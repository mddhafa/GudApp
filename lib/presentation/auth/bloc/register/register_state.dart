part of 'register_bloc.dart';

@immutable
sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class RegisterLoading extends RegisterState {}

final class RegisterSuccess extends RegisterState {
  final AuthResponseModel responseModel;

  RegisterSuccess({required this.responseModel});
}

final class RegisterFailure extends RegisterState {
  final String error;

  RegisterFailure({required this.error});
}
