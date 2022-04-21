import 'dart:convert';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jashn_user/styles/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../../styles/api_handler.dart';
import '../../../../styles/strings.dart';
import '../../bottom_bar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:developer' as developer;
import 'dart:async';
import 'package:flutter/services.dart';

class BusinessShoutoutDetails extends StatefulWidget {
  final String celebrityId;
  final String amount;
  final String offerId;

  const BusinessShoutoutDetails(
      {Key? key,
      required this.celebrityId,
      required this.amount,
      required this.offerId})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return BusinessShoutoutDetailsState();
  }
}

class BusinessShoutoutDetailsState extends State<BusinessShoutoutDetails> {
  static Handler handler = Handler('request/businessshoutout');
  static String url1 = handler.getUrl();

  String countryCode = "+1";
  String myCode = "92";
  var _id;

  var _token;

  TextEditingController nameController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController webController = TextEditingController();
  TextEditingController fbController = TextEditingController();
  TextEditingController insController = TextEditingController();
  TextEditingController contactNameController = TextEditingController();
  TextEditingController contactTitleController = TextEditingController();
  TextEditingController contactEmailController = TextEditingController();
  TextEditingController contactPhoneController = TextEditingController();

  bool _value = false;
  bool _value2 = true;

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  bool isDelaying = false;
  bool isConnected = false;
  bool isInternetDown = false;
  bool isLoading=false;

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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void validateAndSave() {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      setState(() {
        thirdModal();
      });
    } else {
      print('Form is invalid');
    }
  }

  Map mapBudgetResponse = {};
  List<dynamic> listOfBudgetData = [];
  List<String> listOfValue = [];



  void _onCountryChange(CountryCode code) {
    setState(() {
      countryCode = code.toString();
    });
    myCode = countryCode.substring(1);
    print(countryCode);
  }

  Widget _widget() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double scalefactor = MediaQuery.of(context).textScaleFactor;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leadingWidth: 70,
          leading: Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  elevation: 6,
                  borderRadius: BorderRadius.circular(64),
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
              ),
            ],
          ),
        ),
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
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Business Shoutouts",
                              style: TextStyle(
                                  color: Constants.textColour3,
                                  fontFamily: "Segoe UI",
                                  fontSize: 20 * scalefactor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 28.0),
                          child: Text(
                            "Increase your brand reach instantly by a direct business shout-out from your favorite celebrities. Get your "
                                "brand the recognition it deserves by requesting a business shout-out.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Constants.textColour3,
                                fontFamily: "Segoe UI",
                                fontSize: 12 * scalefactor,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 340,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Constants.textColour5,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Text(
                                      "Business Details",
                                      style: TextStyle(
                                        color: Constants.textColour3,
                                        fontFamily: "Segoe UI",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20 * scalefactor,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0, right: 16.0),
                                      child: TextFormField(
                                        validator: (value) =>
                                        value!.isNotEmpty ? null :'Please Enter Business Name.',
                                        controller: nameController,
                                        cursorColor: Colors.grey,
                                        decoration: InputDecoration(
                                          fillColor: Colors.white,
                                          filled: true,
                                          labelText: "Enter Business Name",
                                          labelStyle: TextStyle(
                                              fontSize: 14 * scalefactor,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "Segoe UI",
                                              color: Constants.textColour5),
                                          contentPadding: const EdgeInsets.all(16),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Constants.textColour5,
                                                width: 1.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Constants.textColour4,
                                                width: 1.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Constants.textColour5,
                                                width: 1.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0, right: 16.0),
                                      child: TextFormField(
                                        controller: detailsController,
                                        validator: (value) =>
                                        value!.isNotEmpty ? null :'Please Fill Details.',
                                        maxLines: 5,
                                        cursorColor: Colors.grey,
                                        decoration: InputDecoration(
                                          fillColor: Colors.white,
                                          filled: true,
                                          labelText: "Business Shoutout Details",
                                          labelStyle: TextStyle(
                                              fontSize: 14 * scalefactor,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "Segoe UI",
                                              color: Constants.textColour5),
                                          contentPadding: const EdgeInsets.all(16),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Constants.textColour5,
                                                width: 1.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Constants.textColour4,
                                                width: 1.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Constants.textColour5,
                                                width: 1.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    // Padding(
                                    //   padding: const EdgeInsets.symmetric(
                                    //       horizontal: 12.0),
                                    //   child: Container(
                                    //     decoration: ShapeDecoration(
                                    //       shape: RoundedRectangleBorder(
                                    //         side: BorderSide(
                                    //           width: 1.0,
                                    //           style: BorderStyle.solid,
                                    //           color: Constants.textColour5,
                                    //         ),
                                    //         borderRadius: BorderRadius.all(
                                    //             Radius.circular(15.0)),
                                    //       ),
                                    //     ),
                                    //     child: Padding(
                                    //       padding: const EdgeInsets.symmetric(
                                    //           horizontal: 12.0),
                                    //       child: DropdownSearch<String>(
                                    //         dropdownSearchDecoration:
                                    //             InputDecoration(
                                    //                 hintText: "  Select Occasion",
                                    //                 hintStyle: TextStyle(
                                    //                     fontSize: 14 * scalefactor,
                                    //                     fontWeight: FontWeight.w400,
                                    //                     fontFamily: "Segoe UI",
                                    //                     color:
                                    //                         Constants.textColour5),
                                    //                 border: InputBorder.none),
                                    //         mode: Mode.MENU,
                                    //         showSelectedItems: true,
                                    //         items: listOfValue.isNotEmpty
                                    //             ? listOfValue
                                    //             : ["data is loading"],
                                    //         onChanged: (data) {
                                    //           _selectedText = data!;
                                    //         },
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    // SizedBox(
                                    //   height: 15,
                                    // ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0, right: 16.0),
                                      child: TextFormField(
                                        controller: webController,
                                        cursorColor: Colors.grey,
                                        validator: (value) =>
                                        value!.startsWith("http") && value.isNotEmpty ? null :'Please Enter a Valid Website Link',
                                        decoration: InputDecoration(
                                          fillColor: Colors.white,
                                          filled: true,
                                          labelText: "Business Website",
                                          labelStyle: TextStyle(
                                              fontSize: 14 * scalefactor,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "Segoe UI",
                                              color: Constants.textColour5),
                                          contentPadding: const EdgeInsets.all(16),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Constants.textColour5,
                                                width: 1.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Constants.textColour4,
                                                width: 1.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Constants.textColour5,
                                                width: 1.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0, right: 16.0),
                                      child: TextFormField(
                                        controller: fbController,
                                        cursorColor: Colors.grey,
                                        validator: (value) =>
                                        value!.isNotEmpty ? null :'Please Enter Facebook Link',
                                        decoration: InputDecoration(
                                          fillColor: Colors.white,
                                          filled: true,
                                          labelText: "Facebook Page",
                                          labelStyle: TextStyle(
                                              fontSize: 14 * scalefactor,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "Segoe UI",
                                              color: Constants.textColour5),
                                          contentPadding: const EdgeInsets.all(16),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Constants.textColour5,
                                                width: 1.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Constants.textColour4,
                                                width: 1.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Constants.textColour5,
                                                width: 1.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0, right: 16.0),
                                      child: TextFormField(
                                        controller: insController,
                                        cursorColor: Colors.grey,
                                        validator: (value) =>
                                        value!.isNotEmpty ? null :'Please Enter Instagram Link',
                                        decoration: InputDecoration(
                                          fillColor: Colors.white,
                                          filled: true,
                                          labelText: "Instagram Page",
                                          labelStyle: TextStyle(
                                              fontSize: 14 * scalefactor,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "Segoe UI",
                                              color: Constants.textColour5),
                                          contentPadding: const EdgeInsets.all(16),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Constants.textColour5,
                                                width: 1.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Constants.textColour4,
                                                width: 1.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Constants.textColour5,
                                                width: 1.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Text(
                                      "Contact Person",
                                      style: TextStyle(
                                        color: Constants.textColour3,
                                        fontFamily: "Segoe UI",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20 * scalefactor,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0, right: 16.0),
                                      child: TextFormField(
                                        controller: contactNameController,
                                        cursorColor: Colors.grey,
                                        validator: (value) =>
                                        value!.isNotEmpty ? null :'Please Provide Contact Person Name',
                                        decoration: InputDecoration(
                                          fillColor: Colors.white,
                                          filled: true,
                                          labelText: "Contact Name",
                                          labelStyle: TextStyle(
                                              fontSize: 14 * scalefactor,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "Segoe UI",
                                              color: Constants.textColour5),
                                          contentPadding: const EdgeInsets.all(16),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Constants.textColour5,
                                                width: 1.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Constants.textColour4,
                                                width: 1.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Constants.textColour5,
                                                width: 1.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0, right: 16.0),
                                      child: TextFormField(
                                        controller: contactTitleController,
                                        cursorColor: Colors.grey,
                                        validator: (value) =>
                                        value!.isNotEmpty ? null :'Please Provide Your Designation',
                                        decoration: InputDecoration(
                                          fillColor: Colors.white,
                                          filled: true,
                                          labelText: "Contact Title",
                                          labelStyle: TextStyle(
                                              fontSize: 14 * scalefactor,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "Segoe UI",
                                              color: Constants.textColour5),
                                          contentPadding: const EdgeInsets.all(16),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Constants.textColour5,
                                                width: 1.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Constants.textColour4,
                                                width: 1.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Constants.textColour5,
                                                width: 1.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0, right: 16.0),
                                      child: TextFormField(
                                        controller: contactEmailController,
                                        cursorColor: Colors.grey,
                                        validator: (value) =>
                                        value!.contains("@") && value.isNotEmpty ? null :'Please Provide a Valid Email',
                                        decoration: InputDecoration(
                                          fillColor: Colors.white,
                                          filled: true,
                                          labelText: "Email Address",
                                          labelStyle: TextStyle(
                                              fontSize: 14 * scalefactor,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "Segoe UI",
                                              color: Constants.textColour5),
                                          contentPadding: const EdgeInsets.all(16),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Constants.textColour5,
                                                width: 1.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Constants.textColour4,
                                                width: 1.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Constants.textColour5,
                                                width: 1.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
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
                                                controller: contactPhoneController,
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
                                      height: 7,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0, right: 16.0),
                                      child: Text(
                                        "We’ll send you a code to verify your mobile number",
                                        style: TextStyle(
                                          color: Constants.textColour4,
                                          fontFamily: "Segoe UI",
                                          fontWeight: FontWeight.normal,
                                          fontSize: 10 * scalefactor,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Center(
                                      child: Container(
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
                                              Text("Continue to Payment",
                                                  style: textTheme().subtitle1),
                                            ],
                                          ),
                                          onPressed: () {
                                            if(isInternetDown ==false)
                                              {
                                                validateAndSave();
                                              }
                                            else {
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
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  thirdModal() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double scalefactor = MediaQuery.of(context).textScaleFactor;
    return showModalBottomSheet(
        backgroundColor: Colors.white,
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
              child: isLoading
                  ?Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  child: Wrap(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 28.0),
                        child: Container(
                          width: width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Spacer(
                                flex: 2,
                              ),
                              Text(
                                "Payment Method",
                                style: TextStyle(
                                    color: Constants.textColour3,
                                    fontFamily: "Segoe UI",
                                    fontSize: 18 * scalefactor,
                                    fontWeight: FontWeight.bold),
                              ),
                              Spacer(
                                flex: 1,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                    padding: const EdgeInsets.only(right: 28.0),
                                    child: CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Colors.red,
                                      child: Icon(
                                        Icons.clear,
                                        color: Constants.textColour1,
                                        size: 20,
                                      ),
                                    )
                                  /*GestureDetector(
                                              onTap: (){
                                                Navigator.pop(context);
                                              },
                                              child: Icon(Icons.clear,color: Constants.textColour3,)),*/
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: width / 1.3,
                            height: height*0.2,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),

                          ),
                        ],
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     ElevatedButton(
                      //       child: Container(
                      //         width: MediaQuery.of(context).size.width *0.8,
                      //         height: 55,
                      //
                      //         alignment: Alignment.center,
                      //         child: Text(
                      //           "Activate Code",
                      //           style: TextStyle(
                      //               color: Constants.textColour1,
                      //               fontFamily: "Segoe UI",
                      //               fontSize: 14,
                      //               fontWeight: FontWeight.bold),
                      //         ),
                      //       ),
                      //       onPressed: () {
                      //         print("API hit called");
                      //         _apiHit();
                      //
                      //       },
                      //       style: ButtonStyle(
                      //         shape: MaterialStateProperty.all<
                      //             RoundedRectangleBorder>(
                      //             RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(30.0),
                      //             )),
                      //         backgroundColor: MaterialStateProperty.all(
                      //             Constants.buttonColourMix4),
                      //       ),
                      //     ),
                      //   ],),

                    ],
                  ),
                ),
              )
              :Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  child: Wrap(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 28.0),
                        child: Container(
                          width: width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Spacer(
                                flex: 2,
                              ),
                              Text(
                                "Payment Method",
                                style: TextStyle(
                                    color: Constants.textColour3,
                                    fontFamily: "Segoe UI",
                                    fontSize: 18 * scalefactor,
                                    fontWeight: FontWeight.bold),
                              ),
                              Spacer(
                                flex: 1,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                    padding: const EdgeInsets.only(right: 28.0),
                                    child: CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Colors.red,
                                      child: Icon(
                                        Icons.clear,
                                        color: Constants.textColour1,
                                        size: 20,
                                      ),
                                    )
                                    /*GestureDetector(
                                              onTap: (){
                                                Navigator.pop(context);
                                              },
                                              child: Icon(Icons.clear,color: Constants.textColour3,)),*/
                                    ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        color: Constants.textColour4,
                        height: 2.0,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Jash\'n Wallet",
                              style: TextStyle(
                                  color: Constants.textColour4,
                                  fontFamily: "Segoe UI",
                                  fontSize: 14 * scalefactor,
                                  fontWeight: FontWeight.w600),
                            ),
                            Center(
                                child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (_value2 == true) {
                                    _value2 = !_value2;
                                  }
                                  _value = !_value;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _value
                                        ? Colors.greenAccent
                                        : Constants.textColour1,
                                    border: Border.all(
                                        color: _value
                                            ? Colors.greenAccent
                                            : Constants.textColour4,
                                        width: 2.0)),
                                child: _value
                                    ? Icon(
                                        Icons.check,
                                        size: 20.0,
                                        color: Constants.textColour3,
                                      )
                                    : SizedBox(
                                        width: 20,
                                        height: 20,
                                      ),
                              ),
                            )),
                          ],
                        ),
                      ),

                      Row(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Debit / Credit Card",
                              style: TextStyle(
                                  color: Constants.textColour4,
                                  fontFamily: "Segoe UI",
                                  fontSize: 14 * scalefactor,
                                  fontWeight: FontWeight.w600),
                            ),
                            Center(
                                child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (_value == true) {
                                    _value = !_value;
                                  }
                                  _value2 = !_value2;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _value2
                                        ? Colors.greenAccent
                                        : Constants.textColour1,
                                    border: Border.all(
                                        color: _value2
                                            ? Colors.greenAccent
                                            : Constants.textColour4,
                                        width: 2.0)),
                                child: _value2
                                    ? Icon(
                                        Icons.check,
                                        size: 20.0,
                                        color: Constants.textColour3,
                                      )
                                    : SizedBox(
                                        width: 20,
                                        height: 20,
                                      ),
                              ),
                            )),
                          ],
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
                                  Text("Submit", style: textTheme().subtitle1),
                                ],
                              ),
                              onPressed: () {
                                if(isInternetDown ==false)
                                {
                                  setState((){
                                    isLoading=true;
                                  });

                                  _sendBusinessShoutOutData();
                                }
                                else {
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
                                print("API hit called");
                                // _apiHit();

                                // promoController.clear();
                              },
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
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  Future<bool> onWillPop() {
    Navigator.pop(context);
    return Future.value(true);
  }

  Future<void> _sendBusinessShoutOutData() async {
    SharedPreferences _prefs=await SharedPreferences.getInstance();
    _id = _prefs.getString("customer_id");
    _token=_prefs.getString("token");


    print("Click on fetch data");
    print(_id.toString());
    print(widget.celebrityId);
    print(nameController.text);
    print(
      detailsController.text,
    );
    print(widget.amount);
    print(webController.text);
    print(fbController.text);
    print(insController.text);
    print(contactNameController.text);
    print(contactTitleController.text);
    print(contactEmailController.text);
    print(contactPhoneController.text);
    print(myCode);
    print(widget.offerId);
    print(_token.toString());
    var url = Uri.parse(url1);
    var businessShoutOutResponse = await http.post(url,
        body: ({
          "customer_id": _id.toString(),
          "celebrity_id": widget.celebrityId,
          "business_name": nameController.text,
          "shoutout_details": detailsController.text,
          "budget": widget.amount,
          "business_website": webController.text,
          "business_facebook": fbController.text,
          "business_instagram": insController.text,
          "contact_person": contactNameController.text,
          "contact_title": contactTitleController.text,
          "contact_email": contactEmailController.text,
          "phone": contactPhoneController.text,
          "code": myCode,
          "paid_offer_id": widget.offerId,
          "isPublic":"1",
          "payment_mode_id": _value ? "2" : "1"
        }),
        headers: ({
          "Authorization": 'Bearer $_token',
        }));
    if (businessShoutOutResponse.statusCode == 200) {
      print(businessShoutOutResponse.body);
      var response = jsonDecode(businessShoutOutResponse.body);
      if (response["success"] == true) {
        setState(() {
          isLoading=false;
        });
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BottomBar(
                  currentIndex: 2, categoryId: 1, categoryName: "All"),
            ));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Our Representative will contact you soon")));
      }
      if (response["success"] == false) {
        setState(() {
          isLoading=false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Something missing")));
      } else {
        setState(() {
          isLoading=false;
        });
        print(businessShoutOutResponse.statusCode);
      }
    } else {
      setState(() {
        isLoading=false;
      });
      print(businessShoutOutResponse.statusCode);
      print("Invalid in else condition");
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
}
