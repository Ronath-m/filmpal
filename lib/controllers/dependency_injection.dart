import 'package:get/get.dart';
import 'network_controller.dart';

// Class for dependency injection initialization
class DependencyInjection {
  static void init() {
    Get.put<NetworkController>(NetworkController(), permanent: true);
  }
}
