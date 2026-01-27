import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/manager/color_manager/color_manager.dart';
import '../../../data/models/customer_model.dart';

class UnitDetailDropdown extends StatelessWidget {
  final String? selectedUser;
  final List<CustomerModel> users;
  final Function(String?) onSelected;
  final bool isLoading;
  final String hint;

  const UnitDetailDropdown({
    super.key,
    required this.selectedUser,
    required this.users,
    required this.onSelected,
    required this.isLoading,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
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
          initialSelection: selectedUser,
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
          dropdownMenuEntries: users.map((CustomerModel user) {
            return DropdownMenuEntry<String>(
              value: user.code?.toString() ?? "",
              label: user.nameA ?? "",
              style: MenuItemButton.styleFrom(
                foregroundColor: ColorManager.white,
              ),
            );
          }).toList(),
          onSelected: onSelected,
        );
      },
    );
  }
}
