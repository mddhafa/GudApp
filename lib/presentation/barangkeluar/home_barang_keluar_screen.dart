import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gudapp/core/extensions/customesncakbar.dart';
import 'package:gudapp/presentation/barangkeluar/bloc/barangkeluar_bloc.dart';
import 'package:gudapp/presentation/barangkeluar/detail_barang_keluar_screen.dart';
import 'package:gudapp/presentation/barangkeluar/tambah_barang_keluar_screen.dart';

class HomeBarangKeluarScreen extends StatefulWidget {
  const HomeBarangKeluarScreen({super.key});

  @override
  State<HomeBarangKeluarScreen> createState() => _HomeBarangKeluarScreenState();
}

class _HomeBarangKeluarScreenState extends State<HomeBarangKeluarScreen> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<BarangkeluarBloc>().add(GetBarangKeluarList());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BarangkeluarBloc, BarangkeluarState>(
      listener: (context, state) {
        if (state is BarangkeluarSuccess) {
          showCustomSnackBar(
            context,
            state.message,
            backgroundColor: Colors.green,
            icon: Icons.check_circle,
          );
        } else if (state is BarangkeluarError) {
          showCustomSnackBar(
            context,
            state.message,
            backgroundColor: Colors.red,
            icon: Icons.error,
          );
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // TextField(
              //   decoration: InputDecoration(
              //     hintText:
              //         'Cari barang keluar...'
              //         '',
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
              Expanded(
                child: BlocBuilder<BarangkeluarBloc, BarangkeluarState>(
                  builder: (context, state) {
                    if (state is BarangkeluarLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is BarangkeluarError) {
                      return Center(child: Text('Error: ${state.message}'));
                    } else if (state is BarangkeluarLoaded) {
                      final filteredData =
                          state.data.where((item) {
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
                          context.read<BarangkeluarBloc>().add(
                            GetBarangKeluarList(),
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
                                        (_) => DetailBarangKeluarScreen(
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
                                        Icons.inventory_outlined,
                                        color: Colors.blue,
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
                                              'Tanggal: ${item.tanggalKeluar}',
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
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const TambahBarangKeluarScreen(),
              ),
            );
            if (result == true) {
              context.read<BarangkeluarBloc>().add(GetBarangKeluarList());
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
