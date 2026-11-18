import 'package:flutter/material.dart';
import 'package:praktikum7/component/password_field.dart';

class AkunPage extends StatefulWidget {
  const AkunPage({super.key, required this.title});

  final String title;

  @override
  State<AkunPage> createState() => _AkunPageState();
}

class _AkunPageState extends State<AkunPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
       
      ),
     body: Padding(padding: EdgeInsets.all(20),
     child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ganti sandi', style: TextStyle(
        fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Divider(thickness: 2),
        SizedBox(height: 10),
        Text('sandi saat ini'),
        SizedBox(height: 10),
        PasswordField(), 

        Text('sandi baru'),
        SizedBox(height: 10),
        PasswordField(), 
        SizedBox(height: 10),


        Text('konfirmasi sandi baru'),
        SizedBox(height: 10),
        PasswordField(), 
        SizedBox(height: 10),

        SizedBox(width: double.infinity,
        child: ElevatedButton(
          onPressed: (){

          },
          child: const Text('simpan'),
        ),
      ),
      const Text('keluad dari aplikasi',
      style: TextStyle(fontSize: 18 , fontWeight: FontWeight.bold),
      ),
      const Divider(thickness: 2,),
      const SizedBox(height: 10),

      SizedBox(
        width: double.infinity,
        child: ElevatedButton(onPressed: (){
          Navigator.pop(context);
        },
        child: const Text('keluar'),
        ),
      )
      ],
     ),)
    );
  }
}