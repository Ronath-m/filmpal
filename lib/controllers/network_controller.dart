import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restart_app/restart_app.dart';

// Controller class for managing network connectivity
class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  // Method to update connection status
  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult != ConnectivityResult.none) {
      Navigator.of(Get.overlayContext!).pop();
      Restart.restartApp();
    } else if (connectivityResult == ConnectivityResult.none) {
      // Show modal dialog
      showDialog(
        context: Get.overlayContext!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.black, // Black background color
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.wifi_off,
                    color: Colors.white,
                    size: 35,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'PLEASE CONNECT TO THE INTERNET',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
