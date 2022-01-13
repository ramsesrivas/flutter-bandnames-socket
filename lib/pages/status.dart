import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:band_names/services/socket_service.dart';


class StatusPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    //socketService.socket.emit(event)

    return Scaffold(
       body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('ServerStatus: ${ socketService.serverStatus }')
          ],
        ),
     ),
     floatingActionButton: FloatingActionButton(
       child: Icon(Icons.message),
       onPressed: (){
         //Emitimos el mensaje
         socketService.socket.emit('emitir-mensaje', {
           'nombre': 'FlutterRam', 
           'mensaje': 'Hola desde flutter'});
       } ,
       
       ),
   );
  }
}