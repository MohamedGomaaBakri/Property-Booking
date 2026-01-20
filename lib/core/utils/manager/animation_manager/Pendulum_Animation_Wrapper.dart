import 'package:flutter/material.dart';

class PendulumAnimationWrapper extends StatefulWidget {
  final Widget child;

  const PendulumAnimationWrapper({super.key, required this.child});

  @override
  _PendulumAnimationWrapperState createState() =>
      _PendulumAnimationWrapperState();
}

class _PendulumAnimationWrapperState extends State<PendulumAnimationWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pendulumAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _pendulumAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -15.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -15.0, end: 15.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 15.0, end: -15.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -15.0, end: 15.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 15.0, end: 0), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // بدء الحركة
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pendulumAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _pendulumAnimation.value * 0.0174533,
          child: child,
        );
      },
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
