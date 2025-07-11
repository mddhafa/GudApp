import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gudapp/core/extensions/form_text_custom.dart';
import 'package:gudapp/core/extensions/snackbar_message_custom.dart';
import 'package:gudapp/data/model/request/gudang_request_model.dart';
import 'package:gudapp/presentation/gudang/bloc/gudang_bloc.dart';
import 'package:gudapp/presentation/gudang/maps/map_page.dart';

class UpdateGudang extends StatefulWidget {
  final GudangRequestModel gudang;
  final int id;

  const UpdateGudang({super.key, required this.id, required this.gudang});

  @override
  State<UpdateGudang> createState() => _UpdateGudangState();
}

class _UpdateGudangState extends State<UpdateGudang> {
  late TextEditingController _namaController;
  late TextEditingController _alamatController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  double? latitude;
  double? longitude;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.gudang.name);
    _alamatController = TextEditingController(text: widget.gudang.address);
    latitude = widget.gudang.latitude;
    longitude = widget.gudang.longitude;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final nama = _namaController.text.trim();
      final alamat = _alamatController.text.trim();

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
        longitude: longitude,
      );

      context.read<GudangBloc>().add(
        UpdateGudangEvent(id: widget.id, gudangRequestModel: gudangRequest),
      );

      showCustomSnackBar(
        context,
        'Gudang berhasil diperbarui!',
        backgroundColor: Colors.green,
        icon: Icons.check_circle,
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perbarui Gudang'),
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
          child: ListView(
            children: [
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

              CustomTextFormField(
                controller: _alamatController,
                label: 'Alamat',
                validator:
                    (value) =>
                        value == null || value.trim().isEmpty
                            ? 'Alamat wajib diisi'
                            : null,
              ),
              const SizedBox(height: 16),
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
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Perbarui Gudang'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
