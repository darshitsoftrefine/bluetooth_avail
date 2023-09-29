
import 'package:bluetooth_device/reactive/react.dart';
import 'package:bluetooth_device/reactive_ble.dart';
import 'package:bluetooth_device/scan_page.dart';
import 'package:bluetooth_device/show_connected_devices.dart';
import 'package:bluetooth_device/views/home_page.dart';
import 'package:flutter/material.dart';

import 'blue_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ShoeConnectedDevice()
    );
  }
}

