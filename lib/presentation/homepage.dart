import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gudapp/data/repository/barang_keluar_repository.dart';
import 'package:gudapp/data/repository/barang_masuk_repository.dart';
import 'package:gudapp/data/repository/gudang_repository.dart';
import 'package:gudapp/data/repository/items_repository.dart';
import 'package:gudapp/presentation/auth/login_screen.dart';
import 'package:gudapp/presentation/barangkeluar/bloc/barangkeluar_bloc.dart';
import 'package:gudapp/presentation/barangkeluar/home_barang_keluar_screen.dart';
import 'package:gudapp/presentation/barangmasuk/bloc/baranng_masuk_bloc.dart';
import 'package:gudapp/presentation/barangmasuk/home_barang_masuk_screen.dart';
import 'package:gudapp/presentation/dashboard_pegawai_screen.dart';
import 'package:gudapp/presentation/dashboard_screen.dart';
import 'package:gudapp/presentation/gudang/bloc/gudang_bloc.dart';
import 'package:gudapp/presentation/gudang/gudang_screen.dart';
import 'package:gudapp/presentation/items/bloc/items_bloc.dart';
import 'package:gudapp/presentation/items/home_items_screen.dart';
import 'package:gudapp/services/service_http_client.dart';

class HomeScreen extends StatefulWidget {
  final String userRole; // Role bisa 'admin', dll.

  const HomeScreen({super.key, required this.userRole});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late String userRole;

  @override
  void initState() {
    super.initState();
    userRole = widget.userRole; // Ambil dari parameter
  }

  final List<String> _titles = [
    'Dashboard',
    'Barang Masuk',
    'Barang Keluar',
    'Gudang',
    'Item',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          _titles[_currentIndex],
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.red,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _buildPage(_currentIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey[500],
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.move_to_inbox),
            label: 'Masuk',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Keluar'),
          BottomNavigationBarItem(icon: Icon(Icons.warehouse), label: 'Gudang'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: 'Item'),
        ],
      ),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        if (userRole == 'admin') {
          return BlocProvider(
            create:
                (_) => ItemsBloc(
                  itemsRepository: ItemsRepository(ServiceHttpClient()),
                )..add(GetItemsList()),
            child: const DashboardAdminScreen(), // Dashboard admin
          );
        } else if (userRole == 'pegawai') {
          return const DashboardPegawaiScreen(); //Dashboard pegawai
        } else {
          return const Center(child: Text('Role tidak dikenali'));
        }

      case 1:
        return BlocProvider(
          create:
              (_) => BaranngMasukBloc(
                barangMasukRepository: BarangMasukRepository(
                  ServiceHttpClient(),
                ),
              )..add(GetBarangMasukList()),
          child: const HomeBarangMasukScreen(),
        );
      case 2:
        return BlocProvider(
          create:
              (_) => BarangkeluarBloc(
                barangKeluarRepository: BarangKeluarRepository(
                  ServiceHttpClient(),
                ),
              )..add(GetBarangKeluarList()),
          child: const HomeBarangKeluarScreen(),
        );
      case 3:
        return BlocProvider(
          create:
              (_) => GudangBloc(
                gudangRepository: GudangRepository(ServiceHttpClient()),
              )..add(GetGudangList()),
          child: const GudangScreen(),
        );
      case 4:
        return BlocProvider(
          create:
              (_) => ItemsBloc(
                itemsRepository: ItemsRepository(ServiceHttpClient()),
              )..add(GetItemsList()),
          child: const ItemsScreen(),
        );
      default:
        return const SizedBox();
    }
  }

  // Widget _buildDashboard() {
  //   return Center(
  //     key: const ValueKey('dashboard'),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Icon(Icons.dashboard, size: 60, color: Colors.red[300]),
  //         const SizedBox(height: 16),
  //         Text(
  //           'Selamat Datang, ${widget.userRole.toUpperCase()}',
  //           style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
  //         ),
  //         const SizedBox(height: 8),
  //         const Text("Gunakan menu di bawah untuk navigasi."),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildPlaceholder(String label) {
    return Center(
      key: ValueKey(label),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.block, size: 60, color: Colors.grey),
          const SizedBox(height: 16),
          Text('$label belum tersedia', style: const TextStyle(fontSize: 20)),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: const Text("Konfirmasi"),
            content: const Text("Apakah Anda yakin ingin keluar?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
                child: const Text(
                  "Keluar",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }
}
