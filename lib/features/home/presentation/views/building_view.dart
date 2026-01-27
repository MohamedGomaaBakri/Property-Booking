import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:propertybooking/core/utils/services/service_locator.dart';
import 'package:propertybooking/features/home/data/datasource/home_datasource.dart';
import 'package:propertybooking/features/home/data/models/building_model.dart';
import 'package:propertybooking/features/home/data/models/unit_model.dart';
import 'package:propertybooking/features/home/data/models/building_photo_model.dart';
import '../../../../core/utils/manager/color_manager/color_manager.dart';
import '../../../../core/utils/manager/assets_manager/image_manager.dart';
import '../../../../core/widgets/Images/custome_image.dart';
import '../widgets/model_section.dart';
import '../../../../l10n/app_localizations.dart';

class BuildingView extends StatefulWidget {
  final BuildingModel building;

  const BuildingView({super.key, required this.building});

  @override
  State<BuildingView> createState() => _BuildingViewState();
}

class _BuildingViewState extends State<BuildingView> {
  late Future<List<UnitModel>> _unitsFuture;
  late Future<List<BuildingPhotoModel>> _photosFuture;
  late HomeDatasource _homeDatasource;
  int? _selectedStatus; // null = all, 0 = available, 1 = reserved, 3 = sold

  @override
  void initState() {
    super.initState();
    _homeDatasource = getIt<HomeDatasource>();
    _unitsFuture = _homeDatasource.getUnitsByBuilding(
      widget.building.buildingCode!,
    );
    _photosFuture = _homeDatasource.getAllPhotosByBuilding(
      widget.building.buildingCode!,
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
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
          widget.building.buildingNameA ??
              widget.building.buildingNameE ??
              localizations.building,
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
            child: FutureBuilder<List<dynamic>>(
              future: Future.wait([_unitsFuture, _photosFuture]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildSkeletonBody();
                }

                if (snapshot.hasError) {
                  log(snapshot.error.toString(), name: "BuildingView Error");
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 60.sp,
                          color: ColorManager.soldColor,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          localizations.errorLoadingUnits,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorManager.white,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          localizations.tryAgain,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: ColorManager.white.withValues(alpha: 0.7),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _unitsFuture = _homeDatasource.getUnitsByBuilding(
                                widget.building.buildingCode!,
                              );
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorManager.availableColor,
                            padding: EdgeInsets.symmetric(
                              horizontal: 32.w,
                              vertical: 12.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            localizations.retry,
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

                if (!snapshot.hasData || (snapshot.data![0] as List).isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.apartment_outlined,
                          size: 60.sp,
                          color: ColorManager.white.withValues(alpha: 0.5),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          localizations.noUnitsAvailable,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorManager.white,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          localizations.noUnitsFoundInBuilding,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: ColorManager.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final List<UnitModel> allUnits =
                    snapshot.data![0] as List<UnitModel>;
                final photos = snapshot.data![1] as List<BuildingPhotoModel>;

                // Apply filtering
                final filteredUnits = _selectedStatus == null
                    ? allUnits
                    : allUnits
                          .where(
                            (u) => u.unitStatus?.toInt() == _selectedStatus,
                          )
                          .toList();

                log(
                  '✅ Displaying ${filteredUnits.length} units and ${photos.length} photos',
                  name: 'BuildingView',
                );

                // Group units by model code
                Map<int, List<UnitModel>> unitsByModel = {};
                for (var unit in filteredUnits) {
                  final modelCode = unit.modelCode?.toInt() ?? 0;
                  if (!unitsByModel.containsKey(modelCode)) {
                    unitsByModel[modelCode] = [];
                  }
                  unitsByModel[modelCode]!.add(unit);
                }

                // Group photos by model code
                Map<int, List<BuildingPhotoModel>> photosByModel = {};
                for (var photo in photos) {
                  final modelCode = photo.modelCode ?? 0;
                  if (!photosByModel.containsKey(modelCode)) {
                    photosByModel[modelCode] = [];
                  }
                  photosByModel[modelCode]!.add(photo);
                }

                // Get unique model codes from both photos AND filtered units
                // We show models that have units or photos
                final allModelCodes = {
                  ...unitsByModel.keys,
                  ...photosByModel.keys,
                }.toList()..sort();

                return RefreshIndicator(
                  color: ColorManager.availableColor,
                  onRefresh: () async {
                    setState(() {
                      _unitsFuture = _homeDatasource.getUnitsByBuilding(
                        widget.building.buildingCode!,
                      );
                      _photosFuture = _homeDatasource.getAllPhotosByBuilding(
                        widget.building.buildingCode!,
                      );
                    });
                    await Future.wait([_unitsFuture, _photosFuture]);
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    itemCount: allModelCodes.length + 1, // +1 for legend
                    itemBuilder: (context, index) {
                      // First item is the color legend
                      if (index == 0) {
                        return Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 8.h,
                            horizontal: 4.w,
                          ),
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: ColorManager.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: ColorManager.white.withValues(alpha: 0.3),
                              width: 1.w,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildLegendItem(
                                localizations.all,
                                ColorManager.white,
                                null,
                              ),
                              _buildLegendItem(
                                localizations.available,
                                ColorManager.availableColor,
                                0,
                              ),
                              _buildLegendItem(
                                localizations.reserved,
                                ColorManager.white.withValues(alpha: 0.4),
                                1,
                              ),
                              _buildLegendItem(
                                localizations.sold,
                                ColorManager.soldColor,
                                3,
                              ),
                            ],
                          ),
                        );
                      }

                      // Model sections
                      final modelCode = allModelCodes[index - 1];
                      final modelUnits = unitsByModel[modelCode] ?? [];
                      final modelPhotos = photosByModel[modelCode] ?? [];

                      // Skip if filtering and no units for this model
                      if (_selectedStatus != null && modelUnits.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      final modelName = modelPhotos.isNotEmpty
                          ? modelPhotos.first.modelName ?? 'موديل $modelCode'
                          : 'موديل $modelCode';

                      return ModelSection(
                        modelName: modelName,
                        units: modelUnits,
                        photos: modelPhotos,
                        allFilteredUnits: filteredUnits,
                        onRefresh: () {
                          setState(() {
                            _unitsFuture = _homeDatasource.getUnitsByBuilding(
                              widget.building.buildingCode!,
                            );
                            _photosFuture = _homeDatasource
                                .getAllPhotosByBuilding(
                                  widget.building.buildingCode!,
                                );
                          });
                        },
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

  Widget _buildSkeletonBody() {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        itemCount: 4,
        itemBuilder: (context, index) {
          if (index == 0) {
            // Legend Skeleton
            return Container(
              height: 60.h,
              margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
              decoration: BoxDecoration(
                color: ColorManager.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
            );
          }

          // Model Section Skeleton (Mimicking ModelSection layout)
          return Container(
            height: 200.h,
            margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: ColorManager.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Stack(
              children: [
                // Bottom Info Column (Mimicking the real UI)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Model Name Skeleton
                        Container(
                          width: 150.w,
                          height: 20.h,
                          decoration: BoxDecoration(
                            color: ColorManager.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        // Available Units Skeleton
                        Container(
                          width: 100.w,
                          height: 14.h,
                          decoration: BoxDecoration(
                            color: ColorManager.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, int? status) {
    bool isSelected = _selectedStatus == status;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedStatus = status;
        });
      },
      borderRadius: BorderRadius.circular(8.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 1.w,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16.w,
              height: 16.h,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4.r),
                border: Border.all(
                  color: ColorManager.white.withValues(alpha: 0.3),
                  width: 1.w,
                ),
              ),
            ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                color: isSelected
                    ? ColorManager.white
                    : ColorManager.white.withValues(alpha: 0.7),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
