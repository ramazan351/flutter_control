import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:system_shortcuts/system_shortcuts.dart';
import 'package:hardware_buttons/hardware_buttons.dart' as HardwareButtons;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription<HardwareButtons.VolumeButtonEvent> _volumeButton;
  StreamSubscription<HardwareButtons.HomeButtonEvent> _homeButton;
  StreamSubscription<HardwareButtons.LockButtonEvent> _lockButton;
  String _newButtonEvent;
  @override
  void initState() {
    super.initState();
    _volumeButton=HardwareButtons.volumeButtonEvents.listen((event) {setState(() {
      _newButtonEvent=event.toString();
    });});
    _homeButton=HardwareButtons.homeButtonEvents.listen((event) {setState(() {
      _newButtonEvent="Home_Button_Event";
    });});
    _lockButton=HardwareButtons.lockButtonEvents.listen((event) {setState(() {
     _newButtonEvent="Lock_Button_Event";
    });});

  }
  @override
  void dispose() {
    _lockButton.cancel();
    _homeButton.cancel();
    _volumeButton.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      home: Scaffold(
        body: bodyPage(),
      ),
    );
  }

  Widget bodyPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(onPressed: _homeKeyPress, child: Text("Home Key"),color: Colors.orangeAccent,),
          FlatButton(onPressed: _wifi, child: Text("Wifi"),color: Colors.red,),//turn on/off
          FlatButton(onPressed: _bluetooth, child: Text("Bluetooth"),color: Colors.blue,),//turn on/off
          FlatButton(onPressed: _control, child: Text("Control"),color: Colors.orangeAccent,),
          FlatButton(onPressed: _volumeUP, child: Text("Volume Up"),color: Colors.orange[600],),
          FlatButton(onPressed: _volumeDOWN, child: Text("Volume Down"),color: Colors.orange[200],),
          Text("data: $_newButtonEvent"),
        ],
      ),
    );
  }

  void _homeKeyPress() async{
    await SystemShortcuts.home();
  }

  void _wifi() async{
    await SystemShortcuts.wifi();
  }

  void _bluetooth()async {
    await SystemShortcuts.bluetooth();
  }

  void _control()async {
    bool w= await SystemShortcuts.checkWifi;
    bool b= await SystemShortcuts.checkBluetooth;
    Fluttertoast.showToast(msg: "State of Bluetooth-$b \n State of Wifi-$w");
  }

  void _volumeUP() async{
    await SystemShortcuts.volUp();
  }

  void _volumeDOWN() async{
    await SystemShortcuts.volDown();
  }
}

