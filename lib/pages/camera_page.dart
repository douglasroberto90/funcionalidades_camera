import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:funcionalidades_camera/pages/preview_page.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key, required this.cameras});

  final List<CameraDescription>? cameras;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _cameraController;
  bool _cameraTraseiraEstaSelecionada = true;

  @override
  void initState() {
    super.initState();
    iniciarCamera(widget.cameras![0]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _cameraController.value.isInitialized
              ? CameraPreview(_cameraController)
              : Container(
                  color: Colors.black,
                  child: const Center(child: CircularProgressIndicator())),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                color: Colors.black,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: IconButton(
                      icon: Icon(
                          _cameraTraseiraEstaSelecionada
                              ? CupertinoIcons.switch_camera
                              : CupertinoIcons.switch_camera_solid,
                          color: Colors.white,
                          size: 70),
                      onPressed: () {
                        _cameraTraseiraEstaSelecionada
                            ? _cameraTraseiraEstaSelecionada = false
                            : _cameraTraseiraEstaSelecionada = true;
                        iniciarCamera(widget
                            .cameras![_cameraTraseiraEstaSelecionada ? 0 : 1]);
                      },
                    ),
                  ),
                  Expanded(
                      child: IconButton(
                    icon: Icon(Icons.circle, color: Colors.white, size: 70),
                    onPressed: () async {
                      XFile? foto = await tirarFoto();
                      if (foto != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PreviewPage(
                                      foto: foto,
                                    )));
                      }
                    },
                  )),
                  //Spacer(),
                  Expanded(child: Container()),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> iniciarCamera(CameraDescription cameraDescription) async {
    _cameraController =
        CameraController(cameraDescription, ResolutionPreset.high);
    try {
      await _cameraController.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint("Erro na camera $e");
    }
  }

  Future<XFile?> tirarFoto() async {
    if (!_cameraController.value.isInitialized) {
      return null;
    }
    if (_cameraController.value.isTakingPicture) {
      return null;
    }
    try {
      await _cameraController.setFlashMode(FlashMode.off);
      XFile foto = await _cameraController.takePicture();
      return foto;
    } on CameraException catch (e) {
      debugPrint('Ocorreu um erro ao tirar a foto: $e');
      return null;
    }
  }
}
