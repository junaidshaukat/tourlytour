import 'package:flutter/material.dart';

class Preloader extends StatelessWidget {
  final bool preloader;
  final bool safeArea;
  final Widget child;
  const Preloader({
    super.key,
    this.preloader = true,
    this.safeArea = true,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (safeArea) {
      return SafeArea(
        child: preloader == true
            ? const Scaffold(
                body: Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              )
            : child,
      );
    }

    return preloader == true
        ? const SafeArea(
            child: Scaffold(
              body: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
          )
        : child;
  }
}
