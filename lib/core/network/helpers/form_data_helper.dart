import 'dart:io';

import 'package:dio/dio.dart';

class FormDataHelper {
  static Future<FormData> generate(Map<String, dynamic> body) async {
    Map<String, dynamic> formMap = {};

    for (var entry in body.entries) {
      /// SINGLE FILE
      if (entry.value is File) {
        File file = entry.value;

        formMap[entry.key] = await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        );
      }
      /// MULTIPLE FILES
      else if (entry.value is List<File>) {
        List<File> files = entry.value;

        formMap[entry.key] = await Future.wait(
          files.map((file) async => MultipartFile.fromFile(
              file.path,
              filename: file.path.split('/').last,
            ),
          ),
        );
      }
      /// NORMAL FIELD
      else {
        formMap[entry.key] = entry.value;
      }
    }

    return FormData.fromMap(formMap);
  }
}
