import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ombre_task/screens/onboarding_screens/bloc/login_bloc.dart';

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({super.key});

  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is UserLoggedIn) {
          Navigator.pushNamedAndRemoveUntil(
              context, '/videoScreen', (route) => false);
        }
      },
      child: OutlinedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(width * 0.05),
            ),
          ),
        ),
        onPressed: () async {
          BlocProvider.of<LoginBloc>(context).add(SignINButtonClicked());
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              width * 0.05, height * 0.01, width * 0.05, height * 0.01),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
