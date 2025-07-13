import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:gudapp/data/model/request/barang_keluar_request_model.dart';
import 'package:gudapp/data/repository/barang_keluar_repository.dart';
import 'package:meta/meta.dart';

part 'barangkeluar_event.dart';
part 'barangkeluar_state.dart';

class BarangkeluarBloc extends Bloc<BarangkeluarEvent, BarangkeluarState> {
  final BarangKeluarRepository barangKeluarRepository;

  BarangkeluarBloc({required this.barangKeluarRepository})
    : super(BarangkeluarInitial()) {
    on<GetBarangKeluarList>(_onGetBarangKeluarList);
    on<AddBarangKeluar>(_onAddBarangKeluar);
    on<getBarangKeluarById>(_onGetBarangKeluarById);
  }

  Future<void> _onGetBarangKeluarList(
    GetBarangKeluarList event,
    Emitter<BarangkeluarState> emit,
  ) async {
    emit(BarangkeluarLoading());

    final result = await barangKeluarRepository.getBarangKeluar();

    result.fold(
      (error) => emit(BarangkeluarError(message: error)),
      (data) => emit(BarangkeluarLoaded(data: data.data ?? [])),
    );
  }

  Future<void> _onAddBarangKeluar(
    AddBarangKeluar event,
    Emitter<BarangkeluarState> emit,
  ) async {
    emit(BarangkeluarLoading());

    try {
      final model = event.barangKeluarRequestModel;

      final fields = {
        'item_id': model.itemId.toString(),
        'gudang_id': model.gudangId.toString(),
        'quantity': model.quantity.toString(),
        'tanggal_keluar': model.tanggalKeluar ?? '',
        'keterangan': model.keterangan ?? '',
        'total_harga_barang_keluar': model.totalharga?.toString() ?? '',
        'created_by': model.createdBy?.toString() ?? '1',
      };

      final fotoFile = model.fotoPath != null ? File(model.fotoPath!) : null;

      await barangKeluarRepository.createBarangKeluar(
        fields: fields,
        fotoFile: fotoFile,
      );

      emit(BarangkeluarSuccess(message: 'Barang keluar berhasil ditambahkan'));
      add(GetBarangKeluarList());
    } catch (error) {
      emit(BarangkeluarError(message: error.toString()));
    }
  }

  Future<void> _onGetBarangKeluarById(
    getBarangKeluarById event,
    Emitter<BarangkeluarState> emit,
  ) async {
    emit(BarangkeluarLoading());

    final result = await barangKeluarRepository.getBarangKeluarById(event.id);

    result.fold(
      (error) => emit(BarangkeluarError(message: error)),
      (data) => emit(BarangkeluarLoaded(data: [data])),
    );
  }
}
