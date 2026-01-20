import 'package:flutter/material.dart';

class ScaleUpDownWrapper extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double initialScale;
  final double finalScale;

  const ScaleUpDownWrapper({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 1),
    this.initialScale = 0.8,
    this.finalScale = 1,
  });

  @override
  _ScaleUpDownWrapperState createState() => _ScaleUpDownWrapperState();
}

class _ScaleUpDownWrapperState extends State<ScaleUpDownWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _animation = Tween<double>(
      begin: widget.initialScale,
      end: widget.finalScale,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Start the animation loop
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(scale: _animation.value, child: child);
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
