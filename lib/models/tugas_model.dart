class Tugas {
  final int id;
  final int matakuliahId;
  final String judulTugas;
  final String catatan;
  final String deadline;
  final String? namaMatakuliah;

  Tugas({
    required this.id,
    required this.matakuliahId,
    required this.judulTugas,
    required this.catatan,
    required this.deadline,
    this.namaMatakuliah,
  });

  factory Tugas.fromJson(Map<String, dynamic> json) {
    return Tugas(
      id: json['id'],
      matakuliahId: json['matakuliah_id'],
      judulTugas: json['judul_tugas'],
      catatan: json['catatan'],
      deadline: json['deadline'],
      namaMatakuliah: json['matakuliah']?['nama_matakuliah'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'matakuliah_id': matakuliahId,
      'judul_tugas': judulTugas,
      'catatan': catatan,
      'deadline': deadline,
    };
  }
}
