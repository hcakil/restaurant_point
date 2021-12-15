import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurantpoint/customs/utils/colors.dart';
import 'package:restaurantpoint/helper/local_storage_data.dart';
import 'package:restaurantpoint/helper/shared_prefs.dart';
import 'package:restaurantpoint/models/my_user.dart';
import 'package:restaurantpoint/pages/landing_page.dart';
import 'package:restaurantpoint/service/firestore_user.dart';

class AuthViewModel  extends GetxController {
  //GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  FirebaseAuth _auth = FirebaseAuth.instance;


  String email, sifre;

  Rx<User> _user = Rx<User>();

  String get user => _user.value?.email;

  final LocalStorageData localStorageData = Get.find();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _user.bindStream(_auth.authStateChanges());
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  void signInWithEmailAndPassword() async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: sifre).then((value)async{
        await FireStoreUser().getCurrentUser(value.user.uid).then((value) {
          setUser(MyUser.fromMap(value.data()));
        });
      });
      Get.offAll(LandingPage());
    } catch (e) {
      print(e.message);
      print("hata kullanıcı girişi");
      Get.snackbar(
        'Kullanıcı Girişi Hata',
        e.message,
        colorText: Colors.red,
        snackPosition: SnackPosition.TOP,
      );
    }
  }





  void createAccountWithEmailAndPassword() async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: sifre)
          .then((user) async {
        saveUser(user);
      });

      Get.offAll(LandingPage());
    } catch (e) {
      print(e.message);
      print("hata kullanici olusturma");
      Get.snackbar(
        'Hesap oluşturma Hata',
        e.message,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  void saveUser(UserCredential user) async {
    MyUser userModel = MyUser(
      userID: user.user.uid,
      email: user.user.email,
      //name: name == null ? user.user.displayName : name,
      // pic: '',
    );
    await FireStoreUser().addUserToFireStore(userModel);
    setUser(userModel);
  }

  void setUser(MyUser userModel)async{

    MySharedPreferences.instance.setStringValue("userId",userModel.userID);
    MySharedPreferences.instance.setStringValue("userLevel",userModel.seviye.toString());
    MySharedPreferences.instance.setStringValue("userEmail",userModel.email);
   await localStorageData.setUser(userModel);
  }
}
