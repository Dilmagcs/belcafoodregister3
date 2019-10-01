import 'dart:async';
// import 'package:belcafoodregister/main.dart';
import 'dart:convert';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'invitadosRegistrados.dart';
import 'ClientesPuestoRegistrados.dart';
import 'PuestosInvitados.dart';
import 'package:belcafoodregister/cardaCantidad/CargaId.dart';


class Listas extends StatefulWidget {
  @override
  _ScanState createState() => new _ScanState();
}

class _ScanState extends State<Listas>
    with SingleTickerProviderStateMixin{
  String barcode ;
  List data;
  String nombre = 'vacio';
  String empresa = 'vacio';
  String puesto = 'vacio';
  AnimationController _animationControllerx;
  String CargaCont = '0';
  int  contadorx = 0;
  Animation animationx;
/////CargaLista////

  ////////////////
  @override
  initState  ()   {
    //convertQr (barcode);
   // scan();

    getIds ( );
    _animationControllerx =
    AnimationController(duration: Duration(milliseconds:700 ), vsync: this,)..forward();
    animationx = Tween(begin:0.1 , end :150.0).animate(_animationControllerx)
      ..addListener((){
        setState(() {

        });
      });
    super.initState();
  }

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

  void _showDialog(a) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Registrado en"),
          content: new Text(a),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cerrar"),
              onPressed: () {
                getIds ( );
                Navigator.of(context).pop();

              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.indigo,
          title: new Text('Belca Listas', style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            //letterSpacing: 4.0,
          ),),
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(Icons.list,semanticLabel: 'Scan',size: animationx.value,color: Colors.orange),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                height: 64.0,
                child: RaisedButton(

                    color: Colors.indigo[800],

                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    textColor: Colors.white,
                    splashColor: Colors.blueAccent,
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ClientesPuestosRegistrados(

                                  )
                          )
                      );
                    },

                    child:   Text('Mi Puesto',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 4.0,
                      ),)
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                height: 64.0,
                child: RaisedButton(

                    color: Colors.indigo[800],

                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    textColor: Colors.white,
                    splashColor: Colors.blueAccent,
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  InvitadosRegistrados(

                                  )
                          )
                      );
                    },

                    child:   Text('Invitados',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 4.0,
                      ),)
                ),
              ),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                height: 64.0,
                child: RaisedButton(

                    color: Colors.indigo[800],

                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    textColor: Colors.white,
                    splashColor: Colors.blueAccent,
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PuestosInvitados(

                                  )
                          )
                      );
                    },

                    child:   Text('Puestos Activos',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 4.0,
                      ),)
                ),
              ),


            ],
          ),
        ),
      /*floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          scan();

        },
        tooltip: 'Leer QR',
        child: Icon(Icons.camera,semanticLabel: 'Scan',color: Colors.white, size: animationx.value/6.0,),

      ),*/
    );
  }
  Future convertQr  (barcode)async{
   //data = await json.decode(barcode);
 // print('<<<<<<<<<<<<<<<<<<<<<<<<<' +data[1]["nombre"]);
    var resBody = await json.decode(barcode);
    data =  resBody["data"];
    nombre = data[0]['nombreapellido'];
    empresa = data[0]['empresa'];
    puesto = data[0]['puesto'];
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();

      setState(() {

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
        barcode = "{\"data\":[{\"nombreapellido\":\"vacio\",\"empresa\":\"vacio\",\"puesto\":\"vacio\"}]}";
      });

    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
}