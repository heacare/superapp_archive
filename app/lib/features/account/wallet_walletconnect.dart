import 'dart:convert' show jsonEncode, jsonDecode;
import 'dart:math' show Random;
import 'dart:typed_data' show Uint8List;

import 'package:convert/convert.dart' show hex;
import 'package:json_annotation/json_annotation.dart'
    show JsonSerializable, JsonKey;
import 'package:uuid/uuid.dart' show Uuid;
import 'package:wallet_connect/models/jsonrpc/json_rpc_error.dart';
import 'package:wallet_connect/models/jsonrpc/json_rpc_error_response.dart';
import 'package:wallet_connect/models/jsonrpc/json_rpc_request.dart';
import 'package:wallet_connect/models/jsonrpc/json_rpc_response.dart';
import 'package:wallet_connect/models/message_type.dart';
import 'package:wallet_connect/models/session/wc_approve_session_response.dart';
import 'package:wallet_connect/models/session/wc_session.dart';
import 'package:wallet_connect/models/session/wc_session_request.dart';
import 'package:wallet_connect/models/session/wc_session_update.dart';
import 'package:wallet_connect/models/wc_encryption_payload.dart';
import 'package:wallet_connect/models/wc_method.dart';
import 'package:wallet_connect/models/wc_peer_meta.dart';
import 'package:wallet_connect/models/wc_socket_message.dart';
// TODO(serverwentdown): Re-implement wc_cipher using `cryptography`
import 'package:wallet_connect/wc_cipher.dart';
import 'package:web_socket_channel/web_socket_channel.dart'
    show WebSocketChannel, WebSocketChannelException;

import '../../system/log.dart';
import 'wallet.dart' show Wallet;

part 'wallet_walletconnect.g.dart';

// TODO(serverwentdown): Replace asserts with exceptions

// Utilities
Random _random = Random.secure();
const Uuid _uuid = Uuid();

// WalletConnect client details
final Uri _bridge = Uri.parse('https://bridge.walletconnect.org');
final WCPeerMeta _clientMeta = WCPeerMeta(
  name: 'Happily Ever After',
  url: 'https://hea.care',
  description: 'Test integration with WalletConnect',
  icons: ['https://hea.care/images/logo.png'],
);
// TODO(serverwentdown): Does this ensure the user is using the Optimism chain?
const int _chainId = 10;

/// Generate a random key
Uint8List _generateKey(int length) {
  Uint8List bytes = Uint8List(length);
  for (var i = 0; i < bytes.length; i++) {
    bytes[i] = _random.nextInt(256);
  }
  return bytes;
}

/// Generate a unique integer id
int _generateId() => DateTime.now().millisecondsSinceEpoch;

/// Implementation of a Wallet that communicates with an external wallet using
/// WalletConnect
@JsonSerializable()
class WalletConnectWallet extends Wallet {
  WalletConnectWallet({required this.session, required this.clientId});

  factory WalletConnectWallet.fromJson(Map<String, dynamic> json) =>
      _$WalletConnectWalletFromJson(json);
  factory WalletConnectWallet.createSession() => WalletConnectWallet(
        session: _createSession(),
        clientId: _uuid.v4(),
      );

  final WCSession session;
  final String clientId;

  Map<String, dynamic> toJson() => _$WalletConnectWalletToJson(this);

  /// Lazily initialised WalletConnect client
  WalletConnect? _client;

  @override
  Future<void> start() async {
    _client = WalletConnect(
      session: session,
      clientId: clientId,
      onConnect: _onConnect,
      onConnectError: _onConnectError,
      onSessionUpdate: _onSessionUpdate,
      onDisconnect: _onDisconnect,
    );
  }

  void _onConnect(WCApproveSessionResponse payload) {
    account = payload.accounts[0];
    notifyListeners();
  }

  void _onConnectError(JsonRpcError error) {
    connectError = error.message;
    notifyListeners();
  }

  void _onSessionUpdate(WCSessionUpdate payload) {
    account = payload.accounts?[0];
    notifyListeners();
  }

  void _onDisconnect() {
    account = null;
    notifyListeners();
  }

  @override
  @JsonKey(ignore: true)
  String? account;

  @override
  Future<void> connect() async {
    await _client!.createSession();
    connectReady = true;
    notifyListeners();
  }

  @override
  Future<void> disconnect() async {
    await _client!.killSession();
    account = null;
    notifyListeners();
  }

  @JsonKey(ignore: true)
  bool connectReady = false;

  @JsonKey(ignore: true)
  String? connectError;

  String get walletConnectUri => session.toUri();

  @override
  void dispose() {
    super.dispose();
    _client?.dispose();
  }
}

/// WalletConnect client. Re-implements most of the client aspects of
/// `wallet_connect` but with internal APIs replicating the reference
/// Client API v1.0, as per the [official API reference](https://docs.walletconnect.com/client-api)
/// and the [reference TypeScript implementation](https://github.com/WalletConnect/walletconnect-monorepo/blob/v1.0/packages/clients/core/src/index.ts)
class WalletConnect {
  WalletConnect({
    required this.session,
    required this.clientId,
    required this.onConnect,
    required this.onConnectError,
    required this.onSessionUpdate,
    required this.onDisconnect,
  }) {
    _ensureConnected();
  }

  final WCSession session;
  final String clientId;

  /// Handles successful session creation
  final void Function(WCApproveSessionResponse payload) onConnect;

  /// Handles failed session creation
  final void Function(JsonRpcError error) onConnectError;

  /// Handles session updates
  final void Function(WCSessionUpdate payload) onSessionUpdate;

  /// Handles session disconnects
  final void Function() onDisconnect;

  /// Underlying WebSocket channel. Exists only when a connection is
  /// established and active, null when the connection is closed
  WebSocketChannel? _channel;
  bool get _channelConnected => _channel != null;

  /// Ensure a connection is established to the bridge to begin communicating.
  /// Throws a WalletConnectException when the connection fails
  void _ensureConnected() {
    if (_channelConnected) {
      return;
    }

    try {
      _channel = WebSocketChannel.connect(_bridge.replace(scheme: 'wss'));
    } on WebSocketChannelException catch (e) {
      throw WalletConnectException('Failed to connect to bridge', e);
    }
    _channel!.stream.listen(
      _handleStream,
      onError: _handleStreamError,
      onDone: _handleStreamDone,
    );
    logD('Bridge: connected');
    _subscribe(clientId);
  }

  /// Handles all incoming messages
  Future<void> _handleStream(dynamic event) async {
    if (event is! String) {
      throw Exception(
        'Bridge: invalid message type received: ${event.runtimeType}',
      );
    }

    // Parse message
    WCSocketMessage message = _parseMessage(event);
    if (message.topic != clientId && message.topic != session.topic) {
      logW('Bridge: ignoring message for unknown topic ${message.topic}');
      return;
    }
    // All events should be encrypted events
    WCEncryptionPayload encryptedPayload =
        _parseEncryptedPayload(message.payload);
    // Decrypt the payload
    String decryptedPayload =
        await WCCipher.decrypt(encryptedPayload, session.key);
    Map<String, dynamic> payload = jsonDecode(decryptedPayload);
    logD('Bridge: receive $payload');

    if (_isJsonRpcRequest(payload)) {
      JsonRpcRequest request = JsonRpcRequest.fromJson(payload);
      switch (request.method) {
        case WCMethod.SESSION_UPDATE:
          _handleSessionUpdate(request.params!.first);
          break;
        default:
          throw Exception('Bridge: unhandled request $request');
      }
    } else if (_isJsonRpcResponse(payload)) {
      JsonRpcResponse response = JsonRpcResponse.fromJson(payload);
      _handleResponse(response);
    } else if (_isJsonRpcErrorResponse(payload)) {
      JsonRpcErrorResponse response = JsonRpcErrorResponse.fromJson(payload);
      _handleErrorResponse(response);
    } else {
      throw Exception('Bridge: unhandled message $payload');
    }
  }

  /// Handles stream errors
  void _handleStreamError(dynamic error) {
    logD('Bridge: ${_channel?.closeCode} ${_channel?.closeReason} $error');
    assert(_channel!.closeCode != null);
    _channel = null;
    // TODO(serverwentdown): How should the client handle closed connections? Is it really necessary to keep a persistent connection using retry logic?
  }

  /// Handles stream completion
  void _handleStreamDone() {
    logD('Bridge: ${_channel?.closeCode} ${_channel?.closeReason} done');
    assert(_channel!.closeCode != null);
    _channel = null;
    // TODO(serverwentdown): See _handleStreamError
  }

  /// Handle wc_sessionUpdate message
  void _handleSessionUpdate(dynamic params) {
    WCSessionUpdate sessionUpdate = WCSessionUpdate.fromJson(params);
    if (sessionUpdate.approved) {
      onSessionUpdate(sessionUpdate);
    } else {
      onDisconnect();
    }
  }

  /// Handle response messages
  void _handleResponse(JsonRpcResponse response) {
    // Handle handshake responses
    if (response.id == _handshakeId) {
      var approval = WCApproveSessionResponse.fromJson(response.result);
      onConnect(approval);
    } else {
      throw Exception('Bridge: unhandled response $response');
    }
  }

  /// Handle error response messages
  void _handleErrorResponse(JsonRpcErrorResponse response) {
    if (response.id == _handshakeId) {
      onConnectError(response.error);
    } else {
      throw Exception('Bridge: unhandled error response $response');
    }
  }

  /// Sends an arbitrary payload in a topic over the socket
  void _send(String payload, String topic) {
    WCSocketMessage message = WCSocketMessage(
      topic: topic,
      type: MessageType.PUB,
      payload: payload,
      // TODO(serverwentdown): Add `silent` field
    );
    String encoded = jsonEncode(message.toJson());
    logD('Bridge: send $encoded');
    _channel!.sink.add(encoded);
  }

  /// Subscribes to payloads in a topic over the socket
  void _subscribe(String topic) {
    WCSocketMessage message = WCSocketMessage(
      topic: topic,
      type: MessageType.SUB,
      payload: '',
    );
    String encoded = jsonEncode(message.toJson());
    logD('Bridge: send $encoded');
    _channel!.sink.add(encoded);
  }

  /// Sends a [JsonRpcRequest] over the socket to the peer
  Future<void> _sendRequest(
    JsonRpcRequest request, {
    required String topic,
  }) async {
    String payload = jsonEncode(request.toJson());
    WCEncryptionPayload encryptedPayload =
        await WCCipher.encrypt(payload, session.key);
    _send(jsonEncode(encryptedPayload), topic);
  }

  /// Handshake request ID
  int _handshakeId = 0;

  /// Creates a new WalletConnect session
  Future<void> createSession() async {
    _ensureConnected();

    // In the TypeScript implementation, a session is created here. However,
    // our sessions are created during instantiation and saved to database

    // Instead, we simply send a handshake (wc_sessionRequest)

    _handshakeId = _generateId();
    JsonRpcRequest request = JsonRpcRequest(
      id: _handshakeId,
      method: WCMethod.SESSION_REQUEST,
      params: [
        WCSessionRequest(
          peerId: clientId,
          peerMeta: _clientMeta,
          chainId: _chainId,
        ).toJson()
      ],
    );
    await _sendRequest(request, topic: session.topic);
  }

  /// Disconnect request ID
  int _disconnectId = 0;

  /// Kills the WalletConnect session
  Future<void> killSession() async {
    _ensureConnected();

    _disconnectId = _generateId();
    JsonRpcRequest request = JsonRpcRequest(
      id: _disconnectId,
      method: WCMethod.SESSION_UPDATE,
      params: [
        WCSessionUpdate(
          approved: false,
        ).toJson(),
      ],
    );
    await _sendRequest(request, topic: session.topic);
  }

  void dispose() {
    _channel?.sink.close();
  }
}

/// Exceptions thrown from the WalletConnect client
class WalletConnectException implements Exception {
  WalletConnectException([this.message, this.inner]);

  final String? message;
  final Object? inner;

  @override
  String toString() {
    String s = 'WalletConnectException';
    if (message != null) {
      s += ': $message';
    }
    if (inner != null) {
      s += ': $inner';
    }
    return s;
  }
}

bool _isJsonRpcRequest(Map<String, dynamic> payload) =>
    payload.containsKey('method');

bool _isJsonRpcResponse(Map<String, dynamic> payload) =>
    payload.containsKey('result');

bool _isJsonRpcErrorResponse(Map<String, dynamic> payload) =>
    payload.containsKey('error');

/// Parses incoming WebSocket messages
WCSocketMessage _parseMessage(String event) {
  try {
    return WCSocketMessage.fromJson(jsonDecode(event));
    // ignore: avoid_catching_errors
  } on FormatException catch (e) {
    // Handle most JSON parser errors. Data sent can be manipulated
    logW('Bridge: ignoring invalid message received: $e');
    // For now, re-throw to submit error to crashlogger just in case
    rethrow;
    // ignore: avoid_catching_errors
  } on TypeError catch (e) {
    // Handle most JSON conversion errors. Data sent can be manipulated
    logW('Bridge: ignoring invalid message received: $e');
    // For now, re-throw to submit error to crashlogger just in case
    rethrow;
  }
}

/// Decrypts the payload of incoming WebSocket messages
WCEncryptionPayload _parseEncryptedPayload(String payload) {
  try {
    return WCEncryptionPayload.fromJson(jsonDecode(payload));
    // ignore: avoid_catching_errors
  } on FormatException catch (e) {
    // Handle most JSON parser errors. Data sent can be manipulated
    logW('Bridge: ignoring invalid message received: $e');
    // For now, re-throw to submit error to crashlogger just in case
    rethrow;
    // ignore: avoid_catching_errors
  } on TypeError catch (e) {
    // Handle most JSON conversion errors. Data sent can be manipulated
    logW('Bridge: ignoring invalid message received: $e');
    // For now, re-throw to submit error to crashlogger just in case
    rethrow;
  }
}

/// Creates a new WCSession object from random values
WCSession _createSession() {
  Uint8List key = _generateKey(32);
  return WCSession(
    topic: _uuid.v4(),
    version: '1',
    bridge: _bridge.toString(),
    key: hex.encoder.convert(key),
  );
}
