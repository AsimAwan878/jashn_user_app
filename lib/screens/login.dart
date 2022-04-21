import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jashn_user/screens/forsignup.dart';
import 'package:jashn_user/screens/forgot_password.dart';
import 'package:jashn_user/styles/colors.dart';
import 'package:jashn_user/styles/strings.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../provider_class.dart';
import '../styles/api_handler.dart';
import 'bottomBar/bottom_bar.dart';
import 'landing.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:developer' as developer;
import 'dart:async';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Login_State();
  }
}

// ignore: camel_case_types
class Login_State extends State<Login> with TickerProviderStateMixin {
  AnimationController? controller;

  static Handler handler = Handler('auth/login');
  static String url = handler.getUrl();

  static Handler handler2 = Handler('auth/sociallogin');
  static String url2 = handler2.getUrl();

  static Handler handler3 = Handler('unauthorized/home/reset_password_email');
  static String url3 = handler3.getUrl();

  static Handler handler4 = Handler('unauthorized/home/reset_password_code');
  static String url4 = handler4.getUrl();

  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pin1Controller = TextEditingController();
  TextEditingController pin2Controller = TextEditingController();
  TextEditingController pin3Controller = TextEditingController();
  TextEditingController pin4Controller = TextEditingController();
  TextEditingController pin5Controller = TextEditingController();
  TextEditingController pin6Controller = TextEditingController();

  bool isLogin = false;
  bool sentEmail = false;
  bool resentEmail = false;
  var fcmToken;
  var lat;
  var long;
  var cityName;

  late FocusNode pin2FocusNode;

  late FocusNode pin3FocusNode;

  late FocusNode pin4FocusNode;

  late FocusNode pin5FocusNode;

  late FocusNode pin6FocusNode;

  late FocusNode pin7FocusNode;

  bool _obscureText = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey4 = GlobalKey<FormState>();
  String _email = '';
  String otp = '';

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

    controller = BottomSheet.createAnimationController(this);
    controller!.duration = Duration(seconds: 1);

    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
    pin5FocusNode = FocusNode();
    pin6FocusNode = FocusNode();
    pin7FocusNode = FocusNode();
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
      _fetchData().whenComplete(() {
        setStateIfMounted(() {
          isConnected = true;
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

  void nextField(String value, FocusNode focusNode) {
    if (value.length == 1) {
      focusNode.requestFocus();
    }
  }

  void previousField(String value, FocusNode focusNode) {
    if (value.length == 0) {
      focusNode.requestFocus();
    }
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  Future<void> _fetchData() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    fcmToken = _prefs.getString("fcm");
    lat = _prefs.getString("lat");
    long = _prefs.getString("long");
    cityName = _prefs.getString("getCity");
    print(lat.toString());
    print(long.toString());
    print(cityName.toString());
    print(fcmToken.toString());
  }

  void _onTap() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void validateAndSave() {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      setState(() {
        print("tap");
        isLogin = true;
        _login();
      });
    } else {
      setState(() {
        isLogin=false;
      });
      print('Form is invalid');
    }
  }

  void validateAndSave2() {
    final FormState? form2 = _formKey2.currentState;
    if (form2!.validate()) {
      setState(() {
        print("tap");
        _email = emailController.text;
        emailController.clear();

        _getResponse();
      });
    } else {
      print('Form2 is invalid');
    }
  }

  void validateAndSave3() {
    setState(() {
      print("tap");
      _getResponse1();
    });
  }

  void validateAndSave4() {
    final FormState? form4 = _formKey4.currentState;
    if (form4!.validate()) {
        print("tap");
        _submitOtp();
    } else {
      print('Form2 is invalid');
    }
  }

  var inputDecoration = InputDecoration(
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Constants.textColour4, width: 1.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Constants.textColour6, width: 1.0),
    ),
  );

  Widget _widget() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double scalefactor = MediaQuery.of(context).textScaleFactor;

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
                      print(
                          "\n\n\n\n\n\n\n\n\n\n\n\n 1st stage \n\n\n\n\n\n\n\n\n\n\n\n");
                      return buildLoading();
                    } else if (snapshot.hasData) {
                      print(
                          "\n\n\n\n\n\n\n\n\n\n\n\n 2nd stage \n\n\n\n\n\n\n\n\n\n\n\n");
                      print(snapshot.toString());
                      _apiHit();
                      return buildLoading();
                    } else {
                      return Container(
                        width: width,
                        height: height,
                        color: Colors.white,
                        child: Column(
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
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: height * 0.06,
                                  ),
                                  Image.asset(
                                    "assets/logo.png",
                                    height: 46,
                                    width: 174,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Welcome Back!",
                                    style: TextStyle(
                                        color: Constants.textColour1,
                                        fontFamily: "Segoe UI",
                                        fontSize: 20 * scalefactor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Login to your account!",
                                    style: textTheme().subtitle2,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: isLogin == false,
                              replacement: Expanded(
                                child: Center(
                                  child: CupertinoActivityIndicator(
                                    color: Constants.textColour6,
                                    radius: 20.0,
                                  ),
                                ),
                              ),
                              child: Expanded(
                                  child: SingleChildScrollView(
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: height * 0.05,
                                      ),
                                      ElevatedButton(
                                        child: Container(
                                          constraints: BoxConstraints(
                                              maxWidth: width / 1.3,
                                              maxHeight: 50.0),
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
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
                                              Text("Sign In With Facebook",
                                                  style: textTheme().subtitle1),
                                              Spacer(),
                                            ],
                                          ),
                                        ),
                                        onPressed: () {
                                          // signInWithFacebook();
                                          // setState(() {
                                          //
                                          // });
                                        },
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          )),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Constants.buttonColour2),
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 0.02,
                                      ),
                                      ElevatedButton(
                                        child: Container(
                                          constraints: BoxConstraints(
                                              maxWidth: width / 1.3,
                                              maxHeight: 50.0),
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: width * 0.1,
                                              ),
                                              SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child: Image.asset(
                                                      "assets/google.png")),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Text("Sign In With Google",
                                                  style: textTheme().subtitle1),
                                              Spacer(),
                                            ],
                                          ),
                                        ),
                                        onPressed: () {
                                          if (isInternetDown == false) {
                                            print("OnPressed");
                                            final provider =
                                                Provider.of<MyProvider>(context,
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
                                                Text(
                                                    "You are currently offline."),
                                              ],
                                            )));
                                          }
                                          // signInWithGoogle();
                                        },
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          )),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Constants.buttonColour3),
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 0.02,
                                      ),
                                      ElevatedButton(
                                        child: Container(
                                          constraints: BoxConstraints(
                                              maxWidth: width / 1.3,
                                              maxHeight: 50.0),
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: width * 0.1,
                                              ),
                                              SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child: Icon(
                                                      FontAwesomeIcons.apple)),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Text("Sign In With Apple",
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
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          )),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Constants.textColour3),
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 0.03,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 50, right: 50),
                                        child: TextFormField(
                                          validator: (value) =>
                                              value!.contains("@") &&
                                                      value.isNotEmpty
                                                  ? null
                                                  : 'Must Enter a valid Email',
                                          controller: userEmailController,
                                          cursorColor: Colors.grey,
                                          decoration: InputDecoration(
                                            fillColor: Colors.white,
                                            filled: true,
                                            hintText: 'Email Address',
                                            contentPadding:
                                                const EdgeInsets.only(left: 24),
                                            hintStyle: TextStyle(
                                                fontSize: 12 * scalefactor,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'Mulish',
                                                color: Constants.textColour5),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: Constants.textColour5,
                                                  width: 2.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: Constants.textColour4,
                                                  width: 2.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: Constants.textColour5,
                                                  width: 2.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 50, right: 50),
                                        child: TextFormField(
                                          validator: (value) => value!.length >=
                                                      7 &&
                                                  value.isNotEmpty
                                              ? null
                                              : 'Must Enter a valid Password',
                                          obscureText: _obscureText,
                                          controller: userPasswordController,
                                          cursorColor: Colors.grey,
                                          decoration: InputDecoration(
                                            suffixIcon: GestureDetector(
                                                onTap: () {
                                                  _onTap();
                                                },
                                                child: Icon(
                                                  _obscureText
                                                      ? FontAwesomeIcons
                                                          .eyeSlash
                                                      : Icons
                                                          .remove_red_eye_outlined,
                                                  color: Constants.textColour5,
                                                  size: width*0.05,
                                                )),
                                            fillColor: Colors.white,
                                            filled: true,
                                            hintText: 'Password',
                                            contentPadding:
                                                const EdgeInsets.only(left: 24),
                                            hintStyle: TextStyle(
                                                fontSize: 12 * scalefactor,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'Mulish',
                                                color: Constants.textColour5),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: Constants.textColour5,
                                                  width: 2.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: Constants.textColour4,
                                                  width: 2.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: Constants.textColour5,
                                                  width: 2.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 58),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            InkWell(
                                              child: Text(
                                                "Forgot Password?",
                                                style: TextStyle(
                                                    color:
                                                        Constants.textColour6,
                                                    fontFamily: "Segoe UI",
                                                    fontSize: 12 * scalefactor,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                              onTap: () {
                                                FocusScope.of(context)
                                                    .requestFocus(FocusNode());
                                                forgotModal(isInternetDown);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 0.02,
                                      ),
                                      Container(
                                        width: width / 1.3,
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text("Login",
                                                  style: textTheme().subtitle1),
                                            ],
                                          ),
                                          onPressed: () {
                                            if (isInternetDown == false) {
                                              setStateIfMounted(() {
                                                isLogin = true;
                                              });
                                              validateAndSave();
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Icon(
                                                    Icons.wifi_off,
                                                    color:
                                                        Constants.textColour1,
                                                    size: 20,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                      "You are currently offline."),
                                                ],
                                              )));
                                            }
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 0.03,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SignUp()));
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Don’t have an account?",
                                              style: TextStyle(
                                                  color: Constants.textColour3,
                                                  fontFamily: "Segoe UI",
                                                  fontSize: 12 * scalefactor,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            Text(
                                              " Sign Up",
                                              style: TextStyle(
                                                  color: Constants.textColour6,
                                                  fontFamily: "Segoe UI",
                                                  fontSize: 12 * scalefactor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 0.05,
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                            )
                          ],
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

  forgotModal(bool isInternetDown) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return showModalBottomSheet(
        transitionAnimationController: controller,
        backgroundColor: Constants.textColour1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        ),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: sentEmail
                    ? Row(
                  children: [
                    SizedBox(
                      width: width,
                      height: height * 0.2,
                      child: Center(
                        child: CupertinoActivityIndicator(
                          color: Constants.textColour6,
                          radius: 20.0,
                        ),
                      ),
                    ),
                  ],
                )
                    : Container(
                  child: Wrap(
                    children: <Widget>[
                      Row(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Reset Password",
                            style: TextStyle(
                                color: Constants.textColour3,
                                fontFamily: "Segoe UI",
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Enter your email address below so we can",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Constants.textColour3,
                            fontFamily: "Segoe UI",
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "send you a verification link to reset your password.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Constants.textColour3,
                            fontFamily: "Segoe UI",
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.only(left: 50, right: 50),
                        child: Form(
                          key: _formKey2,
                          child: TextFormField(
                            validator: (value) =>
                            value!.contains("@") && value.isNotEmpty
                                ? null
                                : 'Must Enter a valid Email',
                            controller: emailController,
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(
                              hintText: 'Email Address',
                              contentPadding:
                              const EdgeInsets.only(left: 24),
                              hintStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Mulish',
                                  color: Constants.textColour5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                    color: Constants.textColour5,
                                    width: 2.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                    color: Constants.textColour4,
                                    width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                    color: Constants.textColour5,
                                    width: 2.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            constraints: BoxConstraints(
                                maxWidth: width / 1.3, maxHeight: 50.0),
                            alignment: Alignment.center,
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
                              onPressed: () {
                                if (isInternetDown == false) {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  setState(() {
                                    sentEmail = true;
                                  });
                                  validateAndSave2();
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
                                // isSent=true;
                              },
                              materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                              shape: StadiumBorder(),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Text("Send Email",
                                      style: textTheme().subtitle1),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  otpModal() {
    print(resentEmail);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return showModalBottomSheet(
        backgroundColor: Constants.textColour1,
        transitionAnimationController: controller,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        ),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return SafeArea(
              child: resentEmail == true
                  ? Row(
                children: [
                  SizedBox(
                    width: width,
                    height: height * 0.3,
                    child: Center(child: CupertinoActivityIndicator(
                      color: Constants.textColour6,
                      radius: 20.0,
                    ),),
                  ),
                ],
              )
                  : Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Form(
                  key: _formKey4,
                  child: resentEmail
                      ? Row(
                    children: [
                      SizedBox(
                        width: width,
                        height: height * 0.2,
                        child: Center(
                          child: CupertinoActivityIndicator(
                            color: Constants.textColour6,
                            radius: 20.0,
                          ),),
                      ),
                    ],
                  )
                      : Container(
                    child: Wrap(
                      children: <Widget>[
                        Row(
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            Text(
                              "Enter OTP Code",
                              style: TextStyle(
                                  color: Constants.textColour3,
                                  fontFamily: "Segoe UI",
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "OTP has been sent to you on your email address.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Constants.textColour3,
                              fontFamily: "Segoe UI",
                              fontSize: 14,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Please enter the 6-digit code below",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Constants.textColour3,
                              fontFamily: "Segoe UI",
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0),
                              child: SizedBox(
                                width: 37,
                                height: 42,
                                child: TextFormField(
                                  controller: pin1Controller,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(
                                        1),
                                  ],
                                  focusNode: pin2FocusNode,
                                  autofocus: true,
                                  keyboardType:
                                  TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: inputDecoration,
                                  onChanged: (value) {
                                    nextField(value, pin3FocusNode);
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0),
                              child: SizedBox(
                                width: 37,
                                height: 42,
                                child: TextFormField(
                                    controller: pin2Controller,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(
                                          1),
                                    ],
                                    focusNode: pin3FocusNode,
                                    keyboardType:
                                    TextInputType.number,
                                    textAlign: TextAlign.center,
                                    decoration: inputDecoration,
                                    onChanged: (value) {
                                      nextField(
                                          value, pin4FocusNode);
                                      previousField(
                                          value, pin2FocusNode);
                                    }),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0),
                              child: SizedBox(
                                width: 37,
                                height: 42,
                                child: TextFormField(
                                    controller: pin3Controller,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(
                                          1),
                                    ],
                                    focusNode: pin4FocusNode,
                                    keyboardType:
                                    TextInputType.number,
                                    textAlign: TextAlign.center,
                                    decoration: inputDecoration,
                                    onChanged: (value) {
                                      nextField(
                                          value, pin5FocusNode);
                                      previousField(
                                          value, pin3FocusNode);
                                    }),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0),
                              child: SizedBox(
                                width: 37,
                                height: 42,
                                child: TextFormField(
                                  controller: pin4Controller,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(
                                        1),
                                  ],
                                  focusNode: pin5FocusNode,
                                  keyboardType:
                                  TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: inputDecoration,
                                  onChanged: (value) {
                                    nextField(value, pin6FocusNode);
                                    previousField(
                                        value, pin4FocusNode);
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0),
                              child: SizedBox(
                                width: 37,
                                height: 42,
                                child: TextFormField(
                                  controller: pin5Controller,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(
                                        1),
                                  ],
                                  focusNode: pin6FocusNode,
                                  keyboardType:
                                  TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: inputDecoration,
                                  onChanged: (value) {
                                    nextField(value, pin7FocusNode);
                                    previousField(
                                        value, pin5FocusNode);
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0),
                              child: SizedBox(
                                width: 37,
                                height: 42,
                                child: TextFormField(
                                  controller: pin6Controller,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(
                                        1),
                                  ],
                                  focusNode: pin7FocusNode,
                                  keyboardType:
                                  TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: inputDecoration,
                                  onChanged: (value) {
                                    previousField(
                                        value, pin6FocusNode);
                                    if (value.length == 1) {
                                      pin7FocusNode.unfocus();
                                      // Get.to(
                                      //   PersonalInfoScreen(),
                                      // );

                                      // Then you need to check is the code is correct or not
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                  maxWidth: width / 1.3,
                                  maxHeight: 50.0),
                              alignment: Alignment.center,
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
                                onPressed: () {
                                  setState(() {
                                    resentEmail = true;
                                  });
                                  validateAndSave4();
                                },
                                materialTapTargetSize:
                                MaterialTapTargetSize
                                    .shrinkWrap,
                                shape: StadiumBorder(),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Text("Submit",
                                        style:
                                        textTheme().subtitle1),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                _messageDialog(
                                    context,
                                    ("OTP Code has been sent to you Email"),
                                    "OK");
                                validateAndSave3();
                              },
                              child: Text(
                                "Resend OTP",
                                style: TextStyle(
                                    color: Constants.textColour6,
                                    fontFamily: "Segoe UI",
                                    fontSize: 12 * 1.1,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        });
  }

  Widget buildLoading() => Center(
        child: CupertinoActivityIndicator(
          color: Constants.textColour6,
          radius: 20.0,
        ),
      );

  Future<void> _login() async {
    print(fcmToken.toString());
    print(lat.toString());
    print(long.toString());
    print(cityName.toString());
    print(fcmToken.toString());

    print("In Login method");
    if (userEmailController.text.isNotEmpty &&
        userPasswordController.text.isNotEmpty) {
      var loginResponse = await http.post(Uri.parse(url),
          body: ({
            "email": userEmailController.text,
            "password": userPasswordController.text,
            "device_id": fcmToken.toString(),
            "lat": lat.toString(),
            "long": long.toString(),
            "city": cityName.toString(),
          }));
      print("response comming");
      if (loginResponse.statusCode == 200) {
        print("Inside response body");
        String body = loginResponse.body;
        var jsonBody = jsonDecode(body);
        if (jsonBody["success"] == true) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("token", jsonBody["access_token"]);
          prefs.setString("customer_id", jsonBody["user_id"]);
          prefs.setString("email", jsonBody["email"]);
          prefs.setString("name", jsonBody["username"]);
          prefs.setString("phone", jsonBody["phone"]);
          prefs.setString("image", jsonBody["image"]);
          prefs.setString("wallet", jsonBody["wallet"]);
          prefs.setString("IsSocial", "0");
          var token = prefs.getString("wallet");
          setState(() {
            print("Move to next page");
            print(token.toString());
            isLogin = false;
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => BottomBar(
                          currentIndex: 0,
                          categoryId: 1,
                          categoryName: "All",
                        )));
          });
        }
        if (jsonBody["success"] == false) {
          print("status is false");
          setState(() {
            isLogin = false;
          });
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(jsonBody["message"])));
        }
      } else {
        print(loginResponse.statusCode);
        setState(() {
          isLogin = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Fields not allowed")));
      }
    } else {
      setState(() {
        isLogin = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Must fill all fields")));
    }
  }

  Future<void> _apiHit() async {
    print("In Login with google method");

    final myUser = FirebaseAuth.instance.currentUser;
    print(myUser?.photoURL.toString());
    print(myUser?.displayName.toString());
    print(myUser?.email.toString());
    print(myUser?.uid.toString());
    print(fcmToken.toString());
    print(lat.toString());
    print(long.toString());
    print(cityName.toString());

    var loginResponse = await http.post(Uri.parse(url2),
        body: ({
          "username": myUser?.displayName,
          "email": myUser?.email,
          "phone": "",
          "code": "",
          "image": myUser?.photoURL.toString(),
          "google_id": myUser?.uid,
          "facebook_id": "",
          "apple_id": "",
          "device_id": fcmToken.toString(),
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
        prefs.setString("IsSocial", "1");
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



  Future<bool> onWillPop() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Landing()));
    return Future.value(true);
  }

  Map emailResponse = {};
  bool isSent = false;

  Future _getResponse() async {
    print(emailController.text);
    // ignore: unnecessary_brace_in_string_interps
    var url = Uri.parse("${url3}");
    var response = await http.post(url,
        body: ({
          "email": _email,
        }));
    if (response.statusCode == 200) {
      String body = response.body;
      var jsonBody = jsonDecode(body);
      if (jsonBody["success"] == true) {
        Navigator.pop(context);
        // isSent=false;
        setState(() {
          sentEmail = false;
        });
        otpModal();

        // ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text("Email sent")));
      }
      if (jsonBody["success"] == false) {
        // isSent=false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(jsonBody["error"])));
      }
    } else {
      print("Request failed to response :${response.statusCode}");
    }
  }

  Future _getResponse1() async {
    print("Email");
    print(_email);
    // ignore: unnecessary_brace_in_string_interps
    var url = Uri.parse("${url3}");
    var response = await http.post(url, body: ({"email": _email}));
    if (response.statusCode == 200) {
      String body = response.body;
      print(body);
      var jsonBody = jsonDecode(body);
      if (jsonBody["success"] == true) {
        print("success is true");

        // isSent=false;
        setState(() {});

        // ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text("Email sent")));
      }
      if (jsonBody["success"] == false) {
        // isSent=false;
        setState(() {
          print("resent false");
          resentEmail = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(jsonBody["error"])));
      }
    } else {
      setState(() {
        print("resent false");
        resentEmail = false;
      });
      print("Request failed to response :${response.statusCode}");
    }
  }

  Future _submitOtp() async {
    otp =
        '${pin1Controller.text}${pin2Controller.text}${pin3Controller.text}${pin4Controller.text}${pin5Controller.text}${pin6Controller.text}';
    print(otp);
    // ignore: unnecessary_brace_in_string_interps
    var url = Uri.parse("${url4}");
    var response = await http.post(url,
        body: ({
          "email": _email,
          "code": otp,
        }));
    if (response.statusCode == 200) {
      String body = response.body;
      var jsonBody = jsonDecode(body);
      if (jsonBody["success"] == true) {
        // isSent=false;
        setState(() {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ResetPassword(
                        email: _email,
                        otp: otp,
                    id:0,
                      )));
        });

        // ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text("Email sent")));
      }
      if (jsonBody["success"] == false) {
        // isSent=false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(jsonBody["message"])));
      }
    } else {
      print("Request failed to response :${response.statusCode}");
    }
  }

  // Future<UserCredential> signInWithFacebook() async {
  //   // Trigger the sign-in flow
  //   final LoginResult loginResult = await FacebookAuth.instance.login(
  //     permissions: ['email','public_profile','user_birthday']
  //   );
  //
  //   // Create a credential from the access token
  //   final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
  //
  //   var userData=FacebookAuth.instance.getUserData();
  //
  //   print(userData);
  //
  //   // Once signed in, return the UserCredential
  //   return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  // }

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
    controller!.dispose();

    pin2FocusNode.dispose();
    pin3FocusNode.dispose();
    pin4FocusNode.dispose();
    pin5FocusNode.dispose();
    pin6FocusNode.dispose();
    pin7FocusNode.dispose();
    super.dispose();
  }
}

void _messageDialog(BuildContext myContext, String message, String buttonText) {
  showDialog(
      context: myContext,
      builder: (context) {
        return new SimpleDialog(children: <Widget>[
          new Center(
              child: new Container(
                  child: Column(
            children: [
              new Text(
                message,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Segoe UI",
                    color: Constants.textColour5),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: Container(
                        width: 60,
                        height: 40,
                        alignment: Alignment.center,
                        child: Text(
                          buttonText,
                          style: TextStyle(
                              color: Constants.textColour1,
                              fontFamily: "Segoe UI",
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        )),
                        backgroundColor: MaterialStateProperty.all(
                            Constants.buttonColourMix4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )))
        ]);
      });
}
