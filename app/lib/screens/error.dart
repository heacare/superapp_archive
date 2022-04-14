import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:hea/main.dart';
import 'package:hea/screens/login.dart';
import 'package:hea/widgets/gradient_button.dart';
import 'package:hea/services/auth_service.dart';
import 'package:hea/services/service_locator.dart';

const svgAssetName = "assets/svg/error.svg";

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  Future logout(BuildContext context) async {
    await serviceLocator<AuthService>().logout();

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) {
      return LoginScreen();
    }), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 48.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: SvgPicture.asset(svgAssetName)),
                    Expanded(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text("Oops!",
                              style: Theme.of(context).textTheme.headline1),
                          Text("Something broke along the way",
                              style: Theme.of(context).textTheme.headline2)
                        ])),
                    /*
                    GradientButton(
                        text: "Logout", onPressed: () => logout(context)),
					*/
                    GradientButton(
                        text: "Restart",
                        onPressed: () => App.of(context).restart()),
                  ],
                ))));
  }
}
