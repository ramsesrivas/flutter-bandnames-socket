import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:band_names/models/band.dart';


class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'Metalica', votes: 5),
    Band(id: '1', name: 'Queen', votes: 4),
    Band(id: '1', name: 'Héroes del silencio', votes: 1),
    Band(id: '1', name: 'Bon Jovi', votes: 4),
    Band(id: '1', name: 'Dark', votes: 3),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Band Names', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, i)  =>  _bandTile(bands[i])
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          elevation: 1,
          onPressed: addNewband
        ) ,   );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      key:Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: ( DismissDirection direction ){
        print('Direccion: $direction');
        print('Id: ${ band.id }');
        //TODO llamar al borrado en el
      },
      background: Container(
        padding: EdgeInsets.only(left: 8.0),
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text('Borrar banda', style: TextStyle(color: Colors.white),),
        ),
      ),
      child: ListTile(
            leading: CircleAvatar(
              child: Text(band.name.substring(0,2)), //Solol agrega las primeras dos letras de la banda
              backgroundColor: Colors.blue[100],
            ),
            title: Text(band.name),
            trailing: Text('${ band.votes}', style: TextStyle(fontSize: 20),),
            onTap: (){
              print(band.name);
            }
            ,
          ),
    );
  }

  addNewband(){
    final TextEditingController textController = new TextEditingController();

      //este metodo es para diferenciar Android de IOS
    if( Platform.isAndroid) {
      return showDialog(
      context: context, 
      builder: (context){
        return AlertDialog(
          title: Text('Nuevas banda'),
          content: TextField(
            controller: textController,
          ),
          actions: <Widget>[
            MaterialButton(
              child: Text('Agregar'),
              elevation: 5,
              textColor: Colors.blue,
              onPressed: (){
                addBandToList(textController.text);
                print(textController.text);
              },
            )
          ],
         );
      },
      );
    }
    showCupertinoDialog(
      context: context, 
      builder: ( _) {
        return CupertinoAlertDialog(
          title: Text('Nueva banda'),
          content: CupertinoTextField(
            controller: textController,
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Agregar'),
              onPressed: (){
                addBandToList(textController.text);
                print(textController.text);
              },
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text('Cerrar'),
              onPressed: (){
               //cerrar el show doialog
                Navigator.pop(context);
                print(textController.text);
              },
            ),
          ],
        );
      }
      
      );

    
  }

  void addBandToList(String name){
    if(name.length>1){
      //Podemos agregar
      this.bands.add(new Band(
        id: DateTime.now().toString(),
        name: name,
        votes:0
      ));
      setState(() {});
    }
    //cerrar el show doialog
    Navigator.pop(context);
  }

}