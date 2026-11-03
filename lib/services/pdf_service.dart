import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/models.dart';

class PdfService {
  static const PdfColor _verde = PdfColor.fromInt(0xFF286B45);
  static const PdfColor _verdeOscuro = PdfColor.fromInt(0xFF194B32);
  static const PdfColor _menta = PdfColor.fromInt(0xFF58A66A);
  static const PdfColor _mentaClaro = PdfColor.fromInt(0xFFEAF5EC);
  static const PdfColor _naranja = PdfColor.fromInt(0xFFF29A38);
  static const PdfColor _fondo = PdfColor.fromInt(0xFFF6F8F5);
  static const PdfColor _texto = PdfColor.fromInt(0xFF24342B);
  static const PdfColor _textoMedio = PdfColor.fromInt(0xFF5C6D61);
  static const PdfColor _borde = PdfColor.fromInt(0xFFDCE7DE);
  static const PdfColor _rojo = PdfColor.fromInt(0xFFE06B62);
  static const PdfColor _azul = PdfColor.fromInt(0xFF4385B8);

  static Future<bool> exportarAnalisis({
    required String nombreNegocio,
    required RolEmprendedor rol,
    required List<BloqueCanvas> bloques,
    required ResultadoFactibilidad resultado,
  }) async {
    final documento = pw.Document(
      title: 'Informe de factibilidad - $nombreNegocio',
      author: 'CircularCanvas',
      subject: 'Evaluación de modelo de negocio en economía circular',
    );

    final logoData = await rootBundle.load(
      'assets/images/logo_circular_canvas.jpg',
    );
    final logo = pw.MemoryImage(logoData.buffer.asUint8List());

    final imagenRolData = await rootBundle.load(_rutaImagenRol(rol));
    final imagenRol = pw.MemoryImage(imagenRolData.buffer.asUint8List());

    final fecha = DateTime.now();
    final fechaTexto =
        '${fecha.day.toString().padLeft(2, '0')}/'
        '${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';

    documento.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(38, 38, 38, 48),
        theme: pw.ThemeData.withFont(
          base: pw.Font.helvetica(),
          bold: pw.Font.helveticaBold(),
        ),
        header: (context) => _encabezado(logo, context),
        footer: (context) => _piePagina(context),
        build: (context) => [
          _portada(
            nombreNegocio: nombreNegocio,
            rol: rol,
            imagenRol: imagenRol,
            fecha: fechaTexto,
            indice: resultado.indice,
            nivel: resultado.nivelFactibilidad,
          ),
          pw.SizedBox(height: 22),
          _tituloSeccion('01', 'Resumen de factibilidad'),
          _resumenFactibilidad(resultado),
          pw.SizedBox(height: 20),
          _tituloSeccion('02', 'Evaluación por bloque'),
          _tablaPuntajes(resultado),
          pw.SizedBox(height: 20),
          _tituloSeccion('03', 'Modelo de negocio Canvas'),
          pw.Text(
            'Información registrada en los nueve componentes del modelo de negocio.',
            style: const pw.TextStyle(color: _textoMedio, fontSize: 9),
          ),
          pw.SizedBox(height: 9),
          _tablaCanvas(bloques),
          pw.SizedBox(height: 20),
          _tituloSeccion('04', 'Análisis estratégico DAFO'),
          pw.Text(
            'Síntesis de los factores internos y externos identificados durante la evaluación.',
            style: const pw.TextStyle(color: _textoMedio, fontSize: 9),
          ),
          pw.SizedBox(height: 10),
          _tablaDafo('FORTALEZAS', resultado.fortalezas,
              resultado.observacionesFortalezas, _menta),
          pw.SizedBox(height: 9),
          _tablaDafo('DEBILIDADES', resultado.debilidades,
              resultado.observacionesDebilidades, _rojo),
          pw.SizedBox(height: 9),
          _tablaDafo('OPORTUNIDADES', resultado.oportunidades,
              resultado.observacionesOportunidades, _azul),
          pw.SizedBox(height: 9),
          _tablaDafo('AMENAZAS', resultado.amenazas,
              resultado.observacionesAmenazas, _naranja),
          pw.SizedBox(height: 20),
          _notaFinal(),
        ],
      ),
    );

    final bytes = await documento.save();
    final nombreSeguro = _nombreArchivo(nombreNegocio);
    final ruta = await FilePicker.platform.saveFile(
      dialogTitle: 'Guardar informe de CircularCanvas',
      fileName: 'CircularCanvas_${nombreSeguro}_$fechaTexto.pdf',
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      bytes: bytes,
    );

    return ruta != null;
  }

  static String _rutaImagenRol(RolEmprendedor rol) {
    switch (rol) {
      case RolEmprendedor.directorEjecutivo:
        return 'assets/images/senior.jpg';
      case RolEmprendedor.intrapreneur:
        return 'assets/images/intraemprendedor.jpg';
      case RolEmprendedor.emprendedor:
        return 'assets/images/emprendedor.jpg';
      case RolEmprendedor.inversor:
        return 'assets/images/inversor.jpg';
      case RolEmprendedor.consultor:
        return 'assets/images/consultor.jpg';
      case RolEmprendedor.disenador:
        return 'assets/images/disenador.jpg';
      case RolEmprendedor.emprendedorConcienciado:
        return 'assets/images/concienzudo.jpg';
    }
  }

  static String _nombreArchivo(String nombre) {
    final limpio = nombre
        .trim()
        .replaceAll(RegExp(r'[\\/:*?"<>|]'), '_')
        .replaceAll(RegExp(r'\s+'), '_');
    return limpio.isEmpty ? 'Modelo_de_negocio' : limpio;
  }

  static pw.Widget _encabezado(pw.MemoryImage logo, pw.Context context) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 16),
      padding: const pw.EdgeInsets.only(bottom: 8),
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: _borde, width: 0.8)),
      ),
      child: pw.Row(
        children: [
          pw.Image(logo, width: 25, height: 25),
          pw.SizedBox(width: 7),
          pw.Text(
            'CIRCULARCANVAS',
            style: pw.TextStyle(
              color: _verdeOscuro,
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
          pw.Spacer(),
          pw.Text(
            'INFORME DE FACTIBILIDAD',
            style: const pw.TextStyle(color: _textoMedio, fontSize: 7),
          ),
        ],
      ),
    );
  }

  static pw.Widget _piePagina(pw.Context context) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 12),
      padding: const pw.EdgeInsets.only(top: 8),
      decoration: const pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: _borde, width: 0.8)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'CircularCanvas · Economía circular e innovación',
            style: const pw.TextStyle(color: _textoMedio, fontSize: 7),
          ),
          pw.Text(
            'Página ${context.pageNumber} de ${context.pagesCount}',
            style: const pw.TextStyle(color: _textoMedio, fontSize: 7),
          ),
        ],
      ),
    );
  }

  static pw.Widget _portada({
    required String nombreNegocio,
    required RolEmprendedor rol,
    required pw.MemoryImage imagenRol,
    required String fecha,
    required double indice,
    required String nivel,
  }) {
    final colorNivel = indice >= 70
        ? _menta
        : indice >= 40
            ? _naranja
            : _rojo;

    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        color: _fondo,
        borderRadius: pw.BorderRadius.circular(14),
        border: pw.Border.all(color: _borde),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: 42,
            height: 4,
            decoration: pw.BoxDecoration(
              color: _naranja,
              borderRadius: pw.BorderRadius.circular(2),
            ),
          ),
          pw.SizedBox(height: 15),
          pw.Text(
            'REPORTE DE EVALUACIÓN',
            style: pw.TextStyle(
              color: _verde,
              fontSize: 8,
              fontWeight: pw.FontWeight.bold,
              letterSpacing: 1.4,
            ),
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            nombreNegocio,
            style: pw.TextStyle(
              color: _verdeOscuro,
              fontSize: 22,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 16),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Container(
                width: 76,
                height: 76,
                padding: const pw.EdgeInsets.all(3),
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  border: pw.Border.all(color: _borde),
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.ClipRRect(
                  horizontalRadius: 7,
                  verticalRadius: 7,
                  child: pw.Image(imagenRol, fit: pw.BoxFit.cover),
                ),
              ),
              pw.SizedBox(width: 13),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'PERSPECTIVA DE ANÁLISIS',
                      style: const pw.TextStyle(
                        color: _textoMedio,
                        fontSize: 7,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      rol.nombre,
                      style: pw.TextStyle(
                        color: _verdeOscuro,
                        fontSize: 13,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      rol.descripcion,
                      style: const pw.TextStyle(
                        color: _textoMedio,
                        fontSize: 8,
                      ),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      'Fecha de elaboración: $fecha',
                      style: const pw.TextStyle(
                        color: _textoMedio,
                        fontSize: 8,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(width: 10),
              pw.Container(
                width: 88,
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 12,
                ),
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  borderRadius: pw.BorderRadius.circular(10),
                  border: pw.Border.all(color: _borde),
                ),
                child: pw.Column(
                  children: [
                    pw.Text(
                      '${indice.toStringAsFixed(1)}%',
                      style: pw.TextStyle(
                        color: colorNivel,
                        fontSize: 21,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'FACTIBILIDAD $nivel',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        color: colorNivel,
                        fontSize: 6,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _tituloSeccion(String numero, String titulo) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 9),
      child: pw.Row(
        children: [
          pw.Container(
            width: 23,
            height: 23,
            alignment: pw.Alignment.center,
            decoration: pw.BoxDecoration(
              color: _mentaClaro,
              borderRadius: pw.BorderRadius.circular(6),
            ),
            child: pw.Text(
              numero,
              style: pw.TextStyle(
                color: _verde,
                fontSize: 8,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.SizedBox(width: 8),
          pw.Text(
            titulo,
            style: pw.TextStyle(
              color: _verdeOscuro,
              fontSize: 13,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _resumenFactibilidad(ResultadoFactibilidad resultado) {
    final color = resultado.indice >= 70
        ? _menta
        : resultado.indice >= 40
            ? _naranja
            : _rojo;
    return pw.Container(
      padding: const pw.EdgeInsets.all(13),
      decoration: pw.BoxDecoration(
        color: _fondo,
        borderRadius: pw.BorderRadius.circular(10),
        border: pw.Border.all(color: _borde),
      ),
      child: pw.Row(
        children: [
          pw.Expanded(
            child: _datoResumen(
              'ÍNDICE GLOBAL',
              '${resultado.indice.toStringAsFixed(1)}%',
              color,
            ),
          ),
          pw.Container(width: 0.8, height: 35, color: _borde),
          pw.SizedBox(width: 14),
          pw.Expanded(
            child: _datoResumen(
              'NIVEL',
              resultado.nivelFactibilidad.toUpperCase(),
              color,
            ),
          ),
          pw.Container(width: 0.8, height: 35, color: _borde),
          pw.SizedBox(width: 14),
          pw.Expanded(
            child: _datoResumen(
              'BLOQUES',
              '${resultado.puntajesPorBloque.length}',
              _verde,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _datoResumen(String etiqueta, String valor, PdfColor color) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          etiqueta,
          style: const pw.TextStyle(color: _textoMedio, fontSize: 7),
        ),
        pw.SizedBox(height: 5),
        pw.Text(
          valor,
          style: pw.TextStyle(
            color: color,
            fontSize: 15,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ],
    );
  }

  static pw.Widget _tablaPuntajes(ResultadoFactibilidad resultado) {
    final filas = resultado.puntajesPorBloque.entries
        .map((e) => [e.key, '${e.value.clamp(0, 100).toStringAsFixed(1)}%'])
        .toList();
    if (filas.isEmpty) {
      filas.add(['Sin datos de evaluación', '—']);
    }
    return pw.TableHelper.fromTextArray(
      headers: ['Componente evaluado', 'Puntuación'],
      data: filas,
      columnWidths: {
        0: const pw.FlexColumnWidth(3),
        1: const pw.FlexColumnWidth(1),
      },
      headerDecoration: const pw.BoxDecoration(color: _verde),
      headerStyle: pw.TextStyle(
        color: PdfColors.white,
        fontSize: 8,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(color: _texto, fontSize: 8),
      oddRowDecoration: const pw.BoxDecoration(color: _fondo),
      cellPadding: const pw.EdgeInsets.symmetric(horizontal: 9, vertical: 7),
      border: pw.TableBorder.all(color: _borde, width: 0.5),
      cellAlignment: pw.Alignment.centerLeft,
    );
  }

  static pw.Widget _tablaCanvas(List<BloqueCanvas> bloques) {
    final filas = bloques
        .map((b) => [
              '${b.numero}. ${b.titulo}${b.esCircular ? ' · Circular' : ''}',
              b.contenido.trim().isEmpty ? 'Sin completar' : b.contenido.trim(),
            ])
        .toList();
    return pw.TableHelper.fromTextArray(
      headers: ['Componente', 'Descripción registrada'],
      data: filas,
      columnWidths: {
        0: const pw.FlexColumnWidth(1.25),
        1: const pw.FlexColumnWidth(3),
      },
      headerDecoration: const pw.BoxDecoration(color: _verde),
      headerStyle: pw.TextStyle(
        color: PdfColors.white,
        fontSize: 8,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(color: _texto, fontSize: 8),
      oddRowDecoration: const pw.BoxDecoration(color: _fondo),
      cellPadding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      border: pw.TableBorder.all(color: _borde, width: 0.5),
      cellAlignment: pw.Alignment.topLeft,
    );
  }

  static pw.Widget _tablaDafo(
    String titulo,
    List<String> elementos,
    List<String> observaciones,
    PdfColor color,
  ) {
    final contenido = <pw.Widget>[];
    if (elementos.isEmpty && observaciones.isEmpty) {
      contenido.add(
        pw.Text(
          'No se registraron elementos en esta categoría.',
          style: const pw.TextStyle(color: _textoMedio, fontSize: 8),
        ),
      );
    } else {
      for (final item in elementos) {
        contenido.add(_vineta(item));
      }
      for (final item in observaciones) {
        contenido.add(_vineta(item, observacion: true));
      }
    }

    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: _fondo,
        border: pw.Border(
          left: pw.BorderSide(color: color, width: 3),
          top: const pw.BorderSide(color: _borde, width: 0.5),
          right: const pw.BorderSide(color: _borde, width: 0.5),
          bottom: const pw.BorderSide(color: _borde, width: 0.5),
        ),
        borderRadius: pw.BorderRadius.circular(7),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            titulo,
            style: pw.TextStyle(
              color: color,
              fontSize: 8,
              fontWeight: pw.FontWeight.bold,
              letterSpacing: 0.7,
            ),
          ),
          pw.SizedBox(height: 6),
          ...contenido,
        ],
      ),
    );
  }

  static pw.Widget _vineta(String texto, {bool observacion = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 3),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            observacion ? '– ' : '• ',
            style: pw.TextStyle(
              color: observacion ? _naranja : _verde,
              fontSize: 8,
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              texto,
              style: pw.TextStyle(
                color: _texto,
                fontSize: 8,
                fontStyle:
                    observacion ? pw.FontStyle.italic : pw.FontStyle.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _notaFinal() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(11),
      decoration: pw.BoxDecoration(
        color: _mentaClaro,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Text(
        'Este informe es un apoyo para el análisis del modelo de negocio. '
        'Los resultados dependen de la información proporcionada y deben '
        'complementarse con validación de mercado, análisis financiero y '
        'revisión de los impactos ambientales correspondientes.',
        style: const pw.TextStyle(color: _verdeOscuro, fontSize: 8),
      ),
    );
  }
}
