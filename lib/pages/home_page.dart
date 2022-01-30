import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:tamuhackprojectlol/backend/firebase.dart';
import 'package:tamuhackprojectlol/backend/api.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Object>(
        future: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).get(),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 28.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: [
                        Text(
                          'Hello ${(snapshot.data as DocumentSnapshot)['name']}',
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(
                          flex: 1,
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 500,
                        height: 500,
                        child: ListView(
                          children: const <Widget>[
                            Card(
                              child: ListTile(
                                leading: Icon(Icons.directions_car_rounded, size: 60,),
                                title: Text('Make Model'),
                                subtitle: Text(
                                    '1998 \n\$12/month \n12 MPG'
                                ),
                                isThreeLine: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
          else {
            return const SizedBox(
              width: 50,
              height: 50,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}
