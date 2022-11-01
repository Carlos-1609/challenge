import 'dart:async';

import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';

class BatteryProvider with ChangeNotifier {
  int batteryPercentage = 100;
  final Battery battery = Battery();
  int batteryLevel = 0;
  bool isLoading = true;
  Timer? timer;
  // Timer timer;

  _getBatteryLevel() async {
    final level = await battery.batteryLevel;
    batteryLevel = level;
    isLoading = false;
    notifyListeners();
  }

  batteryTimer() {
    Timer.periodic(
      const Duration(seconds: 5),
      (timer) {
        _getBatteryLevel();
      },
    );
  }

  disposeService() => timer!.cancel();
}
