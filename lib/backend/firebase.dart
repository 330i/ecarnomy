import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tamuhackprojectlol/backend/api.dart';


class User {
   String email;
   String name;
   String uid;
   late List<Car>? cars;
   User({
   required this.email,
   required this.name,
   required this.uid,
   this.cars
         });
   
   User.fromJson(Map<String, Object?> json)
      : this(
         email: json["email"]! as String,
         name: json["name"]! as String,
         uid: json["uid"]! as String,
            );

   Map<String, Object?> toJson() {
      return {
      "email": email,
      "name": name,
      "uid": uid,
      };
   }
}

Future<User> get_user(String uid) async {
   FirebaseFirestore firestore = FirebaseFirestore.instance;
   CollectionReference users = firestore.collection("users");

   var user_list = await users.where("uid", isEqualTo: uid).limit(1).get();
   var user = user_list.docs[0];
   var user_data = user.data() as Map<String, dynamic>;
   
   var user_obj = User(
         uid: user_data["uid"],
         email: user_data["email"],
         name: user_data["name"]
         );
   print(user_obj);

   var cars_ref = await user.reference.withConverter<Car>(
   fromFirestore: (snapshot, _) => Car.fromJson(snapshot.data()!),
   toFirestore: (car, _) => car.toJson(),
         ).collection("garage");
   var cars = await cars_ref.get();
   print(cars.docs.map((doc) => doc.data()));
   var cars_obj = cars.docs.map((doc) => Car.fromJson(doc.data()));
   print(cars_obj);
   return user_obj;
}

Future<void> add_user(User u) async {
   FirebaseFirestore firestore = FirebaseFirestore.instance;
   CollectionReference users = firestore.collection("users").withConverter<User>(
            fromFirestore: (snapshot, _) => User.fromJson(snapshot.data()!),
            toFirestore: (user, _) => user.toJson()
         );
  await users.add(u);
}

Future<void> add_car(User u, Car c) async {
   FirebaseFirestore firestore = FirebaseFirestore.instance;
   CollectionReference users = firestore.collection("users");
   var user = await users.where("uid", isEqualTo: u.uid).limit(1).get();
   print(user.docs[0].data());
   var ref = await user.docs[0].reference.collection("garage");
   print("eeby deeby");
   print(c.vin);
   print(c.toJson());
   var r = await ref.doc(c.vin);
   print(r);
   await r.set(c.toJson());
}
