import 'package:flutter/material.dart';

class FloatingAnimator extends StatefulWidget {
  final Widget child;
  final double offset;       // how far it moves up/down in pixels
  final Duration duration;   // how fast the bobbing animation is

  const FloatingAnimator({
    super.key,
    required this.child,
    this.offset = 10.0,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<FloatingAnimator> createState() => _FloatingAnimatorState();
}

class _FloatingAnimatorState extends State<FloatingAnimator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _movement;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);

    _movement = Tween<double>(
      begin: widget.offset,   // move down
      end: -widget.offset,      // move up
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _movement,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _movement.value),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
