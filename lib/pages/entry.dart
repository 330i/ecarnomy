import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:tamuhackprojectlol/backend/api.dart';

class Entry extends StatefulWidget {
  const Entry({Key? key}) : super(key: key);

  @override
  _EntryState createState() => _EntryState();
}



class _EntryState extends State<Entry> {
  TextEditingController vinController = TextEditingController();
  TextEditingController milesController = TextEditingController();

  @override
  Widget build(BuildContext context)
  {
    return Material(
      child: Container(
        height: 100,
        width: 400,
        child: Stack(
          children: [
            Container(
              height: 400,
              child: Image.asset(
                'assets/cars.jpg',
                fit: BoxFit.fitHeight,
              ),
            ),
            Container(
              width: 1000,
              height: 400,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter,
                      colors: [
                        Colors.white12,
                        Color.fromRGBO(250, 250, 250, 1)// I don't know what Color this will be, so I can't use this
                      ]
                  )
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 200,
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(30.0, 50, 50, 10),
                    child: Text('Add', style: TextStyle(fontSize: 50.0, fontWeight: FontWeight. bold),),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 10, 30),
                    child: Text('your car', style: TextStyle(fontSize: 30.0, fontWeight: FontWeight. bold),),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Neumorphic(
                      style: const NeumorphicStyle(
                        shape: NeumorphicShape.concave,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width-111,
                              child: TextField(
                                controller: vinController,
                                decoration: const InputDecoration(
                                  hintText: 'Enter VIN',
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 28,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Neumorphic(
                      style: const NeumorphicStyle(
                        shape: NeumorphicShape.concave,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width-111,
                              child: TextField(
                                controller: milesController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: 'Miles per Month',
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: NeumorphicButton(
                          style: NeumorphicStyle(
                            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                            color: const Color.fromRGBO(239, 83, 80, 1),
                          ),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width-96,
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
                            Map<String, String> makeModel = await get_makes(vinController.text);
                            Car selectedCar = await get_car(vinController.text);
                            FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('garage').doc(vinController.text).set({
                              'milage': selectedCar.milage,
                              'permonth': milesController.text,
                              'make': makeModel['Make'],
                              'model': makeModel['Model'],
                              'vin': vinController.text,
                              'year': makeModel['Year'],
                              'fuel': selectedCar.fuel,
                              'insurance': selectedCar.insurance,
                              'maintance': selectedCar.maintance,
                              'total': selectedCar.total,
                              'repairs': selectedCar.repairs,
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ]
            ),
          ],
        ),
      ),
    );
  }

}
