import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import '../theme/app_theme.dart';

/// The animation state names that match the Rive file state machine.
enum OhanaState {
  idleSitting,
  walkingForward,
  turningAround,
}

/// Widget that renders the Ohana Rive character animation.
///
/// Ohana is a cute, large-headed Corgi/Border Collie mix.
/// Falls back to a decorative placeholder when the .riv asset is not present.
class OhanaAnimationWidget extends StatefulWidget {
  const OhanaAnimationWidget({
    super.key,
    this.state = OhanaState.idleSitting,
    this.size = 280,
  });

  /// Current animation state.
  final OhanaState state;

  /// Width and height of the animation canvas.
  final double size;

  @override
  State<OhanaAnimationWidget> createState() => _OhanaAnimationWidgetState();
}

class _OhanaAnimationWidgetState extends State<OhanaAnimationWidget> {
  StateMachineController? _controller;
  SMIInput<bool>? _walkInput;
  SMIInput<bool>? _turnInput;

  /// Called when the Rive runtime has initialised the artboard.
  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'OhanaStateMachine',
    );
    if (controller != null) {
      artboard.addController(controller);
      _controller = controller;
      _walkInput =
          controller.findInput<bool>('isWalking') as SMIBool?;
      _turnInput =
          controller.findInput<bool>('isTurning') as SMIBool?;
      _applyState(widget.state);
    }
  }

  void _applyState(OhanaState state) {
    _walkInput?.value = state == OhanaState.walkingForward;
    _turnInput?.value = state == OhanaState.turningAround;
  }

  @override
  void didUpdateWidget(OhanaAnimationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state) {
      _applyState(widget.state);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: _RiveOrFallback(
        onInit: _onRiveInit,
        size: widget.size,
        currentState: widget.state,
      ),
    );
  }
}

/// Tries to load the Rive asset; shows a drawn placeholder on error.
class _RiveOrFallback extends StatefulWidget {
  const _RiveOrFallback({
    required this.onInit,
    required this.size,
    required this.currentState,
  });

  final void Function(Artboard) onInit;
  final double size;
  final OhanaState currentState;

  @override
  State<_RiveOrFallback> createState() => _RiveOrFallbackState();
}

class _RiveOrFallbackState extends State<_RiveOrFallback> {
  // Tri-state: null = loading, true = available, false = missing.
  bool? _assetAvailable;

  static const _kAssetPath = 'assets/animations/ohana.riv';

  @override
  void initState() {
    super.initState();
    _checkAsset();
  }

  Future<void> _checkAsset() async {
    try {
      await rootBundle.load(_kAssetPath);
      if (mounted) setState(() => _assetAvailable = true);
    } catch (_) {
      if (mounted) setState(() => _assetAvailable = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final placeholder =
        _OhanaPlaceholder(size: widget.size, state: widget.currentState);

    // While checking, show the placeholder immediately for snappy UI.
    if (_assetAvailable != true) return placeholder;

    return RiveAnimation.asset(
      _kAssetPath,
      stateMachines: const ['OhanaStateMachine'],
      onInit: widget.onInit,
      fit: BoxFit.contain,
      placeHolder: placeholder,
    );
  }
}

/// SVG-style drawn placeholder used when the .riv file is absent.
class _OhanaPlaceholder extends StatefulWidget {
  const _OhanaPlaceholder({required this.size, required this.state});
  final double size;
  final OhanaState state;

  @override
  State<_OhanaPlaceholder> createState() => _OhanaPlaceholderState();
}

class _OhanaPlaceholderState extends State<_OhanaPlaceholder>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnim;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _bounceAnim = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bounceAnim,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _bounceAnim.value),
          child: child,
        );
      },
      child: CustomPaint(
        size: Size(widget.size, widget.size),
        painter: _OhanaPainter(state: widget.state),
      ),
    );
  }
}

/// Draws a simplified cartoon Corgi/Border Collie mix (Ohana).
class _OhanaPainter extends CustomPainter {
  const _OhanaPainter({required this.state});
  final OhanaState state;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // ── Body ──────────────────────────────────────────────────────────────────
    final bodyPaint = Paint()..color = const Color(0xFFD4905A); // warm brown
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, cy + size.height * 0.12),
          width: size.width * 0.52, height: size.height * 0.35),
      const Radius.circular(30),
    );
    canvas.drawRRect(bodyRect, bodyPaint);

    // White chest patch
    final chestPaint = Paint()..color = const Color(0xFFFFF5E4);
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(cx, cy + size.height * 0.08),
          width: size.width * 0.25,
          height: size.height * 0.22),
      chestPaint,
    );

    // ── Head (large, cute) ───────────────────────────────────────────────────
    final headPaint = Paint()..color = const Color(0xFFD4905A);
    canvas.drawCircle(
        Offset(cx, cy - size.height * 0.18), size.width * 0.285, headPaint);

    // White muzzle blaze
    final blazePaint = Paint()..color = const Color(0xFFFFF5E4);
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(cx, cy - size.height * 0.08),
          width: size.width * 0.18,
          height: size.height * 0.13),
      blazePaint,
    );

    // ── Ears ─────────────────────────────────────────────────────────────────
    final earPaint = Paint()..color = const Color(0xFFA0622A);
    // Left ear
    final leftEarPath = Path()
      ..moveTo(cx - size.width * 0.20, cy - size.height * 0.22)
      ..lineTo(cx - size.width * 0.32, cy - size.height * 0.40)
      ..lineTo(cx - size.width * 0.12, cy - size.height * 0.32)
      ..close();
    canvas.drawPath(leftEarPath, earPaint);
    // Right ear
    final rightEarPath = Path()
      ..moveTo(cx + size.width * 0.20, cy - size.height * 0.22)
      ..lineTo(cx + size.width * 0.32, cy - size.height * 0.40)
      ..lineTo(cx + size.width * 0.12, cy - size.height * 0.32)
      ..close();
    canvas.drawPath(rightEarPath, earPaint);

    // Inner ears
    final innerEarPaint = Paint()..color = const Color(0xFFE8A89C);
    final leftInner = Path()
      ..moveTo(cx - size.width * 0.20, cy - size.height * 0.24)
      ..lineTo(cx - size.width * 0.28, cy - size.height * 0.37)
      ..lineTo(cx - size.width * 0.14, cy - size.height * 0.30)
      ..close();
    canvas.drawPath(leftInner, innerEarPaint);
    final rightInner = Path()
      ..moveTo(cx + size.width * 0.20, cy - size.height * 0.24)
      ..lineTo(cx + size.width * 0.28, cy - size.height * 0.37)
      ..lineTo(cx + size.width * 0.14, cy - size.height * 0.30)
      ..close();
    canvas.drawPath(rightInner, innerEarPaint);

    // ── Eyes ─────────────────────────────────────────────────────────────────
    final eyeWhitePaint = Paint()..color = const Color(0xFFFFFFFF);
    final eyePupilPaint = Paint()..color = const Color(0xFF2C1810);
    final eyeShimmerPaint = Paint()..color = const Color(0xFFFFFFFF);
    // Left eye
    canvas.drawCircle(
        Offset(cx - size.width * 0.10, cy - size.height * 0.22),
        size.width * 0.065, eyeWhitePaint);
    canvas.drawCircle(
        Offset(cx - size.width * 0.095, cy - size.height * 0.22),
        size.width * 0.044, eyePupilPaint);
    canvas.drawCircle(
        Offset(cx - size.width * 0.078, cy - size.height * 0.235),
        size.width * 0.014, eyeShimmerPaint);
    // Right eye
    canvas.drawCircle(
        Offset(cx + size.width * 0.10, cy - size.height * 0.22),
        size.width * 0.065, eyeWhitePaint);
    canvas.drawCircle(
        Offset(cx + size.width * 0.105, cy - size.height * 0.22),
        size.width * 0.044, eyePupilPaint);
    canvas.drawCircle(
        Offset(cx + size.width * 0.122, cy - size.height * 0.235),
        size.width * 0.014, eyeShimmerPaint);

    // ── Nose ─────────────────────────────────────────────────────────────────
    final nosePaint = Paint()..color = const Color(0xFF2C1810);
    final nosePath = Path()
      ..moveTo(cx, cy - size.height * 0.04)
      ..lineTo(cx - size.width * 0.04, cy - size.height * 0.075)
      ..lineTo(cx + size.width * 0.04, cy - size.height * 0.075)
      ..close();
    canvas.drawPath(nosePath, nosePaint);
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(cx, cy - size.height * 0.068),
          width: size.width * 0.08,
          height: size.height * 0.036),
      nosePaint,
    );

    // ── Smile ────────────────────────────────────────────────────────────────
    final smilePaint = Paint()
      ..color = const Color(0xFF2C1810)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.018
      ..strokeCap = StrokeCap.round;
    final smilePath = Path();
    smilePath.moveTo(cx - size.width * 0.055, cy - size.height * 0.028);
    smilePath.quadraticBezierTo(
        cx, cy + size.height * 0.008, cx + size.width * 0.055, cy - size.height * 0.028);
    canvas.drawPath(smilePath, smilePaint);

    // ── Legs (state-dependent) ───────────────────────────────────────────────
    final legPaint = Paint()..color = const Color(0xFFD4905A);
    final pawPaint = Paint()..color = const Color(0xFFE8A89C);

    if (state == OhanaState.idleSitting) {
      // Sitting paws in front
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(cx - size.width * 0.22, cy + size.height * 0.24,
              size.width * 0.14, size.height * 0.10),
          const Radius.circular(8),
        ),
        legPaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(cx + size.width * 0.08, cy + size.height * 0.24,
              size.width * 0.14, size.height * 0.10),
          const Radius.circular(8),
        ),
        legPaint,
      );
      // Paw pads
      canvas.drawCircle(
          Offset(cx - size.width * 0.15, cy + size.height * 0.34),
          size.width * 0.04, pawPaint);
      canvas.drawCircle(
          Offset(cx + size.width * 0.15, cy + size.height * 0.34),
          size.width * 0.04, pawPaint);
    } else if (state == OhanaState.walkingForward) {
      // Legs in walking stride
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(cx - size.width * 0.25, cy + size.height * 0.22,
              size.width * 0.12, size.height * 0.14),
          const Radius.circular(6),
        ),
        legPaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(cx - size.width * 0.06, cy + size.height * 0.28,
              size.width * 0.12, size.height * 0.14),
          const Radius.circular(6),
        ),
        legPaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(cx + size.width * 0.06, cy + size.height * 0.22,
              size.width * 0.12, size.height * 0.14),
          const Radius.circular(6),
        ),
        legPaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(cx + size.width * 0.18, cy + size.height * 0.28,
              size.width * 0.12, size.height * 0.14),
          const Radius.circular(6),
        ),
        legPaint,
      );
    } else {
      // Turning – sideways stance
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(cx - size.width * 0.24, cy + size.height * 0.24,
              size.width * 0.12, size.height * 0.14),
          const Radius.circular(6),
        ),
        legPaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(cx + size.width * 0.10, cy + size.height * 0.24,
              size.width * 0.12, size.height * 0.14),
          const Radius.circular(6),
        ),
        legPaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(cx - size.width * 0.10, cy + size.height * 0.30,
              size.width * 0.12, size.height * 0.10),
          const Radius.circular(6),
        ),
        legPaint,
      );
    }

    // ── Tail ─────────────────────────────────────────────────────────────────
    final tailPaint = Paint()
      ..color = const Color(0xFFD4905A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.06
      ..strokeCap = StrokeCap.round;
    final tailPath = Path();
    tailPath.moveTo(cx + size.width * 0.24, cy + size.height * 0.12);
    tailPath.quadraticBezierTo(
        cx + size.width * 0.42, cy - size.height * 0.04,
        cx + size.width * 0.30, cy - size.height * 0.18);
    canvas.drawPath(tailPath, tailPaint);

    // ── State label (debug / visual cue) ─────────────────────────────────────
    final labelPainter = TextPainter(
      text: TextSpan(
        text: _stateEmoji(),
        style: TextStyle(fontSize: size.width * 0.10),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    labelPainter.paint(
        canvas,
        Offset(cx - labelPainter.width / 2,
            cy + size.height * 0.38));
  }

  String _stateEmoji() {
    switch (state) {
      case OhanaState.idleSitting:
        return '🐾';
      case OhanaState.walkingForward:
        return '🦮';
      case OhanaState.turningAround:
        return '🔄';
    }
  }

  @override
  bool shouldRepaint(_OhanaPainter oldDelegate) =>
      oldDelegate.state != state;
}
