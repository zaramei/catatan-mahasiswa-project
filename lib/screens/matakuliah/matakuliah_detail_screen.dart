import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/matakuliah_model.dart';
import '../../providers/matakuliah_provider.dart';

class MatakuliahDetailScreen extends StatefulWidget {
  final Matakuliah matakuliah;
  const MatakuliahDetailScreen({super.key, required this.matakuliah});

  @override
  State<MatakuliahDetailScreen> createState() => _MatakuliahDetailScreenState();
}

class _MatakuliahDetailScreenState extends State<MatakuliahDetailScreen> {
  bool _isEditing = false;
  final _namaController = TextEditingController();
  final _sksController = TextEditingController();
  final _dosenController = TextEditingController();
  final _jamController = TextEditingController();
  final _ruangController = TextEditingController();
  String? _selectedHari;

  final List<String> _hariList = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  @override
  void initState() {
    super.initState();
    _namaController.text = widget.matakuliah.namaMatakuliah;
    _sksController.text = widget.matakuliah.sks.toString();
    _dosenController.text = widget.matakuliah.dosen;
    _selectedHari = widget.matakuliah.hari;
    _jamController.text = widget.matakuliah.jam;
    _ruangController.text = widget.matakuliah.ruang;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Mata Kuliah' : 'Detail Mata Kuliah'),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            ),
          if (_isEditing)
            IconButton(icon: const Icon(Icons.save), onPressed: _save),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: _delete,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isEditing) ...[
                _buildTextField('Nama Mata Kuliah', _namaController),
                const SizedBox(height: 16),
                _buildTextField(
                  'SKS',
                  _sksController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                _buildTextField('Dosen', _dosenController),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedHari,
                  decoration: const InputDecoration(
                    labelText: 'Hari',
                    border: OutlineInputBorder(),
                  ),
                  items: _hariList.map((hari) {
                    return DropdownMenuItem<String>(
                      value: hari,
                      child: Text(hari),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedHari = value),
                ),
                const SizedBox(height: 16),
                _buildTextField('Jam (HH:MM)', _jamController),
                const SizedBox(height: 16),
                _buildTextField('Ruang', _ruangController),
              ] else ...[
                _buildDetailRow(
                  'Nama Mata Kuliah',
                  widget.matakuliah.namaMatakuliah,
                ),
                _buildDetailRow('SKS', widget.matakuliah.sks.toString()),
                _buildDetailRow('Dosen', widget.matakuliah.dosen),
                _buildDetailRow('Hari', widget.matakuliah.hari),
                _buildDetailRow('Jam', widget.matakuliah.jam),
                _buildDetailRow('Ruang', widget.matakuliah.ruang),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _save() async {
    final data = {
      'nama_matakuliah': _namaController.text,
      'sks': int.parse(_sksController.text),
      'dosen': _dosenController.text,
      'hari': _selectedHari,
      'jam': _jamController.text,
      'ruang': _ruangController.text,
    };
    final success = await context.read<MatakuliahProvider>().update(
      widget.matakuliah.id,
      data,
    );
    if (success && mounted) {
      setState(() => _isEditing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Berhasil diupdate'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Mata Kuliah'),
        content: Text(
          'Yakin ingin menghapus "${widget.matakuliah.namaMatakuliah}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      final success = await context.read<MatakuliahProvider>().delete(
        widget.matakuliah.id,
      );
      if (success && mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Berhasil dihapus'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }
}
