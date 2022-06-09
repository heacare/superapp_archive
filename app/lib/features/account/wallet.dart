import 'dart:convert' show jsonEncode, jsonDecode;
import 'package:flutter/foundation.dart' show ChangeNotifier;

import 'package:uuid/uuid.dart';
import 'package:wallet_connect/models/jsonrpc/json_rpc_request.dart';
import 'package:wallet_connect/models/message_type.dart';
import 'package:wallet_connect/models/session/wc_session.dart';
import 'package:wallet_connect/models/session/wc_session_request.dart';
import 'package:wallet_connect/models/wc_encryption_payload.dart';
import 'package:wallet_connect/models/wc_method.dart';
import 'package:wallet_connect/models/wc_peer_meta.dart';
import 'package:wallet_connect/models/wc_socket_message.dart';
import 'package:wallet_connect/wc_cipher.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../system/log.dart';

const uuid = Uuid();

// TODO(serverwentdown): Figure out how to replace the wallet implementation on-the-fly
abstract class Wallet extends ChangeNotifier {
  Future<void> connect();

  String? get walletConnectUri => null;
}

// TODO(serverwentdown): Replace asserts with exceptions
class WalletConnectWallet extends Wallet {
  WalletConnectWallet._();

  static Future<Wallet> load() async => WalletConnectWallet._();

  static final Uri _bridge = Uri.parse('https://bridge.walletconnect.org');
  static final WCPeerMeta _clientMeta = WCPeerMeta(
    name: 'Happily Ever After',
    url: 'https://hea.care',
    description: 'Test integration with WalletConnect',
    icons: ['https://hea.care/images/logo.png'],
  );
  static const int _chainId = 0;

  WebSocketChannel? _channel;
  // TODO(serverwentdown): Use raw bytes instead of hex keys
  WCSession? _session;
  String? _clientId;
  int? _handshakeId;
  String? _handshakeTopic;

  void _ensureConnected() {
	if (_channel != null) {
		return;
	}

    _channel = WebSocketChannel.connect(_bridge.replace(scheme: 'wss'));
    _channel!.stream.listen(
      _handleStream,
      onError: _handleStreamError,
      onDone: _handleStreamDone,
    );
    logD('Bridge: connected');
  }

  bool get _connected => _channel != null;

  void _handleStream(dynamic event) {
    logD('Bridge: receive $event');
	if (!(event is String)) {
		return;
	}
  }

  void _handleStreamError(dynamic error) {
    assert(_channel!.closeCode != null);
    logD('Bridge: ${_channel?.closeCode} ${_channel?.closeReason} $error');
    _channel = null;
  }

  void _handleStreamDone() {
    assert(_channel!.closeCode != null);
    logD('Bridge: ${_channel?.closeCode} ${_channel?.closeReason} done');
    _channel = null;
  }

  void _send(String payload, String topic) {
    WCSocketMessage message = WCSocketMessage(
      topic: topic,
      type: MessageType.PUB,
      payload: payload,
    );
    String encoded = jsonEncode(message.toJson());
    logD('Bridge: send $encoded');
    _channel!.sink.add(encoded);
  }

  Future<void> _subscribe(String topic) async {
    WCSocketMessage message = WCSocketMessage(
      topic: topic,
      type: MessageType.SUB,
      payload: '',
    );
    String encoded = jsonEncode(message.toJson());
    logD('Bridge: send $encoded');
    _channel!.sink.add(encoded);
  }

  Future<WCEncryptionPayload> _encrypt(JsonRpcRequest request) async {
    String contentString = jsonEncode(request.toJson());
    logD(contentString);
    return await WCCipher.encrypt(contentString, _session!.key);
  }

  Future<void> _sendRequest(JsonRpcRequest request,
      {required String topic,}) async {
    String payload = jsonEncode(await _encrypt(request));
    _send(payload, topic);
  }

  int _idTime() => DateTime.now().millisecondsSinceEpoch;

  Future<void> _createSession() async {
    assert(_connected);

    String key =
        '37e67e3b2cf4c6a292d6d6ec7fbeaa7fe4bab940e1960961338257d6fce68aac';
    _clientId = uuid.v4();

    WCSessionRequest param = WCSessionRequest(
      peerId: _clientId!,
      peerMeta: _clientMeta,
      chainId: _chainId,
    );

    JsonRpcRequest request = JsonRpcRequest(
      id: _idTime(),
      method: WCMethod.SESSION_REQUEST,
      params: [param.toJson()],
    );

    _handshakeId = request.id;
    _handshakeTopic = uuid.v4();

    _session = WCSession(
      topic: _handshakeTopic!,
      version: '1',
      bridge: _bridge.toString(),
      key: key,
    );

    logD('$_session');
    await _sendRequest(request, topic: _handshakeTopic!);
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
