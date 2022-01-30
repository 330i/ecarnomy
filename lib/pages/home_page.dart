import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:tamuhackprojectlol/backend/firebase.dart';
import 'package:tamuhackprojectlol/backend/api.dart';
import 'package:tamuhackprojectlol/pages/entry.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';
import 'package:tamuhackprojectlol/pages/vehicle_page.dart';

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
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 28.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: const [
                                      Text(
                                        'Welcome',
                                        style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Spacer(
                                        flex: 1,
                                      )
                                    ],
                                  ),
                                  Text(
                                    'to your garage',
                                    style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                    FutureBuilder<Object>(
                                       future: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('garage').get(),
                                       builder: (context, snap) {
                                       if (snap.hasData) {
                                          var docs = (snap.data as QuerySnapshot).docs;
                                          var costs = docs.map((d) => (d["total"][0]/12.0).toDouble());
                                          double sum = 0;
                                          for (var c in costs)
                                             sum += c;
                                          print(sum);
                                          return Text('Your cars are costing you \$${sum.toStringAsFixed(2)}/month');
                                          } else {
                                             return SizedBox(
                                             width: 100,
                                             height: 100,
                                             child: CircularProgressIndicator()
                                            );
                                          }
                                       }
                                    )
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: FutureBuilder<Object>(
                            future: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('garage').get(),
                            builder: (context, garageSnapshot) {
                              if(garageSnapshot.hasData) {
                                List<QueryDocumentSnapshot> garageData = (garageSnapshot.data as QuerySnapshot).docs;
                                return Container(
                                  height: MediaQuery.of(context).size.height-200,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: garageData.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return TextButton(
                                        onPressed: () {
                                          Navigator.of(context).push(CupertinoPageRoute(builder: (context) => VehiclePage(vin: garageData[index]['vin'])));
                                        },
                                        child: Card(
                                          child: ListTile(
                                            leading: Icon(Icons.directions_car_rounded, size: 60,),
                                            title: Text('${garageData[index]['make']} ${garageData[index]['model']}'),
                                            subtitle: Text(
                                                '${garageData[index]['year']} \n\$${(garageData[index]['total'][0]/12).toStringAsFixed(2)}/month \n${garageData[index]['milage']} MPG'
                                            ),
                                            isThreeLine: true,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }
                              else {
                                return Center(
                                  child: Container(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    Spacer(
                      flex: 1,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: NeumorphicButton(
                            style: NeumorphicStyle(
                              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                              color: const Color.fromRGBO(16, 196, 97, 1.0),
                            ),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width-80,
                              height: 33,
                              child: Row(
                                children: const [
                                  Text(
                                    'Add Vehicle',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Spacer(
                                    flex: 1,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () async {
                              Navigator.of(context).push(CupertinoPageRoute(builder: (context) => const Entry()));
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
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
