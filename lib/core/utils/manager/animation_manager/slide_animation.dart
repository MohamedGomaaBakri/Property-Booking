import 'package:flutter/material.dart';

class SlideInWrapper extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double startOffsetX;
  final double endOffsetX;
  final double startOffsetY;
  final double endOffsetY;

  const SlideInWrapper({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 3),
    this.startOffsetX = 600.0,
    this.endOffsetX = 0.0,
    this.startOffsetY = 0.0,
    this.endOffsetY = 0.0,
  });

  @override
  _SlideInWrapperState createState() => _SlideInWrapperState();
}

class _SlideInWrapperState extends State<SlideInWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animationX;
  late Animation<double> _animationY;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);

    _animationX = Tween<double>(
      begin: widget.startOffsetX,
      end: widget.endOffsetX,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _animationY = Tween<double>(
      begin: widget.startOffsetY,
      end: widget.endOffsetY,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_animationX.value, _animationY.value),
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
