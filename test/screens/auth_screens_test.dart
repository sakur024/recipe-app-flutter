import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/providers/auth_provider.dart';
import 'package:recipe_app/providers/favorites_provider.dart';
import 'package:recipe_app/screens/auth/auth_gate.dart';
import 'package:recipe_app/screens/auth/login_screen.dart';
import 'package:recipe_app/screens/auth/register_screen.dart';

import '../providers/auth_provider_test.dart';

void main() {
  late FakeAuthService fakeService;
  late AuthProvider authProvider;

  setUp(() {
    fakeService = FakeAuthService();
    authProvider = AuthProvider(authService: fakeService);
  });

  tearDown(() {
    authProvider.dispose();
    fakeService.dispose();
  });

  Widget buildTestableWidget(Widget child) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        ChangeNotifierProvider<FavoritesProvider>(
          create: (_) => FavoritesProvider(),
        ),
      ],
      child: MaterialApp(home: child),
    );
  }

  group('Auth Screen Widget Tests', () {
    // 1. Login screen renders.
    testWidgets('Login screen renders branding, fields, and buttons',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(const LoginScreen()));

      expect(find.text('Recipe App'), findsOneWidget);
      expect(find.text('Email Address'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Log In'), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);
    });

    // 2. Register screen renders.
    testWidgets('Register screen renders fields, buttons, and navigation',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(const RegisterScreen()));

      // "Create Account" appears as both heading and button label
      expect(find.text('Create Account'), findsNWidgets(2));
      expect(find.text('Email Address'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
      expect(
        find.widgetWithText(ElevatedButton, 'Create Account'),
        findsOneWidget,
      );
      expect(find.text('Log In'), findsOneWidget);
    });

    // 3. Required-field validation works.
    testWidgets('Required-field validation works on Login screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(const LoginScreen()));

      // Tap Log In without filling fields
      await tester.tap(find.widgetWithText(ElevatedButton, 'Log In'));
      await tester.pump();

      expect(find.text('Please enter your email.'), findsOneWidget);
      expect(find.text('Please enter your password.'), findsOneWidget);
    });

    testWidgets('Required-field validation works on Register screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(const RegisterScreen()));

      // Tap Create Account without filling fields
      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Account'));
      await tester.pump();

      expect(find.text('Please enter your email.'), findsOneWidget);
      expect(find.text('Please enter a password.'), findsOneWidget);
      expect(find.text('Please confirm your password.'), findsOneWidget);
    });

    // 4. Password confirmation validation works.
    testWidgets('Password confirmation validation detects mismatch',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(const RegisterScreen()));

      // Enter valid email
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email Address'),
        'test@example.com',
      );

      // Enter password
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'password123',
      );

      // Enter mismatched confirm password
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm Password'),
        'differentPassword',
      );

      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Account'));
      await tester.pump();

      expect(find.text('Passwords do not match.'), findsOneWidget);
    });

    testWidgets('AuthGate renders LoginScreen when unauthenticated',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(const AuthGate()));

      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.text('Recipe App'), findsOneWidget);
    });

    testWidgets('AuthGate renders MainShell when authenticated',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      // Simulate authenticated user
      await authProvider.login('authenticated@example.com', 'secret123');

      await tester.pumpWidget(buildTestableWidget(const AuthGate()));
      await tester.pumpAndSettle();

      expect(find.byType(MainShell), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Favorites'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Quick & Easy'), findsOneWidget);
    });
  });
}
