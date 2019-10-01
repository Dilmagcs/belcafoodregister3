import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';


import 'package:belcafoodregister/cardaCantidad/CargaId.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:belcafoodregister/listas/invitadosRegistrados.dart';
import 'package:flutter/services.dart';




class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin{
  int _counter = 0;
  AnimationController _animationControllerx;
  Animation animationx;
  int usersAdd2 = 0;
  String barcode;
  String usersAdd ='0';
  Color colorIcon = Colors.orange;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final databaseReference = FirebaseDatabase.instance.reference();

   void initState() {
    super.initState();
    getIds();
    _animationControllerx =
    AnimationController(duration: Duration(milliseconds:700 ), vsync: this,)..forward();
    animationx = Tween(begin:1.0 , end :200.0).animate(_animationControllerx)
      ..addListener((){
        setState(() {

        });
      });
  }

  int  contadorx = 0;
  String CargaCont = '0';

  void getIds ( ) async {
    print('Verifica --> $contadorx -- ${CargaCont}');
    CargaCont = await cargaId.loadUser(CargaCont);
    print('Recuerda --> $CargaCont');
    contadorx =int.parse(CargaCont);
    setState(() {
      this.contadorx=contadorx   ;
    });
    //getData (contadorx);
  }


  void _incrementCounter() {
    setState(() {

      _counter++;
    });
  }

  AnimationController myAni;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(

        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.account_circle,semanticLabel: 'Usuario',size: animationx.value,color: colorIcon,),
           // AnimatedIcon(Icons.account_circle,semanticLabel: 'Scan',size: animationx.value,),
            Text(
              nombre,
              style: TextStyle(fontSize: 30),
            ),
            Text(
              puesto,
              style: TextStyle(fontSize: 15),
            ),
           Container(height: 25.0,),

          Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          height: 64.0,
          child: RaisedButton(

              color: Colors.indigo[800],

              shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
              textColor: Colors.white,
              splashColor: Colors.blueAccent,
              onPressed: (){
               scan();
              },

              child:   Text('Verificar Cliente',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 4.0,
                ),)
             ),
           )
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Center(
                child: const Text(
                  'Belca Food Show',
                  style: TextStyle(
                    fontSize: 36.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 4.0,
                    /*shadows: [
                    Shadow(
                      blurRadius: 8.0,
                      color: Colors.lightBlueAccent,
                      offset: Offset(3.0, 4.5),
                    ),
                  ],*/
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
            ),
            ListTile(
              title: Text('Lista de Invitados'),
              onTap: () {
                // Update the state of the app                // ...
                // Then close the drawer
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            InvitadosRegistrados(

                            )
                    )
                );
              },
            ),

          ],
        ),
      ),
    );
  }
//Scaneo de datos

  Query Data;
  List data;
  String nombre = 'vacio';
  String empresa = 'vacio';
  String puesto = 'vacio';


  Future convertQr  (barcode)async{
    //data = await json.decode(barcode);
    // print('<<<<<<<<<<<<<<<<<<<<<<<<<' +data[1]["nombre"]);
    //var resBody = await json.decode(barcode);
    //data =  resBody["data"];
   print('ID $barcode');
    ///nombre = data[0]['nombreapellido'];
   ///


    await databaseReference.child('RegistrosIniciales').child('RegiConvert').child(barcode).once().then((DataSnapshot snapshot) {
    print('Data : ${snapshot.value}');
    var data = snapshot.value;
    if(data!=null){
      setState(() {
        nombre = data['NombreCompleto'];
        puesto =  data['Puesto'];
      });

      databaseReference.child('RegistrosFinales').child('BelcaRegistros').child(barcode).set(data);
    }else{
      print('No registrado');
      colorIcon= Colors.red;
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('No registrado'),
        duration: Duration(seconds:10),
        action: SnackBarAction(
          label:'Descartar',
          onPressed:(){
            _scaffoldKey.currentState.hideCurrentSnackBar();
          },
        ),
      ));
    }

});




  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        colorIcon= Colors.green;
        contadorx++;
        print('Scan $contadorx');
        cargaId.GuardaUser(contadorx.toString());
        //this.barcode = barcode;
        convertQr(barcode);
      });

    } on PlatformException catch (e) {


      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'No hay permisos suficientes de la camara';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException{

      setState(() {
        colorIcon= Colors.lightBlue;
        nombre = 'Vacío';
        empresa = 'Vacío';
      //  barcode = "{\"data\":[{\"nombreapellido\":\"vacio\",\"empresa\":\"vacio\",\"puesto\":\"vacio\"}]}";
      });

    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
}
