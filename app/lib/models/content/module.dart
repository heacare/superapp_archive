class Module {
  final int id;
  final int moduleOrder;
  final String icon;
  final String title;

  Module.fromJson(Map<String, dynamic> json)
      : id = int.parse(json["id"]),
        // TODO Need to rename on backend
        moduleOrder = int.parse(json["unitOrder"]),
        icon = json["icon"]!,
        title = json["title"]!;
}
