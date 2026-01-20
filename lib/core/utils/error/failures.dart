import 'package:dio/dio.dart';

abstract class Failure {
  final String message;
  const Failure({required this.message});
}

class ServerFailure extends Failure {
  const ServerFailure({super.message = 'حدث خطأ في الخادم'});

  factory ServerFailure.fromDioException({required DioException dioException}) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return const ServerFailure(message: 'انتهت مهلة الاتصال بالخادم');
      case DioExceptionType.sendTimeout:
        return const ServerFailure(message: 'انتهت مهلة إرسال البيانات');
      case DioExceptionType.receiveTimeout:
        return const ServerFailure(message: 'انتهت مهلة استقبال البيانات');
      case DioExceptionType.badResponse:
        return ServerFailure._fromResponse(
          dioException.response?.statusCode,
          dioException.response?.data,
        );
      case DioExceptionType.cancel:
        return const ServerFailure(message: 'تم إلغاء الطلب');
      case DioExceptionType.connectionError:
        return const ServerFailure(message: 'لا يوجد اتصال بالإنترنت');
      case DioExceptionType.badCertificate:
        return const ServerFailure(message: 'خطأ في شهادة الأمان');
      case DioExceptionType.unknown:
        return const ServerFailure(message: 'حدث خطأ غير متوقع');
    }
  }

  factory ServerFailure._fromResponse(int? statusCode, dynamic response) {
    if (statusCode == null) {
      return const ServerFailure(message: 'حدث خطأ في الخادم');
    }

    switch (statusCode) {
      case 400:
        return const ServerFailure(message: 'طلب غير صحيح');
      case 401:
        return const ServerFailure(message: 'غير مصرح لك بالدخول');
      case 403:
        return const ServerFailure(message: 'ممنوع الوصول');
      case 404:
        return const ServerFailure(message: 'البيانات المطلوبة غير موجودة');
      case 500:
        return const ServerFailure(message: 'خطأ في الخادم');
      case 503:
        return const ServerFailure(message: 'الخادم غير متاح حالياً');
      default:
        return const ServerFailure(message: 'حدث خطأ في الخادم');
    }
  }
}

class CacheFailure extends Failure {
  const CacheFailure({super.message = 'حدث خطأ في التخزين المؤقت'});
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'حدث خطأ في الاتصال بالإنترنت'});
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}

class UnknownFailure extends Failure {
  const UnknownFailure({super.message = 'حدث خطاء غير معروف'});
}

class NoInternetFailure extends Failure {
  const NoInternetFailure({super.message = 'لا يوجد اتصال بالانترنت'});
}

class NoConnectionFailure extends Failure {
  const NoConnectionFailure({super.message = 'لا يوجد اتصال بالانترنت'});
}

class NoDataFailure extends Failure {
  const NoDataFailure({super.message = 'لا يوجد بيانات'});
}
