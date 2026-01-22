import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:propertybooking/core/utils/navigation/navigation_context_extension.dart';
import 'package:propertybooking/core/utils/navigation/router_path.dart';
import 'package:propertybooking/features/home/data/datasource/home_datasource.dart';
import 'package:propertybooking/features/home/data/models/land_model.dart';
import 'package:propertybooking/features/home/data/models/project_model.dart';
import 'package:propertybooking/features/home/presentation/widgets/land_card.dart';
import '../../../../core/utils/manager/color_manager/color_manager.dart';
import '../../../../core/utils/manager/assets_manager/image_manager.dart';
import '../../../../core/widgets/Images/custome_image.dart';

class LandView extends StatefulWidget {
  final ProjectModel project;
  final HomeDatasource homeDatasource;

  const LandView({
    super.key,
    required this.project,
    required this.homeDatasource,
  });

  @override
  State<LandView> createState() => _LandViewState();
}

class _LandViewState extends State<LandView> {
  late Future<List<LandModel>> _landsFuture;

  @override
  void initState() {
    super.initState();
    _landsFuture = widget.homeDatasource.getLandByProject(
      widget.project.buildingCode!,
    );
  }

  void _onLandCardTap(LandModel land) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(color: ColorManager.brandBlue),
        ),
      );

      // Fetch buildings
      final buildings = await widget.homeDatasource.getBuildingByLand(
        land.buildingCode!,
      );

      // Close loading dialog
      if (mounted) Navigator.pop(context);

      if (buildings.isEmpty) {
        // Show error if no buildings found
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('لا توجد مباني متاحة'),
              backgroundColor: ColorManager.errorColor,
            ),
          );
        }
        return;
      }

      // Navigate to BuildingView with first building only
      if (mounted) {
        context.pushNamed(RouterPath.buildingView, arguments: buildings.first);
      }
    } catch (e) {
      // Close loading dialog if still open
      if (mounted) Navigator.pop(context);

      log('Error fetching buildings: $e', name: 'LandView');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ أثناء تحميل المباني'),
            backgroundColor: ColorManager.errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.black.withValues(alpha: 0.4),
      appBar: AppBar(
        backgroundColor: ColorManager.darkGrayColor.withValues(alpha: 0.15),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: ColorManager.white,
            size: 22.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.project.buildingNameA ??
              widget.project.buildingNameE ??
              'الأراضي',
          style: TextStyle(
            color: ColorManager.white,
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
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
        centerTitle: true,
        elevation: 0,
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
            child: FutureBuilder<List<LandModel>>(
              future: _landsFuture,
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
                  log(snapshot.error.toString(), name: "LandView Error");
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
                          'خطأ في تحميل الأراضي',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorManager.white,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'يرجى المحاولة مرة أخرى',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: ColorManager.white.withValues(alpha: 0.7),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _landsFuture = widget.homeDatasource
                                  .getLandByProject(
                                    widget.project.buildingCode!,
                                  );
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
                            'إعادة المحاولة',
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
                          Icons.landscape_outlined,
                          size: 60.sp,
                          color: ColorManager.white.withValues(alpha: 0.5),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'لا توجد أراضي متاحة',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorManager.white,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'لم يتم العثور على أراضي في هذا المشروع',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: ColorManager.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final lands = snapshot.data!;
                log('✅ Displaying ${lands.length} lands', name: 'LandView');

                return RefreshIndicator(
                  color: ColorManager.brandBlue,
                  onRefresh: () async {
                    setState(() {
                      _landsFuture = widget.homeDatasource.getLandByProject(
                        widget.project.buildingCode!,
                      );
                    });
                    await _landsFuture;
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    itemCount: lands.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 8.h,
                          horizontal: 4.w,
                        ),
                        child: LandCard(
                          index: index,
                          land: lands[index],
                          onTap: () => _onLandCardTap(lands[index]),
                        ),
                      );
                    },
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
