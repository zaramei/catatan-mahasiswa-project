<?php

namespace App\Http\Controllers;

use App\Models\Catatan;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class CatatanController extends Controller
{
    public function index(Request $request)
    {
        $catatan = Catatan::where('user_id', $request->user()->id)->get();
        return response()->json($catatan);
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'judul' => 'required|string|max:255',
            'isi_catatan' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $catatan = Catatan::create([
            'user_id' => $request->user()->id,
            'judul' => $request->judul,
            'isi_catatan' => $request->isi_catatan,
        ]);

        return response()->json([
            'catatan' => $catatan,
            'message' => 'Catatan berhasil ditambahkan'
        ], 201);
    }

    public function show($id)
    {
        $catatan = Catatan::findOrFail($id);
        
        if ($catatan->user_id !== auth()->id()) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }
        
        return response()->json($catatan);
    }

    public function update(Request $request, $id)
    {
        $catatan = Catatan::findOrFail($id);
        
        if ($catatan->user_id !== auth()->id()) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $validator = Validator::make($request->all(), [
            'judul' => 'sometimes|string|max:255',
            'isi_catatan' => 'sometimes|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $catatan->update($request->all());

        return response()->json([
            'catatan' => $catatan,
            'message' => 'Catatan berhasil diupdate'
        ]);
    }

    public function destroy($id)
    {
        $catatan = Catatan::findOrFail($id);
        
        if ($catatan->user_id !== auth()->id()) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $catatan->delete();
        return response()->json(['message' => 'Catatan berhasil dihapus']);
    }
}