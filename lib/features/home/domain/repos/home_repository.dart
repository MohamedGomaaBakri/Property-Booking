import 'package:dartz/dartz.dart';
import 'package:propertybooking/core/utils/error/error_model.dart';

abstract class HomeRepository {
  Future<Either<ErrorModel, String>> getHomeData();
}
