import 'dart:async';

import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';

class BatteryProvider with ChangeNotifier {
  int batteryPercentage = 100;
  final Battery battery = Battery();
  int batteryLevel = 0;
  // Timer timer;

  getBatteryLevel() async {
    final level = await battery.batteryLevel;
    batteryLevel = level;
    notifyListeners();
  }
}
