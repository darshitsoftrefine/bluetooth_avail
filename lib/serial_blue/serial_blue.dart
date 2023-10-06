import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class SerialBlue extends StatefulWidget {
  const SerialBlue({super.key});

  @override
  State<SerialBlue> createState() => _SerialBlueState();
}

class _SerialBlueState extends State<SerialBlue> {

  List<BluetoothDevice> _devices = [];
  FlutterBluetoothSerial serial = FlutterBluetoothSerial.instance;
  bool? isDiscovering;
  List<int> selectedItem = [];


  Future<void> getDevices() async {
    //await serial.requestEnable();
    await serial.getBondedDevices().then((List<BluetoothDevice> bondedDevices) {
      setState(() {
        _devices = bondedDevices;
      });
    });
    isDiscovering = await serial.isDiscovering;
    if (!isDiscovering!) {
     serial.startDiscovery().listen((r) {
        setState(() {
          _devices.add(r.device);
        });
      });
    }
    isDiscovering = true;
  }

  Future<void> connecting(BluetoothDevice device) async {
    await BluetoothConnection.toAddress(device.address);
  }
  // Future<void> connect(BluetoothDevice device) async {
  //   BluetoothConnection connection;
  //   try {
  //     connection = await BluetoothConnection.toAddress(device.address);
  //     print('Connected to the device');
  //     connection.input?.listen((Uint8List data) {
  //       print('Data incoming: ${ascii.decode(data)}');
  //
  //     }).onDone(() {
  //       print('Disconnected by remote request');
  //     });
  //
  //   } catch (exception) {
  //     print(exception);
  //     print('Cannot connect, exception occured');
  //   }
  // }

  connect(String address) async {
    BluetoothConnection connection;
    try {
      connection = await BluetoothConnection.toAddress(address);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Connected to the device')));
      print(connection.isConnected);

    } catch (exception) {
      print(exception);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cannot connect, error occured')));
    }
  }

  Future<void> connectToAddress(String? address) => Future(() async {
     await BluetoothConnection.toAddress(address);
  });



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Bluetooth Devices"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => getDevices(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              children: [
                ElevatedButton(onPressed: (){
                  getDevices();
                }, child: const Text("Scan Devices")),
                isDiscovering == false ? const Center(child: CircularProgressIndicator()) : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _devices.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: _devices[index].name == null ? const SizedBox() : Text(_devices[index].name!),
                        subtitle: Text(_devices[index].address),
                        leading: const Icon(Icons.bluetooth),
                        trailing:  ElevatedButton(onPressed: () async{
                          connect(_devices[index].address);
                          setState(() {
                            if (selectedItem.contains(index)) {
                              selectedItem.remove(index);
                            } else {
                              selectedItem.add(index);
                            }
                          });
                        }, child: selectedItem.contains(index) ? const Text("Disconnect"): const Text("Connect")),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}