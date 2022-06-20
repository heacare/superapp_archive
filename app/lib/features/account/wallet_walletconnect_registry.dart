import 'dart:convert' show jsonDecode;

import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart'
    show JsonSerializable, JsonKey;

part 'wallet_walletconnect_registry.g.dart';

final Uri _registry =
    Uri.parse('https://registry.walletconnect.com/api/v1/wallets');

/// Get the list of advertised wallets in the public WalletConnect registry
Future<List<RegistryWallet>> registryGetWallets({required bool desktop}) async {
  // TODO(serverwentdown): Cache this list for 7 days
  var response = await http.get(_registry);
  assert(response.headers['content-type'] == 'application/json');
  var data = RegistryGetWalletsResponse.fromJson(jsonDecode(response.body));
  return data.listings.values
      .where(
        (value) =>
            (desktop ? value.desktop?.valid : value.mobile?.valid) ?? false,
      )
      .toList();
}

@JsonSerializable()
class RegistryGetWalletsResponse {
  RegistryGetWalletsResponse({required this.listings, required this.count});

  factory RegistryGetWalletsResponse.fromJson(Map<String, dynamic> json) =>
      _$RegistryGetWalletsResponseFromJson(json);

  final Map<String, RegistryWallet> listings;
  final int count;

  Map<String, dynamic> toJson() => _$RegistryGetWalletsResponseToJson(this);
}

@JsonSerializable()
class RegistryWallet {
  const RegistryWallet({
    required this.name,
    this.description,
    this.imageUrl,
    this.mobile,
    this.desktop,
  });
  //final RegistryWalletLinks? desktop;

  factory RegistryWallet.fromJson(Map<String, dynamic> json) =>
      _$RegistryWalletFromJson(json);

  final String name;
  final String? description;
  @JsonKey(name: 'image_url')
  final RegistryWalletImageUrl? imageUrl;
  final RegistryWalletLinks? mobile;
  final RegistryWalletLinks? desktop;

  Map<String, dynamic> toJson() => _$RegistryWalletToJson(this);
}

@JsonSerializable()
class RegistryWalletImageUrl {
  const RegistryWalletImageUrl({
    required this.sm,
    required this.md,
    required this.lg,
  });

  factory RegistryWalletImageUrl.fromJson(Map<String, dynamic> json) =>
      _$RegistryWalletImageUrlFromJson(json);

  final String? sm;
  final String? md;
  final String? lg;

  Map<String, dynamic> toJson() => _$RegistryWalletImageUrlToJson(this);
}

@JsonSerializable()
class RegistryWalletLinks {
  const RegistryWalletLinks({required this.native, required this.universal});

  factory RegistryWalletLinks.fromJson(Map<String, dynamic> json) =>
      _$RegistryWalletLinksFromJson(json);

  final String? native;
  final String? universal;

  bool get validNative => native != null && native!.isNotEmpty;
  bool get validUniversal => universal != null && universal!.isNotEmpty;
  bool get valid => validNative || validUniversal;

  Map<String, dynamic> toJson() => _$RegistryWalletLinksToJson(this);
}
