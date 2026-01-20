import 'package:flutter/material.dart';

class RotateWrapper extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double initialAngle;
  final double finalAngle;
  final int turns; // ← عدد اللفات

  const RotateWrapper({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 1),
    this.initialAngle = 0.0,
    this.finalAngle = 2 * 3.14159,
    this.turns = 1,
  });

  @override
  _RotateWrapperState createState() => _RotateWrapperState();
}

class _RotateWrapperState extends State<RotateWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration * widget.turns,
    );

    _animation = Tween<double>(
      begin: widget.initialAngle,
      end: widget.finalAngle * widget.turns,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward(); // ← تلف مرة أو أكتر حسب turns
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.rotate(angle: _animation.value, child: child);
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
