import 'dart:async' show unawaited;

import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart' show SvgPicture;

import '../../navigator.dart' show ForceRTL;
import '../../system/log.dart';
import '../../system/url_launcher.dart' show launchUrl, LaunchMode;
import '../../widgets/button.dart' show buttonStylePrimaryLarge;
import '../../widgets/qr_code.dart' show QrCodeDialog;
import 'wallet.dart' show Wallet;
import 'wallet_walletconnect.dart' show WalletConnectWallet;
import 'wallet_walletconnect_registry.dart'
    show
        registryGetWallets,
        RegistryWallet,
        RegistryWalletLinks,
        RegistryWalletImageUrl;

// TODO(serverwentdown): Use same dialog for prompts to sign transactions

class WalletConnect extends StatelessWidget {
  const WalletConnect({super.key, required this.wallet});

  final WalletConnectWallet wallet;

  Widget _buildTabsDesktop(BuildContext context, WalletConnectWallet wallet) =>
      DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Mobile'),
                Tab(text: 'QR Code'),
                Tab(text: 'Desktop'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildTabMobile(context, wallet),
                  _buildTabQR(context, wallet),
                  _buildTabMobile(context, wallet, desktop: true),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _buildTabs(BuildContext context, WalletConnectWallet wallet) =>
      DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Mobile'),
                Tab(text: 'QR Code'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildTabMobile(context, wallet),
                  _buildTabQR(context, wallet),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _buildTabMobile(
    BuildContext context,
    WalletConnectWallet wallet, {
    bool desktop = false,
  }) =>
      WalletConnectWalletPicker(
        uri: wallet.walletConnectUri,
        desktop: desktop,
      );

  Widget _buildTabQR(BuildContext context, WalletConnectWallet wallet) =>
      Padding(
        padding: const EdgeInsets.all(16),
        child: QrCodeDialog(
          data: wallet.walletConnectUri,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8),
            child: const Text(
              'Scan QR code with a WalletConnect-compatible wallet',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: wallet,
        builder: (context, child) {
          if (wallet.connected) {
            Navigator.of(context).pop(wallet);
          }
          if (wallet.connectError != null) {
            return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16),
              child: Text(
                'WalletConnect failed: ${wallet.connectError}',
                textAlign: TextAlign.center,
              ),
            );
          }
          if (!wallet.connectReady) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          switch (defaultTargetPlatform) {
            case TargetPlatform.android:
            case TargetPlatform.iOS:
              return _buildTabs(context, wallet);
            default:
              return _buildTabsDesktop(context, wallet);
          }
        },
      );
}

class WalletConnectWalletPicker extends StatelessWidget {
  const WalletConnectWalletPicker({
    super.key,
    required this.uri,
    required this.desktop,
  });

  final String uri;
  final bool desktop;

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return Center(
          child: ElevatedButton(
            style: buttonStylePrimaryLarge(context),
            child: const Text('Connect'),
            onPressed: () {
              Uri launchUri = Uri.parse(uri);
              logD('WalletConnect: launching $launchUri');
              launchUrl(
                launchUri,
                mode: LaunchMode.externalNonBrowserApplication,
              );
            },
          ),
        );
      default:
        return FutureBuilder<List<RegistryWallet>>(
          future: registryGetWallets(desktop: desktop),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Unable to fetch list of wallets from the WalletConnect registry. Ensure you are connected to the internet. ${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              );
            }

            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) => WalletConnectWalletPickerItem(
                item: snapshot.data![index],
                uri: uri,
                desktop: desktop,
              ),
            );
          },
        );
    }
  }
}

class WalletConnectWalletPickerItem extends StatelessWidget {
  const WalletConnectWalletPickerItem({
    super.key,
    required this.item,
    required this.uri,
    required this.desktop,
  });

  final RegistryWallet item;
  final String uri;
  final bool desktop;

  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: _buildImage(item.imageUrl),
        title: Text(item.name),
        onTap: () {
          String? launchString;
          RegistryWalletLinks links = desktop ? item.desktop! : item.mobile!;
          if (links.validUniversal) {
            launchString = '${links.universal}/wc?uri=$uri';
          } else if (links.validNative) {
            launchString = '${links.native}//wc?uri=$uri';
          }
          Uri launchUri = Uri.parse(launchString!);
          logD('WalletConnect: launching $launchUri');
          launchUrl(
            launchUri,
            mode: LaunchMode.externalNonBrowserApplication,
          );
        },
      );

  Widget? _buildImage(RegistryWalletImageUrl? imageUrl) {
    if (imageUrl?.sm == null) {
      return null;
    }
    return Image.network(imageUrl!.sm!, width: 48, height: 48);
  }
}

Future<Wallet?> showWalletConnectDialog(BuildContext context) async {
  var wallet = WalletConnectWallet.createSession();
  unawaited(
    () async {
      await Future.delayed(const Duration(milliseconds: 200));
      await wallet.start();
      await wallet.connect();
    }(),
  );
  // TODO(serverwentdown): Enable state restoration https://api.flutter.dev/flutter/material/showDialog.html#state-restoration-in-dialogs
  return showDialog(
    context: context,
    builder: (context) => ForceRTL(
      AlertDialog(
        title: Center(
          child: SvgPicture.asset(
            'assets/integrations/walletconnect-banner.svg',
            width: 180,
          ),
        ),
        contentPadding: const EdgeInsets.only(top: 20),
        content: SizedBox(
          width: 320,
          height: 420,
          child: WalletConnect(wallet: wallet),
        ),
      ),
    ),
  );
}
