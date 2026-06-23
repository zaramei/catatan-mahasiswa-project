import 'package:flutter/material.dart';
import '../models/tugas_model.dart';
import '../services/api_service.dart';

class TugasProvider extends ChangeNotifier {
  List<Tugas> _list = [];
  bool _isLoading = false;
  String? _error;

  List<Tugas> get list => _list;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.getTugas();
      _list = response.map((e) => Tugas.fromJson(e)).toList();
    } catch (e) {
      _error = 'Gagal memuat data: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> create(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.createTugas(data);
      if (response.containsKey('tugas')) {
        final newItem = Tugas.fromJson(response['tugas']);
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

  Future<bool> update(int id, Map<String, dynamic> data) async {
    try {
      final response = await ApiService.updateTugas(id, data);
      if (response.containsKey('tugas')) {
        final updated = Tugas.fromJson(response['tugas']);
        final index = _list.indexWhere((item) => item.id == id);
        if (index != -1) {
          _list[index] = updated;
          notifyListeners();
        }
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> delete(int id) async {
    try {
      final response = await ApiService.deleteTugas(id);
      if (response.containsKey('message')) {
        _list.removeWhere((item) => item.id == id);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
