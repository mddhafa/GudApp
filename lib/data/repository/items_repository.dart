import 'dart:convert';
// import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:gudapp/data/model/response/items_response_model.dart';
import 'package:gudapp/services/service_http_client.dart';

class ItemsRepository {
  final ServiceHttpClient _serviceHttpClient;

  ItemsRepository(this._serviceHttpClient);

  Future<Either<String, ItemsResponse>> getItemsList() async {
    try {
      final response = await _serviceHttpClient.getWithToken('items');
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final itemsResponse = ItemsResponse.fromMap(jsonResponse);
        return Right(itemsResponse);
      } else {
        return Left(
          'Tidak ada items yang ditemukan. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      return Left('Error fetching items list: $e');
    }
  }

  Future<Either<String, ItemsDatum>> getItemById(int id) async {
    try {
      final response = await _serviceHttpClient.getWithToken('items/$id');
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final item = ItemsDatum.fromMap(jsonResponse['data']);
        print('Item fetched: ${item.name}');
        print('url: ${_serviceHttpClient.baseUrl}items/$id');
        return Right(item);
      } else {
        return Left('Item not found. Status code: ${response.statusCode}');
      }
    } catch (e) {
      return Left('Error fetching item by ID: $e');
    }
  }

  Future<Map<String, dynamic>> createItem(Map<String, dynamic> itemData) async {
    try {
      final response = await _serviceHttpClient.postWithToken(
        "items",
        itemData,
      );
      if (response.statusCode == 201) {
        final decoded = json.decode(response.body);
        return decoded['data'];
      } else {
        throw Exception('Failed to create item');
      }
    } catch (e) {
      throw Exception('Error creating item: $e');
    }
  }

  Future<Map<String, dynamic>> updateItem(
    int id,
    Map<String, dynamic> itemData,
  ) async {
    try {
      final response = await _serviceHttpClient.put("items/$id", itemData);
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        return decoded['data'];
      } else {
        throw Exception('Failed to update item');
      }
    } catch (e) {
      throw Exception('Error updating item: $e');
    }
  }

  Future<void> deleteItem(int id) async {
    try {
      final response = await _serviceHttpClient.deleteWithToken("items/$id");

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to delete item. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error deleting item: $e');
    }
  }
}
