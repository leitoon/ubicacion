import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ubicacion/modelos/amigos.dart';

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
      _latitud = posicion.latitude;
      _longitud = posicion.longitude;
    });
  }

  void _guardarUbicacion(context) {
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

    // Aquí agregarías la validación de radio y guardarías la ubicación
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ubicación guardada correctamente')),
    );
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
                DropdownButton<Amigo>(
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
