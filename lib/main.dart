import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  return const MaterialApp(
    title: 'Name of App',
   home: IntroPage(),
    );
  }
}

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
               Intro(),
              dropDown(),

            ]
        )
    );
  }

  Widget Intro() {
    return Container(
        child: Column(
          children: <Widget>[
            Text('Hello!'),
            Text('Find your car'),
          ],
        )
    );
  }

  Widget dropDown() {
    String dropdownValue = 'Tesla';
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
          // print(dropdownValue);
        });
      },
      items: <String>[
        'Any Make',
        'AC',
        'Acura',
        'Alfra Romeo',
        'Allard',
        'AMC',
        'AM General',
        'Ariel',
        'Aston Martin',
        'Auburn',
        'Audi',
        'Austin',
        'Austin-Healey',
        'Avanti Motors',
        'Bently',
        'BMW',
        'Bugatti',
        'Buick',
        'Cadillac',
        'Checker',
        'Chevrolet',
        'Chrysler',
        'Citroen',
        'Daewoo',
        'Daihatsu',
        'Datsun',
        'Delahaye',
        'DeLorean',
        'Desoto',
        'DeTomaso',
        'Dodge',
        'Eagle',
        'Edsel',
        'Essex',
        'Ferrari',
        'Fiat',
        'Fisker',
        'Ford',
        'Franklin',
        'Freightliner',
        'Genesis',
        'Geo',
        'GMC',
        'Hino',
        'Honda',
        'Hudson',
        'HUMMER',
        'Hupmobile',
        'Hyundai',
        'Infiniti',
        'International',
        'Intl. Harvester',
        'Isuzu',
        'Jaguar',
        'Jeep',
        'Jensen',
        'Kaiser',
        'Karma',
        'Kia',
        'Koenigsegg',
        'Lamborghini',
        'Lancia',
        'Land Rover',
        'LaSalle',
        'Lexus',
        'Lincoln',
        'Lotus',
        'Maserati',
        'Maybach',
        'Mazda',
        'McLaren',
        'Mercedes-Benz',
        'Mercury',
        'Merkur',
        'MG',
        'MINI',
        'Mitsubishi',
        'Morgan',
        'Morris',
        'Nash',
        'Nissan',
        'Oldsmobile',
        'Opel',
        'Packard',
        'Pagani',
        'Panoz',
        'Peugeot',
        'Plymouth',
        'Pontiac',
        'Porsche',
        'Qvale',
        'RAM',
        'Renault',
        'Rolls-Royce',
        'Rover',
        'Saab',
        'Saleen',
        'Saturn',
        'Scion',
        'Shelby',
        'smart',
        'Spyker',
        'Sterling',
        'Studebaker',
        'Subaru',
        'Sunbeam',
        'Suzuki',
        'Tesla'
      ]
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
