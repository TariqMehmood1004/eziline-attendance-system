// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:equatable/equatable.dart';

class AuthStates extends Equatable {
  final String name;
  final String email;
  final String password;
  final String imageUrl;

  final bool isLogin;

  const AuthStates({
    this.email = '',
    this.password = '',
    this.name = '',
    this.imageUrl = '',
    this.isLogin = true,
  });

  AuthStates copyWith({String? email, String? password}) {
    return AuthStates(
      email: email ?? this.email,
      password: password ?? this.password,
      name: name,
      imageUrl: imageUrl,
      isLogin: isLogin,
    );
  }

  @override
  List<Object> get props => [email, password, name, imageUrl, isLogin];
}

class InitialAuthState extends AuthStates {}

class SignUpInProgressState extends AuthStates {}

class SignUpSuccessState extends AuthStates {}

class SignUpFailureState extends AuthStates {
  final String errorMessage;

  const SignUpFailureState({required this.errorMessage});
}

class LoginInProgressState extends AuthStates {}

class LoginSuccessState extends AuthStates {}

class LoginFailureState extends AuthStates {
  final String errorMessage;

  const LoginFailureState({required this.errorMessage});
}
