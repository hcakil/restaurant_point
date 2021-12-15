import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurantpoint/pages/main_page.dart';
import 'package:restaurantpoint/pages/login_page.dart';
import 'package:restaurantpoint/service/view_model/auth_view_model.dart';
import 'package:restaurantpoint/service/view_model/control_view_model.dart';

class LandingPage extends GetWidget<AuthViewModel> {


  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return (Get.find<AuthViewModel>().user == null)
          ? LoginPage()
          : GetBuilder <ControlViewModel>(

            init: ControlViewModel(),
            builder:(controller)=> Scaffold(
                body: FirstPage(gelenAdresName: null,gelenAdresId: null,),//controller.currentScreen,
               // bottomNavigationBar: bottomNavigationBar(),
              ),
          );
    });
  }


}
