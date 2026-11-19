import 'package:flutter/material.dart';
import 'package:mydj/data/data_provider.dart';
import 'package:mydj/pages/login_page.dart';
import 'package:mydj/pages/simple_home_page.dart';
import 'package:provider/provider.dart';

class StartupPage extends StatefulWidget {
  const StartupPage({super.key});

  @override
  State<StartupPage> createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  bool? _isLoggedIn;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // Ambil instance state management (Provider).
    final DataProvider provider = context.read<DataProvider>();
    // Panggil method pengecekan login dari instance tersebut.
    final bool isLoggedIn = await provider.isLoggedIn();
    // Setelah async, pastikan widget masih ada.
    if (!mounted) return;
    setState(() {
      _isLoggedIn = isLoggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Ketika masih loading, tampilkan spinner.
    if (_isLoggedIn == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Jika user sudah pernah login -> HomePage,
    // jika belum atau sudah logout -> LoginPage.
    return _isLoggedIn!
        ? const SimpleHomePage(title: 'Beranda')
        : const LoginPage();
  }
}
