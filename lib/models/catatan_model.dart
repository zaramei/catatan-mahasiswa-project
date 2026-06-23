class Catatan {
  final int id;
  final String judul;
  final String isiCatatan;

  Catatan({required this.id, required this.judul, required this.isiCatatan});

  factory Catatan.fromJson(Map<String, dynamic> json) {
    return Catatan(
      id: json['id'],
      judul: json['judul'],
      isiCatatan: json['isi_catatan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'judul': judul, 'isi_catatan': isiCatatan};
  }
}
