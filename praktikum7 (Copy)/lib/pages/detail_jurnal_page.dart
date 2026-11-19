import 'package:flutter/material.dart';
import 'package:mydj/data/data_provider.dart';
import 'package:mydj/data/jurnal.dart';
import 'package:mydj/pages/buat_jurnal_page.dart';
import 'package:provider/provider.dart';

class DetailJurnalPage extends StatefulWidget {
  const DetailJurnalPage({super.key, required this.jurnal});

  final Jurnal jurnal;

  @override
  State<DetailJurnalPage> createState() => _DetailJurnalPageState();
}

class _DetailJurnalPageState extends State<DetailJurnalPage> {
  // Mengambil data terbaru dari state global, agar perubahan hasil edit
  // langsung terlihat pada halaman ini. Jika halaman ini dirender tanpa
  // Provider (mis. pada pengujian), data yang awal tetap dipakai.
  Jurnal _jurnalTerbaru() {
    final DataProvider? provider = context.watch<DataProvider?>();
    if (provider == null) return widget.jurnal;

    final List<Jurnal> daftarJurnal = provider.jurnalTersimpan;
    final int? id = widget.jurnal.id;
    if (id == null) return widget.jurnal;
    for (final Jurnal item in daftarJurnal) {
      if (item.id == id) return item;
    }
    return widget.jurnal;
  }

  Future<void> _openEditPage(BuildContext context) async {
    final bool? tersimpan = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => BuatJurnalPage(jurnal: _jurnalTerbaru()),
      ),
    );

    if (tersimpan == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jurnal berhasil diperbarui')),
      );
    }
  }

  Widget _baris(String label, String nilai) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(nilai.isEmpty ? '-' : nilai),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Jurnal jurnal = _jurnalTerbaru();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Jurnal'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _baris('Kelas', jurnal.kelas),
              _baris('Mata Pelajaran', jurnal.mapel),
              _baris('Jam Ke-', jurnal.jam == 0 ? '' : '${jurnal.jam}'),
              _baris('Tujuan Pembelajaran', jurnal.tujuanPembelajaran),
              _baris('Materi / Topik Pembelajaran', jurnal.materiTopikPembelajaran),
              _baris('Kegiatan Pembelajaran', jurnal.kegiatanPembelajaran),
              _baris(
                'Dimensi Profil Pelajar Pancasila',
                jurnal.dimensiProfilPelajarPancasila,
              ),
              _baris('Waktu Dibuat', jurnal.createdAt.toString()),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _openEditPage(context),
                  child: const Text('Edit Jurnal Ini'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
