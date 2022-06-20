// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_walletconnect_registry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegistryGetWalletsResponse _$RegistryGetWalletsResponseFromJson(
        Map<String, dynamic> json) =>
    RegistryGetWalletsResponse(
      listings: (json['listings'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, RegistryWallet.fromJson(e as Map<String, dynamic>)),
      ),
      count: json['count'] as int,
    );

Map<String, dynamic> _$RegistryGetWalletsResponseToJson(
        RegistryGetWalletsResponse instance) =>
    <String, dynamic>{
      'listings': instance.listings,
      'count': instance.count,
    };

RegistryWallet _$RegistryWalletFromJson(Map<String, dynamic> json) =>
    RegistryWallet(
      name: json['name'] as String,
      description: json['description'] as String?,
      imageUrl: json['image_url'] == null
          ? null
          : RegistryWalletImageUrl.fromJson(
              json['image_url'] as Map<String, dynamic>),
      mobile: json['mobile'] == null
          ? null
          : RegistryWalletLinks.fromJson(
              json['mobile'] as Map<String, dynamic>),
      desktop: json['desktop'] == null
          ? null
          : RegistryWalletLinks.fromJson(
              json['desktop'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RegistryWalletToJson(RegistryWallet instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'image_url': instance.imageUrl,
      'mobile': instance.mobile,
      'desktop': instance.desktop,
    };

RegistryWalletImageUrl _$RegistryWalletImageUrlFromJson(
        Map<String, dynamic> json) =>
    RegistryWalletImageUrl(
      sm: json['sm'] as String?,
      md: json['md'] as String?,
      lg: json['lg'] as String?,
    );

Map<String, dynamic> _$RegistryWalletImageUrlToJson(
        RegistryWalletImageUrl instance) =>
    <String, dynamic>{
      'sm': instance.sm,
      'md': instance.md,
      'lg': instance.lg,
    };

RegistryWalletLinks _$RegistryWalletLinksFromJson(Map<String, dynamic> json) =>
    RegistryWalletLinks(
      native: json['native'] as String?,
      universal: json['universal'] as String?,
    );

Map<String, dynamic> _$RegistryWalletLinksToJson(
        RegistryWalletLinks instance) =>
    <String, dynamic>{
      'native': instance.native,
      'universal': instance.universal,
    };
