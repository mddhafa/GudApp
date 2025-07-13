part of 'baranng_masuk_bloc.dart';

sealed class BaranngMasukState {}

final class BaranngMasukInitial extends BaranngMasukState {}

final class BaranngMasukLoading extends BaranngMasukState {}

final class BaranngMasukLoaded extends BaranngMasukState {
  final List<dynamic> data;
  BaranngMasukLoaded({required this.data});
}

final class BaranngMasukError extends BaranngMasukState {
  final String message;
  BaranngMasukError({required this.message});
}

final class BaranngMasukSuccess extends BaranngMasukState {
  final String message;
  BaranngMasukSuccess({required this.message});
}

final class BaranngMasukDetailLoaded extends BaranngMasukState {
  final dynamic data;
  BaranngMasukDetailLoaded({required this.data});
}
