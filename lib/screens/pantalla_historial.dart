import 'package:flutter/material.dart';
import '../data/tema.dart';
import '../data/db_service.dart';
import '../main.dart';
import '../data/adjunto_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/models.dart';
import 'pantalla_canvas.dart';

class PantallaHistorial extends StatefulWidget {
  const PantallaHistorial({super.key});

  @override
  State<PantallaHistorial> createState() => _PantallaHistorialState();
}

class _PantallaHistorialState extends State<PantallaHistorial> {
  late List<SesionHive> _sesiones;

  Future<void> adjuntar(SesionHive sesion) async {
    try {
      final cantidad = await AdjuntoService.adjuntar(sesion.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$cantidad archivo(s) adjuntado(s)',
          ),
        ),
      );

      _refrescar();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al adjuntar archivos: $e')),
      );
    }
  }

  Future<void> _gestionarAdjuntos(SesionHive sesion) async {
    Future<List<Map>> cargarArchivos() {
      return AdjuntoService.obtenerPorSesion(sesion.id);
    }

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, actualizarDialogo) {
            return AlertDialog(
              title: Text('Archivos de ${sesion.nombreNegocio}'),
              content: SizedBox(
                width: 450,
                child: FutureBuilder<List<Map>>(
                  future: cargarArchivos(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        height: 100,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (snapshot.hasError) {
                      return const Text('No se pudieron cargar los archivos.');
                    }

                    final archivos = snapshot.data ?? [];

                    if (archivos.isEmpty) {
                      return const Text(
                          'Esta evaluación todavía no tiene archivos adjuntos.');
                    }

                    return SizedBox(
                      height: 300,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: archivos.length,
                        itemBuilder: (context, index) {
                          final archivo = archivos[index];

                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading:
                                const Icon(Icons.insert_drive_file_outlined),
                            title: Text(
                              archivo['nombre'].toString(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              AdjuntoService.tamanoLegible(
                                archivo['tamano'] as int,
                              ),
                            ),
                            trailing: Wrap(
                              spacing: 0,
                              children: [
                                IconButton(
                                  tooltip: 'Descargar',
                                  icon: const Icon(Icons.download),
                                  onPressed: () {
                                    AdjuntoService.descargar(archivo);
                                  },
                                ),
                                IconButton(
                                  tooltip: 'Eliminar archivo',
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    await AdjuntoService.eliminar(
                                      archivo['id'].toString(),
                                    );

                                    actualizarDialogo(() {});
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cerrar'),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    final cantidad = await AdjuntoService.adjuntar(sesion.id);

                    if (!mounted) return;

                    actualizarDialogo(() {});
                    _refrescar();

                    if (cantidad > 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('$cantidad archivo(s) adjuntado(s)'),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.attach_file),
                  label: const Text('Agregar archivos'),
                ),
              ],
            );
          },
        );
      },
    );
  }


  void _editar(SesionHive sesion) {
    final roles = RolEmprendedor.values.where(
          (r) => r.nombre == sesion.rolNombre,
    );

    if (roles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo identificar el rol de esta sesión.'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PantallaCanvas(
          sesionExistente: sesion,
          rol: roles.first,
          nombreNegocio: sesion.nombreNegocio,
        ),
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    _sesiones = DBService.obtenerSesiones();
  }

  void _refrescar() {
    if (!mounted) return;

    setState(() {
      _sesiones = DBService.obtenerSesiones();
    });
  }

  Future<void> _eliminar(SesionHive sesion) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Eliminar sesión'),
        content: Text(
            '¿Deseas eliminar la evaluación de "${sesion.nombreNegocio}"? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE24B4A)),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmar == true) {
      await DBService.eliminarSesion(sesion.id);
      await AdjuntoService.eliminarPorSesion(sesion.id);
      _refrescar();
    }
  }

  Color _colorNivel(String nivel) {
    switch (nivel) {
      case 'Alta':
        return AppTema.menta;
      case 'Media':
        return AppTema.ambar;
      default:
        return const Color(0xFFE24B4A);
    }
  }

  String _formatFecha(DateTime fecha) {
    return '${fecha.day}/${fecha.month}/${fecha.year} ${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de evaluaciones'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${Hive.box<SesionHive>('sesiones').length} guardadas',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<SesionHive>('sesiones').listenable(),
        builder: (context, box, child) {
          final sesionesActualizadas = DBService.obtenerSesiones();

          return sesionesActualizadas.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.folder_open_outlined,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      const Text('No hay evaluaciones guardadas'),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: sesionesActualizadas.length,
                  itemBuilder: (context, index) {
                    final sesion = sesionesActualizadas[index];
                    final color = _colorNivel(sesion.nivelFactibilidad);

                    final bloqLlenos = sesion.contenidoBloques.values
                        .where((v) => v.toString().trim().isNotEmpty)
                        .length;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppTema.mentaClaro,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  sesion.rolIcono,
                                  style: const TextStyle(fontSize: 22),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    sesion.nombreNegocio,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    sesion.rolNombre,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppTema.textoMedio,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today_outlined,
                                        size: 11,
                                        color: AppTema.textoClaro,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        _formatFecha(sesion.fecha),
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: AppTema.textoClaro,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Icon(
                                        Icons.grid_view_outlined,
                                        size: 11,
                                        color: AppTema.textoClaro,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '$bloqLlenos/11 bloques',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: AppTema.textoClaro,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(99),
                                  ),
                                  child: Text(
                                    '${sesion.indiceFactibilidad.round()}%',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: color,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  sesion.nivelFactibilidad,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: color,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                IconButton(
                                  tooltip: 'Administrar archivos adjuntos',
                                  visualDensity: VisualDensity.compact,
                                  icon: const Icon(
                                    Icons.attach_file,
                                    size: 19,
                                    color: Colors.blueGrey,
                                  ),
                                  onPressed: () => _gestionarAdjuntos(sesion),
                                ),
                                IconButton(
                                  tooltip: 'Editar evaluación',
                                  visualDensity: VisualDensity.compact,
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                    size: 19,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () => _editar(sesion),
                                ),
                                GestureDetector(
                                  onTap: () => _eliminar(sesion),
                                  child: Icon(
                                    Icons.delete_outline,
                                    size: 18,
                                    color: AppTema.textoClaro,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
