abstract class ChangePassState {}

class ChangePassInitial extends ChangePassState {}

class ChangePassLoading extends ChangePassState {}

class ChangePassSuccess extends ChangePassState {}

class ChangePassFailure extends ChangePassState {
  final String errorMessage;
  ChangePassFailure(this.errorMessage);
}
