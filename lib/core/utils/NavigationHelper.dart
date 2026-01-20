import 'package:flutter/material.dart';

enum AnimationType {
  slide,
  fade,
  scale,
  rotation,
  size,
  slideFade,
}

class NavigationHelper {
  // Private constructor to prevent instantiation
  NavigationHelper._();

  // Navigate with animation
  static Future<void> navigateWithAnimation(
    BuildContext context,
    Widget destinationScreen, {
    AnimationType animationType = AnimationType.slide,
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.easeInOut,
    Offset slideOffset = const Offset(1.0, 0.0), // Default: slide from right
  }) async {
    switch (animationType) {
      case AnimationType.slide:
        await Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: duration,
            pageBuilder: (_, __, ___) => destinationScreen,
            transitionsBuilder: (_, animation, __, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: slideOffset,
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: curve,
                )),
                child: child,
              );
            },
          ),
        );
        break;

      case AnimationType.fade:
        await Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: duration,
            pageBuilder: (_, __, ___) => destinationScreen,
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
        break;

      case AnimationType.scale:
        await Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: duration,
            pageBuilder: (_, __, ___) => destinationScreen,
            transitionsBuilder: (_, animation, __, child) {
              return ScaleTransition(
                scale: Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: curve,
                )),
                child: child,
              );
            },
          ),
        );
        break;

      case AnimationType.rotation:
        await Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: duration,
            pageBuilder: (_, __, ___) => destinationScreen,
            transitionsBuilder: (_, animation, __, child) {
              return RotationTransition(
                turns: Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: curve,
                )),
                child: child,
              );
            },
          ),
        );
        break;

      case AnimationType.size:
        await Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: duration,
            pageBuilder: (_, __, ___) => destinationScreen,
            transitionsBuilder: (_, animation, __, child) {
              return SizeTransition(
                sizeFactor: CurvedAnimation(
                  parent: animation,
                  curve: curve,
                ),
                axis: Axis.vertical, // Can be Axis.horizontal
                child: child,
              );
            },
          ),
        );
        break;

      case AnimationType.slideFade:
        await Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: duration,
            pageBuilder: (_, __, ___) => destinationScreen,
            transitionsBuilder: (_, animation, __, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: slideOffset,
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: curve,
                )),
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
          ),
        );
        break;
    }
  }

  // Navigate with replacement (replaces current screen)
  static Future<void> navigateWithReplacement(
    BuildContext context,
    Widget destinationScreen, {
    AnimationType animationType = AnimationType.slide,
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.easeInOut,
    Offset slideOffset = const Offset(1.0, 0.0),
  }) async {
    switch (animationType) {
      case AnimationType.slide:
        await Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: duration,
            pageBuilder: (_, __, ___) => destinationScreen,
            transitionsBuilder: (_, animation, __, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: slideOffset,
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: curve,
                )),
                child: child,
              );
            },
          ),
        );
        break;

      case AnimationType.fade:
        await Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: duration,
            pageBuilder: (_, __, ___) => destinationScreen,
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
        break;

      case AnimationType.scale:
        await Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: duration,
            pageBuilder: (_, __, ___) => destinationScreen,
            transitionsBuilder: (_, animation, __, child) {
              return ScaleTransition(
                scale: Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: curve,
                )),
                child: child,
              );
            },
          ),
        );
        break;

      case AnimationType.rotation:
        await Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: duration,
            pageBuilder: (_, __, ___) => destinationScreen,
            transitionsBuilder: (_, animation, __, child) {
              return RotationTransition(
                turns: Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: curve,
                )),
                child: child,
              );
            },
          ),
        );
        break;

      case AnimationType.size:
        await Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: duration,
            pageBuilder: (_, __, ___) => destinationScreen,
            transitionsBuilder: (_, animation, __, child) {
              return SizeTransition(
                sizeFactor: CurvedAnimation(
                  parent: animation,
                  curve: curve,
                ),
                axis: Axis.vertical,
                child: child,
              );
            },
          ),
        );
        break;

      case AnimationType.slideFade:
        await Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: duration,
            pageBuilder: (_, __, ___) => destinationScreen,
            transitionsBuilder: (_, animation, __, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: slideOffset,
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: curve,
                )),
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
          ),
        );
        break;
    }
  }
}