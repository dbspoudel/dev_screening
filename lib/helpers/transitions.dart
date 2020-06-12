import 'package:flutter/material.dart';

Route slideFromRightTransition(Widget target) {
  Widget _target = target;
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => _target,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
