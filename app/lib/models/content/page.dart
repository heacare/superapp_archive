class Page {
  final int id;
  final int pageOrder;
  final String title;
  final String text;
  final String icon;

  Page.fromJson(Map<String, dynamic> json)
      : id = json["id"]!,
        pageOrder = json["pageOrder"]!,
        title = json["title"]!,
        text = json["text"]!,
        icon = json["icon"]!;
}
