import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:jashn_user/models/updateLocation_model.dart';
import 'package:jashn_user/screens/bottomBar/profiles/profiles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../styles/api_handler.dart';
import '../../styles/colors.dart';
import '../../styles/strings.dart';
import 'experience.dart';
import 'home.dart';
import 'jashn_moments.dart';
import 'notification_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:developer' as developer;
import 'dart:async';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class BottomBar extends StatefulWidget {
  final int currentIndex;
  var categoryId;
  var categoryName;

  BottomBar({
    Key? key,
    required this.currentIndex,
    required this.categoryId,
    required this.categoryName,
  }) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

Future<UpdateLocation?> _updateLocation() async {
  Handler handler3 = Handler('user/updatelocation');
  String url3 = handler3.getUrl();
  var id;
  var lat;
  var long;
  var city;
  var token;

  SharedPreferences _prefs = await SharedPreferences.getInstance();
  id = _prefs.getString("customer_id");
  lat = _prefs.getString("lat");
  long = _prefs.getString("long");
  city = _prefs.getString("getCity");
  token = _prefs.getString("token");

  print("Click on Update data");
  var url = Uri.parse(url3);
  var response = await http.post(url,
      body: ({
        "customer_id": id.toString(),
        "city": city.toString(),
        "lat": lat.toString(),
        "long": long.toString(),
      }),
      headers: ({"Authorization": "Bearer ${token.toString()}"}));
  if (response.statusCode == 200) {
    var jsonBody = jsonDecode(response.body);
    if (jsonBody["success"] == true) {
      print("Update Location in bottom bar");
      UpdateLocation.fromJson(jsonBody);
    } else if (jsonBody["success"] == false) {
      return null;
      print("Failed to update Location");
    }
  } else {
    print("Request failed to response :${response.statusCode}");
    return null;
  }

}

class _BottomBarState extends State<BottomBar> {
  late UpdateLocation _updateLocationModel;
  int currentIndex = 0;
  var id;
  var lat;
  var long;
  var city;
  var token;

  bool isLoading1 = false;
  bool isConnected = false;
  bool isDelaying = false;
  bool isInternetDown = false;

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  List<String> myList = [];

  @override
  void initState() {
    currentIndex = widget.currentIndex;

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
      UpdateLocation? data=await _updateLocation();
      setStateIfMounted((){
        // _updateLocationModel=data!;
        isLoading1 = true;
      });
    }
    if (_connectionStatus.toString() != "ConnectivityResult.none") {
      print("In third condition");
      print(_connectionStatus.toString());
      setStateIfMounted((){
        isInternetDown = false;
      });

      print(isInternetDown.toString());
    } else if (_connectionStatus.toString() == "ConnectivityResult.none") {
      print(_connectionStatus.toString());
      setStateIfMounted((){
        isInternetDown = true;
      });
      print(isInternetDown.toString());
    }
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  /// Set a type current number a layout class
  Widget callPage(int current) {
    switch (current) {
      case 0:
        return HomeScreen(
          categoryName: widget.categoryName,
          categoryId: widget.categoryId,
        );
      case 1:
        return JashnMoments();
      case 2:
        return Experiences();
      case 3:
        return Profiles();
      case 4:
        return NotificationScreen();
      default:
        return HomeScreen(
          categoryName: widget.categoryName,
          categoryId: widget.categoryId,
        );
    }
  }

  Widget _widget() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // double scalefactor = MediaQuery.of(context).textScaleFactor;
    return SafeArea(
      child: WillPopScope(
        onWillPop: onWillPop,
        child: Visibility(
          visible: isDelaying,
          replacement: Scaffold(
            body: Center(
              child: CupertinoActivityIndicator(
                color: Constants.textColour6,
                radius: 20.0,
              ),
            ),
          ),
          child: Visibility(
            visible: isInternetDown == false|| isConnected,
            replacement: Scaffold(
              body: Container(
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
            ),
            child: Visibility(
              visible: isLoading1 && isConnected,
              replacement: Scaffold(
                body: loadingCard(width, height),
              ),
              child: Scaffold(
                      body: callPage(currentIndex),
                      floatingActionButton: Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          height: 40,
                          width: width * 0.7,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    currentIndex = 0;
                                  });
                                },
                                child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      Icons.home_outlined,
                                      color: currentIndex == 0
                                          ? Colors.black
                                          : Colors.grey,
                                    )),
                              ),
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      currentIndex = 1;
                                    });
                                  },
                                  child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.white,
                                      child: Image.asset(
                                        'assets/smile.png',
                                        color: currentIndex == 1
                                            ? Colors.black
                                            : Colors.grey,
                                        width: 21,
                                        height: 21,
                                      ))),
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      currentIndex = 2;
                                    });
                                  },
                                  child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.white,
                                      child: Image.asset(
                                        'assets/star.png',
                                        color: currentIndex == 2
                                            ? Colors.black
                                            : Colors.grey,
                                        width: 21,
                                        height: 21,
                                      ))),
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      currentIndex = 3;
                                    });
                                  },
                                  child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.white,
                                      child: Image.asset(
                                        'assets/user.png',
                                        color: currentIndex == 3
                                            ? Colors.black
                                            : Colors.grey,
                                        width: 21,
                                        height: 21,
                                      ))),
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      currentIndex = 4;
                                    });
                                  },
                                  child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.white,
                                      child: Icon(
                                        Icons.notifications_none,
                                        color: currentIndex == 4
                                            ? Colors.black
                                            : Colors.grey,
                                      ))),
                            ],
                          ),
                        ),
                      ),
                      floatingActionButtonLocation:
                          FloatingActionButtonLocation.centerFloat,
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Container loadingCard(double width, double height) {
    return Container(
      width: width,
      height: height,
      color: Constants.textColour1,
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Skeleton(
                height: 40,
                width: width,
                decoration: BorderRadius.all(Radius.circular(40))),
          ),
          Container(
            width: width,
            height: height * 0.3,
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.02,
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Center(
                      child: Container(
                        width: width,
                        height: height * 0.25,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                spreadRadius: 5,
                                blurRadius: 5,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                            color: Constants.textColour1,
                            borderRadius: BorderRadius.circular(32)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 22.0, vertical: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Skeleton(
                                  height: 50,
                                  width: width * 0.2,
                                  decoration:
                                      BorderRadius.all(Radius.circular(2.0))),
                              Spacer(),
                              Row(
                                children: [
                                  Skeleton(
                                      height: 20,
                                      width: width * 0.3,
                                      decoration: BorderRadius.all(
                                          Radius.circular(2.0))),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Icon(
                                    FontAwesomeIcons.rightLong,
                                    color: Constants.textColour2,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                            width: width,
                            height: height * 0.15,
                            decoration: BoxDecoration(
                              color: Constants.textColour1,
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Skeleton(
                                      width: width * 0.2,
                                      height: height * 0.12,
                                      decoration: BorderRadius.all(
                                          Radius.circular(25.0))),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Skeleton(
                                      width: width * 0.2,
                                      height: height * 0.12,
                                      decoration: BorderRadius.all(
                                          Radius.circular(25.0))),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Skeleton(
                                      width: width * 0.2,
                                      height: height * 0.12,
                                      decoration: BorderRadius.all(
                                          Radius.circular(25.0))),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Skeleton(
                                      width: width * 0.2,
                                      height: height * 0.12,
                                      decoration: BorderRadius.all(
                                          Radius.circular(25.0))),
                                ],
                              ),
                            )),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.02,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Skeleton(
                              width: width * 0.4,
                              height: height / 4.5,
                              decoration: BorderRadius.circular(10.0)),
                          Skeleton(
                              width: width * 0.4,
                              height: height / 4.5,
                              decoration: BorderRadius.circular(10.0)),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Skeleton(
                              width: width * 0.4,
                              height: height / 4.5,
                              decoration: BorderRadius.circular(10.0)),
                          Skeleton(
                              width: width * 0.4,
                              height: height / 4.5,
                              decoration: BorderRadius.circular(10.0)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> onWillPop() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Constants.textColour1,
        content: Text(
          'Are you sure you want to exit?',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: "Segoe UI",
              color: Constants.textColour5),
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () async {
              exit(0);
            },
            child: Container(
              width: 60,
              height: 40,
              alignment: Alignment.center,
              child: Text(
                "Yes",
                style: TextStyle(
                    color: Constants.textColour1,
                    fontFamily: "Segoe UI",
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ),
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              )),
              backgroundColor:
                  MaterialStateProperty.all(Constants.buttonColourMix4),
            ),
          ),
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'No',
              style: TextStyle(color: Constants.textColour5),
            ),
          ),
        ],
      ),
    ).then((x) => x ?? false);
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
    print("Dispose State called");
    _connectivitySubscription.cancel();
    super.dispose();
  }
}
