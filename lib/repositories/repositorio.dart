import 'package:camera/camera.dart';
import 'package:gallery_saver/gallery_saver.dart';

class Repositorio{
  Repositorio({required this.foto});

  XFile foto;

  Future<void> salvarNaGaleria() async {
    GallerySaver.saveImage(foto.path);
  }

}