import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:validators/sanitizers.dart';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;
import 'package:validators/validators.dart';
import 'package:tamuhackprojectlol/backend/api.dart';
import 'package:tamuhackprojectlol/stuff/indicator.dart';
import 'package:fl_chart/fl_chart.dart';

import 'dart:convert';

import 'package:flutter/material.dart';

class VehiclePage extends StatefulWidget {
  final String vin;
  const VehiclePage({Key? key, required this.vin}) : super(key: key);

  @override
  _VehiclePageState createState() => _VehiclePageState();
}

class _VehiclePageState extends State<VehiclePage> {
  int touchedIndex = -1;
  bool disp_dep = false;
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
    var api_endpoint = Uri.parse(
        "https://fueleconomy.gov/ws/rest/vehicle/${id}");
    print(api_endpoint);
    var response = await http.get(api_endpoint);
    if (response.statusCode != 200) {
      print("Not a good response");
      print(response.body);
      throw InvalidResponse;
    }
    // We get the type of gas that the car uses so we can get the right price later
    var doc = XmlDocument.parse(response.body).getElement("vehicle");
    var gas = doc
        ?.getElement("fuelType")
        ?.text
        .toLowerCase();
    if (gas == null) {
      throw InvalidResponse;
    }

    var price_endpoint = Uri.parse(
        "https://www.fueleconomy.gov/ws/rest/fuelprices");
    response = await http.get(price_endpoint);
    if (response.statusCode != 200) {
      print("Not a good response");
      print(response.body);
      throw InvalidResponse;
    }
    doc = XmlDocument.parse(response.body).getElement("fuelPrices");
    // This is where we use the type of gas the car uses
    var cost = double.parse(doc
        ?.getElement(gas)
        ?.text ?? "");

    return cost / currentCar.milage;
  }

  @override
  Widget build(BuildContext context) {
    String vin = widget.vin;
    get_this_car().then((car) =>
    {
    });
    return Scaffold(
      backgroundColor: Color.fromRGBO(227, 234, 237, 1),
      body: FutureBuilder<Object>(
        future: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth
            .instance.currentUser?.uid).collection('garage').doc(vin).get(),
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 30,
                      ),
                      Text(
                        '${(snapshot
                            .data as DocumentSnapshot)['make']} ${(snapshot
                            .data as DocumentSnapshot)['model']}',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        height: 6,
                      ),
                      Text(
                        'Monthly Cost',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      AspectRatio(
                        aspectRatio: 1.3,
                        child: Neumorphic(
                          child: Row(
                            children: <Widget>[
                              const SizedBox(
                                height: 18,
                              ),
                              FutureBuilder<Object>(
                                future: get_fuel_price(),
                                builder: (context, fuel_snapshot) {
                                  if (!fuel_snapshot.hasData)
                                    return Text("Loading, please wait");
                                  return Expanded(
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child: PieChart(
                                        PieChartData(
                                            pieTouchData: PieTouchData(
                                                touchCallback:
                                                    (FlTouchEvent event,
                                                    pieTouchResponse) {
                                                  setState(() {
                                                    if (!event
                                                        .isInterestedForInteractions ||
                                                        pieTouchResponse == null ||
                                                        pieTouchResponse
                                                            .touchedSection ==
                                                            null) {
                                                      touchedIndex = -1;
                                                      return;
                                                    }
                                                    touchedIndex = pieTouchResponse
                                                        .touchedSection!
                                                        .touchedSectionIndex;
                                                  });
                                                }),
                                            borderData: FlBorderData(
                                              show: false,
                                            ),
                                            sectionsSpace: 0,
                                            centerSpaceRadius: 40,
                                            sections: showingSections(((snapshot.data as DocumentSnapshot)['maintance'][0] / 12.0).toStringAsFixed(2), ((snapshot.data as DocumentSnapshot)['insurance'][0] / 12.0).toStringAsFixed(2), ((snapshot.data as DocumentSnapshot)['repairs'][0] / 12.0).toStringAsFixed(2), ((fuel_snapshot.data as double) * toDouble(
                                                (snapshot
                                                    .data as DocumentSnapshot)['permonth']))
                                                .toStringAsFixed(2))
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget>[
                                  Indicator(
                                    color: Color.fromRGBO(128, 203, 196, 1),
                                    text: 'Maintenance',
                                    isSquare: true,
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Indicator(
                                    color: Color.fromRGBO(255, 171, 145, 1),
                                    text: 'Insurance',
                                    isSquare: true,
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Indicator(
                                    color: Color.fromRGBO(129, 199, 132, 1),
                                    text: 'Repairs',
                                    isSquare: true,
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Indicator(
                                    color: Color.fromRGBO(220, 231, 117, 1),
                                    text: 'Fuel',
                                    isSquare: true,
                                  ),
                                  SizedBox(
                                    height: 18,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 28,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
               Row(
                     children: <Widget>[
                     Checkbox(
                        value: disp_dep,
                        onChanged: (bool? v) {
                        setState(() {
                           disp_dep = v ?? false;
                              });
                        }
                        ),
                        Text("Include deprecation")
                     ]
                  ),
                FutureBuilder<Object>(
                  future: get_fuel_price(),
                  builder: (context, fuel_snapshot) {
                    if (fuel_snapshot.hasData) {
                      // We want to round the digits to 2, because cents are the smallest unit.
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '*Calculated Fuel Cost \$${(fuel_snapshot
                                .data as double).toStringAsFixed(2)}/mile',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Container(
                            height: 28,
                          ),
                          Text(
                            'Total Monthly Cost',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '\$${((snapshot
                                .data as DocumentSnapshot)['maintance'][0] /
                                12.0 + (snapshot
                                .data as DocumentSnapshot)['repairs'][0] /
                                12.0 + (snapshot
                                .data as DocumentSnapshot)['insurance'][0] /
                                12.0 + (fuel_snapshot.data as double) *
                                toDouble((snapshot
                                    .data as DocumentSnapshot)['permonth']))
                                .toStringAsFixed(2)}/month',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      );
                    }
                    else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<PieChartSectionData> showingSections(String maintenance, String insurance, String repairs, String fuel) {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color.fromRGBO(128, 203, 196, 1),
            value: toDouble(maintenance),
            title: '\$${maintenance}/month',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: const Color.fromRGBO(255, 171, 145, 1),
            value: toDouble(insurance),
            title: '\$${insurance}/month',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: const Color.fromRGBO(129, 199, 132, 1),
            value: toDouble(repairs),
            title: '\$${repairs}/month',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: const Color.fromRGBO(220, 231, 117, 1),
            value: toDouble(fuel),
            title: '\$${fuel}/month',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}
