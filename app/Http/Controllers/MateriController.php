<?php

namespace App\Http\Controllers;

use App\Models\Materi;
use App\Models\Matakuliah;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;

class MateriController extends Controller
{
    public function index(Request $request)
    {
        $materi = Materi::with('matakuliah')
            ->where('user_id', $request->user()->id)
            ->get();
        return response()->json($materi);
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'matakuliah_id' => 'required|exists:matakuliah,id',
            'judul_materi' => 'required|string|max:255',
            'catatan' => 'required|string',
            'file_pdf' => 'nullable|file|mimes:pdf|max:5120',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $matakuliah = Matakuliah::findOrFail($request->matakuliah_id);
        if ($matakuliah->user_id !== auth()->id()) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $data = [
            'user_id' => $request->user()->id,
            'matakuliah_id' => $request->matakuliah_id,
            'judul_materi' => $request->judul_materi,
            'catatan' => $request->catatan,
        ];

        if ($request->hasFile('file_pdf')) {
            $file = $request->file('file_pdf');
            $filename = Str::random(20) . '.' . $file->getClientOriginalExtension();
            $path = $file->storeAs('materi_pdf', $filename, 'public');
            $data['file_pdf'] = $path;
        }

        $materi = Materi::create($data);

        return response()->json([
            'materi' => $materi,
            'message' => 'Materi berhasil ditambahkan'
        ], 201);
    }

    public function show($id)
    {
        $materi = Materi::with('matakuliah')->findOrFail($id);
        
        if ($materi->user_id !== auth()->id()) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }
        
        return response()->json($materi);
    }

    public function update(Request $request, $id)
    {
        $materi = Materi::findOrFail($id);
        
        if ($materi->user_id !== auth()->id()) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $validator = Validator::make($request->all(), [
            'matakuliah_id' => 'sometimes|exists:matakuliah,id',
            'judul_materi' => 'sometimes|string|max:255',
            'catatan' => 'sometimes|string',
            'file_pdf' => 'nullable|file|mimes:pdf|max:5120',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $data = $request->except('file_pdf');

        if ($request->hasFile('file_pdf')) {
            if ($materi->file_pdf) {
                \Storage::disk('public')->delete($materi->file_pdf);
            }
            
            $file = $request->file('file_pdf');
            $filename = Str::random(20) . '.' . $file->getClientOriginalExtension();
            $path = $file->storeAs('materi_pdf', $filename, 'public');
            $data['file_pdf'] = $path;
        }

        $materi->update($data);

        return response()->json([
            'materi' => $materi,
            'message' => 'Materi berhasil diupdate'
        ]);
    }

    public function destroy($id)
    {
        $materi = Materi::findOrFail($id);
        
        if ($materi->user_id !== auth()->id()) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        if ($materi->file_pdf) {
            \Storage::disk('public')->delete($materi->file_pdf);
        }

        $materi->delete();
        return response()->json(['message' => 'Materi berhasil dihapus']);
    }
}