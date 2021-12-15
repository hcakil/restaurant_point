import 'dart:math';

class Location {
  final String id;
  String name;
  String latLng;


  Location(this.id, this.name, this.latLng);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      "latLng": latLng ,

    };
  }

  Location.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        latLng = map["latLng"];




}
