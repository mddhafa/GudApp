import 'package:flutter/material.dart';



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GudApp Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Tambahkan logika logout jika ada
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Logout berhasil')));
              // Contoh: Navigasi kembali ke login
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Selamat datang di GudApp!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.warehouse),
              label: const Text('Kelola Barang'),
              onPressed: () {
                // Navigasi ke fitur manajemen barang
                // Navigator.push(context, MaterialPageRoute(builder: (_) => BarangScreen()));
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.inventory),
              label: const Text('Laporan Gudang'),
              onPressed: () {
                // Navigasi ke fitur laporan
              },
            ),
          ],
        ),
      ),
    );
  }
}
