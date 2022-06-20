// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_walletconnect.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletConnectWallet _$WalletConnectWalletFromJson(Map<String, dynamic> json) =>
    WalletConnectWallet(
      session: WCSession.fromJson(json['session'] as Map<String, dynamic>),
      clientId: json['clientId'] as String,
    )..account = json['account'] as String?;

Map<String, dynamic> _$WalletConnectWalletToJson(
  WalletConnectWallet instance,
) =>
    <String, dynamic>{
      'session': instance.session,
      'clientId': instance.clientId,
      'account': instance.account,
    };
