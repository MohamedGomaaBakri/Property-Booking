import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/manager/color_manager/color_manager.dart';

class UnitDetailIndicator extends StatelessWidget {
  final String text;

  const UnitDetailIndicator({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: ColorManager.soldColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: ColorManager.soldColor.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: ColorManager.soldColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
