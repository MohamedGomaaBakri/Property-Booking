import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/manager/color_manager/color_manager.dart';
import '../../data/models/unit_model.dart';

class UnitCard extends StatelessWidget {
  final UnitModel unit;

  const UnitCard({
    super.key,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final status = unit.unitStatus?.toInt() ?? 4;
    
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 8.h,
          horizontal: 4.w,
        ),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: _getStatusColor(status),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: ColorManager.white.withValues(
              alpha: 0.2,
            ),
            width: 1.w,
          ),
        ),
        child: Text(
          'الوحدة: ${unit.unitCode ?? 'N/A'}',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: ColorManager.white,
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case 0: // متاحة - Available (Green)
        return Color(0xFF2ECC71).withValues(alpha: 0.3);
      case 1: // محجوزة - Reserved (White/Default)
        return ColorManager.white.withValues(alpha: 0.1);
      case 3: // مباعة - Sold (Red)
        return Color(0xFFE74C3C).withValues(alpha: 0.3);
      default:
        return ColorManager.white.withValues(alpha: 0.1);
    }
  }
}
