import 'package:equatable/equatable.dart';

abstract class AuthEvents extends Equatable {
  const AuthEvents();

  @override
  List<Object?> get props => [];
}

class SignUpEvent extends AuthEvents {
  final String name;
  final String email;
  final String password;
  final String imageUrl;

  const SignUpEvent({
    required this.email,
    required this.password,
    required this.name,
    required this.imageUrl,
  });
}

class LoginEvent extends AuthEvents {
  final String email;
  final String password;

  const LoginEvent({
    required this.email,
    required this.password,
  });
}

class LoggedOutEvent extends AuthEvents {}
