import 'dart:io';

import 'package:data/models/reference/reference_on_list_model.dart';
import 'package:data/services/api_service.dart';
import 'package:data/services/token_manager.dart';
import 'package:data/utils/api_header.dart';
import 'package:data/utils/data_response.dart';
import 'package:data/utils/exception_handler.dart';
import 'package:dio/dio.dart';
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
  final TokenInterceptor tokenInterceptor;

  ReferenceDataSourceImpl(
      {required this.tokenInterceptor,
      required this.dio,
      required this.apiHeader}) {
    dio.interceptors.add(tokenInterceptor);
  }

  @override
  Future<List<ReferenceOnListModel>> getReferenceByDepartmentId(
      {required String unitId}) async {
    try {
      final response = await dio.get(
        '${ApiService.baseUrl}/references/units/$unitId',
        options: await apiHeader.userOptions(),
      );

      final dataResponse = DataResponse<List<dynamic>>.fromJson(response.data);
      List<ReferenceOnListModel> listData = dataResponse.data
          .map((e) => ReferenceOnListModel.fromJson(e))
          .toList();
      return listData;
    } catch (e) {
      throw failure(e);
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
          '${ApiService.baseUrl}/references/$id',
          savePath,
          onReceiveProgress: (received, total) {
            if (total != -1) {}
          },
          options: await apiHeader.userOptions(),
        );
      } else {
        savePath = await FileSaver.instance.saveAs(
          name: basename(filename),
          ext: 'pdf',
          link: LinkDetails(
            link: '${ApiService.baseUrl}/references/$id',
            headers: await apiHeader.userOptions(onlyHeader: true),
          ),
          mimeType: MimeType.pdf,
        );
      }

      return savePath ?? '';
    } catch (e) {
      throw failure(e);
    }
  }
}
