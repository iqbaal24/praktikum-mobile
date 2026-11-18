import 'package:flutter/material.dart';

class LihatJurnalPage extends StatefulWidget {
  const LihatJurnalPage({super.key});

  final String title = 'lihat jurnal';

  @override
  State<LihatJurnalPage> createState() {
    return _LihatJurnalPageState();
  }
}

class _LihatJurnalPageState extends State<LihatJurnalPage> 
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
              itemBuilder: (context, index) => ListTile(
              title: Text('Judul Indeks ke-$index'),
              subtitle: Text('Sub-judul Indeks ke-$index'),
              trailing: Text('Trailing Indeks ke-$index'),
              onTap: () {},
              ),
              separatorBuilder: (context, index) => const Divider(),
              itemCount: 20, // Jumlah baris kita set manual dulu..
              ),
            ),
          ],
        ),
      )
    );
  }
}
