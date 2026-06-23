import 'package:flutter/material.dart';
import '../models/materi_model.dart';
import '../services/api_service.dart';

class MateriProvider extends ChangeNotifier {
  List<Materi> _list = [];
  bool _isLoading = false;
  String? _error;

  List<Materi> get list => _list;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // ============ LOAD DATA ============
  Future<void> loadData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.getMateri();
      _list = response.map((e) => Materi.fromJson(e)).toList();
    } catch (e) {
      _error = 'Gagal memuat data: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  // ============ CREATE (TANPA PDF) ============
  Future<bool> create(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.createMateri(data);
      if (response.containsKey('materi')) {
        final newItem = Materi.fromJson(response['materi']);
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

  // ============ CREATE DENGAN PDF ============
  Future<bool> createWithPdf(Map<String, dynamic> data, String? pdfPath) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.createMateriWithPdf(data, pdfPath);
      if (response.containsKey('materi')) {
        final newItem = Materi.fromJson(response['materi']);
        _list.add(newItem);
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _error = response['message'] ?? 'Gagal menambahkan materi';
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

  // ============ UPDATE (TANPA PDF) ============
  Future<bool> update(int id, Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.updateMateri(id, data);
      if (response.containsKey('materi')) {
        final updated = Materi.fromJson(response['materi']);
        final index = _list.indexWhere((item) => item.id == id);
        if (index != -1) {
          _list[index] = updated;
          notifyListeners();
        }
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _error = response['message'] ?? 'Gagal update';
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

  // ============ UPDATE DENGAN PDF ============
  Future<bool> updateWithPdf(
    int id,
    Map<String, dynamic> data,
    String? pdfPath,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.updateMateriWithPdf(id, data, pdfPath);
      if (response.containsKey('materi')) {
        final updated = Materi.fromJson(response['materi']);
        final index = _list.indexWhere((item) => item.id == id);
        if (index != -1) {
          _list[index] = updated;
          notifyListeners();
        }
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _error = response['message'] ?? 'Gagal update materi';
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

  // ============ DELETE ============
  Future<bool> delete(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.deleteMateri(id);
      if (response.containsKey('message')) {
        _list.removeWhere((item) => item.id == id);
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _error = response['message'] ?? 'Gagal hapus';
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

  // ============ GET BY ID ============
  Materi? getById(int id) {
    try {
      return _list.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }
}
