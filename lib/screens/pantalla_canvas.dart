import 'package:flutter/material.dart';
import '../main.dart';
import '../models/models.dart';
import '../data/canvas_data.dart';
import '../data/tema.dart';
import '../widgets/tarjeta_bloque.dart';
import 'pantalla_evaluacion.dart';

class PantallaCanvas extends StatefulWidget {
  final SesionHive? sesionExistente;
  final RolEmprendedor rol;
  final String nombreNegocio;

  const PantallaCanvas({this.sesionExistente,super.key, required this.rol, required this.nombreNegocio});

  @override
  State<PantallaCanvas> createState() => _PantallaCanvasState();
}

class _PantallaCanvasState extends State<PantallaCanvas> {
  late List<BloqueCanvas> _bloques;

  @override
  void initState() {
    super.initState();

    _bloques = obtenerBloques();

    final sesion = widget.sesionExistente;

    if (sesion != null) {
      for (final bloque in _bloques) {
        bloque.contenido =
            (sesion.contenidoBloques[bloque.numero] ??
                sesion.contenidoBloques[bloque.numero.toString()] ??
                '').toString();
      }
    }
  }

  int get _bloqLlenos => _bloques.where((b) => b.estaLleno).length;
  double get _progreso => _bloqLlenos / _bloques.length;

  void _seleccionarBloque(BloqueCanvas bloque) {
    final ctrl = TextEditingController(text: bloque.contenido);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            if (bloque.esCircular)
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTema.circularClaro,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text('Circular',
                    style: TextStyle(fontSize: 11, color: AppTema.circular, fontWeight: FontWeight.w600)),
              ),
            Expanded(
              child: Text('Bloque ${bloque.numero}: ${bloque.titulo}',
                  style: const TextStyle(fontSize: 15)),
            ),
          ],
        ),
        content: SizedBox(
          width: 480,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTema.mentaClaro,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(bloque.preguntaGuia,
                    style: TextStyle(fontSize: 13, color: AppTema.verde, fontStyle: FontStyle.italic)),
              ),
              const SizedBox(height: 12),
              Text(bloque.descripcion,
                  style: TextStyle(fontSize: 13, color: AppTema.textoMedio)),
              const SizedBox(height: 14),
              TextField(
                controller: ctrl,
                maxLines: 5,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Describe cómo aplica este bloque a tu modelo de negocio...',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              setState(() => bloque.contenido = ctrl.text);
              Navigator.pop(ctx);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final esAncho = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.nombreNegocio),
            Text('${widget.rol.icono} ${widget.rol.nombre}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text('$_bloqLlenos/${_bloques.length} bloques',
                  style: const TextStyle(fontSize: 13)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: _progreso,
            backgroundColor: AppTema.borde,
            valueColor: AlwaysStoppedAnimation<Color>(AppTema.menta),
            minHeight: 4,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Modelo de negocio circular',
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 4),
                  Text('Toca cada bloque para definirlo. Los bloques 10 y 11 son la extensión circular.',
                      style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 16),
                  esAncho
                      ? _CanvasAncho(bloques: _bloques, onTap: _seleccionarBloque)
                      : _CanvasAngosto(bloques: _bloques, onTap: _seleccionarBloque),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PantallaEvaluacion(
                      bloques: _bloques,
                      rol: widget.rol,
                      nombreNegocio: widget.nombreNegocio,
                    ),
                  ),
                ),
                icon: const Icon(Icons.assessment_outlined),
                label: const Text('Evaluar factibilidad'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CanvasAncho extends StatelessWidget {
  final List<BloqueCanvas> bloques;
  final void Function(BloqueCanvas) onTap;

  const _CanvasAncho({required this.bloques, required this.onTap});

  BloqueCanvas _b(int n) => bloques.firstWhere((b) => b.numero == n);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: TarjetaBloque(bloque: _b(8), onTap: onTap)),
              const SizedBox(width: 6),
              Expanded(
                child: Column(children: [
                  Expanded(child: TarjetaBloque(bloque: _b(7), onTap: onTap)),
                  const SizedBox(height: 6),
                  Expanded(child: TarjetaBloque(bloque: _b(6), onTap: onTap)),
                ]),
              ),
              const SizedBox(width: 6),
              Expanded(child: TarjetaBloque(bloque: _b(2), onTap: onTap)),
              const SizedBox(width: 6),
              Expanded(
                child: Column(children: [
                  Expanded(child: TarjetaBloque(bloque: _b(4), onTap: onTap)),
                  const SizedBox(height: 6),
                  Expanded(child: TarjetaBloque(bloque: _b(3), onTap: onTap)),
                ]),
              ),
              const SizedBox(width: 6),
              Expanded(child: TarjetaBloque(bloque: _b(1), onTap: onTap)),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Row(children: [
          Expanded(child: TarjetaBloque(bloque: _b(9), onTap: onTap)),
          const SizedBox(width: 6),
          Expanded(child: TarjetaBloque(bloque: _b(5), onTap: onTap)),
        ]),
        const SizedBox(height: 6),
        Row(children: [
          Expanded(child: TarjetaBloque(bloque: _b(10), onTap: onTap)),
          const SizedBox(width: 6),
          Expanded(child: TarjetaBloque(bloque: _b(11), onTap: onTap)),
        ]),
      ],
    );
  }
}

class _CanvasAngosto extends StatelessWidget {
  final List<BloqueCanvas> bloques;
  final void Function(BloqueCanvas) onTap;

  const _CanvasAngosto({required this.bloques, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: bloques
          .map((b) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TarjetaBloque(bloque: b, onTap: onTap),
              ))
          .toList(),
    );
  }
}
