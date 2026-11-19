class Jurnal {
  int? id;
  final DateTime _createdAt;
  String kelas;
  String mapel;
  int jam;
  String tujuanPembelajaran;
  String materiTopikPembelajaran;
  String kegiatanPembelajaran;
  String dimensiProfilPelajarPancasila;

  Jurnal({
    this.id,
    this.kelas = '',
    this.mapel = '',
    this.jam = 0,
    this.tujuanPembelajaran = '',
    this.materiTopikPembelajaran = '',
    this.kegiatanPembelajaran = '',
    this.dimensiProfilPelajarPancasila = '',
    DateTime? createdAt,
  }) : _createdAt = createdAt ?? DateTime.now();

  DateTime get createdAt => _createdAt;

  // Objek -> Map (untuk disimpan ke tabel).
  Map<String, dynamic> toMap() => {
        'id': id,
        'kelas': kelas,
        'mapel': mapel,
        'jam': jam,
        'tujuanPembelajaran': tujuanPembelajaran,
        'materiTopikPembelajaran': materiTopikPembelajaran,
        'kegiatanPembelajaran': kegiatanPembelajaran,
        'dimensiProfilPelajarPancasila': dimensiProfilPelajarPancasila,
        'createdAt': _createdAt.toIso8601String(),
      };

  // Map (baris tabel) -> Objek.
  factory Jurnal.fromMap(Map<String, dynamic> map) => Jurnal(
        id: map['id'],
        kelas: map['kelas'],
        mapel: map['mapel'],
        jam: map['jam'],
        tujuanPembelajaran: map['tujuanPembelajaran'],
        materiTopikPembelajaran: map['materiTopikPembelajaran'],
        kegiatanPembelajaran: map['kegiatanPembelajaran'],
        dimensiProfilPelajarPancasila: map['dimensiProfilPelajarPancasila'],
        createdAt: DateTime.parse(map['createdAt']),
      );
}
