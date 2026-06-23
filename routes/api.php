<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\MatakuliahController;
use App\Http\Controllers\MateriController;
use App\Http\Controllers\TugasController;
use App\Http\Controllers\CatatanController;
use Illuminate\Support\Facades\Route;

// ========== ROUTE PUBLIC ==========
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

// ========== ROUTE PROTECTED ==========
Route::middleware('auth:sanctum')->group(function () {
    
    // Auth
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/profile', [AuthController::class, 'profile']);
    Route::put('/profile', [AuthController::class, 'updateProfile']);
    Route::post('/upload-foto', [AuthController::class, 'uploadFoto']);
    
    // Matakuliah
    Route::get('/matakuliah', [MatakuliahController::class, 'index']);
    Route::post('/matakuliah', [MatakuliahController::class, 'store']);
    Route::get('/matakuliah/{id}', [MatakuliahController::class, 'show']);
    Route::put('/matakuliah/{id}', [MatakuliahController::class, 'update']);
    Route::delete('/matakuliah/{id}', [MatakuliahController::class, 'destroy']);
    
    // Materi
    Route::get('/materi', [MateriController::class, 'index']);
    Route::post('/materi', [MateriController::class, 'store']);
    Route::get('/materi/{id}', [MateriController::class, 'show']);
    Route::put('/materi/{id}', [MateriController::class, 'update']);
    Route::delete('/materi/{id}', [MateriController::class, 'destroy']);
    
    // Tugas
    Route::get('/tugas', [TugasController::class, 'index']);
    Route::post('/tugas', [TugasController::class, 'store']);
    Route::get('/tugas/{id}', [TugasController::class, 'show']);
    Route::put('/tugas/{id}', [TugasController::class, 'update']);
    Route::delete('/tugas/{id}', [TugasController::class, 'destroy']);
    
    // Catatan
    Route::get('/catatan', [CatatanController::class, 'index']);
    Route::post('/catatan', [CatatanController::class, 'store']);
    Route::get('/catatan/{id}', [CatatanController::class, 'show']);
    Route::put('/catatan/{id}', [CatatanController::class, 'update']);
    Route::delete('/catatan/{id}', [CatatanController::class, 'destroy']);
});