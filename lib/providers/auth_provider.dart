import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  String? _token;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _token != null;
  String? get error => _error;

  AuthProvider() {
    _loadAuthData();
  }

  // ============ LOAD TOKEN DARI LOCAL STORAGE ============
  Future<void> _loadAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    if (_token != null) {
      try {
        final response = await ApiService.getProfile();
        _user = User.fromJson(response);
      } catch (e) {
        _token = null;
        await prefs.remove('token');
      }
    }
    notifyListeners();
  }

  // ============ REGISTER ============
  Future<bool> register(
    String name,
    String email,
    String password,
    String nim,
    String jurusan,
    int semester,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = {
        'name': name,
        'email': email,
        'password': password,
        'nim': nim,
        'jurusan': jurusan,
        'semester': semester,
      };

      final response = await ApiService.register(data);

      if (response.containsKey('token')) {
        _token = response['token'];
        _user = User.fromJson(response['user']);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response['message'] ?? 'Registrasi gagal';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Terjadi kesalahan: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ============ LOGIN ============
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = {'email': email, 'password': password};

      final response = await ApiService.login(data);

      if (response.containsKey('token')) {
        _token = response['token'];
        _user = User.fromJson(response['user']);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response['message'] ?? 'Login gagal';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Terjadi kesalahan: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ============ UPDATE PROFILE ============
  Future<bool> updateProfile(Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.updateProfile(data);
      if (response.containsKey('user')) {
        _user = User.fromJson(response['user']);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response['message'] ?? 'Update profil gagal';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Terjadi kesalahan: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ============ UPLOAD FOTO ============
  Future<bool> uploadFoto(String path) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.uploadFoto(path);
      if (response.containsKey('user')) {
        _user = User.fromJson(response['user']);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response['message'] ?? 'Upload foto gagal';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Terjadi kesalahan: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ============ LOGOUT ============
  Future<void> logout() async {
    await ApiService.logout();
    _token = null;
    _user = null;
    notifyListeners();
  }
}
