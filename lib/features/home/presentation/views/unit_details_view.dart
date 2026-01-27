import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/manager/color_manager/color_manager.dart';
import '../../../../core/utils/services/service_locator.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/datasource/home_datasource.dart';
import '../../data/models/unit_model.dart';
import '../../data/models/unit_photo_model.dart';
import '../widgets/unit_detail_item.dart';
import '../widgets/unit_image_carousel.dart';
import '../widgets/unit_detail/unit_detail_indicator.dart';
import '../widgets/unit_detail/reservation_title_widget.dart';
import 'package:provider/provider.dart';
import '../providers/reservation_form_provider.dart';

class UnitDetailsView extends StatefulWidget {
  final List<UnitModel> units;
  final int initialIndex;
  final VoidCallback? onRefresh;

  const UnitDetailsView({
    super.key,
    required this.units,
    required this.initialIndex,
    this.onRefresh,
  });

  @override
  State<UnitDetailsView> createState() => _UnitDetailsViewState();
}

class _UnitDetailsViewState extends State<UnitDetailsView> {
  late PageController _pageController;
  late int _currentIndex;
  late HomeDatasource _homeDatasource;

  final NumberFormat _numberFormatter = NumberFormat('#,##0.00', 'en_US');

  @override
  void initState() {
    super.initState();
    _homeDatasource = getIt<HomeDatasource>();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);

    // Initialize form for the first unit
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReservationFormProvider>().init(widget.units[_currentIndex]);
    });
  }

  String _formatValue(num? value) {
    if (value == null) return "-";
    return _numberFormatter.format(value);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
          });
          // Reset/init form for the new unit
          context.read<ReservationFormProvider>().init(widget.units[index]);
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
                FutureBuilder<List<UnitPhotoModel>>(
                  future: _homeDatasource.getAllPhotoForUnit(
                    unit.buildingCode?.toInt() ?? 0,
                    int.tryParse(unit.unitCode ?? '0') ?? 0,
                  ),
                  builder: (context, snapshot) {
                    final photos =
                        snapshot.data
                            ?.map((p) => p.photoUrl ?? '')
                            .where((url) => url.isNotEmpty)
                            .toList() ??
                        [];
                    return UnitImageCarousel(images: photos);
                  },
                ),
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
                        value: _formatValue(unit.unitArea),
                      ),
                      UnitDetailItem(
                        label: localizations.installment,
                        value: _formatValue(unit.calcInstValUnit),
                      ),
                      UnitDetailItem(
                        label: localizations.totalPrice,
                        value: _formatValue(unit.totPrice),
                      ),
                      UnitDetailItem(
                        label: localizations.unitStatus,
                        value: _getUnitStatusText(context, status),
                        valueColor: _getStatusTextColor(status),
                      ),
                      UnitDetailItem(
                        label: localizations.meterPrice,
                        value: _formatValue(unit.meterPriceInst),
                      ),
                      UnitDetailItem(
                        label: localizations.notes,
                        value: unit.notes ?? "-",
                      ),

                      SizedBox(height: 16.h),

                      // Boolean Indicators
                      if (unit.hold == 1)
                        UnitDetailIndicator(
                          text: localizations.notAvailableNow,
                        ),
                      if (unit.compUnit == 1)
                        UnitDetailIndicator(text: localizations.partnerUnit),

                      // Reservation Form (Only if Available)
                      if (status == 0) ...[
                        const Divider(color: Colors.white24, height: 40),
                        ReservationTitleWidget(
                          unit: unit,
                          onRefresh: widget.onRefresh,
                          homeDatasource: _homeDatasource,
                        ),
                        SizedBox(height: 16.h),
                      ],
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
}
