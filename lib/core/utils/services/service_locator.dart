import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:propertybooking/core/utils/cached/hive_service.dart';
import 'package:propertybooking/core/utils/networking/api_constants.dart';
import 'package:propertybooking/core/utils/networking/api_service.dart';
import 'package:propertybooking/core/utils/services/device_info_service.dart';
import 'package:propertybooking/features/auth/data/repos/auth_repo.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // getIt.registerLazySingleton<SocketIOHandler>(() => SocketIOHandler());
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => FlutterSecureStorage(),
  );

  getIt.registerLazySingleton<HiveService>(() => HiveService());
  getIt.registerLazySingleton<DeviceInfoProvider>(() => DeviceInfoProvider());

  final token = await getIt<FlutterSecureStorage>().read(key: 'auth_token');
  final propertyBookingUrl = ApiConstants.PropertyBookingUrl;

  final Dio dio = Dio(
    BaseOptions(
      maxRedirects: 10000,
      connectTimeout: Duration(seconds: 30),
      baseUrl: propertyBookingUrl,
      headers: {
        'Accept': 'application/json',
        'lang': Platform.localeName.split('_').last == 'ar' ? 'ar' : 'en',
        'Content-Type': 'application/json',
        if (token != null)
          'Authorization': "Bearer $token"
        else
          'Authorization':
              "Bearer 28|d8WEXVVqwDlN8itPvgqVXEJqoBamhBUebMhEQJsO88fbbfab",
      },
    ),
  );

  dio.interceptors.add(
    PrettyDioLogger(
      responseBody: true,
      error: true,
      requestHeader: true,
      request: true,
      compact: true,
      maxWidth: 90,
      requestBody: true,
      responseHeader: true,
      logPrint: (object) {
        print(object);
      },
    ),
  );

  getIt.registerLazySingleton<Dio>(() {
    return dio;
  });

  await getIt.allReady(); // Ensure that Dio is ready before proceeding

  getIt.registerLazySingleton<ApiService>(() {
    return ApiService(getIt<Dio>());
  });

  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepo(getIt<ApiService>(), getIt<DeviceInfoProvider>()),
  );
}
