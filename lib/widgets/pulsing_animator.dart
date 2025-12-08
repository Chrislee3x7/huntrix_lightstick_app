import 'package:flutter/material.dart';

class PulsingAnimator extends StatefulWidget {
  final Widget child; // now takes any widget
  final Duration duration;
  final double minScale; // how small the widget shrinks
  final double maxScale; // how large it grows
  final double opacity; // constant opacity for pulse effect

  const PulsingAnimator({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 1),
    this.minScale = 0.95,
    this.maxScale = 1.05,
    this.opacity = 0.5,
  });

  @override
  State<PulsingAnimator> createState() => _PulsingAnimatorState();
}

class _PulsingAnimatorState extends State<PulsingAnimator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat(reverse: true);

    _scale = Tween<double>(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
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
      builder: (context, child) {
        return Opacity(
          opacity: widget.opacity,
          child: Transform.scale(scale: _scale.value, child: child),
        );
      },
      child: widget.child, // use the passed-in widget
    );
  }
}
