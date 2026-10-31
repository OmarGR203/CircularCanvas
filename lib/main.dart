import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'data/tema.dart';
import 'screens/pantalla_rol.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(SesionHiveAdapter());
  await Hive.openBox<SesionHive>('sesiones');
  await Hive.openBox<dynamic>('adjuntos');
  await Hive.openBox<dynamic>('analisis_dafo');
  runApp(const CircularCanvasApp());
}

class SesionHive extends HiveObject {
  String id;
  String nombreNegocio;
  String rolNombre;
  String rolIcono;
  DateTime fecha;
  Map<dynamic, dynamic> contenidoBloques;
  Map<dynamic, dynamic> puntuaciones;
  Map<dynamic, dynamic> importancias;
  double indiceFactibilidad;
  String nivelFactibilidad;

  SesionHive({
    required this.id,
    required this.nombreNegocio,
    required this.rolNombre,
    required this.rolIcono,
    required this.fecha,
    required this.contenidoBloques,
    required this.puntuaciones,
    required this.importancias,
    required this.indiceFactibilidad,
    required this.nivelFactibilidad,
  });
}

class SesionHiveAdapter extends TypeAdapter<SesionHive> {
  @override
  final int typeId = 0;

  @override
  SesionHive read(BinaryReader reader) {
    return SesionHive(
      id: reader.readString(),
      nombreNegocio: reader.readString(),
      rolNombre: reader.readString(),
      rolIcono: reader.readString(),
      fecha: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      contenidoBloques: reader.readMap(),
      puntuaciones: reader.readMap(),
      importancias: reader.readMap(),
      indiceFactibilidad: reader.readDouble(),
      nivelFactibilidad: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, SesionHive obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.nombreNegocio);
    writer.writeString(obj.rolNombre);
    writer.writeString(obj.rolIcono);
    writer.writeInt(obj.fecha.millisecondsSinceEpoch);
    writer.writeMap(obj.contenidoBloques);
    writer.writeMap(obj.puntuaciones);
    writer.writeMap(obj.importancias);
    writer.writeDouble(obj.indiceFactibilidad);
    writer.writeString(obj.nivelFactibilidad);
  }
}

class CircularCanvasApp extends StatelessWidget {
  const CircularCanvasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CircularCanvas',
      debugShowCheckedModeBanner: false,
      theme: AppTema.tema,
      home: const PantallaRol(),
    );
  }
}
