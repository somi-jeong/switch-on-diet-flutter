import 'package:flutter/material.dart';

class PulseAnimation extends StatefulWidget {
  final Tween<double> tween;
  final Duration duration;
  final Widget Function(BuildContext, double, Widget?) builder;

  const PulseAnimation({
    super.key,
    required this.tween,
    required this.duration,
    required this.builder,
  });

  @override
  State<PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..repeat();
    _animation = widget.tween.animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) =>
          widget.builder(context, _animation.value, child),
    );
  }
}
