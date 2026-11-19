import 'package:flutter/material.dart';
import 'package:mydj/components/media_selector.dart';
import 'package:mydj/data/data_provider.dart';
import 'package:mydj/data/jurnal.dart';
import 'package:provider/provider.dart';

class BuatJurnalPage extends StatefulWidget {
  const BuatJurnalPage({super.key});

  final String title = 'Buat Jurnal';

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

  // Fungsi _textArea: dekomposisi widget input teks banyak (multi-baris).
  Widget _textArea(
    String label,
    String hint,
    void Function(String text) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 10),
        TextField(
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

  // Menyimpan jurnal ke SQLite melalui DataProvider.
  Future<void> _saveJurnal(BuildContext context) async {
    final Jurnal jurnal = Jurnal(
      kelas: kelas,
      mapel: mapel,
      jam: jamKe,
      tujuanPembelajaran: tujuanPembelajaran,
      materiTopikPembelajaran: materiTopikPembelajaran,
      kegiatanPembelajaran: kegiatanPembelajaran,
      dimensiProfilPelajarPancasila: dimensiProfilPelajarPancasila,
    );

    // context.read() -> menyimpan data ke state global.
    final DataProvider provider = context.read<DataProvider>();
    // Simpan ke SQLite lewat Provider.
    await provider.tambahJurnal(jurnal);

    // BuildContext dipakai setelah operasi async, jadi harus dicek dulu.
    if (context.mounted) {
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
                (text) => tujuanPembelajaran = text,
              ),
              const SizedBox(height: 10),
              _textArea(
                'Materi/Topik Pembelajaran',
                'Masukkan Materi/Topik Pembelajaran',
                (text) => materiTopikPembelajaran = text,
              ),
              const SizedBox(height: 10),
              _textArea(
                'Kegiatan Pembelajaran',
                'Masukkan Kegiatan Pembelajaran',
                (text) => kegiatanPembelajaran = text,
              ),
              const SizedBox(height: 10),
              _textArea(
                'Dimensi Profil Pelajar Pancasila',
                'Tuliskan Dimensi Profil Pelajar Pancasila',
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
