import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../../core/utils/manager/color_manager/color_manager.dart';

class UnitDetailDatePicker extends StatelessWidget {
  final DateTime date;
  final Function(DateTime) onDateSelected;

  const UnitDetailDatePicker({
    super.key,
    required this.date,
    required this.onDateSelected,
  });

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: ColorManager.availableColor,
              onPrimary: ColorManager.black,
              surface: ColorManager.darkGrayColor,
              onSurface: ColorManager.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
    
    return InkWell(
      onTap: () => _selectDate(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: ColorManager.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: ColorManager.availableColor.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              dateFormatter.format(date),
              style: TextStyle(color: ColorManager.white),
            ),
            Icon(
              Icons.calendar_today,
              size: 18.sp,
              color: ColorManager.availableColor,
            ),
          ],
        ),
      ),
    );
  }
}
