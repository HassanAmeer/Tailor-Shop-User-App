import 'package:flutter/material.dart';
import 'dart:math' as math show sin, pi;

import '../constants/appColors.dart';

class DotLoader extends StatefulWidget {
  const DotLoader({
    super.key,
    this.color = AppColors.primaryColor,
    this.size = 27.0,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 1100),
    this.controller,
  });
  // assertion is used for show errors on whole screen
  // assert(
  //     !(itemBuilder is IndexedWidgetBuilder && color is Color) &&
  //         !(itemBuilder == null && color == null),
  //     'You should specify itemBuilder or a color For Dot Loader');

  final Color? color;
  final double size;
  final IndexedWidgetBuilder? itemBuilder;
  final Duration duration;
  final AnimationController? controller;

  @override
  State<DotLoader> createState() => _DotLoaderState();
}

class _DotLoaderState extends State<DotLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = (widget.controller ??
        AnimationController(vsync: this, duration: widget.duration))
      ..repeat();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.fromSize(
        size: Size(widget.size * 2, widget.size),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(3, (i) {
            return ScaleTransition(
              scale: DelayTween(
                begin: 0.0,
                end: 1.0,
                delay: i * .2,
              ).animate(_controller),
              child: SizedBox.fromSize(
                size: Size.square(widget.size * 0.5),
                child: _itemBuilder(i),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _itemBuilder(int index) => widget.itemBuilder != null
      ? widget.itemBuilder!(context, index)
      : DecoratedBox(
          decoration:
              BoxDecoration(color: widget.color, shape: BoxShape.circle));
}

////////////
class DelayTween extends Tween<double> {
  DelayTween({super.begin, super.end, required this.delay});

  final double delay;

  @override
  double lerp(double t) {
    return super.lerp((math.sin((t - delay) * 2 * math.pi) + 1) / 2);
  }

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}
