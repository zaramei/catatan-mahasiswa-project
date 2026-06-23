import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/materi_provider.dart';
import '../../providers/matakuliah_provider.dart';

class AddMateriScreen extends StatefulWidget {
  // ← UBAH NAMA
  const AddMateriScreen({super.key});

  @override
  State<AddMateriScreen> createState() => _AddMateriScreenState();
}

class _AddMateriScreenState extends State<AddMateriScreen> {
  final _formKey = GlobalKey<FormState>();
  final _judulController = TextEditingController();
  final _catatanController = TextEditingController();
  int? _selectedMatakuliahId;
  String? _pdfPath;
  String? _pdfName;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MatakuliahProvider>().loadData();
    });
  }

  @override
  void dispose() {
    _judulController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final matakuliahProvider = Provider.of<MatakuliahProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Materi'),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Pilih Mata Kuliah
                matakuliahProvider.isLoading
                    ? const CircularProgressIndicator()
                    : DropdownButtonFormField<int>(
                        value: _selectedMatakuliahId,
                        decoration: const InputDecoration(
                          labelText: 'Mata Kuliah',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.book),
                        ),
                        items: matakuliahProvider.list.map((mk) {
                          return DropdownMenuItem<int>(
                            value: mk.id,
                            child: Text(mk.namaMatakuliah),
                          );
                        }).toList(),
                        validator: (value) =>
                            value == null ? 'Pilih mata kuliah' : null,
                        onChanged: (value) =>
                            setState(() => _selectedMatakuliahId = value),
                      ),
                const SizedBox(height: 16),

                // Judul Materi
                TextFormField(
                  controller: _judulController,
                  decoration: const InputDecoration(
                    labelText: 'Judul Materi',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.title),
                  ),
                  validator: (value) => value?.isEmpty ?? true
                      ? 'Judul tidak boleh kosong'
                      : null,
                ),
                const SizedBox(height: 16),

                // Catatan
                TextFormField(
                  controller: _catatanController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Catatan',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.note),
                    alignLabelWithHint: true,
                  ),
                  validator: (value) => value?.isEmpty ?? true
                      ? 'Catatan tidak boleh kosong'
                      : null,
                ),
                const SizedBox(height: 16),

                // Upload PDF
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.picture_as_pdf,
                          color: Colors.red.shade700,
                          size: 30,
                        ),
                        title: Text(
                          _pdfName ?? 'Pilih File PDF',
                          style: TextStyle(
                            color: _pdfName != null
                                ? Colors.black
                                : Colors.grey.shade600,
                          ),
                        ),
                        trailing: _pdfPath != null
                            ? IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _pdfPath = null;
                                    _pdfName = null;
                                  });
                                },
                              )
                            : null,
                        onTap: _pickPdf,
                      ),
                      if (_pdfPath != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: LinearProgressIndicator(
                                  value: 1.0,
                                  backgroundColor: Colors.grey.shade200,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Uploaded',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Tombol Simpan
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A237E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Simpan',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickPdf() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        setState(() {
          _pdfPath = result.files.single.path;
          _pdfName = result.files.single.name;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final data = {
      'matakuliah_id': _selectedMatakuliahId!,
      'judul_materi': _judulController.text,
      'catatan': _catatanController.text,
    };

    final success = await context.read<MateriProvider>().createWithPdf(
      data,
      _pdfPath,
    );
    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Materi berhasil ditambahkan'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.read<MateriProvider>().error ?? 'Gagal menambahkan',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
