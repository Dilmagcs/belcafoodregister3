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

class ClientesPuestosRegistrados extends StatefulWidget {
  @override
  _ScanState createState() => new _ScanState();
}

class _ScanState extends State<ClientesPuestosRegistrados>
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
  String puestoSeleccionado;



  final List<int> colorCodes = <int>[600, 500, 100];
  final List<String> entries = <String>['Tapita', 'Dos Pinos', 'Cafe 1820'];

  @override
  initState  ()   {
    //convertQr (barcode);
   // scan();
    CargaPuesto();
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

  ///Carga Nombre Comercial
  CargaPuesto  () async{
    print('Carga ID $puestoSeleccionado');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    puestoSeleccionado = (prefs.getString('Puestos') ?? '0');
    return puestoSeleccionado;
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
var contador =0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.indigo,
          title: new Text('Invitados', style: TextStyle(
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
                    .reference().child("Puestos").child(puestoSeleccionado).child('Registrados'),

                padding: new EdgeInsets.all(8.0),
                reverse: false,
                itemBuilder: (_, DataSnapshot snapshot,
                    Animation<double> animation, int x) {
                 // contador++;
                  var  data = snapshot.value;
                  nombre = data['NombreCompleto'];
                  puesto = data['Puesto'];
                  try {
                    empresa = data['NombreDeEmpresa'];
                  }catch(e){
                    empresa="noAplico";
                  }

                  x=x+1;
                  return  Column(
                    children: <Widget>[
                      ListTile(
                        leading:   Icon(
                          Icons.account_circle,
                          color: Colors.green,
                          size: 24.0,
                          semanticLabel: 'Invitados',
                        ),
                        title: new Text('$x - ${nombre.toString()}'),
                        subtitle: new Text('Empresa  ${empresa.toString()}'),
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