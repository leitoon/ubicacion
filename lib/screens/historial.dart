import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../modelos/ubicacion.dart';

class HistorialScreen extends StatefulWidget {
  const HistorialScreen({super.key});

  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  List<Ubicacion> _ubicaciones = [];

  @override
  void initState() {
    super.initState();
    _cargarHistorial();
  }

  Future<void> _cargarHistorial() async {
    final prefs = await SharedPreferences.getInstance();
    final ubicacionesGuardadas = prefs.getStringList('ubicaciones') ?? [];

    setState(() {
      _ubicaciones = ubicacionesGuardadas
          .map((jsonString) => Ubicacion.fromJson(jsonDecode(jsonString)))
          .toList();
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
            horizontal: 0.05 * size.width,
            vertical: 0.05 * size.height,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios,
                        color: Colors.white, size: 30),
                  ),
                  const Text(
                    'Historial',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _ubicaciones.isEmpty
                    ? const Center(
                        child: Text(
                          'No hay ubicaciones guardadas',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _ubicaciones.length,
                        itemBuilder: (context, index) {
                          final ubicacion = _ubicaciones[index];
                          return Card(
                            color: const Color(0xff252041),
                            child: ListTile(
                              title: Text(
                                ubicacion.titulo,
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                '${ubicacion.descripcion}\nAmigo: ${ubicacion.amigoAsignado}\nLat: ${ubicacion.latitud}, Long: ${ubicacion.longitud}',
                                style: const TextStyle(color: Colors.white70),
                              ),
                              isThreeLine: true,
                              leading: ubicacion.fotos.isNotEmpty
                                  ? Image.file(
                                      File(ubicacion.fotos.first),
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
