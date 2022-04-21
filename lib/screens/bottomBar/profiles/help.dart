import 'dart:convert';
import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../styles/colors.dart';
import '../../../styles/strings.dart';
import '../bottom_bar.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:developer' as developer;
import 'dart:async';

// ignore: must_be_immutable
class Help extends StatefulWidget {
  var token;
  var myId;
  var myName;
  var email;
  var phone;

  Help({
    Key? key,
    required this.token,
    required this.myId,
    required this.myName,
    required this.email,
    required this.phone,
  }) : super(key: key);

  @override
  HelpState createState() => HelpState();
}

class HelpState extends State<Help> {
  bool isClicked = false;
  bool isSelected = false;
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  var picked;
  final ImagePicker _picker = ImagePicker();
  bool showSpinner = false;
  File? myFile;
  var multipleImages;

  var id;
  var token;
  String countryCodeName = "PK";
  String countryCode = "+92";
  String myCode = "92";

  bool isConnected = false;
  bool isDelaying = false;
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
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => BottomBar(
                                              currentIndex: 3,
                                              categoryId: 1,
                                              categoryName: "All")));
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
                          "Help",
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
                     visible: isClicked ==false,
                     replacement: Expanded(
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           CupertinoActivityIndicator(color: Constants.textColour6,radius: 20.0,)
                         ],
                       ),
                     ),
                     child: Expanded(
                            child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 30),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(
                                                0, 3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Our Team is happy to answer your questions,"
                                              "\n Fill out the form and we'll be in touch"
                                              "\nas soon as possible",
                                              style: TextStyle(
                                                  color: Constants.textColour3,
                                                  fontFamily: "Segoe UI",
                                                  fontSize: 12 * scalefactor,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Divider(
                                            height: 2.0,
                                            color: Constants.textColour4,
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 18.0),
                                            child: TextFormField(
                                              cursorColor: Colors.grey,
                                              // initialValue: widget.email.toString(),style: TextStyle(color: Constants.text_colour3),
                                              controller: userNameController,
                                              decoration: InputDecoration(
                                                fillColor: Colors.white,
                                                filled: true,
                                                labelText: widget.myName != null
                                                    ? widget.myName.toString()
                                                    : "Enter Your Name",
                                                labelStyle: TextStyle(
                                                    fontSize: 14 * scalefactor,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: "Segoe UI",
                                                    color: Constants.textColour5),
                                                contentPadding:
                                                    const EdgeInsets.all(16),
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
                                            height: 20,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 18.0),
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
                                                      controller: phoneController,
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
                                            height: 20,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 18.0),
                                            child: TextFormField(
                                              cursorColor: Colors.grey,
                                              // initialValue: widget.email.toString(),style: TextStyle(color: Constants.text_colour3),
                                              controller: emailController,
                                              decoration: InputDecoration(
                                                fillColor: Colors.white,
                                                filled: true,
                                                labelText: widget.email != null
                                                    ? widget.email.toString()
                                                    : "Enter Your Email",
                                                labelStyle: TextStyle(
                                                    fontSize: 14 * scalefactor,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: "Segoe UI",
                                                    color: Constants.textColour5),
                                                contentPadding:
                                                    const EdgeInsets.all(16),
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
                                            height: 20,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 18.0),
                                            child: TextFormField(
                                              cursorColor: Colors.grey,
                                              // initialValue: widget.email.toString(),style: TextStyle(color: Constants.text_colour3),
                                              controller: subjectController,
                                              decoration: InputDecoration(
                                                fillColor: Colors.white,
                                                filled: true,
                                                labelText: "Subject",
                                                labelStyle: TextStyle(
                                                    fontSize: 14 * scalefactor,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: "Segoe UI",
                                                    color: Constants.textColour5),
                                                contentPadding:
                                                    const EdgeInsets.all(16),
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
                                            height: 20,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 18.0),
                                            child: TextFormField(
                                              maxLength: 250,
                                              maxLines: 3,
                                              cursorColor: Colors.grey,
                                              // initialValue: widget.email.toString(),style: TextStyle(color: Constants.text_colour3),
                                              controller: detailsController,
                                              decoration: InputDecoration(
                                                fillColor: Colors.white,
                                                filled: true,
                                                labelText: "Description",
                                                labelStyle: TextStyle(
                                                    fontSize: 14 * scalefactor,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: "Segoe UI",
                                                    color: Constants.textColour5),
                                                contentPadding:
                                                    const EdgeInsets.all(16),
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
                                            height: 20,
                                          ),
                                          isSelected
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                          horizontal: 18.0),
                                                  child: Container(
                                                    height: 130,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey.shade200,
                                                      borderRadius:
                                                          BorderRadius.circular(10),
                                                      border: Border.all(
                                                          color:
                                                              Constants.textColour3,
                                                          width: 2.0),
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        // imageFileList!.length <= 1
                                                        //     ? Text(
                                                        //         "${myFile!.length.toString()} file added")
                                                        //     : Text(
                                                        //         "${myFile!.length.toString()} files added"),
                                                        // Spacer(),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Stack(
                                                              alignment: Alignment
                                                                  .topRight,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(8.0),
                                                                  child: Container(
                                                                    width: width *
                                                                        0.18,
                                                                    height: 100,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(
                                                                                    10),
                                                                            image:
                                                                                DecorationImage(
                                                                              image:
                                                                                  FileImage(myFile!),
                                                                              fit: BoxFit
                                                                                  .cover,
                                                                            )),
                                                                  ),
                                                                ),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    myFile!
                                                                        .delete();
                                                                    setState(() {
                                                                      isSelected =
                                                                          false;
                                                                    });
                                                                  },
                                                                  child:
                                                                      CircleAvatar(
                                                                          radius:
                                                                              10,
                                                                          backgroundColor:
                                                                              Colors
                                                                                  .black38,
                                                                          child:
                                                                              Icon(
                                                                            Icons
                                                                                .clear,
                                                                            color: Colors
                                                                                .white,
                                                                            size:
                                                                                14,
                                                                          )),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                          horizontal: 18.0),
                                                  child: Container(
                                                    height: 130,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey.shade200,
                                                      borderRadius:
                                                          BorderRadius.circular(10),
                                                      border: Border.all(
                                                          color:
                                                              Constants.textColour3,
                                                          width: 2.0),
                                                    ),
                                                    child: InkWell(
                                                      onTap: () async {
                                                        // var multipleImages=await getScreenShots();
                                                        // if(multipleImages.isNotEmpty)
                                                        //   {
                                                        //     setState(() {
                                                        //
                                                        //     });
                                                        //   }

                                                        getScreenshot();
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Icon(
                                                                Icons.cloud_upload,
                                                                color: Constants
                                                                    .textColour4,
                                                                size: 32,
                                                              ),
                                                              SizedBox(
                                                                height:
                                                                    height * 0.008,
                                                              ),
                                                              Text(
                                                                "Upload ScreenShot",
                                                                style: TextStyle(
                                                                    fontSize: 12 *
                                                                        scalefactor,
                                                                    fontFamily:
                                                                        "Segoe UI",
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Constants
                                                                        .textColour3),
                                                              ),
                                                              Text(
                                                                "Click to drop file",
                                                                style: TextStyle(
                                                                    fontSize: 10 *
                                                                        scalefactor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontFamily:
                                                                        "Segoe UI",
                                                                    color: Constants
                                                                        .textColour4),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                          SizedBox(
                                            height: 30,
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
                                                  Text("Send",
                                                      style: textTheme().subtitle1),
                                                ],
                                              ),
                                              onPressed: () {
                                                if(isInternetDown ==false)
                                                  {
                                                    setStateIfMounted(() {
                                                      isClicked = true;
                                                    });
                                                    _submitHelp();
                                                  }
                                                else{
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                      content: Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
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
                                                // setState(() {
                                                //   print("tap");
                                                //   isLogin=true;
                                                //   _login();
                                                // });
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                        ],
                                      ),
                                    )),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
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

  void getScreenshot() async {
    try {
      final selectedImage =
          await _picker.pickImage(source: ImageSource.gallery);
      if (selectedImage == null) {
        return;
      } else {
        final imageTemporary = (File(selectedImage.path));
        setState(() {
          this.myFile = imageTemporary;
          isSelected = true;
        });
      }
    } on PlatformException catch (e) {
      print("Failed to pick Image : $e");
    }
  }

  Future _submitHelp() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    id = _prefs.getString("customer_id");
    token = _prefs.getString("token");
    print(id);
    print(token);

    Map<String, String> data = {
      "customer_id": id.toString(),
      "name": userNameController.text,
      "email": emailController.text,
      "phone": phoneController.text,
      "subject": subjectController.text,
      "description": detailsController.text,
    };

    Map<String, String> auth = {"Authorization": "Bearer ${token.toString()}"};

    // // Dio dio = Dio();
    // //
    // // final response = await dio.post(
    // //   "http://haulers.tech/jashn/mobile/request/help", //your url here
    // //   data: data ,
    // //   options: Options(
    // //       contentType: 'multipart/form-data',
    // //       headers: {"Authorization": "Bearer ${token.toString()}"},
    // //       followRedirects: false,
    // //       validateStatus: (status) {
    //         return status! <= 500;
    //       }),
    // );

    if (userNameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        subjectController.text.isNotEmpty &&
        detailsController.text.isNotEmpty) {
      var stream = new http.ByteStream(myFile!.openRead());
      stream.cast();
      var length = await myFile!.length();
      var multiPort = new http.MultipartFile('myfile[0]', stream, length,
          filename: myFile!.path);

      // var stream2 = new http.ByteStream(myFile![1].openRead());
      // stream2.cast();
      // var length2 = await myFile![1].length();
      // var multiPort2 = new http.MultipartFile('myfile[1]', stream2, length2,
      //     filename: myFile![1].path);
      //
      // var stream3 = new http.ByteStream(myFile![2].openRead());
      // stream3.cast();
      // var length3 = await myFile![2].length();
      // var multiPort3 = new http.MultipartFile('myfile[2]', stream3, length3,
      //     filename: myFile![2].path);
      // print("\n\n\n\n\n\n");
      // print(newList);
      // print("\n\n\n\n\n\n");
      var url = Uri.parse("http://haulers.tech/jashn/mobile/request/help");
      final multiPartRequest = new http.MultipartRequest('POST', url)
        ..fields.addAll(data)
        ..headers.addAll(auth)
        ..files.add(multiPort);

      // final response = await dio.post(
      //   "http://haulers.tech/jashn/mobile/request/help", //your url here
      //   data: formData ,
      //   options: Options(
      //       contentType: 'multipart/form-data',
      //       headers: {"Authorization": "Bearer ${token.toString()}"},
      //       followRedirects: false,
      //       validateStatus: (status) {
      //         return status! <= 500;
      //       }),
      // );
      // print(response.statusCode);
      // print(response.data);
      //
      // setState(() {
      //   isSelected=false;
      // });

      http.Response response =
          await http.Response.fromStream(await multiPartRequest.send());

      print("\n\n\n\n\n${response.body} \n\n\n\n\n");

      if (response.statusCode == 200) {
        // final respStr = await response.stream.bytesToString();
        print("Inside response.body");
        var jsonBody = jsonDecode(response.body);
        if (jsonBody["success"] == true) {
          print("Json body message: ${jsonBody["message"]}");
          print(jsonBody.toString());
          setState(() {
            isClicked = false;
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BottomBar(
                      currentIndex: 3, categoryId: 1, categoryName: "All"),
                ));
          });
        } else if (jsonBody["success"] == false) {
          setState(() {
            isClicked = false;
          });
          print(jsonBody["message"]);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(jsonBody["message"])));
        }
      } else {
        setState(() {
          isClicked = false;
        });
        print(response.statusCode);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Invalid Response")));
      }
    } else {
      setState(() {
        isClicked = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Must fill all the fields")));
    }
  }

  Future<bool> onWillPop() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => BottomBar(
                currentIndex: 3, categoryId: 1, categoryName: "All")));
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
