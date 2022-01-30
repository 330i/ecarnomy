import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
      appBar: AppBar(title: Center(child: Text('Name of App'))),
      body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(50.0, 50, 50, 10),
              child: Text('Hello', style: TextStyle(fontSize: 50.0, fontWeight: FontWeight. bold),),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 30),
              child: Text('Find your car', style: TextStyle(fontSize: 30.0, fontWeight: FontWeight. bold),),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
              child: Entry(),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('Enter your VIN above'),
            ),
          ]
        ),
      ),
      );
  }
}

/*
class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text('Name of App'),
          ),
      body: Column(
        children: <Widget>[
          Text(''),
          Text(''),
          Text('Hello', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight. bold),),
          Text('Find your car', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight. bold),),
        ],
      ),
    );
  }
}
*/

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
    return Container(
      height: 100,
      width: 400,
      child: Center(
        child: TextField(
                  controller: vinController,
        ),
      ),
    );
  }

}


