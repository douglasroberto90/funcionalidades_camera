import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:funcionalidades_camera/pages/home_page.dart';
import 'dart:io';

import 'package:funcionalidades_camera/repositories/repositorio.dart';

class PreviewPage extends StatelessWidget {
  PreviewPage({super.key, required this.foto});

  XFile foto;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Gostou da foto?"),
          backgroundColor: Colors.blue,
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.file(File(foto.path), fit: BoxFit.cover, width: 250),
          Text(foto.name),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Repositorio rep = Repositorio(foto: foto);
                    rep.salvarNaGaleria();
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                        builder: (_) => HomePage(
                          foto: File(foto.path),
                        )), (route) => false);
                  },
                  child: Text("Salvar")),
            ],
          ),
        ]));
  }
}
