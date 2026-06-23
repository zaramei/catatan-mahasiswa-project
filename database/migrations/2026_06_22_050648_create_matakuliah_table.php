<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('matakuliah', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->string('nama_matakuliah');
            $table->integer('sks');
            $table->string('dosen');
            $table->string('hari');
            $table->time('jam');
            $table->string('ruang');
            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('matakuliah');
    }
};