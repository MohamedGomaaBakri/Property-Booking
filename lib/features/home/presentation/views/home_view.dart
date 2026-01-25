import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:propertybooking/core/utils/services/service_locator.dart';
import 'package:propertybooking/features/auth/presentation/manager/auth_cubit/auth_cubit_cubit.dart';
import 'package:propertybooking/features/home/data/datasource/home_datasource.dart';
import 'package:propertybooking/features/home/data/models/zone_model.dart';
import 'package:propertybooking/features/home/presentation/views/projects_view.dart';
import 'package:propertybooking/features/home/presentation/widgets/zone_card.dart';
import 'package:propertybooking/core/utils/manager/color_manager/color_manager.dart';
import 'package:propertybooking/l10n/app_localizations.dart';

import 'package:propertybooking/features/auth/data/models/user_model.dart';

import '../../../../core/utils/manager/assets_manager/image_manager.dart';
import '../../../../core/widgets/Images/custome_image.dart';

class HomeView extends StatefulWidget {
  final UserModel userModel;
  const HomeView({super.key, required this.userModel});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late Future<List<ZoneModel>> _zonesFuture;
  late HomeDatasource _homeDatasource;

  @override
  void initState() {
    super.initState();
    _homeDatasource = getIt<HomeDatasource>();
    _zonesFuture = _homeDatasource.getAllZones();
  }

  void _onZoneCardTap(ZoneModel zone) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ProjectsView(zone: zone, homeDatasource: _homeDatasource),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
              // Perform logout
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

  bool get isArabic => Localizations.localeOf(context).languageCode == 'ar';

  @override
  Widget build(BuildContext context) {
    log(getIt<AuthCubitCubit>().state.userModel.toString() ?? "");
    return Scaffold(
      backgroundColor: ColorManager.black.withValues(alpha: 0.4),
      appBar: AppBar(
        backgroundColor: ColorManager.darkGrayColor.withValues(alpha: 0.15),
        automaticallyImplyLeading: false,
        elevation: 0,
        toolbarHeight: 80.h, // Increased height for profile info
        title: Row(
          children: [
            // Profile Picture
            Container(
              width: 50.w,
              height: 50.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorManager.brandBlue.withValues(alpha: 0.2),
                border: Border.all(
                  color: ColorManager.brandBlue.withValues(alpha: 0.5),
                  width: 2.w,
                ),
                boxShadow: [
                  BoxShadow(
                    color: ColorManager.brandBlue.withValues(alpha: 0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                Icons.person_rounded,
                color: ColorManager.white,
                size: 30.sp,
              ),
            ),

            SizedBox(width: 16.w),

            // Name and Role
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Welcome Text
                  Text(
                    AppLocalizations.of(context)!.welcomeBack,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: ColorManager.white.withValues(alpha: 0.8),
                      letterSpacing: 0.3,
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // User Name
                  Text(
                    widget.userModel.items?.firstOrNull?.empName ??
                        AppLocalizations.of(context)!.guest,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorManager.white,
                      letterSpacing: 0.5,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          offset: const Offset(0, 2),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 2.h),

                  // User Role
                  Text(
                    widget.userModel.items?.firstOrNull?.roleNameA ??
                        AppLocalizations.of(context)!.propertyManager,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: ColorManager.white.withValues(alpha: 0.7),
                      letterSpacing: 0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showLogoutDialog(context);
            },
            icon: Icon(
              Icons.logout_rounded,
              color: ColorManager.availableColor,
              size: 28.sp,
            ),
            tooltip: AppLocalizations.of(context)!.logout,
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background with gradient overlay
          CustomImage(image: ImageManager.splashImage, fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  ColorManager.black.withValues(alpha: 0.4),
                  ColorManager.black.withValues(alpha: 0.4),
                ],
              ),
            ),
          ),
          // Main content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: FutureBuilder<List<ZoneModel>>(
              future: _zonesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: ColorManager.brandBlue,
                      strokeWidth: 2.0,
                    ),
                  );
                }

                if (snapshot.hasError) {
                  log(snapshot.error.toString(), name: "HomeView Error");
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 60.sp,
                          color: ColorManager.errorColor,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          AppLocalizations.of(context)!.errorLoadingZones,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorManager.white,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          AppLocalizations.of(context)!.pleaseTryAgainLater,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: ColorManager.white.withValues(alpha: 0.7),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _zonesFuture = _homeDatasource.getAllZones();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorManager.brandBlue,
                            padding: EdgeInsets.symmetric(
                              horizontal: 32.w,
                              vertical: 12.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.retry,
                            style: TextStyle(
                              color: ColorManager.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_off_outlined,
                          size: 60.sp,
                          color: ColorManager.white.withValues(alpha: 0.5),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          AppLocalizations.of(context)!.noZonesAvailable,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorManager.white,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          AppLocalizations.of(
                            context,
                          )!.checkBackLaterForUpdates,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: ColorManager.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final zones = snapshot.data!;
                log('✅ Displaying ${zones.length} zones', name: 'HomeView');

                return RefreshIndicator(
                  color: ColorManager.brandBlue,
                  onRefresh: () async {
                    setState(() {
                      _zonesFuture = _homeDatasource.getAllZones();
                    });
                    await _zonesFuture;
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Zones Title
                      Padding(
                        padding: EdgeInsets.only(
                          left: 4.w,
                          bottom: 8.h,
                          top: 8.h,
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.availableZones,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: ColorManager.white,
                            letterSpacing: 0.5,
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                offset: const Offset(0, 2),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Zones List
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          itemCount: zones.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 8.h,
                                horizontal: 4.w,
                              ),
                              child: ZoneCard(
                                index: index,
                                zone: zones[index],
                                onTap: () => _onZoneCardTap(zones[index]),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
