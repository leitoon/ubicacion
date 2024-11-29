

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
        padding:  EdgeInsets.symmetric(vertical: 0.05*size.height),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                height: 0.2*size.height,
                child: Image.asset('assets/img/logo.png')),
            ),
            SizedBox(
              height: 0.03*size.height,
            ),
            Boton(),
            
          ],
        ),
      ),
    )
    );
  }
}

class Boton extends StatelessWidget {
  const Boton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      
      onTap: () {
        
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
              Icon(Icons.camera_alt_sharp,color: Color(0xff1a1731),),
               Text('Ubicación con foto',
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