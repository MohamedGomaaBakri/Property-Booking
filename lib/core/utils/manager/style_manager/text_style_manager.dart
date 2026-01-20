// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class TextStyleManager {
//   static double adaptiveFontSize(double size) {
//     double scaleFactor = ScreenUtil().screenWidth > 600 ? 0.6 : 1.0;
//     return (size * scaleFactor).sp;
//   }
//   // ============= 8 =============

//   static TextStyle style8RegWhite = TextStyle(
//     fontSize: adaptiveFontSize(8),
//     fontWeight: FontWeight.w400,
//     color: Colors.white,
//   );

//   static TextStyle style8RegBlack = TextStyle(
//     fontSize: adaptiveFontSize(8),
//     fontWeight: FontWeight.w400,
//     color: Colors.black,
//   );
//   // ============= 10 =============

//   static TextStyle style10RegWhite = TextStyle(
//     fontSize: adaptiveFontSize(10),
//     fontWeight: FontWeight.w400,
//   );
//   // ============= 11 =============

//   static TextStyle style11RegWhite = TextStyle(
//     fontSize: adaptiveFontSize(11),
//     fontWeight: FontWeight.w400,
//     color: Colors.white,
//   );
//   // ============= 13 =============

//   static TextStyle style13RegWhite = TextStyle(
//     fontSize: adaptiveFontSize(13),
//     fontWeight: FontWeight.w400,
//     color: Colors.white,
//   );
//   // ============= 14 =============

//   static TextStyle style14RegWhite = TextStyle(
//     fontSize: adaptiveFontSize(14),
//     fontWeight: FontWeight.w400,
//     color: Colors.white,
//   );
//   static TextStyle style14BoldWhite = TextStyle(
//     fontSize: adaptiveFontSize(14),
//     fontWeight: FontWeight.w700,
//     color: Colors.white,
//   );
//   static TextStyle style14RegDarkGray = TextStyle(
//     fontSize: adaptiveFontSize(14),
//     fontWeight: FontWeight.w400,
//     color: ColorManager.darkGray,
//   );
//   static TextStyle style14BoldBlack = TextStyle(
//     fontSize: adaptiveFontSize(14),
//     fontWeight: FontWeight.w700,
//     color: Colors.black,
//   );
//   // ============= 16 =============

//   static TextStyle style16RegWhite = TextStyle(
//     fontSize: adaptiveFontSize(16),
//     fontWeight: FontWeight.w400,
//     color: Colors.white,
//   );

//   static TextStyle style16BoldWhite = TextStyle(
//     fontSize: adaptiveFontSize(16),
//     fontWeight: FontWeight.w700,
//     color: Colors.white,
//     fontFamily: FontManager.ibmPlexSans,
//   );

//   static TextStyle style16RegGrey = TextStyle(
//     fontSize: adaptiveFontSize(16),
//     fontWeight: FontWeight.w700,
//     color: Color(0xFF999696),
//   );
//   // ============= 18 =============
//   static TextStyle style18RegWhite = TextStyle(
//     fontSize: adaptiveFontSize(18),
//     fontWeight: FontWeight.w400,
//     color: Colors.white,
//   );
//   static TextStyle style18BoldWhite = TextStyle(
//     fontSize: adaptiveFontSize(18),
//     fontWeight: FontWeight.w600,
//     color: Colors.white,
//   );
//   static TextStyle style18BoldBlack = TextStyle(
//     fontSize: adaptiveFontSize(18),
//     fontWeight: FontWeight.w600,
//     color: Colors.black,
//   );
//   // ============= 20 =============

//   static TextStyle style20RegWhite = TextStyle(
//     fontSize: adaptiveFontSize(20),
//     fontWeight: FontWeight.w400,
//     color: Colors.white,
//   );

//   static TextStyle style20RegGrey = TextStyle(
//     fontSize: adaptiveFontSize(20),
//     fontWeight: FontWeight.w400,
//     color: Color(0xFF999696),
//   );

//   static TextStyle style20BoldWhite = TextStyle(
//     fontSize: adaptiveFontSize(20),
//     fontWeight: FontWeight.w600,
//     color: Colors.white,
//   );

//   static TextStyle style20BoldDarkGray = TextStyle(
//     fontSize: adaptiveFontSize(20),
//     fontWeight: FontWeight.w700,
//     color: Color(0xFF3E3E3F),
//   );
//   // ============= 24 =============
//   static TextStyle style24BoldWhite = TextStyle(
//     fontSize: adaptiveFontSize(24),
//     fontWeight: FontWeight.w700,
//     color: Colors.white,
//     fontFamily: FontManager.ibmPlexSans,
//   );
//   // ============= 26 =============

//   static TextStyle style26RegWhite = TextStyle(
//     fontSize: adaptiveFontSize(26),
//     fontWeight: FontWeight.w400,
//     color: Colors.white,
//   );
//   // ============= 28 =============

//   static TextStyle style28BoldWhite = TextStyle(
//     fontSize: adaptiveFontSize(28),
//     fontWeight: FontWeight.w700,
//     color: Colors.white,
//   );

//   // ============= 30 =============

//   static TextStyle style30RegWhite = TextStyle(
//     fontSize: adaptiveFontSize(30),
//     fontWeight: FontWeight.w700,
//     color: Colors.white,
//   );
//   // ============= 36 =============

//   static TextStyle style36RegWhite = TextStyle(
//     fontSize: adaptiveFontSize(36),
//     fontWeight: FontWeight.w700,
//     color: Colors.white,
//   );

//   static TextStyle style36RegBlack = TextStyle(
//     fontSize: adaptiveFontSize(36),
//     fontWeight: FontWeight.w700,
//     color: Colors.black,
//   );
//   // ============ 40 ==============
//   static TextStyle style40BoldWhite = TextStyle(
//     fontSize: adaptiveFontSize(40),
//     fontWeight: FontWeight.w700,
//     color: Colors.white,
//   );

//   // ============= IBM Plex Sans Styles =============

//   // Regular IBM Plex Sans
//   static TextStyle ibmPlexSansRegular(double size, {Color? color}) => TextStyle(
//     fontSize: adaptiveFontSize(size),
//     fontFamily: FontManager.ibmPlexSans,
//     fontWeight: FontWeight.w400,
//     color: color ?? Colors.black,
//   );

//   static TextStyle ibmPlexSansMedium(double size, {Color? color}) => TextStyle(
//     fontSize: adaptiveFontSize(size),
//     fontFamily: FontManager.ibmPlexSans,
//     fontWeight: FontWeight.w500,
//     color: color ?? Colors.black,
//   );

//   static TextStyle ibmPlexSansBold(double size, {Color? color}) => TextStyle(
//     fontSize: adaptiveFontSize(size),
//     fontFamily: FontManager.ibmPlexSans,
//     fontWeight: FontWeight.w700,
//     color: color ?? Colors.black,
//   );

//   // Condensed IBM Plex Sans
//   static TextStyle ibmPlexSansCondensedRegular(double size, {Color? color}) =>
//       TextStyle(
//         fontSize: adaptiveFontSize(size),
//         fontFamily: FontManager.ibmPlexSansCondensed,
//         fontWeight: FontWeight.w400,
//         color: color ?? Colors.black,
//       );

//   static TextStyle ibmPlexSansCondensedBold(double size, {Color? color}) =>
//       TextStyle(
//         fontSize: adaptiveFontSize(size),
//         fontFamily: FontManager.ibmPlexSansCondensed,
//         fontWeight: FontWeight.w700,
//         color: color ?? Colors.black,
//       );

//   // SemiCondensed IBM Plex Sans
//   static TextStyle ibmPlexSansSemiCondensedRegular(
//     double size, {
//     Color? color,
//   }) => TextStyle(
//     fontSize: adaptiveFontSize(size),
//     fontFamily: FontManager.ibmPlexSansSemiCondensed,
//     fontWeight: FontWeight.w400,
//     color: color ?? Colors.black,
//   );

//   static TextStyle ibmPlexSansSemiCondensedBold(double size, {Color? color}) =>
//       TextStyle(
//         fontSize: adaptiveFontSize(size),
//         fontFamily: FontManager.ibmPlexSansSemiCondensed,
//         fontWeight: FontWeight.w700,
//         color: color ?? Colors.black,
//       );

//   static TextStyle chatStyle1 = TextStyle(
//     fontSize: adaptiveFontSize(28),
//     fontWeight: FontWeight.bold,
//     fontFamily: FontManager.ibmPlexSansSemiCondensed,
//     color: ColorManager.chattextColor1,
//   );
//   static TextStyle chatStyle2 = TextStyle(
//     fontSize: adaptiveFontSize(20),
//     fontWeight: FontWeight.w400,
//     fontFamily: FontManager.ibmPlexSansSemiCondensed,
//     color: ColorManager.secondaryGrayColor,
//   );

//   static TextStyle chatStyle3 = TextStyle(
//     fontSize: adaptiveFontSize(16),
//     fontWeight: FontWeight.w400,
//     fontFamily: FontManager.ibmPlexSansSemiCondensed,
//     color: ColorManager.secondaryGrayColor,
//   );
//   static TextStyle chatBotTimeColor = TextStyle(
//     fontSize: adaptiveFontSize(12),
//     fontWeight: FontWeight.w400,
//     fontFamily: FontManager.ibmPlexSansSemiCondensed,
//     color: ColorManager.grayColor,
//   );
// }
