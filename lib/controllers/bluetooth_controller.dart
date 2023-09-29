import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class BluetoothController extends GetxController {

  FlutterBluePlus flutterBlue = FlutterBluePlus();
  Future scanDevices() async {
    FlutterBluePlus.startScan(timeout: Duration(seconds: 10));

    //FlutterBluePlus.stopScan();
  }

  Stream<List<ScanResult>> get scanResults => FlutterBluePlus.scanResults;
}