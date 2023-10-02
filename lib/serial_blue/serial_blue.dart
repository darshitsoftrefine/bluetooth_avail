import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:audioplayers/audioplayers.dart';

class SerialBlue extends StatefulWidget {
  const SerialBlue({super.key});

  @override
  State<SerialBlue> createState() => _SerialBlueState();
}

class _SerialBlueState extends State<SerialBlue> {

  List<BluetoothDevice> _devices = [];

  Future<void> getDevices() async {
    await FlutterBluetoothSerial.instance.getBondedDevices().then((List<BluetoothDevice> bondedDevices) {
      setState(() {
        _devices = bondedDevices;
      });
    });
    bool? _isDiscovering = await FlutterBluetoothSerial.instance.isDiscovering;
    if (!_isDiscovering!) {
      await FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
        setState(() {
          _devices.add(r.device);
        });
      });
    }
  }

  //Future<void> connect(BluetoothDevice device) => BluetoothConnection.toAddress(device.address);
  // Future<void> connect(BluetoothDevice device) async {
  //   BluetoothConnection connection;
  //   try {
  //     connection = await BluetoothConnection.toAddress(device.address);
  //     print('Connected to the device');
  //   } catch (exception) {
  //     print('Cannot connect, exception occured');
  //   }
  // }

  connect(String address) async {
    BluetoothConnection connection;
    try {
      connection = await BluetoothConnection.toAddress(address);
      print(connection.isConnected);
      print('Connected to the device');

      connection.input?.listen((Uint8List data) {
        //Data entry point
        print(ascii.decode(data));
      });

    } catch (exception) {
      print('Cannot connect, exception occured');
    }
  }

  Future<void> connectToAddress(String? address) => Future(() async {
     await BluetoothConnection.toAddress(address);
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(onPressed: (){
              getDevices();
            }, child: const Text("Get Devices")),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _devices.length,
              itemBuilder: (context, index) {
                final device = _devices[index];
                return ListTile(
                  title: Text(device.name!),
                  subtitle: Text(device.address),
                  leading: const Icon(Icons.bluetooth),
                  onTap: () async{
                  await connect(device.address);
                  // final player = AudioPlayer();
                  // player.play(AssetSource('audio/aud1.mp3'));
                  },
                );
              },
            ),
          ],
        ),
      )
    );
  }
}
