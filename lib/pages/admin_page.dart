import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:restaurantpoint/customs/fade_animation.dart';
import 'package:restaurantpoint/models/comment.dart';
import 'package:restaurantpoint/pages/landing_page.dart';
import 'package:restaurantpoint/pages/main_page.dart';
import 'package:restaurantpoint/service/view_model/home_view_model.dart';

class AdminPage extends StatefulWidget {
  AdminPage({Key key, this.gelenAdresId, this.gelenAdresName, this.isNeed})
      : super(key: key);
  String gelenAdresId;

  String gelenAdresName;
  bool isNeed;
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {

  @override
  void dispose() {
    // TODO: implement dispose
   print("admin dispose çalıştı");

   //Get.offAll(() => LandingPage());
    super.dispose();

  }


  @override
  Widget build(BuildContext context) {


    return GetBuilder<HomeViewModel>(
        init: HomeViewModel(),
        builder: (controller) {
          if (controller.loading.value == true)
            return Center(
              child: CircularProgressIndicator(),
            );
          else {
            return Scaffold(
              //backgroundColor: Colors.white70,
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: (){
                   _backMethod(controller,context);
                    }
                    ),
                title: Text("Onay Bekleyenler"),
              ),

              body: Stack(
                children: [
                  FutureBuilder<List<Comment>>(
                      future: controller.getCommentsForResponse(),
                      builder: (context, postList) {
                        if (!postList.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          var tumComments = postList.data;
                          if (tumComments.length > 0) {
                            return RefreshIndicator(
                              onRefresh: _kluplerListesiniYenile,
                              child: ListView.builder(
                                itemCount: tumComments.length,
                                itemBuilder: (context, index) {
                                  var oAnkiKlup = tumComments[index];
                                  return GestureDetector(
                                    onTap: () {},
                                    child: FadeAnimation(
                                      2,
                                      Container(
                                        width: double.infinity,
                                        height: 85,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 5),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 0),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.blueGrey,
                                                width: 1),
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Colors.blueGrey,
                                                  blurRadius: 10,
                                                  offset: Offset(1, 1)),
                                            ],
                                            color: Colors.blueGrey.shade100,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20))),
                                        child: Container(
                                            child: ListTile(
                                          onTap: () {},
                                          title: Text(oAnkiKlup.userEmail,
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.purple,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 2,
                                                  fontFamily: "OpenSans")),

                                          leading: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                oAnkiKlup.photoUrl),
                                            radius: 30,
                                            backgroundColor: Colors.white,
                                          ),
                                          subtitle: Text(
                                            oAnkiKlup.comment,
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic),
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              InkWell(
                                                onTap: () async {
                                                  await controller
                                                      .approveDenyRequest(
                                                          "approved",
                                                          oAnkiKlup);
                                                },
                                                child: Container(
                                                  height: 40,
                                                  child: Image.asset(
                                                      "assets/images/check.png"),
                                                ),
                                              ),
                                              // Icon(Icons.add_box,size: 30,),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              InkWell(
                                                  onTap: () async {
                                                    await controller
                                                        .approveDenyRequest(
                                                            "denied",
                                                            oAnkiKlup);
                                                    //_kluplerListesiniYenile();
                                                  },
                                                  child: Container(
                                                      height: 40,
                                                      child: Image.asset(
                                                          "assets/images/denied.png"))),
                                            ],
                                          ), //Text(oAnkiUser.aradakiFark),
                                        )),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          } else {
                            return bosWidget(context);
                          }
                        }
                      })
                ],
              ),
            );
          }
        });
  }

  Widget bosWidget(BuildContext context) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Container(
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(
              Icons.flash_on,
              color: Theme.of(context).primaryColor,
              size: 80,
            ),
            Text(
              "Onay Bekleyen Yorum Yok",
              style: TextStyle(fontSize: 26),
            ),
          ]),
        ),
        height: MediaQuery.of(context).size.height - 150,
      ),
    );
  }

  Future<Null> _kluplerListesiniYenile() async {
    setState(() {});
    await Future.delayed(Duration(seconds: 1));

    return null;
  }


   _backMethod(HomeViewModel controller,BuildContext context1) async {
    Future.delayed(Duration(milliseconds: 500)).then((value) {
      controller.loading.value=false;
     // controller.update();
    //  Navigator.push(context, MaterialPageRoute(builder: (context) => LandingPage()));
      Navigator.of(context1).pop();
      //Get.offAll(() => LandingPage());
    });
  }
}
