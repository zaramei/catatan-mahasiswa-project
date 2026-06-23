import 'package:flutter/material.dart';
import '../models/matakuliah_model.dart';
import '../services/api_service.dart';

class MatakuliahProvider extends ChangeNotifier {
  List<Matakuliah> _list = [];
  bool _isLoading = false;
  String? _error;

  List<Matakuliah> get list => _list;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // ============ LOAD DATA ============
  Future<void> loadData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.getMatakuliah();
      _list = response.map((e) => Matakuliah.fromJson(e)).toList();
    } catch (e) {
      _error = 'Gagal memuat data: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  // ============ CREATE ============
  Future<bool> create(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.createMatakuliah(data);
      if (response.containsKey('matakuliah')) {
        final newItem = Matakuliah.fromJson(response['matakuliah']);
        _list.add(newItem);
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _error = response['message'] ?? 'Gagal menambahkan';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Error: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ============ UPDATE ============
  Future<bool> update(int id, Map<String, dynamic> data) async {
    try {
      final response = await ApiService.updateMatakuliah(id, data);
      if (response.containsKey('matakuliah')) {
        final updated = Matakuliah.fromJson(response['matakuliah']);
        final index = _list.indexWhere((item) => item.id == id);
        if (index != -1) {
          _list[index] = updated;
          notifyListeners();
        }
        return true;
      }
      return false;
    } catch (e) {
      print('Error updating: $e');
      return false;
    }
  }

  // ============ DELETE ============
  Future<bool> delete(int id) async {
    try {
      final response = await ApiService.deleteMatakuliah(id);
      if (response.containsKey('message')) {
        _list.removeWhere((item) => item.id == id);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Error deleting: $e');
      return false;
    }
  }
}
