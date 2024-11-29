

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size= MediaQuery.of(context).size;
    return SafeArea(child: 
    Scaffold(
      backgroundColor: Color(0xff1a1731),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 0.05*size.width),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                height: 0.2*size.height,
                child: Image.asset('assets/img/logo.png')),
            ),
            SizedBox(
              height: 0.03*size.height,
            ),
            GridView.count(
              crossAxisCount: 2, // Dos columnas
              mainAxisSpacing: 20, // Espacio vertical entre filas
              crossAxisSpacing: 20, // Espacio horizontal entre columnas
              shrinkWrap: true,
              children: [
              Boton(titulo: 'Ubicación con foto', icono: Icons.add_a_photo_outlined, ruta: 'ubifoto',),
              Boton(titulo: 'Ubicación manual', icono: Icons.edit_location_alt_outlined, ruta: 'ubimanual',),
              Boton(titulo: 'Amigos', icono: Icons.person_outlined, ruta: 'amigos',),
              Boton(titulo: 'Historial', icono: Icons.history, ruta: 'historial',)
              ]),
            
          ],
        ),
      ),
    )
    );
  }
}

class Boton extends StatelessWidget {
  const Boton({
    super.key, required this.titulo, required this.icono, required this.ruta,
  });
  final String titulo;
  final IconData icono;
  final String ruta;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      
      onTap: () {
        Navigator.pushReplacementNamed(context, ruta);
      },
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(),
          borderRadius: BorderRadius.circular(10)
        ),
        child:
         Padding(
           padding: const EdgeInsets.all(8.0),
           child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
             children: [
              Icon(icono, color: Color(0xff1a1731),size: 30,),
               Text(titulo,
               style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Color(0xff1a1731)
                ),
                textAlign: TextAlign.center,
                
                ),
             ],
           ),
         )
         ),
    );
  }
}