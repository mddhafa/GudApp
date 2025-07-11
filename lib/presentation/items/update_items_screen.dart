import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gudapp/data/model/request/items_request_model.dart';
import 'package:gudapp/data/model/response/items_response_model.dart';
import 'package:gudapp/presentation/items/bloc/items_bloc.dart';
import 'package:gudapp/core/extensions/form_text_custom.dart';

class EditItemScreen extends StatefulWidget {
  final ItemsDatum item;

  const EditItemScreen({super.key, required this.item});

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  late String _status;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.name);
    _descController = TextEditingController(text: widget.item.description);
    _priceController = TextEditingController(text: widget.item.price ?? '');
    _stockController = TextEditingController(
      text: widget.item.stock?.toString() ?? '',
    );
    _status = widget.item.status ?? 'tersedia';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Item'),
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
                controller: _nameController,
                label: 'Nama Item',
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                controller: _descController,
                label: 'Deskripsi',
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 12),
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
              ElevatedButton.icon(
                onPressed: _submitForm,
                icon: const Icon(Icons.save),
                label: const Text('Simpan Perubahan'),
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
      final updatedItem = ItemRequestModel(
        name: _nameController.text.trim(),
        description: _descController.text.trim(),
        price: double.tryParse(_priceController.text.trim()),
        stock: int.tryParse(_stockController.text.trim()),
        status: _status,
      );

      context.read<ItemsBloc>().add(
        UpdateItemEvent(id: widget.item.id!, itemRequestModel: updatedItem),
      );

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
