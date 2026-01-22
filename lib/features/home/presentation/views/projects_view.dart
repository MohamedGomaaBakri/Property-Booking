import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:propertybooking/core/utils/navigation/navigation_context_extension.dart';
import 'package:propertybooking/core/utils/navigation/router_path.dart';
import 'package:propertybooking/features/home/data/datasource/home_datasource.dart';
import 'package:propertybooking/features/home/data/models/project_model.dart';
import 'package:propertybooking/features/home/data/models/zone_model.dart';
import 'package:propertybooking/features/home/presentation/widgets/project_card.dart';
import 'package:propertybooking/l10n/app_localizations.dart';
import '../../../../core/utils/manager/color_manager/color_manager.dart';
import '../../../../core/utils/manager/assets_manager/image_manager.dart';
import '../../../../core/widgets/Images/custome_image.dart';

class ProjectsView extends StatefulWidget {
  final ZoneModel zone;
  final HomeDatasource homeDatasource;

  const ProjectsView({
    super.key,
    required this.zone,
    required this.homeDatasource,
  });

  @override
  State<ProjectsView> createState() => _ProjectsViewState();
}

class _ProjectsViewState extends State<ProjectsView> {
  late Future<List<ProjectModel>> _projectsFuture;

  @override
  void initState() {
    super.initState();
    _projectsFuture = widget.homeDatasource.getProjectByZone(
      widget.zone.buildingCode!,
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
          widget.zone.buildingNameA ??
              widget.zone.buildingNameE ??
              AppLocalizations.of(context)!.projects,
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
            child: FutureBuilder<List<ProjectModel>>(
              future: _projectsFuture,
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
                  log(snapshot.error.toString(), name: "ProjectsView Error");
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
                          AppLocalizations.of(context)!.errorLoadingProjects,
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
                              _projectsFuture = widget.homeDatasource
                                  .getProjectByZone(widget.zone.buildingCode!);
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
                          Icons.folder_off_outlined,
                          size: 60.sp,
                          color: ColorManager.white.withValues(alpha: 0.5),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          AppLocalizations.of(context)!.noProjectsAvailable,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorManager.white,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          AppLocalizations.of(context)!.noProjectsFoundInZone,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: ColorManager.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final projects = snapshot.data!;
                log(
                  '✅ Displaying ${projects.length} projects',
                  name: 'ProjectsView',
                );

                return RefreshIndicator(
                  color: ColorManager.brandBlue,
                  onRefresh: () async {
                    setState(() {
                      _projectsFuture = widget.homeDatasource.getProjectByZone(
                        widget.zone.buildingCode!,
                      );
                    });
                    await _projectsFuture;
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    itemCount: projects.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 8.h,
                          horizontal: 4.w,
                        ),
                        child: ProjectCard(
                          index: index,
                          project: projects[index],
                          onTap: () {
                            context.pushNamed(
                              RouterPath.landView,
                              arguments: {
                                'project': projects[index],
                                'homeDatasource': widget.homeDatasource,
                              },
                            );
                          },
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
