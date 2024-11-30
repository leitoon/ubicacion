class Amigo {
  final String nombre;
  final String apellido;
  final String email;
  final String numeroCelular;
  final String foto; // URL de la imagen o ruta local
  final List<String> ordenesAsignadas;

  Amigo({
    required this.nombre,
    required this.apellido,
    required this.email,
    required this.numeroCelular,
    required this.foto,
    required this.ordenesAsignadas,
  });

  void agregarOrden(String orden) {
    ordenesAsignadas.add(orden);
  }
}


final List<Amigo> amigos = [
  Amigo(
    nombre: 'Juan',
    apellido: 'Pérez',
    email: 'juan.perez@example.com',
    numeroCelular: '+573001234567',
    foto: 'https://via.placeholder.com/150',
    ordenesAsignadas: [],
  ),
  Amigo(
    nombre: 'Ana',
    apellido: 'García',
    email: 'ana.garcia@example.com',
    numeroCelular: '+573005678901',
    foto: 'https://via.placeholder.com/150',
    ordenesAsignadas: [],
  ),
  Amigo(
    nombre: 'Carlos',
    apellido: 'López',
    email: 'carlos.lopez@example.com',
    numeroCelular: '+573002345678',
    foto: 'https://via.placeholder.com/150',
    ordenesAsignadas: [],
  ),
  Amigo(
    nombre: 'Jorge',
    apellido: 'López',
    email: 'jorge@example.com',
    numeroCelular: '+57300235678',
    foto: 'https://via.placeholder.com/150',
    ordenesAsignadas: [],
  ),
  Amigo(
    nombre: 'Luis',
    apellido: 'López',
    email: 'luis@example.com',
    numeroCelular: '+573002341234',
    foto: 'https://via.placeholder.com/150',
    ordenesAsignadas: [],
  ),
];
