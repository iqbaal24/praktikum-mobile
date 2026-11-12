import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple
      ),
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget{
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState(){
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage>
{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('profil saya')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("masukkan nama anda"),
            TextField(
              maxLines: 3,
              decoration:  InputDecoration(
                border : OutlineInputBorder(),
                labelText : "isikan nama anda di sini"
              )
            ),
          ],
        ),
      ),
    );
  }
}