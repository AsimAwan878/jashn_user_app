import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jashn_user/screens/bottomBar/profiles/setting.dart';
import 'package:jashn_user/styles/colors.dart';
import 'package:jashn_user/styles/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../styles/api_handler.dart';
import 'edit_profile.dart';
import 'help.dart';
import 'wallet/jashn_wallet.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:developer' as developer;
import 'dart:async';
import 'package:flutter/services.dart';

class Profiles extends StatefulWidget {
  @override
  _ProfilesState createState() => _ProfilesState();
}

class _ProfilesState extends State<Profiles> {
  bool isInitializing = false;
  bool isAmountInitializing = false;
  bool isDelaying = false;
  bool isConnected = false;
  bool isInternetDown = false;

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    Future.delayed(const Duration(seconds: 2), () {
      setStateIfMounted(() {
        isDelaying = true;
      });
    });

    super.initState();
  }
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
      print("Connection Successfull");
    } on PlatformException catch (e) {
      print("Connection unsuccessfull");
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    _connectionStatus = result;
    if (_connectionStatus.toString() != "ConnectivityResult.none" &&
        isConnected == false) {
      print(_connectionStatus.toString());
      isConnected = true;
      _getData().whenComplete(() {
        setStateIfMounted(() {
          isInitializing=true;
        });
      });
      _getAmount().whenComplete(() {
        setStateIfMounted(() {
          isAmountInitializing = true;
        });
      });

    }
    if (_connectionStatus.toString() != "ConnectivityResult.none") {
      print("In third condition");
      print(_connectionStatus.toString());
      isInternetDown = false;
      print(isInternetDown.toString());
    } else if (_connectionStatus.toString() == "ConnectivityResult.none") {
      print(_connectionStatus.toString());
      isInternetDown = true;
      print(isInternetDown.toString());
    }
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  var name;
  var email;
  var token;
  var id;
  var phone;
  var myImage;
  var totalAmount;
  var isSocial;

  Future<void> _getData() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    name = _prefs.getString("name");
    email = _prefs.getString("email");
    token = _prefs.getString("token");
    id = _prefs.getString("customer_id");
    phone = _prefs.getString("phone");
    myImage = _prefs.getString("image");
    isSocial=_prefs.getString("IsSocial");
  }

  Future _getAmount() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    id = _prefs.getString("customer_id");
    token = _prefs.getString("token");

    Handler handler = Handler('user/mywallet?customer_id=$id');
    String url1 = handler.getUrl();

    print("Click on fetch data");

    var response = await http.get(Uri.parse(url1),
        headers: ({
          "Authorization": "Bearer ${token.toString()}",
        }));

    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      if (jsonBody["success"] == true) {
        setState(() {
          totalAmount = jsonBody["wallet"];
        });
      } else if (jsonBody["success"] == false) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(jsonBody["message"])));
      }
    } else {
      print(response.body);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Server Error!")));
    }
  }

  Widget _widget() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double scalefactor = MediaQuery.of(context).textScaleFactor;
    print("Is socaial = ${isSocial.toString()}");

    return Scaffold(
      body: Visibility(
        visible: isDelaying,
        replacement: loadingCard(width, height),
        child: Visibility(
          visible: isInternetDown == false || isConnected,
          replacement: Container(
            width: width,
            height: height,
            color: Constants.textColour4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/sad-face-in-rounded-square.png",color: Constants.textColour1,height: 50,width: 50,fit: BoxFit.cover,),
                SizedBox(height: 20,),
                Center(child: Text(
                  "OOPS !",
                  style: homeTextTheme().bodyText1,
                  textAlign: TextAlign.center,
                ),),
                SizedBox(height: 20,),
                Center(child: Text(
                  "No Internet Connection...",
                  style: textTheme().subtitle1,
                  textAlign: TextAlign.center,
                ),),
              ],
            ),
          ),
          child: Visibility(
            visible: isInitializing && isAmountInitializing,
            replacement: loadingCard(width, height),
            child: Column(
              children: [
                Material(
                  elevation: 2,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40)),
                  child: Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: width,
                            height: 270,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Constants.buttonColourMix2,
                                    Constants.buttonColourMix3,
                                    Constants.buttonColourMix4,
                                    Constants.buttonColourMix1,
                                  ],
                                  begin: const FractionalOffset(0.2, 0.0),
                                  // end: const FractionalOffset(0.0, 1.0),
                                ),
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(40),
                                    bottomRight: Radius.circular(40))),
                            child:  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(name.toString().toUpperCase(),
                                          style: homeTextTheme().bodyText1),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(email.toString(),
                                          style: textTheme().subtitle1)
                                    ],
                                  ),
                          ),
                        ],
                      ),
                      Transform.translate(
                        offset: Offset(width/2.6, height / 3.7),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 52,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Constants.buttonColourMix1,
                                  child: myImage == null
                                          ? SizedBox(
                                              width: 40,
                                              height: 40,
                                              child: Image.asset(
                                                "assets/photo.png",
                                                color: Colors.grey.shade600,
                                              ))
                                          : ClipRRect(
                                    borderRadius: BorderRadius.circular(50.0),
                                    child: CachedNetworkImage(
                                      width: 100,
                                      height: 100,
                                      progressIndicatorBuilder: (context, url, progress) => Center(
                                        child: CircularProgressIndicator(
                                          value: progress.progress,
                                        ),
                                      ),
                                      imageUrl:myImage,
                                      fit: BoxFit.cover,
                                      alignment: Alignment.center,
                                    ),
                                  ),),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                // Material(
                //   elevation: 2,
                //   borderRadius: BorderRadius.only(
                //       bottomLeft: Radius.circular(40),
                //       bottomRight: Radius.circular(40)),
                //   child: Container(
                //     decoration: BoxDecoration(
                //         borderRadius: BorderRadius.only(
                //             bottomLeft: Radius.circular(40),
                //             bottomRight: Radius.circular(40))),
                //     height: height / 2.75,
                //     child: Stack(
                //       alignment: Alignment.topLeft,
                //       children: [
                //         Column(
                //           mainAxisAlignment: MainAxisAlignment.start,
                //           children: [
                //             Container(
                //               width: width,
                //               height: height / 3,
                //               decoration: BoxDecoration(
                //                   gradient: LinearGradient(
                //                     colors: [
                //                       Constants.buttonColourMix2,
                //                       Constants.buttonColourMix3,
                //                       Constants.buttonColourMix4,
                //                       Constants.buttonColourMix1,
                //                     ],
                //                     begin: const FractionalOffset(0.2, 0.0),
                //                     // end: const FractionalOffset(0.0, 1.0),
                //                   ),
                //                   borderRadius: BorderRadius.only(
                //                       bottomLeft: Radius.circular(40),
                //                       bottomRight: Radius.circular(40))),
                //               child:  Column(
                //                 mainAxisAlignment: MainAxisAlignment.center,
                //                 children: [
                //                   Text(name.toString().toUpperCase(),
                //                       style: homeTextTheme().bodyText1),
                //                   SizedBox(
                //                     height: 10,
                //                   ),
                //                   Text(email.toString(),
                //                       style: textTheme().subtitle1)
                //                 ],
                //               ),
                //             ),
                //           ],
                //         ),
                //         Transform.translate(
                //           offset: Offset(width/2.7, height / 3.7),
                //           child: Column(
                //             mainAxisAlignment: MainAxisAlignment.start,
                //             crossAxisAlignment: CrossAxisAlignment.center,
                //             children: [
                //               CircleAvatar(
                //                 radius: 52,
                //                 backgroundColor: Colors.white,
                //                 child: CircleAvatar(
                //                     radius: 50,
                //                     backgroundColor: Constants.buttonColourMix1,
                //                     child: myImage == null
                //                         ? SizedBox(
                //                         width: 40,
                //                         height: 40,
                //                         child: Image.asset(
                //                           "assets/photo.png",
                //                           color: Colors.grey.shade600,
                //                         ))
                //                         : Container(
                //                       width: 100,
                //                       height: 100,
                //                       decoration: BoxDecoration(
                //                           borderRadius:
                //                           BorderRadius.circular(50),
                //                           image: DecorationImage(
                //                               image: NetworkImage(myImage),
                //                               fit: BoxFit.cover)),
                //                     )),
                //               ),
                //             ],
                //           ),
                //         )
                //       ],
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: 22,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                           Text(
                                  'PKR ${totalAmount.toString()}',
                                  style: TextStyle(
                                      fontFamily: "Segoe UI",
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20 * scalefactor),
                                ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Available balance',
                            style: TextStyle(
                                fontFamily: "Segoe UI",
                                color: Colors.grey,
                                fontWeight: FontWeight.normal,
                                fontSize: 12 * scalefactor),
                          )
                        ],
                      ),
                      Spacer(),
                      // Container(
                      //   height: 30,
                      //   width: 1,
                      //   color: Colors.grey,
                      // ),
                      Spacer(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            'assets/sad.png',
                            width: 25,
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            ' Experiences',
                            style: TextStyle(
                                fontFamily: "Segoe UI",
                                color: Colors.grey,
                                fontWeight: FontWeight.normal,
                                fontSize: 12 * scalefactor),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22.0),
                    child: ListView(
                      children: [
                        ListTile(
                          leading: Image.asset(
                            'assets/book.png',
                            width: 33,
                            height: 28,
                            fit: BoxFit.fill,
                          ),
                          title: Text('Jash\'n wallet',
                              style: TextStyle(
                                  fontFamily: "Segoe UI",
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12 * scalefactor)),
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => JashnWallet(name: name.toString(),)));
                          },
                        ),
                        ListTile(
                          leading: Image.asset(
                            'assets/user1.png',
                            width: 33,
                            height: 28,
                            fit: BoxFit.fill,
                          ),
                          title: Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              Text('Edit profile',
                                  style: TextStyle(
                                      fontFamily: "Segoe UI",
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12 * scalefactor)),
                              isSocial =="1" ?Container(width: width,height: 20,color: Colors.white54,) :SizedBox(),
                            ],
                          ),
                          onTap: () {
                            if(isSocial =="0")
                              {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditProfile(
                                          email: email,
                                          token: token,
                                          myName: name,
                                          phone: phone,
                                          myId: id,
                                          myImage: myImage,
                                        )));
                              }

                          },
                        ),
                        // ListTile(
                        //   leading: Image.asset('assets/present-box.png'),
                        //   title: Text('Refer friends',
                        //       style: TextStyle(
                        //           color: Colors.black,
                        //           fontWeight: FontWeight.w700,
                        //           fontSize: 14 * scalefactor)),
                        //   onTap: () {
                        //     Navigator.pushReplacement(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => Refer_And_Earn()));
                        //   },
                        // ),
                        // ListTile(
                        //   leading: Image.asset('assets/promo.png'),
                        //   title: Text('Promo codes',
                        //       style: TextStyle(
                        //           color: Colors.black,
                        //           fontWeight: FontWeight.w700,
                        //           fontSize: 14 * scalefactor)),
                        //   onTap: () {
                        //     Navigator.pushReplacement(context,
                        //         MaterialPageRoute(builder: (context) => Promo_Codes()));
                        //   },
                        // ),
                        ListTile(
                          leading: Image.asset(
                            'assets/help.png',
                            width: 33,
                            height: 28,
                            fit: BoxFit.fill,
                          ),
                          title: Text('Help',
                              style: TextStyle(
                                  fontFamily: "Segoe UI",
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12 * scalefactor)),
                          onTap: () {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) => Help(
                                  email: email,
                                  token: token,
                                  myName: name,
                                  phone: phone,
                                  myId: id,
                                )));
                          },
                        ),
                        ListTile(
                          leading: Image.asset(
                            'assets/settings.png',
                            width: 33,
                            height: 28,
                            fit: BoxFit.fill,
                          ),
                          title: Text('Settings',
                              style: TextStyle(
                                  fontFamily: "Segoe UI",
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12 * scalefactor)),
                          onTap: () {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) => Setting(isSocial: isSocial,)));
                          },
                        ),

                        // ListTile(
                        //   leading: Image.asset('assets/help.png'),
                        //   title: Text('Help',
                        //       style: TextStyle(
                        //           color: Colors.black,
                        //           fontWeight: FontWeight.w700,
                        //           fontSize: 14 * scalefactor)),
                        //   onTap: () {
                        //     Navigator.pushReplacement(context,
                        //         MaterialPageRoute(builder: (context) => Help()));
                        //   },
                        // ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column loadingCard(double width, double height) {
    return Column(
      children: [
        Material(
          elevation: 2,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40)),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40))),
            height: height / 2.8,
            width: width,
            child: Stack(
              alignment: Alignment.topLeft,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Skeleton(
                        width: width,
                        height: height / 3,
                        decoration: BorderRadius.only(
                            bottomLeft: Radius.circular(40),
                            bottomRight: Radius.circular(40))),
                  ],
                ),
                Transform.translate(
                  offset: Offset(width / 2.5, height / 3.7),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.all(Radius.circular(50.0)))
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 22,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Skeleton(
                      height: 40,
                      width: width * 0.25,
                      decoration: BorderRadius.all(Radius.circular(2.0))),
                  SizedBox(
                    height: 5,
                  ),
                  Skeleton(
                      height: 10,
                      width: width * 0.2,
                      decoration: BorderRadius.all(Radius.circular(2.0))),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Skeleton(
                      height: 40,
                      width: width * 0.25,
                      decoration: BorderRadius.all(Radius.circular(2.0))),
                  SizedBox(
                    height: 5,
                  ),
                  Skeleton(
                      height: 10,
                      width: width * 0.2,
                      decoration: BorderRadius.all(Radius.circular(2.0))),
                ],
              ),
            ],
          ),
        ),
        Expanded(
            child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 32.0, vertical: 32.0),
                child: ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(
                    height: 20,
                  ),
                  itemCount: 4,
                  itemBuilder: (context, index) => Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Skeleton(
                          height: 40,
                          width: 40,
                          decoration: BorderRadius.all(Radius.circular(2))),
                      SizedBox(
                        width: 10,
                      ),
                      Skeleton(
                          height: 30,
                          width: width * 0.65,
                          decoration: BorderRadius.all(Radius.circular(2.0)))
                    ],
                  ),
                ))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final md = MediaQuery.of(context);
    if (md.orientation == Orientation.landscape) {
      return _widget();
    }
    return _widget();
  }
  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
}

class Skeleton extends StatelessWidget {
  const Skeleton(
      {Key? key,
        required this.height,
        required this.width,
        required this.decoration})
      : super(key: key);

  final double height, width;
  final BorderRadiusGeometry decoration;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.04), borderRadius: decoration));
  }

}
