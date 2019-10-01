import 'package:flutter/material.dart';
import 'behaviors/hidden.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LoginPage extends StatefulWidget{
  @override
  State<StatefulWidget>createState()=> _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{

  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String email;
  String password;
  bool _isLogin = false;

  login() async{

    if(_isLogin)return;
    setState((){
      _isLogin = true;
    });
    _scaffoldKey.currentState.showSnackBar(SnackBar(content:Text('Iniciando Sesion')));

    final form = formKey.currentState;
    if(!form.validate()){
      _scaffoldKey.currentState.hideCurrentSnackBar();


      setState(() {
        _isLogin = false;
      });
      return;
    }
    form.save();
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/maintabs');
    } catch (e){
      _scaffoldKey.currentState.hideCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(e.message),
        duration: Duration(seconds:10),
        action: SnackBarAction(
          label:'Descartar',
          onPressed:(){
            _scaffoldKey.currentState.hideCurrentSnackBar();
          },
        ),
      ));
    }finally{
      setState(() {
        _isLogin = false;
      });
    }
  }

  @override
  Widget build (BuildContext context){

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title:Text("Iniciar Sesion"),

      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child:ScrollConfiguration(
          behavior: Hidden(),
          child:Form(
            key:formKey,
            child: ListView(children: <Widget>[
            Center(
            child: Text(
                'BELCA',
                style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  letterSpacing: 4.0,
                  shadows: [
                    /*Shadow(
                              blurRadius: 8.0,
                              color: Colors.black,
                              offset: Offset(3.0, 4.5),
                            ),*/
                  ],
                ),
              ),),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (val){
                  if (val.isEmpty){
                    return 'Introduce Correo';
                  }else{
                    return null;
                  }
                },
                onSaved: (val){
                  setState((){
                    email = val;
                  });
                },

              ),
              TextFormField(
                obscureText:true,
                decoration: InputDecoration(labelText: 'Contrasenya'),
                validator: (val) {
                  if (val.isEmpty) {
                    return 'Introduïu una contrasenya vàlida';
                  } else {
                    return null;
                  }
                },
                onSaved: (val){
                  setState((){
                    password = val;
                  });
                },
              ),

              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  'Benvingut a Dexamen',
                  style:
                  TextStyle(color: Color.fromARGB(255, 200, 200, 200)),
                ),
              ),

              FlatButton(
                child: Text('He oblidat la meva contrasenya'),
                onPressed: (){
                  Navigator.of(context).pushNamed('/forgotpassword');
                },
              ),

            ],),
          ),

        ),

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          login();
        },
        child: Icon(Icons.account_circle),
      ),
      persistentFooterButtons: <Widget>[
        FlatButton(
          onPressed:(){
            Navigator.of(context).pop();
          } ,
          child: Text("No tinc un compte"),
        )
      ],
    );
  }
}