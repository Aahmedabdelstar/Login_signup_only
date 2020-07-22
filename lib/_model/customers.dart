import 'package:firebase_database/firebase_database.dart';

enum Gender { male, female }

class customers {
  String customerID;
  String name;
  String gender;
  String email = "email not provided";
  String phone = "phone not provided";
  String regionID;
  bool isBlocked;
  double customerLat = 1.1;
  double customerLong = 1.1;
  String token ;

  customers({this.name, this.gender, this.email, this.phone, this.regionID,
      this.isBlocked,this.customerLat,this.customerLong,this.token});

  Map toJson() => {
        "name": name,
        "gender": gender,
        "email": email,
        "phone": phone,
        "regionID": regionID,
        "isBlocked": isBlocked,
        "latitude": customerLat,
        "token": token,
        "longitude": customerLong
      };

  customers.fromSnapshot(DataSnapshot snap)
      : this.customerID = snap.key,
        this.name = snap.value["name"],
        this.gender = snap.value["gender"],
        this.email = snap.value["email"],
        this.phone = snap.value["phone"],
        this.isBlocked = snap.value["isBlocked"],
        this.regionID = snap.value["regionID"],
        this.customerLat = snap.value["latitude"],
        this.customerLong = snap.value["longitude"],
        this.token = snap.value["token"];

  customers.fromMap(Map<dynamic, dynamic> value, String key)
      :  this.customerID = key,
        this.name = value["name"],
        this.gender = value["gender"],
        this.email = value["email"],
        this.phone = value["phone"],
        this.isBlocked = value["isBlocked"],
        this.regionID = value["regionID"],
        this.customerLat = value["latitude"],
        this.customerLong = value["longitude"],
        this.token = value["token"];


  Map toMap() {
    return {
      "name": name,
      "gender": gender,
      "email": email,
      "phone": phone,
      "regionID": regionID,
      "isBlocked": isBlocked,
      "latitude": customerLat,
      "longitude": customerLong
    };
  }
}
