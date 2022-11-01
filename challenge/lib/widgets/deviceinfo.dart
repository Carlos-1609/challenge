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
  @override
  void initState() {
    super.initState();
    Provider.of<BatteryProvider>(context, listen: false).batteryTimer();
    Provider.of<ConnectivityProvider>(context, listen: false)
        .checkInternetConnection();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // timer!.cancel();
    // Provider.of<ConnectivityProvider>(context, listen: false)
    //     .internetSubscription
    //     .cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var battery = Provider.of<BatteryProvider>(context);
    var conn = Provider.of<ConnectivityProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Battery: ${battery.batteryLevel}%',
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 3,
            ),
            SizedBox(
              height: 10,
              width: 10,
              child:
                  battery.isLoading ? CircularProgressIndicator() : SizedBox(),
            ),
          ],
        ),
        Text(
          'Internet Connection Status: ${conn.hasInternet ? 'Active' : 'Disable'}',
          style: TextStyle(
              color: conn.hasInternet ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
