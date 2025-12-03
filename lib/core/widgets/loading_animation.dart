import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';

class LoadingAnimation extends StatefulWidget {
  final double size;
  final Color? color;

  const LoadingAnimation({
    super.key,
    this.size = 50.0,
    this.color,
  });

  @override
  State<LoadingAnimation> createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size.w,
      height: widget.size.h,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Stack(
            children: [
              for (int i = 0; i < 3; i++)
                Positioned.fill(
                  child: Transform.rotate(
                    angle: (i * 2.0944) + (_animation.value * 6.28318),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: 8.w,
                        height: 8.h,
                        decoration: BoxDecoration(
                          color: (widget.color ?? AppColors.primary)
                              .withOpacity(0.8 - (i * 0.2)),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class PulseLoadingAnimation extends StatefulWidget {
  final double size;
  final Color? color;

  const PulseLoadingAnimation({
    super.key,
    this.size = 60.0,
    this.color,
  });

  @override
  State<PulseLoadingAnimation> createState() => _PulseLoadingAnimationState();
}

class _PulseLoadingAnimationState extends State<PulseLoadingAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
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
      builder: (context, child) {
        return Container(
          width: widget.size.w,
          height: widget.size.h,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                (widget.color ?? AppColors.primary).withOpacity(_animation.value),
                (widget.color ?? AppColors.primary).withOpacity(0.1),
              ],
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Container(
              width: (widget.size * 0.4).w,
              height: (widget.size * 0.4).h,
              decoration: BoxDecoration(
                color: widget.color ?? AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }
}
