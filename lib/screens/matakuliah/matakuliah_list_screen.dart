import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/matakuliah_provider.dart';
import 'matakuliah_add_screen.dart';
import 'matakuliah_detail_screen.dart';

class MatakuliahListScreen extends StatefulWidget {
  const MatakuliahListScreen({super.key});

  @override
  State<MatakuliahListScreen> createState() => _MatakuliahListScreenState();
}

class _MatakuliahListScreenState extends State<MatakuliahListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MatakuliahProvider>().loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MatakuliahProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mata Kuliah'),
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
            MaterialPageRoute(
              builder: (context) => const MatakuliahAddScreen(),
            ),
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
          Icon(Icons.book, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Belum ada mata kuliah',
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

  Widget _buildList(MatakuliahProvider provider) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.list.length,
      itemBuilder: (context, index) {
        final mk = provider.list[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: Colors.green.shade100,
              child: Text(
                mk.namaMatakuliah.substring(0, 1).toUpperCase(),
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              mk.namaMatakuliah,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dosen: ${mk.dosen}'),
                Text('${mk.hari} - ${mk.jam} (Ruang: ${mk.ruang})'),
                Text('SKS: ${mk.sks}'),
              ],
            ),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MatakuliahDetailScreen(matakuliah: mk),
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
