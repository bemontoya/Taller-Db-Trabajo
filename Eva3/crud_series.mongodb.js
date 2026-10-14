// =============================================================================
// DUOC UC - SEDE PUERTO MONTT
// ESCUELA DE INFORMÁTICA Y TELECOMUNICACIONES
// ASIGNATURA: BDY1103 Taller de Base de Datos
// EVALUACIÓN SUMATIVA 3: MODELADO Y OPERACIONES CRUD EN MONGODB
//
// ARCHIVO: crud_series.mongodb.js
// DESCRIPCIÓN: Ciclo completo de operaciones CRUD para documentos tipo 'serie'.
//              Demuestra la jerarquía multinivel (documento -> temporadas -> episodios)
//              y la manipulación de arreglos embebidos con operadores posicionales.
// =============================================================================

// -----------------------------------------------------------------------------
// 0. CONEXIÓN Y SELECCIÓN DE BASE DE DATOS
// -----------------------------------------------------------------------------
use('streaming_platform');

// -----------------------------------------------------------------------------
// 1. CREATE (Crear un registro de serie con estructura jerárquica)
// -----------------------------------------------------------------------------
// Objetivo: Insertar la serie 'Berserk' (1997) con su jerarquía completa de
// temporadas, episodios, elenco e idiomas en una sola operación atómica.
// Nota: Se omite intencionalmente el atributo '_id' para que MongoDB genere
// automáticamente un identificador único de tipo ObjectId.
db.contenidos.insertOne({
  titulo: 'Berserk',
  tipo: 'serie',
  anio_lanzamiento: NumberInt('1997'),
  clasificacion: '+18',
  sinopsis: 'Guts, un solitario mercenario que blande una espada colosal, se une a la Banda del Halcón liderada por el carismático Griffith, forjando un destino marcado por la ambición y la traición.',
  generos: [
    'Animación',
    'Fantasía Oscura',
    'Acción',
    'Drama'
  ],
  calidad_maxima: '1080p Full HD',
  disponible: true,
  fecha_agregado: ISODate('2026-11-10T00:00:00.000Z'),
  reparto: [
    {
      actor: 'Nobutoshi Canna',
      personaje: 'Guts'
    },
    {
      actor: 'Toshiyuki Morikawa',
      personaje: 'Griffith'
    },
    {
      actor: 'Yūko Miyamura',
      personaje: 'Casca'
    }
  ],
  idiomas: {
    audio: [
      'Japonés (Original)',
      'Español Latino',
      'Inglés'
    ],
    subtitulos: [
      'Español',
      'Inglés',
      'Portugués'
    ]
  },
  temporadas: [
    {
      temporada: NumberInt('1'),
      anio: NumberInt('1997'),
      episodios: [
        {
          num: NumberInt('1'),
          titulo: 'El Caballero Negro',
          duracion_min: NumberInt('25'),
          video_url: 'https://cdn.stream.com/berserk/s01e01.mp4'
        },
        {
          num: NumberInt('2'),
          titulo: 'La Banda del Halcón',
          duracion_min: NumberInt('25'),
          video_url: 'https://cdn.stream.com/berserk/s01e02.mp4'
        },
        {
          num: NumberInt('3'),
          titulo: 'Bautismo de fuego',
          duracion_min: NumberInt('25'),
          video_url: 'https://cdn.stream.com/berserk/s01e03.mp4'
        }
      ]
    }
  ]
});

// -----------------------------------------------------------------------------
// 2. READ (Consultar series con filtros anidados y proyección selectiva)
// -----------------------------------------------------------------------------
// Objetivo: Recuperar series disponibles del género 'Fantasía Oscura' donde
// participe el actor 'Nobutoshi Canna'. Se proyectan únicamente los campos
// necesarios para la interfaz de reproducción, omitiendo el '_id' explícitamente.
db.contenidos.find(
  {
    tipo: 'serie',
    disponible: true,
    generos: 'Fantasía Oscura',
    'reparto.actor': 'Nobutoshi Canna'
  },
  {
    _id: 0,
    titulo: 1,
    anio_lanzamiento: 1,
    calidad_maxima: 1,
    'temporadas.temporada': 1,
    'temporadas.episodios.num': 1,
    'temporadas.episodios.titulo': 1
  }
);

// -----------------------------------------------------------------------------
// 3. UPDATE (Actualizar arreglos multinivel y evitar duplicados)
// -----------------------------------------------------------------------------
// Objetivo:
// a) Añadir el Episodio 4 a la Temporada 1 usando el operador posicional '$'.
//    El filtro 'temporadas.temporada': NumberInt('1') ubica el índice exacto en el arreglo.
// b) Agregar 'Francés' a los subtítulos con '$addToSet' para asegurar unicidad (sin duplicados).
db.contenidos.updateOne(
  {
    titulo: 'Berserk',
    tipo: 'serie',
    anio_lanzamiento: NumberInt('1997'),
    'temporadas.temporada': NumberInt('1')
  },
  {
    $push: {
      'temporadas.$.episodios': {
        num: NumberInt('4'),
        titulo: 'La mano de Dios',
        duracion_min: NumberInt('25'),
        video_url: 'https://cdn.stream.com/berserk/s01e04.mp4'
      }
    },
    $addToSet: {
      'idiomas.subtitulos': 'Francés'
    }
  }
);

// Consulta de verificación del UPDATE:
db.contenidos.find(
  { titulo: 'Berserk' },
  {
    _id: 0,
    titulo: 1,
    'idiomas.subtitulos': 1,
    'temporadas.episodios': 1
  }
);

// -----------------------------------------------------------------------------
// 4. DELETE (Eliminación controlada de registros de prueba)
// -----------------------------------------------------------------------------
// Paso 4.1: Insertar un registro temporal para validar la operación de borrado
// sin comprometer la integridad de la serie principal del catálogo.
db.contenidos.insertOne({
  titulo: 'Berserk - Especial Recopilatorio (Prueba)',
  tipo: 'cortometraje',
  anio_lanzamiento: NumberInt('1997'),
  disponible: false,
  fecha_agregado: ISODate('2026-11-24T00:00:00.000Z')
});

// Paso 4.2: Ejecutar la eliminación física con deleteOne
db.contenidos.deleteOne({
  titulo: 'Berserk - Especial Recopilatorio (Prueba)'
});

// Paso 4.3: Comprobar que el registro ya no existe (debe retornar 0)
db.contenidos.countDocuments({
  titulo: 'Berserk - Especial Recopilatorio (Prueba)'
});

// Nota arquitectónica sobre Borrado Lógico en Producción:
// En plataformas reales de streaming, suele preferirse la baja lógica para
// preservar el historial de visualización y métricas de usuario:
// db.contenidos.updateOne(
//   { titulo: 'Berserk' },
//   { $set: { disponible: false, fecha_baja: new Date() } }
// );
