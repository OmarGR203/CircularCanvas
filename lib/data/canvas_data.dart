import '../models/models.dart';

List<BloqueCanvas> obtenerBloques() {
  return [
    BloqueCanvas(
      numero: 1,
      titulo: 'Segmentos de mercado',
      descripcion: 'Los diferentes grupos de personas o entidades a los que se dirige la empresa.',
      preguntaGuia: '¿Para quién creamos valor? ¿Quiénes son nuestros clientes más importantes?',
      esCircular: false,
    ),
    BloqueCanvas(
      numero: 2,
      titulo: 'Propuesta de valor',
      descripcion: 'El conjunto de productos y servicios que crean valor para el segmento de clientes. En el modelo circular incluye incentivos para devolver productos usados.',
      preguntaGuia: '¿Qué valor entregamos al cliente? ¿Qué problema resolvemos? ¿Qué incentivo ofrecemos para recuperar el producto al final de su vida útil?',
      esCircular: false,
    ),
    BloqueCanvas(
      numero: 3,
      titulo: 'Canales',
      descripcion: 'Cómo la empresa llega a sus segmentos de clientes para entregar la propuesta de valor.',
      preguntaGuia: '¿A través de qué canales quieren ser contactados nuestros clientes? ¿Cuáles funcionan mejor?',
      esCircular: false,
    ),
    BloqueCanvas(
      numero: 4,
      titulo: 'Relaciones con clientes',
      descripcion: 'El tipo de relación que la empresa establece con cada segmento. En economía circular incluye estrategias de marketing social.',
      preguntaGuia: '¿Qué tipo de relación esperan nuestros clientes? ¿Cómo fomentamos que devuelvan los productos usados?',
      esCircular: false,
    ),
    BloqueCanvas(
      numero: 5,
      titulo: 'Fuentes de ingresos',
      descripcion: 'El dinero que genera la empresa. En el modelo circular incluye pagos por disponibilidad, uso o rendimiento.',
      preguntaGuia: '¿Por qué valor están dispuestos a pagar nuestros clientes? ¿Cómo generamos ingresos del material recuperado?',
      esCircular: false,
    ),
    BloqueCanvas(
      numero: 6,
      titulo: 'Recursos clave',
      descripcion: 'Los activos más importantes para el modelo. En el modelo circular: proveedores con materiales de mejor desempeño.',
      preguntaGuia: '¿Qué recursos clave requiere nuestra propuesta de valor? ¿Contamos con recursos regenerativos?',
      esCircular: false,
    ),
    BloqueCanvas(
      numero: 7,
      titulo: 'Actividades clave',
      descripcion: 'Las acciones más importantes. En el modelo circular: rediseño del producto y virtualización.',
      preguntaGuia: '¿Qué actividades clave requiere nuestra propuesta de valor? ¿Cómo mejoramos el diseño para los bucles de material?',
      esCircular: false,
    ),
    BloqueCanvas(
      numero: 8,
      titulo: 'Asociaciones clave',
      descripcion: 'La red de socios que hacen funcionar el modelo. En el modelo circular: socios que apoyan la cadena de valor circular.',
      preguntaGuia: '¿Quiénes son nuestros socios clave? ¿Qué alianzas necesitamos para cerrar los ciclos de material?',
      esCircular: false,
    ),
    BloqueCanvas(
      numero: 9,
      titulo: 'Estructura de costos',
      descripcion: 'Todos los costos del modelo. En el modelo circular incluye el valor de los incentivos al cliente.',
      preguntaGuia: '¿Cuáles son los costos más importantes? ¿Hemos incluido el costo de los incentivos para el retorno de productos?',
      esCircular: false,
    ),
    BloqueCanvas(
      numero: 10,
      titulo: 'Sistema take-back',
      descripcion: 'BLOQUE CIRCULAR: El diseño del sistema de gestión de devolución, incluyendo los canales y relaciones con los clientes.',
      preguntaGuia: '¿Cómo recuperamos los productos al final de su vida útil? ¿Qué canales usamos para el retorno?',
      esCircular: true,
    ),
    BloqueCanvas(
      numero: 11,
      titulo: 'Factores de adopción',
      descripcion: 'BLOQUE CIRCULAR: Las capacidades organizacionales y factores externos necesarios para la transición circular.',
      preguntaGuia: '¿Qué capacidades internas necesitamos? ¿Qué factores externos facilitan u obstaculizan la transición circular?',
      esCircular: true,
    ),
  ];
}

List<ItemEvaluacion> obtenerItemsEvaluacion() {
  return [
    ItemEvaluacion(
      bloque: 'Propuesta de valor',
      afirmacionPositiva: 'Nuestra propuesta de valor está en consonancia con las necesidades del cliente',
      afirmacionNegativa: 'La propuesta y las necesidades del cliente no están en consonancia',
      categoria: 'interno',
    ),
    ItemEvaluacion(
      bloque: 'Propuesta de valor',
      afirmacionPositiva: 'Nuestra propuesta de valor tiene un potente efecto de red',
      afirmacionNegativa: 'Nuestra propuesta de valor no tiene efectos de red',
      categoria: 'interno',
    ),
    ItemEvaluacion(
      bloque: 'Fuentes de ingresos',
      afirmacionPositiva: 'Nuestros ingresos son predecibles y recurrentes',
      afirmacionNegativa: 'Nuestros ingresos son impredecibles y transaccionales',
      categoria: 'interno',
    ),
    ItemEvaluacion(
      bloque: 'Fuentes de ingresos',
      afirmacionPositiva: 'Tenemos fuentes de ingresos diversificadas',
      afirmacionNegativa: 'Dependemos de una sola fuente de ingresos',
      categoria: 'interno',
    ),
    ItemEvaluacion(
      bloque: 'Estructura de costos',
      afirmacionPositiva: 'Tenemos márgenes elevados y sostenibles',
      afirmacionNegativa: 'Nuestros márgenes son reducidos e insostenibles',
      categoria: 'interno',
    ),
    ItemEvaluacion(
      bloque: 'Estructura de costos',
      afirmacionPositiva: 'Percibimos ingresos antes de incurrir en gastos',
      afirmacionNegativa: 'Tenemos que incurrir en muchos gastos antes de percibir ingresos',
      categoria: 'interno',
    ),
    ItemEvaluacion(
      bloque: 'Recursos clave',
      afirmacionPositiva: 'Los recursos clave son difíciles de replicar por la competencia',
      afirmacionNegativa: 'Los recursos clave son fáciles de copiar o sustituir',
      categoria: 'interno',
    ),
    ItemEvaluacion(
      bloque: 'Actividades clave',
      afirmacionPositiva: 'Las actividades clave son difíciles de imitar y crean ventaja competitiva',
      afirmacionNegativa: 'Las actividades clave son fáciles de replicar por la competencia',
      categoria: 'interno',
    ),
    ItemEvaluacion(
      bloque: 'Sistema take-back',
      afirmacionPositiva: 'Existe un mecanismo claro y eficiente de recuperación de productos usados',
      afirmacionNegativa: 'No hay un sistema definido de retorno o devolución de productos',
      categoria: 'circular',
    ),
    ItemEvaluacion(
      bloque: 'Sistema take-back',
      afirmacionPositiva: 'Los canales de retorno están integrados con los canales de distribución',
      afirmacionNegativa: 'Los canales de retorno son independientes y costosos de operar',
      categoria: 'circular',
    ),
    ItemEvaluacion(
      bloque: 'Factores de adopción',
      afirmacionPositiva: 'La organización tiene capacidad y cultura para la transición circular',
      afirmacionNegativa: 'Hay resistencia interna al cambio hacia un modelo circular',
      categoria: 'circular',
    ),
    ItemEvaluacion(
      bloque: 'Factores de adopción',
      afirmacionPositiva: 'El entorno regulatorio y de mercado favorece la economía circular',
      afirmacionNegativa: 'El entorno regulatorio dificulta la implementación del modelo circular',
      categoria: 'externo',
    ),
  ];
}

List<String> oportunidadesContexto = [

];

List<String> amenazasContexto = [

];
