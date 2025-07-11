abstract class AuthState {}

class SignInInitial extends AuthState {}

class SignInLoading extends AuthState {}

class SignInSuccess extends AuthState {
  final String? token;
  SignInSuccess(this.token);
}

class SignInFailure extends AuthState {
  final String errorMessage;
  SignInFailure(this.errorMessage);
}

class TokenValid extends AuthState {}

class TokenInvalid extends AuthState {}


class LogoutLoading extends AuthState {}

class LogoutSuccess extends AuthState {}

class LogoutFailure extends AuthState {
  final String errorMessage;
  LogoutFailure(this.errorMessage);
}

