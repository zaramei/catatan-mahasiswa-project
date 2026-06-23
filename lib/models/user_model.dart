class User {
  final int id;
  final String name;
  final String email;
  final String nim;
  final String jurusan;
  final int semester;
  final String? foto;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.nim,
    required this.jurusan,
    required this.semester,
    this.foto,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      nim: json['nim'],
      jurusan: json['jurusan'],
      semester: json['semester'],
      foto: json['foto'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'nim': nim,
      'jurusan': jurusan,
      'semester': semester,
    };
  }
}
