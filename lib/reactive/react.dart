import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class React extends StatefulWidget {
  const React({super.key});

  @override
  State<React> createState() => _ReactState();
}

class _ReactState extends State<React> {

  final flutterReactiveBle = FlutterReactiveBle();
  List devices = [];

  void scan() {
    try{
    flutterReactiveBle.scanForDevices(withServices: [], scanMode: ScanMode.lowLatency).listen((device) {
      setState(() {
        devices.add(device.name);
      });
    },
    );
        } catch(e){
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: (){
                scan();
              },
              child: Text("Scanning"),
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: devices.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(devices.toString()),
                );
              },

            )
          ],
        ),
      ),
    );
  }
}
