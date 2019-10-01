import 'package:flutter/material.dart';
import 'package:belcafoodregister/main.dart';
import '../mainTabs.dart';


class Login extends StatefulWidget{
  @override
  State<StatefulWidget>createState()=> LoginPageState();

  final tema;
  Login({Key key, @required this.tema,}) : super(key: key);
}

class LoginPageState extends State<Login>{

  Entra(){
    setState(() {
      Label= true;
    });
  }

  bool Label= false;

  Widget get _pageToDisplay {
    if(Label==false){
      return Register;
    }else{
      return Home;
    }
  }

  Widget get Register {
    return Scaffold(body: Container(
      child: new ListView(
        padding: EdgeInsets.zero,

        children: <Widget>[
          new Container(height: 55,),
          Container(

            padding: EdgeInsets.only(top:10,left: 10),
            child:Text('Belca Login',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                letterSpacing: 3.0,
              ),
            ),
          ),

          Container(
            child:   TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: 'Nombre Comercial'),
              validator: (val){
                if (val.isEmpty){
                  return 'Nombre de la empresa comercial';
                }else{
                  return null;
                }
              },
              onSaved: (val){
                setState((){

                });
              },

            ),
          ),
          Container(
            child:   TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: 'Empresa'),
              validator: (val){
                if (val.isEmpty){
                  return 'Introduïu un correu electrònic vàlid';
                }else{
                  return null;
                }
              },
              onSaved: (val){
                setState((){

                });
              },

            ),
          ),
          Container(
            child:    RaisedButton(
              onPressed: () {
                Entra();
              },
              textColor: Colors.white,
              padding: const EdgeInsets.all(0.0),
              child: Container(
                width: 500.0,
                decoration: const BoxDecoration(
                  color: const Color(0xFF1976D2),
                ), padding: const EdgeInsets.all(10.0),
                child: const Text(
                    'ACTUALIDAD',
                    style: TextStyle(fontSize: 16)
                ),
              ),
            ),
          ),
        ],),

    )
    );
  }

  Widget get Home {
    return  MainTabsPage();
  }

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
