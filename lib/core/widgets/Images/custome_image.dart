// shared Network image widget
// usd CachedNetworkImage package
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:propertybooking/core/widgets/Images/custome_network_image.dart';

class CustomImage extends StatelessWidget {
  const CustomImage({
    super.key,
    required this.image,
    this.fit,
    this.height,
    this.width,
    this.color,
    this.colors, // ✅ أضفنا list of colors
    this.radius,
  });
  final String image;
  final BoxFit? fit;
  final double? height;
  final double? width;
  final Color? color; // لون واحد
  final List<Color>? colors; // ✅ قائمة ألوان للـ gradient
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final imageExtension = image.split('.').last.toLowerCase();
    if (isNetworkImage(image)) {
      return getNetworkImage(imageExtension);
    } else {
      return getAssetImage(imageExtension);
    }
  }

  bool isNetworkImage(String url) {
    return url.startsWith('http://') || url.startsWith('https://');
  }

  getAssetImage(String imageExtension) {
    Widget imageWidget;

    if (imageExtension == 'svg') {
      imageWidget = SvgPicture.asset(
        image,
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
        colorFilter: color != null
            ? ColorFilter.mode(color!, BlendMode.srcIn)
            : null,
        placeholderBuilder: (context) => Container(
          height: height ?? 24,
          width: width ?? 24,
          color: Colors.grey[300],
        ),
      );
    } else {
      imageWidget = Image.asset(
        image,
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
        color: color,
        errorBuilder: (context, error, stackTrace) => Container(
          height: height ?? 24,
          width: width ?? 24,
          color: Colors.grey[300],
          child: Icon(Icons.error, color: Colors.grey[600]),
        ),
      );
    }

    // ✅ لو في colors list، نضيف gradient
    if (colors != null && colors!.isNotEmpty) {
      return ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          colors: colors!,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds),
        blendMode: BlendMode.srcIn,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  getNetworkImage(String imageExtension) {
    Widget imageWidget = CustomNetworkImage(
      image: image,
      fit: fit,
      height: height,
      width: width,
      radius: radius,
      color: color,
    );

    // ✅ لو في colors list، نضيف gradient
    if (colors != null && colors!.isNotEmpty) {
      return ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          colors: colors!,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds),
        blendMode: BlendMode.srcIn,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}
