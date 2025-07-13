import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gudapp/core/extensions/customesncakbar.dart';
import 'package:gudapp/core/extensions/form_text_custom.dart';
import 'package:gudapp/data/model/request/barang_keluar_request_model.dart';
import 'package:gudapp/presentation/barangkeluar/bloc/barangkeluar_bloc.dart';
import 'package:gudapp/presentation/barangmasuk/camera.dart';
import 'package:image_picker/image_picker.dart';

class TambahBarangKeluarScreen extends StatefulWidget {
  const TambahBarangKeluarScreen({super.key});

  @override
  State<TambahBarangKeluarScreen> createState() =>
      _TambahBarangKeluarScreenState();
}

class _TambahBarangKeluarScreenState extends State<TambahBarangKeluarScreen> {
  final _formKey = GlobalKey<FormState>();
  final _itemIdController = TextEditingController();
  final _gudangIdController = TextEditingController();
  final _qtyController = TextEditingController();
  final _tanggalController = TextEditingController();
  final _keteranganController = TextEditingController();
  final _totalHargaController = TextEditingController();
  String? _fotoPath;

  final _picker = ImagePicker();

  Future<void> _pickFromGallery() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) setState(() => _fotoPath = file.path);
  }

  Future<void> _captureWithCamera() async {
    final result = await Navigator.push<File>(
      context,
      MaterialPageRoute(builder: (_) => const CameraPage()),
    );
    if (result != null) setState(() => _fotoPath = result.path);
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final model = BarangKeluarRequestModel(
        itemId: int.tryParse(_itemIdController.text.trim()),
        gudangId: int.tryParse(_gudangIdController.text.trim()),
        quantity: int.tryParse(_qtyController.text.trim()),
        tanggalKeluar: _tanggalController.text.trim(),
        keterangan: _keteranganController.text.trim(),
        totalharga: int.tryParse(_totalHargaController.text.trim()),
        fotoPath: _fotoPath,
        createdBy: 1,
      );

      context.read<BarangkeluarBloc>().add(
        AddBarangKeluar(barangKeluarRequestModel: model),
      );
    }
  }

  @override
  void dispose() {
    _itemIdController.dispose();
    _gudangIdController.dispose();
    _qtyController.dispose();
    _tanggalController.dispose();
    _keteranganController.dispose();
    _totalHargaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BarangkeluarBloc, BarangkeluarState>(
      listener: (context, state) {
        if (state is BarangkeluarSuccess) {
          showCustomSnackBar(
            context,
            state.message,
            backgroundColor: Colors.green,
          );
          Navigator.pop(context, true);
        } else if (state is BarangkeluarError) {
          showCustomSnackBar(
            context,
            state.message,
            backgroundColor: Colors.red,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tambah Barang Keluar'),
          centerTitle: true,
          foregroundColor: Colors.red,
          titleTextStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.red,
          ),
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
                      (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 12),
                CustomTextFormField(
                  controller: _gudangIdController,
                  label: 'Gudang ID',
                  keyboardType: TextInputType.number,
                  validator:
                      (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 12),
                CustomTextFormField(
                  controller: _qtyController,
                  label: 'Jumlah',
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    final q = int.tryParse(v ?? '');
                    if (q == null || q <= 0) return 'Jumlah tidak valid';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                CustomTextFormField(
                  controller: _tanggalController,
                  label: 'Tanggal Keluar (YYYY-MM-DD)',
                  readOnly: true,
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      _tanggalController.text =
                          picked.toIso8601String().split('T').first;
                    }
                  },
                  validator:
                      (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 12),
                CustomTextFormField(
                  controller: _keteranganController,
                  label: 'Keterangan',
                ),
                const SizedBox(height: 12),
                CustomTextFormField(
                  controller: _totalHargaController,
                  label: 'Total Harga',
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v != null && v.isNotEmpty) {
                      final parsed = int.tryParse(v);
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
                      onPressed: _pickFromGallery,
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
                      onPressed: _captureWithCamera,
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
      ),
    );
  }
}
