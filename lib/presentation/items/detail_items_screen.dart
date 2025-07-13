import 'package:flutter/material.dart';
import 'package:gudapp/data/model/response/items_response_model.dart';
import 'package:gudapp/presentation/items/update_items_screen.dart';
import 'package:intl/intl.dart';

class DetailItemScreen extends StatelessWidget {
  final ItemsDatum item;

  const DetailItemScreen({super.key, required this.item});


  @override
  Widget build(BuildContext context) {

    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 2,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(item.name ?? 'Detail Item'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: Colors.red,
        ),
        foregroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Nama', item.name ?? '-'),
                const SizedBox(height: 12),
                _buildDetailRow('Deskripsi', item.description ?? '-'),
                const SizedBox(height: 12),
                // _buildDetailRow(
                //   'Harga',
                //   'Rp ${(double.tryParse(item.price ?? '') ?? 0).toStringAsFixed(2)}',
                // ),
                _buildDetailRow(
                  'Harga',
                  currencyFormat.format(
                    double.tryParse(item.price ?? '0') ?? 0,
                  ),
                ),
                const SizedBox(height: 12),
                _buildDetailRow('Stok', item.stock?.toString() ?? '0'),
                const SizedBox(height: 20),
                const Divider(thickness: 1),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Dibuat pada:',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item.createdAt?.toLocal().toString().split(".").first ??
                          '-',
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => EditItemScreen(item: item)),
          );
        },
        backgroundColor: Colors.red,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: const Icon(Icons.edit, size: 28, color: Colors.white),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 15)),
      ],
    );
  }
}
