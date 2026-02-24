import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ohana_kiosk/main.dart';
import 'package:ohana_kiosk/models/dog_profile.dart';
import 'package:ohana_kiosk/screens/kiosk_screen.dart';
import 'package:ohana_kiosk/theme/app_theme.dart';
import 'package:ohana_kiosk/widgets/dog_profile_card.dart';
import 'package:ohana_kiosk/widgets/emergency_contact_button.dart';
import 'package:ohana_kiosk/widgets/ohana_animation_widget.dart';
import 'package:ohana_kiosk/widgets/welcome_bubble.dart';

void main() {
  group('AppColors', () {
    test('has correct ocean blue value', () {
      expect(AppColors.oceanBlue, const Color(0xFF1A6B8A));
    });

    test('has correct coral value', () {
      expect(AppColors.coral, const Color(0xFFE85D3A));
    });

    test('has correct seafoam value', () {
      expect(AppColors.seafoam, const Color(0xFF4CAF7D));
    });
  });

  group('DogProfile model', () {
    const profile = DogProfile(
      id: '1',
      name: 'Anubis',
      ownerName: 'The Carter Family',
      breed: 'German Shepherd',
    );

    test('copyWith updates isCheckedIn', () {
      final updated = profile.copyWith(isCheckedIn: true);
      expect(updated.isCheckedIn, isTrue);
      expect(updated.name, equals(profile.name));
      expect(updated.id, equals(profile.id));
    });

    test('default isCheckedIn is false', () {
      expect(profile.isCheckedIn, isFalse);
    });

    test('kDefaultDogProfiles contains expected dogs', () {
      final names = kDefaultDogProfiles.map((p) => p.name).toList();
      expect(names, containsAll(['Anubis', 'Rex', 'Buddies']));
      expect(kDefaultDogProfiles.length, greaterThan(3));
    });
  });

  group('OhanaState enum', () {
    test('has all three required states', () {
      expect(OhanaState.values, containsAll([
        OhanaState.idleSitting,
        OhanaState.walkingForward,
        OhanaState.turningAround,
      ]));
    });
  });

  group('WelcomeBubble widget', () {
    testWidgets('displays the provided message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WelcomeBubble(message: 'Hello, world!'),
          ),
        ),
      );
      expect(find.text('Hello, world!'), findsOneWidget);
    });

    testWidgets('updates when message changes', (tester) async {
      String msg = 'First message';
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) => Column(
                children: [
                  WelcomeBubble(message: msg),
                  ElevatedButton(
                    onPressed: () => setState(() => msg = 'Second message'),
                    child: const Text('Change'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('First message'), findsOneWidget);
      await tester.tap(find.text('Change'));
      await tester.pumpAndSettle();
      expect(find.text('Second message'), findsOneWidget);
    });
  });

  group('DogProfileCard widget', () {
    testWidgets('shows dog name and breed', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.theme,
          home: Scaffold(
            body: DogProfileCard(
              profile: const DogProfile(
                id: '1',
                name: 'Rex',
                ownerName: 'The Thompson Family',
                breed: 'Labrador Retriever',
              ),
              onCheckIn: () {},
            ),
          ),
        ),
      );
      expect(find.text('Rex'), findsOneWidget);
      expect(find.text('Labrador Retriever'), findsOneWidget);
    });

    testWidgets('shows Check In button when not checked in', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.theme,
          home: Scaffold(
            body: DogProfileCard(
              profile: const DogProfile(
                id: '2',
                name: 'Luna',
                ownerName: 'The Kim Family',
                breed: 'Border Collie',
              ),
              onCheckIn: () {},
            ),
          ),
        ),
      );
      expect(find.text('Check In'), findsOneWidget);
      expect(find.text('Checked In'), findsNothing);
    });

    testWidgets('shows Checked In badge when already checked in',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.theme,
          home: Scaffold(
            body: DogProfileCard(
              profile: const DogProfile(
                id: '3',
                name: 'Mochi',
                ownerName: 'The Nguyen Family',
                breed: 'Shiba Inu',
                isCheckedIn: true,
              ),
              onCheckIn: () {},
            ),
          ),
        ),
      );
      expect(find.text('Checked In'), findsOneWidget);
      expect(find.text('Check In'), findsNothing);
    });

    testWidgets('calls onCheckIn callback when button tapped', (tester) async {
      bool called = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.theme,
          home: Scaffold(
            body: DogProfileCard(
              profile: const DogProfile(
                id: '4',
                name: 'Daisy',
                ownerName: 'The Johnson Family',
                breed: 'Beagle',
              ),
              onCheckIn: () => called = true,
            ),
          ),
        ),
      );
      await tester.tap(find.text('Check In'));
      await tester.pump();
      expect(called, isTrue);
    });
  });

  group('EmergencyContactButton widget', () {
    testWidgets('renders and shows Emergency Contact label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.theme,
          home: const Scaffold(
            body: EmergencyContactButton(),
          ),
        ),
      );
      expect(find.text('Emergency Contact'), findsOneWidget);
    });

    testWidgets('shows dialog when tapped without custom handler',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.theme,
          home: const Scaffold(
            body: EmergencyContactButton(),
          ),
        ),
      );
      await tester.tap(find.text('Emergency Contact'));
      await tester.pumpAndSettle();
      // Dialog should appear
      expect(find.text('Emergency Contact'), findsWidgets);
      expect(find.text('Close'), findsOneWidget);
    });

    testWidgets('calls custom onPressed handler', (tester) async {
      bool called = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.theme,
          home: Scaffold(
            body: EmergencyContactButton(
              onPressed: () => called = true,
            ),
          ),
        ),
      );
      await tester.tap(find.text('Emergency Contact'));
      await tester.pump();
      expect(called, isTrue);
    });
  });

  group('KioskScreen smoke test', () {
    testWidgets('renders without errors', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.theme,
          home: const KioskScreen(),
        ),
      );
      // Allow timers to settle.
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(OhanaAnimationWidget), findsOneWidget);
      expect(find.byType(WelcomeBubble), findsOneWidget);
      expect(find.byType(EmergencyContactButton), findsOneWidget);
    });

    testWidgets('shows all default dog profiles', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.theme,
          home: const KioskScreen(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      for (final profile in kDefaultDogProfiles) {
        expect(find.text(profile.name), findsOneWidget);
      }
    });

    testWidgets('shows Ohana Dog Training header', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.theme,
          home: const KioskScreen(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Ohana Dog Training'), findsOneWidget);
    });

    testWidgets('tapping Check-In triggers animation change', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.theme,
          home: const KioskScreen(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Find and tap the first Check-In button
      final checkInButtons = find.text('Check In');
      expect(checkInButtons, findsWidgets);
      await tester.tap(checkInButtons.first);
      await tester.pump();

      // Ohana should now show walking message
      expect(
        find.text('Here I come! Getting ready for check-in! 🏃'),
        findsOneWidget,
      );
    });
  });

  group('OhanaKioskApp smoke test', () {
    testWidgets('app launches without errors', (tester) async {
      await tester.pumpWidget(const OhanaKioskApp());
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(KioskScreen), findsOneWidget);
    });
  });
}
