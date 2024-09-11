import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:codelab1/main.dart'; // Asegúrate de usar la ruta correcta a tu archivo main.dart

void main() {
  testWidgets('MyApp renders correctly', (WidgetTester tester) async {
    // Build the MyApp widget
    await tester.pumpWidget(MyApp());

    // Verify that MyApp contains a MaterialApp
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('App title is correct', (WidgetTester tester) async {
    // Build the MyApp widget
    await tester.pumpWidget(MyApp());

    // Verify that the title is 'Namer App'
    final MaterialApp app = tester.widget(find.byType(MaterialApp));
    expect(app.title, 'Namer App');
  });

  testWidgets('App theme is applied correctly', (WidgetTester tester) async {
    // Build the MyApp widget
    await tester.pumpWidget(MyApp());

    // Verify that the theme is applied correctly
    final MaterialApp app = tester.widget(find.byType(MaterialApp));
    expect(app.theme!.colorScheme.primary, Colors.deepPurple);
  });
}