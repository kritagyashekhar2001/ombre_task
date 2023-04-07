import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ombre_task/screens/onboarding_screens/bloc/login_bloc.dart';
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
      body: Container(
        width: width,
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
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
