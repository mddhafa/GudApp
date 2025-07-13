import 'package:flutter/material.dart';
import 'package:gudapp/data/model/response/barang_keluar_respone_model.dart';
import 'package:gudapp/presentation/detail_gambar.dart';
import 'package:intl/intl.dart';

class DetailBarangKeluarScreen extends StatelessWidget {
  final BarangKeluarDatum barang;

  const DetailBarangKeluarScreen({super.key, required this.barang});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 2,
    );

    print('Foto URL: ${barang.foto}');
    print('Tanggal Keluar: ${barang.tanggalKeluar}');
    print('Total Harga: ${barang.totalharga}');
    print('Created By: ${barang.createdBy?.name}');
    print('Created At: ${barang.createdAt}');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Barang Keluar'),
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
                if (barang.foto != null && barang.foto!.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => DetailGambarScreen(
                                imageUrl:
                                    'http://10.0.2.2:8000/storage/${barang.foto}',
                              ),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        'http://10.0.2.2:8000/storage/${barang.foto}',
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) =>
                                const Icon(Icons.broken_image, size: 100),
                      ),
                    ),
                  )
                else
                  const Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 100,
                      color: Colors.grey,
                    ),
                  ),
                const SizedBox(height: 20),

                _buildDetailTile('Item', barang.itemName ?? 'Tidak diketahui'),
                _buildDetailTile(
                  'Gudang',
                  barang.gudangName ?? 'Tidak diketahui',
                ),
                _buildDetailTile('Jumlah', '${barang.quantity ?? 0}'),
                _buildDetailTile(
                  'Tanggal Keluar',
                  '${barang.tanggalKeluar?.toLocal().toString().split(' ')[0]}',
                ),
                _buildDetailTile(
                  'Total Harga',
                  barang.totalharga != null
                      ? currencyFormat.format(barang.totalharga)
                      : 'Tidak diketahui',
                ),
                _buildDetailTile('Keterangan', barang.keterangan ?? '-'),
                _buildDetailTile('Diinput oleh', barang.createdBy?.name ?? '-'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
