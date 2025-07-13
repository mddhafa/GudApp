part of 'barangkeluar_bloc.dart';

@immutable
sealed class BarangkeluarState {}

final class BarangkeluarInitial extends BarangkeluarState {}

final class BarangkeluarLoading extends BarangkeluarState {}

final class BarangkeluarLoaded extends BarangkeluarState {
  final List<dynamic> data;
  BarangkeluarLoaded({required this.data});
}

final class BarangkeluarError extends BarangkeluarState {
  final String message;
  BarangkeluarError({required this.message});
}

final class BarangkeluarSuccess extends BarangkeluarState {
  final String message;
  BarangkeluarSuccess({required this.message});
}
