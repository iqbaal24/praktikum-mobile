import 'package:flutter/material.dart';
import 'package:praktikum7/component/password_field.dart';
import 'package:praktikum7/pages/simple_home_page.dart';

class LoginPage extends StatefulWidget {
  final String title = 'MyDJ - Welcome';
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  String namaPengguna = ''; // Menyimpan username
  String sandi = ''; // Menyimpan password

  void login(BuildContext context) {
    if (namaPengguna == 'guru' && sandi == 'guru') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SimpleHomePage(title: 'Beranda'),
        ),
      );
    } else {
      // Opsional: menampilkan pesan jika username/password salah
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
                // Gambar Login
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
                      login(context);
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