enum RolEmprendedor {
  directorEjecutivo,
  intrapreneur,
  emprendedor,
  inversor,
  consultor,
  disenador,
  emprendedorConcienciado,
}

extension RolEmprendedorExt on RolEmprendedor {
  String get nombre {
    switch (this) {
      case RolEmprendedor.directorEjecutivo: return 'Director ejecutivo';
      case RolEmprendedor.intrapreneur: return 'Intrapreneur';
      case RolEmprendedor.emprendedor: return 'Emprendedor';
      case RolEmprendedor.inversor: return 'Inversor';
      case RolEmprendedor.consultor: return 'Consultor';
      case RolEmprendedor.disenador: return 'Diseñador';
      case RolEmprendedor.emprendedorConcienciado: return 'Emprendedor concienciado';
    }
  }

  String get descripcion {
    switch (this) {
      case RolEmprendedor.directorEjecutivo: return 'Visión global y sostenibilidad del modelo';
      case RolEmprendedor.intrapreneur: return 'Innovación desde dentro de una empresa';
      case RolEmprendedor.emprendedor: return 'Creación de un negocio desde cero';
      case RolEmprendedor.inversor: return 'Viabilidad financiera y fuentes de ingreso';
      case RolEmprendedor.consultor: return 'Diagnóstico externo del modelo';
      case RolEmprendedor.disenador: return 'Propuesta de valor y experiencia del cliente';
      case RolEmprendedor.emprendedorConcienciado: return 'Impacto ambiental y circularidad';
    }
  }

  String get icono {
    switch (this) {
      case RolEmprendedor.directorEjecutivo: return '🏢';
      case RolEmprendedor.intrapreneur: return '💡';
      case RolEmprendedor.emprendedor: return '🚀';
      case RolEmprendedor.inversor: return '💰';
      case RolEmprendedor.consultor: return '🧩';
      case RolEmprendedor.disenador: return '🎨';
      case RolEmprendedor.emprendedorConcienciado: return '🌱';
    }
  }
}

class BloqueCanvas {
  final int numero;
  final String titulo;
  final String descripcion;
  final String preguntaGuia;
  final bool esCircular;
  String contenido;

  BloqueCanvas({
    required this.numero,
    required this.titulo,
    required this.descripcion,
    required this.preguntaGuia,
    required this.esCircular,
    this.contenido = '',
  });

  bool get estaLleno => contenido.trim().isNotEmpty;
}

class ItemEvaluacion {
  final String bloque;
  final String afirmacionPositiva;
  final String afirmacionNegativa;
  final String categoria;
  int puntuacion;
  int importancia;

  ItemEvaluacion({
    required this.bloque,
    required this.afirmacionPositiva,
    required this.afirmacionNegativa,
    required this.categoria,
    this.puntuacion = 3,
    this.importancia = 5,
  });
}

class ResultadoFactibilidad {
  final double indice;

  final List<String> fortalezas;
  final List<String> debilidades;
  final List<String> oportunidades;
  final List<String> amenazas;

  final Map<String, double> puntajesPorBloque;


  final List<String> observacionesFortalezas;
  final List<String> observacionesDebilidades;
  final List<String> observacionesOportunidades;
  final List<String> observacionesAmenazas;

  ResultadoFactibilidad({
    required this.indice,
    required this.fortalezas,
    required this.debilidades,
    required this.oportunidades,
    required this.amenazas,
    required this.puntajesPorBloque,
    this.observacionesFortalezas = const [],
    this.observacionesDebilidades = const [],
    this.observacionesOportunidades = const [],
    this.observacionesAmenazas = const [],
  });

  String get nivelFactibilidad {
    if (indice >= 70) return 'Alta';
    if (indice >= 40) return 'Media';
    return 'Baja';
  }
}
