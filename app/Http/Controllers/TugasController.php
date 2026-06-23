<?php

namespace App\Http\Controllers;

use App\Models\Tugas;
use App\Models\Matakuliah;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class TugasController extends Controller
{
    public function index(Request $request)
    {
        $tugas = Tugas::with('matakuliah')
            ->where('user_id', $request->user()->id)
            ->get();
        return response()->json($tugas);
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'matakuliah_id' => 'required|exists:matakuliah,id',
            'judul_tugas' => 'required|string|max:255',
            'catatan' => 'required|string',
            'deadline' => 'required|date|after:today',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $matakuliah = Matakuliah::findOrFail($request->matakuliah_id);
        if ($matakuliah->user_id !== auth()->id()) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $tugas = Tugas::create([
            'user_id' => $request->user()->id,
            'matakuliah_id' => $request->matakuliah_id,
            'judul_tugas' => $request->judul_tugas,
            'catatan' => $request->catatan,
            'deadline' => $request->deadline,
        ]);

        return response()->json([
            'tugas' => $tugas,
            'message' => 'Tugas berhasil ditambahkan'
        ], 201);
    }

    public function show($id)
    {
        $tugas = Tugas::with('matakuliah')->findOrFail($id);
        
        if ($tugas->user_id !== auth()->id()) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }
        
        return response()->json($tugas);
    }

    public function update(Request $request, $id)
    {
        $tugas = Tugas::findOrFail($id);
        
        if ($tugas->user_id !== auth()->id()) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $validator = Validator::make($request->all(), [
            'matakuliah_id' => 'sometimes|exists:matakuliah,id',
            'judul_tugas' => 'sometimes|string|max:255',
            'catatan' => 'sometimes|string',
            'deadline' => 'sometimes|date|after:today',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $tugas->update($request->all());

        return response()->json([
            'tugas' => $tugas,
            'message' => 'Tugas berhasil diupdate'
        ]);
    }

    public function destroy($id)
    {
        $tugas = Tugas::findOrFail($id);
        
        if ($tugas->user_id !== auth()->id()) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $tugas->delete();
        return response()->json(['message' => 'Tugas berhasil dihapus']);
    }
}