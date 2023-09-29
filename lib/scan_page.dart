
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {

  FlutterBlue fl = FlutterBlue.instance;
  List<ScanResult> scanResultList = [];


Future<StreamSubscription<List<ScanResult>>> scanDevices()async{
  var name = "";
  await fl.startScan(timeout: Duration(seconds: 10), allowDuplicates: false);
 var subscription = fl.scanResults.listen((results) async {

   for (ScanResult r in results) {
     await r.device.connect();
     var name = r.device.name;
     print(' hi ${r.device.name} found! rssi: ${r.rssi}');

   }
 });
 print("Hi $name");
 return subscription;
  await fl.stopScan();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            children: [
             FutureBuilder(
               future: scanDevices(),
               builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                 print(snapshot.toString());
                 if(!snapshot.hasData){
                   return Text(snapshot.toString());
                 } else {
                   return const CircularProgressIndicator();
                 }
               },

             ),
              ElevatedButton(onPressed: (){
                scanDevices();
                print(scanResultList);
              }, child: Text("Scan"))
            ],
          ),
        ),
      ),
    );
  }
}
