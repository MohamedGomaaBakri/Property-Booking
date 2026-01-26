import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/manager/color_manager/color_manager.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/unit_model.dart';
import '../widgets/unit_detail_item.dart';
import '../widgets/unit_image_carousel.dart';

class UnitDetailsView extends StatefulWidget {
  final List<UnitModel> units;
  final int initialIndex;

  const UnitDetailsView({
    super.key,
    required this.units,
    required this.initialIndex,
  });

  @override
  State<UnitDetailsView> createState() => _UnitDetailsViewState();
}

class _UnitDetailsViewState extends State<UnitDetailsView> {
  final TextEditingController _installmentController = TextEditingController();
  late PageController _pageController;
  late int _currentIndex;
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    _installmentController.addListener(_validateInput);
  }

  @override
  void dispose() {
    _installmentController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _validateInput() {
    final unit = widget.units[_currentIndex];
    final status = unit.unitStatus?.toInt() ?? 4;
    setState(() {
      _isButtonEnabled = status == 0 && _installmentController.text.isNotEmpty;
    });
  }

  String _getUnitStatusText(BuildContext context, int? status) {
    final localizations = AppLocalizations.of(context)!;
    switch (status) {
      case 0:
        return localizations.available;
      case 1:
        return localizations.reserved;
      case 3:
        return localizations.sold;
      default:
        return "-";
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

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: ColorManager.black,
      appBar: AppBar(
        backgroundColor: ColorManager.black,
        elevation: 0,
        title: Text(
          localizations.unitDetails,
          style: TextStyle(
            color: ColorManager.availableColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: ColorManager.availableColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.units.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
            _installmentController.clear();
          });
        },
        itemBuilder: (context, index) {
          final unit = widget.units[index];
          final status = unit.unitStatus?.toInt() ?? 4;
          final fullDescription = isArabic
              ? (unit.unitNameA ?? "-")
              : (unit.unitNameE ?? "-");

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const UnitImageCarousel(),
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Information Section
                      UnitDetailItem(
                        label: localizations.buildingName,
                        value: unit.buildingNameA ?? "-",
                      ),
                      UnitDetailItem(
                        label: localizations.modelName,
                        value: unit.modelName ?? "-",
                      ),

                      UnitDetailItem(
                        label: localizations.levelNo,
                        value: unit.levelNo?.toString() ?? "-",
                      ),
                      UnitDetailItem(
                        label: localizations.flatNo,
                        value: unit.flatNo ?? "-",
                      ),
                      UnitDetailItem(
                        label: localizations.fullDescription,
                        value: fullDescription,
                      ),
                      UnitDetailItem(
                        label: localizations.unitArea,
                        value: unit.unitArea?.toString() ?? "-",
                      ),
                      UnitDetailItem(
                        label: localizations.installment,
                        value: unit.calcInstValUnit?.toString() ?? "-",
                      ),
                      UnitDetailItem(
                        label: localizations.totalPrice,
                        value: unit.totPrice?.toString() ?? "-",
                      ),
                      UnitDetailItem(
                        label: localizations.unitStatus,
                        value: _getUnitStatusText(context, status),
                        valueColor: _getStatusTextColor(status),
                      ),
                      UnitDetailItem(
                        label: localizations.meterPrice,
                        value: unit.meterPriceInst?.toString() ?? "-",
                      ),
                      UnitDetailItem(
                        label: localizations.notes,
                        value: unit.notes ?? "-",
                      ),

                      SizedBox(height: 16.h),

                      // Boolean Indicators
                      if (unit.hold == 1)
                        _buildIndicator(localizations.notAvailableNow),
                      if (unit.compUnit == 1)
                        _buildIndicator(localizations.partnerUnit),

                      SizedBox(height: 24.h),

                      // Installment Value Input
                      Text(
                        localizations.installmentValue,
                        style: TextStyle(
                          color: ColorManager.availableColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      TextField(
                        controller: _installmentController,
                        enabled: status == 0,
                        style: TextStyle(color: ColorManager.white),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "0.0",
                          hintStyle: TextStyle(
                            color: ColorManager.white.withValues(alpha: 0.3),
                          ),
                          filled: true,
                          fillColor: ColorManager.white.withValues(alpha: 0.05),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(
                              color: ColorManager.availableColor.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(
                              color: ColorManager.white.withValues(alpha: 0.1),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(
                              color: ColorManager.availableColor,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 32.h),

                      // Reserve Button
                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton(
                          onPressed: _isButtonEnabled
                              ? () {
                                  // TODO: Implement reservation logic
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorManager.availableColor,
                            disabledBackgroundColor: ColorManager.availableColor
                                .withValues(alpha: 0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            localizations.reserve,
                            style: TextStyle(
                              color: ColorManager.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 32.h),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildIndicator(String text) {
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
