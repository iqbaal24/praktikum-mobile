import 'package:flutter/material.dart';
import 'package:mydj/components/password_field.dart';
import 'package:mydj/data/login_info.dart';
import 'package:mydj/pages/login_page.dart';

class AkunPage extends StatefulWidget {
  const AkunPage({super.key});

  final String title = 'Akun';

  @override
  State<AkunPage> createState() => _AkunPageState();
}

class _AkunPageState extends State<AkunPage> {
  String sandiSaatIni = '';
  String sandiBaru = '';
  String konfirmasiSandiBaru = '';

  void _simpanSandi(BuildContext context) {
    if (sandiBaru.isEmpty || konfirmasiSandiBaru.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sandi baru dan konfirmasi wajib diisi.')),
      );
      return;
    }

    if (sandiBaru != konfirmasiSandiBaru) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Konfirmasi sandi tidak sama dengan sandi baru.'),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sandi berhasil diperbarui.')),
    );
  }

  // Membuka halaman login.
  void _openLoginPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  // Menghapus info sesi dari Shared Preferences lalu kembali ke halaman login.
  Future<void> _logout(BuildContext context) async {
    await LoginInfo.deleteFromSharedPreferences();
    // BuildContext dipakai setelah operasi async, jadi harus dicek dulu.
    if (!context.mounted) return;
    _openLoginPage(context);
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
              // ----------------- Section Ganti Sandi -----------------
              const Text(
                'Ganti Sandi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(thickness: 2),
              const SizedBox(height: 10),
              const Text('Sandi Saat Ini'),
              const SizedBox(height: 10),
              PasswordField(
                onChanged: (value) => sandiSaatIni = value,
              ),
              const SizedBox(height: 10),
              const Text('Sandi Baru'),
              const SizedBox(height: 10),
              PasswordField(
                onChanged: (value) => sandiBaru = value,
              ),
              const SizedBox(height: 10),
              const Text('Konfirmasi Sandi Baru'),
              const SizedBox(height: 10),
              PasswordField(
                onChanged: (value) => konfirmasiSandiBaru = value,
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => {_simpanSandi(context)},
                  child: const Text('Simpan'),
                ),
              ),

              // ----------------- Section Keluar -----------------
              const SizedBox(height: 20),
              const Text(
                'Keluar dari Aplikasi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(thickness: 2),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    _logout(context);
                  },
                  child: const Text('Keluar dari Aplikasi'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
