class Mahasiswa {
  final String nama;
  final String nim;
  String? uid;

  Mahasiswa({this.uid, required this.nama, required this.nim});

  factory Mahasiswa.fromJson(Map<String, dynamic> data) {
    return Mahasiswa(nama: data['nama'] ?? "", nim: data['nim'] ?? "");
  }

  toJson() {
    return {"nama": nama, "nim": nim};
  }
}
