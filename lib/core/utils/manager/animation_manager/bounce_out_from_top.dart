import 'package:flutter/material.dart';

class BounceOutFromTop extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double startOffsetY;
  final double endOffsetY;
  final Curve curve;

  const BounceOutFromTop({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 3),
    this.startOffsetY = -600.0,
    this.endOffsetY = 0.0,
    this.curve = Curves.bounceOut,
  });

  @override
  _BounceOutFromTopState createState() => _BounceOutFromTopState();
}

class _BounceOutFromTopState extends State<BounceOutFromTop>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animationY;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);

    _animationY = Tween<double>(
      begin: widget.startOffsetY,
      end: widget.endOffsetY,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animationY.value),
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
