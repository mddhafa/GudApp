import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gudapp/data/model/response/gudang_response_model.dart';
import 'package:gudapp/data/model/request/gudang_request_model.dart';
import 'package:gudapp/presentation/gudang/update_gudang.dart';

class DetailGudangScreen extends StatefulWidget {
  final Datum gudang;

  const DetailGudangScreen({super.key, required this.gudang});

  @override
  State<DetailGudangScreen> createState() => _DetailGudangScreenState();
}

class _DetailGudangScreenState extends State<DetailGudangScreen> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String? _role;

  @override
  void initState() {
    super.initState();
    _loadRole();
  }

  Future<void> _loadRole() async {
    final role = await _storage.read(key: 'userRole');
    setState(() {
      _role = role;
    });
  }

  @override
  Widget build(BuildContext context) {
    final gudang = widget.gudang;

    return Scaffold(
      appBar: AppBar(
        title: Text(gudang.name ?? 'Detail Gudang'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
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
                _buildDetailRow(Icons.inventory_2, 'Nama', gudang.name),
                const SizedBox(height: 12),
                _buildDetailRow(Icons.location_on, 'Alamat', gudang.address),
                const SizedBox(height: 12),
                _buildDetailRow(Icons.map, 'Latitude', gudang.latitude),
                const SizedBox(height: 12),
                _buildDetailRow(
                  Icons.map_outlined,
                  'Longitude',
                  gudang.longitude,
                ),
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
                      gudang.createdAt?.toLocal().toString().split(".").first ??
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
      floatingActionButton:
          _role == 'admin'
              ? FloatingActionButton(
                onPressed: () {
                  final lat = double.tryParse(gudang.latitude ?? '');
                  final lng = double.tryParse(gudang.longitude ?? '');

                  if (lat == null || lng == null || gudang.id == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Data lokasi atau ID gudang tidak valid.',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => UpdateGudang(
                            id: gudang.id!,
                            gudang: GudangRequestModel(
                              name: gudang.name,
                              address: gudang.address,
                              latitude: lat,
                              longitude: lng,
                            ),
                          ),
                    ),
                  );
                },
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Icon(Icons.edit, size: 28, color: Colors.white),
              )
              : null,
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String? value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.red, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(value ?? '-', style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ],
    );
  }
}
