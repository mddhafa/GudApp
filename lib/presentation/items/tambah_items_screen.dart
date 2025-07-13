import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gudapp/data/model/request/items_request_model.dart';
import 'package:gudapp/presentation/items/bloc/items_bloc.dart';
import 'package:gudapp/core/extensions/form_text_custom.dart';

class TambahItemScreen extends StatefulWidget {
  const TambahItemScreen({super.key});

  @override
  State<TambahItemScreen> createState() => _TambahItemScreenState();
}

class _TambahItemScreenState extends State<TambahItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  String _status = 'tersedia';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Item'),
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
              // Nama
              CustomTextFormField(
                controller: _nameController,
                label: 'Nama Item',
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 12),

              // Deskripsi
              CustomTextFormField(
                controller: _descController,
                label: 'Deskripsi',
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 12),

              // Harga
              CustomTextFormField(
                controller: _priceController,
                label: 'Harga',
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Wajib diisi';
                  final parsed = double.tryParse(value);
                  if (parsed == null || parsed <= 0) return 'Harga tidak valid';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Stok
              CustomTextFormField(
                controller: _stockController,
                label: 'Stok',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Wajib diisi';
                  final parsed = int.tryParse(value);
                  if (parsed == null || parsed < 0) return 'Stok tidak valid';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              //status
              DropdownButtonFormField<String>(
                value: _status,
                items: const [
                  DropdownMenuItem(value: 'tersedia', child: Text('Tersedia')),
                  DropdownMenuItem(value: 'habis', child: Text('Habis')),
                  DropdownMenuItem(value: 'ditarik', child: Text('Di Tarik')),
                ],
                onChanged: (value) {
                  setState(() {
                    _status = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Status'),
              ),
              const SizedBox(height: 24),

              // Tombol Simpan
              ElevatedButton.icon(
                onPressed: _submitForm,
                icon: const Icon(Icons.save),
                label: const Text('Simpan'),
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final item = ItemRequestModel(
        name: _nameController.text.trim(),
        description: _descController.text.trim(),
        price: double.tryParse(_priceController.text.trim()),
        stock: int.tryParse(_stockController.text.trim()),
        status: _status,
      );

      context.read<ItemsBloc>().add(AddItem(itemRequestModel: item));
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }
}
