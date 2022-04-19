import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:hea/services/auth_service.dart';
import 'package:hea/screens/onboarding.dart';
import 'package:hea/screens/home.dart';
import 'package:hea/services/service_locator.dart';
import 'package:hea/services/api_manager.dart';
import 'package:hea/services/user_service.dart';
import 'package:hea/widgets/navigable_text.dart';
import 'package:hea/widgets/gradient_button.dart';

const svgAssetName = "assets/svg/login.svg";

enum LoginChoice { unselected, login, signUp }

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = serviceLocator<AuthService>();

  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  var _loginChoice = LoginChoice.unselected;

  void login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      await _auth.login(_email.text, _password.text);
      // Get new JWT Token and create user in backend if necessary
      await serviceLocator<ApiManager>().fetchJwtToken();
      // Redirect to correct page
      await navigateSuccess();
    } on AuthServiceException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  void signup() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      await _auth.signup(_email.text, _password.text);
      // Get new JWT Token and create user in backend if necessary
      await serviceLocator<ApiManager>().fetchJwtToken();
      // Redirect to correct page
      await navigateSuccess();
    } on AuthServiceException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future navigateSuccess() async {
    final userOnboarded =
        await serviceLocator<UserService>().isCurrentUserOnboarded();

    if (!userOnboarded) {
      await Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
          (route) => false);
    } else {
      // User already finished onboarding
      await Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false);
    }
  }

  Widget _credsOrText() {
    if (_loginChoice == LoginChoice.unselected) {
      // Show welcome text
      return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  color: Colors.grey[200]),
            )),
            const SizedBox(height: 24.0),
            Padding(
                child: Text("Say hello to longevity!",
                    style: Theme.of(context).textTheme.headline1),
                padding: const EdgeInsets.symmetric(vertical: 16.0)),
            Text(
                "We provide proactive, preventive & personalised healthcare to keep you at the apex of your health.",
                style: Theme.of(context).textTheme.headline2?.copyWith(
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                    color: const Color(0xFF707070))),
            const SizedBox(height: 24.0),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: GradientButton(
                text: "LOGIN",
                onPressed: () =>
                    setState(() => _loginChoice = LoginChoice.login),
              ),
            ),
            SizedBox(
                height: 50.0,
                child: GestureDetector(
                    onTap: () =>
                        setState(() => _loginChoice = LoginChoice.signUp),
                    child: Ink(
                      decoration: const BoxDecoration(
                        color: Color(0xFFF4F4F4),
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      child: Container(
                        constraints: const BoxConstraints(
                            minWidth: 88.0, minHeight: 36.0),
                        alignment: Alignment.center,
                        child: const Text("JOIN US",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                letterSpacing: 1.0,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                                height: 1.5,
                                color: Color(0xFF414141)),
                            textAlign: TextAlign.center),
                      ),
                    ))),
          ]);
    }

    return Form(
        key: _formKey,
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          NavigableText(
            onPressed: () =>
                setState(() => _loginChoice = LoginChoice.unselected),
            text: _loginChoice == LoginChoice.login
                ? "Welcome back to HEA"
                : "Let's make you superhuman",
          ),
          const SizedBox(height: 24.0),
          TextFormField(
            controller: _email,
            decoration: const InputDecoration(labelText: "Email"),
            validator: FormBuilderValidators.email(context),
          ),
          const SizedBox(height: 8.0),
          TextFormField(
              controller: _password,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true),
          const SizedBox(height: 36.0),
          GradientButton(
            text: "LET'S GO",
            onPressed: () {
              _loginChoice == LoginChoice.login ? login() : signup();
            },
          ),
        ]));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precachePicture(
        ExactAssetPicture(SvgPicture.svgStringDecoder, svgAssetName), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Enabling the safe area
      body: SafeArea(
          child: Container(
              padding: const EdgeInsets.all(30.0), child: _credsOrText())),
    );
  }
}
