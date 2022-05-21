import 'package:flutter/material.dart';

class WaitForConnectionPage extends StatelessWidget {
  const WaitForConnectionPage({super.key});
  static const pageRouteName = '/wait_for_connection';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Center(
          child: AnimatedPulsatingWidget(
            child: Text(
              "Shopeeta",
              style: Theme.of(context).textTheme.headline1!.copyWith(
                    fontSize: 150,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedPulsatingWidget extends StatefulWidget {
  const AnimatedPulsatingWidget({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  State<AnimatedPulsatingWidget> createState() =>
      _AnimatedPulsatingWidgetState();
}

class _AnimatedPulsatingWidgetState extends State<AnimatedPulsatingWidget>
    with SingleTickerProviderStateMixin {
  AnimationController? motionController;
  Animation? motionAnimation;
  double size = 20;

  @override
  void initState() {
    super.initState();

    motionController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
      lowerBound: 0.5,
    );

    motionAnimation = CurvedAnimation(
      parent: motionController!,
      curve: Curves.fastOutSlowIn,
    );

    motionController!.forward();
    motionController!.addStatusListener((status) {
      setState(() {
        if (status == AnimationStatus.completed) {
          motionController!.reverse();
        } else if (status == AnimationStatus.dismissed) {
          motionController!.forward();
        }
      });
    });

    motionController!.addListener(() {
      setState(() {
        size = motionController!.value * 250;
      });
    });
    // motionController.repeat();
  }

  @override
  void dispose() {
    motionController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: motionAnimation!.value,
      child: widget.child,
    );
  }
}
