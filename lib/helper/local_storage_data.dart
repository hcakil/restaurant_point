

import 'dart:convert';

import 'package:get/get.dart';
import 'package:restaurantpoint/customs/utils/constants.dart';
import 'package:restaurantpoint/models/my_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageData extends GetxController{


  Future<MyUser> get getUser async {
    try{

      MyUser userModel = await _getUserData();

      if(userModel == null){
        return null;
      }
      return userModel;

    }
    catch(e){
      print(e.toString());
      return null;
    }
  }


  _getUserData()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

   var value =  prefs.getString(CACHED_USER_DATA);

   return MyUser.fromMap(json.decode(value));

  }

  setUser(MyUser user)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    
    await prefs.setString(CACHED_USER_DATA, json.encode(user.toMap()));

  }

 void deleteUser() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
