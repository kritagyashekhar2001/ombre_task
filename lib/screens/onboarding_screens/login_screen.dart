import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ombre_task/screens/onboarding_screens/components/google_signin_button.dart';
import '../../resources/resources.dart' as resources;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: resources.blackColor,
      body: SizedBox(
        width: width,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          SizedBox(
            height: height * 0.1,
          ),
          Lottie.asset("assets/lottie_json/login_screen.json",
              repeat: true, height: height * 0.35),
          const Spacer(),
          const GoogleSignInButton(),
          SizedBox(
            height: height * 0.1,
          )
        ]),
      ),
    );
  }
}
