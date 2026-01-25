import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/utils/manager/color_manager/color_manager.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/icons/pajamas.dart';

class SocialButtonsWidget extends StatelessWidget {
  const SocialButtonsWidget({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialIcon(
          icon: Ic.baseline_facebook, //Icons.facebook,
          color: ColorManager.white,
          onTap: () => _launchURL('https://www.facebook.com/ranksolutionseg'),
        ),
        SizedBox(width: 16.w),
        _buildSocialIcon(
          icon: Mdi.linkedin,
          color: ColorManager.white,
          onTap: () =>
              _launchURL('https://www.linkedin.com/company/ranksolutionseg/'),
        ),
        SizedBox(width: 16.w),
        _buildSocialIcon(
          icon: Mdi.instagram,
          color: ColorManager.white,
          onTap: () => _launchURL('https://www.instagram.com/ranksolutionseg/'),
        ),
        SizedBox(width: 16.w),
        _buildSocialIcon(
          icon: Ic.baseline_whatsapp,
          color: ColorManager.white,
          onTap: () => _launchURL(
            'https://api.whatsapp.com/send/?phone=%2B201033429826&text&type=phone_number&app_absent=0',
          ),
        ),
        SizedBox(width: 16.w),
        _buildSocialIcon(
          icon: Pajamas.twitter,
          color: ColorManager.white,
          onTap: () => _launchURL('https://x.com/RankSolutionsEG'),
        ),
      ],
    );
  }

  Widget _buildSocialIcon({
    required String icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: ColorManager.white.withValues(alpha: 0.05),
          shape: BoxShape.circle,
          border: Border.all(
            color: ColorManager.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Iconify(icon, color: color.withValues(alpha: 0.8), size: 24.sp),
      ),
    );
  }
}
