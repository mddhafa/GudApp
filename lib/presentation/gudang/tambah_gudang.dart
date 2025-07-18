import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gudapp/core/extensions/customesncakbar.dart';
import 'package:gudapp/data/model/request/gudang_request_model.dart';
import 'package:gudapp/presentation/gudang/bloc/gudang_bloc.dart';
import 'package:gudapp/presentation/gudang/maps/map_page.dart';
import 'package:gudapp/core/extensions/form_text_custom.dart';

class TambahGudang extends StatefulWidget {
  const TambahGudang({super.key});

  @override
  State<TambahGudang> createState() => _TambahGudangState();
}

class _TambahGudangState extends State<TambahGudang> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  double? latitude;
  double? longitude;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final nama = _namaController.text.trim();
      final alamat = _alamatController.text.trim();

      // Validasi apakah lokasi sudah dipilih
      if (latitude == null || longitude == null) {
        showCustomSnackBar(
          context,
          'Silakan pilih lokasi di peta terlebih dahulu.',
          backgroundColor: Colors.red,
          icon: Icons.error,
        );
        return;
      }

      final gudangRequest = GudangRequestModel(
        name: nama,
        address: alamat,
        latitude: latitude,
        longitude: latitude,
      );

      context.read<GudangBloc>().add(
        AddGudang(gudangRequestModel: gudangRequest),
      );
      showCustomSnackBar(
        context,
        'Gudang berhasil ditambahkan!',
        backgroundColor: Colors.green,
        icon: Icons.check_circle,
      );

      print('📤 Data yang dikirim: ${gudangRequest.toMap()}');

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Gudang'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: Colors.red,
        ),
        foregroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              //nama
              CustomTextFormField(
                controller: _namaController,
                label: 'Nama Gudang',
                validator:
                    (value) =>
                        value == null || value.trim().isEmpty
                            ? 'Nama wajib diisi'
                            : null,
              ),
              const SizedBox(height: 16),

              //alamt
              CustomTextFormField(
                controller: _alamatController,
                label: 'Alamat',
                validator:
                    (value) =>
                        value == null || value.trim().isEmpty
                            ? 'Alamat wajib diisi'
                            : null,
              ),
              const SizedBox(height: 24),
              IconButton(
                icon: const Icon(Icons.map),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MapPage()),
                  );

                  if (result != null && result is Map<String, dynamic>) {
                    print('Data lokasi diterima dari MapPage: $result');

                    setState(() {
                      _alamatController.text = result['address'] ?? '';
                      latitude = result['latitude'];
                      longitude = result['longitude'];
                    });
                  } else {
                    print('Tidak ada lokasi yang dipilih dari MapPage.');
                  }
                },
              ),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.save),
                  label: const Text('Simpan'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
