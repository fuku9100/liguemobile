import 'package:flutter_test/flutter_test.dart';
import 'package:lmdl/main.dart';

void main() {
  testWidgets('MyApp builds correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
await tester.pumpWidget(const MyApp());

    // Verify that our app has a title 'My App'.
    expect(find.text('My App'), findsOneWidget);
  });
}