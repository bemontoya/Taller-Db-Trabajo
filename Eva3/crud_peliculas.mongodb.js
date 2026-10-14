// =============================================================================
// DUOC UC - SEDE PUERTO MONTT
// ESCUELA DE INFORMÁTICA Y TELECOMUNICACIONES
// ASIGNATURA: BDY1103 Taller de Base de Datos
// EVALUACIÓN SUMATIVA 3: MODELADO Y OPERACIONES CRUD EN MONGODB
//
// ARCHIVO: crud_peliculas.mongodb.js
// DESCRIPCIÓN: Ciclo completo de operaciones CRUD para documentos tipo 'pelicula'.
//              Demuestra la flexibilidad polimórfica en MongoDB: en películas,
//              los atributos técnicos ('duracion_min' y 'video_url') se alojan
//              directamente en la raíz del documento, prescindiendo del arreglo
//              'temporadas' sin necesidad de tablas separadas ni columnas NULL.
// =============================================================================

// -----------------------------------------------------------------------------
// 0. CONEXIÓN Y SELECCIÓN DE BASE DE DATOS
// -----------------------------------------------------------------------------
use('streaming_platform');

// -----------------------------------------------------------------------------
// 1. CREATE (Crear un registro de largometraje con atributos directos)
// -----------------------------------------------------------------------------
// Objetivo: Insertar la película 'Dune: Parte Dos' (2024) en la colección 'contenidos'.
// Observación técnica: Al tratarse de un largometraje, 'duracion_min' y 'video_url'
// residen en el primer nivel del documento BSON. No se incluye el arreglo
// 'temporadas', lo que ahorra almacenamiento y simplifica las consultas.
db.contenidos.insertOne({
  titulo: 'Dune: Parte Dos',
  tipo: 'pelicula',
  anio_lanzamiento: NumberInt('2024'),
  clasificacion: '+13',
  sinopsis: 'Paul Atreides se une a Chani y a los Fremen mientras busca venganza contra los conspiradores que destruyeron a su familia.',
  generos: [
    'Ciencia Ficción',
    'Aventura',
    'Acción'
  ],
  calidad_maxima: '4K IMAX Enhanced',
  disponible: true,
  duracion_min: NumberInt('166'),
  video_url: 'https://cdn.hbo.com/movies/dune2_4k.mp4',
  fecha_agregado: ISODate('2024-04-10T00:00:00.000Z'),
  reparto: [
    {
      actor: 'Timothée Chalamet',
      personaje: 'Paul Atreides'
    },
    {
      actor: 'Zendaya',
      personaje: 'Chani'
    },
    {
      actor: 'Rebecca Ferguson',
      personaje: 'Lady Jessica'
    }
  ],
  idiomas: {
    audio: [
      'Español Latino',
      'Inglés (Dolby Atmos)',
      'Francés'
    ],
    subtitulos: [
      'Español',
      'Inglés',
      'Francés'
    ]
  }
});

// -----------------------------------------------------------------------------
// 2. READ (Consultar películas con filtros de rango y proyección plana)
// -----------------------------------------------------------------------------
// Objetivo: Buscar películas disponibles del género 'Ciencia Ficción' cuya duración
// sea mayor o igual a 150 minutos ($gte) y cuenten con la participación de 'Zendaya'.
// Se proyectan campos técnicos de primer nivel y pistas de audio disponibles.
db.contenidos.find(
  {
    tipo: 'pelicula',
    disponible: true,
    generos: 'Ciencia Ficción',
    duracion_min: { $gte: NumberInt('150') },
    'reparto.actor': 'Zendaya'
  },
  {
    _id: 0,
    titulo: 1,
    anio_lanzamiento: 1,
    duracion_min: 1,
    calidad_maxima: 1,
    'idiomas.audio': 1
  }
);

// Consulta adicional (Filtro por calidad técnica y audio inmersivo):
// Recupera películas disponibles con resolución 4K y soporte Dolby Atmos
db.contenidos.find(
  {
    tipo: 'pelicula',
    calidad_maxima: /4K/i,
    'idiomas.audio': 'Inglés (Dolby Atmos)'
  },
  {
    _id: 0,
    titulo: 1,
    calidad_maxima: 1,
    'idiomas.audio': 1,
    video_url: 1
  }
);

// -----------------------------------------------------------------------------
// 3. UPDATE (Actualizar atributos de raíz y colecciones de idiomas)
// -----------------------------------------------------------------------------
// Objetivo:
// a) Mejorar el estándar de calidad de video a '4K IMAX Enhanced (Dolby Vision)' mediante $set.
// b) Incorporar el idioma 'Italiano' al arreglo de subtítulos mediante $addToSet,
//    garantizando que no se duplique si la pista ya existiera.
// Observación técnica: En películas no se requiere el operador posicional '$'
// porque no hay un arreglo anidado de temporadas/episodios.
db.contenidos.updateOne(
  {
    titulo: 'Dune: Parte Dos',
    tipo: 'pelicula',
    anio_lanzamiento: NumberInt('2024')
  },
  {
    $set: {
      calidad_maxima: '4K IMAX Enhanced (Dolby Vision)'
    },
    $addToSet: {
      'idiomas.subtitulos': 'Italiano'
    }
  }
);

// Consulta de verificación del UPDATE:
db.contenidos.find(
  { titulo: 'Dune: Parte Dos' },
  {
    _id: 0,
    titulo: 1,
    calidad_maxima: 1,
    'idiomas.subtitulos': 1
  }
);

// -----------------------------------------------------------------------------
// 4. DELETE (Eliminación controlada de réplicas temporales)
// -----------------------------------------------------------------------------
// Paso 4.1: Insertar un registro temporal (ej. copia de prelanzamiento en CDN de pruebas)
db.contenidos.insertOne({
  titulo: 'Dune: Parte Dos - Copia Staging CDN',
  tipo: 'pelicula',
  anio_lanzamiento: NumberInt('2024'),
  duracion_min: NumberInt('166'),
  video_url: 'https://staging-cdn.hbo.com/movies/dune2_preview.mp4',
  disponible: false,
  fecha_agregado: ISODate('2026-11-24T00:00:00.000Z')
});

// Paso 4.2: Ejecutar la eliminación del registro temporal con deleteOne
db.contenidos.deleteOne({
  titulo: 'Dune: Parte Dos - Copia Staging CDN'
});

// Paso 4.3: Validar que el registro temporal fue removido exitosamente
db.contenidos.countDocuments({
  titulo: 'Dune: Parte Dos - Copia Staging CDN'
});

// Nota arquitectónica: Para baja lógica en el catálogo comercial:
// db.contenidos.updateOne(
//   { titulo: 'Dune: Parte Dos' },
//   { $set: { disponible: false, fecha_baja: new Date() } }
// );
