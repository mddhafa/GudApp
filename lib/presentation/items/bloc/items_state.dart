part of 'items_bloc.dart';

sealed class ItemsState {}

final class ItemsInitial extends ItemsState {}

final class ItemsLoading extends ItemsState {}

final class ItemsLoaded extends ItemsState {
  final List<dynamic> data;
  ItemsLoaded({required this.data});
}

final class ItemDetailLoaded extends ItemsState {
  final dynamic data;
  ItemDetailLoaded({required this.data});
}

final class ItemsError extends ItemsState {
  final String message;
  ItemsError({required this.message});
}

final class ItemsSuccess extends ItemsState {
  final String message;
  ItemsSuccess({required this.message});
}
