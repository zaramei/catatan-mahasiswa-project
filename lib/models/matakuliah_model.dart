class Matakuliah {
  final int id;
  final String namaMatakuliah;
  final int sks;
  final String dosen;
  final String hari;
  final String jam;
  final String ruang;

  Matakuliah({
    required this.id,
    required this.namaMatakuliah,
    required this.sks,
    required this.dosen,
    required this.hari,
    required this.jam,
    required this.ruang,
  });

  factory Matakuliah.fromJson(Map<String, dynamic> json) {
    return Matakuliah(
      id: json['id'],
      namaMatakuliah: json['nama_matakuliah'],
      sks: json['sks'],
      dosen: json['dosen'],
      hari: json['hari'],
      jam: json['jam'],
      ruang: json['ruang'],
    );
  }

  // Untuk mengirim data ke API (create/update)
  Map<String, dynamic> toJson() {
    return {
      'nama_matakuliah': namaMatakuliah,
      'sks': sks,
      'dosen': dosen,
      'hari': hari,
      'jam': jam,
      'ruang': ruang,
    };
  }
}
