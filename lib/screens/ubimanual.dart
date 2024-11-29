

import 'package:flutter/material.dart';

class UbimanualScreen extends StatefulWidget {
  const UbimanualScreen({super.key});

  @override
  State<UbimanualScreen> createState() => _UbimanualScreenState();
}

class _UbimanualScreenState extends State<UbimanualScreen> {
  
  @override
  Widget build(BuildContext context) {
    final Size size= MediaQuery.of(context).size;
    return SafeArea(child: 
    Scaffold(
      backgroundColor: Color(0xff1a1731),
      body: Padding(
        padding:EdgeInsets.symmetric(horizontal: 0.05*size.width,vertical: 0.05*size.height),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(onPressed: (){
                  Navigator.pop(context);
                }, icon: Icon(Icons.arrow_back_ios, color: Colors.white,size: 30,)),
                Text('Ubicación manual', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),)
              ],
            )
          ],
        ),
      ),
    )
    );
  }
}