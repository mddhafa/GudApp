part of 'profile_pegawai_bloc.dart';

sealed class ProfilePegawaiState {}

final class ProfilePegawaiInitial extends ProfilePegawaiState {}

final class ProfilePegawaiLoading extends ProfilePegawaiState {}

final class ProfilePegawaiLoaded extends ProfilePegawaiState {
  final List<dynamic> data;
  ProfilePegawaiLoaded({required this.data});
}

final class ProfilePegawaiSuccess extends ProfilePegawaiState {
  final String message;
  ProfilePegawaiSuccess({required this.message});
}

final class ProfilePegawaiError extends ProfilePegawaiState {
  final String message;
  ProfilePegawaiError({required this.message});
}
