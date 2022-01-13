import 'dart:io';
import 'package:band_names/services/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:band_names/models/band.dart';
import 'package:pie_chart/pie_chart.dart';

enum LegendShape { Circle, Rectangle }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    List<Band> bands = [
    //Band(id: '1', name: 'Metalica', votes: 5),
    //Band(id: '1', name: 'Queen', votes: 4),
    //Band(id: '1', name: 'Héroes del silencio', votes: 1),
    //Band(id: '1', name: 'Bon Jovi', votes: 4),
    //Band(id: '1', name: 'Dark', votes: 3),
  ];

    @override
    void initState() {
      //Inicio a escuchar el evento
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.socket.on('active-bands', _handleActiveBands);
      super.initState();
    }

    _handleActiveBands (dynamic payload){
      //Convierto el objeto recibido jason en un listo y luego por fromMap lo asigno a las bandas
        this.bands = (payload as List).map((band) => Band.fromMap(band)).toList();
        setState(() {});
    }

    @override
      void dispose() {
        //Dejo de escuchar el evento
        final socketService = Provider.of<SocketService>(context, listen: false);
        socketService.socket.off('active-bands');
        super.dispose();
      }


  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Bandas', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: <Widget> [
          Container(
            margin: EdgeInsets.only( right: 10),
            child: 
              (socketService.serverStatus == ServerStatus.Online)
                ? Icon (Icons.check_circle, color: Colors.blue[300]) 
                : Icon (Icons.offline_bolt, color: Colors.red,)
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          _showGraph(),
          Expanded(
            child: ListView.builder(
            itemCount: bands.length,
            itemBuilder: (context, i)  =>  _bandTile(bands[i])
            ),
          ),
        ],
      ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          elevation: 1,
          onPressed: addNewband
        ) ,   );
  }

  Widget _bandTile(Band band) {
    final socketService =  Provider.of<SocketService>(context, listen: false);
    
    return Dismissible(
      key:Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: ( _ ) => socketService.socket.emit('delete-band', { 'id': band.id }),
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
            onTap: () => socketService.socket.emit('vote-band', { 'id': band.id }),
          ),
    );
  }

  addNewband(){
    final TextEditingController textController = new TextEditingController();

      //este metodo es para diferenciar Android de IOS
    if( Platform.isAndroid) {
      return showDialog(
      context: context, 
      builder: ( _ ) => AlertDialog(
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
         ),
      );
    }
    showCupertinoDialog(
      context: context, 
      builder: ( _) => CupertinoAlertDialog(
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
        )
      );
  }

  void addBandToList(String name){
    if(name.length>1){
      //Podemos agregar
      //this.bands.add(new Band(
      //  id: DateTime.now().toString(),
      //  name: name,
      //  votes:0
      //));
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.emit('add-band',{
        'name': name
      });
    }
    //cerrar el show dialog
    Navigator.pop(context);
  }


  final colorList = <Color>[
    Color(0xfffdcb6e),
    Color(0xff0984e3),
    Color(0xfffd79a8),
    Color(0xffe17055),
    Color(0xff6c5ce7),
  ];

  final gradientList = <List<Color>>[
    [
      Color.fromRGBO(223, 250, 92, 1),
      Color.fromRGBO(129, 250, 112, 1),
    ],
    [
      Color.fromRGBO(129, 182, 205, 1),
      Color.fromRGBO(91, 253, 199, 1),
    ],
    [
      Color.fromRGBO(175, 63, 62, 1.0),
      Color.fromRGBO(254, 154, 92, 1),
    ]
  ];

  ChartType _chartType = ChartType.disc;
  bool _showCenterText = true;
  double _ringStrokeWidth = 32;
  double _chartLegendSpacing = 32;

  bool _showLegendsInRow = false;
  bool _showLegends = true;

  bool _showChartValueBackground = true;
  bool _showChartValues = true;
  bool _showChartValuesInPercentage = false;
  bool _showChartValuesOutside = false;

  bool _showGradientColors = false;

  LegendShape _legendShape = LegendShape.Circle;
  LegendPosition _legendPosition = LegendPosition.right;

  _showGraph(){
    Map<String, double> dataMap = new Map();
    //dataMap.putIfAbsent('Flutter', () => 5);
    bands.forEach((band) {
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble() );
    });
    
    return Container(
     // padding: EdgeInsets.only(top:10),
      width: double.infinity,
      height: 200,
      child: PieChart(
        dataMap: dataMap,
        animationDuration: Duration(milliseconds: 800),
        chartLegendSpacing: _chartLegendSpacing,
        chartRadius: MediaQuery.of(context).size.width / 3.2 > 300
          ? 300
          : MediaQuery.of(context).size.width / 3.2,
        colorList: colorList,
        initialAngleInDegree: 0,
        chartType: _chartType,
        centerText: _showCenterText ? "Band" : null,
        legendOptions: LegendOptions(
          showLegendsInRow: _showLegendsInRow,
          legendPosition: _legendPosition,
          showLegends: _showLegends,
          legendShape: _legendShape == LegendShape.Circle
              ? BoxShape.circle
              : BoxShape.rectangle,
          legendTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        chartValuesOptions: ChartValuesOptions(
          showChartValueBackground: _showChartValueBackground,
          showChartValues: _showChartValues,
          showChartValuesInPercentage: _showChartValuesInPercentage,
          showChartValuesOutside: _showChartValuesOutside,
        ),
        ringStrokeWidth: _ringStrokeWidth,
        emptyColor: Colors.grey,
        gradientList: _showGradientColors ? gradientList : null,
        emptyColorGradient: [
          Color(0xff6c5ce7),
          Colors.blue,
        ],
      ));
  }
}