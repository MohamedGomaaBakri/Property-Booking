abstract class Failure {
  final String message;
  const Failure({required this.message});
}

class ServerFailure extends Failure {
  const ServerFailure({super.message = 'حدث خطأ في الخادم'});
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
