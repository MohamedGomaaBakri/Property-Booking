import 'dart:convert';

import 'package:propertybooking/core/utils/cached/hive_service.dart';

abstract class HomeLocalDataSource {
  Future<void> cacheHomeData(String homeModel);
  Future<String?> getCachedHomeData();
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  static const String _boxName = 'homeBox';
  static const String _cacheKey = 'CACHED_HOME_DATA';
  final HiveService hiveService;

  HomeLocalDataSourceImpl(this.hiveService);

  @override
  Future<void> cacheHomeData(String homeModel) async {
    final jsonString = json.encode(homeModel);
    await hiveService.put(_boxName, _cacheKey, jsonString);
  }

  @override
  Future<String?> getCachedHomeData() async {
    final jsonString = await hiveService.get(_boxName, _cacheKey);
    if (jsonString != null) {
      final jsonMap = json.decode(jsonString);
      return jsonMap;
    }
    return null;
  }
}
