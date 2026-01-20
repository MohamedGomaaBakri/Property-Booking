import 'package:flutter/material.dart';
import 'package:propertybooking/core/utils/manager/assets_manager/image_manager.dart';
import 'package:propertybooking/core/utils/navigation/navigation_context_extension.dart';
import 'package:propertybooking/core/utils/navigation/router_path.dart';
import 'package:propertybooking/core/widgets/Images/custome_image.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      context.pushReplacementNamed(RouterPath.loginView);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image - fills the entire screen
          // Image.asset('assets/images/splash.png', fit: BoxFit.fill),
          CustomImage(image: ImageManager.splashImage, fit: BoxFit.fill),

          // Center content - App Icon and Name
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Icon - يمكنك تغيير الأيقونة حسب رغبتك
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.home_work_rounded,
                    size: 70,
                    color: Color(0xFF1A4D6D),
                  ),
                ),

                const SizedBox(height: 24),

                // App Name
                Text(
                  'Property Booking',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: Offset(0, 2),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Tagline
                Text(
                  'Find Your Dream Property',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                    letterSpacing: 1.2,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: Offset(0, 1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
