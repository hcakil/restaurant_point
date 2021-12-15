
import 'package:get/get.dart';
import 'package:restaurantpoint/helper/local_storage_data.dart';
import 'package:restaurantpoint/service/view_model/auth_view_model.dart';
import 'package:restaurantpoint/service/view_model/control_view_model.dart';
import 'package:restaurantpoint/service/view_model/home_view_model.dart';

class Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthViewModel());
    Get.lazyPut(() => ControlViewModel());
    Get.lazyPut(() => HomeViewModel(),fenix: true);
   // Get.lazyPut(() => ProfileViewModel());
    Get.lazyPut(() => LocalStorageData());
  }
}
