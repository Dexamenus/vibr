import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vibr/core/models/app_models.dart';
import 'package:vibr/core/state/app_controller.dart';
import 'package:vibr/core/theme/app_theme.dart';
import 'package:vibr/features/auth/auth_screens.dart';
import 'package:vibr/features/comments/comments_screen.dart';
import 'package:vibr/features/shell/home_shell.dart';

void main() {
  testWidgets('renders the SociAI sign-in screen', (WidgetTester tester) async {
    final controller = AppController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_app(SignInScreen(controller: controller)));

    expect(find.text('SociAI'), findsOneWidget);
    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Your next great idea is waiting.'), findsOneWidget);
    expect(find.text('Continue with Facebook'), findsOneWidget);
    expect(find.text('Sign up'), findsOneWidget);
  });

  testWidgets('validates sign-in fields and toggles password visibility', (
    WidgetTester tester,
  ) async {
    final controller = AppController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_app(SignInScreen(controller: controller)));

    await tester.ensureVisible(find.text('Sign In'));
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);

    await tester.ensureVisible(find.byIcon(Icons.visibility_outlined));
    await tester.tap(find.byIcon(Icons.visibility_outlined));
    await tester.pump();

    expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
  });

  testWidgets('signs into the dashboard in demo mode', (
    WidgetTester tester,
  ) async {
    final controller = AppController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_app(SignInScreen(controller: controller)));

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'zahira@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.ensureVisible(find.text('Sign In'));
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Good'), findsOneWidget);
    expect(find.text('Today\'s Schedule'), findsOneWidget);
  });

  testWidgets('sign-up validates required account fields', (
    WidgetTester tester,
  ) async {
    final controller = AppController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_app(SignInScreen(controller: controller)));

    await tester.ensureVisible(find.text('Sign up'));
    await tester.tap(find.text('Sign up'));
    await tester.pumpAndSettle();
    expect(find.text('Create your account'), findsOneWidget);
    await tester.ensureVisible(find.text('Sign Up'));
    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle();

    expect(find.text('Name is required'), findsOneWidget);
    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
  });

  testWidgets('comments can be filtered and marked as handled', (
    WidgetTester tester,
  ) async {
    final controller = AppController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _app(Scaffold(body: CommentsScreen(controller: controller))),
    );
    expect(controller.commentsFor(CommentSentiment.question), hasLength(2));

    await tester.tap(find.byTooltip('Mark as done').first);
    await tester.pumpAndSettle();

    expect(controller.commentsFor(CommentSentiment.question), hasLength(1));
  });

  testWidgets('comments are inside Insights and Profile is the last tab', (
    WidgetTester tester,
  ) async {
    final controller = AppController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_app(HomeShell(controller: controller)));

    final navigationBar = find.byType(NavigationBar);
    await tester.tap(
      find.descendant(of: navigationBar, matching: find.text('Insights')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('Comments'), findsOneWidget);

    await tester.tap(find.text('Comments'));
    await tester.pumpAndSettle();
    expect(find.text('Priority'), findsOneWidget);
    expect(find.textContaining('All'), findsOneWidget);

    await tester.tap(
      find.descendant(of: navigationBar, matching: find.text('Profile')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Profile'), findsNWidgets(2));
    expect(find.text('Appearance'), findsOneWidget);
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Account'), findsOneWidget);
  });

  testWidgets('creates a local post and adds it to the schedule', (
    WidgetTester tester,
  ) async {
    final controller = AppController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_app(HomeShell(controller: controller)));

    await tester.tap(find.text('Create').last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Generate Image + Caption'));
    await tester.tap(find.text('Generate Image + Caption'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextFormField),
      'A violet planet with a mint glow',
    );
    await tester.ensureVisible(find.text('Generate'));
    await tester.tap(find.text('Generate'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pumpAndSettle();

    expect(find.text('Your creation'), findsOneWidget);
    await tester.ensureVisible(find.text('Schedule post'));
    await tester.tap(find.text('Schedule post'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Schedule it'));
    await tester.tap(find.text('Schedule it'));
    await tester.pumpAndSettle();

    expect(controller.posts.length, 4);
    expect(find.text('Schedule'), findsWidgets);
  });
}

Widget _app(Widget home) {
  return MaterialApp(theme: AppTheme.dark, home: home);
}
