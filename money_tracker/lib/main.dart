import 'package:flutter/material.dart';
void main() => runApp(const MoneyTrackerApp());

class MoneyTrackerApp extends StatelessWidget {
  const MoneyTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class Transaksi {
  final String id;
  final String judul;
  final String kategori;
  final double jumlah;
  final bool pemasukan;
  final DateTime tanggal;

  Transaksi({
    required this.id,
    required this.judul,
    required this.kategori,
    required this.jumlah,
    required this.pemasukan,
    required this.tanggal,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'judul': judul,
    'kategori': kategori,
    'jumlah': jumlah,
    'pemasukan': pemasukan,
    'tanggal': tanggal.toIso8601String(),
  };

  factory Transaksi.fromJson(Map<String, dynamic> j) => Transaksi(
    id: j['id'],
    judul: j['judul'],
    kategori: j['kategori'],
    jumlah: (j['jumlah'] as num).toDouble(),
    pemasukan: j['pemasukan'],
    tanggal: DateTime.parse(j['tanggal']),
  );
}

String rupiah(double v) {
  final s = v.abs().round().toString();
  final b = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
    b.write(s[i]);
  }
  return 'Rp ${v < 0 ? '-' : ''}$b';
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _kunci = 'data_transaksi';
  List<Transaksi> _data = [];

  @override
  void initState() {
    super.initState();
    _muat();
  }

  Future<void> _muat() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kunci);
    if (raw != null) {
      final list = (jsonDecode(raw) as List)
          .map((e) => Transaksi.fromJson(e as Map<String, dynamic>))
          .toList();
      setState(() => _data = list);
    }
  }

  Future<void> _simpan() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _kunci, jsonEncode(_data.map((e) => e.toJson()).toList()));
  }

  double get _pemasukan =>
      _data.where((t) => t.pemasukan).fold(0.0, (a, t) => a + t.jumlah);
  double get _pengeluaran =>
      _data.where((t) => !t.pemasukan).fold(0.0, (a, t) => a + t.jumlah);

  void _tambah(Transaksi t) {
    setState(() {
      _data.insert(0, t);
      _data.sort((a, b) => b.tanggal.compareTo(a.tanggal));
    });
    _simpan();
  }

  void _hapus(Transaksi t) {
    setState(() => _data.removeWhere((e) => e.id == t.id));
    _simpan();
  }

  void _bukaForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => FormTransaksi(onSimpan: _tambah),
    );
  }

  @override
  Widget build(BuildContext context) {
    final saldo = _pemasukan - _pengeluaran;
    return Scaffold(
      appBar: AppBar(title: const Text('Money Tracker')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _bukaForm,
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
      body: Column(
        children: [
          _kartuSaldo(saldo),
          Expanded(
            child: _data.isEmpty
                ? const Center(child: Text('Belum ada transaksi'))
                : ListView.builder(
              padding: const EdgeInsets.only(bottom: 90),
              itemCount: _data.length,
              itemBuilder: (_, i) => _itemTransaksi(_data[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _kartuSaldo(double saldo) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      color: cs.primaryContainer,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('Saldo'),
            const SizedBox(height: 4),
            Text(rupiah(saldo),
                style: const TextStyle(
                    fontSize: 30, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                    child: _ringkasan('Pemasukan', _pemasukan,
                        Icons.arrow_downward, Colors.green)),
                Expanded(
                    child: _ringkasan('Pengeluaran', _pengeluaran,
                        Icons.arrow_upward, Colors.red)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _ringkasan(String label, double nilai, IconData ikon, Color warna) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(ikon, color: warna),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12)),
            Text(rupiah(nilai),
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }

  Widget _itemTransaksi(Transaksi t) {
    final warna = t.pemasukan ? Colors.green : Colors.red;
    final d = t.tanggal;
    return Dismissible(
      key: ValueKey(t.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _hapus(t),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: warna.withOpacity(0.15),
          child: Icon(
              t.pemasukan ? Icons.arrow_downward : Icons.arrow_upward,
              color: warna),
        ),
        title: Text(t.judul),
        subtitle: Text('${t.kategori} • ${d.day}/${d.month}/${d.year}'),
        trailing: Text(
          '${t.pemasukan ? '+' : '-'} ${rupiah(t.jumlah)}',
          style: TextStyle(color: warna, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class FormTransaksi extends StatefulWidget {
  final void Function(Transaksi) onSimpan;
  const FormTransaksi({super.key, required this.onSimpan});

  @override
  State<FormTransaksi> createState() => _FormTransaksiState();
}

class _FormTransaksiState extends State<FormTransaksi> {
  final _judul = TextEditingController();
  final _jumlah = TextEditingController();
  bool _pemasukan = false;
  String _kategori = 'Makanan';
  String? _error;

  static const _kategoriKeluar = [
    'Makanan', 'Transport', 'Belanja', 'Tagihan', 'Hiburan', 'Lainnya'
  ];
  static const _kategoriMasuk = ['Gaji', 'Bonus', 'Uang Saku', 'Lainnya'];

  List<String> get _daftarKategori =>
      _pemasukan ? _kategoriMasuk : _kategoriKeluar;

  @override
  void dispose() {
    _judul.dispose();
    _jumlah.dispose();
    super.dispose();
  }

  void _simpan() {
    final judul = _judul.text.trim();
    final jumlah = double.tryParse(_jumlah.text.replaceAll('.', ''));
    if (judul.isEmpty || jumlah == null || jumlah <= 0) {
      setState(() => _error = 'Isi keterangan dan nominal dengan benar');
      return;
    }
    widget.onSimpan(Transaksi(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      judul: judul,
      kategori: _kategori,
      jumlah: jumlah,
      pemasukan: _pemasukan,
      tanggal: DateTime.now(),
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          16, 0, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: false, label: Text('Pengeluaran')),
                ButtonSegment(value: true, label: Text('Pemasukan')),
              ],
              selected: {_pemasukan},
              onSelectionChanged: (s) => setState(() {
                _pemasukan = s.first;
                _kategori = _daftarKategori.first;
              }),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _judul,
              decoration: const InputDecoration(
                  labelText: 'Keterangan', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _jumlah,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: 'Nominal',
                  prefixText: 'Rp ',
                  border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _kategori,
              decoration: const InputDecoration(
                  labelText: 'Kategori', border: OutlineInputBorder()),
              items: _daftarKategori
                  .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                  .toList(),
              onChanged: (v) => setState(() => _kategori = v!),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                  onPressed: _simpan, child: const Text('Simpan')),
            ),
          ],
        ),
      ),
    );
  }
}