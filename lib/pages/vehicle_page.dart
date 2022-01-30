import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:validators/sanitizers.dart';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;
import 'package:validators/validators.dart';
import 'package:tamuhackprojectlol/backend/api.dart';

import 'dart:convert';

import 'package:flutter/material.dart';

class VehiclePage extends StatefulWidget {
  final String vin;
  const VehiclePage({Key? key, required this.vin}) : super(key: key);

  @override
  _VehiclePageState createState() => _VehiclePageState();
}

class _VehiclePageState extends State<VehiclePage> {
  late Car currentCar;
  Future get_this_car() async {
    currentCar = await get_car(widget.vin);
  }

  Future<double> get_fuel_price() async {
    // This returns the fuel cost per mile
    // Which should be given by the formula MPG/ Cost of a gallon
    print("getting feul price");
    var id = await get_id(await get_makes(widget.vin));
    print("===");
    print(id);
    print("===");
    var api_endpoint = Uri.parse("https://fueleconomy.gov/ws/rest/vehicle/${id}");
    print(api_endpoint);
    var response = await http.get(api_endpoint);
    if (response.statusCode != 200) {
      print("Not a good response");
      print(response.body);
      throw InvalidResponse;
    }
    // We get the type of gas that the car uses so we can get the right price later
    var doc = XmlDocument.parse(response.body).getElement("vehicle");
    var gas = doc?.getElement("fuelType")?.text.toLowerCase();
    if (gas == null) {
      throw InvalidResponse;
    }

    var price_endpoint = Uri.parse("https://www.fueleconomy.gov/ws/rest/fuelprices");
    response = await http.get(price_endpoint);
    if (response.statusCode != 200) {
      print("Not a good response");
      print(response.body);
      throw InvalidResponse;
    }
    doc = XmlDocument.parse(response.body).getElement("fuelPrices");
    // This is where we use the type of gas the car uses
    var cost = double.parse(doc?.getElement(gas)?.text ?? "");

    return cost / currentCar.milage;
  }

  @override
  Widget build(BuildContext context) {
    String vin = widget.vin;
    get_this_car().then((car) => {

    });
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              height: 500,
              child: FutureBuilder<Object>(
                future: FirebaseFirestore.instance.collection('users').doc('GlkZoRdAhzRgq5yKFybR').collection('garage').doc('1FA6P8TH7G5208997').get(),
                builder: (context, snapshot) {
                  if(snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 30,
                        ),
                        Text(
                          '${(snapshot.data as DocumentSnapshot)['make']} ${(snapshot.data as DocumentSnapshot)['model']}',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          (snapshot.data as DocumentSnapshot)['year'].toString(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),

                        Text(
                          'Monthly Cost',
                        ),
                        Text(
                          'Maintenance',
                        ),
                        Text('${(snapshot.data as DocumentSnapshot)['maintance'][0]/12.0}/month'),
                      ],
                    );
                  }
                  else {
                    return const Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              ),
            ),
            Text('Fuel'),
            FutureBuilder<Object>(
              future: get_fuel_price(),
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  // We want to round the digits to 2, because cents are the smallest unit.
                  return Text('Current Fuel Cost ${(snapshot.data as double).toStringAsFixed(2)}');
                }
                else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

