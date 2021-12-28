class ContentCard {
  final String text;
  final String icon;

  ContentCard({required this.text, required this.icon});

  ContentCard.fromJson(Map<String, dynamic> json) :
        this(
          text: json["text"]! as String,
          icon: json["icon"]! as String,
      );

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'icon': icon,
    };
  }
}