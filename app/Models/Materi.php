<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Materi extends Model
{
    use HasFactory;

    
    protected $table = 'materi';  // ← PENTING! Memberi tahu Laravel nama tabel yang benar
    
    protected $fillable = [
        'user_id',
        'matakuliah_id',
        'judul_materi',
        'catatan',
        'file_pdf'
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function matakuliah()
    {
        return $this->belongsTo(Matakuliah::class);
    }
}