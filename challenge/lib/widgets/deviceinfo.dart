import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/battery_provider.dart';
import '../providers/connectivity_provider.dart';

class DeviceInfo extends StatefulWidget {
  const DeviceInfo({super.key});

  @override
  State<DeviceInfo> createState() => _DeviceInfoState();
}

class _DeviceInfoState extends State<DeviceInfo> {
  Timer? timer;
  @override
  void initState() {
    super.initState();
    Timer.periodic(
      const Duration(seconds: 5),
      (timer) {
        Provider.of<BatteryProvider>(context, listen: false).getBatteryLevel();
      },
    );
    Provider.of<ConnectivityProvider>(context, listen: false)
        .checkInternetConnection();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer!.cancel();
    Provider.of<ConnectivityProvider>(context, listen: false)
        .internetSubscription
        .cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var battery = Provider.of<BatteryProvider>(context);
    var conn = Provider.of<ConnectivityProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Battery ${battery.batteryLevel}%'),
        Text(
            'Internet Connection Status: ${conn.hasInternet ? 'Active' : 'Disable'}')
      ],
    );
  }
}
