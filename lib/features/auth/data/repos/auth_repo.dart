import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:propertybooking/core/utils/error/failures.dart';
import 'package:propertybooking/core/utils/networking/api_constants.dart';
import 'package:propertybooking/core/utils/networking/api_service.dart';
import 'package:propertybooking/core/utils/services/device_info_service.dart';
import 'package:propertybooking/features/auth/data/models/user_model.dart';
import 'package:intl/intl.dart';

class AuthRepo {
  final ApiService apiService;
  final DeviceInfoProvider _deviceInfoProvider;

  AuthRepo(this.apiService, this._deviceInfoProvider);

  Future<Either<Failure, UserModel>> getUser(int userCode) async {
    try {
      final response = await apiService.get(
        endPoint: "${ApiConstants.getUser}$userCode",
      );
      return right(UserModel.fromJson(response));
    } on DioException catch (e) {
      return left(ServerFailure.fromDioException(dioException: e));
    }
  }

  Future<void> postActivity(int userCode) async {
    try {
      final ip = await _deviceInfoProvider.getIpAddress();
      final deviceId = await _deviceInfoProvider.getDeviceUniqueId();
      final osUser = await _deviceInfoProvider.getOsUser();
      final String formattedDate = DateFormat(
        "yyyy-MM-dd'T'HH:mm:ss'Z'",
      ).format(DateTime.now().toUtc().add(Duration(hours: 1)));

      Position? position;
      try {
        position = await _deviceInfoProvider.determinePosition();
      } catch (e) {
        print("Could not get location for activity post: $e");
      }

      final Map<String, dynamic> loginData = {
        "users_code": userCode,
        "machine_ip": ip,
        "machine_mac": deviceId,
        "osuser": osUser,
        "contime": formattedDate,
        "latitude": position?.latitude,
        "longitude": position?.longitude,
      };

      print('data loginData $loginData');
      await apiService.post(
        endPoint: ApiConstants.getAccessInfo,
        data: loginData,
      );
    } catch (e) {
      print("Could not post activity data: $e");
    }
  }
}
