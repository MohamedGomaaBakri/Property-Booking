import 'package:dartz/dartz.dart';
import 'package:propertybooking/core/utils/error/error_model.dart';
import 'package:propertybooking/features/home/data/datasource/local/home_local_ds.dart';
import 'package:propertybooking/features/home/data/datasource/remote/home_remote_ds.dart';
import 'package:propertybooking/features/home/domain/repos/home_repository.dart';

class HomeRepoImpl implements HomeRepository {
  final HomeRemoteDataSource remote;
  final HomeLocalDataSource local;

  HomeRepoImpl(this.remote, this.local);

  @override
  Future<Either<ErrorModel, String>> getHomeData() async {
    final cached = await local.getCachedHomeData();
    if (cached != null) {
      remote.getHomeData().then((remoteResult) {
        remoteResult.fold(
          (error) => null,
          (homeModel) => local.cacheHomeData(homeModel),
        );
      });
      return Right(cached);
    } else {
      final remoteResult = await remote.getHomeData();
      return await remoteResult.fold((error) => Left(error), (homeModel) async {
        await local.cacheHomeData(homeModel);
        return Right('homeModel');
      });
    }
  }
}
