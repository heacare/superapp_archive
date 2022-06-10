import 'dart:convert' show jsonEncode;
import 'dart:math' show Random;
import 'dart:typed_data' show Uint8List;

import 'package:convert/convert.dart';
import 'package:uuid/uuid.dart';
import 'package:wallet_connect/models/jsonrpc/json_rpc_request.dart';
import 'package:wallet_connect/models/message_type.dart';
import 'package:wallet_connect/models/session/wc_session.dart';
import 'package:wallet_connect/models/session/wc_session_request.dart';
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
class WalletConnectWallet extends Wallet {
  /// Underlying WebSocket channel. Exists only when a connection is
  /// established and active, null when the connection is closed
  WebSocketChannel? _channel;
  bool get _connected => _channel != null;

  // The following session information needs to be restored on restart

  /// The current session. There can only be one session per instance
  WCSession? _session;

  /// The current session's clientId
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
    _clientId = uuid.v4();
    _subscribe(_clientId!);
    logD('Bridge: connected');
  }

  /// Handles all incoming messages
  void _handleStream(dynamic event) {
    logD('Bridge: receive $event');
    if (event is! String) {
      return;
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

  /// Encrypts a [JsonRpcRequest] into a payload that can be sent over the
  /// socket
  Future<WCEncryptionPayload> _encrypt(JsonRpcRequest request) async {
    String contentString = jsonEncode(request.toJson());
    logD(contentString);
    return WCCipher.encrypt(contentString, _session!.key);
  }

  /// Sends a [JsonRpcRequest] over the socket to the peer
  Future<void> _sendRequest(
    JsonRpcRequest request, {
    required String topic,
  }) async {
    String payload = jsonEncode(await _encrypt(request));
    _send(payload, topic);
  }

  Future<void> _createSession() async {
    assert(_connected);

    Uint8List key = _generateKey(32);

    _session = WCSession(
      topic: uuid.v4(),
      version: '1',
      bridge: _bridge.toString(),
      key: hex.encoder.convert(key),
    );

    JsonRpcRequest request = JsonRpcRequest(
      id: _generateId(),
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

  @override
  Future<void> connect() async {
    _ensureConnected();
    await _createSession();
    logD('Bridge: session created');
    notifyListeners();
  }

  @override
  String? get walletConnectUri => _session?.toUri();
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
