<?php

namespace App\Http\Controllers;

use App\Models\Matakuliah;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class MatakuliahController extends Controller
{
    // GET ALL
    public function index(Request $request)
    {
        $matakuliah = Matakuliah::where('user_id', $request->user()->id)->get();
        return response()->json($matakuliah);
    }

    // CREATE
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'nama_matakuliah' => 'required|string|max:255',
            'sks' => 'required|integer|min:1|max:6',
            'dosen' => 'required|string|max:255',
            'hari' => 'required|string|in:Senin,Selasa,Rabu,Kamis,Jumat,Sabtu,Minggu',
            'jam' => 'required|date_format:H:i',
            'ruang' => 'required|string|max:100',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $matakuliah = Matakuliah::create([
            'user_id' => $request->user()->id,
            'nama_matakuliah' => $request->nama_matakuliah,
            'sks' => $request->sks,
            'dosen' => $request->dosen,
            'hari' => $request->hari,
            'jam' => $request->jam,
            'ruang' => $request->ruang,
        ]);

        return response()->json([
            'matakuliah' => $matakuliah,
            'message' => 'Mata kuliah berhasil ditambahkan'
        ], 201);
    }

    // GET BY ID
    public function show($id)
    {
        $matakuliah = Matakuliah::findOrFail($id);
        
        if ($matakuliah->user_id !== auth()->id()) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }
        
        return response()->json($matakuliah);
    }

    // UPDATE
    public function update(Request $request, $id)
    {
        $matakuliah = Matakuliah::findOrFail($id);
        
        if ($matakuliah->user_id !== auth()->id()) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $validator = Validator::make($request->all(), [
            'nama_matakuliah' => 'sometimes|string|max:255',
            'sks' => 'sometimes|integer|min:1|max:6',
            'dosen' => 'sometimes|string|max:255',
            'hari' => 'sometimes|string|in:Senin,Selasa,Rabu,Kamis,Jumat,Sabtu,Minggu',
            'jam' => 'sometimes|date_format:H:i',
            'ruang' => 'sometimes|string|max:100',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $matakuliah->update($request->all());

        return response()->json([
            'matakuliah' => $matakuliah,
            'message' => 'Mata kuliah berhasil diupdate'
        ]);
    }

    // DELETE
    public function destroy($id)
    {
        $matakuliah = Matakuliah::findOrFail($id);
        
        if ($matakuliah->user_id !== auth()->id()) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $matakuliah->delete();
        return response()->json(['message' => 'Mata kuliah berhasil dihapus']);
    }
}