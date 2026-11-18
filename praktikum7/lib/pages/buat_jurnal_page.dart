import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class BuatJurnalPage extends StatefulWidget {
  final String title = 'Buat Jurnal';
  const BuatJurnalPage({super.key});
  @override
  State<StatefulWidget> createState() {
    return _BuatJurnalPageState();
  }
}

class _BuatJurnalPageState extends State<BuatJurnalPage> {
  @override
  Widget _textArea(
    String label,
    String hint,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: hint,
          ),
          maxLines: 4,
          onChanged: (value) => {},
        ),
      ],
    );
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
              SizedBox(height: 10),
              _textArea('Tujuan Pembelajaran', 'Masukkan Tujuan Pembelajaran'),
              SizedBox(height: 10),
              _textArea('Materi/Topik Pembelajaran', 'Masukkan Materi/Topik Pembelajaran'),
              SizedBox(height: 10),
              _textArea('Kegiatan Pembelajaran', 'Masukkan Kegiatan Pembelajaran'),
              SizedBox(height: 10),
              _textArea('Dimensi Profil Pelajar Pancasila', 'Tuliskan Dimensi Profil Pelajar Pancasila'),
              SizedBox(height: 10),

              SizedBox(height: 10),
              SizedBox(
                width: double.infinity, 
                child: ElevatedButton( 
                onPressed: () => {}, 
                child: Text('Simpan')
                ),
              ),

              Text('Kelas:'),
              SizedBox(height: 10), // Jeda 10 jarak
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Masukkan Kelas',
                ),
                onChanged: (value) => {},
              ),

              SizedBox(
                height: 10,
              ), // Beri 10 unit jarak dari komponen di atasnya
              Text('Nama Mapel'),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Masukkan Nama Mapel',
                ),
                onChanged: (value) => {},
              ),

              SizedBox(
                height: 10,
              ), // Beri 10 unit jarak dari komponen di atasnya
              Text('Jam Ke-'),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(), // garis tepi
                  labelText: 'Pilih Jam',
                ),
                items: [
                  DropdownMenuItem(value: '1', child: Text('1')),
                  DropdownMenuItem(value: '2', child: Text('2')),
                  DropdownMenuItem(value: '3', child: Text('3')),
                  DropdownMenuItem(value: '4', child: Text('4')),
                  DropdownMenuItem(value: '5', child: Text('5')),
                  DropdownMenuItem(value: '6', child: Text('6')),
                  DropdownMenuItem(value: '7', child: Text('7')),
                  DropdownMenuItem(value: '8', child: Text('8')),
                ],
                onChanged: (value) => {},
              ),

              SizedBox(height: 10),
              Text('Tujuan Pembelajaran'),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Masukkan Tujuan Pembelajaran',
                ),
                maxLines: 4, // Property ini yang menjadikan seperti textarea
                onChanged: (value) => {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
