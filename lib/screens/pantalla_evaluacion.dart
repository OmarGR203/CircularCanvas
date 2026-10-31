import 'package:flutter/material.dart';
import '../models/models.dart';
import '../data/canvas_data.dart';
import '../data/tema.dart';
import 'pantalla_resultados.dart';
import '../main.dart';

class PantallaEvaluacion extends StatefulWidget {
  final List<BloqueCanvas> bloques;
  final RolEmprendedor rol;
  final String nombreNegocio;
  final SesionHive? sesionExistente;


  const PantallaEvaluacion({
    super.key,
    required this.bloques,
    required this.rol,
    required this.nombreNegocio,
    this.sesionExistente,
  });

  @override
  State<PantallaEvaluacion> createState() => _PantallaEvaluacionState();
}

class _PantallaEvaluacionState extends State<PantallaEvaluacion> {
  late List<ItemEvaluacion> _items;




  @override
  void initState() {
    super.initState();
    _items = obtenerItemsEvaluacion();
    final sesion = widget.sesionExistente;

    if (sesion != null) {
      for (var i = 0; i < _items.length; i++) {
        final item = _items[i];

        item.puntuacion = (
            sesion.puntuaciones[i] ??
                sesion.puntuaciones[i.toString()] ??
                item.puntuacion
        ) as int;

        item.importancia = (
            sesion.importancias[i] ??
                sesion.importancias[i.toString()] ??
                item.importancia
        ) as int;
      }
    }
  }



  ResultadoFactibilidad _calcularResultado() {
    double sumaTotal = 0;
    double pesoTotal = 0;
    final puntajesPorBloque = <String, double>{};

    final grupos = <String, List<ItemEvaluacion>>{};
    for (final item in _items) {
      grupos.putIfAbsent(item.bloque, () => []).add(item);
    }

    for (final entry in grupos.entries) {
      double sumaBloque = 0;
      double pesoBloque = 0;
      for (final item in entry.value) {
        sumaBloque += item.puntuacion * item.importancia;
        pesoBloque += 5 * item.importancia;
      }
      final pct = pesoBloque > 0 ? (sumaBloque / pesoBloque) * 100 : 0.0;
      puntajesPorBloque[entry.key] = pct;
      sumaTotal += sumaBloque;
      pesoTotal += pesoBloque;
    }

    final indice = pesoTotal > 0 ? (sumaTotal / pesoTotal) * 100 : 0.0;

    final fortalezas = <String>[];
    final debilidades = <String>[];
    puntajesPorBloque.forEach((bloque, pct) {
      if (pct >= 65) fortalezas.add('$bloque bien definido y viable');
      if (pct < 40) debilidades.add('$bloque requiere refuerzo urgente');
    });

    final sinCompletar = widget.bloques.where((b) => !b.estaLleno).length;
    if (sinCompletar > 3) {
      debilidades.add('$sinCompletar bloques del Canvas sin completar');
    }

    return ResultadoFactibilidad(
      indice: indice,
      fortalezas: fortalezas.isEmpty
          ? ['Completa la evaluación para identificar fortalezas']
          : fortalezas,
      debilidades:
          debilidades.isEmpty ? ['No se detectaron debilidades críticas'] : debilidades,
      oportunidades: oportunidadesContexto,
      amenazas: amenazasContexto,
      puntajesPorBloque: puntajesPorBloque,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Evaluación de factibilidad')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Evalúa cada afirmación',
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 4),
                  Text(
                    'Desliza hacia la derecha si estás de acuerdo con la afirmación positiva.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 20),
                  ..._items.map((item) => _ItemEval(
                        item: item,
                        onCambio: () => setState(() {}),
                      )),
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
                    builder: (_) => PantallaResultados(
                      resultado: _calcularResultado(),
                      nombreNegocio: widget.nombreNegocio,
                      rol: widget.rol,
                      bloques: widget.bloques,
                      items: _items,
                      sesionId: widget.sesionExistente?.id,
                    ),
                  ),
                ),
                icon: const Icon(Icons.bar_chart_outlined),
                label: const Text('Ver resultados'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemEval extends StatelessWidget {
  final ItemEvaluacion item;
  final VoidCallback onCambio;

  const _ItemEval({required this.item, required this.onCambio});

  Color get _colorCategoria {
    switch (item.categoria) {
      case 'circular': return AppTema.circular;
      case 'externo': return AppTema.ambar;
      default: return AppTema.verde;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _colorCategoria.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(item.bloque,
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _colorCategoria)),
                ),
                if (item.categoria == 'circular') ...[
                  const SizedBox(width: 6),
                  Icon(Icons.recycling, size: 14, color: AppTema.circular),
                ],
              ],
            ),
            const SizedBox(height: 10),
            Text(item.afirmacionPositiva,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text('← ${item.afirmacionNegativa}',
                      style: TextStyle(fontSize: 10, color: AppTema.textoClaro),
                      textAlign: TextAlign.right),
                ),
                Expanded(
                  flex: 3,
                  child: StatefulBuilder(
                    builder: (ctx, setSt) => Slider(
                      value: item.puntuacion.toDouble(),
                      min: 1,
                      max: 5,
                      divisions: 4,
                      label: item.puntuacion.toString(),
                      activeColor: AppTema.menta,
                      inactiveColor: AppTema.borde,
                      onChanged: (v) {
                        item.puntuacion = v.round();
                        setSt(() {});
                        onCambio();
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text('De acuerdo →',
                      style: TextStyle(fontSize: 10, color: AppTema.menta)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Text('Importancia:',
                    style: TextStyle(fontSize: 12, color: AppTema.textoMedio)),
                const SizedBox(width: 8),
                Expanded(
                  child: StatefulBuilder(
                    builder: (ctx, setSt) => Slider(
                      value: item.importancia.toDouble(),
                      min: 1,
                      max: 10,
                      divisions: 9,
                      label: '${item.importancia}/10',
                      activeColor: AppTema.ambar,
                      inactiveColor: AppTema.borde,
                      onChanged: (v) {
                        item.importancia = v.round();
                        setSt(() {});
                        onCambio();
                      },
                    ),
                  ),
                ),
                Text('${item.importancia}/10',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTema.ambar)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
