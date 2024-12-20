import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubicacion/modelos/amigos.dart';
import '../modelos/ubicacion.dart';

class UbiFotoScreen extends StatefulWidget {
  const UbiFotoScreen({super.key});

  @override
  State<UbiFotoScreen> createState() => _UbiFotoScreenState();
}

class _UbiFotoScreenState extends State<UbiFotoScreen> {
  final List<String> _fotos = []; // Guardará las rutas locales de las fotos.
  double? _latitud;
  double? _longitud;
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();
  Amigo? _amigoSeleccionado;

  @override
  void dispose() {
    // Cancela streams, timers, o listeners aquí.
    super.dispose();
  }

  Future<void> _agregarFoto(context) async {
    if (_fotos.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Solo puedes agregar hasta 3 fotos')),
      );
      return;
    }

    final picker = ImagePicker();
    final XFile? foto =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 50);

    if (foto != null) {
      // Guarda la foto en el almacenamiento local.
      final File fotoGuardada =
          await _guardarFotoEnDispositivo(File(foto.path));
      setState(() {
        _fotos.add(fotoGuardada.path); // Agrega la ruta de la foto a la lista.
      });
    }
  }

  Future<File> _guardarFotoEnDispositivo(File fotoOriginal) async {
    final Directory directorio = await getApplicationDocumentsDirectory();
    final String nuevaRuta = join(directorio.path, basename(fotoOriginal.path));

    // Copia la foto al directorio de documentos.
    return fotoOriginal.copy(nuevaRuta);
  }

  Future<void> _obtenerUbicacionActual(context) async {
    LocationPermission permiso = await Geolocator.checkPermission();

    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
      if (permiso == LocationPermission.denied ||
          permiso == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permiso de ubicación denegado')),
        );
        return;
      }
    }

    final posicion = await Geolocator.getCurrentPosition();
    setState(() {
      if (mounted) {
        // Verifica si el widget está montado
        _latitud = posicion.latitude;
        _longitud = posicion.longitude;
      }
    });
  }

  void _guardarUbicacion(context) async {
    if (_latitud == null ||
        _longitud == null ||
        _tituloController.text.isEmpty ||
        _descripcionController.text.isEmpty ||
        _amigoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final List<String> ubicacionesGuardadas =
        prefs.getStringList('ubicaciones') ?? [];

    final nuevaOrden = 'Orden: ${_tituloController.text}';

    final nuevaUbicacion = Ubicacion(
      titulo: _tituloController.text,
      descripcion: _descripcionController.text,
      latitud: _latitud!,
      longitud: _longitud!,
      fotos: _fotos,
      amigoAsignado:
          '${_amigoSeleccionado!.nombre} ${_amigoSeleccionado!.apellido}',
    );

    // Verifica si la ubicación ya está guardada o está demasiado cerca
    for (var ubicacionJson in ubicacionesGuardadas) {
      final ubicacionGuardada = Ubicacion.fromJson(jsonDecode(ubicacionJson));

      if (nuevaUbicacion.latitud == ubicacionGuardada.latitud &&
          nuevaUbicacion.longitud == ubicacionGuardada.longitud) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Esta ubicación ya está guardada')),
        );
        return;
      }

      final distancia = Ubicacion.calcularDistancia(
        nuevaUbicacion.latitud,
        nuevaUbicacion.longitud,
        ubicacionGuardada.latitud,
        ubicacionGuardada.longitud,
      );

      if (distancia <= 500) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('La ubicación está demasiado cerca a una ya guardada')),
        );
        return;
      }
    }

    // Verifica si el amigo seleccionado ya tiene 5 órdenes asignadas
    final amigoIndex = amigos.indexWhere((amigo) =>
        amigo.nombre == _amigoSeleccionado!.nombre &&
        amigo.apellido == _amigoSeleccionado!.apellido);

    if (amigoIndex != -1) {
      if (amigos[amigoIndex].ordenesAsignadas.length >= 5) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Este amigo ya tiene el máximo de 5 órdenes asignadas')),
        );
        return;
      }

      // Asigna la nueva orden al amigo
      amigos[amigoIndex].ordenesAsignadas.add(nuevaOrden);
    }

    // Guarda la ubicación
    ubicacionesGuardadas.add(jsonEncode(nuevaUbicacion.toJson()));
    await prefs.setStringList('ubicaciones', ubicacionesGuardadas);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ubicación guardada correctamente')),
    );

    setState(() {
      _fotos.clear();
      _latitud = null;
      _longitud = null;
      _tituloController.clear();
      _descripcionController.clear();
      _amigoSeleccionado = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff1a1731),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 0.05 * size.width, vertical: 0.05 * size.height),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const Text(
                      'Ubicación con foto',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onPressed: () {
                    _agregarFoto(context);
                  },
                  child: const Icon(Icons.add_a_photo_outlined),
                ),
                const SizedBox(height: 20),
                Text(
                  'Fotos (${_fotos.length}/3)',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _fotos.map((ruta) {
                    _obtenerUbicacionActual(context);
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(ruta),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    );
                  }).toList(),
                ),
                if (_latitud != null && _longitud != null)
                  Text(
                    'Latitud: $_latitud\nLongitud: $_longitud',
                    style: const TextStyle(color: Colors.white),
                  ),
                const SizedBox(height: 20),
                const Text(
                  'Título:',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                TextField(
                  controller: _tituloController,
                  style: const TextStyle(
                      color: Colors.white), // Estilo del texto ingresado
                  decoration: const InputDecoration(
                    hintText: 'Ingrese el título',
                    hintStyle: TextStyle(
                        color: Colors.grey), // Estilo del texto del hint
                    labelStyle: TextStyle(
                        color: Colors.white), // Estilo de la etiqueta flotante
                    floatingLabelStyle: TextStyle(
                        color: Colors
                            .white), // Estilo de la etiqueta flotante al enfocarse
                    suffixStyle: TextStyle(
                        color: Colors.white), // Estilo del texto del sufijo
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.white), // Color del borde inactivo
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.white), // Color del borde al enfocar
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Descripción:',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                TextField(
                  controller: _descripcionController,
                  maxLines: 3,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Ingrese la descripción',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 0.07 * size.height,
                  child: DropdownButton<Amigo>(
                    value: _amigoSeleccionado,
                    hint: const Text(
                      'Selecciona un amigo',
                      style: TextStyle(color: Colors.white),
                    ),
                    dropdownColor: const Color(0xff1a1731),
                    items: amigos.map((amigo) {
                      return DropdownMenuItem<Amigo>(
                        value:
                            amigo, // Asignamos el objeto Amigo completo como valor.
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  NetworkImage(amigo.foto), // Foto del amigo.
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '${amigo.nombre} ${amigo.apellido}', // Nombre completo.
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (Amigo? nuevoAmigo) {
                      setState(() {
                        _amigoSeleccionado =
                            nuevoAmigo; // Actualizamos el amigo seleccionado.
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _guardarUbicacion(context);
                  },
                  child: const Text('Guardar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
