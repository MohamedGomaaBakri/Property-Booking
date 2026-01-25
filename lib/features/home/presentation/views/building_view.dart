import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:propertybooking/core/utils/services/service_locator.dart';
import 'package:propertybooking/features/home/data/datasource/home_datasource.dart';
import 'package:propertybooking/features/home/data/models/building_model.dart';
import 'package:propertybooking/features/home/data/models/unit_model.dart';
import 'package:propertybooking/features/home/data/models/building_photo_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../../core/utils/manager/color_manager/color_manager.dart';
import '../../../../core/utils/manager/assets_manager/image_manager.dart';
import '../../../../core/widgets/Images/custome_image.dart';
import '../../../../core/widgets/Images/custome_network_image.dart';
import '../widgets/unit_card.dart';

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
              'المبنى',
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
                  return Center(
                    child: CircularProgressIndicator(
                      color: ColorManager.brandBlue,
                      strokeWidth: 2.0,
                    ),
                  );
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
                          color: ColorManager.errorColor,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'خطأ في تحميل الوحدات',
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
                              _unitsFuture = _homeDatasource.getUnitsByBuilding(
                                widget.building.buildingCode!,
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
                          Icons.apartment_outlined,
                          size: 60.sp,
                          color: ColorManager.white.withValues(alpha: 0.5),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'لا توجد وحدات متاحة',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorManager.white,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'لم يتم العثور على وحدات في هذا المبنى',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: ColorManager.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final units = snapshot.data![0] as List<UnitModel>;
                final photos = snapshot.data![1] as List<BuildingPhotoModel>;
                log(
                  '✅ Displaying ${units.length} units and ${photos.length} photos',
                  name: 'BuildingView',
                );

                // Group units by model code
                Map<int, List<UnitModel>> unitsByModel = {};
                for (var unit in units) {
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

                // Get unique model codes from both units and photos
                final allModelCodes = {
                  ...unitsByModel.keys,
                  ...photosByModel.keys,
                }.toList()..sort();

                return RefreshIndicator(
                  color: ColorManager.brandBlue,
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
                              _buildLegendItem('متاحة', Color(0xFF2ECC71)),
                              _buildLegendItem(
                                'محجوزة',
                                ColorManager.white.withValues(alpha: 0.1),
                              ),
                              _buildLegendItem('مباعة', Color(0xFFE74C3C)),
                            ],
                          ),
                        );
                      }

                      // Model sections
                      final modelCode = allModelCodes[index - 1];
                      final modelUnits = unitsByModel[modelCode] ?? [];
                      final modelPhotos = photosByModel[modelCode] ?? [];
                      final modelName = modelPhotos.isNotEmpty
                          ? modelPhotos.first.modelName ?? 'موديل $modelCode'
                          : 'موديل $modelCode';

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Model Title
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 4.w,
                              vertical: 16.h,
                            ),
                            child: Text(
                              modelName,
                              style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                                color: ColorManager.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withValues(alpha: 0.5),
                                    offset: const Offset(0, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Photo Carousel
                          if (modelPhotos.isNotEmpty)
                            CarouselSlider(
                              options: CarouselOptions(
                                height: 200.h,
                                enlargeCenterPage: true,
                                autoPlay: true,
                                autoPlayInterval: Duration(seconds: 3),
                                viewportFraction: 0.9,
                              ),
                              items: modelPhotos.map((photo) {
                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.3,
                                        ),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12.r),
                                    child: CustomNetworkImage(
                                      image: photo.photoURL ?? '',
                                      placeHolder: ImageManager.splashImage,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),

                          SizedBox(height: 16.h),

                          // Unit Cards for this model
                          ...modelUnits.map((unit) => UnitCard(unit: unit)).toList(),

                          SizedBox(height: 24.h),
                        ],
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

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 20.w,
          height: 20.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4.r),
            border: Border.all(
              color: ColorManager.white.withValues(alpha: 0.3),
              width: 1.w,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: ColorManager.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

}
