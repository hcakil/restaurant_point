import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:restaurantpoint/customs/utils/keys.dart';
import 'package:restaurantpoint/helper/shared_prefs.dart';
import 'package:restaurantpoint/models/comment.dart';
import 'package:restaurantpoint/models/my_user.dart';
import 'package:restaurantpoint/pages/admin_page.dart';
import 'package:restaurantpoint/pages/comment_add_page.dart';
import 'package:restaurantpoint/pages/landing_page.dart';
import 'package:restaurantpoint/pages/login_page.dart';
import 'package:restaurantpoint/pages/qr_code_generate_page.dart';
import 'package:restaurantpoint/pages/qr_code_scan_page.dart';
import 'package:restaurantpoint/service/view_model/home_view_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FirstPage extends StatefulWidget {
  FirstPage({Key key, this.gelenAdresId, this.gelenAdresName, this.isNeed})
      : super(key: key);
  String gelenAdresId;

  String gelenAdresName;
  bool isNeed;

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  static final kInitialPosition = LatLng(39.9030394, 32.4825798);
  PickResult selectedPlace;
  bool commentVisibility = false;
  bool adminVisibility = false;
  String userEmail = null;

  @override
  void initState() {
    // TODO: implement initState

    getUser();
  }

  @override
  Widget build(BuildContext context) {

    // getUser();
    if (selectedPlace != null) {
      commentVisibility = true;
      widget.gelenAdresId = selectedPlace.placeId;
      widget.gelenAdresName = selectedPlace.formattedAddress;
    } else if (widget.gelenAdresId != null &&
        !widget.gelenAdresName.contains("Adres Yorumları")) {
      commentVisibility = true;
    } else if (widget.isNeed != null) {
      if (widget.isNeed == true) {
        // adminVisibility=true;
        getUser();
      }
    }

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
                title: Text("Restaurant Point"),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      // do something
                      controller.signOut();
                      MySharedPreferences.instance.removeAll();
                      Get.offAll(LoginPage());
                    },
                  )
                ],
              ),
              drawer: Drawer(
                // Add a ListView to the drawer. This ensures the user can scroll
                // through the options in the drawer if there isn't enough vertical
                // space to fit everything.
                child: ListView(
                  // Important: Remove any padding from the ListView.
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent.shade100,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            child: Image.asset("assets/images/user.png"),
                          ),
                          Text(
                            userEmail != null ? userEmail : 'Restaurant Point',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      title: const Text('Ana Sayfa'),
                      onTap: () async {
                        Navigator.of(context).pop();
                      },
                    ),
                    ListTile(
                      title: Text('QR Code Okut'),
                      onTap: () {
                        controller.loading.value = false;
                        Get.to(QrCodeScanPage());

                      },
                    ),
                    Visibility(
                      visible: adminVisibility,
                      child: ListTile(
                        title: Text('Onay Bekleyenler'),
                        onTap: () {
                          //controller.loading.value = false;


                          var placaID = selectedPlace != null
                              ? selectedPlace.placeId
                              : widget.gelenAdresId;

                          var placaName = selectedPlace != null
                              ? selectedPlace.formattedAddress
                              : widget.gelenAdresName;

                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) => AdminPage(
                                      gelenAdresId: placaID,
                                      gelenAdresName: placaName,
                                      isNeed: true)))
                              .then((value) => {setState(() {})});
                          /* Navigator.push(context, MaterialPageRoute(
                              builder: (context) => AdminPage(
                                gelenAdresId: placaID,
                                gelenAdresName: placaName,
                                isNeed:true

                             7 )),
                          );*/
                          /* Navigator.push(
                            context,
                            MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (context) => AdminPage()),
                          );*/
                        },
                      ),
                    ),
                    Divider(
                      thickness: 5,
                    ),
                    ListTile(
                      title: Text(
                        'Çıkış',
                        style: TextStyle(color: Colors.red),
                      ),
                      onTap: () {
                        // Update the state of the app
                        // ... controller.signOut();
                        //            Get.offAll(LoginPage());
                        controller.signOut();
                        MySharedPreferences.instance.removeAll();
                        Get.offAll(LoginPage());
                      },
                    ),
                  ],
                ),
              ),
              body: Stack(
                children: [
                  Container(
                    height: 150,
                    width: double.infinity,
                    //color: Colors.red,
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        selectedPlace == null
                            ? widget.gelenAdresName == null
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      child: Text("Konum Yok",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.purple,
                                              letterSpacing: 2,
                                              fontFamily: "Lobster")),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(widget.gelenAdresName ?? "",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.purple,
                                            letterSpacing: 2,
                                            fontFamily: "Lobster")),
                                  )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    selectedPlace.formattedAddress ?? "",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.purple,
                                        letterSpacing: 2,
                                        fontFamily: "Lobster")),
                              ),
                        // Center(child: Text("Yorumlar "))
                      ],
                    ),
                  ),
                  FutureBuilder<List<Comment>>(
                      future:
                          controller.getCommentsForPlace(widget.gelenAdresId),
                      builder: (context, postList) {
                        if (!postList.hasData) {
                          return Container(
                            child: Center(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.location_off,
                                      color: Theme.of(context).primaryColor,
                                      size: 80,
                                    ),
                                    Text(
                                      "Henüz Konum Yok",
                                      style: TextStyle(fontSize: 26),
                                    ),
                                  ]),
                            ),
                            height: MediaQuery.of(context).size.height - 150,
                          );
                        } else {
                          var tumPosts = postList.data;
                          if (tumPosts.length > 0) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 150.0),
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: tumPosts.length,
                                itemBuilder: (context, index) {
                                  var oAnkiAktivite = postList.data[index];

                                  return Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: double.infinity,

                                          //height: 85,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 5),

                                          child: Column(
                                            children: [
                                              Container(
                                                //height: 400,
                                                child: Stack(children: <Widget>[
                                                  Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 10.0),
                                                        child: Container(
                                                          // height: 60,
                                                          color: Colors.white,
                                                          width:
                                                              double.infinity,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10,
                                                                    top: 5),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    CircleAvatar(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .white,
                                                                      backgroundImage:
                                                                          AssetImage(
                                                                              "assets/images/user1.png"),
                                                                      //NetworkImage(oAnkiKlup.photoUrl),
                                                                      radius:
                                                                          20,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              oAnkiAktivite.userEmail == null ? "Misafir" : oAnkiAktivite.userEmail,
                                                                              style: TextStyle(
                                                                                fontSize: 20,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontFamily: "Lobster",
                                                                                color: Colors.deepPurple,
                                                                                letterSpacing: 1,
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            CircleAvatar(
                                                                              backgroundColor: Colors.grey,
                                                                              backgroundImage: AssetImage("assets/images/blue_tick.png"),
                                                                              radius: 10,
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors
                                                              .transparent,
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          20)),
                                                          boxShadow: const [
                                                            BoxShadow(
                                                                color: Colors
                                                                    .blueAccent,
                                                                blurRadius: 10,
                                                                offset: Offset(
                                                                    1, 1)),
                                                          ],
                                                          border: Border.all(
                                                              color: Colors
                                                                  .blueAccent,
                                                              width: 1),
                                                          image: DecorationImage(
                                                              image: oAnkiAktivite
                                                                          .photoUrl ==
                                                                      null
                                                                  ? NetworkImage(
                                                                      "https://digitalpratix.com/wp-content/uploads/resimsec.png")
                                                                  : NetworkImage(
                                                                      oAnkiAktivite
                                                                          .photoUrl),
                                                              fit: BoxFit.fill),
                                                        ),
                                                        height: 250.0,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Flexible(
                                                              child: Text(
                                                                oAnkiAktivite
                                                                    .comment,
                                                                maxLines: 3,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontFamily:
                                                                      "Lobster",
                                                                  color: Colors
                                                                      .deepPurple,
                                                                  letterSpacing:
                                                                      1,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 30,
                                                      )
                                                    ],
                                                  ),
                                                ]),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          } else {
                            return RefreshIndicator(
                              onRefresh: _kluplerListesiniYenile,
                              child: SingleChildScrollView(
                                physics: AlwaysScrollableScrollPhysics(),
                                child: Container(
                                  child: Center(
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.flash_on,
                                            color:
                                                Theme.of(context).primaryColor,
                                            size: 80,
                                          ),
                                          Text(
                                            "Henüz Gönderi Yok",
                                            style: TextStyle(fontSize: 26),
                                          ),
                                        ]),
                                  ),
                                  height:
                                      MediaQuery.of(context).size.height - 150,
                                ),
                              ),
                            );
                          }
                        }
                      })
                ],
              ),
              floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Visibility(
                    visible: commentVisibility,
                    child: FloatingActionButton(
                      heroTag: "hero1",
                      backgroundColor: Colors.blue,
                      child: InkWell(
                        child: Icon(Icons.qr_code),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => QRCodeGeneratePage(
                                    gelenAdresId: selectedPlace.placeId,
                                    gelenAdresName:
                                        selectedPlace.formattedAddress,
                                  )));
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: FloatingActionButton(
                      heroTag: "hero2",
                      backgroundColor: Colors.green,
                      child: InkWell(
                        child: Icon(Icons.map),
                        onTap: () {
                          openMap(context);
                        },
                      ),
                    ),
                  ),
                  Visibility(
                    visible: commentVisibility,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: FloatingActionButton(
                        heroTag: "hero3",
                        backgroundColor: Colors.red,
                        child: InkWell(
                          child: Icon(Icons.comment),
                          onTap: () async {
                            var placaID = selectedPlace != null
                                ? selectedPlace.placeId
                                : widget.gelenAdresId;

                            var placaName = selectedPlace != null
                                ? selectedPlace.formattedAddress
                                : widget.gelenAdresName;

                            controller.checkComment().then((value) {
                              if(value)
                                {
                                  Future.delayed(Duration(milliseconds: 300))
                                      .then((value) {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => CommentAddPage(
                                            gelenAdresId: placaID,
                                            //selectedPlace.placeId,
                                            gelenAdresName: placaName,
                                            //selectedPlace.formattedAddress,
                                            isAdmin: commentVisibility)));
                                  });
                                }
                              else {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      Future.delayed(Duration(seconds: 2), () {
                                        Navigator.of(context).pop();
                                      });
                                      return Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top: 200),
                                            child: AlertDialog(
                                              backgroundColor: Colors.white70,
                                              content: SingleChildScrollView(
                                                child: Text(
                                                  "Onaylanmamış yorumunuz vardır. Onay Sonrası Tekrar Deneyiniz !!",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black,
                                                    letterSpacing: 2,
                                                    //fontFamily: "Lobster"
                                                  ),
                                                ),
                                              ),
                                              // shape: ContinuousRectangleBorder(),
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                              }
                            });



                            //  openMap(context);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }

  void openMap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return PlacePicker(
            apiKey: APIKeys.apiKey,
            initialPosition: kInitialPosition,
            useCurrentLocation: true,
            selectInitialPosition: true,

            //usePlaceDetailSearch: true,
            onPlacePicked: (result) {
              selectedPlace = result;
              Navigator.of(context).pop();
              setState(() {});
            },
          );
        },
      ),
    );
  }

  Future<Null> _kluplerListesiniYenile() async {
    setState(() {});
    await Future.delayed(Duration(seconds: 1));

    return null;
  }

  Future<void> getUser() {

    MySharedPreferences.instance.getStringValue("userEmail").then((value) {
      userEmail = value;


      MySharedPreferences.instance.getStringValue("userLevel").then((value) {
        if (value.contains("2")) adminVisibility = true;
      });
    });
  }
}
