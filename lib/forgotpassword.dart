import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordPage extends StatefulWidget{
  @override
  State<StatefulWidget>createState()=> _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>{



  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String email;
  String password;
  bool _isLogin = false;

  forgotPassword() async{

    if(_isLogin)return;
    setState((){
      _isLogin = true;
    });
    _scaffoldKey.currentState.showSnackBar(SnackBar(content:Text('Sollicitud de canvi de contrasenya')));

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
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _scaffoldKey.currentState.hideCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('ha enviat el correu electrònic de restabliment de la contrasenya! Comproveu la vostra safata d’entrada'),
        duration: Duration(seconds:10),
      ),
      );
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
      appBar: AppBar(title:Text("Restaureu la contrasenya"),

      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child:ScrollConfiguration(
          behavior: ScrollBehavior(),
          child:Form(
            key:formKey,
            child: ListView(children: <Widget>[
              FlutterLogo(
                  style: FlutterLogoStyle.markOnly,
                  size:120.0
              ),
              Padding(
                padding:EdgeInsets.symmetric(vertical:20.0),
                child:Text('Introduïu la vostra adreça de correu electrònic per enviar-li un enllaç de reinicialització de la contrasenya'),


              ),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'Correu electrònic'),
                validator: (val){
                  if (val.isEmpty){
                    return 'Introduïu un correu electrònic vàlid';
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


              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text('Restaura la contrasenya',
                  style:
                  TextStyle(color: Color.fromARGB(255, 200, 200, 200)),
                ),
              ),



            ],),
          ),

        ),

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          forgotPassword();
        },
        child: Icon(Icons.restore),
      ),

    );
  }
}