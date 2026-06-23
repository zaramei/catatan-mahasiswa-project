<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('tugas', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->foreignId('matakuliah_id')->constrained('matakuliah')->onDelete('cascade');
            $table->string('judul_tugas');
            $table->text('catatan');
            $table->date('deadline');
            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('tugas');
    }
};