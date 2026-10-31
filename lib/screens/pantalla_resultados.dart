import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/models.dart';
import '../data/tema.dart';
import '../data/db_service.dart';
import '../services/pdf_service.dart';

class PantallaResultados extends StatefulWidget {
  final ResultadoFactibilidad resultado;
  final String nombreNegocio;
  final RolEmprendedor rol;
  final List<BloqueCanvas> bloques;
  final List<ItemEvaluacion> items;
  final String? sesionId;


  const PantallaResultados({
    this.sesionId,
    super.key,
    required this.resultado,
    required this.nombreNegocio,
    required this.rol,
    required this.bloques,
    required this.items,
  });

  //String? get sesionId => null;

  @override
  State<PantallaResultados> createState() => _PantallaResultadosState();
}

class _PantallaResultadosState extends State<PantallaResultados> {
  //this.sesionId;
  bool _guardando = false;
  bool _guardado = false;
  String? _idGuardado;

  Color get _colorIndice {
    if (widget.resultado.indice >= 70) return AppTema.menta;
    if (widget.resultado.indice >= 40) return AppTema.ambar;
    return const Color(0xFFE24B4A);
  }

  String get _etiquetaIndice {
    if (widget.resultado.indice >= 70) return 'Factibilidad alta';
    if (widget.resultado.indice >= 40) return 'Factibilidad media';
    return 'Factibilidad baja';
  }

  Future<void> _exportarPDF() async {
    try {
      await PdfService.exportarAnalisis(
        nombreNegocio: widget.nombreNegocio,
        rol: widget.rol,
        bloques: widget.bloques,
        resultado: widget.resultado,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo generar el PDF: $e'),
        ),
      );
    }
  }

  Future<void> _guardar() async {
    setState(() => _guardando = true);
    try {
      final id = await DBService.guardarSesion(
        idExistente: widget.sesionId,
        nombreNegocio: widget.nombreNegocio,
        rol: widget.rol,
        bloques: widget.bloques,
        items: widget.items,
        resultado: widget.resultado,
      );
      setState(() {
        _guardado = true;
        _idGuardado = id;
        _guardando = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text('Sesión guardada correctamente'),
              ],
            ),
            backgroundColor: AppTema.menta,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      setState(() => _guardando = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar: $e'),
            backgroundColor: const Color(0xFFE24B4A),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final indiceRedondeado = widget.resultado.indice.round();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados de factibilidad'),
        actions: [
          IconButton(
            tooltip: 'Exportar a PDF',
            icon: const Icon(Icons.picture_as_pdf_outlined),
            onPressed: _exportarPDF,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _guardado
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, color: AppTema.menta, size: 18),
                      const SizedBox(width: 4),
                      const Text('Guardado', style: TextStyle(fontSize: 13)),
                      const SizedBox(width: 8),
                    ],
                  )
                : TextButton.icon(
                    onPressed: _guardando ? null : _guardar,
                    icon: _guardando
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.save_outlined, color: Colors.white, size: 18),
                    label: Text(
                      _guardando ? 'Guardando...' : 'Guardar',
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text(widget.rol.icono, style: const TextStyle(fontSize: 32)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.nombreNegocio,
                              style: Theme.of(context).textTheme.titleMedium),
                          Text(widget.rol.nombre,
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          PieChart(
                            PieChartData(
                              startDegreeOffset: -90,
                              sections: [
                                PieChartSectionData(
                                  value: widget.resultado.indice,
                                  color: _colorIndice,
                                  radius: 12,
                                  showTitle: false,
                                ),
                                PieChartSectionData(
                                  value: 100 - widget.resultado.indice,
                                  color: AppTema.borde,
                                  radius: 12,
                                  showTitle: false,
                                ),
                              ],
                              sectionsSpace: 0,
                              centerSpaceRadius: 26,
                            ),
                          ),
                          Text(
                            '$indiceRedondeado%',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: _colorIndice,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _colorIndice.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(color: _colorIndice.withOpacity(0.3)),
                ),
                child: Text(
                  _etiquetaIndice,
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600, color: _colorIndice),
                ),
              ),
            ),

            const SizedBox(height: 20),
            Text('Puntuación por bloque',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: widget.resultado.puntajesPorBloque.entries.map((e) {
                    final pct = e.value.clamp(0.0, 100.0);
                    final color = pct >= 65
                        ? AppTema.menta
                        : pct >= 40
                            ? AppTema.ambar
                            : const Color(0xFFE24B4A);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(e.key,
                                    style: const TextStyle(fontSize: 12),
                                    overflow: TextOverflow.ellipsis),
                              ),
                              Text('${pct.round()}%',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: color)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(99),
                            child: LinearProgressIndicator(
                              value: pct / 100,
                              backgroundColor: AppTema.borde,
                              valueColor: AlwaysStoppedAnimation<Color>(color),
                              minHeight: 8,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 20),
            Text('Análisis DAFO del modelo',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.1,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: [
                _CeldaDAFO(
                    titulo: 'Fortalezas',
                    icono: Icons.trending_up,
                    color: AppTema.menta,
                    items: widget.resultado.fortalezas),
                _CeldaDAFO(
                    titulo: 'Debilidades',
                    icono: Icons.trending_down,
                    color: const Color(0xFFE24B4A),
                    items: widget.resultado.debilidades),
                _CeldaDAFO(
                    titulo: 'Oportunidades',
                    icono: Icons.lightbulb_outline,
                    color: const Color(0xFF378ADD),
                    items: widget.resultado.oportunidades),
                _CeldaDAFO(
                    titulo: 'Amenazas',
                    icono: Icons.warning_amber_outlined,
                    color: AppTema.ambar,
                    items: widget.resultado.amenazas),
              ],
            ),

            const SizedBox(height: 24),
            Center(
              child: Text(
                'CBMC (Lewandowski, 2015) + DAFO (Osterwalder & Pigneur, 2010 pp. 216–219)',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _CeldaDAFO extends StatelessWidget {
  final String titulo;
  final IconData icono;
  final Color color;
  final List<String> items;

  const _CeldaDAFO(
      {required this.titulo,
      required this.icono,
      required this.color,
      required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icono, size: 16, color: color),
              const SizedBox(width: 6),
              Text(titulo,
                  style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600, color: color)),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: items
                    .take(3)
                    .map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('• ',
                                  style: TextStyle(fontSize: 11, color: color)),
                              Expanded(
                                child: Text(item,
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: AppTema.textoMedio,
                                        height: 1.3)),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
