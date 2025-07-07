import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:gudapp/data/model/request/gudang_request_model.dart';
import 'package:gudapp/data/repository/gudang_repository.dart';

part 'gudang_event.dart';
part 'gudang_state.dart';

class GudangBloc extends Bloc<GudangEvent, GudangState> {
  final GudangRepository gudangRepository;

  GudangBloc({required this.gudangRepository}) : super(GudangInitial()) {
    on<GetGudangList>(_onGetGudangList);
    on<AddGudang>(_onAddGudang);
    on<UpdateGudang>(_onUpdateGudang);
    on<DeleteGudang>(_onDeleteGudang);
  }

  Future<void> _onGetGudangList(
    GetGudangList event,
    Emitter<GudangState> emit,
  ) async {
    emit(GudangLoading());
    final result = await gudangRepository.getGudangList();
    result.fold(
      (error) => emit(GudangError(message: error)),
      (data) => emit(GudangLoaded(data: data.data ?? [])),
    );
  }

  Future<void> _onAddGudang(AddGudang event, Emitter<GudangState> emit) async {
    emit(GudangLoading());

    try {
      await gudangRepository.createGudang(
        event.gudangRequestModel.toJson() as Map<String, dynamic>,
      );
      add(GetGudangList());
    } catch (e) {
      emit(GudangError(message: e.toString()));
    }
  }

  Future<void> _onUpdateGudang(
    UpdateGudang event,
    Emitter<GudangState> emit,
  ) async {
    emit(GudangLoading());

    try {
      await gudangRepository.updateGudang(
        event.id,
        event.gudangRequestModel.toJson() as Map<String, dynamic>,
      );
      add(GetGudangList());
    } catch (e) {
      emit(GudangError(message: e.toString()));
    }
  }

  Future<void> _onDeleteGudang(
    DeleteGudang event,
    Emitter<GudangState> emit,
  ) async {
    emit(GudangLoading());

    try {
      await gudangRepository.deleteGudang(event.id);

      // Emit state sukses jika perlu
      emit(GudangSuccess(message: 'Gudang berhasil dihapus'));

      // Refresh list
      final result = await gudangRepository.getGudangList();
      emit(
        result.fold(
          (error) => GudangError(message: error),
          (data) => GudangLoaded(data: data.data ?? []),
        ),
      );
    } catch (e) {
      emit(GudangError(message: e.toString()));
    }
  }
}
