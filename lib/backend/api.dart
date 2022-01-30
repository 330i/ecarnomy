import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import 'dart:convert';

class Car {
   final String model;
   final String make;
   final String vin;
   final int year;

   final List<dynamic> insurance;
   final List<dynamic> maintance;
   final List<dynamic> repairs;
   final List<dynamic> fuel;
   final List<dynamic> total;
   final int milage;
   Car({
      required this.make,
      required this.model,
      required this.year,
      required this.vin,

      required this.insurance, 
      required this.maintance,
      required this.repairs,
      required this.fuel, 
      required this.total,
      required this.milage
   });

   Map<String, Object?> toJson() {
      return {
         "vin": vin,
         "make": make,
         "model": model,
         "year": year,
         "insurance": insurance,
         "maintance": maintance,
         "repairs": repairs,
         "fuel": fuel,
         "total": total,
         "milage": milage
      };
   }
   Car.fromJson(Map<String, Object?> json) : this(
            make: json["make"]! as String,
            model: json["model"]! as String,
            year: json["year"]! as int,
            insurance: json["insurance"]! as List<dynamic>,
            maintance: json["maintance"]! as List<dynamic>,
            repairs: json["repairs"]! as List<dynamic>,
            fuel: json["fuel"]! as List<dynamic>,
            total: json["total"]! as List<dynamic>,
            milage: json["milage"]! as int,
            vin: json["vin"]! as String,
            );
}

class NotGoodMap implements Exception {
   String cause;
   NotGoodMap(this.cause);
}
class InvalidResponse implements Exception {
   String cause;
   InvalidResponse(this.cause);
}


Future<Map<String, String>> get_makes(String vin) async {
   var vin_api = Uri.parse("https://vpic.nhtsa.dot.gov/api/vehicles/decodevin/${vin}?format=json");
   var response = await http.get(vin_api);
   if (response.statusCode != 200) {
      print("Not a good response");
      print(response.body);
      throw InvalidResponse;
   }

   var vininfo = jsonDecode(response.body);
   var results = vininfo["Results"].where((d) => ["Make", "Model", "Model Year"].contains(d["Variable"]));
   Map<String, String> makes = {};
   for (var d in results) {
      makes[d["Variable"]] = d["Value"];
   }
   return makes;
}

Future<String> get_id(Map<String, String> m) async {

   if (m["Make"] == null && m["Model Year"] == null && m["Model"] == null)
      throw NotGoodMap;
   var id_api = Uri.parse("https://www.fueleconomy.gov/ws/rest/vehicle/menu/make?year=${m["Model Year"]}");

   var response = await http.get(id_api);
   if (response.statusCode != 200) {
      print("Not a good responseonse");
      print(response.body);
      throw InvalidResponse;
   }
   var doc = XmlDocument.parse(response.body);
   if (doc == null)
      throw InvalidResponse;
   var choices = doc.getElement("menuItems")?.findElements("menuItem");
   var textual = choices?.map((d) => d.getElement("value")?.text);
   print(textual); 
   var found = textual?.where((d) => d?.toLowerCase() == m["Make"]?.toLowerCase()).toList();
   if (found == null) 
      throw InvalidResponse;
   var make = found[0];
   print(make);

   var mod_api = Uri.parse("https://www.fueleconomy.gov/ws/rest/vehicle/menu/model?year=${m["Model Year"]}&make=${make}");
   print(mod_api);
   var m_response = await http.get(mod_api);
   if (m_response.statusCode != 200) {
      print("Not a good responseonse");
      print(m_response.body);
      throw InvalidResponse;
   }
   print(m_response.body);
   var m_doc = XmlDocument.parse(m_response.body).getElement("menuItems")?.findElements("menuItem");
   var text = m_doc?.map((d) => d.getElement("value")?.text);
   if (text == null)
      throw InvalidResponse;
   for(var t in text)
      print(t);
   var found_m = text.where((d) => d?.toLowerCase() == m["Model"]?.toLowerCase()).toList();
   print(found_m);
   var model = found_m[0];

   var opt_api = Uri.parse("https://www.fueleconomy.gov/ws/rest/vehicle/menu/options?year=${m["Model Year"]}&make=${make}&model=${model}");
   var opt_req = await http.get(opt_api);
   if (opt_req.statusCode != 200) {
      print("Invalid response");
      print(opt_req.body);
      throw InvalidResponse;
   }
   
   var opt_doc = XmlDocument.parse(opt_req.body).getElement("menuItems")?.getElement("menuItem");
   var id = opt_doc?.getElement("value")?.text;
   return id ?? "";
}
//TODO: Pass a state code
Future<Car> get_car(String vin) async {
   var cost_api = Uri.parse("https://ownershipcost.vinaudit.com/getownershipcost.php?vin=${vin}&key=VA_DEMO_KEY&state=TX");
   var resp = await http.get(cost_api);
   if (resp.statusCode != 200) {
      print("Not a good response");
      print(resp.body);
      throw InvalidResponse;
   }
   var data = jsonDecode(resp.body);
   var makes = await get_makes(vin);
   var id = await get_id(makes);
   var gas = await get_fuel(id);
   print(data);
   return Car(
      vin: vin,
      make: makes["Make"] ?? "",
      model: makes["Model"] ?? "",
      year: int.parse(makes["Model Year"] ?? ""),
      insurance: data["insurance_cost"],
      maintance: data["maintenance_cost"],
      repairs: data["repairs_cost"],
      fuel: data["fuel_cost"],
      total: data["total_cost"],
      milage: gas["milage"],
   );
}

Future<Map<String, dynamic>> get_fuel(String id) async {
   var api_endpoint = Uri.parse("https://fueleconomy.gov/ws/rest/vehicle/${id}");
   print(api_endpoint);
   var response = await http.get(api_endpoint);
   if (response.statusCode != 200) {
      print("Not a good response");
      print(response.body);
      throw InvalidResponse;
   }
   print (response.body);
   var doc = XmlDocument.parse(response.body).getElement("vehicle");
   var mpg = doc?.getElement("highway08");
   if (mpg == null) {
      throw InvalidResponse;
   }
   Map<String, dynamic> data = {};
   data["milage"] = int.parse(mpg.text);
   return data;
}