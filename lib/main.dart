import 'package:flutter/material.dart';
import 'package:ubicacion/screens/historial.dart';
import 'package:ubicacion/screens/screens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inter rapidisimo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff1a1731)),
        useMaterial3: true,
      ),
      initialRoute: 'home', // Verifica el estado y establece la ruta inicial
        routes: {
          'home': (_) => HomeScreen(),
          'amigos': (_) => AmigosScreen(),
          'historial': (_) => HistorialScreen(),
          'ubimanual': (_) => UbimanualScreen(),
          'ubifoto': (_) => UbiFotoScreen(),
        },
    );
  }
}

