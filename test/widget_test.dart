import 'package:flutter_test/flutter_test.dart';
import 'package:the_bear/main.dart';

void main() {
  testWidgets('abre o aplicativo', (WidgetTester tester) async {
    await tester.pumpWidget(const TheBearApp());

    expect(find.text('The Bear'), findsOneWidget);
  });
}