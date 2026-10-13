import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationService {
  // Private constructor
  NavigationService._();

  // Singleton instance
  static final NavigationService instance = NavigationService._();

  void pop(BuildContext context, {dynamic value}) {
    Navigator.pop(context, value);
  }

  void pushAndRemoveUntil(BuildContext context, Widget page) {
    Platform.isAndroid
        ? Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => page), (route) => false)
        : Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => page), (route) => false);
  }

  void push(BuildContext context, Widget page) {
    Platform.isAndroid
        ? Navigator.push(context, MaterialPageRoute(builder: (context) => page))
        : Navigator.push(context, CupertinoPageRoute(builder: (context) => page));
  }

  void replace(BuildContext context, Widget page) {
    Platform.isAndroid
        ? Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page))
        : Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => page));
  }

  void pushSlideAnimation(BuildContext context, Widget page, {Function(dynamic value)? onValue}) {
    if (Platform.isIOS) {
      Navigator.of(context).push(CupertinoPageRoute(builder: (_) => page)).then((value) => onValue?.call(value));
    } else {
      Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;
          var tween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      )).then((value) => onValue?.call(value));
    }
  }

  void pushAndRemoveUntilSlideAnimation(BuildContext context, Widget page) {
    if (Platform.isIOS) {
      Navigator.of(context).pushAndRemoveUntil(CupertinoPageRoute(builder: (_) => page), (route) => false);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;
            var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ), (route) => false,
      );
    }
  }

  void pushFadeAnimation(BuildContext context, Widget page, {Function(dynamic value)? onValue}) {
    if (Platform.isIOS) {
      Navigator.of(context).push(CupertinoPageRoute(builder: (_) => page)).then((value) => onValue?.call(value));
    } else {
      Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const curve = Curves.easeInOut;
          var tween = Tween<double>(begin: 0, end: 1)
              .chain(CurveTween(curve: curve));
          var fade = animation.drive(tween);
          return FadeTransition(
            opacity: fade,
            child: child,
          );
        },
      )).then((value) => onValue?.call(value));
    }
  }

  void pushReplaceFadeAnimation(BuildContext context, Widget page, {Function(dynamic value)? onValue}) {
    if (Platform.isIOS) {
      Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (_) => page)).then((value) => onValue?.call(value));
    } else {
      Navigator.of(context).pushReplacement(PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const curve = Curves.easeInOut;
          var tween = Tween<double>(begin: 0, end: 1).chain(CurveTween(curve: curve));
          var fade = animation.drive(tween);
          return FadeTransition(
            opacity: fade,
            child: child,
          );
        },
      )).then((value) => onValue?.call(value));
    }
  }

  void pushReplaceSlideAnimation(BuildContext context, Widget page, {Function(dynamic value)? onValue}) {
    if (Platform.isIOS) {
      Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (_) => page)).then((value) => onValue?.call(value));
    } else {
      Navigator.of(context).pushReplacement(PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;
          var tween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      )).then((value) => onValue?.call(value));
    }
  }
}
