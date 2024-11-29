

import 'package:flutter/material.dart';
import 'package:ubicacion/modelos/amigos.dart';

class AmigosScreen extends StatelessWidget {
  const AmigosScreen({super.key});

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
                    'Amigos',
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
                child: ListView.builder(
                  itemCount: amigos.length,
                  itemBuilder: (context, index) {
                    final amigo = amigos[index];
                    return Card(
                      color: const Color(0xff252041),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(amigo.foto),
                        ),
                        title: Text(
                          '${amigo.nombre} ${amigo.apellido}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          amigo.email,
                          style: const TextStyle(color: Colors.white70),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.phone, color: Colors.white),
                            const SizedBox(height: 5),
                            Text(
                              amigo.numeroCelular,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          // Acción al tocar un amigo
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(
                                'Órdenes de ${amigo.nombre}',
                                style: const TextStyle(fontSize: 18),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: amigo.ordenesAsignadas
                                    .map((orden) => Text(orden))
                                    .toList(),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cerrar'),
                                ),
                              ],
                            ),
                          );
                        },
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