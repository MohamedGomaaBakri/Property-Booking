import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/manager/color_manager/color_manager.dart';
import '../../data/models/unit_model.dart';
import '../views/unit_details_view.dart';

class UnitCard extends StatelessWidget {
  final UnitModel unit;
  final List<UnitModel> units;
  final int index;

  const UnitCard({
    super.key,
    required this.unit,
    required this.units,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final status = unit.unitStatus?.toInt() ?? 4;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UnitDetailsView(
              units: units,
              initialIndex: index,
            ),
          ),
        );
      },
      onLongPress: () {
        _showUnitDetails(context);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          gradient: _getStatusGradient(status),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: ColorManager.availableColor.withValues(alpha: 0.3),
            width: 1.w,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            '${unit.unitCode ?? 'N/A'}',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: ColorManager.white,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  offset: Offset(0, 1),
                  blurRadius: 2,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void _showUnitDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ColorManager.black.withValues(alpha: 0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
          side: BorderSide(color: ColorManager.availableColor, width: 1.w),
        ),
        title: Container(
          padding: EdgeInsets.only(bottom: 12.h),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: ColorManager.availableColor.withValues(alpha: 0.3),
                width: 1.w,
              ),
            ),
          ),
          child: Text(
            'تفاصيل الوحدة',
            style: TextStyle(
              color: ColorManager.availableColor,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('الكود:', unit.unitCode ?? 'N/A'),
            SizedBox(height: 16.h),
            _buildDetailRow('الاسم:', unit.unitNameA ?? 'غير متوفر'),
            SizedBox(height: 16.h),
            _buildDetailRow(
              'الحالة:',
              _getUnitStatusText(unit.unitStatus?.toInt()),
              valueColor: _getStatusTextColor(unit.unitStatus?.toInt()),
            ),
            SizedBox(height: 16.h),
            _buildDetailRow('المساحة:', unit.unitArea?.toString() ?? ""),
            SizedBox(height: 16.h),
            _buildDetailRow(
              'سعر المتر:',
              unit.meterPriceInst?.toString() ?? "-",
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: ColorManager.availableColor,
            ),
            child: Text(
              'إغلاق',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: ColorManager.availableColor.withValues(alpha: 0.7),
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: valueColor ?? ColorManager.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  String _getUnitStatusText(int? status) {
    switch (status) {
      case 0:
        return 'متاحة';
      case 1:
        return 'محجوزة';
      case 3:
        return 'مباعة';
      default:
        return 'غير معروف';
    }
  }

  Color _getStatusTextColor(int? status) {
    switch (status) {
      case 0:
        return ColorManager.availableColor;
      case 3:
        return ColorManager.soldColor.withValues(alpha: 0.8);
      default:
        return ColorManager.white;
    }
  }

  Gradient _getStatusGradient(int status) {
    switch (status) {
      case 0: // Available - Gold Gradient
        return LinearGradient(
          colors: [
            ColorManager.availableColor.withValues(alpha: 0.7),
            ColorManager.availableColor.withValues(alpha: 0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 1: // Reserved - Dark Gray Gradient
        return LinearGradient(
          colors: [
            ColorManager.white.withValues(alpha: 0.15),
            ColorManager.white.withValues(alpha: 0.05),
          ],
        );
      case 3: // Sold - Reddish Gradient
        return LinearGradient(
          colors: [
            ColorManager.soldColor.withValues(alpha: 0.6),
            ColorManager.soldColor.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return LinearGradient(
          colors: [
            ColorManager.white.withValues(alpha: 0.1),
            ColorManager.white.withValues(alpha: 0.05),
          ],
        );
    }
  }
}
