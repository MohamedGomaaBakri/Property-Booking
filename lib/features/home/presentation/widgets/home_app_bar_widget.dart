import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:propertybooking/core/providers/language_provider.dart';
import 'package:propertybooking/core/utils/manager/color_manager/color_manager.dart';
import 'package:propertybooking/features/auth/presentation/manager/auth_cubit/auth_cubit_cubit.dart';
import 'package:propertybooking/features/auth/data/models/user_model.dart';
import 'package:propertybooking/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/manager/assets_manager/image_manager.dart';
import '../../../../core/widgets/Images/custome_image.dart';

class HomeAppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  final UserModel userModel;

  const HomeAppBarWidget({super.key, required this.userModel});

  @override
  State<HomeAppBarWidget> createState() => _HomeAppBarWidgetState();

  @override
  Size get preferredSize => Size.fromHeight(100.h);
}

class _HomeAppBarWidgetState extends State<HomeAppBarWidget> {
  String _currentLocation = '';
  Timer? _timer;
  bool _isLoadingLocation = true;

  @override
  void initState() {
    super.initState();
    _startTimer();
    // Delay location fetch to avoid accessing Localizations in initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentLocation();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) {
        setState(() {}); // Trigger rebuild to update time
      }
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            setState(() {
              _currentLocation = ''; // Will show localized "Unknown" in build
              _isLoadingLocation = false;
            });
          }
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty && mounted) {
        final placemark = placemarks.first;
        setState(() {
          _currentLocation =
              '${placemark.administrativeArea ?? ''}, ${placemark.country ?? ''}';
          _isLoadingLocation = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _currentLocation = ''; // Will show localized "Unknown" in build
          _isLoadingLocation = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Provider.of<LanguageProvider>(context).isArabic;
    final now = DateTime.now();
    final formatter = DateFormat('h:mm a', isArabic ? 'ar' : 'en');
    final currentTime = formatter.format(now);
    final displayLocation = _currentLocation.isEmpty && !_isLoadingLocation
        ? AppLocalizations.of(context)!.unknownZone
        : _currentLocation;
    return AppBar(
      backgroundColor: ColorManager.darkGrayColor.withValues(alpha: 0.15),
      automaticallyImplyLeading: false,
      elevation: 0,
      toolbarHeight: 100.h,
      title: Row(
        children: [
          // Profile Picture
          Container(
            width: 54.w,
            height: 54.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorManager.availableColor.withValues(alpha: 0.1),
              border: Border.all(
                color: ColorManager.availableColor.withValues(alpha: 0.3),
                width: 1.5.w,
              ),
            ),
            child: ClipOval(
              child: CustomImage(
                image: ImageManager.profileImage,
                fit: BoxFit.cover,
                height: 54.h,
                width: 54.w,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          // Name and Role
          Expanded(child: _buildUserInfo(context)),
          SizedBox(width: 8.w),
          // Location and Time
          _buildLocationTimeWidget(
            currentTime: currentTime,
            displayLocation: displayLocation,
            isLoadingLocation: _isLoadingLocation,
          ),
        ],
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 16.w, left: 16.w),
          child: _buildIconButton(
            icon: Icons.logout_rounded,
            onTap: () => _showLogoutDialog(context),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationTimeWidget({
    required String currentTime,
    required String displayLocation,
    required bool isLoadingLocation,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildPillIndicator(icon: Icons.access_time_rounded, text: currentTime),
        SizedBox(height: 6.h),
        _buildPillIndicator(
          icon: Icons.location_on_rounded,
          text: isLoadingLocation ? '...' : displayLocation,
          isLoading: isLoadingLocation,
        ),
      ],
    );
  }

  Widget _buildPillIndicator({
    required IconData icon,
    required String text,
    bool isLoading = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: ColorManager.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ColorManager.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: ColorManager.availableColor, size: 14.sp),
          SizedBox(width: 6.w),
          if (isLoading)
            SizedBox(
              width: 12.w,
              height: 12.h,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                color: ColorManager.availableColor,
              ),
            )
          else
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100.w),
              child: Text(
                text,
                style: GoogleFonts.poppins(
                  color: ColorManager.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: ColorManager.availableColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: ColorManager.availableColor.withValues(alpha: 0.2),
          ),
        ),
        child: Icon(icon, color: ColorManager.availableColor, size: 24.sp),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final user = widget.userModel.items?.firstOrNull;
    final name = isArabic
        ? (user?.empName ?? l10n.guest)
        : (user?.empNameE ?? user?.empName ?? l10n.guest);
    final role = user?.roleNameA ?? l10n.propertyManager;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          name,
          style: GoogleFonts.poppins(
            color: ColorManager.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 2.h),
        Text(
          role,
          style: GoogleFonts.poppins(
            color: ColorManager.availableColor.withValues(alpha: 0.8),
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ColorManager.black.withValues(alpha: 0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
          side: BorderSide(color: ColorManager.availableColor, width: 1.w),
        ),
        title: Text(
          l10n.logout,
          style: TextStyle(
            color: ColorManager.availableColor,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          isArabic
              ? 'هل أنت متأكد من تسجيل الخروج؟'
              : 'Are you sure you want to logout?',
          style: TextStyle(color: ColorManager.white),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              isArabic ? 'إلغاء' : 'Cancel',
              style: TextStyle(
                color: ColorManager.white.withValues(alpha: 0.7),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<AuthCubitCubit>().logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                'LoginView',
                (route) => false,
              );
            },
            child: Text(
              l10n.logout,
              style: TextStyle(
                color: ColorManager.availableColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
