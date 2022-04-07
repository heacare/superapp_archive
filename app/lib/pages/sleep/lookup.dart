import 'package:hea/screens/error.dart';
import 'package:hea/widgets/page.dart';
import './ch01_introduction.dart';

typedef PageBuilder = Page Function();

class PageDef {
  final PageBuilder builder;
  final Type t;
  PageDef(this.t, this.builder);
}

class Lesson {
  Map<String, PageDef> byKey = {};
  Map<Type, String> byType = {};
  PageDef defaultPage;

  Lesson(List<PageDef> pages) : defaultPage = pages[0] {
    for (var page in pages) {
      byKey[page.t.toString()] = page;
      byType[page.t] = page.t.toString();
    }
  }
  String? rlookup(Type t) {
    return byType[t];
  }

  PageBuilder lookup(String? key) {
    PageBuilder? builder = byKey[key]?.builder;
    if (builder == null) {
      return defaultPage.builder;
    }
    return builder;
  }
}

Lesson sleep = Lesson([
  PageDef(IntroductionWelcome, () => IntroductionWelcome()),
  PageDef(IntroductionGettingToKnowYou, () => IntroductionGettingToKnowYou()),
]);
