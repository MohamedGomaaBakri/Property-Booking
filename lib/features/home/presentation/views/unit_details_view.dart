import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:propertybooking/features/home/data/models/customer_model.dart';
import '../../../../core/utils/manager/color_manager/color_manager.dart';
import '../../../../core/utils/navigation/router_path.dart';
import '../../../../core/utils/services/service_locator.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/manager/auth_cubit/auth_cubit_cubit.dart';
import '../../data/datasource/home_datasource.dart';
import '../../data/models/unit_model.dart';
import '../../data/models/unit_photo_model.dart';
import '../widgets/unit_detail_item.dart';
import '../widgets/unit_image_carousel.dart';

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
  // Controllers for Reservation Form
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _meterPriceController = TextEditingController();
  final TextEditingController _unitAreaController = TextEditingController();
  final TextEditingController _totalPriceController = TextEditingController();
  final TextEditingController _paymentValueController = TextEditingController();

  late PageController _pageController;
  late int _currentIndex;
  late HomeDatasource _homeDatasource;

  String? _selectedUser;
  List<CustomerModel> _users = [];
  bool _isLoadingUsers = true;
  bool _isReserving = false;

  DateTime _reservationDate = DateTime.now();
  DateTime _contractDate = DateTime.now();
  DateTime _dueDate = DateTime.now();

  final DateFormat _dateFormatter = DateFormat('yyyy-MM-dd');
  final NumberFormat _numberFormatter = NumberFormat('#,##0.00', 'en_US');

  @override
  void initState() {
    super.initState();
    _homeDatasource = getIt<HomeDatasource>();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);

    _initUnitControllers();
    _fetchUsers();

    // Add listeners for calculation and validation
    _meterPriceController.addListener(() {
      _calculateTotal();
      _validateFields();
    });
    _unitAreaController.addListener(() {
      _calculateTotal();
      _validateFields();
    });
    _customerNameController.addListener(_validateFields);
    _descriptionController.addListener(_validateFields);
    _paymentValueController.addListener(_validateFields);
  }

  void _initUnitControllers() {
    final unit = widget.units[_currentIndex];
    _meterPriceController.text = _numberFormatter.format(
      unit.meterPriceInst ?? 0,
    );
    _unitAreaController.text = unit.unitArea?.toString() ?? "0";
    _calculateTotal();
  }

  double _parseFormatted(String text) {
    return double.tryParse(text.replaceAll(',', '')) ?? 0;
  }

  void _calculateTotal() {
    final price = _parseFormatted(_meterPriceController.text);
    final area = _parseFormatted(_unitAreaController.text);
    setState(() {
      _totalPriceController.text = _numberFormatter.format(price * area);
    });
  }

  String _formatValue(num? value) {
    if (value == null) return "-";
    return _numberFormatter.format(value);
  }

  Future<void> _fetchUsers() async {
    setState(() => _isLoadingUsers = true);
    _users = await _homeDatasource.getCustomers();
    setState(() => _isLoadingUsers = false);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _customerNameController.dispose();
    _descriptionController.dispose();
    _meterPriceController.dispose();
    _unitAreaController.dispose();
    _totalPriceController.dispose();
    _paymentValueController.dispose();
    super.dispose();
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

  Future<void> _selectDate(
    BuildContext context,
    DateTime initialDate,
    Function(DateTime) onSelected,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
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
      setState(() {
        onSelected(picked);
      });
    }
  }

  // Add method to check if all required fields are filled
  bool _areRequiredFieldsFilled() {
    return _selectedUser != null &&
        _selectedUser!.isNotEmpty &&
        _customerNameController.text.trim().isNotEmpty &&
        _descriptionController.text.trim().isNotEmpty &&
        _meterPriceController.text.trim().isNotEmpty &&
        _unitAreaController.text.trim().isNotEmpty &&
        _paymentValueController.text.trim().isNotEmpty &&
        _totalPriceController.text.trim().isNotEmpty;
  }

  // Add validation trigger
  void _validateFields() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _handleReservation(UnitModel unit) async {
    // First validate all fields
    if (!_areRequiredFieldsFilled()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.fillAllFields),
          backgroundColor: ColorManager.soldColor,
        ),
      );
      return;
    }

    if (_selectedUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.selectUser),
          backgroundColor: ColorManager.soldColor,
        ),
      );
      return;
    }

    setState(() => _isReserving = true);

    try {
      final authState = context.read<AuthCubitCubit>().state;
      final salesCode = authState.userModel?.items?.firstOrNull?.usersCode ?? 0;

      final response = await _homeDatasource.reserveUnit(
        salesCode: salesCode,
        buildingCode: unit.buildingCode ?? 0,
        unitCode: unit.unitCode ?? "",
        customerName: _customerNameController.text,
        selectedUser: _selectedUser!,
        reservationDate: _dateFormatter.format(_reservationDate),
        contractDate: _dateFormatter.format(_contractDate),
        description: _descriptionController.text,
        meterPrice: _parseFormatted(_meterPriceController.text),
        unitArea: _parseFormatted(_unitAreaController.text),
        totalPrice: _parseFormatted(_totalPriceController.text),
        paymentValue: _parseFormatted(_paymentValueController.text),
        dueDate: _dateFormatter.format(_dueDate),
      );

      if (mounted) {
        final localizations = AppLocalizations.of(context)!;
        String message = localizations.reservationSuccess;
        bool isSuccess = true;

        // Check if response is DioError
        if (response is DioException) {
          message = _getErrorMessageFromDio(response, localizations);
          isSuccess = false;
        } else if (response is Map<String, dynamic>) {
          if (response['status'] == 'success') {
            message = localizations.reservationSuccess;
          } else if (response['message'] == 'Unit is already reserved') {
            message = localizations.unitAlreadyReserved;
            isSuccess = false;
          } else {
            // Check for server error in message too
            final errorMsg = response['message'] ?? '';
            if (errorMsg.contains('500') ||
                errorMsg.toLowerCase().contains('server error') ||
                errorMsg.toLowerCase().contains('internal error')) {
              message = localizations.serverError;
            } else {
              message = errorMsg.isNotEmpty
                  ? errorMsg
                  : localizations.reservationError;
            }
            isSuccess = false;
          }
        } else if (response is Response) {
          // Handle direct Response object
          if (response.statusCode != null && response.statusCode! >= 500) {
            message = localizations.serverError;
            isSuccess = false;
          } else if (response.statusCode == 200) {
            message = localizations.reservationSuccess;
          } else {
            message = localizations.reservationError;
            isSuccess = false;
          }
        }

        await _showResultDialog(message, isSuccess);

        if (isSuccess || message == localizations.unitAlreadyReserved) {
          if (mounted) {
            // Navigate back to BuildingView with refresh
            Navigator.of(context).pop();

            // Trigger refresh callback if provided
            if (widget.onRefresh != null) {
              widget.onRefresh!();
            }
          }
        }
      }
    } catch (e) {
      if (mounted) {
        _showResultDialog(
          AppLocalizations.of(context)!.reservationError,
          false,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isReserving = false);
      }
    }
  }

  String _getErrorMessageFromDio(DioException error, AppLocalizations l10n) {
    if (error.response != null) {
      final statusCode = error.response!.statusCode;

      if (statusCode != null && statusCode >= 500) {
        return l10n.serverError;
      }

      // Try to get message from response data
      if (error.response!.data is Map<String, dynamic>) {
        return error.response!.data['message'] ?? l10n.reservationError;
      } else if (error.response!.data is String) {
        return error.response!.data;
      }
    }

    return l10n.reservationError;
  }

  Future<void> _showResultDialog(String message, bool isSuccess) async {
    final localizations = AppLocalizations.of(context)!;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: ColorManager.black.withValues(alpha: 0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
          side: BorderSide(
            color: isSuccess
                ? ColorManager.availableColor
                : ColorManager.soldColor,
            width: 1.w,
          ),
        ),
        title: Text(
          isSuccess ? localizations.success : localizations.error,
          style: TextStyle(
            color: isSuccess
                ? ColorManager.availableColor
                : ColorManager.soldColor,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          message,
          style: TextStyle(color: ColorManager.white),
          textAlign: TextAlign.center,
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog

                if (isSuccess || message == localizations.unitAlreadyReserved) {
                  // Navigate back properly
                  Navigator.of(context).pop();

                  // Trigger refresh
                  if (widget.onRefresh != null) {
                    widget.onRefresh!();
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isSuccess
                    ? ColorManager.availableColor
                    : ColorManager.soldColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                localizations.ok,
                style: TextStyle(
                  color: ColorManager.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final areFieldsFilled = _areRequiredFieldsFilled();

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
            _selectedUser = null;
            _customerNameController.clear();
            _descriptionController.clear();
            _paymentValueController.clear();
            _initUnitControllers();
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
                        _buildIndicator(localizations.notAvailableNow),
                      if (unit.compUnit == 1)
                        _buildIndicator(localizations.partnerUnit),

                      // Reservation Form (Only if Available)
                      if (status == 0) ...[
                        const Divider(color: Colors.white24, height: 40),
                        Text(
                          localizations.reservationDetails,
                          style: GoogleFonts.poppins(
                            color: ColorManager.availableColor,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Users Dropdown
                        _buildLabel(localizations.customerNameLabel),
                        _buildDropdownField(localizations.customerNameLabel),
                        SizedBox(height: 16.h),

                        // Customer Name Manual
                        _buildLabel(localizations.customerDescription),
                        _buildTextField(
                          _customerNameController,
                          hint: localizations.enterName,
                        ),
                        SizedBox(height: 16.h),

                        // Dates Row
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel(localizations.resDate),
                                  _buildDatePickerField(_reservationDate, (
                                    date,
                                  ) {
                                    _reservationDate = date;
                                  }),
                                ],
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel(localizations.contDate),
                                  _buildDatePickerField(_contractDate, (date) {
                                    _contractDate = date;
                                  }),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),

                        // Description
                        _buildLabel(localizations.description),
                        _buildTextField(
                          _descriptionController,
                          hint: localizations.notesHint,
                          maxLines: 3,
                        ),
                        SizedBox(height: 24.h),

                        // Editable Unit Info
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel(localizations.meterPrice),
                                  _buildTextField(
                                    _meterPriceController,
                                    isNumber: true,
                                    formatters: [
                                      ThousandsSeparatorInputFormatter(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: 25.h,
                                left: 5.w,
                                right: 5.w,
                              ), // Aligns with text fields
                              child: Text(
                                "✕",
                                style: TextStyle(
                                  color: ColorManager.availableColor,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel(localizations.unitArea),
                                  _buildTextField(
                                    _unitAreaController,
                                    isNumber: true,
                                    formatters: [
                                      ThousandsSeparatorInputFormatter(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        const Divider(color: Colors.white24),
                        _buildLabel(localizations.totalPriceAuto),
                        _buildTextField(
                          _totalPriceController,
                          enabled: false,
                          suffix: isArabic ? "ج.م" : "EGP",
                          color: ColorManager.availableColor,
                        ),

                        const Divider(color: Colors.white24, height: 40),

                        // User Input Section
                        Text(
                          localizations.userInput,
                          style: GoogleFonts.poppins(
                            color: ColorManager.availableColor,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel(localizations.payValue),
                                  _buildTextField(
                                    _paymentValueController,
                                    isNumber: true,
                                    formatters: [
                                      ThousandsSeparatorInputFormatter(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel(localizations.dueDate),
                                  _buildDatePickerField(_dueDate, (date) {
                                    _dueDate = date;
                                  }),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 32.h),

                        // Reserve Button
                        SizedBox(
                          width: double.infinity,
                          height: 50.h,
                          child: ElevatedButton(
                            onPressed: areFieldsFilled && !_isReserving
                                ? () => _handleReservation(unit)
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: areFieldsFilled
                                  ? ColorManager.availableColor
                                  : ColorManager.availableColor.withOpacity(
                                      0.5,
                                    ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              disabledBackgroundColor: ColorManager
                                  .availableColor
                                  .withOpacity(0.3),
                            ),
                            child: _isReserving
                                ? SizedBox(
                                    height: 20.h,
                                    width: 20.h,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: ColorManager.white,
                                    ),
                                  )
                                : Text(
                                    localizations.reserve,
                                    style: TextStyle(
                                      color: areFieldsFilled
                                          ? ColorManager.white
                                          : ColorManager.white.withOpacity(0.7),
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(height: 32.h),
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

  Widget _buildLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        label,
        style: TextStyle(
          color: ColorManager.white.withValues(alpha: 0.7),
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller, {
    String? hint,
    bool isNumber = false,
    int maxLines = 1,
    bool enabled = true,
    String? suffix,
    Color? color,
    List<TextInputFormatter>? formatters,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      maxLines: maxLines,
      inputFormatters: formatters,
      style: TextStyle(
        color: color ?? ColorManager.white,
        fontWeight: enabled ? FontWeight.normal : FontWeight.bold,
      ),
      keyboardType: isNumber
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        suffixText: suffix,
        suffixStyle: TextStyle(color: ColorManager.availableColor),
        hintStyle: TextStyle(color: ColorManager.white.withValues(alpha: 0.3)),
        filled: true,
        fillColor: ColorManager.white.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: ColorManager.availableColor.withValues(alpha: 0.3),
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
          borderSide: BorderSide(color: ColorManager.availableColor),
        ),
      ),
    );
  }

  Widget _buildDatePickerField(DateTime date, Function(DateTime) onSelected) {
    return InkWell(
      onTap: () => _selectDate(context, date, onSelected),
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
              _dateFormatter.format(date),
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

  Widget _buildDropdownField(String hint) {
    if (_isLoadingUsers) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: ColorManager.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: ColorManager.availableColor.withValues(alpha: 0.3),
          ),
        ),
        child: Center(
          child: SizedBox(
            height: 20.h,
            width: 20.h,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: ColorManager.availableColor,
            ),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return DropdownMenu<String>(
          width: constraints.maxWidth,
          initialSelection: _selectedUser,
          hintText: hint,
          enableSearch: true,
          enableFilter: true,
          requestFocusOnTap: true,
          textStyle: TextStyle(color: ColorManager.white, fontSize: 14.sp),
          menuStyle: MenuStyle(
            backgroundColor: WidgetStateProperty.all(
              ColorManager.darkGrayColor,
            ),
            maximumSize: WidgetStateProperty.all(Size.fromHeight(300.h)),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: ColorManager.white.withValues(alpha: 0.05),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 8.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: ColorManager.availableColor.withValues(alpha: 0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: ColorManager.availableColor.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: ColorManager.availableColor),
            ),
            hintStyle: TextStyle(
              color: ColorManager.white.withValues(alpha: 0.3),
              fontSize: 14.sp,
            ),
          ),
          dropdownMenuEntries: _users.map((CustomerModel user) {
            return DropdownMenuEntry<String>(
              value: user.code?.toString() ?? "",
              label: user.nameA ?? "",
              style: MenuItemButton.styleFrom(
                foregroundColor: ColorManager.white,
              ),
            );
          }).toList(),
          onSelected: (String? newValue) {
            setState(() {
              _selectedUser = newValue;
            });
          },
        );
      },
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

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  static final NumberFormat _formatter = NumberFormat('#,##0.##', 'en_US');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Allow typing only numbers, commas and one dot
    String baseText = newValue.text.replaceAll(',', '');

    // Check if it's a valid partial number
    if (baseText == '.' || baseText == '-') return newValue;

    try {
      double value = double.parse(baseText);

      // Handle the case where the user is typing a decimal
      if (newValue.text.endsWith('.')) {
        return newValue;
      }

      // Format the number
      String formatted = _formatter.format(value);

      // Special handling for fractional parts to allow typing .0 or .01
      if (baseText.contains('.')) {
        List<String> parts = baseText.split('.');
        String integerPart = _formatter.format(int.parse(parts[0]));
        String decimalPart = parts[1];
        if (decimalPart.length > 2) {
          decimalPart = decimalPart.substring(0, 2);
        }
        formatted = '$integerPart.$decimalPart';
      }

      return newValue.copyWith(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    } catch (e) {
      return oldValue;
    }
  }
}
