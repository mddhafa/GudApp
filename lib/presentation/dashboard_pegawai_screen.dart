import 'package:flutter/material.dart';

class DashboardPegawaiScreen extends StatelessWidget {
  const DashboardPegawaiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selamat datang!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Berikut ringkasan aktivitas hari ini:',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),

            /// Kartu Statistik
            Row(
              children: [
                _buildInfoCard(
                  title: 'Barang Masuk',
                  value: '?',
                  icon: Icons.move_to_inbox,
                  color: Colors.redAccent,
                ),
                const SizedBox(width: 12),
                _buildInfoCard(
                  title: 'Total Item',
                  value: '?',
                  icon: Icons.inventory,
                  color: Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildInfoCard(
                  title: 'Gudang Aktif',
                  value: '?',
                  icon: Icons.store,
                  color: Colors.green,
                ),
                const SizedBox(width: 12),
                _buildInfoCard(
                  title: 'Laporan',
                  value: '?',
                  icon: Icons.assignment,
                  color: Colors.blueAccent,
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        height: 100,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const Spacer(),
            Text(title, style: TextStyle(color: color, fontSize: 14)),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
