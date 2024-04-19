import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:funcionalidades_camera/pages/camera_page.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key, this.foto });

  File? foto;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? fotinha;

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
        title: Text("Tire sua fotinha"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          fotinha != null
              ? Image.file(File(fotinha!.path), fit: BoxFit.cover, width: 250)
              : Container(
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
              ElevatedButton(
                  onPressed: () async {
                    await availableCameras().then((valor) => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => CameraPage(cameras: valor))));
                  },
                  child: Text("Tirar foto")),
              ElevatedButton(onPressed: () {}, child: Text("Galeria")),
              ElevatedButton(onPressed: () {}, child: Text("Editar foto")),
            ],
          )
        ],
      ),
    );
  }
}
