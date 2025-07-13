import 'package:bloc/bloc.dart';
import 'package:gudapp/data/repository/profile_pegawai_repository.dart';

part 'profile_pegawai_event.dart';
part 'profile_pegawai_state.dart';

class ProfilePegawaiBloc
    extends Bloc<ProfilePegawaiEvent, ProfilePegawaiState> {
  final ProfilePegawaiRepository profilePegawaiRepository;

  ProfilePegawaiBloc({required this.profilePegawaiRepository})
    : super(ProfilePegawaiInitial()) {
    on<GetProfilePegawai>(_getProfilePegawai);
    on<CreateProfilePegawai>(_createProfilePegawai);
  }

  Future<void> _getProfilePegawai(
    GetProfilePegawai event,
    Emitter<ProfilePegawaiState> emit,
  ) async {
    emit(ProfilePegawaiLoading());

    try {
      final response = await profilePegawaiRepository.getProfile();

      if (response.success == true && response.data != null) {
        emit(ProfilePegawaiLoaded(data: [response.data!]));
      } else {
        emit(
          ProfilePegawaiError(
            message: response.message ?? 'Gagal memuat profil',
          ),
        );
      }
    } catch (e) {
      emit(ProfilePegawaiError(message: e.toString()));
    }
  }

  Future<void> _createProfilePegawai(
    CreateProfilePegawai event,
    Emitter<ProfilePegawaiState> emit,
  ) async {
    emit(ProfilePegawaiLoading());

    try {
      final response = await profilePegawaiRepository.createProfile(
        event.itemData,
      );

      if (response.isNotEmpty) {
        emit(ProfilePegawaiSuccess(message: 'Profil berhasil dibuat!'));
        add(GetProfilePegawai()); // Refresh the profile after creation
      } else {
        emit(ProfilePegawaiError(message: 'Gagal membuat profil'));
      }
    } catch (e) {
      emit(ProfilePegawaiError(message: e.toString()));
    }
  }
}
