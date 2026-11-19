import 'package:flutter/material.dart';
import 'package:mydj/components/password_field.dart';
import 'package:mydj/data/data_provider.dart';
import 'package:mydj/pages/simple_home_page.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  final String title = 'MyDJ - Welcome';

  @override
  State<LoginPage> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  String namaPengguna = ''; // Menyimpan username
  String sandi = ''; // Menyimpan password

  Future<void> _login(BuildContext context) async {
    // Ambil instance Provider (state management) kita dari BuildContext.
    final DataProvider provider = context.read<DataProvider>();

    // Jika username dan password benar..
    if (namaPengguna == 'guru' && sandi == 'guru') {
      // Simpan info login lewat Provider (State Management).
      await provider.saveLoginInfo(namaPengguna, sandi);

      // Jika ingin menggunakan BuildContext dalam operasi async, harus dicek dulu.
      if (context.mounted) {
        // Buka halaman home.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SimpleHomePage(title: 'Beranda'),
          ),
        );
      }
    } else {
      // Menampilkan pesan jika username/password salah.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama pengguna atau sandi salah!')),
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Menampilkan gambar login
                Image.asset('assets/images/login_icon.png', width: 250),
                const SizedBox(height: 15),

                // Judul Log-In
                const Text(
                  'Log-In',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // Bagian Input Nama Pengguna
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Nama Pengguna:'),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          namaPengguna = value;
                        });
                      },
                    ),
                    const SizedBox(height: 15),

                    // Bagian Input Sandi
                    const Text('Sandi:'),
                    const SizedBox(height: 8),
                    PasswordField(
                      onChanged: (value) {
                        setState(() {
                          sandi = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                // Tombol Login
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _login(context);
                    },
                    child: const Text('Login'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
