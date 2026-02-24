import 'dart:async';
import 'package:flutter/material.dart';
import '../models/dog_profile.dart';
import '../theme/app_theme.dart';
import '../widgets/dog_profile_card.dart';
import '../widgets/emergency_contact_button.dart';
import '../widgets/ohana_animation_widget.dart';
import '../widgets/welcome_bubble.dart';

/// Welcome messages that rotate while Ohana is idle.
const List<String> _kWelcomeMessages = [
  'Woof! Welcome to Ohana Dog Training! 🐾',
  'Ready for today\'s session? Tap Check-In! 🎾',
  'Ohana means family — and you\'re part of ours! 🏡',
  'Sit, stay, and let\'s get started! 🐶',
  'Your pup\'s big day starts right here! ✨',
];

class KioskScreen extends StatefulWidget {
  const KioskScreen({super.key});

  @override
  State<KioskScreen> createState() => _KioskScreenState();
}

class _KioskScreenState extends State<KioskScreen> {
  OhanaState _ohanaState = OhanaState.idleSitting;
  int _welcomeIndex = 0;
  late Timer _welcomeTimer;
  Timer? _idleReturnTimer;
  List<DogProfile> _profiles = List.from(kDefaultDogProfiles);

  @override
  void initState() {
    super.initState();
    _startWelcomeCycle();
  }

  void _startWelcomeCycle() {
    _welcomeTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (_ohanaState == OhanaState.idleSitting && mounted) {
        setState(() {
          _welcomeIndex =
              (_welcomeIndex + 1) % _kWelcomeMessages.length;
        });
      }
    });
  }

  /// Called when a dog's Check-In button is tapped.
  void _onCheckIn(DogProfile profile) {
    setState(() {
      _ohanaState = OhanaState.walkingForward;
      _welcomeIndex = 0; // Use a dedicated "great to see you" message set
    });

    // After walking animation, turn around and sit back
    _idleReturnTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _ohanaState = OhanaState.turningAround);
      Timer(const Duration(seconds: 1), () {
        if (!mounted) return;
        setState(() {
          _ohanaState = OhanaState.idleSitting;
          // Mark the dog as checked in
          _profiles = _profiles.map((p) {
            return p.id == profile.id ? p.copyWith(isCheckedIn: true) : p;
          }).toList();
        });
      });
    });
  }

  @override
  void dispose() {
    _welcomeTimer.cancel();
    _idleReturnTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sand,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ─────────────────────────────────────────────────────
            const _KioskHeader(),
            // ── Ohana + Welcome bubble ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: OhanaAnimationWidget(
                state: _ohanaState,
                size: 240,
              ),
            ),
            const SizedBox(height: 8),
            WelcomeBubble(
              message: _buildWelcomeMessage(),
            ),
            const SizedBox(height: 16),
            // ── Dog profile list ────────────────────────────────────────────
            Expanded(
              child: _DogProfileList(
                profiles: _profiles,
                onCheckIn: _onCheckIn,
              ),
            ),
            // ── Emergency Contact ───────────────────────────────────────────
            const EmergencyContactButton(),
          ],
        ),
      ),
    );
  }

  String _buildWelcomeMessage() {
    switch (_ohanaState) {
      case OhanaState.walkingForward:
        return 'Here I come! Getting ready for check-in! 🏃';
      case OhanaState.turningAround:
        return 'Almost there… just turning around! 🔄';
      case OhanaState.idleSitting:
        return _kWelcomeMessages[_welcomeIndex];
    }
  }
}

class _KioskHeader extends StatelessWidget {
  const _KioskHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.oceanBlue,
        boxShadow: [
          BoxShadow(
            color: AppColors.oceanBlue.withOpacity(0.30),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Text('🐾', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Ohana Dog Training',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.white,
                  letterSpacing: 0.2,
                ),
              ),
              Text(
                'San Diego, CA — Check-In Kiosk',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Spacer(),
          const _LiveClock(),
        ],
      ),
    );
  }
}

/// A live digital clock shown in the kiosk header.
class _LiveClock extends StatefulWidget {
  const _LiveClock();

  @override
  State<_LiveClock> createState() => _LiveClockState();
}

class _LiveClockState extends State<_LiveClock> {
  late Timer _timer;
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hour = _now.hour % 12 == 0 ? 12 : _now.hour % 12;
    final minute = _now.minute.toString().padLeft(2, '0');
    final period = _now.hour < 12 ? 'AM' : 'PM';
    return Text(
      '$hour:$minute $period',
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.white,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _DogProfileList extends StatelessWidget {
  const _DogProfileList({
    required this.profiles,
    required this.onCheckIn,
  });

  final List<DogProfile> profiles;
  final void Function(DogProfile) onCheckIn;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            "Today's Appointments",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.oceanBlue,
                ),
          ),
        ),
        const SizedBox(height: 6),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 8),
            itemCount: profiles.length,
            itemBuilder: (context, index) {
              final profile = profiles[index];
              return DogProfileCard(
                profile: profile,
                onCheckIn: () => onCheckIn(profile),
              );
            },
          ),
        ),
      ],
    );
  }
}
