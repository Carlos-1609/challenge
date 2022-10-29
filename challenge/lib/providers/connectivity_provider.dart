import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectivityProvider with ChangeNotifier {
  bool hasInternet = false;
  late StreamSubscription internetSubscription;

  checkInternetConnection() {
    internetSubscription = InternetConnectionChecker().onStatusChange.listen(
      (status) {
        hasInternet = status == InternetConnectionStatus.connected;
        notifyListeners();
      },
    );
  }
}
