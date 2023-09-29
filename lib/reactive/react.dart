import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class React extends StatefulWidget {
  const React({super.key});

  @override
  State<React> createState() => _ReactState();
}

class _ReactState extends State<React> {

  final flutterReactiveBle = FlutterReactiveBle();

  void scan() {
    flutterReactiveBle.scanForDevices(
        withServices: [], scanMode: ScanMode.lowLatency).listen((
        device) {
      print("device $device");
    }, onError: () {
      print("error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ElevatedButton(
        onPressed: (){
          scan();
        },
        child: Text("Scanning"),
      ),
    );
  }
}
