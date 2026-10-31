import 'package:flutter/material.dart';
import '../models/models.dart';
import '../data/tema.dart';
import '../data/db_service.dart';
import 'pantalla_canvas.dart';
import 'pantalla_historial.dart';

class PantallaRol extends StatefulWidget {
  const PantallaRol({super.key});

  @override
  State<PantallaRol> createState() => _PantallaRolState();
}



class _PantallaRolState extends State<PantallaRol> {
  RolEmprendedor? _rolSeleccionado;
  final _nombreController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  void _continuar() {
    if (_rolSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona tu rol para continuar')),
      );
      return;
    }
    if (_nombreController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa el nombre de tu negocio')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PantallaCanvas(
          rol: _rolSeleccionado!,
          nombreNegocio: _nombreController.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalSesiones = DBService.totalSesiones;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Image.asset(
                  'assets/images/logo_circular_canvas.png',
                  width: 150,
                  height: 150,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTema.verde,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.recycling, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('CircularCanvas',
                            style: Theme.of(context).textTheme.headlineSmall),
                        Text('Sistema de factibilidad en economía circular',
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                  // Botón historial
                  if (totalSesiones > 0)
                    Stack(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const PantallaHistorial()),
                          ).then((_) => setState(() {})),
                          icon: const Icon(Icons.history),
                          color: AppTema.verde,
                          tooltip: 'Ver historial',
                        ),
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: AppTema.menta,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '$totalSesiones',
                              style: const TextStyle(
                                  fontSize: 9,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 32),

              Text('Nombre de tu negocio o idea',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              TextField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  hintText: 'Ej. EcoPlásticos del Valle',
                  prefixIcon: Icon(Icons.business_outlined),
                ),
              ),
              const SizedBox(height: 28),

              Text('¿Desde qué perspectiva analizas tu modelo?',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text('Las 7 caras de la innovación en modelos de negocio',
                  style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 16),

              LayoutBuilder(builder: (context, constraints) {
                final cols = constraints.maxWidth > 500 ? 3 : 2;
                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: cols,
                  childAspectRatio: 1.3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: RolEmprendedor.values
                      .map((rol) => _TarjetaRol(
                            rol: rol,
                            seleccionado: _rolSeleccionado == rol,
                            onTap: () => setState(() => _rolSeleccionado = rol),
                          ))
                      .toList(),
                );
              }),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _continuar,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Comenzar análisis'),
                ),
              ),
              if (totalSesiones > 0) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PantallaHistorial()),
                    ).then((_) => setState(() {})),
                    icon: Icon(Icons.history, color: AppTema.verde),
                    label: Text('Ver $totalSesiones evaluación(es) guardada(s)',
                        style: TextStyle(color: AppTema.verde)),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppTema.verde),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Basado en CBMC (Lewandowski, 2015)\nOsterwalder & Pigneur (2010)',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TarjetaRol extends StatelessWidget {
  final RolEmprendedor rol;
  final bool seleccionado;
  final VoidCallback onTap;

  const _TarjetaRol({required this.rol, required this.seleccionado, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: seleccionado ? AppTema.mentaClaro : Colors.white,
          border: Border.all(
            color: seleccionado ? AppTema.menta : AppTema.borde,
            width: seleccionado ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(rol.icono, style: const TextStyle(fontSize: 26)),
            const SizedBox(height: 6),
            Text(
              rol.nombre,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: seleccionado ? AppTema.verde : AppTema.textoOscuro,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              rol.descripcion,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: seleccionado ? AppTema.textoMedio : AppTema.textoClaro,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
