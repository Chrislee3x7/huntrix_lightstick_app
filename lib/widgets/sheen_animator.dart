import 'package:flutter/material.dart';

enum SheenDirection { leftToRight, rightToLeft, topToBottom, bottomToTop }

class SheenAnimator extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double sheenOpacity;
  final Color sheenColor;
  final double sheenWidth;
  final SheenDirection direction;
  final Duration delay;

  const SheenAnimator({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 2),
    this.sheenOpacity = 0.3,
    this.sheenWidth = 0.2,
    this.sheenColor = Colors.white,
    this.direction = SheenDirection.leftToRight,
    this.delay = const Duration(seconds: 0),
  });

  @override
  State<SheenAnimator> createState() => _SheenAnimatorState();
}

class _SheenAnimatorState extends State<SheenAnimator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  double _currentOpacity = 1.0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);
    _offsetAnimation = _getOffsetTween(
      widget.direction,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    // Listen for completion to fade out during delay
    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        if (widget.delay > Duration.zero) {
          // fade out
          setState(() => _currentOpacity = 0.0);
          await Future.delayed(widget.delay);
        }
        // reset opacity and controller for next cycle
        setState(() => _currentOpacity = 1.0);
        _controller.reset();
        _controller.forward();
      }
    });

    _controller.forward();
  }

  Tween<Offset> _getOffsetTween(SheenDirection dir) {
    double startPos = -0.5;
    double endPos = 0.5;
    switch (dir) {
      case SheenDirection.leftToRight:
        return Tween(begin: Offset(startPos, 0.0), end: Offset(endPos, 0.0));
      case SheenDirection.rightToLeft:
        return Tween(begin: Offset(endPos, 0.0), end: Offset(startPos, 0.0));
      case SheenDirection.topToBottom:
        return Tween(begin: Offset(0.0, startPos), end: Offset(0.0, endPos));
      case SheenDirection.bottomToTop:
        return Tween(begin: Offset(0.0, endPos), end: Offset(0.0, startPos));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: SlideTransition(
            position: _offsetAnimation,
            child: AnimatedOpacity(
              opacity: _currentOpacity,
              duration: const Duration(milliseconds: 300),
              child: FractionallySizedBox(
                widthFactor:
                    widget.direction == SheenDirection.leftToRight ||
                        widget.direction == SheenDirection.rightToLeft
                    ? widget.sheenWidth
                    : 1.0,
                heightFactor:
                    widget.direction == SheenDirection.topToBottom ||
                        widget.direction == SheenDirection.bottomToTop
                    ? widget.sheenWidth
                    : 1.0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 0.5,
                      colors: [
                        widget.sheenColor.withOpacity(
                          widget.sheenOpacity,
                        ), // strongest in center
                        widget.sheenColor.withOpacity(
                          widget.sheenOpacity * 0.5,
                        ), // mid fade
                        widget.sheenColor.withOpacity(
                          0.0,
                        ), // fully transparent at edge
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
