import 'dart:async';
// import 'package:belcafoodregister/main.dart';
import 'dart:convert';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:belcafoodregister/cardaCantidad/CargaId.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class PuestosInvitados extends StatefulWidget {
  @override
  _ScanState createState() => new _ScanState();
}

class _ScanState extends State<PuestosInvitados>
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
  final List<String> entries = <String>['Tapita', 'Dos Pinos', 'Cafe 1820'];

  @override
  initState  ()   {
    //convertQr (barcode);
   // scan();

    getIds ( );
    _animationControllerx =
    AnimationController(duration: Duration(milliseconds:700 ), vsync: this,)..forward();
    animationx = Tween(begin:0.1 , end :200.0).animate(_animationControllerx)
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
          title: new Text('Puestos Activos', style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            //letterSpacing: 4.0,
          ),),
        ),
      body: new Column(
        children: <Widget>[
          new Flexible(
            child: new FirebaseAnimatedList(
                query: FirebaseDatabase.instance
                    .reference().child('Puestos'),

                padding: new EdgeInsets.all(8.0),
                reverse: false,
                itemBuilder: (_, DataSnapshot snapshot,
                    Animation<double> animation, int x) {
                  var  key = snapshot.key;
                  var  data = snapshot.value;
                  var count = data['Registrados'].length;
                  x=x+1;
                  return  Column(
                    children: <Widget>[
                      ListTile(
                        leading:   Icon(
                          Icons.store,
                          color: Colors.green,
                          size: 24.0,
                          semanticLabel: 'Invitados',
                        ),
                        title: new Text('$x - ${snapshot.key.toString()}'),
                        subtitle: new Text('Registrados ${count.toString()}'),
                      ),
                      new Divider(
                        height: 2.0,
                      ),
                    ],
                  );


                }
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          Navigator.pop(context);

        },
        tooltip: 'Leer QR',
        child: Icon(Icons.keyboard_backspace,semanticLabel: 'Scan',color: Colors.white, size: animationx.value/6.0,),

      ),
    );
  }

}