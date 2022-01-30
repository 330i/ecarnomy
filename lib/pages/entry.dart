import 'package:flutter/material.dart';

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
      child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.fromLTRB(50.0, 50, 50, 10),
              child: Text('Hello', style: TextStyle(fontSize: 50.0, fontWeight: FontWeight. bold),),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 30),
              child: Text('Find your car', style: TextStyle(fontSize: 30.0, fontWeight: FontWeight. bold),),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
              child: Center(
                child: TextField(
                  controller: vinController,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('Enter your VIN above'),
            ),
          ]
      ),
    );
  }

}
