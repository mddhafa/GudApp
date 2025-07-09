import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gudapp/presentation/gudang/bloc/gudang_bloc.dart';
import 'package:gudapp/presentation/gudang/detail_gudang.dart';
import 'package:gudapp/presentation/gudang/tambah_gudang.dart';

class GudangScreen extends StatefulWidget {
  const GudangScreen({super.key});

  @override
  State<GudangScreen> createState() => _GudangScreenState();
}

class _GudangScreenState extends State<GudangScreen> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String? _role;

  @override
  void initState() {
    super.initState();
    _loadRole();
    context.read<GudangBloc>().add(GetGudangList());
  }

  Future<void> _loadRole() async {
    _role = await _storage.read(key: 'userRole');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print("Build GudangScreen - role: $_role");

    return BlocListener<GudangBloc, GudangState>(
      listener: (context, state) {
        if (state is GudangSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: const [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Data berhasil dihapus!',
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
              Expanded(
                child: BlocBuilder<GudangBloc, GudangState>(
                  builder: (context, state) {
                    if (state is GudangLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is GudangError) {
                      return Center(child: Text(state.message));
                    } else if (state is GudangLoaded) {
                      if (state.data.isEmpty) {
                        return const Center(
                          child: Text('Tidak ada data gudang.'),
                        );
                      }
                      return RefreshIndicator(
                        onRefresh: () async {
                          context.read<GudangBloc>().add(GetGudangList());
                        },
                        child: ListView.separated(
                          itemCount: state.data.length,
                          separatorBuilder:
                              (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final gudang = state.data[index];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) =>
                                            DetailGudangScreen(gudang: gudang),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.warehouse,
                                        size: 32,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              gudang.name ?? '-',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.location_on,
                                                  size: 16,
                                                  color: Colors.grey,
                                                ),
                                                const SizedBox(width: 4),
                                                Expanded(
                                                  child: Text(
                                                    gudang.address ?? '-',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (_role == 'admin') ...[
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            final id = gudang.id;
                                            if (id != null) {
                                              context.read<GudangBloc>().add(
                                                DeleteGudang(id: id),
                                              );
                                            }
                                          },
                                          tooltip: 'Hapus Gudang',
                                        ),
                                      ],
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
        floatingActionButton:
            _role == 'admin'
                ? FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TambahGudang(),
                      ),
                    );
                  },
                  backgroundColor: Colors.red,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Icon(Icons.add, size: 28, color: Colors.white),
                )
                : null,
      ),
    );
  }
}
