import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluePlus extends StatefulWidget {
  const BluePlus({super.key});

  @override
  State<BluePlus> createState() => _BluePlusState();
}

class _BluePlusState extends State<BluePlus> {

  FlutterBluePlus flutterBluePlus = FlutterBluePlus();
  void scan(){
    String name = "";
    FlutterBluePlus.startScan(timeout: Duration(seconds: 5));
    FlutterBluePlus.scanResults.listen((event) async {
      for (ScanResult r in event) {
        await r.device.connect(autoConnect: true);
        name = r.device.localName;
        print(' hi ${r.device.name} found! rssi: ${r.rssi}');

      }
    });
    print("Hi $name");
    FlutterBluePlus.stopScan();
  }

  void connectToDevice(BluetoothDevice device) async {
    await device.connect();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: ElevatedButton(
            onPressed: () {
              scan();

            },
            child: Text("Scan"),

          ),
        ),
      ),
    );
  }
}
