import 'dart:io';

import 'package:dio/dio.dart';
import 'package:elogbook/core/services/api_service.dart';
import 'package:elogbook/core/utils/api_header.dart';
import 'package:elogbook/core/utils/data_response.dart';
import 'package:elogbook/core/utils/failure.dart';
import 'package:elogbook/src/data/models/reference/reference_on_list_model.dart';
import 'package:file_saver/file_saver.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

abstract class ReferenceDataSource {
  Future<List<ReferenceOnListModel>> getReferenceByDepartmentId(
      {required String unitId});
  Future<String> downloadDataReference(
      {required int id, required String filename});
}

class ReferenceDataSourceImpl implements ReferenceDataSource {
  final Dio dio;
  final ApiHeader apiHeader;

  ReferenceDataSourceImpl({required this.dio, required this.apiHeader});

  @override
  Future<List<ReferenceOnListModel>> getReferenceByDepartmentId(
      {required String unitId}) async {
    try {
      final response = await dio.get(
        ApiService.baseUrl + '/references/units/$unitId',
        options: await apiHeader.userOptions(),
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
    try {
      Directory _directory = Directory("");
      if (Platform.isAndroid) {
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
          options: await apiHeader.userOptions(),
        );
      } else {
        savePath = await FileSaver.instance.saveAs(
          name: basename(filename),
          ext: 'pdf',
          link: LinkDetails(
            link: ApiService.baseUrl + '/references/$id',
            headers: await apiHeader.userOptions(onlyHeader: true),
          ),
          mimeType: MimeType.pdf,
        );
      }

      return savePath ?? '';
    } catch (e) {
      throw ClientFailure(e.toString());
    }
  }
}
