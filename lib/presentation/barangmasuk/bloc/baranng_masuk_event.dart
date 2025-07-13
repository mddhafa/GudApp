part of 'baranng_masuk_bloc.dart';

sealed class BaranngMasukEvent {}

class GetBarangMasukList extends BaranngMasukEvent {}

class AddBarangMasuk extends BaranngMasukEvent {
  final BarangMasukRequestModel barangMasukRequestModel;
  AddBarangMasuk({required this.barangMasukRequestModel});
}

class getBarangMasukById extends BaranngMasukEvent {
  final int id;
  getBarangMasukById({required this.id});
}

class UpdateBarangMasuk extends BaranngMasukEvent {
  final int id;
  final BarangMasukRequestModel barangMasukRequestModel;
  UpdateBarangMasuk({required this.id, required this.barangMasukRequestModel});
}

class DeleteBarangMasuk extends BaranngMasukEvent {
  final int id;
  DeleteBarangMasuk({required this.id});
}
