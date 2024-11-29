import 'dart:math';

class Ubicacion {
  final String titulo;
  final String descripcion;
  final double latitud;
  final double longitud;
  final List<String> fotos; // URLs o rutas locales de las fotos
  final String amigoAsignado;

  Ubicacion({
    required this.titulo,
    required this.descripcion,
    required this.latitud,
    required this.longitud,
    required this.fotos,
    required this.amigoAsignado,
  });

  // Método para calcular la distancia entre dos ubicaciones usando la fórmula de Haversine
  static double calcularDistancia(double lat1, double lon1, double lat2, double lon2) {
    const radioTierra = 6371000; // Radio de la Tierra en metros
    final dLat = _gradosARadianes(lat2 - lat1);
    final dLon = _gradosARadianes(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_gradosARadianes(lat1)) *
            cos(_gradosARadianes(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return radioTierra * c;
  }

  static double _gradosARadianes(double grados) {
    return grados * pi / 180;
  }
}
