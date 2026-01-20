import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageCompressor {
  static Future<File?> compressImage(
    File file, {
    int quality = 70,
    int minWidth = 800,
    int minHeight = 800,
  }) async {
    String targetPath = file.path;
    if (!targetPath.endsWith('.jpg') && !targetPath.endsWith('.jpeg')) {
      targetPath = '${targetPath}_compressed.jpg';
    } else {
      targetPath = targetPath
          .replaceFirst('.jpg', '_compressed.jpg')
          .replaceFirst('.jpeg', '_compressed.jpeg');
    }
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: quality,
      minWidth: minWidth,
      minHeight: minHeight,
    );
    return result != null ? File(result.path) : null;
  }
}
