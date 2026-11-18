import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/data_provider.dart';
import 'pages/simple_home_page.dart';

void main() {
 runApp(
  ChangeNotifierProvider( 
      create: (context) => DataProvider(),
      child: MyApp(), 
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyDJ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SimpleHomePage(title: 'Jurnal Harian Guru'),
    );
  }
}