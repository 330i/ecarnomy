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

  Future<String> get_fuel_price() async {
    var api_endpoint = Uri.parse("https://fueleconomy.gov/ws/rest/vehicle/${get_id(await get_makes(widget.vin))}");
    print(api_endpoint);
    var response = await http.get(api_endpoint);
    if (response.statusCode != 200) {
      print("Not a good response");
      print(response.body);
      throw InvalidResponse;
    }
    print (response.body);
    var doc = XmlDocument.parse(response.body).getElement("vehicle");
    var gas = doc?.getElement("fuelType");
    if (gas == null) {
      throw InvalidResponse;
    }
    var api_fuel_endpoint = Uri.parse("https://fueleconomy.gov/ws/rest/fuelprices");
    var fuel_response = await http.get(api_fuel_endpoint);
    if (fuel_response.statusCode != 200) {
      print("Not a good response");
      print(fuel_response.body);
      throw InvalidResponse;
    }
    print (fuel_response.body);
    var fuel_doc = XmlDocument.parse(fuel_response.body).getElement("fuelPrices");
    print(gas.innerText.substring(0, gas.innerText.contains(' ') ? gas.innerText.indexOf(' ') : gas.innerText.length).toLowerCase());
    var price = fuel_doc?.getElement(gas.innerText.substring(0, gas.innerText.contains(' ') ? gas.innerText.indexOf(' ') : gas.innerText.length).toLowerCase());
    if (price == null) {
      throw InvalidResponse;
    }
    return price.innerText;
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
                  return Text('Current Fuel Cost ${snapshot.data}');
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

