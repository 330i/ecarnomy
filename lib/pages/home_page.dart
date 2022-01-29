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
        child: Container(
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
                children: <Widget>[
                  Container(
                    width: 200,
                    height: 200,
                    child: Card(),
                  ),
                ]
              )
            ]
          ),
        ),
      ),
    );
  }

  Widget Card() {
    return Padding(
      padding: const EdgeInsets.all(22.0),
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: 4,
          shape: NeumorphicShape.concave,
        ),
        child: Center(
          child: Column(
            children: [
              Container(
                height: 15,
              ),
              Text(
                'This Week',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Container(
                height: 15,
              ),
              Container(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
