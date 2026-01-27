import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/utils/manager/color_manager/color_manager.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../data/datasource/home_datasource.dart';
import '../../../data/models/unit_model.dart';
import 'reservation_form_bottom_sheet.dart';

class ReservationTitleWidget extends StatelessWidget {
  final UnitModel unit;
  final VoidCallback? onRefresh;
  final HomeDatasource homeDatasource;

  const ReservationTitleWidget({
    super.key,
    required this.unit,
    this.onRefresh,
    required this.homeDatasource,
  });

  void _showReservationBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (context) => ReservationFormBottomSheet(
        unit: unit,
        onRefresh: onRefresh,
        homeDatasource: homeDatasource,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return InkWell(
      onTap: () => _showReservationBottomSheet(context),
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: ColorManager.availableColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: ColorManager.availableColor.withValues(alpha: 0.3),
            width: 1.w,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.assignment,
                  color: ColorManager.availableColor,
                  size: 24.sp,
                ),
                SizedBox(width: 12.w),
                Text(
                  localizations.reservationDetails,
                  style: GoogleFonts.poppins(
                    color: ColorManager.availableColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: ColorManager.availableColor,
              size: 18.sp,
            ),
          ],
        ),
      ),
    );
  }
}
