
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/models.dart';

class PdfService {
  static Future<void> exportarAnalisis({
    required String nombreNegocio,
    required RolEmprendedor rol,
    required List<BloqueCanvas> bloques,
    required ResultadoFactibilidad resultado,
  }) async {
    final documento = pw.Document();

    final logoData = await rootBundle.load(
      'assets/images/logo_circular_canvas.jpeg',
    );
    final logo = pw.MemoryImage(
      logoData.buffer.asUint8List(),
    );

    documento.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          pw.Center(
            child: pw.Image(logo, width: 90, height: 90),
          ),
          pw.SizedBox(height: 12),
          pw.Header(
            level: 0,
            child: pw.Text('Informe de CircularCanvas'),
          ),
          pw.Text('Negocio: $nombreNegocio'),
          pw.Text('Perfil: ${rol.nombre}'),
          pw.Text(
            'Fecha: ${DateTime.now().toLocal().toString().split(".").first}',
          ),
          pw.SizedBox(height: 16),
          pw.Header(level: 1, child: pw.Text('Modelo de negocio')),
          pw.TableHelper.fromTextArray(
            headers: ['Bloque', 'Contenido'],
            data: bloques.map((b) => [
              '${b.numero}. ${b.titulo}',
              b.contenido.trim().isEmpty
                  ? 'Sin completar'
                  : b.contenido,
            ]).toList(),
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
            ),
            cellAlignment: pw.Alignment.topLeft,
          ),
          pw.SizedBox(height: 18),
          pw.Header(level: 1, child: pw.Text('Factibilidad')),
          pw.Text(
            'Índice: ${resultado.indice.toStringAsFixed(1)}%',
          ),
          pw.Text('Nivel: ${resultado.nivelFactibilidad}'),
          pw.SizedBox(height: 10),
          // FORTALEZAS
          pw.Header(level: 2, child: pw.Text('Fortalezas')),
          ...resultado.fortalezas.map(
                (x) => pw.Bullet(text: x),
          ),
          if (resultado.observacionesFortalezas.isNotEmpty) ...[
            pw.Text(
              'Observaciones:',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            ...resultado.observacionesFortalezas.map(
                  (x) => pw.Bullet(text: x),
            ),
          ],

          // DEBILIDADES
          pw.Header(level: 2, child: pw.Text('Debilidades')),
          ...resultado.debilidades.map(
                (x) => pw.Bullet(text: x),
          ),
          if (resultado.observacionesDebilidades.isNotEmpty) ...[
            pw.Text(
              'Observaciones:',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            ...resultado.observacionesDebilidades.map(
                  (x) => pw.Bullet(text: x),
            ),
          ],

          // OPORTUNIDADES
          pw.Header(level: 2, child: pw.Text('Oportunidades')),
          ...resultado.oportunidades.map(
                (x) => pw.Bullet(text: x),
          ),
          if (resultado.observacionesOportunidades.isNotEmpty) ...[
            pw.Text(
              'Observaciones:',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            ...resultado.observacionesOportunidades.map(
                  (x) => pw.Bullet(text: x),
            ),
          ],

          // AMENAZAS
          pw.Header(level: 2, child: pw.Text('Amenazas')),
          ...resultado.amenazas.map(
                (x) => pw.Bullet(text: x),
          ),
          if (resultado.observacionesAmenazas.isNotEmpty) ...[
            pw.Text(
              'Observaciones:',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            ...resultado.observacionesAmenazas.map(
                  (x) => pw.Bullet(text: x),
            ),
          ],
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => documento.save(),
    );
  }
}
