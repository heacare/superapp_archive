import 'dart:async' show unawaited;

import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' show launchUrl, LaunchMode;

import '../../system/log.dart';
import '../../widgets/button.dart' show buttonStylePrimaryLarge;
import '../../widgets/qr_code.dart' show QrCodeDialog;
import '../../widgets/tabbar.dart' show tabBarIndicatorInverse;
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
            TabBar(
              indicator: tabBarIndicatorInverse(context),
              tabs: const [
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
            TabBar(
              indicator: tabBarIndicatorInverse(context),
              tabs: const [
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
            return SizedBox(
              width: 360,
              height: 420,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(16),
                child: Text(
                  'WalletConnect failed: ${wallet.connectError}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          Widget? tabs;
          if (defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.iOS) {
            tabs = _buildTabs(context, wallet);
          } else {
            tabs = _buildTabsDesktop(context, wallet);
          }
          return SizedBox(
            width: 360,
            height: 420,
            child: wallet.connectReady
                ? tabs
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          );
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
    if (defaultTargetPlatform == TargetPlatform.android) {
      return Center(
        child: ElevatedButton(
          style: buttonStylePrimaryLarge(context),
          child: const Text('Connect'),
          onPressed: () {
            Uri launchUri = Uri.parse(uri);
            logD('WalletConnect: launching $launchUri');
            launchUrl(launchUri);
          },
        ),
      );
    }

    return FutureBuilder<List<RegistryWallet>>(
      future: registryGetWallets(desktop: desktop),
      builder: (context, snapshot) => ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: snapshot.data?.length ?? 0,
        itemBuilder: (context, index) {
          var item = snapshot.data![index];
          return ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: _buildImage(item.imageUrl),
            title: Text(item.name),
            onTap: () {
              String? launchString;
              RegistryWalletLinks links =
                  desktop ? item.desktop! : item.mobile!;
              if (links.validUniversal) {
                launchString = '${links.universal}/wc?uri=$uri';
              } else if (links.validNative) {
                launchString = '${links.native}//wc?uri=$uri';
              }
              Uri launchUri = Uri.parse(launchString!);
              logD('WalletConnect: launching $launchUri');
              launchUrl(launchUri, mode: LaunchMode.externalApplication);
            },
          );
        },
      ),
    );
  }

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
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('WalletConnect'),
      contentPadding: const EdgeInsets.only(top: 20),
      content: WalletConnect(wallet: wallet),
    ),
  );
}
