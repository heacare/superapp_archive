import 'package:flutter_test/flutter_test.dart';

import 'package:hea/widgets/avatar_icon.dart';

void main() {
  testWidgets('AvatarIcon', (WidgetTester tester) async {
    await tester.pumpWidget(const AvatarIcon());
  });
}
