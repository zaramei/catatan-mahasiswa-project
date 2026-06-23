class Materi {
  final int id;
  final int matakuliahId;
  final String judulMateri;
  final String catatan;
  final String? filePdf;
  final String? namaMatakuliah;

  Materi({
    required this.id,
    required this.matakuliahId,
    required this.judulMateri,
    required this.catatan,
    this.filePdf,
    this.namaMatakuliah,
  });

  factory Materi.fromJson(Map<String, dynamic> json) {
    return Materi(
      id: json['id'],
      matakuliahId: json['matakuliah_id'],
      judulMateri: json['judul_materi'],
      catatan: json['catatan'],
      filePdf: json['file_pdf'],
      namaMatakuliah: json['matakuliah']?['nama_matakuliah'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'matakuliah_id': matakuliahId,
      'judul_materi': judulMateri,
      'catatan': catatan,
    };
  }
}
