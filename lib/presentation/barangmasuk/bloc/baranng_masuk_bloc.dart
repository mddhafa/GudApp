import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:gudapp/data/model/request/barang_masuk_request_model.dart';
import 'package:gudapp/data/repository/barang_masuk_repository.dart';
import 'package:meta/meta.dart';

part 'baranng_masuk_event.dart';
part 'baranng_masuk_state.dart';

class BaranngMasukBloc extends Bloc<BaranngMasukEvent, BaranngMasukState> {
  final BarangMasukRepository barangMasukRepository;

  BaranngMasukBloc({required this.barangMasukRepository})
    : super(BaranngMasukInitial()) {
    on<GetBarangMasukList>(_onGetBarangMasukList);
    on<getBarangMasukById>(_onGetBarangMasukById);
    on<AddBarangMasuk>(_onAddBarangMasuk);
    on<UpdateBarangMasuk>(_onUpdateBarangMasuk);
    on<DeleteBarangMasuk>(_onDeleteBarangMasuk);
  }

  // Future<void> _onGetBarangMasukList(
  //   GetBarangMasukList event,
  //   Emitter<BaranngMasukState> emit,
  // ) async {
  //   emit(BaranngMasukLoading());

  //   final result = await barangMasukRepository.getBarangMasuk();

  //   result.fold(
  //     (error) => emit(BaranngMasukError(message: error)),
  //     (data) => emit(BaranngMasukLoaded(data: data.data ?? [])),
  //   );
  // }
  Future<void> _onGetBarangMasukList(
    GetBarangMasukList event,
    Emitter<BaranngMasukState> emit,
  ) async {
    emit(BaranngMasukLoading());
    print('[BLOC] GetBarangMasukList dipanggil...');

    final result = await barangMasukRepository.getBarangMasuk();

    result.fold(
      (error) {
        print('[BLOC] Error: $error');
        emit(BaranngMasukError(message: error));
      },
      (data) {
        print('[BLOC] Data didapat: ${data.data?.length} item');
        emit(BaranngMasukLoaded(data: data.data ?? []));
      },
    );
  }

  Future<void> _onAddBarangMasuk(
    AddBarangMasuk event,
    Emitter<BaranngMasukState> emit,
  ) async {
    emit(BaranngMasukLoading());

    try {
      final model = event.barangMasukRequestModel;

      final fields = {
        'item_id': model.itemId.toString(),
        'gudang_id': model.gudangId.toString(),
        'quantity': model.quantity.toString(),
        'tanggal_masuk': model.tanggalMasuk ?? '',
        'keterangan': model.keterangan ?? '',
        'harga_beli': model.hargaBeli?.toString() ?? '',
        'created_by': model.createdBy?.toString() ?? '1',
      };

      final fotoFile = model.fotoPath != null ? File(model.fotoPath!) : null;

      await barangMasukRepository.createBarangMasukWithFoto(
        fields: fields,
        fotoFile: fotoFile,
      );

      emit(BaranngMasukSuccess(message: 'Barang masuk berhasil ditambahkan!'));
      add(GetBarangMasukList());
    } catch (error) {
      emit(BaranngMasukError(message: error.toString()));
    }
  }

  Future<void> _onGetBarangMasukById(
    getBarangMasukById event,
    Emitter<BaranngMasukState> emit,
  ) async {
    emit(BaranngMasukLoading());

    final result = await barangMasukRepository.getBarangMasukById(event.id);

    result.fold(
      (error) => emit(BaranngMasukError(message: error)),
      (data) => emit(BaranngMasukDetailLoaded(data: data)),
    );
  }

  Future<void> _onUpdateBarangMasuk(
    UpdateBarangMasuk event,
    Emitter<BaranngMasukState> emit,
  ) async {
    emit(BaranngMasukLoading());

    try {
      await barangMasukRepository.updateBarangMasuk(
        event.id,
        event.barangMasukRequestModel.toMap(),
      );
      add(GetBarangMasukList());
    } catch (error) {
      emit(BaranngMasukError(message: error.toString()));
    }
  }

  Future<void> _onDeleteBarangMasuk(
    DeleteBarangMasuk event,
    Emitter<BaranngMasukState> emit,
  ) async {
    emit(BaranngMasukLoading());

    try {
      await barangMasukRepository.deleteBarangMasuk(event.id);

      emit(BaranngMasukSuccess(message: 'Barang masuk berhasil dihapus!'));

      final result = await barangMasukRepository.getBarangMasuk();

      emit(
        result.fold(
          (error) => BaranngMasukError(message: error),
          (data) => BaranngMasukLoaded(data: data.data ?? []),
        ),
      );
    } catch (e) {
      emit(BaranngMasukError(message: e.toString()));
    }
  }
}
