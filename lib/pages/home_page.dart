import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:funcionalidades_camera/pages/camera_page.dart';
import 'package:funcionalidades_camera/pages/preview_page.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key, this.foto});

  File? foto;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? fotinha;
  final imagePicker = ImagePicker();

  @override
  void initState() {
    if (widget.foto != null) {
      fotinha = widget.foto;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tire sua fotinha"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          fotinha != null
              ? Image.file(File(fotinha!.path), fit: BoxFit.cover, width: 250)
              : const SizedBox(
                  width: 250,
                  height: 250,
                  child: Icon(
                    Icons.camera_alt,
                    size: 200,
                  ),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        fixedSize: const Size(120, double.infinity)),
                    onPressed: () async {
                      await availableCameras().then((valor) => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => CameraPage(cameras: valor))));
                    },
                    child: const Text(
                      "Tirar foto",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        fixedSize: const Size(120, double.infinity)),
                    onPressed: () async {
                      final arquivoPego = await imagePicker.pickImage(
                          source: ImageSource.gallery);
                      if (arquivoPego != null) {
                        setState(() {
                          fotinha = File(arquivoPego.path);
                        });
                      }
                    },
                    child: const Text("Galeria",
                        style: TextStyle(
                          color: Colors.white,
                        ))),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        fixedSize: const Size(120, double.infinity)),
                    onPressed: () async {
                      if (fotinha != null) {
                        var imagemEditada = await ImageCropper().cropImage(
                          sourcePath: fotinha!.path,
                          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
                          compressQuality: 100,
                          maxHeight: 700,
                          maxWidth: 700,
                          compressFormat: ImageCompressFormat.jpg,
                        );
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => PreviewPage(
                                    foto: XFile(imagemEditada!.path))));
                      } else {
                        const snack = SnackBar(
                          content: Text(
                              "Para editar uma foto é necessário primeiro carregar uma imagem da galeria ou tirar uma foto"),
                          duration: Duration(seconds: 7),
                        );
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(snack);
                      }
                    },
                    child: const Text("Editar foto",
                        style: TextStyle(
                          color: Colors.white,
                        ))),
              ),
            ],
          )
        ],
      ),
    );
  }
}
