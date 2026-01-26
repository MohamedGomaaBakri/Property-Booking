import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/manager/assets_manager/image_manager.dart';
import '../../../../core/widgets/Images/custome_image.dart';

class UnitImageCarousel extends StatelessWidget {
  final List<String> images;
  const UnitImageCarousel({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    final List<String> displayImages = images.isNotEmpty
        ? images
        : [
            ImageManager.building1Image,
            ImageManager.building2Image,
          ];

    return CarouselSlider(
      options: CarouselOptions(
        height: 250.h,
        viewportFraction: 1.0,
        autoPlay: displayImages.length > 1,
        enlargeCenterPage: false,
      ),
      items: displayImages.map((imagePath) {
        return Stack(
          children: [
            CustomImage(
              image: imagePath,
              width: double.infinity,
              height: 250.h,
              fit: BoxFit.cover,
            ),
            // Bottom Gradient for better readability if text overlaps
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.6),
                  ],
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
