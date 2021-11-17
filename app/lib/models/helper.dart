enum HelpType { MENTAL, PHYSICAL }

class Helper {
  final String name;
  final String icon;
  final String description;
  final double lat;
  final double lng;
  final HelpType type;

  Helper(
      {required this.name,
      required this.icon,
      required this.description,
      required this.lat,
      required this.lng,
      required this.type});
}
