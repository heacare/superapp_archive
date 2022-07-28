import 'package:flutter_test/flutter_test.dart';

import 'package:hea/old/widgets/avatar_icon.dart';

void main() {
  testWidgets('AvatarIcon', (final WidgetTester tester) async {
    await tester.pumpWidget(const AvatarIcon());
  });
}
