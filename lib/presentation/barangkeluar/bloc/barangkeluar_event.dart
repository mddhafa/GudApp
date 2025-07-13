part of 'barangkeluar_bloc.dart';

sealed class BarangkeluarEvent {}

class GetBarangKeluarList extends BarangkeluarEvent {}

class AddBarangKeluar extends BarangkeluarEvent {
  final BarangKeluarRequestModel barangKeluarRequestModel;
  AddBarangKeluar({required this.barangKeluarRequestModel});
}

class getBarangKeluarById extends BarangkeluarEvent {
  final int id;
  getBarangKeluarById({required this.id});
}
