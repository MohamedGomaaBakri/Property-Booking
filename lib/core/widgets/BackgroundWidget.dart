import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BackgroundWidget extends StatelessWidget {
  final String image;
  final Widget child;

  const BackgroundWidget({super.key, required this.image, required this.child});

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.sizeOf(context).width;
    var h = MediaQuery.sizeOf(context).height;

    return Stack(
      children: [
        SvgPicture.asset(image, height: h, width: w, fit: BoxFit.cover),
        child,
      ],
    );
  }
}
