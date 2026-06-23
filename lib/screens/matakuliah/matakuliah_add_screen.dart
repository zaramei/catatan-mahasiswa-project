import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/matakuliah_provider.dart';

class MatakuliahAddScreen extends StatefulWidget {
  const MatakuliahAddScreen({super.key});

  @override
  State<MatakuliahAddScreen> createState() => _MatakuliahAddScreenState();
}

class _MatakuliahAddScreenState extends State<MatakuliahAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _sksController = TextEditingController();
  final _dosenController = TextEditingController();
  final _jamController = TextEditingController();
  final _ruangController = TextEditingController();
  String? _selectedHari;
  bool _isLoading = false;

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Mata Kuliah'),
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
                // Nama Matakuliah
                TextFormField(
                  controller: _namaController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Mata Kuliah',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.book),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Nama tidak boleh kosong' : null,
                ),
                const SizedBox(height: 16),

                // SKS
                TextFormField(
                  controller: _sksController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'SKS',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.numbers),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'SKS tidak boleh kosong';
                    final sks = int.tryParse(value!);
                    if (sks == null || sks < 1 || sks > 6)
                      return 'SKS harus 1-6';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Dosen
                TextFormField(
                  controller: _dosenController,
                  decoration: const InputDecoration(
                    labelText: 'Dosen',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) => value?.isEmpty ?? true
                      ? 'Dosen tidak boleh kosong'
                      : null,
                ),
                const SizedBox(height: 16),

                // Hari (Dropdown)
                DropdownButtonFormField<String>(
                  value: _selectedHari,
                  decoration: const InputDecoration(
                    labelText: 'Hari',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  items: _hariList.map((hari) {
                    return DropdownMenuItem<String>(
                      value: hari,
                      child: Text(hari),
                    );
                  }).toList(),
                  validator: (value) => value == null ? 'Pilih hari' : null,
                  onChanged: (value) => setState(() => _selectedHari = value),
                ),
                const SizedBox(height: 16),

                // Jam
                TextFormField(
                  controller: _jamController,
                  decoration: const InputDecoration(
                    labelText: 'Jam (HH:MM)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.access_time),
                    hintText: '08:00',
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Jam tidak boleh kosong';
                    if (!RegExp(r'^\d{2}:\d{2}$').hasMatch(value!)) {
                      return 'Format jam harus HH:MM';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Ruang
                TextFormField(
                  controller: _ruangController,
                  decoration: const InputDecoration(
                    labelText: 'Ruang',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  validator: (value) => value?.isEmpty ?? true
                      ? 'Ruang tidak boleh kosong'
                      : null,
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

  void _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final data = {
      'nama_matakuliah': _namaController.text,
      'sks': int.parse(_sksController.text),
      'dosen': _dosenController.text,
      'hari': _selectedHari!,
      'jam': _jamController.text,
      'ruang': _ruangController.text,
    };

    final success = await context.read<MatakuliahProvider>().create(data);
    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mata kuliah berhasil ditambahkan'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
