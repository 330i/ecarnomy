import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 28.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              const Text(
                'Hello Mark',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                ),
              ),
              ListView(
                children: const <Widget>[
                  Card(
                    child: ListTile(
                      leading: FlutterLogo(size: 72.0),
                      title: Text('Three-line ListTile'),
                      subtitle: Text(
                          'A sufficiently long subtitle warrants three lines.'
                      ),
                      trailing: Icon(Icons.more_vert),
                      isThreeLine: true,
                    ),
                  ),
                ]
              )
            ]
          ),
        ),
      ),
    );
  }
}
