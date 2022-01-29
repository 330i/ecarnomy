import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Name of App',
      home: Column(
          children: <Widget>[
            IntroPage(),
            // Entry(),
          ]
        ),
      );
  }
}

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
              children: <Widget>[
                Text(''),
                Text(''),
                Text('Hello', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight. bold),),
                Text('Find your car', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight. bold),),
              ],
            );
  }
}

class Entry extends StatefulWidget {
  const Entry({Key? key}) : super(key: key);

  @override
  _EntryState createState() => _EntryState();
}



class _EntryState extends State<Entry> {
  TextEditingController vinController = TextEditingController();

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
        body: Center(
          child: Container(
            height: 100,
            child: TextField(
              controller: vinController,
            ),
           ),
        ),
      );
  }

}


