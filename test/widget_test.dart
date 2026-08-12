import 'package:flutter_test/flutter_test.dart';

import 'package:cg_device_app/screens/splash/splash_screen.dart';

void main() {
  testWidgets('Splash screen renders title and loading text', (WidgetTester tester) async {
    await tester.pumpWidget(const SplashScreen());

    expect(find.text('PORTABLE'), findsOneWidget);
    expect(find.text('LOADING...'), findsOneWidget);
  });
}
