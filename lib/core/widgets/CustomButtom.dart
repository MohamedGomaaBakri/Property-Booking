import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:propertybooking/core/utils/manager/style_manager/theme/AppColor.dart';
import 'package:propertybooking/core/utils/manager/style_manager/theme/AppStyle.dart'
    show Appstyle;

class CustomButtom extends StatelessWidget {
  const CustomButtom({super.key, required this.text, required this.onTap});
  final String text;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(300.w, 53.46.h),
        backgroundColor: AppColor.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(17.82.r),
        ),
      ),
      onPressed: onTap,
      child: Text(text, style: Appstyle.TextButttonstyle),
    );
  }
}
