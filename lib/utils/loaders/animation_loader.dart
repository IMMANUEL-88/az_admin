import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../constants/colors.dart';
import '../helper_functions/helper_functions.dart';

class EAnimationLoaderWidget extends StatefulWidget {
  final String text;
  final String image;

  const EAnimationLoaderWidget({
    super.key,
    required this.text,
    required this.image,
  });

  @override
  State<EAnimationLoaderWidget> createState() => _EAnimationLoaderWidgetState();
}

class _EAnimationLoaderWidgetState extends State<EAnimationLoaderWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            widget.image,
            controller: _controller,
            height: 100,
            width: 100,
            fit: BoxFit.contain,
            onLoaded: (composition) {
              // 2x speed
              _controller.duration = composition.duration ~/ 2;
              _controller.repeat();
            },
          ),
          Text(
            widget.text,
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Colors.black,
                ),
          ),
        ],
      ),
    );
  }
}
