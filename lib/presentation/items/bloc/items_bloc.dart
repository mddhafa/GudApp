import 'package:bloc/bloc.dart';
import 'package:gudapp/data/model/request/items_request_model.dart';
// import 'package:gudapp/data/model/response/items_response_model.dart';
import 'package:gudapp/data/repository/items_repository.dart';
import 'package:meta/meta.dart';

part 'items_event.dart';
part 'items_state.dart';

class ItemsBloc extends Bloc<ItemsEvent, ItemsState> {
  final ItemsRepository itemsRepository;

  ItemsBloc({required this.itemsRepository}) : super(ItemsInitial()) {
    on<GetItemById>(_onGetItemById);
    on<GetItemsList>(_onGetItemsList);
    on<AddItem>(_onAddItem);
    on<UpdateItemEvent>(_onUpdateItem);
    on<DeleteItem>(_onDeleteItem);
  }

  Future<void> _onGetItemById(
    GetItemById event,
    Emitter<ItemsState> emit,
  ) async {
    emit(ItemsLoading());

    final result = await itemsRepository.getItemById(event.id);

    result.fold(
      (error) => emit(ItemsError(message: error)),
      (data) => emit(ItemDetailLoaded(data: data)),
    );
  }

  Future<void> _onGetItemsList(
    GetItemsList event,
    Emitter<ItemsState> emit,
  ) async {
    emit(ItemsLoading());

    final result = await itemsRepository.getItemsList();

    result.fold(
      (error) => emit(ItemsError(message: error)),
      (data) => emit(ItemsLoaded(data: data.data ?? [])),
    );
  }

  Future<void> _onAddItem(AddItem event, Emitter<ItemsState> emit) async {
    emit(ItemsLoading());

    try {
      final result = await itemsRepository.createItem(
        event.itemRequestModel.toMap(),
      );
      emit(ItemsSuccess(message: 'Item berhasil ditambahkan!'));
      add(GetItemsList()); // Refresh the list after adding an item
    } catch (error) {
      emit(ItemsError(message: error.toString()));
    }
  }

  Future<void> _onUpdateItem(
    UpdateItemEvent event,
    Emitter<ItemsState> emit,
  ) async {
    emit(ItemsLoading());

    try {
      await itemsRepository.updateItem(
        event.id,
        event.itemRequestModel.toMap(),
      );
      add(GetItemsList()); // Refresh the list after updating an item
    } catch (error) {
      emit(ItemsError(message: error.toString()));
    }
  }

  Future<void> _onDeleteItem(DeleteItem event, Emitter<ItemsState> emit) async {
    emit(ItemsLoading());

    try {
      await itemsRepository.deleteItem(event.id);

      // Emit state sukses jika perlu
      emit(ItemsSuccess(message: 'Item berhasil dihapus'));

      // Refresh list
      final result = await itemsRepository.getItemsList();
      emit(
        result.fold(
          (error) => ItemsError(message: error),
          (data) => ItemsLoaded(data: data.data ?? []),
        ),
      );
    } catch (e) {
      emit(ItemsError(message: e.toString()));
    }
  }
}
