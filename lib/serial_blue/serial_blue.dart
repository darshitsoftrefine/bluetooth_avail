import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class SerialBlue extends StatefulWidget {
  const SerialBlue({super.key});

  @override
  State<SerialBlue> createState() => _SerialBlueState();
}

class _SerialBlueState extends State<SerialBlue> {

  List<BluetoothDevice> _devices = [];
  Future<void> getDevices() async {
    await FlutterBluetoothSerial.instance.getBondedDevices()
        .then((List<BluetoothDevice> bondedDevices) {
      setState(() {
        _devices = bondedDevices;
      });
    });
    bool? _isDiscovering = await FlutterBluetoothSerial.instance.isDiscovering;
    if (!_isDiscovering!) {
      await FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
        setState(() {
// Add discovered device to the list
          _devices.add(r.device);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _devices.length,
        itemBuilder: (context, index) {
// Get device from list
          final device = _devices[index];
// Return a list tile with device name and ID
          print(device.name);
          return ListTile(
            title: Text(device.name!),
            subtitle: Text(device.address),
            leading: const Icon(Icons.bluetooth),
            onTap: () {
// Do something when device is tapped
            },
          );
        },
      )
    );
  }
}
