// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';

import 'package:core/styles/color_palette.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:main/widgets/custom_alert.dart';
import 'package:permission_handler/permission_handler.dart';

class FileManagement {
  static Future<bool> checkAndRequestPermission() async {
    PermissionStatus? status;

    if (Platform.isAndroid) {
      final plugin = DeviceInfoPlugin();
      final android = await plugin.androidInfo;

      status = android.version.sdkInt < 33
          ? await Permission.storage.request()
          : PermissionStatus.granted;
    } else {
      status = await Permission.storage.request();
    }
    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      await Permission.storage.request();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
    return status.isGranted;
  }

  static Future<void> uploadFile(
      BuildContext context,
      Function(
        String path,
      ) uploadAction) async {
    if (await FileManagement.checkAndRequestPermission()) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowedExtensions: ['pdf', 'jpg', 'png'],
        type: FileType.custom,
      );

      int maxSizeInBytes = 5 * 1024 * 1024;
      if ((result?.files.first.size ?? 0) > maxSizeInBytes) {
        CustomAlert.error(context: context, message: 'Max file size is 5mb');
        return;
      }
      if (result != null) {
        File file = File(result.files.single.path!);

        try {
          uploadAction.call(file.path);
        } catch (e) {
          print('Error uploading file: $e');
        }
      }
    }
  }

  static Future<void> uploadImage(
      BuildContext context,
      Function(
        String path,
      ) uploadAction) async {
    if (await FileManagement.checkAndRequestPermission()) {
      // Izin diberikan, lanjutkan dengan tindakan yang diperlukan
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);

      if (result != null) {
        CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: result.files.single.path!,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Crop Profile Image',
                toolbarColor: primaryColor,
                toolbarWidgetColor: Colors.white,
                statusBarColor: secondaryColor,
                activeControlsWidgetColor: primaryColor,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            IOSUiSettings(
              title: 'Crop Profile Image',
            ),
          ],
        );

        int maxSizeInBytes = 5 * 1024 * 1024;
        if ((await File(croppedFile!.path).length()) > maxSizeInBytes) {
          CustomAlert.error(context: context, message: 'Max file size is 5mb');
          return;
        }
        uploadAction.call(croppedFile.path);
      }
    }
  }

  static Future<Uint8List> compressData(Uint8List data) async {
    List<int> compressedImage = await FlutterImageCompress.compressWithList(
      data,
      minHeight: 800,
      minWidth: 800,
      quality: 40,
      format: CompressFormat.jpeg,
    );
    return Uint8List.fromList(compressedImage);
  }
}
