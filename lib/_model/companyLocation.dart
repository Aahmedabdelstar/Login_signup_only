import 'package:firebase_database/firebase_database.dart';

class companyLocation {

  double companyLatitude;
  double companyLongitude;



  companyLocation(this.companyLatitude, this.companyLongitude,);


  companyLocation.fromMap(Map<dynamic , dynamic> value , String key)
      : this.companyLatitude = value["latitude"],
        this.companyLongitude = value["longitude"];

  companyLocation.fromSnapshot(DataSnapshot snap)
      : this.companyLatitude = snap.value["latitude"],
        this.companyLongitude = snap.value["longitude"];

}
