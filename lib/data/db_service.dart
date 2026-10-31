import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../main.dart';
import '../models/models.dart';

class DBService {
  static const String _boxName = 'sesiones';
  static Box<SesionHive> get _box => Hive.box<SesionHive>(_boxName);

  static Future<String> guardarSesion({
    String? idExistente,
    required String nombreNegocio,
    required RolEmprendedor rol,
    required List<BloqueCanvas> bloques,
    required List<ItemEvaluacion> items,
    required ResultadoFactibilidad resultado,
  }) async {
    final id = idExistente ?? const Uuid().v4();

    final contenidoBloques = <dynamic, dynamic>{};
    for (final b in bloques) {
      contenidoBloques[b.numero] = b.contenido;
    }

    final puntuaciones = <dynamic, dynamic>{};
    final importancias = <dynamic, dynamic>{};
    for (var i = 0; i < items.length; i++) {
      puntuaciones[i] = items[i].puntuacion;
      importancias[i] = items[i].importancia;
    }

    final sesion = SesionHive(
      id: id,
      nombreNegocio: nombreNegocio,
      rolNombre: rol.nombre,
      rolIcono: rol.icono,
      fecha: DateTime.now(),
      contenidoBloques: contenidoBloques,
      puntuaciones: puntuaciones,
      importancias: importancias,
      indiceFactibilidad: resultado.indice,
      nivelFactibilidad: resultado.nivelFactibilidad,
    );

    await _box.put(id, sesion);
    return id;
  }

  static List<SesionHive> obtenerSesiones() {
    final sesiones = _box.values.toList();
    sesiones.sort((a, b) => b.fecha.compareTo(a.fecha));
    return sesiones;
  }

  static Future<void> eliminarSesion(String id) async {
    await _box.delete(id);
  }

  static int get totalSesiones => _box.length;
}
