<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Catatan extends Model
{
    use HasFactory;
    protected $table = 'catatan';
    protected $fillable = [
        'user_id',
        'judul',
        'isi_catatan'
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}