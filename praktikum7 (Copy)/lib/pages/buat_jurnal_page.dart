import 'package:flutter/material.dart';
import 'package:mydj/components/media_selector.dart';
import 'package:mydj/data/data_provider.dart';
import 'package:mydj/data/jurnal.dart';
import 'package:provider/provider.dart';

class BuatJurnalPage extends StatefulWidget {
  // Jurnal yang akan diedit. Jika null, halaman ini dipakai untuk membuat
  // jurnal baru.
  final Jurnal? jurnal;

  const BuatJurnalPage({super.key, this.jurnal});

  bool get modeEdit => jurnal != null;

  String get title => modeEdit ? 'Edit Jurnal' : 'Buat Jurnal';

  @override
  State<BuatJurnalPage> createState() {
    return _BuatJurnalPageState();
  }
}

class _BuatJurnalPageState extends State<BuatJurnalPage> {
  // State untuk menampung isian dari semua widget input.
  String kelas = '';
  String mapel = '';
  int jamKe = 0;
  String tujuanPembelajaran = '';
  String materiTopikPembelajaran = '';
  String kegiatanPembelajaran = '';
  String dimensiProfilPelajarPancasila = '';

  // Controller dipakai agar isian dapat diisi otomatis saat halaman edit
  // dibuka (pre-fill).
  late final TextEditingController _kelasController;
  late final TextEditingController _mapelController;
  late final TextEditingController _tujuanController;
  late final TextEditingController _materiController;
  late final TextEditingController _kegiatanController;
  late final TextEditingController _dimensiController;

  // Nilai awal dropdown, hanya dibaca sekali oleh DropdownButtonFormField.
  late final String? _jamAwal;

  @override
 void initState() {
    super.initState();
    final Jurnal? jurnal = widget.jurnal;

    _kelasController = TextEditingController(text: jurnal?.kelas ?? '');
    _mapelController = TextEditingController(text: jurnal?.mapel ?? '');
    _tujuanController =
        TextEditingController(text: jurnal?.tujuanPembelajaran ?? '');
    _materiController =
        TextEditingController(text: jurnal?.materiTopikPembelajaran ?? '');
    _kegiatanController =
        TextEditingController(text: jurnal?.kegiatanPembelajaran ?? '');
    _dimensiController =
        TextEditingController(text: jurnal?.dimensiProfilPelajarPancasila ?? '');

    kelas = jurnal?.kelas ?? '';
    mapel = jurnal?.mapel ?? '';
    jamKe = jurnal?.jam ?? 0;
    tujuanPembelajaran = jurnal?.tujuanPembelajaran ?? '';
    materiTopikPembelajaran = jurnal?.materiTopikPembelajaran ?? '';
    kegiatanPembelajaran = jurnal?.kegiatanPembelajaran ?? '';
    dimensiProfilPelajarPancasila = jurnal?.dimensiProfilPelajarPancasila ?? '';

    _jamAwal = (jurnal?.jam ?? 0) > 0 ? '${jurnal!.jam}' : null;
  }

  @override
  void dispose() {
    _kelasController.dispose();
    _mapelController.dispose();
    _tujuanController.dispose();
    _materiController.dispose();
    _kegiatanController.dispose();
    _dimensiController.dispose();
    super.dispose();
  }

  // Fungsi _textArea: dekomposisi widget input teks banyak (multi-baris).
  Widget _textArea(
    String label,
    String hint,
    TextEditingController controller,
    void Function(String text) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: hint,
          ),
          maxLines: 4,
          onChanged: onChanged,
        ),
      ],
    );
  }

  // Menyimpan jurnal baru (CREATE) atau memperbarui jurnal yang ada (UPDATE).
  Future<void> _saveJurnal(BuildContext context) async {
    final Jurnal jurnal = Jurnal(
      id: widget.jurnal?.id,
      kelas: kelas,
      mapel: mapel,
      jam: jamKe,
      tujuanPembelajaran: tujuanPembelajaran,
      materiTopikPembelajaran: materiTopikPembelajaran,
      kegiatanPembelajaran: kegiatanPembelajaran,
      dimensiProfilPelajarPancasila: dimensiProfilPelajarPancasila,
      // Saat mengubah, waktu dibuat tetap memakai waktu awal.
      createdAt: widget.jurnal?.createdAt,
    );

    // context.read() -> menyimpan data ke state global.
    final DataProvider provider = context.read<DataProvider>();

    if (widget.modeEdit) {
      // UPDATE: baris yang sudah ada diperbarui, bukan menambah baris baru.
      await provider.ubahJurnal(jurnal);
    } else {
      // CREATE: simpan jurnal baru ke SQLite.
      await provider.tambahJurnal(jurnal);
    }

    // BuildContext dipakai setelah operasi async, jadi harus dicek dulu.
    if (!context.mounted) return;

    if (widget.modeEdit) {
      // Kembali ke halaman detail jurnal.
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jurnal berhasil disimpan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Kelas:'),
              const SizedBox(height: 10), // Jeda 10 jarak
              TextField(
                controller: _kelasController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Masukkan Kelas',
                ),
                onChanged: (value) => {
                  setState(() {
                    kelas = value;
                  }),
                },
              ),

              const SizedBox(height: 10), // Beri 10 unit jarak dari komponen di atasnya
              Text('Nama Mapel'),
              const SizedBox(height: 10),
              TextField(
                controller: _mapelController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Masukkan Nama Mapel',
                ),
                onChanged: (value) => {
                  setState(() {
                    mapel = value;
                  }),
                },
              ),

              const SizedBox(height: 10), // Beri 10 unit jarak dari komponen di atasnya
              Text('Jam Ke-'),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(), // garis tepi
                  labelText: 'Pilih Jam',
                ),
                initialValue: _jamAwal,
                items: [
                  const DropdownMenuItem(value: '1', child: Text('1')),
                  const DropdownMenuItem(value: '2', child: Text('2')),
                  const DropdownMenuItem(value: '3', child: Text('3')),
                  const DropdownMenuItem(value: '4', child: Text('4')),
                  const DropdownMenuItem(value: '5', child: Text('5')),
                  const DropdownMenuItem(value: '6', child: Text('6')),
                  const DropdownMenuItem(value: '7', child: Text('7')),
                  const DropdownMenuItem(value: '8', child: Text('8')),
                ],
                onChanged: (value) => {
                  setState(() {
                    jamKe = int.tryParse(value ?? '0') ?? 0;
                  }),
                },
              ),

              const SizedBox(height: 10),
              _textArea(
                'Tujuan Pembelajaran',
                'Masukkan Tujuan Pembelajaran',
                _tujuanController,
                (text) => tujuanPembelajaran = text,
              ),
              const SizedBox(height: 10),
              _textArea(
                'Materi/Topik Pembelajaran',
                'Masukkan Materi/Topik Pembelajaran',
                _materiController,
                (text) => materiTopikPembelajaran = text,
              ),
              const SizedBox(height: 10),
              _textArea(
                'Kegiatan Pembelajaran',
                'Masukkan Kegiatan Pembelajaran',
                _kegiatanController,
                (text) => kegiatanPembelajaran = text,
              ),
              const SizedBox(height: 10),
              _textArea(
                'Dimensi Profil Pelajar Pancasila',
                'Tuliskan Dimensi Profil Pelajar Pancasila',
                _dimensiController,
                (text) => dimensiProfilPelajarPancasila = text,
              ),

              const SizedBox(height: 10),
              Text('Foto Kegiatan'),
              const SizedBox(height: 10),
              const MediaSelector(), // MediaSelector untuk foto.
              const SizedBox(height: 10),
              Text('Video Kegiatan'),
              const SizedBox(height: 10),
              const MediaSelector(
                mediaType: MediaType.video,
              ), // MediaSelector untuk video.

              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => {_saveJurnal(context)},
                  child: const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
