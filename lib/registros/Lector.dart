import 'dart:async';
// import 'package:belcafoodregister/main.dart';
import 'dart:convert';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:belcafoodregister/cardaCantidad/CargaId.dart';
import 'package:intl/intl.dart';
import 'package:belcafoodregister/listas/ClientesPuestoRegistrados.dart';


class Lector extends StatefulWidget {
  @override
  _ScanState createState() => new _ScanState();
}

class _ScanState extends State<Lector>
    with SingleTickerProviderStateMixin{
  String barcode ;
  List data;
  String nombre = 'vacio';
  String empresa = 'vacio';
  String puesto = 'vacio';
  bool PuestoReg = false;
  AnimationController _animationControllerx;
  String CargaCont = '0';
  int  contadorx = 0;
  Animation animationx;
  String puestoSeleccionado;
  String cedula;
  String pass;
  Color colorIcon = Colors.orange;
  String SaliVal;


  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  final databaseReference = FirebaseDatabase.instance.reference();

  @override
  initState  ()   {
    //convertQr (barcode);
   // scan();
    CargaPuesto  ();
    getIds ( );
    nombre = 'Pulsa el botón verde para continuar';
    puesto =  'Belca Food Registro';
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
//Renders


  Widget get _pageToDisplay {
    if(PuestoReg==false){
      return PuestoRegis;
    }else{
      return LectorPuesto;
    }

  }

  final myController = TextEditingController();
  final myController2 = TextEditingController();
  final myController3 = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController3.dispose();
    myController2.dispose();
    myController.dispose();
    super.dispose();
  }

  Registro() async {

    if (myController2.text=='1234A'){
      GuardaPuesto(puestoSeleccionado);

      setState(() {
        PuestoReg = true;

      });
      puestoSeleccionado= await CargaPuesto  ();
    }else{
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Constraseña Incorrecta'),
        duration: Duration(seconds:10),
        action: SnackBarAction(
          label:'Descartar',
          onPressed:(){
            _scaffoldKey.currentState.hideCurrentSnackBar();
          },
        ),
      ));

    }

  }

  ///Guarda Nombre Comercial
  GuardaPuesto(puestoSeleccionado) async {
    puestoSeleccionado = myController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('Guarda ID $puestoSeleccionado');

    prefs.setString('Puestos', puestoSeleccionado);
    return puestoSeleccionado;
  }

  ///Carga Nombre Comercial
  CargaPuesto  () async {
    print('Carga ID ->>>$puestoSeleccionado');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    puestoSeleccionado = (prefs.getString('Puestos') ?? '0');
    if(puestoSeleccionado!='0') {
      setState(() {
        PuestoReg = true;
      });

    }
    return puestoSeleccionado;
  }

  SalirValida(){

    if(myController3.text=="dilmag"){
      Navigator.of(context).pop();
      setState(() {
        PuestoReg = false;
      });
      setState(() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        print('Guarda ID $puestoSeleccionado');
        prefs.setString('Puestos', '0');
      });
    }

  }

  Future<void> _neverSatisfied() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Validador'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Ingresa constraseña para quitar el puesto'),
                TextFormField(
                  controller: myController3,
                  obscureText: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: 'Contraseña'),
                  validator: (val){
                    if (val.isEmpty){
                      return 'Introduce la contraseña del admi';
                    }else{
                      return null;
                    }
                  },
                  onSaved: (val){
                    setState((){
                      //SaliVal = val;
                      //print(puestoSeleccionado);
                    });
                  },

                ),
               // Text('You\’re like me. I’m never satisfied.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Aceptar'),
              onPressed: () {
              SalirValida();
              },
            ),
            FlatButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  Widget get LectorPuesto {
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        backgroundColor: Colors.indigo,
        title: new Text('Puesto $puestoSeleccionado', style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          //letterSpacing: 4.0,
        ),),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Icon(Icons.store,semanticLabel: 'Scan',size: animationx.value,color: colorIcon,),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text('$nombre', textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    letterSpacing: 4.0,
                  )),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text('Empresa: '+ empresa +' Puesto: '+ puesto, textAlign: TextAlign.center,),
            )
            ,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              height: 64.0,
              child: RaisedButton(

                  color: Colors.green,

                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),

                  splashColor: Colors.redAccent,
                  onPressed: (){
                    // _showDialog(puesto);
                    scan();
                  },

                  child:   Text('Registrar Invitado #$contadorx',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 4.0,
                    ),)
              ),
            ),
           /* Container(
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

                  child:   Text('Autenticar Puesto',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 4.0,
                    ),)
              ),
            )*/
          ],
        ),
      ),
      /* floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          scan();

        },
        tooltip: 'Leer QR',
        child: Icon(Icons.camera,semanticLabel: 'Scan',color: Colors.white, size: animationx.value/6.0,),

      ),*/
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
              title: Text('Lista de inscripciones'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ClientesPuestosRegistrados(

                            )
                    )
                );

              },
            ),
            ListTile(
              title: Text('Salir'),
              onTap: () {
                Navigator.pop(context);
                _neverSatisfied();


              },
            ),
          ],
        ),
      ),
    );
  }

  Widget get _loadingView {
    return new Center(

        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[
            Text(
              'Cargando',
              style: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                letterSpacing: 4.0,
              ),
            ),
            new Container (


              padding: EdgeInsets.all(18.0),
              child:Text('Cargando invitado...'),
            ),

            CircularProgressIndicator(),


          ],)
    );
  }

  Widget get PuestoRegis{
    return  new Scaffold(

      key: _scaffoldKey,
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[
            Text(
              'Belca Puesto',textAlign: TextAlign.center,
              style: TextStyle( fontSize: 40.0,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                letterSpacing: 4.0,),
            ),
            TextFormField(
              controller: myController,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: 'Nombre Puesto'),
              validator: (val){
                if (val.isEmpty){
                  return 'Introduce el nombre de la empresa';
                }else{
                  return null;
                }
              },
               onSaved: (val){
                setState((){
                puestoSeleccionado = val;
                print(puestoSeleccionado);
                });
              },

            ),
            TextFormField(
              controller: myController2,
              obscureText:true,

              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: 'Contraseña'),
              validator: (val){
                if (val.isEmpty){
                  return 'Contraseña asignada';
                }else{
                  return null;
                }
              },
              onSaved: (val){
                setState((){
                  pass = val;
                });
              },

            ),


          ],

        ),

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Registro();

        },
        child: Icon(Icons.done),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget body = _pageToDisplay;
    return body;
  }


  Future convertQr  (barcode)async{

    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('Cargando...'),
      duration: Duration(seconds:100),
      action: SnackBarAction(
        label:'Delegar',textColor: Colors.white ,
        onPressed:(){
          setState(() {
            colorIcon= Colors.orange;
          });
          _scaffoldKey.currentState.hideCurrentSnackBar();
        },
      ),
    ));
   //data = await json.decode(barcode);
 // print('<<<<<<<<<<<<<<<<<<<<<<<<<' +data[1]["nombre"]);
   // var resBody = await json.decode(barcode);
   // data =  resBody["data"];
    var now = new DateTime.now();
    var key =  databaseReference.child('Puestos').child('Entrada').child('Registrados').hashCode;
    print("KEY -  $key");
    var keyString = key.toString();
    databaseReference.child('PuestosRespaldadosTemporales').child(puestoSeleccionado).child('Registrados').child(barcode).child(keyString).set({'Codigo':barcode,'Hora':now.toString()});
    databaseReference.child('RegistrosFinalesTemporales').child('PuestoSelecionadoCliente').child(barcode).child(puestoSeleccionado).child(keyString).set({'Codigo':barcode,'Hora':now.toString()});

    await databaseReference.child('RegistrosIniciales').child('RegiConvert').child(barcode).once().then((DataSnapshot snapshot) {
      _scaffoldKey.currentState.hideCurrentSnackBar();
      print('Data : ${snapshot.value}');
      var data = snapshot.value;
      var cedula = data['Cedula'];

      var codigo = data['Codigo'];
     ;



      if(puestoSeleccionado!='0'){
        if(data!=null){
          setState(() {
            colorIcon= Colors.green;
            nombre = data['NombreCompleto'];
            puesto =  data['Puesto'];
            empresa = data['NombreDeEmpresa'];
          //  print('SSSSSSSSSSSSSSSSSSSSSSSSs $puesto');
            if(puesto==null){
              puesto="-";
            }
            if(empresa==null){
              empresa="-";
            }

            cedula=  data['Cedula'];
            contadorx++;
          });

         // databaseReference.child('Puestos').child(puestoSeleccionado).child('Registrados').child(barcode).child(keyString).set({'NombreDeEmpresa':empresa,'Codigo':codigo,'Puesto':puesto,'Cedula':cedula,'NombreCompleto':nombre,'Hora':now.toString()});
          databaseReference.child('Puestos').child(puestoSeleccionado).child('Registrados').child(barcode).set(data);
          databaseReference.child('Puestos').child(puestoSeleccionado).child('Registrados').child(barcode).update({'Hora':now.toString()});

         // databaseReference.child('RegistrosFinales').child('PuestoSelecionadoCliente').child(barcode).child(puestoSeleccionado).child(keyString).update({'NombreDeEmpresa':empresa,'Codigo':codigo,'Puesto':puesto,'Cedula':cedula,'NombreCompleto':nombre,'Hora':now.toString()});
          databaseReference.child('RegistrosFinales').child('PuestoSelecionadoCliente').child(barcode).child(puestoSeleccionado).child(keyString).set(data);
          databaseReference.child('RegistrosFinales').child('PuestoSelecionadoCliente').child(barcode).child(puestoSeleccionado).child(keyString).update({'Hora':now.toString()});
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('Codigo Correcto'),
            duration: Duration(seconds:30),
            action: SnackBarAction(
              label:'Aceptar',textColor: Colors.white ,
              onPressed:(){
                setState(() {
                  colorIcon= Colors.orange;
                  nombre = 'Pulsa el botón verde para continuar';
                  empresa =  'Belca Food Show';
                  puesto =  'Belca Food Registros';
                });
                _scaffoldKey.currentState.hideCurrentSnackBar();
              },
            ),
          ));
        }else{
          setState(() {
            nombre = 'Vacio';
            puesto =  'Vacio';
          });
          print('No registrado');

          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('Codigo Incorrecto'),
            duration: Duration(seconds:10),
            action: SnackBarAction(
              label:'Descartar',textColor: Colors.white ,
              onPressed:(){
                _scaffoldKey.currentState.hideCurrentSnackBar();
              },
            ),
          ));
        }
      }


    });

  }

  Future scan() async {
    _scaffoldKey.currentState.hideCurrentSnackBar();
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
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
        barcode = "{\"data\":[{\"nombreapellido\":\"vacio\",\"NombreDeEmpresa\":\"vacio\",\"puesto\":\"vacio\"}]}";
      });

    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
}