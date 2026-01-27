import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/manager/color_manager/color_manager.dart';

class UnitDetailLabel extends StatelessWidget {
  final String label;
  final bool isRequired;

  const UnitDetailLabel({
    super.key,
    required this.label,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: ColorManager.white.withValues(alpha: 0.7),
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (isRequired)
            Text(
              ' *',
              style: TextStyle(
                color: ColorManager.soldColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}
