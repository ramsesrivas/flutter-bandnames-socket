import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


enum ServerStatus{
  Online,
  Offline,
  Connecting
}


class SocketService with ChangeNotifier{
  //inicializo en conectando
  ServerStatus _serverStatus = ServerStatus.Connecting;

  //Declaro el socket como local
  IO.Socket _socket;

  // getter que permite retornar el estatus del servidor
  ServerStatus get serverStatus => this._serverStatus;

  //Expongo la propieda al exterior
  IO.Socket get socket => this._socket;

  //Expongo la funcion emit con un get 
  Function get emit => this._socket.emit;

  SocketService(){
    this._initConfig();
  }

  void _initConfig(){
    // Dart client
    this._socket = IO.io('http://192.168.100.21:3000',{
      'transports': ['websocket'],
      'autoConnect': true
    });

    this._socket.on('connect', (_) {
      print('Flutter Conectado');
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    this._socket.on('disconnect', (_) {
      print('Flutter Desconectado');
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    /* socket.on('nuevo-mensaje', ( payload ) {
      print('Nuevo Mensaje: ');

      print('Nombre: ' + payload['nombre']);
      print('Mensaje: ' + payload['mensaje']);

      //validar si el mensaje tiene algun dato
      print(payload.containsKey('mensaje2') ? payload['mensaje2'] : 'No hay mensaje2');
    });  */




  }
}


