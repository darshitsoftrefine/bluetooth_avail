import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class ShoeConnectedDevice extends StatefulWidget {
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final List<BluetoothDevice> devicesList = <BluetoothDevice>[];
  final Map<Guid, List<int>> readValues = Map<Guid, List<int>>();
  ShoeConnectedDevice({super.key});

  @override
  State<ShoeConnectedDevice> createState() => _ShoeConnectedDeviceState();
}

class _ShoeConnectedDeviceState extends State<ShoeConnectedDevice> {
  final _writeController = TextEditingController();
   List<BluetoothService>? _services;
  BluetoothDevice? _connectedDevice;

  @override
  void initState() {
    super.initState();
    widget.flutterBlue.connectedDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      for (BluetoothDevice device in devices) {
        _addDeviceTolist(device);
      }
    });
    widget.flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        _addDeviceTolist(result.device);
      }
    });
    widget.flutterBlue.startScan();
  }

//   @override
//   void initState() {
//     super.initState();
//     flutterBlue.startScan(scanMode: ScanMode.lowLatency, timeout: const Duration(seconds: 15));
//
// // Stop scanning
//     flutterBlue.scanResults.listen((results) {
//       // Handle scan results
//       for (ScanResult result in results) {
//         //print(result.device.name);
//         if (!devices.contains(result.device)) {
//           setState(() {
//             devices.add(result.device);
//           });
//       }
//       }
//     });
//     flutterBlue.stopScan();
//   }

  _addDeviceTolist(final BluetoothDevice device) {
    if (!widget.devicesList.contains(device)) {
      setState(() {
        widget.devicesList.add(device);
      });
    }
  }

  ListView _buildListViewOfDevices() {
    List<Container> containers = <Container>[];
    for (BluetoothDevice device in widget.devicesList) {
      containers.add(
        Container(
          height: 50,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(device.name),
                    Text(device.id.toString()),
                  ],
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text(
                  'Connect',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async{
                    await widget.flutterBlue.stopScan();
                    try {
                      await device.connect();
                    } catch (e) {
                      if (e.toString() != 'already_connected') {
                        rethrow;
                      }
                    } finally {
                      _services = await device.discoverServices();
                    }
                    _connectedDevice = device;
                },
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ...containers,
      ],
    );
  }

//   void scan(){
//     flutterBlue.startScan(timeout: const Duration(seconds: 4));
//
// // Listen to scan results
//     var subscription = flutterBlue.scanResults.listen((results) {
//       // do something with scan results
//       for (ScanResult r in results) {
//         print('${r.device.name} found! rssi: ${r.rssi}');
//       }
//     });
//
// // Stop scanning
//     flutterBlue.stopScan();
//   }
//   Future<void> check(BluetoothDevice device) async {
//      await device.discoverServices();
//   }
//
//   Future<void> startScan() async {
//     await flutterBlue.startScan();
//   }
//   Future<void> stopScan() async {
//     await flutterBlue.stopScan();
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLE Scanner'),
      ),
      body: _buildView(),
    );
  }

  ListView _buildView() {
    if (_connectedDevice != null) {
      return _buildConnectDeviceView();
    }
    return _buildListViewOfDevices();
  }

  ListView _buildConnectDeviceView() {
    List<Container> containers = <Container>[];

    for (BluetoothService service in _services!) {
      List<Widget> characteristicsWidget = <Widget>[];
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        characteristic.value.listen((value) {
          print(value);
        });
        characteristicsWidget.add(
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(characteristic.uuid.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  children: <Widget>[
                    ..._buildReadWriteNotifyButton(characteristic),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('Value: ${widget.readValues[characteristic.uuid]}'),
                  ],
                ),
                const Divider(),
              ],
            ),
          ),
        );
      }
      containers.add(
        Container(
          child: ExpansionTile(
              title: Text(service.uuid.toString()),
              children: characteristicsWidget),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ...containers,
      ],
    );
  }

  List<ButtonTheme> _buildReadWriteNotifyButton(
      BluetoothCharacteristic characteristic) {
    List<ButtonTheme> buttons = <ButtonTheme>[];

    if (characteristic.properties.read) {
      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              child: const Text('READ', style: TextStyle(color: Colors.black)),
              onPressed: () async {
                var sub = characteristic.value.listen((value) {
                  setState(() {
                    widget.readValues[characteristic.uuid] = value;
                  });
                });
                await characteristic.read();
                sub.cancel();
              },
            ),
          ),
        ),
      );
    }
    if (characteristic.properties.write) {
      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              child: const Text('WRITE', style: TextStyle(color: Colors.black)),
              onPressed: () async {
                await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Write"),
                        content: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                controller: _writeController,
                              ),
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text("Send"),
                            onPressed: () {
                              characteristic.write(utf8
                                  .encode(_writeController.value.text));
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: const Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    });
              },
            ),
          ),
        ),
      );
    }
    if (characteristic.properties.notify) {
      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              child: const Text('NOTIFY', style: TextStyle(color: Colors.black)),
              onPressed: () async {
                characteristic.value.listen((value) {
                  widget.readValues[characteristic.uuid] = value;
                });
                await characteristic.setNotifyValue(true);
              },

            ),
          ),
        ),
      );
    }

    return buttons;
  }

  }