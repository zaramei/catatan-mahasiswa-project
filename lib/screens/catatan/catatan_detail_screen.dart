import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/catatan_model.dart';
import '../../providers/catatan_provider.dart';

class CatatanDetailScreen extends StatefulWidget {
  final Catatan catatan;
  const CatatanDetailScreen({super.key, required this.catatan});

  @override
  State<CatatanDetailScreen> createState() => _CatatanDetailScreenState();
}

class _CatatanDetailScreenState extends State<CatatanDetailScreen> {
  bool _isEditing = false;
  final _judulController = TextEditingController();
  final _isiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _judulController.text = widget.catatan.judul;
    _isiController.text = widget.catatan.isiCatatan;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Catatan' : 'Detail Catatan'),
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
                TextFormField(
                  controller: _judulController,
                  decoration: const InputDecoration(
                    labelText: 'Judul',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _isiController,
                  maxLines: 8,
                  decoration: const InputDecoration(
                    labelText: 'Isi Catatan',
                    border: OutlineInputBorder(),
                  ),
                ),
              ] else ...[
                const Text(
                  'Judul',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(widget.catatan.judul),
                const SizedBox(height: 16),
                const Text(
                  'Isi Catatan',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(widget.catatan.isiCatatan),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _save() async {
    final data = {
      'judul': _judulController.text,
      'isi_catatan': _isiController.text,
    };
    final success = await context.read<CatatanProvider>().update(
      widget.catatan.id,
      data,
    );
    if (success && mounted) {
      setState(() => _isEditing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Catatan berhasil diupdate'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Catatan'),
        content: Text('Yakin ingin menghapus "${widget.catatan.judul}"?'),
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
      final success = await context.read<CatatanProvider>().delete(
        widget.catatan.id,
      );
      if (success && mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Catatan berhasil dihapus'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }
}
