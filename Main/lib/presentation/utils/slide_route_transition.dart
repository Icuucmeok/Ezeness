import 'package:flutter/material.dart';

class SlideRouteTransition extends PageRouteBuilder {
  final Widget page;

  SlideRouteTransition(this.page)
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end:const Offset(0, 0),
            ).animate(animation),
            child: child,
          ),
          transitionDuration:const Duration(milliseconds: 300),
        );
}
