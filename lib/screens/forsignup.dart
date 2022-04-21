import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jashn_user/screens/bottomBar/bottom_bar.dart';
import 'package:jashn_user/screens/signUp.dart';
import 'package:jashn_user/styles/colors.dart';
import 'package:jashn_user/styles/strings.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../provider_class.dart';
import '../styles/api_handler.dart';
import 'landing.dart';
import 'login.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:developer' as developer;
import 'dart:async';
import 'package:flutter/services.dart';

class SignUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SignUpState();
  }
}

class SignUpState extends State<SignUp> {
  static Handler handler = Handler('auth/sociallogin');
  static String url = handler.getUrl();

  var fcmToken;
  var lat;
  var long;
  var cityName;

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
      isConnected = false;
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

  Widget _widget() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double scaleFactor = MediaQuery.of(context).textScaleFactor;

    return SafeArea(
      child: Scaffold(
        body: WillPopScope(
          onWillPop: onWillPop,
          child: Visibility(
            visible: isDelaying,
            replacement: Center(
              child: CupertinoActivityIndicator(
                color: Constants.textColour6,
                radius: 20.0,
              ),
            ),
            child: ChangeNotifierProvider(
              create: (context) => MyProvider(),
              child: StreamBuilder(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    final provider = Provider.of<MyProvider>(context);
                    if (provider.isSigningIn) {
                      return buildLoading();
                    } else if (snapshot.hasData) {
                      _apiHit();
                      return buildLoading();
                    } else {
                      return Container(
                        width: width,
                        height: height,
                        color: Colors.white,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                width: width,
                                height: 290,
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
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: height * 0.06,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "WELCOME TO",
                                          style: textTheme().subtitle2,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Image.asset(
                                          "assets/logo.png",
                                          height: 46,
                                          width: 174,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Text(
                                      "Jash’n brings you a surprising opportunity",
                                      style: textTheme().bodyText2,
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "to engage with your favorite celebrities.",
                                      style: textTheme().bodyText2,
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "So, what are you still waiting for?",
                                      style: textTheme().bodyText2,
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Register Now!",
                                      style: textTheme().bodyText2,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: height * 0.1,
                              ),
                              ElevatedButton(
                                child: Container(
                                  constraints: BoxConstraints(
                                      maxWidth: width / 1.3, maxHeight: 50.0),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: width * 0.1,
                                      ),
                                      SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: Image.asset(
                                              "assets/facebook.png")),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text("Sign Up With Facebook",
                                          style: textTheme().subtitle1),
                                      Spacer(),
                                    ],
                                  ),
                                ),
                                onPressed: () {
                                  if (isInternetDown==false) {
                                    print("OnPressed");
                                    print(url);
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                            content: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.wifi_off,
                                          color: Constants.textColour1,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text("You are currently offline."),
                                      ],
                                    )));
                                  }
                                },
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  )),
                                  backgroundColor: MaterialStateProperty.all(
                                      Constants.buttonColour2),
                                ),
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),
                              ElevatedButton(
                                child: Container(
                                  constraints: BoxConstraints(
                                      maxWidth: width / 1.3, maxHeight: 50.0),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: width * 0.1,
                                      ),
                                      SizedBox(
                                          width: 20,
                                          height: 20,
                                          child:
                                              Image.asset("assets/google.png")),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text("Sign Up With Google",
                                          style: textTheme().subtitle1),
                                      Spacer(),
                                    ],
                                  ),
                                ),
                                onPressed: () {
                                  if (isInternetDown==false) {
                                    print("OnPressed");
                                    final provider = Provider.of<MyProvider>(
                                        context,
                                        listen: false);
                                    provider.loginWithGoogle();
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                            content: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.wifi_off,
                                          color: Constants.textColour1,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text("You are currently offline."),
                                      ],
                                    )));
                                  }
                                  // signInWithGoogle();
                                },
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  )),
                                  backgroundColor: MaterialStateProperty.all(
                                      Constants.buttonColour3),
                                ),
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),
                              ElevatedButton(
                                child: Container(
                                  constraints: BoxConstraints(
                                      maxWidth: width / 1.3, maxHeight: 50.0),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: width * 0.1,
                                      ),
                                      SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: Icon(FontAwesomeIcons.apple)),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text("Sign Up With Apple",
                                          style: textTheme().subtitle1),
                                      Spacer(),
                                    ],
                                  ),
                                ),
                                onPressed: () {},
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  )),
                                  backgroundColor: MaterialStateProperty.all(
                                      Constants.textColour3),
                                ),
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),
                              Container(
                                width: width / 1.17,
                                height: 50,
                                decoration: ShapeDecoration(
                                  shape: StadiumBorder(),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Constants.buttonColourMix3,
                                      Constants.buttonColourMix2
                                    ],
                                  ),
                                ),
                                child: MaterialButton(
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  shape: StadiumBorder(),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: width * 0.1,
                                      ),
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: Icon(
                                          Icons.email_outlined,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text("Sign Up With Email",
                                          style: textTheme().subtitle1),
                                      Spacer(),
                                    ],
                                  ),
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SignUpForm()));
                                  },
                                ),
                              ),
                              SizedBox(
                                height: height * 0.03,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Login()));
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Already have an account? ",
                                      style: TextStyle(
                                          color: Constants.textColour3,
                                          fontFamily: "Segoe UI",
                                          fontSize: 12 * scaleFactor,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    Text(
                                      " Login",
                                      style: TextStyle(
                                          color: Constants.textColour6,
                                          fontFamily: "Segoe UI",
                                          fontSize: 12 * scaleFactor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  }),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLoading() => Center(
        child: CupertinoActivityIndicator(
          color: Constants.textColour6,
          radius: 20.0,
        ),
      );

  Future<bool> onWillPop() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Landing()));
    return Future.value(true);
  }

  Future<void> _apiHit() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    fcmToken = _prefs.getString("fcm");
    lat = _prefs.getString("lat");
    long = _prefs.getString("long");
    cityName = _prefs.getString("getCity");

    final myUser = FirebaseAuth.instance.currentUser;
    //
    // String? name=myUser?.displayName;
    // String? email = myUser?.email;
    // String phone="";
    // String code="";
    // String? image=myUser?.photoURL;
    // String? google_id=myUser?.uid;
    // String longitude=long.toString();
    // String latitude=lat.toString();
    // String city=cityName.toString();
    //
    // SocialLogin socialLogin=SocialLogin(
    //   username: name.toString(),email: email.toString(),phone: phone,code: code,image: image.toString(),googleId: google_id.toString(),
    //   facebookId: "",appleId: "",lat: latitude,long: longitude,city: city
    // );
    // var provider=Provider.of<SocialLogin>(context, listen: false);
    // await provider.postData(signUpBody);
    // if(provider.isBack)
    //   {
    //     Navigator.pushReplacement(
    //         context,
    //         MaterialPageRoute(
    //             builder: (context) => BottomBar(
    //               currentIndex: 0,
    //               categoryId: 1,
    //               categoryName: "All",
    //             )));
    //   }




    var loginResponse = await http.post(Uri.parse(url),
        body: ({
          "username": myUser?.displayName,
          "email": myUser?.email,
          "phone": "",
          "code": "",
          "image": myUser?.photoURL,
          "google_id": myUser?.uid,
          "facebook_id": "",
          "apple_id": "",
          "lat": lat.toString(),
          "long": long.toString(),
          "city": cityName.toString(),
        }));
    print("response comming");
    if (loginResponse.statusCode == 200) {
      print("Inside response body");
      String body = loginResponse.body;
      print(body);
      var jsonBody = jsonDecode(body);
      if (jsonBody["status"] == true) {
        Map mapData = {};
        mapData = jsonBody["data"];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("token", mapData["access_token"]);
        prefs.setString("customer_id", mapData["user_id"]);
        prefs.setString("email", mapData["email"]);
        prefs.setString("name", mapData["username"]);
        prefs.setString("phone", mapData["phone"]);
        prefs.setString("image", mapData["image"]);
        var token = prefs.getString("token");
        print("Move to next page");
        print(token.toString());
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => BottomBar(
                      currentIndex: 0,
                      categoryId: 1,
                      categoryName: "All",
                    )));
      } else if (jsonBody["status"] == false) {
        print("status is false");
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(jsonBody["message"])));
      }
    } else {
      print(loginResponse.statusCode);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Fields not allowed")));
    }
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
