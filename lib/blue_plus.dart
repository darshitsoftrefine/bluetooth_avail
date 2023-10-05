import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluePlus extends StatefulWidget {
  const BluePlus({super.key});

  @override
  State<BluePlus> createState() => _BluePlusState();
}

class _BluePlusState extends State<BluePlus> {

  FlutterBluePlus flutterBluePlus = FlutterBluePlus();
  List<BluetoothDevice> devices = [];
  Future<void> scan() async {
    // Setup Listener for scan results.
// device not found? see "Common Problems" in the README
    Set<DeviceIdentifier> seen = {};
    var subscription = FlutterBluePlus.scanResults.listen(
            (results) {
          for (ScanResult r in results) {
            if (seen.contains(r.device.remoteId) == false) {
              print('${r.device.remoteId}: "${r.advertisementData.localName}" found! rssi: ${r.rssi}');
              seen.add(r.device.remoteId);
            }
          }
        },

    );

// Start scanning
// Note: You should always call `scanResults.listen` before you call startScan!
    await FlutterBluePlus.startScan(timeout: Duration(seconds: 10));

// Stop scanning
    await FlutterBluePlus.stopScan();
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    scan();

                  },
                  child: Text("Scan"),
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: devices.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(devices[index].localName),
                    );
                  },

                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
