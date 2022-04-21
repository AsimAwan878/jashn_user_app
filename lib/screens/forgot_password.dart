import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jashn_user/screens/bottomBar/profiles/change_password.dart';
import 'package:jashn_user/screens/login.dart';
import 'package:jashn_user/styles/colors.dart';
import 'package:http/http.dart' as http;
import '../styles/api_handler.dart';
import '../styles/strings.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:developer' as developer;
import 'dart:async';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class ResetPassword extends StatefulWidget {
  final String email;
  final String otp;
  final int id;

  ResetPassword({Key? key, required this.email, required this.otp,required this.id})
      : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static Handler handler4 = Handler('unauthorized/home/reset_password_code');
  static String url4 = handler4.getUrl();

  TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;
  bool _obscureText2 = true;

  bool isLogin = false;

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

  void validateAndSave() {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      setState(() {
        _submitData();
      });
    } else {
      setState(() {
        isLogin=false;
      });
      print('Form is invalid');
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
            replacement: Center(
              child: CupertinoActivityIndicator(
                color: Constants.textColour6,
                radius: 20.0,
              ),
            ),
            child: Container(
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
                                  if(widget.id ==0)
                                    {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Login(
                                              )));
                                    }
                                  if(widget.id ==1)
                                    {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ForgotPassword(
                                              )));
                                    }

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
                          "Create New Password",
                          style: TextStyle(
                              color: Constants.textColour1,
                              fontFamily: "Segoe UI",
                              fontSize: 20 * scalefactor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  isLogin
                      ? Expanded(
                          child: Center(
                          child: Center(
                            child: CupertinoActivityIndicator(
                              color: Constants.textColour6,
                              radius: 20.0,
                            ),
                          ),
                        ))
                      : Expanded(
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

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Enter Your New Password Below.",
                                      style: TextStyle(
                                          color: Constants.textColour6,
                                          fontFamily: "Segoe UI",
                                          fontSize: 16 * scalefactor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: height * 0.05,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 50, right: 50),
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
                                  height: height * 0.03,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 50, right: 50),
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
                                              size: width*0.05
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
                                // Padding(
                                //   padding: const EdgeInsets.only(left: 64, right: 64),
                                //   child: TextFormField(
                                //     controller: passwordController,
                                //     cursorColor: Colors.grey,
                                //     decoration: InputDecoration(
                                //       fillColor: Colors.white,
                                //       filled: true,
                                //       hintText: 'New Password',
                                //       contentPadding: const EdgeInsets.only(left: 24),
                                //       hintStyle: TextStyle(
                                //           fontSize: 12 * scalefactor,
                                //           fontWeight: FontWeight.w400,
                                //           fontFamily: 'Mulish',
                                //           color: Constants.textColour5),
                                //       border: OutlineInputBorder(
                                //         borderRadius: BorderRadius.circular(0),
                                //         borderSide: BorderSide(
                                //             color: Constants.textColour5, width: 2.0),
                                //       ),
                                //       focusedBorder: OutlineInputBorder(
                                //         borderRadius: BorderRadius.circular(0),
                                //         borderSide: BorderSide(
                                //             color: Constants.textColour4, width: 2.0),
                                //       ),
                                //       enabledBorder: OutlineInputBorder(
                                //         borderRadius: BorderRadius.circular(0),
                                //         borderSide: BorderSide(
                                //             color: Constants.textColour5, width: 2.0),
                                //       ),
                                //     ),
                                //   ),
                                // ),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Change Password",
                                            style: textTheme().subtitle1),
                                      ],
                                    ),
                                    onPressed: () {
                                      if (isInternetDown==false) {
                                        setStateIfMounted((){
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
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitData() async {
    print("In new password submit method ");
    if (passwordController.text.isNotEmpty) {
      print("Inside if condition");
      var submitResponse = await http.post(Uri.parse(url4),
          body: ({
            "email": widget.email,
            "code": widget.otp,
            "new_password": passwordController.text,
          }));
      if (submitResponse.statusCode == 200) {
        String body = submitResponse.body;
        var jsonBody = jsonDecode(body);
        if (jsonBody["success"] == true) {
          print(jsonBody["success"]);
          print(passwordController.text);
          print("Move to next page");
          setState(() {
            isLogin = true;
          });
          if(widget.id ==0)
          {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => Login(
                    )));
          }
          if(widget.id ==1)
          {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ForgotPassword(
                    )));
          }
        }
        if (jsonBody["success"] == false) {
          print("status is false");
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(jsonBody["message"])));
        }
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Fields not allowed")));
    }
  }

  Future<bool> onWillPop() {
    if(widget.id ==0)
    {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Login(
              )));
    }
    if(widget.id ==1)
    {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ForgotPassword(
              )));
    }
    return Future.value(true);
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
