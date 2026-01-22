// shared Network image widget
// usd CachedNetworkImage package

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:propertybooking/core/utils/manager/assets_manager/image_manager.dart';
import 'package:propertybooking/core/widgets/Images/custome_image.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage({
    super.key,
    required this.image,
    this.fit,
    this.height,
    this.width,
    this.radius,
    this.color,
    this.placeHolder,
  });
  final String image;
  final String? placeHolder;
  final BoxFit? fit;
  final double? height;
  final double? width;
  final double? radius;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    Widget imageWidget = CachedNetworkImage(
      height: height,
      width: width,
      imageUrl: image,
      errorWidget: (context, url, error) {
        log(error.toString(), name: "error at CachedNetworkImage");
        return CustomImage(
          image: ImageManager.onboardingImage,
          fit: fit ?? BoxFit.cover,
        );
      },
      placeholder: (context, url) =>
          CustomImage(image: placeHolder ?? ImageManager.onboardingImage),
      fit: fit ?? BoxFit.cover,
    );

    if (color != null) {
      imageWidget = ColorFiltered(
        colorFilter: ColorFilter.mode(color!, BlendMode.srcIn),
        child: imageWidget,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 0),
      child: imageWidget,
    );
  }
}
