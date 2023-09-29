import 'package:bluetooth_device/controllers/bluetooth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<BluetoothController>(
        init: BluetoothController(),
        builder: (controller) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  color: Colors.blue,
                  child: Center(
                    child: Text("Bluetooth App", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),),
                  ),
                ),
                SizedBox(height: 30,),
                Center(
                  child: ElevatedButton(onPressed: () => controller.scanDevices(), child: Text("Scan", style: TextStyle(fontSize: 19),),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue
                    ),),
                ),
                SizedBox(height: 30,),
                StreamBuilder<List<ScanResult>>(
                  stream: controller.scanResults,
                    builder: (context, snapshot)  {
                      if(snapshot.hasData){
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index){
                            final data = snapshot.data?[index];
                            return Card(
                              child: ListTile(
                                title: Text(data!.device.localName),
                                subtitle: Text(data.device.id.id),
                                trailing: Text(data.rssi.toString()),
                                onTap: () async {
                                  await data.device.connect();
                                },
                              ),
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator()
                        );
                      }
                    })
              ],
            ),
          );
        }
      ),
    );
  }
}
