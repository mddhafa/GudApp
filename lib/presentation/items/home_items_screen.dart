import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gudapp/presentation/gudang/detail_gudang.dart';
import 'package:gudapp/presentation/items/bloc/items_bloc.dart';
import 'package:gudapp/presentation/items/detail_items_screen.dart';
import 'package:gudapp/presentation/items/tambah_items_screen.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<ItemsBloc>().add(GetItemsList());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ItemsBloc, ItemsState>(
      listener: (context, state) {
        if (state is ItemsSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: const [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Aksi berhasil dilakukan!',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              duration: const Duration(seconds: 3),
              margin: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: null,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Cari item...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
              ),
              const SizedBox(height: 16),

              // List Items
              Expanded(
                child: BlocBuilder<ItemsBloc, ItemsState>(
                  builder: (context, state) {
                    if (state is ItemsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ItemsError) {
                      return Center(child: Text(state.message));
                    } else if (state is ItemsLoaded) {
                      final filteredData =
                          state.data
                              .where(
                                (item) =>
                                    item.name?.toLowerCase().contains(
                                      _searchQuery,
                                    ) ??
                                    false,
                              )
                              .toList();

                      if (filteredData.isEmpty) {
                        return const Center(
                          child: Text('Item tidak ditemukan.'),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () async {
                          context.read<ItemsBloc>().add(GetItemsList());
                        },
                        child: ListView.separated(
                          itemCount: filteredData.length,
                          separatorBuilder:
                              (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final item = filteredData[index];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => DetailItemScreen(item: item),
                                  ),
                                );
                              },
                              child: Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.inventory_2,
                                        size: 32,
                                        color: Colors.blue,
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.name ?? '-',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              item.description ??
                                                  'Tidak ada deskripsi',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Harga: Rp ${(double.tryParse(item.price ?? '') ?? 0).toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          final id = item.id;
                                          if (id != null) {
                                            context.read<ItemsBloc>().add(
                                              DeleteItem(id: id),
                                            );
                                          }
                                        },
                                        tooltip: 'Hapus Item',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TambahItemScreen()),
            );
          },
          backgroundColor: Colors.red,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: const Icon(Icons.add, size: 28, color: Colors.white),
        ),
      ),
    );
  }
}
