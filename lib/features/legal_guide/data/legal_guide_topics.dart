import 'package:calculadora_laboral_mx/features/legal_guide/domain/legal_guide_topic.dart';

const legalGuideTopics = [
  LegalGuideTopic(
    id: 'que-es-finiquito',
    title: '¿Qué es el finiquito?',
    summary:
        'Pago de conceptos pendientes cuando termina una relacion laboral.',
    content:
        'El finiquito es el pago de cantidades ya generadas por la persona '
        'trabajadora al terminar la relacion laboral.\n\n'
        'Suele incluir dias trabajados no pagados, aguinaldo proporcional, '
        'vacaciones proporcionales pendientes y prima vacacional. No depende '
        'necesariamente de que exista despido.',
    category: LegalGuideCategory.basics,
    tags: ['finiquito', 'terminacion', 'pago final'],
  ),
  LegalGuideTopic(
    id: 'que-es-liquidacion',
    title: '¿Qué es la liquidación?',
    summary:
        'Pago que puede incluir indemnizaciones cuando la separacion lo amerita.',
    content:
        'La liquidacion suele referirse al pago que incluye indemnizaciones, '
        'ademas del finiquito, cuando la ley o el caso concreto lo permite.\n\n'
        'Un ejemplo comun es el despido injustificado, donde pueden analizarse '
        'conceptos como indemnizacion constitucional, prima de antiguedad y, '
        'segun el caso, 20 dias por ano.',
    category: LegalGuideCategory.basics,
    tags: ['liquidacion', 'despido', 'indemnizacion'],
  ),
  LegalGuideTopic(
    id: 'diferencia-finiquito-liquidacion',
    title: 'Diferencia entre finiquito y liquidación',
    summary:
        'El finiquito cubre pendientes; la liquidacion puede sumar indemnizacion.',
    content:
        'El finiquito cubre prestaciones y salarios ya generados. La '
        'liquidacion puede incluir esos conceptos y ademas indemnizaciones.\n\n'
        'La diferencia principal esta en la causa de terminacion. Una renuncia '
        'normalmente lleva finiquito. Un despido injustificado puede abrir la '
        'puerta a liquidacion o a una reclamacion.',
    category: LegalGuideCategory.basics,
    tags: ['finiquito', 'liquidacion', 'diferencia'],
  ),
  LegalGuideTopic(
    id: 'que-incluye-finiquito',
    title: '¿Qué incluye el finiquito?',
    summary:
        'Conceptos frecuentes: salario pendiente, aguinaldo, vacaciones y prima.',
    content:
        'El finiquito puede incluir dias trabajados no pagados, aguinaldo '
        'proporcional, vacaciones proporcionales, vacaciones pendientes y prima '
        'vacacional.\n\n'
        'Tambien puede incluir otros adeudos documentados, como bonos, '
        'comisiones o prestaciones pactadas, si aplican en el caso concreto.',
    category: LegalGuideCategory.calculations,
    tags: ['conceptos', 'aguinaldo', 'vacaciones', 'prima vacacional'],
  ),
  LegalGuideTopic(
    id: 'cuando-aplica-liquidacion',
    title: '¿Cuándo aplica la liquidación?',
    summary:
        'Principalmente cuando hay despido injustificado u otra causa reclamable.',
    content:
        'La liquidacion puede aplicar cuando la separacion no fue voluntaria o '
        'cuando existen elementos para reclamar un despido injustificado.\n\n'
        'Cada caso depende de hechos, documentos, fecha de ingreso, salario y '
        'forma en que termino la relacion laboral. Esta app solo orienta, no '
        'decide si una reclamacion procede.',
    category: LegalGuideCategory.laborRights,
    tags: ['despido injustificado', 'liquidacion', 'derechos'],
  ),
  LegalGuideTopic(
    id: 'prima-antiguedad',
    title: '¿Qué es la prima de antigüedad?',
    summary:
        'Prestacion calculada con dias por ano trabajado y salario topado.',
    content:
        'La prima de antiguedad es una prestacion que se calcula con base en '
        '12 dias por ano trabajado, normalmente considerando un salario diario '
        'topado.\n\n'
        'Puede aparecer en escenarios especificos, por ejemplo en ciertos '
        'casos de separacion o reclamacion. Conviene revisar el caso con una '
        'autoridad o asesor laboral.',
    category: LegalGuideCategory.calculations,
    tags: ['prima de antiguedad', 'antiguedad', 'salario topado'],
  ),
  LegalGuideTopic(
    id: 'aguinaldo-proporcional',
    title: '¿Qué es el aguinaldo proporcional?',
    summary:
        'Parte del aguinaldo generada segun los dias trabajados en el ano.',
    content:
        'El aguinaldo proporcional es la parte del aguinaldo anual que se '
        'genera por el tiempo trabajado durante el ano.\n\n'
        'Si la relacion termina antes de cerrar el ano, suele calcularse con '
        'el salario diario, los dias de aguinaldo pactados o legales, y la '
        'proporcion del ano trabajado.',
    category: LegalGuideCategory.calculations,
    tags: ['aguinaldo', 'proporcional', 'ano actual'],
  ),
  LegalGuideTopic(
    id: 'vacaciones-proporcionales',
    title: '¿Qué son las vacaciones proporcionales?',
    summary:
        'Vacaciones generadas segun antiguedad y tiempo trabajado del periodo.',
    content:
        'Las vacaciones proporcionales son los dias de vacaciones generados '
        'durante el periodo laboral, aunque no se haya completado todo el ano '
        'de servicio.\n\n'
        'La base depende de la antiguedad y de la tabla de vacaciones vigente. '
        'El calculo estimado usa la proporcion del periodo trabajado.',
    category: LegalGuideCategory.calculations,
    tags: ['vacaciones', 'proporcional', 'antiguedad'],
  ),
  LegalGuideTopic(
    id: 'prima-vacacional',
    title: '¿Qué es la prima vacacional?',
    summary: 'Pago adicional sobre vacaciones, comunmente calculado con 25%.',
    content:
        'La prima vacacional es un pago adicional relacionado con las '
        'vacaciones. En muchos calculos se usa como base minima el 25% sobre '
        'el importe de vacaciones.\n\n'
        'Si el contrato o politica interna mejora ese porcentaje, debe '
        'considerarse el dato aplicable al caso.',
    category: LegalGuideCategory.calculations,
    tags: ['prima vacacional', 'vacaciones', '25%'],
  ),
  LegalGuideTopic(
    id: 'si-no-me-quieren-pagar',
    title: '¿Qué hacer si no me quieren pagar?',
    summary:
        'Documenta el caso, evita firmar sin entender y busca orientacion.',
    content:
        'Si no quieren pagarte, conserva mensajes, recibos, contrato, '
        'identificaciones laborales y cualquier evidencia de salario y fechas.\n\n'
        'Evita firmar documentos si no entiendes su alcance. Puedes pedir una '
        'explicacion por escrito y buscar orientacion antes de aceptar una '
        'cantidad o renuncia.',
    category: LegalGuideCategory.whatToDo,
    tags: ['no pago', 'evidencia', 'conciliacion'],
  ),
  LegalGuideTopic(
    id: 'donde-acudir-asesoria',
    title: '¿Dónde acudir por asesoría laboral?',
    summary: 'Opciones habituales: PROFEDET y Centros de Conciliacion.',
    content:
        'Puedes buscar orientacion en PROFEDET, en el Centro de Conciliacion '
        'correspondiente o con una persona abogada laboral.\n\n'
        'La institucion aplicable puede depender de tu localidad, tipo de '
        'empleador y etapa del conflicto. Esta app no sustituye esos servicios.',
    category: LegalGuideCategory.institutions,
    tags: ['PROFEDET', 'conciliacion', 'asesoria'],
  ),
  LegalGuideTopic(
    id: 'documentos-conservar',
    title: 'Documentos que conviene conservar',
    summary:
        'Recibos, contrato, mensajes, identificaciones y evidencia de pagos.',
    content:
        'Conviene conservar contrato, recibos de nomina, estados de cuenta, '
        'mensajes, correos, gafetes, cartas, controles de asistencia y datos '
        'de contacto de la empresa.\n\n'
        'Tambien ayuda guardar evidencia de salario real, fecha de ingreso, '
        'puesto, horario y cualquier oferta de pago.',
    category: LegalGuideCategory.whatToDo,
    tags: ['documentos', 'recibos', 'evidencia'],
  ),
  LegalGuideTopic(
    id: 'salario-diario-vs-sdi',
    title: 'Diferencia entre salario diario y salario diario integrado',
    summary:
        'El salario diario paga prestaciones; el integrado suma conceptos para indemnizar.',
    content:
        'El salario diario suele obtenerse dividiendo el salario mensual entre '
        '30 y se usa para varios conceptos proporcionales.\n\n'
        'El salario diario integrado puede incluir prestaciones adicionales y '
        'se usa como referencia en ciertos calculos indemnizatorios. Si no lo '
        'conoces, la app puede estimar usando salario diario.',
    category: LegalGuideCategory.calculations,
    tags: ['salario diario', 'sdi', 'indemnizacion'],
  ),
];
