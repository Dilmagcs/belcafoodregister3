import 'package:flutter/material.dart';
import 'register.dart';
import 'login.dart';

import 'forgotpassword.dart';
import 'mainTabs.dart';



Map<String, WidgetBuilder> buildAppRoutes(){

  String  title;
  String description;

  return{
    '/login':(BuildContext context) =>  LoginPage(),
    '/register':(BuildContext context) =>  RegisterPage(),
    '/forgotpassword':(BuildContext context) =>  ForgotPasswordPage(),



  };
}