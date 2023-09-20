import 'dart:io';

import 'package:dio/dio.dart';
import 'package:elogbook/core/services/api_service.dart';
import 'package:elogbook/core/utils/data_response.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/datasources/local_datasources/auth_preferences_handler.dart';
import 'package:elogbook/src/data/models/reference/reference_on_list_model.dart';
import 'package:file_saver/file_saver.dart';
import 'package:path_provider/path_provider.dart';

abstract class ReferenceDataSource {
  Future<List<ReferenceOnListModel>> getReferenceByDepartmentId(
      {required String unitId});
  Future<String> downloadDataReference(
      {required int id, required String filename});
}

class ReferenceDataSourceImpl implements ReferenceDataSource {
  final Dio dio;
  final AuthPreferenceHandler preferenceHandler;

  ReferenceDataSourceImpl({required this.dio, required this.preferenceHandler});

  @override
  Future<List<ReferenceOnListModel>> getReferenceByDepartmentId(
      {required String unitId}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/references/units/$unitId',
        options: Options(
          headers: {
            "content-type": 'application/json',
            "authorization": 'Bearer ${credential?.accessToken}'
          },
        ),
      );

      final dataResponse =
          await DataResponse<List<dynamic>>.fromJson(response.data);
      List<ReferenceOnListModel> listData = dataResponse.data
          .map((e) => ReferenceOnListModel.fromJson(e))
          .toList();
      return listData;
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }

  @override
  Future<String> downloadDataReference(
      {required int id, required String filename}) async {
    final credential = await preferenceHandler.getCredential();
    try {
      Directory _directory = Directory("");
      if (Platform.isAndroid) {
        // Redirects it to download folder in android
        _directory = Directory("/storage/emulated/0/Download");
      } else {
        _directory = await getApplicationDocumentsDirectory();
      }
      String? savePath = '${_directory.path}/$filename.pdf';
      if (Platform.isAndroid) {
        await dio.download(
          ApiService.baseUrl + '/references/$id',
          savePath,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              print((received / total * 100).toStringAsFixed(0) + "%");
            }
          },
          options: Options(
            headers: {
              "content-type": 'application/json',
              "authorization": 'Bearer ${credential?.accessToken}'
            },
          ),
        );
      } else {
        savePath = await FileSaver.instance.saveAs(
          name: filename,
          ext: 'pdf',
          link: LinkDetails(
            link: ApiService.baseUrl + '/references/$id',
            headers: {
              "content-type": 'application/json',
              "authorization": 'Bearer ${credential?.accessToken}'
            },
          ),
          mimeType: MimeType.pdf,
        );
      }

      return savePath ?? '';
    } catch (e) {
      print(e.toString());
      throw ClientFailure(e.toString());
    }
  }
}
