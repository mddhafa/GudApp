import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gudapp/core/extensions/customesncakbar.dart';
import 'package:gudapp/presentation/barangmasuk/bloc/baranng_masuk_bloc.dart';
import 'package:gudapp/presentation/barangmasuk/detail_barang_masuk_screen.dart';
import 'package:gudapp/presentation/barangmasuk/tambah_barang_masuk_screen.dart';

class HomeBarangMasukScreen extends StatefulWidget {
  const HomeBarangMasukScreen({super.key});

  @override
  State<HomeBarangMasukScreen> createState() => _HomeBarangMasukScreenState();
}

class _HomeBarangMasukScreenState extends State<HomeBarangMasukScreen> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<BaranngMasukBloc>().add(GetBarangMasukList());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BaranngMasukBloc, BaranngMasukState>(
      listener: (context, state) {
        if (state is BaranngMasukSuccess) {
          showCustomSnackBar(
            context,
            'Data berhasil dihapus!',
            backgroundColor: Colors.green,
            icon: Icons.check_circle,
          );
        } else if (state is BaranngMasukError) {
          showCustomSnackBar(
            context,
            '${state.message}',
            backgroundColor: Colors.red,
            icon: Icons.error,
          );
        }

        if (state is UpdateBarangMasuk) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Barang berhasil diperbarui'),
              backgroundColor: Colors.green,
            ),
          );
          context.read<BaranngMasukBloc>().add(GetBarangMasukList());
        }

        if (state is BaranngMasukError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },

      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Search Field
              // TextField(
              //   decoration: InputDecoration(
              //     hintText: 'Cari barang masuk...',
              //     prefixIcon: const Icon(Icons.search),
              //     filled: true,
              //     fillColor: Colors.white,
              //     contentPadding: const EdgeInsets.symmetric(
              //       vertical: 12,
              //       horizontal: 16,
              //     ),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(12),
              //       borderSide: BorderSide.none,
              //     ),
              //   ),
              //   onChanged: (value) {
              //     setState(() {
              //       _searchQuery = value.toLowerCase();
              //     });
              //   },
              // ),
              // const SizedBox(height: 16),

              // List Barang Masuk
              Expanded(
                child: BlocBuilder<BaranngMasukBloc, BaranngMasukState>(
                  builder: (context, state) {
                    if (state is BaranngMasukLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is BaranngMasukError) {
                      return Center(child: Text('Error: ${state.message}'));
                    } else if (state is BaranngMasukLoaded) {
                      final filteredData =
                          state.data.where((item) {
                            // Filter berdasarkan keterangan jika tersedia
                            return item.keterangan?.toLowerCase().contains(
                                  _searchQuery,
                                ) ??
                                false;
                          }).toList();

                      final displayData =
                          _searchQuery.isEmpty ? state.data : filteredData;

                      if (displayData.isEmpty) {
                        return const Center(
                          child: Text('Data tidak ditemukan.'),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () async {
                          context.read<BaranngMasukBloc>().add(
                            GetBarangMasukList(),
                          );
                        },
                        child: ListView.separated(
                          itemCount: displayData.length,
                          separatorBuilder:
                              (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final item = displayData[index];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => DetailBarangMasukScreen(
                                          barang: item,
                                        ),
                                  ),
                                );
                              },
                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.inventory,
                                        color: Colors.red,
                                        size: 32,
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Item: ${item.itemName ?? 'ID: ${item.itemId}'}',
                                            ),
                                            const SizedBox(height: 4),
                                            Text('Jumlah: ${item.quantity}'),
                                            const SizedBox(height: 4),
                                            Text('Gudang: ${item.gudangName}'),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Tanggal: ${item.tanggalMasuk}',
                                            ),
                                            if (item.keterangan != null)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 4,
                                                ),
                                                child: Text(
                                                  item.keterangan!,
                                                  style: const TextStyle(
                                                    color: Colors.black54,
                                                  ),
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
                                            context
                                                .read<BaranngMasukBloc>()
                                                .add(DeleteBarangMasuk(id: id));
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

                    return const SizedBox(); // Default fallback
                  },
                ),
              ),
            ],
          ),
        ),

        //Floating Button
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const TambahBarangMasukScreen(),
              ),
            );
            if (result == true) {
              context.read<BaranngMasukBloc>().add(GetBarangMasukList());
            }
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
