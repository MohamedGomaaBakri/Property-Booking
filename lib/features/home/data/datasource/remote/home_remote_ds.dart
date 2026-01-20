import 'package:dartz/dartz.dart';
import 'package:propertybooking/core/utils/error/error_model.dart';
import 'package:propertybooking/core/utils/error/exceptions.dart';
import 'package:propertybooking/core/utils/networking/api_service.dart';

abstract class HomeRemoteDataSource {
  Future<Either<ErrorModel, String>> getHomeData();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiService apiService;

  HomeRemoteDataSourceImpl({required this.apiService});

  @override
  Future<Either<ErrorModel, String>> getHomeData() async {
    try {
      final response = await apiService.get(endPoint: 'home');
      return Right('response');
    } on ServerException catch (e) {
      return Left(e.errorModel);
    }
  }
}
