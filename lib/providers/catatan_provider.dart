import 'package:flutter/material.dart';
import '../models/catatan_model.dart';
import '../services/api_service.dart';

class CatatanProvider extends ChangeNotifier {
  List<Catatan> _list = [];
  bool _isLoading = false;
  String? _error;

  List<Catatan> get list => _list;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.getCatatan();
      _list = response.map((e) => Catatan.fromJson(e)).toList();
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
      final response = await ApiService.createCatatan(data);
      if (response.containsKey('catatan')) {
        final newItem = Catatan.fromJson(response['catatan']);
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
      final response = await ApiService.updateCatatan(id, data);
      if (response.containsKey('catatan')) {
        final updated = Catatan.fromJson(response['catatan']);
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
      final response = await ApiService.deleteCatatan(id);
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
