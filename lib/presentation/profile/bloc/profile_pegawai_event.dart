part of 'profile_pegawai_bloc.dart';

sealed class ProfilePegawaiEvent {}

class GetProfilePegawai extends ProfilePegawaiEvent {}

class CreateProfilePegawai extends ProfilePegawaiEvent {
  final Map<String, dynamic> itemData;
  CreateProfilePegawai({required this.itemData});
}
