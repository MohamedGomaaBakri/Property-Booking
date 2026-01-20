
// class AppRouter {
//   Route? generateRoute(RouteSettings settings) {
//     final arguments = settings.arguments as dynamic;
//     switch (settings.name) {
//       case RouterPath.splashView:
//         return MaterialPageRoute(
//           builder: (context) {
//             return const SplashView();
//           },
//         );
//       case RouterPath.onBoardingView:
//         return MaterialPageRoute(
//           builder: (context) {
//             return OnBoardingView();
//           },
//         );
//       case RouterPath.login:
//         return _bottomToTopTransition(
//           const LoginView(),
//           routeName: RouterPath.login,
//         );
//       case RouterPath.register:
//         return _bottomToTopTransition(
//           const RegisterView(),
//           routeName: RouterPath.register,
//         );
//       case RouterPath.confirmPhoneView:
//         return _bottomToTopTransition(
//           ConfirmPhoneNumberView(
//             phoneNumber: arguments['phoneNumber'],
//             isForgetPassword: arguments['isForgetPassword'] ?? false,
//           ),
//           routeName: RouterPath.confirmPhoneView,
//         );
//       case RouterPath.setPasswordView:
//         return _bottomToTopTransition(
//           SetPasswordView(
//             otp: arguments['otp'],
//             phoneNumber: arguments['phoneNumber'],
//           ),
//           routeName: RouterPath.setPasswordView,
//         );
//       case RouterPath.accountCreatedSuccessfully:
//         return _bottomToTopTransition(
//           const AccountCreatedView(),
//           routeName: RouterPath.accountCreatedSuccessfully,
//         );
//       case RouterPath.forgetPasswordView:
//         return _bottomToTopTransition(
//           const ForgetPasswordView(),
//           routeName: RouterPath.forgetPasswordView,
//         );
//       case RouterPath.homeView:
//         return _bottomToTopTransition(
//           const HomeView(),
//           routeName: RouterPath.homeView,
//         );
//       case RouterPath.navBar:
//         return _bottomToTopTransition(
//           const NavBar(),
//           routeName: RouterPath.navBar,
//         );
//       case RouterPath.developerProfileView:
//         return _bottomToTopTransition(
//           BlocProvider(
//             create: (context) => DevelopersCubit(getIt<DevelopersRepo>()),
//             child: DeveloperProfileView(developerId: arguments['developerId']),
//           ),
//           routeName: RouterPath.developerProfileView,
//         );
//       case RouterPath.projectProfileView:
//         return _bottomToTopTransition(
//           ProjectProfileView(projectId: arguments['projectId']),
//           routeName: RouterPath.projectProfileView,
//         );
//       case RouterPath.propertyTypesFilter:
//         return _bottomToTopTransition(
//           PropertyTypesFilter(
//             propertyTypes: arguments['propertyTypes'],
//             selectedSlug: arguments['selectedSlug'],
//           ),
//           routeName: RouterPath.propertyTypesFilter,
//         );
//       case RouterPath.personalInformationView:
//         return _bottomToTopTransition(
//           const PersonalInformationView(),
//           routeName: RouterPath.personalInformationView,
//         );
//       case RouterPath.changePhoneNumberView:
//         return _bottomToTopTransition(
//           const ChangePhoneNumberView(),
//           routeName: RouterPath.changePhoneNumberView,
//         );
//       case RouterPath.changePasswordView:
//         return _bottomToTopTransition(
//           const ChangePasswordView(),
//           routeName: RouterPath.changePasswordView,
//         );
//       case RouterPath.seeAllScreen:
//         return _bottomToTopTransition(
//           SeeAllScreen(
//             type: arguments['type'],
//             homeCubit: arguments['homeCubit'],
//           ),
//           routeName: RouterPath.seeAllScreen,
//         );
//       case RouterPath.termsAndCondition:
//         return _bottomToTopTransition(
//           const TermsAndCondition(),
//           routeName: RouterPath.termsAndCondition,
//         );
//       case RouterPath.privacyPolicy:
//         return _bottomToTopTransition(
//           const PrivacyPolicy(),
//           routeName: RouterPath.privacyPolicy,
//         );
//       case RouterPath.guestView:
//         return _bottomToTopTransition(
//           const GuestView(),
//           routeName: RouterPath.guestView,
//         );
//       case RouterPath.propertyDetails:
//         return _bottomToTopTransition(
//           PropertyDetailsView(propertyId: arguments['propertyId']),
//           routeName: RouterPath.propertyDetails,
//         );
//       case RouterPath.searchScreen:
//         return _bottomToTopTransition(
//           SearchScreen(homeCubit: arguments['homeCubit']),
//           routeName: RouterPath.searchScreen,
//         );
//       case RouterPath.addPropertyView:
//         return _bottomToTopTransition(
//           const AddPropertyView(),
//           routeName: RouterPath.addPropertyView,
//         );
//       case RouterPath.searchDeveloperView:
//         return _bottomToTopTransition(
//           DeveloperSearchView(developersCubit: arguments['developersCubit']),
//           routeName: RouterPath.searchDeveloperView,
//         );
//       case RouterPath.favoritesView:
//         return _bottomToTopTransition(
//           const FavoriteView(),
//           routeName: RouterPath.favoritesView,
//         );
//       case RouterPath.propertyFilterView:
//         return _bottomToTopTransition(
//           PropertyFilterView(
//             propertyTypesModel: arguments['propertyTypesModel'],
//           ),
//           routeName: RouterPath.propertyFilterView,
//         );
//       case RouterPath.filterResult:
//         return _bottomToTopTransition(
//           FilterResultView(
//             selectedType: arguments['selectedType'],
//             selectedPurpose: arguments['selectedPurpose'],
//             selectedAmenities: arguments['selectedAmenities'],
//             filterCubit: arguments['filterCubit'],
//           ),
//           routeName: RouterPath.filterResult,
//         );
//     }
//     return null;
//   }

//   Route _bottomToTopTransition(Widget page, {required String routeName}) {
//     return PageRouteBuilder(
//       settings: RouteSettings(name: routeName),
//       transitionDuration: const Duration(milliseconds: 500),
//       reverseTransitionDuration: const Duration(milliseconds: 500),
//       pageBuilder: (context, animation, secondaryAnimation) => page,
//       transitionsBuilder: (context, animation, secondaryAnimation, child) {
//         const begin = Offset(1.0, 0.0);
//         const end = Offset.zero;
//         const curve = Curves.decelerate;
//         var tween = Tween(
//           begin: begin,
//           end: end,
//         ).chain(CurveTween(curve: curve));
//         var offsetAnimation = animation.drive(tween);
//         return SlideTransition(position: offsetAnimation, child: child);
//       },
//     );
//   }
// }
