import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:propertybooking/core/utils/manager/style_manager/theme/AppColor.dart';

abstract class Appstyle {
  static TextStyle OnbordingTextStyleBlockBlod22 = TextStyle(
    color: Colors.black,
    fontFamily: "Readex Pro",
    fontSize: 22.sp,
    fontWeight: FontWeight.bold,
  );

  static TextStyle TextStyleBold25 = TextStyle(
    color: AppColor.primaryColor,
    fontFamily: "Readex Pro",
    fontSize: 25.sp,
    fontWeight: FontWeight.bold,
  );

  //=====================================
  static TextStyle TextButttonstyle = TextStyle(
    color: Colors.white,
    fontFamily: "Readex Pro",
    fontSize: 20.sp,
    fontWeight: FontWeight.w400,
  );

  //=====================================
  static TextStyle Text400_16 = TextStyle(
    color: Colors.black.withValues(alpha: .66),
    fontFamily: "Readex Pro",
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
  );
  //==================================
}
