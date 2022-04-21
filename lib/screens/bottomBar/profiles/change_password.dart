import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jashn_user/styles/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../styles/api_handler.dart';
import '../../../styles/strings.dart';
import 'package:http/http.dart' as http;
import '../../forgot_password.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:developer' as developer;
import 'dart:async';

// ignore: must_be_immutable
class ForgotPassword extends StatefulWidget {
  ForgotPassword({
    Key? key,
  }) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword>
    with TickerProviderStateMixin {
  static Handler handler = Handler('auth/resetpassword');
  static String url = handler.getUrl();

  static Handler handler3 = Handler('unauthorized/home/reset_password_email');
  static String url3 = handler3.getUrl();

  static Handler handler4 = Handler('unauthorized/home/reset_password_code');
  static String url4 = handler4.getUrl();

  TextEditingController pin1Controller = TextEditingController();
  TextEditingController pin2Controller = TextEditingController();
  TextEditingController pin3Controller = TextEditingController();
  TextEditingController pin4Controller = TextEditingController();
  TextEditingController pin5Controller = TextEditingController();
  TextEditingController pin6Controller = TextEditingController();

  late FocusNode pin2FocusNode;

  late FocusNode pin3FocusNode;

  late FocusNode pin4FocusNode;

  late FocusNode pin5FocusNode;

  late FocusNode pin6FocusNode;

  late FocusNode pin7FocusNode;

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

  TextEditingController currentPassController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey4 = GlobalKey<FormState>();
  AnimationController? controller;

  bool sentEmail = false;
  bool resentEmail = false;

  bool _obscureText = true;
  bool _obscureText2 = true;
  bool _obscureText3 = true;

  String _email = '';
  String otp = '';

  bool isLoading = false;

  bool isDelaying = false;
  bool isConnected = false;
  bool isInternetDown = false;

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  var id;
  var token;

  @override
  void initState() {
    controller = BottomSheet.createAnimationController(this);
    controller!.duration = Duration(seconds: 1);

    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
    pin5FocusNode = FocusNode();
    pin6FocusNode = FocusNode();
    pin7FocusNode = FocusNode();
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

  void _onTap() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _onTap2() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
  }

  void _onTap3() {
    setState(() {
      _obscureText3 = !_obscureText3;
    });
  }

  void validateAndSave() {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      _submitData();
    } else {
      setStateIfMounted(() {
        isLoading = false;
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
      setState(() {
        sentEmail = false;
      });
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
      setState(() {
        Navigator.pop(context);
        print("tap");
        _submitOtp();
      });
    } else {
      print('Form2 is invalid');
    }
  }

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
            replacement: Scaffold(
              body: Center(
                child: CupertinoActivityIndicator(
                  color: Constants.textColour6,
                  radius: 20.0,
                ),
              ),
            ),
            child: Container(
              width: width,
              height: height,
              color: Constants.textColour1,
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: height * 0.04,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
                          "Change Password",
                          style: TextStyle(
                              color: Constants.textColour1,
                              fontFamily: "Segoe UI",
                              fontSize: 24 * scalefactor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: isLoading == false,
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
                            Image.asset(
                              "assets/password.png",
                              height: 76,
                              width: 107,
                            ),
                            SizedBox(
                              height: height * 0.03,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 50.0, right: 50.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  TextFormField(
                                    controller: currentPassController,
                                    keyboardType: TextInputType.name,
                                    cursorColor: Colors.grey,
                                    obscureText: _obscureText3,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Must enter Your Current password';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      suffixIcon: GestureDetector(
                                          onTap: () {
                                            _onTap3();
                                          },
                                          child: Icon(
                                            _obscureText3
                                                ? FontAwesomeIcons.eyeSlash
                                                : Icons.remove_red_eye_outlined,
                                            color: Constants.textColour5,
                                              size: width*0.05
                                          )),
                                      fillColor: Colors.white,
                                      filled: true,
                                      labelText: "Current Password",
                                      labelStyle: TextStyle(
                                          fontSize: 14 * scalefactor,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "Segoe UI",
                                          color: Constants.textColour5),
                                      contentPadding: const EdgeInsets.all(16),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: Constants.textColour5,
                                            width: 2.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: Constants.textColour4,
                                            width: 2.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: Constants.textColour5,
                                            width: 2.0),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      forgotModal();
                                    },
                                    child: Text(
                                      "Forgot Password?",
                                      style: TextStyle(
                                          color: Constants.textColour6,
                                          fontFamily: "Segoe UI",
                                          fontSize: 12 * scalefactor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: height * 0.02,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 50, right: 50),
                              child: TextFormField(
                                obscureText: _obscureText,
                                cursorColor: Colors.grey,
                                controller: passwordController,
                                validator: (value) =>
                                    value!.length > 7 && value.isNotEmpty
                                        ? null
                                        : 'Must Enter a valid Password',
                                decoration: InputDecoration(
                                  suffixIcon: GestureDetector(
                                      onTap: () {
                                        _onTap();
                                      },
                                      child: Icon(
                                        _obscureText
                                            ? FontAwesomeIcons.eyeSlash
                                            : Icons.remove_red_eye_outlined,
                                        color: Constants.textColour5,
                                          size: width*0.05
                                      )),
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: 'New Password',
                                  hintStyle: TextStyle(
                                      fontSize: 12 * scalefactor,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Mulish',
                                      color: Constants.textColour5),
                                  contentPadding:
                                      const EdgeInsets.only(left: 24),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Constants.textColour5,
                                        width: 2.0),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Constants.textColour5,
                                        width: 2.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Constants.textColour4,
                                        width: 2.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Constants.textColour5,
                                        width: 2.0),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.02,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 50, right: 50),
                              child: TextFormField(
                                obscureText: _obscureText2,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Must enter confirm password';
                                  }
                                  if (value != passwordController.text) {
                                    return 'Password not matched';
                                  }
                                  return null;
                                },
                                cursorColor: Colors.grey,
                                decoration: InputDecoration(
                                  suffixIcon: GestureDetector(
                                      onTap: () {
                                        _onTap2();
                                      },
                                      child: Icon(
                                        _obscureText2
                                            ? FontAwesomeIcons.eyeSlash
                                            : Icons.remove_red_eye_outlined,
                                        color: Constants.textColour5,
                                        size: 25,
                                      )),
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: 'Confirm Password',
                                  contentPadding:
                                      const EdgeInsets.only(left: 24),
                                  hintStyle: TextStyle(
                                      fontSize: 12 * scalefactor,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Mulish',
                                      color: Constants.textColour5),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Constants.textColour5,
                                        width: 2.0),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Constants.textColour5,
                                        width: 2.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Constants.textColour4,
                                        width: 2.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Constants.textColour5,
                                        width: 2.0),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.03,
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Save", style: textTheme().subtitle1),
                                  ],
                                ),
                                onPressed: () {
                                  if (isInternetDown == false) {
                                    setState(() {
                                      isLoading = true;
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
                                  // _submitData();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  forgotModal() {
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
                child: Visibility(
                  visible: sentEmail,
                  replacement: Row(
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
                  ),
                  child: Container(
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
                                  "Enter your email and we'll send you a",
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
                                  "verification"
                                  " code to reset your password",
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
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        if (isInternetDown == false) {
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
                          child: Center(child: CircularProgressIndicator()),
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
                                        child: CircularProgressIndicator()),
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
                                          "OTP CODE",
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
                                        "OTP has been sent to your email address.",
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
                                        "Please enter it below",
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
                                                ("Otp has been sent to your Email"),
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
            .showSnackBar(SnackBar(content: Text(jsonBody["message"])));
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
                    id: 1,
                      )));
        });

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

  Future<void> _submitData() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    id = _prefs.getString("customer_id");
    token = _prefs.getString("token");

    print("In new password submit method ");

    print("Inside if condition");
    var submitResponse = await http.post(Uri.parse(url),
        body: ({
          "customer_id": id.toString(),
          "old_password": currentPassController.text,
          "new_password": passwordController.text,
        }),
        headers: ({"Authorization": "Bearer: ${token.toString()}"}));
    String body = submitResponse.body;
    var jsonBody = jsonDecode(body);
    if (submitResponse.statusCode == 200) {
      if (jsonBody["success"] == true) {
        setStateIfMounted(() {
          isLoading = false;
        });
        print(jsonBody["success"]);
        print(passwordController.text);
        print("Move to next page");
        Navigator.pop(context);
      } else if (jsonBody["success"] == false) {
        setStateIfMounted(() {
          isLoading = false;
        });
        print("status is false");
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(jsonBody["message"])));
      }
    } else {
      print(submitResponse.statusCode);
      print(submitResponse.body);
      setStateIfMounted(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(jsonBody["message"])));
    }
  }

  Future<bool> onWillPop() {
    Navigator.pop(context);
    return Future.value(true);
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final md = MediaQuery.of(context);
    if (md.orientation == Orientation.landscape) {
      return _widget();
    }
    return _widget();
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
