import 'dart:convert';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jashn_user/styles/colors.dart';
import 'package:http/http.dart' as http;
import 'package:jashn_user/styles/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../styles/api_handler.dart';
import 'forsignup.dart';
import 'login.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:developer' as developer;
import 'dart:async';
import 'package:flutter/services.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  static Handler handler = Handler('auth/registration');
  static String url = handler.getUrl();

  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController numController = TextEditingController();
  var fcmToken;
  var lat;
  var long;
  var cityName;
  bool _obscureText = true;
  String countryCodeName = "PK";

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

  void _onCountryChange(
    CountryCode code,
  ) {
    setState(() {
      countryCode = code.toString();
      countryCodeName = code.code.toString();
    });
    print(countryCodeName);
    myCode = countryCode.substring(1);
    print(myCode);
    print(countryCode);
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _onTap() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void validateAndSave() {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      setState(() {
        FocusScope.of(context).requestFocus(FocusNode());
        _signUp();
      });
    } else {
      setState(() {
        isLogin = false;
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
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
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
                            "Sign Up with Jash’n",
                            style: TextStyle(
                                color: Constants.textColour1,
                                fontFamily: "Segoe UI",
                                fontSize: 20 * scalefactor,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
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
                              height: height * 0.1,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 50, right: 50),
                              child: TextFormField(
                                cursorColor: Colors.grey,
                                controller: userNameController,
                                keyboardType: TextInputType.name,
                                validator: (value) => value!.isEmpty
                                    ? 'Must enter User Name'
                                    : null,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: 'User Name',
                                  contentPadding:
                                      const EdgeInsets.only(left: 24),
                                  hintStyle: TextStyle(
                                      fontSize: 12 * scalefactor,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Mulish',
                                      color: Constants.textColour5),
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
                                controller: emailController,
                                cursorColor: Colors.grey,
                                keyboardType: TextInputType.name,
                                validator: (value) =>
                                    value!.contains("@") && value.isNotEmpty
                                        ? null
                                        : 'Must Enter a valid Email',
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
                                validator: (value) =>
                                    value!.length >= 7 && value.isNotEmpty
                                        ? null
                                        : 'Password must be of 8 characters',
                                obscureText: _obscureText,
                                controller: passController,
                                cursorColor: Colors.grey,
                                keyboardType: TextInputType.name,
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
                                  hintText: 'Password',
                                  contentPadding:
                                      const EdgeInsets.only(left: 24),
                                  hintStyle: TextStyle(
                                      fontSize: 12 * scalefactor,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Mulish',
                                      color: Constants.textColour5),
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50.0),
                              child: Container(
                                height: 55,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Constants
                                          .textColour5,
                                      width: 1.0),
                                  borderRadius:
                                  BorderRadius.circular(
                                      10.0
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 90,
                                      height: 53,
                                      child: CountryCodePicker(
                                        onChanged: _onCountryChange,
                                        // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                        initialSelection: 'PK',
                                        favorite: [
                                          'US',
                                          'IE',
                                          '+966',
                                          'PK'
                                        ],
                                        textStyle: TextStyle(
                                            color: Colors.black),
                                        // optional. Shows only country name and flag
                                        showCountryOnly: false,
                                        // optional. Shows only country name and flag when popup is closed.
                                        showOnlyCountryWhenClosed:
                                        false,
                                        // optional. aligns the flag and the Text left
                                        alignLeft: false,
                                      ),
                                    ),
                                    VerticalDivider(width: 2.0,color: Constants
                                        .textColour5,thickness: 1.0,),
                                    Expanded(
                                      child: TextFormField(
                                        keyboardType:
                                        TextInputType.number,
                                        controller: numController,
                                        validator: (value) => value!
                                            .length <=
                                            10 &&
                                            value.isNotEmpty
                                            ? null
                                            : 'Please Enter a Valid Phone Number.',
                                        cursorColor: Colors.grey,
                                        decoration: InputDecoration(
                                          fillColor: Colors.white,
                                          filled: true,
                                          hintText: '102358865',
                                          contentPadding:
                                          const EdgeInsets.all(
                                              16),
                                          hintStyle: TextStyle(
                                              fontSize:
                                              14 * scalefactor,
                                              fontWeight:
                                              FontWeight.w400,
                                              fontFamily:
                                              "Segoe UI",
                                              color: Constants
                                                  .textColour5),
                                          border: InputBorder.none,
                                          // border:
                                          //     OutlineInputBorder(
                                          //   borderRadius:
                                          //       BorderRadius.only(
                                          //     topRight:
                                          //         Radius.circular(
                                          //             10),
                                          //     bottomRight:
                                          //         Radius.circular(
                                          //             10),
                                          //   ),
                                          //   borderSide: BorderSide(
                                          //       color: Constants
                                          //           .textColour5,
                                          //       width: 2.0),
                                          // ),
                                          // focusedBorder:
                                          //     OutlineInputBorder(
                                          //   borderRadius:
                                          //       BorderRadius.only(
                                          //     topRight:
                                          //         Radius.circular(
                                          //             10),
                                          //     bottomRight:
                                          //         Radius.circular(
                                          //             10),
                                          //   ),
                                          //   borderSide: BorderSide(
                                          //       color: Constants
                                          //           .textColour4,
                                          //       width: 2.0),
                                          // ),
                                          // enabledBorder:
                                          //     OutlineInputBorder(
                                          //   borderRadius:
                                          //       BorderRadius.only(
                                          //     topRight:
                                          //         Radius.circular(
                                          //             10),
                                          //     bottomRight:
                                          //         Radius.circular(
                                          //             10),
                                          //   ),
                                          //   borderSide: BorderSide(
                                          //       color: Constants
                                          //           .textColour5,
                                          //       width: 2.0),
                                          // ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Sign Up",
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
                                        builder: (context) => Login()));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Already have an account?",
                                    style: TextStyle(
                                        color: Constants.textColour3,
                                        fontFamily: "Segoe UI",
                                        fontSize: 12 * scalefactor,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  Text(
                                    " Login",
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
                              height: height * 0.1,
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

  Future<bool> onWillPop() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SignUp()));
    return Future.value(true);
  }

  String countryCode = "+92";
  String myCode = "92";
  bool isLogin = false;

  Future<void> _signUp() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    fcmToken = _prefs.getString("fcm");
    lat = _prefs.getString("lat");
    long = _prefs.getString("long");
    cityName = _prefs.getString("getCity");

    print("Inside signup");
    if (userNameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passController.text.isNotEmpty &&
        numController.text.isNotEmpty) {
      print("Inside first if");
      // ignore: unnecessary_brace_in_string_interps
      print("My Code is ${myCode}");
      print(userNameController.text.toString());
      print(emailController.text.toString());
      print(passController.text.toString());
      print(numController.text.toString());
      print(fcmToken.toString());

      var sendResponse = await http.post(Uri.parse(url),
          body: ({
            "username": userNameController.text,
            "email": emailController.text,
            "password": passController.text,
            "code": myCode,
            "phone": numController.text,
            "device_id": fcmToken.toString(),
            "lat": lat.toString(),
            "long": long.toString(),
            "city": cityName.toString(),
            "country_code": countryCodeName,
          }));
      if (sendResponse.statusCode == 200) {
        print("Inside response 200");
        String body = sendResponse.body;
        var jsonBody = jsonDecode(body);
        if (jsonBody["status"] == true) {
          print("Inside success true");

          setState(() {
            isLogin = false;
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Login(),
                ));
          });
        } else if (jsonBody["status"] == false) {
          print("Inside success falsd");
          setState(() {
            isLogin = false;
          });
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(jsonBody["message"])));
        }
      } else {
        print(sendResponse.statusCode);
        setState(() {
          isLogin = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Fields not allowed")));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Must fill all the fields")));
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
