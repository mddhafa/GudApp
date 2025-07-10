part of 'items_bloc.dart';

@immutable
sealed class ItemsEvent {}

class GetItemsList extends ItemsEvent {}

class AddItem extends ItemsEvent {
  final ItemRequestModel itemRequestModel;
  AddItem({required this.itemRequestModel});
}

class UpdateItemEvent extends ItemsEvent {
  final int id;
  final ItemRequestModel itemRequestModel;
  UpdateItemEvent({required this.id, required this.itemRequestModel});
}

class DeleteItem extends ItemsEvent {
  final int id;
  DeleteItem({required this.id});
}

class GetItemById extends ItemsEvent {
  final int id;
  GetItemById({required this.id});
}
