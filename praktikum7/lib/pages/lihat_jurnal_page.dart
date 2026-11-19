import 'package:flutter/material.dart';
import 'package:mydj/data/data_provider.dart';
import 'package:mydj/data/jurnal.dart';
import 'package:provider/provider.dart';

class LihatJurnalPage extends StatefulWidget {
  const LihatJurnalPage({super.key});

  final String title = 'Lihat Jurnal';

  @override
  State<LihatJurnalPage> createState() {
    return _LihatJurnalPageState();
  }
}

class _LihatJurnalPageState extends State<LihatJurnalPage> {
  @override
  void initState() {
    super.initState();
    // Muat jurnal dari SQLite sekali saja saat halaman dibuka.
    context.read<DataProvider>().muatJurnal();
  }

  @override
  Widget build(BuildContext context) {
    // context.watch() -> membaca data dari state global (Provider).
    final List<Jurnal> daftarJurnal = context.watch<DataProvider>().jurnalTersimpan;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: daftarJurnal.isEmpty
                  ? const Center(
                      child: Text(
                        'Belum ada jurnal tersimpan.\n'
                        'Buat jurnal terlebih dahulu pada halaman "Buat Jurnal".',
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.separated(
                      itemBuilder: (context, index) => ListTile(
                        title: Text(daftarJurnal[index].kelas),
                        subtitle: Text(
                          '${daftarJurnal[index].mapel}\n${daftarJurnal[index].createdAt}',
                        ),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            context
                                .read<DataProvider>()
                                .hapusJurnal(daftarJurnal[index].id!);
                          },
                        ),
                        onTap: () {},
                      ),
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: daftarJurnal.length,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
