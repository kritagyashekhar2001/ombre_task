part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}
class SelectYourGmail extends LoginState {
  final int rand = Random().nextInt(100);

  SelectYourGmail();
  List<Object> get props => [rand];
}

class Loading extends LoginState {}

class SignInError extends LoginState {
  final String message;

  SignInError(this.message);

  List<Object> get props => [message];
}
class UserLoggedIn extends LoginState{}