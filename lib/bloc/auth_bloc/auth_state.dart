// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:equatable/equatable.dart';

class AuthStates extends Equatable {
  final String name;
  final String email;
  final String password;

  const AuthStates({this.email = '', this.password = '', this.name = ''});

  AuthStates copyWith({String? email, String? password}) {
    return AuthStates(
      email: email ?? this.email,
      password: password ?? this.password,
      name: name,
    );
  }

  @override
  List<Object> get props => [email, password, name];
}

class InitialAuthState extends AuthStates {}

class SignUpInProgressState extends AuthStates {}

class SignUpSuccessState extends AuthStates {}

class SignUpFailureState extends AuthStates {
  final String errorMessage;

  const SignUpFailureState({required this.errorMessage});
}
