

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:restaurantpoint/helper/local_storage_data.dart';

class ProfileViewModel extends GetxController{

  final LocalStorageData localStorageData = Get.find();

  Future<void> signOut ()async{
    FirebaseAuth.instance.signOut();

    localStorageData.deleteUser();

}
}
