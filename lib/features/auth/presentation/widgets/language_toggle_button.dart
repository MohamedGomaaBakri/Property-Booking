import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:propertybooking/core/providers/language_provider.dart';
import 'package:propertybooking/core/utils/manager/color_manager/color_manager.dart';
import 'dart:ui';

class LanguageToggleButton extends StatelessWidget {
  const LanguageToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        final isArabic = languageProvider.isArabic;

        return Positioned(
          top: 50.h,
          right: isArabic ? 20.w : null,
          left: isArabic ? null : 20.w,
          child: GestureDetector(
            onTap: () {
              languageProvider.toggleLanguage();
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: ColorManager.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: ColorManager.white.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: ColorManager.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.language,
                        color: ColorManager.white,
                        size: 20.sp,
                      ),
                      SizedBox(width: 8.w),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: ScaleTransition(
                              scale: animation,
                              child: child,
                            ),
                          );
                        },
                        child: Text(
                          isArabic ? 'EN' : 'AR',
                          key: ValueKey(isArabic),
                          style: TextStyle(
                            color: ColorManager.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
