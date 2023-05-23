import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:halal_guide/result_screen.dart';
import 'package:permission_handler/permission_handler.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  bool isPermissionGranted = false;
  bool isFlashOn = false; // Переменная для отслеживания состояния спышки

  late final Future<void> _future;
  CameraController? _cameraController;
  final _textRecognizer = TextRecognizer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _future = requestCameraPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _startCamera();
    _textRecognizer.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      stopCamera();
    } else if (state == AppLifecycleState.resumed &&
        _cameraController != null &&
        _cameraController!.value.isInitialized) {
      _startCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        return Stack(
          children: [
            if (isPermissionGranted)
              FutureBuilder<List<CameraDescription>>(
                future: availableCameras(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    _initCameraController(snapshot.data!);

                    return Center(child: CameraPreview(_cameraController!));
                  } else {
                    return const LinearProgressIndicator();
                  }
                },
              ),
            Scaffold(
              backgroundColor: Colors.transparent,
              body: isPermissionGranted
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Expanded(child: Container()),
                        Container(
                          padding: const EdgeInsets.only(right: 300, top: 20),
                          color: Colors.black,
                          height: 100,
                          width: double.infinity,
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  isFlashOn =
                                      !isFlashOn; // Включение/отключение спышки
                                  _cameraController?.setFlashMode(isFlashOn
                                      ? FlashMode.torch
                                      : FlashMode.off);
                                });
                              },
                              icon: Icon(
                                Icons.light_mode,
                                color: isFlashOn ? Colors.white : Colors.grey,
                                size: 50,
                              )),

                          // isFlashOn
                          //       ? 'Выключить спышку'
                          //       : 'Включить спышку'), //
                        ),
                        Container(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              side: const BorderSide(
                                width: 3,
                                color: Colors.blue,
                              ),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.all(20),
                            ),
                            onPressed: () async{
                             
                              _scanImage().then((recognizedText) {
                                showModalBottomSheet(
                                  
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (context) => ResultScreen(
                                    text: recognizedText
                                  ),
                                );
                              });
                            },
                            child: const Text('Сканировать'),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Container(
                        padding: const EdgeInsets.only(left: 24, right: 24),
                        child: Text(
                          isPermissionGranted
                              ? 'Camera permission granted'
                              : 'Camera permission denied',
                        ),
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  Future<void> requestCameraPermission() async {
    final status = await Permission.camera.request();
    isPermissionGranted = status == PermissionStatus.granted;
  }

  void _startCamera() {
    if (_cameraController != null) {
      _cameraSelected(_cameraController!.description);
    }
  }

  void stopCamera() {
    if (_cameraController != null) {
      _cameraController?.dispose();
    }
  }

  void _initCameraController(List<CameraDescription> cameras) {
    if (_cameraController != null) {
      return;
    }

    CameraDescription? camera;
    for (var i = 0; i < cameras.length; i++) {
      final CameraDescription current = cameras[i];
      if (current.lensDirection == CameraLensDirection.back) {
        camera = current;
        break;
      }
    }
    if (camera != null) {
      _cameraSelected(camera);
    }
  }

  Future<void> _cameraSelected(CameraDescription camera) async {
    _cameraController =
        CameraController(camera, ResolutionPreset.max, enableAudio: false);

    await _cameraController?.initialize();
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Future<String> _scanImage() async {
    if (_cameraController == null) return '';

    final navigator = Navigator.of(context);

    try {
      final pictureFile = await _cameraController!.takePicture();
      final file = File(pictureFile.path);
      final inputImage = InputImage.fromFilePath(file.path);

      await GoogleMlKit.vision.textRecognizer().processImage(inputImage);

      final recognizedText = await _textRecognizer.processImage(inputImage);
      

      return recognizedText.text;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred when scanning text')),
      );
    }
    return '';
  }
}
