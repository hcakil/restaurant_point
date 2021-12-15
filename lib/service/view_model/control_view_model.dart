
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurantpoint/pages/main_page.dart';

class ControlViewModel extends GetxController{

  int _navigatorValue = 0;
  Widget _currentScreen = FirstPage();

  int get navigatorValue => _navigatorValue;


  Widget get currentScreen => _currentScreen;

  void changeSelectedValue (int selectedValue){
    _navigatorValue = selectedValue;
    switch(selectedValue){
      case 0 : {
        _currentScreen = FirstPage();
        break;
      }


    }
    update();

  }
}
