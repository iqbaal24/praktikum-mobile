import 'package:flutter/material.dart';
import 'package:mydj/data/data_provider.dart';
import 'package:mydj/pages/startup_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      // <-- State management global dibungkus di sini.
      create: (context) => DataProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Widget app = MaterialApp(
      title: 'MyDJ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const StartupPage(),
    );

    // Provider sudah tersedia dari main(). Agar MyApp tetap bisa dipakai
    // berdiri sendiri, Provider dibungkus di sini bila belum ada di atasnya.
    if (context.read<DataProvider?>() != null) {
      return app;
    }
    return ChangeNotifierProvider(
      create: (context) => DataProvider(),
      child: app,
    );
  }
}
