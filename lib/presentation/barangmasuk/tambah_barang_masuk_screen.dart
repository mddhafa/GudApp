import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gudapp/core/extensions/form_text_custom.dart';
import 'package:gudapp/data/model/request/barang_masuk_request_model.dart';
import 'package:gudapp/presentation/barangmasuk/bloc/baranng_masuk_bloc.dart';
import 'package:gudapp/presentation/barangmasuk/camera.dart';
import 'package:image_picker/image_picker.dart';

class TambahBarangMasukScreen extends StatefulWidget {
  const TambahBarangMasukScreen({super.key});

  @override
  State<TambahBarangMasukScreen> createState() =>
      _TambahBarangMasukScreenState();
}

class _TambahBarangMasukScreenState extends State<TambahBarangMasukScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _itemIdController = TextEditingController();
  final TextEditingController _gudangIdController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _keteranganController = TextEditingController();
  final TextEditingController _hargaBeliController = TextEditingController();
  String? _fotoPath;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImageFromGallery() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _fotoPath = picked.path);
    }
  }

  Future<void> _captureFromCamera() async {
    final result = await Navigator.push<File>(
      context,
      MaterialPageRoute(builder: (_) => const CameraPage()),
    );
    if (result != null) {
      setState(() => _fotoPath = result.path);
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final model = BarangMasukRequestModel(
        itemId: int.tryParse(_itemIdController.text.trim()),
        gudangId: int.tryParse(_gudangIdController.text.trim()),
        quantity: int.tryParse(_qtyController.text.trim()),
        tanggalMasuk: _tanggalController.text.trim(),
        keterangan: _keteranganController.text.trim(),
        hargaBeli: int.tryParse(_hargaBeliController.text.trim()),
        fotoPath: _fotoPath,
      );

      context.read<BaranngMasukBloc>().add(
        AddBarangMasuk(barangMasukRequestModel: model),
      );

      Navigator.pop(context, true);
    }
  }

  @override
  void dispose() {
    _itemIdController.dispose();
    _gudangIdController.dispose();
    _qtyController.dispose();
    _tanggalController.dispose();
    _keteranganController.dispose();
    _hargaBeliController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Barang Masuk'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: Colors.red,
        ),
        foregroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomTextFormField(
                controller: _itemIdController,
                label: 'Item ID',
                keyboardType: TextInputType.number,
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                controller: _gudangIdController,
                label: 'Gudang ID',
                keyboardType: TextInputType.number,
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                controller: _qtyController,
                label: 'Jumlah',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Wajib diisi';
                  final parsed = int.tryParse(value);
                  if (parsed == null || parsed <= 0)
                    return 'Jumlah tidak valid';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                controller: _tanggalController,
                label: 'Tanggal Masuk (YYYY-MM-DD)',
                keyboardType: TextInputType.datetime,
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                controller: _keteranganController,
                label: 'Keterangan',
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                controller: _hargaBeliController,
                label: 'Harga Beli',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final parsed = int.tryParse(value);
                    if (parsed == null || parsed < 0)
                      return 'Harga tidak valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickImageFromGallery,
                    icon: const Icon(Icons.photo, color: Colors.white),
                    label: const Text(
                      'Galeri',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: _captureFromCamera,
                    icon: const Icon(Icons.camera_alt, color: Colors.white),
                    label: const Text(
                      'Kamera',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (_fotoPath != null)
                    Expanded(
                      child: Text(
                        File(_fotoPath!).path.split('/').last,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _submitForm,
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text(
                  'Simpan',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
