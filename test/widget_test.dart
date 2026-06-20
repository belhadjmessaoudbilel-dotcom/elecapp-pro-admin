import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:elecapp_admin/screens/auth/splash_screen.dart';

void main() {
  testWidgets('SplashScreen affiche le logo Elecapp sur fond blanc', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SplashScreen()));

    expect(find.byType(Image), findsOneWidget);
    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(scaffold.backgroundColor, Colors.white);
  });
}
