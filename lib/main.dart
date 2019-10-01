import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'behaviors/hidden.dart';
import 'mainTabs.dart';
import 'log/login.dart';
import 'package:belcafoodregister/cardaCantidad/CargaId.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:belcafoodregister/listas/ClientesPuestoRegistrados.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
static bool Label= false;


  Widget get _pageToDisplay {
      return Home;
  }

  Widget get Home {
    return  MainTabsPage();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Widget body = _pageToDisplay;
    return MaterialApp(
      title: 'Belca Food Register',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.indigo,
      ),
      home: _pageToDisplay,
    );
  }
}


