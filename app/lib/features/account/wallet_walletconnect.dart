import 'dart:convert' show jsonEncode, jsonDecode;
import 'dart:math' show Random;
import 'dart:typed_data' show Uint8List;

import 'package:convert/convert.dart';
import 'package:uuid/uuid.dart';
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
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../system/log.dart';
import 'wallet.dart';

Random random = Random.secure();
const Uuid uuid = Uuid();

// TODO(serverwentdown): Replace asserts with exceptions

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
    bytes[i] = random.nextInt(256);
  }
  return bytes;
}

/// Generate a unique integer id
int _generateId() => DateTime.now().millisecondsSinceEpoch;

/// Implementation of a Wallet that communicates with an external wallet using
/// WalletConnect. Re-implements most of the client aspects of `wallet_connect`
/// but with internal APIs replicating the reference Client API v1.0, as per
/// the [official API reference](https://docs.walletconnect.com/client-api)
class WalletConnectWallet extends Wallet with WalletConnect {
  @override
  void _onConnect(WCApproveSessionResponse payload) {
    account = payload.accounts[0];
    notifyListeners();
  }

  @override
  void _onSessionUpdate(WCSessionUpdate payload) {
    account = payload.accounts?[0];
    notifyListeners();
  }

  @override
  void _onDisconnect() {
    account = null;
    notifyListeners();
  }

  @override
  Future<void> connect() async {
    _ensureConnected();
    await _createSession();
    logD('Bridge: session created');
    notifyListeners();
  }

  @override
  String? account;

  @override
  String? get walletConnectUri => _session?.toUri();
}

/// WalletConnect client. Re-implements most of the client aspects of
/// `wallet_connect` but with internal APIs replicating the reference
/// Client API v1.0, as per the [official API reference](https://docs.walletconnect.com/client-api)
abstract class WalletConnect {
  /// Underlying WebSocket channel. Exists only when a connection is
  /// established and active, null when the connection is closed
  WebSocketChannel? _channel;
  bool get _connected => _channel != null;

  // Handshake request ID
  int _handshakeId = 0;

  // The following session information needs to be restored on restart

  /// Current session. There can only be one session per instance
  WCSession? _session;

  /// Current session's clientId
  String? _clientId;

  // End session information

  /// Ensure a connection is established to the bridge to begin communicating.
  /// Throws a WalletConnectException when the connection fails
  void _ensureConnected() {
    if (_connected) {
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
    //_clientId = uuid.v4();
    _clientId = 'test';
    _subscribe(_clientId!);
    logD('Bridge: connected');
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
    if (message.topic != _clientId && message.topic != _session?.topic) {
      logW('Bridge: ignoring message for unknown topic ${message.topic}');
      return;
    }
    // All events should be encrypted events
    WCEncryptionPayload encryptedPayload =
        _parseEncryptedPayload(message.payload);
    // Decrypt the payload
    String decryptedPayload =
        await WCCipher.decrypt(encryptedPayload, _session!.key);
    Map<String, dynamic> payload = jsonDecode(decryptedPayload);

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
    assert(_channel!.closeCode != null);
    logD('Bridge: ${_channel?.closeCode} ${_channel?.closeReason} $error');
    _channel = null;
  }

  /// Handles stream completion
  void _handleStreamDone() {
    assert(_channel!.closeCode != null);
    logD('Bridge: ${_channel?.closeCode} ${_channel?.closeReason} done');
    _channel = null;
  }

  /// Handle wc_sessionUpdate message
  void _handleSessionUpdate(dynamic params) {
    WCSessionUpdate sessionUpdate = WCSessionUpdate.fromJson(params);
    if (sessionUpdate.approved) {
      _onSessionUpdate(sessionUpdate);
    } else {
      _onDisconnect();
    }
  }

  /// Handle response messages
  void _handleResponse(JsonRpcResponse response) {
    // Handle handshake responses
    if (response.id == _handshakeId) {
      var approval = WCApproveSessionResponse.fromJson(response.result);
      _onConnect(approval);
    } else {
      throw Exception('Bridge: unhandled response $response');
    }
  }

  /// Handle error response messages
  void _handleErrorResponse(JsonRpcErrorResponse response) {
    throw Exception('Bridge: unhandled error response $response');
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
        await WCCipher.encrypt(payload, _session!.key);
    _send(jsonEncode(encryptedPayload), topic);
  }

  /// Creates a new WalletConnect session
  Future<void> _createSession() async {
    assert(_connected);

    Uint8List key = _generateKey(32);

    _session = WCSession(
      topic: uuid.v4(),
      version: '1',
      bridge: _bridge.toString(),
      key: hex.encoder.convert(key),
    );

    _handshakeId = _generateId();
    JsonRpcRequest request = JsonRpcRequest(
      id: _handshakeId,
      method: WCMethod.SESSION_REQUEST,
      params: [
        WCSessionRequest(
          peerId: _clientId!,
          peerMeta: _clientMeta,
          chainId: _chainId,
        ).toJson()
      ],
    );

    logD('$_session');
    await _sendRequest(request, topic: _session!.topic);
    _subscribe(_clientId!);
  }

  /// Handles successful session creation
  void _onConnect(WCApproveSessionResponse payload);

  /// Handles session updates
  void _onSessionUpdate(WCSessionUpdate payload);

  /// Handles session disconnects
  void _onDisconnect();
}

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
  } on FormatException catch (e) {
    // Handle most JSON parser errors. Data sent can be manipulated
    logW('Bridge: ignoring invalid message received: $e');
    // For now, re-throw to submit error to crashlogger just in case
    rethrow;
  } on TypeError catch (e) {
    // ignore: avoid_catching_errors
    // ignore: avoid_catching_errors
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
  } on FormatException catch (e) {
    // Handle most JSON parser errors. Data sent can be manipulated
    logW('Bridge: ignoring invalid message received: $e');
    // For now, re-throw to submit error to crashlogger just in case
    rethrow;
  } on TypeError catch (e) {
    // ignore: avoid_catching_errors
    // ignore: avoid_catching_errors
    // Handle most JSON conversion errors. Data sent can be manipulated
    logW('Bridge: ignoring invalid message received: $e');
    // For now, re-throw to submit error to crashlogger just in case
    rethrow;
  }
}
