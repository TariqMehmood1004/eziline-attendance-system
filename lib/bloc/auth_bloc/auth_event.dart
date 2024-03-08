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

  const SignUpEvent({
    required this.email,
    required this.password,
    required this.name,
  });
}
