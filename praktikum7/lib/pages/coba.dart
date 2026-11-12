import 'package:flutter/material.dart';

class Coba extends StatefulWidget {
  const Coba({super.key, required this.title});

  final String title;

  @override
  State<Coba> createState() => _CobaPageState();
}

class _CobaPageState extends State<Coba> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [],
        ),
      ),
    );
  }
}