class User {
  final int? id;
  final String nama;
  final String nik;
  final String email;
  final String telepon;
  final String alamat;
  final String username;
  final String password;

  User({
    this.id,
    required this.nama,
    required this.nik,
    required this.email,
    required this.telepon,
    required this.alamat,
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'nik': nik,
      'email': email,
      'telepon': telepon,
      'alamat': alamat,
      'username': username,
      'password': password,
    };
  }
}
