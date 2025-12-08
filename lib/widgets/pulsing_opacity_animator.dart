import 'package:flutter/material.dart';

class PulsingOpacityAnimator extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double minOpacity;
  final double maxOpacity;

  const PulsingOpacityAnimator({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 1),
    this.minOpacity = 0.3,
    this.maxOpacity = 1.0,
  });

  @override
  State<PulsingOpacityAnimator> createState() => _PulsingOpacityAnimatorState();
}

class _PulsingOpacityAnimatorState extends State<PulsingOpacityAnimator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat(reverse: true);

    _opacityAnimation = Tween<double>(
      begin: widget.minOpacity,
      end: widget.maxOpacity,
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
      animation: _opacityAnimation,
      builder: (context, child) {
        return Opacity(opacity: _opacityAnimation.value, child: child);
      },
      child: widget.child,
    );
  }
}
