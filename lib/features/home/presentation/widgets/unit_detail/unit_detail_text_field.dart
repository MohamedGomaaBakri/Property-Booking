import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../../core/utils/manager/color_manager/color_manager.dart';

class UnitDetailTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hint;
  final bool isNumber;
  final int maxLines;
  final bool enabled;
  final String? suffix;
  final Color? color;
  final List<TextInputFormatter>? formatters;
  final String? errorText;
  final FocusNode? focusNode;

  const UnitDetailTextField({
    super.key,
    required this.controller,
    this.hint,
    this.isNumber = false,
    this.maxLines = 1,
    this.enabled = true,
    this.suffix,
    this.color,
    this.formatters,
    this.errorText,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      maxLines: maxLines,
      inputFormatters: formatters,
      focusNode: focusNode,
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
        errorText: errorText,
        errorStyle: TextStyle(color: ColorManager.soldColor, fontSize: 12.sp),
        suffixStyle: TextStyle(color: ColorManager.availableColor),
        hintStyle: TextStyle(color: ColorManager.white.withValues(alpha: 0.3)),
        filled: true,
        fillColor: ColorManager.white.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: errorText != null
                ? ColorManager.soldColor
                : ColorManager.availableColor.withValues(alpha: 0.3),
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
            color: errorText != null
                ? ColorManager.soldColor
                : ColorManager.availableColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: errorText != null
                ? ColorManager.soldColor
                : ColorManager.availableColor.withValues(alpha: 0.3),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: ColorManager.soldColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: ColorManager.soldColor, width: 2.w),
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
