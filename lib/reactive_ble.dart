import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class Scanning extends StatefulWidget {
  const Scanning({super.key});

  @override
  State<Scanning> createState() => _ScanningState();
}

class _ScanningState extends State<Scanning> {
  final FlutterBlue flutterBlue = FlutterBlue.instance;

  List<ScanResult> scanResults = [];

  @override
  void initState() {
    super.initState();
// Start scanning for BLE devices
    flutterBlue.scan().listen((result) {
// Add the result to the list
      setState(() {
        scanResults.add(result);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth connected devices'),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: scanResults.length,
        itemBuilder: (context, index) {
          ScanResult result = scanResults[index];
          BluetoothDevice device = result.device;
          String deviceName = device.name ?? 'Unknown device';
          String deviceId = device.id.toString();
          int deviceRssi = result.rssi;
          return ListTile(
            title: Text(deviceName),
            subtitle: Text(deviceId),
            trailing: Text('$deviceRssi dBm'),
            onTap: () {
              print('You tapped $deviceName');
               device.connect();
            },
          );
        },
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_blue/flutter_blue.dart';
//
// class ScanPage extends StatefulWidget {
//   const ScanPage({super.key});
//
//   @override
//   _ScanPageState createState() => _ScanPageState();
// }
//
// class _ScanPageState extends State<ScanPage> {
// // Get the FlutterBlue instance
//   final FlutterBlue flutterBlue = FlutterBlue.instance;
//
//   List<ScanResult> scanResults = [];
//
//   @override
//   void initState() {
//     super.initState();
// // Start scanning for BLE devices
//     flutterBlue.scan().listen((result) {
//       setState(() {
//         scanResults.add(result);
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Print bluetooth connected devices'),
//       ),
//       body: ListView.builder(
//         shrinkWrap: true,
//         itemCount: scanResults.length,
//         itemBuilder: (context, index) {
//           ScanResult result = scanResults[index];
//           BluetoothDevice device = result.device;
//           String deviceName = device.name ?? 'Unknown device';
//           print("HI $deviceName");
//           print(scanResults.length);
//           String deviceId = device.id.toString();
//           int deviceRssi = result.rssi;
//           return ListTile(
//             title: Text(deviceName),
//             subtitle: Text(deviceId),
//             trailing: Text('$deviceRssi dBm'),
//             onTap: () {
//               print('You tapped $deviceName');
//               device.connect();
//             },
//           );
//         },
//       ),
//     );
//   }
// }