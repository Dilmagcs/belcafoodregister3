import 'package:flutter/material.dart';
import 'behaviors/hidden.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';


class RegisterPage extends StatefulWidget{
  @override
  State<StatefulWidget>createState()=> _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>{

  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String email;
  String password;
  bool _isRegistering = false;
  String usersAdd;

  register() async{

    if(_isRegistering)return;
    setState((){
      _isRegistering = true;
    });
    _scaffoldKey.currentState.showSnackBar(SnackBar(content:Text('Registre d’usuari')));

    final form = formKey.currentState;
    if(!form.validate()){
      _scaffoldKey.currentState.hideCurrentSnackBar();


      setState(() {
        _isRegistering = false;
      });
   return;
    }
  form.save();
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      usersAdd = user.uid.toString();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print('Guarda ID $usersAdd');
      prefs.setString('usersAdd', usersAdd);
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
        _isRegistering = false;
      });
    }
}

  @override
  Widget build (BuildContext context){

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title:Text("Registrarse"),

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
                   'DEXAMEN',
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
               TextFormField(
                 obscureText:true,
                 decoration: InputDecoration(labelText: 'Crea la teva contrasenya'),
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
                   'Benvingut a Examen',
                   style: 
                   TextStyle(color: Color.fromARGB(255, 200, 200, 200)),
                 ),
               )
             ],),
           ),

         ),

       ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          register();
        },
        child: Icon(Icons.person_add),
      ),
      persistentFooterButtons: <Widget>[
        FlatButton(
          onPressed:(){
            Navigator.of(context).pushNamed('/login');
          } ,
          child: Text('Tinc un compte', style: TextStyle(color: Colors.redAccent)),
        )
      ],
      );
  }
}