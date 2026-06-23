import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/catatan_provider.dart';
import 'catatan_add_screen.dart';
import 'catatan_detail_screen.dart';

class CatatanListScreen extends StatefulWidget {
  const CatatanListScreen({super.key});

  @override
  State<CatatanListScreen> createState() => _CatatanListScreenState();
}

class _CatatanListScreenState extends State<CatatanListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CatatanProvider>().loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CatatanProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Pribadi'),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => provider.loadData(),
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.list.isEmpty
          ? _buildEmptyState()
          : _buildList(provider),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CatatanAddScreen()),
          );
          if (result == true) provider.loadData();
        },
        backgroundColor: const Color(0xFF1A237E),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.note, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Belum ada catatan',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            'Tambahkan dengan tombol +',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildList(CatatanProvider provider) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.list.length,
      itemBuilder: (context, index) {
        final catatan = provider.list[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: Colors.red.shade100,
              child: Icon(Icons.note, color: Colors.red.shade700),
            ),
            title: Text(
              catatan.judul,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              catatan.isiCatatan.length > 50
                  ? '${catatan.isiCatatan.substring(0, 50)}...'
                  : catatan.isiCatatan,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CatatanDetailScreen(catatan: catatan),
                ),
              );
              if (result == true) provider.loadData();
            },
          ),
        );
      },
    );
  }
}
