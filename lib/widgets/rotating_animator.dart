import 'package:flutter/material.dart';
import 'dart:math';

enum RotationDirection { clockwise, counterClockwise }

class RotatingAnimator extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final RotationDirection direction;

  const RotatingAnimator({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 2),
    this.direction = RotationDirection.clockwise,
  });

  @override
  State<RotatingAnimator> createState() => _RotatingAnimatorState();
}

class _RotatingAnimatorState extends State<RotatingAnimator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat(); // continuously rotate
  }

  @override
  void didUpdateWidget(covariant RotatingAnimator oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
      _controller.reset();
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        // determine rotation direction
        double angle = _controller.value * 2 * pi;
        if (widget.direction == RotationDirection.counterClockwise) {
          angle = -angle;
        }
        return Transform.rotate(angle: angle, child: child);
      },
    );
  }
}
