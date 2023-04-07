import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  late GoogleSignInAccount? usersignin;
  final googleSignIn = GoogleSignIn();

  LoginBloc() : super(LoginInitial()) {
    on<SignINButtonClicked>((event, emit) async {
      emit(Loading());
      try {
        usersignin = await googleLogin();
        if (usersignin == null) {
          emit(SignInError("Please select your Google Id."));
          return;
        } else {
          emit(UserLoggedIn());
        }
      } on Exception {
        emit(SignInError("Something went wrong."));
      }
    });
  }
  Future<GoogleSignInAccount?> googleLogin() async {
    try {
      final user = await googleSignIn.signIn();

      if (user == null) {
        return null;
      } else {
        final authentication = await user.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: authentication.accessToken,
          idToken: authentication.idToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
        return user;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return null;
  }
}
