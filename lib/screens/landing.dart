import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jashn_user/screens/login.dart';
import 'package:jashn_user/styles/colors.dart';
import 'package:jashn_user/styles/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'forsignup.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:developer' as developer;
import 'dart:async';
import 'package:flutter/services.dart';

class Landing extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LandingState();
  }
}

class LandingState extends State<Landing> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  var myToken;
  var id;
  bool isLoading = false;
  bool isConnected = false;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;


  @override
  void initState() {
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    Future.delayed(const Duration(seconds: 5), () {
      setStateIfMounted(() {
        isLoading = true;
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
      _getToken().whenComplete(() {
        setStateIfMounted(() {
          isConnected = true;
        });
      });
    }
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  Future<void> _getToken() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    myToken = _pref.getString("token");
    id = _pref.getString("customer_id");
    _firebaseMessaging.getToken().then((token) {
      print("Token = \n\n\n\n\n\n\n\n{$token} \n\n\n\n\n\n\n\n");
      print("Token = \n\n\n\n\n\n\n\n{$myToken} \n\n\n\n\n\n\n\n");
      print("Token = \n\n\n\n\n\n\n\n{$id} \n\n\n\n\n\n\n\n");
      _pref.setString("fcm", token.toString());
    });
  }

  Widget _widget() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // double scaleFactor = MediaQuery.of(context).textScaleFactor;

    return SafeArea(
      child: Scaffold(
        body: WillPopScope(
          onWillPop: onWillPop,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/splash-1.png"),
                    fit: BoxFit.fill)),
            child:  Visibility(
              visible: isLoading,
              replacement: Center(
                child: CupertinoActivityIndicator(
                  color: Constants.textColour6,
                  radius: 20.0,
                ),
              ),
              child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("JASH’N",
                                style: textTheme().bodyText1),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Experience unforgettable moments",
                                style: textTheme().subtitle1,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "with your favorite celebrity icons",
                                style: textTheme().subtitle1,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "through personalized videoss",
                                style: textTheme().subtitle1,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "and let the magic begin!",
                                style: textTheme().subtitle1,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              child: Container(
                                constraints: BoxConstraints(
                                    maxWidth: width / 3.6, minHeight: 45.0),
                                alignment: Alignment.center,
                                child: Text(
                                  "Sign Up",
                                  style: textTheme().button,
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUp()));
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                )),
                                backgroundColor: MaterialStateProperty.all(
                                    Constants.buttonColour1),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            ElevatedButton(
                              child: Container(
                                constraints: BoxConstraints(
                                    maxWidth: width / 3.6, minHeight: 45.0),
                                alignment: Alignment.center,
                                child: Text(
                                  "Login",
                                  style: textTheme().subtitle1,
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login()));
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30.0),
                                        side: BorderSide(
                                            color: Colors.white, width: 4.0))),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.black38),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          ),
        ),
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
