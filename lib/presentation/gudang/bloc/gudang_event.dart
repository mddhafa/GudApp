part of 'gudang_bloc.dart';

@immutable
sealed class GudangEvent {}

class GetGudangList extends GudangEvent {}

class AddGudang extends GudangEvent {
  final GudangRequestModel gudangRequestModel;
  AddGudang({required this.gudangRequestModel});
}

class UpdateGudangEvent extends GudangEvent {
  final int id;
  final GudangRequestModel gudangRequestModel;
  UpdateGudangEvent({required this.id, required this.gudangRequestModel});
}


class DeleteGudang extends GudangEvent {
  final int id;
  DeleteGudang({required this.id});
}
