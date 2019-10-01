import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:firebase_database/firebase_database.dart';

class cargaId {

 // final databaseReference = FirebaseDatabase.instance.reference();
  String contadorxy = '0';



  static loadUser(contadorxy) async {
    print("1.CargaIDInstance data" + contadorxy);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    contadorxy = (prefs.getString('contadorxy') ?? '0');

  if (contadorxy == '0')  {
        print('1.Solicita'+contadorxy);

        return contadorxy = await idUser(contadorxy);

      } else {
        contadorxy = (prefs.getString('contadorxy') ?? '0');
        print("2.RecuerdaIDInstance" + contadorxy);

        return contadorxy;
      }
  }

  static idUser(contadorxy) async {
    //FirebaseUser user = await FirebaseAuth.instance.currentUser();
     // contadorxy =contadorxy.toString();
      print('2.Solicita ' + contadorxy);
      GuardaUser(contadorxy);
    return contadorxy;
  }

 static GuardaUser(contadorxy) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      print('Guarda ID $contadorxy');
      prefs.setString('contadorxy', contadorxy);
    return contadorxy;
  }

 // cargaId({this.contadorxy});

}