part of 'gudang_bloc.dart';

sealed class GudangState {}

class GudangInitial extends GudangState {}

class GudangLoading extends GudangState {}

class GudangLoaded extends GudangState {
  final List<dynamic> data;
  GudangLoaded({required this.data});
}

class GudangError extends GudangState {
  final String message;
  GudangError({required this.message});
}

class GudangSuccess extends GudangState {
  final String message;
  GudangSuccess({required this.message});
}
