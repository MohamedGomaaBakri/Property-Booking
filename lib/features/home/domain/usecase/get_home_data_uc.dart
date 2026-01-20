import 'package:dartz/dartz.dart';
import 'package:propertybooking/core/utils/error/error_model.dart';
import 'package:propertybooking/features/home/domain/repos/home_repository.dart';

class GetHomeDataUc {
  final HomeRepository repository;
  GetHomeDataUc(this.repository);

  Future<Either<ErrorModel, String>> call() async {
    return await repository.getHomeData();
  }
}
