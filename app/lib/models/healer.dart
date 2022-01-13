import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Healer {
  num id;
  String name;
  String description;
  List<Proficiency> proficiencies;
  List<Availability> availabilities;
  LatLng? location;

  Healer.fromJson(Map<String, dynamic> data)
      : id = data["id"]!,
        name = data["name"]! as String,
        description = data["description"]! as String,
        proficiencies = data["proficiencies"]!
        .map((Map<String, dynamic> proficiency) => Proficiency.fromJson(proficiency)).toList(),
        availabilities = data["availabilities"]!.map((Map<String, dynamic> availability) => Availability.fromJson(availability)).toList();
}

class Proficiency {
  String name;
  String description;
  num proficiency;

  Proficiency({required this.name, required this.description, required this.proficiency});

  Proficiency.fromJson(Map<String, dynamic> data)
      : name = data["name"]! as String,
        description = data["description"]! as String,
        proficiency = data["proficiency"]!;
}

class Availability {
  DateTimeRange range;
  bool isHouseVisit;

  Availability({required this.range, required this.isHouseVisit});

  Availability.fromJson(Map<String, dynamic> data)
      : range = DateTimeRange(start: DateTime.parse(data["start"]!), end: DateTime.parse(data["end"]!)),
        isHouseVisit = data["isHouseVisit"]! as bool;
}
