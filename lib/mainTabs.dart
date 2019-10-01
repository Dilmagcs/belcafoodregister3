import 'package:flutter/material.dart';
import 'registros/Lector.dart';
import 'listas/Listas.dart';
import 'main.dart';
import 'registros/Validador.dart';
class MainTabsPage extends StatelessWidget{

  @override
  Widget build(BuildContext context){


    return Scaffold(body: DefaultTabController(
      length:1,
      child: new Scaffold(
        body :TabBarView(
          children: <Widget>[
            Lector(),
            //MyHomePage(title: 'Belca Validador'),

          //  Listas(),
            /*RentalPage(),
            LovePage(),*/


          ],
      ),

        bottomNavigationBar: PreferredSize(
            preferredSize: Size(35.0,6.0),
            child: Container(
              height: 36.0,
              child: TabBar(
                labelColor: Theme.of(context).primaryColor,
                labelStyle: TextStyle(fontSize: 10.0 ),
                tabs:<Widget>[
                  Tab(
                   icon:Icon(Icons.face),
                  // text:'vibra432',

                  ),
                 /* Tab(
                      icon:Icon(Icons.camera_alt),
                  //  text:'L’EXAMEN',
                  ),*/
                 /*Tab(
                    icon:Icon(Icons.format_list_numbered),

                  ),*/
                 /* Tab(
                    icon:Icon(Icons.star),
                    text:'Honores',
                  ),
                 /* Tab(
                    icon:Icon(Icons.camera_alt),
                    text:'Camera',
                  ),*/
                  Tab(
                    icon:Icon(Icons.face),
                    text:'User',
                  ),*/

                ]
              ),
            ),
            ),
      ),
    ));
  }
}