import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:propertybooking/core/utils/navigation/app_router.dart';
import 'package:propertybooking/core/utils/navigation/router_path.dart';
import 'package:propertybooking/core/utils/services/service_locator.dart';
import 'package:propertybooking/features/auth/data/repos/auth_repo.dart';
import 'package:propertybooking/features/auth/presentation/manager/auth_cubit/auth_cubit_cubit.dart';
import 'package:provider/provider.dart';
import 'package:propertybooking/l10n/app_localizations.dart';
import 'package:propertybooking/core/providers/language_provider.dart';
import 'features/home/presentation/providers/customer_provider.dart';
import 'features/home/presentation/providers/reservation_form_provider.dart';
import 'package:bot_toast/bot_toast.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await setupServiceLocator();

  runApp(const PropertyBooking());
}

class PropertyBooking extends StatelessWidget {
  const PropertyBooking({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => CustomerProvider()),
        ChangeNotifierProvider(create: (_) => ReservationFormProvider()),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, _) {
          return ScreenUtilInit(
            designSize: const Size(430, 932),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return BlocProvider(
                create: (context) => AuthCubitCubit(getIt<AuthRepo>()),
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  builder: BotToastInit(),
                  navigatorObservers: [BotToastNavigatorObserver()],
                  locale: languageProvider.currentLocale,
                  supportedLocales: const [Locale('ar'), Locale('en')],
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  initialRoute: RouterPath.splashView,
                  onGenerateRoute: AppRouter().generateRoute,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
