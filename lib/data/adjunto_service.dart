
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

class AdjuntoService {
  static Box<dynamic> get _box => Hive.box<dynamic>('adjuntos');

  static const int maxBytes = 10 * 1024 * 1024;

  static Future<int> adjuntar(String sesionId) async {
    final seleccion = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: true,
      type: FileType.any,
    );

    if (seleccion == null) return 0;

    int guardados = 0;
    final errores = <String>[];

    for (final archivo in seleccion.files) {
      final Uint8List? bytes = archivo.bytes;

      if (bytes == null) {
        errores.add('${archivo.name}: no se pudieron leer sus datos');
        continue;
      }

      if (bytes.length > maxBytes) {
        errores.add('${archivo.name}: supera el límite de 10 MB');
        continue;
      }

      final id = const Uuid().v4();

      await _box.put(id, {
        'id': id,
        'sesionId': sesionId,
        'nombre': archivo.name,
        'extension': archivo.extension ?? '',
        'tamano': bytes.length,
        'bytes': bytes,
        'fecha': DateTime.now().millisecondsSinceEpoch,
      });

      guardados++;
    }

    if (errores.isNotEmpty) {
      throw Exception(
        'Algunos archivos no se adjuntaron: ${errores.join('; ')}',
      );
    }

    return guardados;
  }


  static Future<List<Map>> obtenerPorSesion(String sesionId) async {
    final archivos = _box.values
        .whereType<Map>()
        .where((archivo) => archivo['sesionId'] == sesionId)
        .toList();

    archivos.sort(
          (a, b) => a['nombre']
          .toString()
          .toLowerCase()
          .compareTo(b['nombre'].toString().toLowerCase()),
    );

    return archivos;
  }


  static Future<void> eliminar(String id) async {
    await _box.delete(id);
  }

  static Future<void> eliminarPorSesion(String sesionId) async {
    final ids = _box.values
        .whereType<Map>()
        .where((archivo) => archivo['sesionId'] == sesionId)
        .map((archivo) => archivo['id'].toString())
        .toList();

    await _box.deleteAll(ids);
  }

  static Future<void> descargar(Map archivo) async {
    final bytes = archivo['bytes'] as Uint8List;

    final nombre = archivo['nombre']
        .toString()
        .replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');

    final extension = archivo['extension'].toString().toLowerCase();

    final mime = switch (extension) {
      'pdf' => 'application/pdf',
      'png' => 'image/png',
      'jpg' || 'jpeg' => 'image/jpeg',
      'txt' => 'text/plain',
      'csv' => 'text/csv',
      'json' => 'application/json',
      _ => 'application/octet-stream',
    };

    await FilePicker.platform.saveFile(
      fileName: nombre,
      bytes: bytes,
    );
  }

  static String tamanoLegible(int bytes) {
    if (bytes < 1024) return '$bytes B';

    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }

    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }
}
