import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class ShoeConnectedDevice extends StatefulWidget {
  const ShoeConnectedDevice({super.key});

  @override
  State<ShoeConnectedDevice> createState() => _ShoeConnectedDeviceState();
}

class _ShoeConnectedDeviceState extends State<ShoeConnectedDevice> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<BluetoothDevice> devices = [];

  @override
  void initState() {
    super.initState();
    flutterBlue.startScan(scanMode: ScanMode.lowLatency, timeout: const Duration(seconds: 15));

// Stop scanning
    flutterBlue.scanResults.listen((results) {
      // Handle scan results
      for (ScanResult result in results) {
        //print(result.device.name);
        if (!devices.contains(result.device)) {
          setState(() {
            devices.add(result.device);
          });
      }
      }
    });
    flutterBlue.stopScan();
  }



  void scan(){
    flutterBlue.startScan(timeout: const Duration(seconds: 4));

// Listen to scan results
    var subscription = flutterBlue.scanResults.listen((results) {
      // do something with scan results
      for (ScanResult r in results) {
        print('${r.device.name} found! rssi: ${r.rssi}');
      }
    });

// Stop scanning
    flutterBlue.stopScan();
  }
  Future<void> check(BluetoothDevice device) async {
     await device.discoverServices();
  }

  Future<void> startScan() async {
    await flutterBlue.startScan();
  }
  Future<void> stopScan() async {
    await flutterBlue.stopScan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLE Scanner'),
      ),
      body: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              scan();
            },
            child: const Text('Start Scanning'),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: devices.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(devices[index].name),
                  subtitle: Text(devices[index].id.toString()),
                  onTap: () async {
                    await devices[index].connect(autoConnect: true);
                    check(devices[index]);
                    //await devices[index].disconnect();
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              stopScan();
            },
            child: const Text('Stop Scanning'),
          ),
        ],
      ),
    );
  }
  }