class Module {
  final int id;
  final int moduleOrder;
  final String icon;
  final String title;

  Module.fromJson(Map<String, dynamic> json)
      : id = json["id"]!,
        moduleOrder = json["moduleOrder"]!,
        icon = json["icon"]!,
        title = json["title"]!;
}
