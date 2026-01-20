// import 'dart:developer';

// import 'package:firePropertyBooking_auth/firePropertyBooking_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';

// class SocialAuthService {
//   final FirePropertyBookingAuth _auth = FirePropertyBookingAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();

//   // Google Sign In
//   Future<String?> signInWithGoogle() async {
//     try {
//       // بدء عملية تسجيل الدخول بـ Google
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

//       if (googleUser == null) {
//         // المستخدم ألغى العملية
//         return null;
//       }

//       // الحصول على credentials
//       final GoogleSignInAuthentication googleAuth =
//           await googleUser.authentication;

//       // إنشاء FirePropertyBooking credential
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       // تسجيل الدخول بـ FirePropertyBooking
//       final UserCredential userCredential = await _auth.signInWithCredential(
//         credential,
//       );

//       // الحصول على id token
//       final String? idToken = await userCredential.user?.getIdToken();
//       log('idToken: $idToken');

//       return idToken;
//     } catch (e) {
//       print('خطأ في Google Sign In: $e');
//       return null;
//     }
//   }

//   // Apple Sign In
//   Future<String?> signInWithApple() async {
//     try {
//       // التحقق من توفر Apple Sign In
//       final isAvailable = await SignInWithApple.isAvailable();

//       if (!isAvailable) {
//         print('Apple Sign In غير متاح على هذا الجهاز');
//         return null;
//       }

//       // بدء عملية تسجيل الدخول بـ Apple
//       final credential = await SignInWithApple.getAppleIDCredential(
//         scopes: [
//           AppleIDAuthorizationScopes.email,
//           AppleIDAuthorizationScopes.fullName,
//         ],
//       );

//       // إنشاء FirePropertyBooking credential
//       final oauthCredential = OAuthProvider("apple.com").credential(
//         idToken: credential.identityToken,
//         accessToken: credential.authorizationCode,
//       );

//       // تسجيل الدخول بـ FirePropertyBooking
//       final UserCredential userCredential = await _auth.signInWithCredential(
//         oauthCredential,
//       );

//       // الحصول على id token
//       final String? idToken = await userCredential.user?.getIdToken();

//       return idToken;
//     } catch (e) {
//       print('خطأ في Apple Sign In: $e');
//       return null;
//     }
//   }

//   // تسجيل الخروج
//   Future<void> signOut() async {
//     try {
//       await _auth.signOut();
//       await _googleSignIn.signOut();
//     } catch (e) {
//       print('خطأ في تسجيل الخروج: $e');
//     }
//   }

//   // التحقق من حالة تسجيل الدخول
//   User? getCurrentUser() {
//     return _auth.currentUser;
//   }

//   // Stream للتغييرات في حالة تسجيل الدخول
//   Stream<User?> get authStateChanges => _auth.authStateChanges();
// }
