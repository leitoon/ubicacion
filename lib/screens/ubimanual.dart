import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubicacion/modelos/ubicacion.dart';

import '../modelos/amigos.dart';

class UbimanualScreen extends StatefulWidget {
  const UbimanualScreen({super.key});

  @override
  State<UbimanualScreen> createState() => _UbimanualScreenState();
}

class _UbimanualScreenState extends State<UbimanualScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _latitudController = TextEditingController();
  final TextEditingController _longitudController = TextEditingController();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  Amigo? _amigoSeleccionado;

  void _guardarUbicacionManual() async {
    if (_formKey.currentState!.validate()) {
      final double? latitud = double.tryParse(_latitudController.text);
      final double? longitud = double.tryParse(_longitudController.text);
      final nuevaOrden = 'Orden: ${_tituloController.text}';

      if (latitud == null || longitud == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Latitud y Longitud deben ser números válidos')),
        );
        return;
      }

      if (_amigoSeleccionado != null) {
        // Verifica si el amigo seleccionado tiene 5 o más órdenes
        if (_amigoSeleccionado!.ordenesAsignadas.length >= 5) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Este amigo ya tiene el máximo de 5 órdenes asignadas')),
          );
          return;
        }

        final nuevaUbicacion = Ubicacion(
          titulo: _tituloController.text,
          descripcion: _descripcionController.text,
          amigoAsignado:
              '${_amigoSeleccionado!.nombre} ${_amigoSeleccionado!.apellido}',
          latitud: latitud,
          longitud: longitud,
          fotos: [],
        );

        // Guardar en SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        final ubicacionesGuardadas = prefs.getStringList('ubicaciones') ?? [];
        ubicacionesGuardadas.add(jsonEncode(nuevaUbicacion.toJson()));
        await prefs.setStringList('ubicaciones', ubicacionesGuardadas);

        // Asigna la orden al amigo seleccionado
        final amigoIndex = amigos.indexWhere((amigo) =>
            amigo.nombre == _amigoSeleccionado!.nombre &&
            amigo.apellido == _amigoSeleccionado!.apellido);

        if (amigoIndex != -1) {
          amigos[amigoIndex].ordenesAsignadas.add(nuevaOrden);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ubicación guardada correctamente')),
        );

        _formKey.currentState!.reset();
        setState(() {
          _amigoSeleccionado = null;
          _tituloController.clear();
          _latitudController.clear();
          _longitudController.clear();
          _descripcionController.clear();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor selecciona un amigo')),
        );
      }
    }
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
                      'Ubicación manual',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        controller: _latitudController,
                        decoration: const InputDecoration(
                          labelText: 'Latitud',
                          labelStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white24,
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa una latitud';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        controller: _longitudController,
                        decoration: const InputDecoration(
                          labelText: 'Longitud',
                          labelStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white24,
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa una longitud';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        controller: _tituloController,
                        decoration: const InputDecoration(
                          labelText: 'Título',
                          labelStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white24,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa un título';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        controller: _descripcionController,
                        decoration: const InputDecoration(
                          labelText: 'Descripción',
                          labelStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white24,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa una descripción';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<Amigo>(
                        value: _amigoSeleccionado,
                        dropdownColor: Color(0xff1a1731),
                        decoration: const InputDecoration(
                          labelText: 'Asignar a',
                          labelStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white24,
                        ),
                        items: amigos
                            .map((amigo) => DropdownMenuItem<Amigo>(
                                  value: amigo,
                                  child: Text(
                                    '${amigo.nombre} ${amigo.apellido}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ))
                            .toList(),
                        onChanged: (amigo) {
                          setState(() {
                            _amigoSeleccionado = amigo;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Por favor selecciona un amigo';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _guardarUbicacionManual,
                        child: const Text('Guardar Ubicación'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
