import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../../resources/icons/icons_svg.dart';
import 'app_bars/base_app_bar.dart';

typedef PictureCallback = void Function(String path);

class CameraViewScreen extends StatelessWidget {
  final String pageTitle;
  final PictureCallback onTakePicture;

  const CameraViewScreen({
    @required this.pageTitle,
    this.onTakePicture,
  });

  Future<CameraController> _openCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      final camera = cameras.length >= 2 ? cameras[1] : cameras.first;
      final controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
      );
      await controller.initialize();
      return controller;
    } else {
      // Phone has no cameras
      Get.back();
      return null;
    }
  }

  Future<void> _takePicture(CameraController controller) async {
    final String tempDirectoryPath = (await getTemporaryDirectory()).path;
    final String picturePath = '$tempDirectoryPath/${DateTime.now()}.png';

    await controller.takePicture(picturePath);
    onTakePicture?.call(picturePath);
  }

  BaseAppBar _appBar() => BaseAppBar(
        titleString: pageTitle,
        titleColor: Get.theme.colorScheme.background,
        backIconPath: IconsSVG.arrowLeftIOSStyle,
        backgroundColor: Get.theme.colorScheme.onBackground,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: FutureBuilder<CameraController>(
        future: _openCamera(),
        builder: (context, snapshot) {
          return Stack(
            children: [
              if (snapshot.connectionState == ConnectionState.done)
                CameraPreview(snapshot.data),
              Container(
                height: 143.h,
                margin: EdgeInsets.only(top: 580.h),
                padding: EdgeInsets.only(bottom: 30.h),
                decoration:
                    BoxDecoration(color: Get.theme.colorScheme.onBackground),
                child: Center(
                  child: FlatButton(
                    child: SvgPicture.asset(IconsSVG.cameraButton),
                    onPressed: () => _takePicture(snapshot.data),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
