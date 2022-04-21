import 'dart:convert';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:jashn_user/styles/colors.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../styles/api_handler.dart';
import '../../../../styles/strings.dart';
import '../../bottom_bar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:developer' as developer;
import 'dart:async';
import 'package:flutter/services.dart';

class BookVideoShoutoutDetails extends StatefulWidget {
  final String name;
  final String isFriend;
  final String offerId;
  final String celebrityId;
  final String amount;

  const BookVideoShoutoutDetails(
      {Key? key,
      required this.name,
      required this.isFriend,
      required this.offerId,
      required this.celebrityId,
      required this.amount})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return BookVideoShoutoutDetailsState();
  }
}

class BookVideoShoutoutDetailsState extends State<BookVideoShoutoutDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void validateAndSave() {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      setState(() {
        settingModal();
      });
    } else {
      print('Form is invalid');
    }
  }

  static Handler handler2 = Handler('request/coupon');
  static String url2 = handler2.getUrl();
  static Handler handler3 = Handler('request/shoutout');
  static String url3 = handler3.getUrl();

  TextEditingController nameController = TextEditingController();
  TextEditingController occasionController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController promoController = TextEditingController();
  String countryCode = "+92";
  bool isSwitched = true;
  String selectedText = "other";
  String myCode = "92";
  String number = "";
  var id;
  var token;
  var promoCode;
  var promoValue;
  var totalValue;
  var promoId;

  bool _value = false;
  bool _value2 = true;

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  bool isDelaying = false;
  bool isDataLoading = false;
  bool isConnected = false;
  bool isInternetDown = false;

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
      _fetchData().whenComplete(() {
        setStateIfMounted(() {
          isDataLoading = true;
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

  Map mapResponse = {};
  List<dynamic> listOfData = [];
  List<String> listOfOccasion = [];

  Future _fetchData() async {
    Handler handler = Handler('home/occasion');
    String url1 = handler.getUrl();

    SharedPreferences _prefs = await SharedPreferences.getInstance();
    id = _prefs.getString("customer_id").toString();
    token = _prefs.getString("token").toString();
    print("Click on fetch data");
    var url = Uri.parse(url1);
    var response = await http.post(url,
        body: ({
          "customer_id": id,
        }),
        headers: ({
          "Authorization": 'Bearer $token',
        }));
    if (response.statusCode == 200) {
      print("Response coming :${response.statusCode}");
      setState(() {
        mapResponse = jsonDecode(response.body);
        listOfData = mapResponse["data"];
        for (int i = 0; i < listOfData.length; i++) {
          listOfOccasion.insert(i, listOfData[i]["occassion"]);
        }
      });
    } else {
      print("Request failed to response :${response.statusCode}");
    }
  }

  void _onCountryChange(CountryCode code) {
    setState(() {
      countryCode = code.toString();
    });
    myCode = countryCode.substring(1);
    print(myCode);
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
          title: Text(
            "Video Shoutout",
            style: homeTextTheme().subtitle2,
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
            child: Visibility(
              visible: isInternetDown == false || isConnected,
              replacement: Container(
                width: width,
                height: height,
                color: Constants.textColour4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Image.asset(
                              "assets/sad-face-in-rounded-square.png",
                              width: 30,
                              height: 30,
                              color: Constants.textColour1,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'OOPS !',
                              style: TextStyle(
                                  color: Constants.textColour1,
                                  fontFamily: "Segoe UI",
                                  fontSize: 30 * scalefactor),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'No Internet Connection...',
                              style: TextStyle(
                                  color: Constants.textColour1,
                                  fontFamily: "Segoe UI",
                                  fontSize: 20 * scalefactor),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              child: Visibility(
                visible: isDataLoading && isConnected,
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
                        height: 15,
                      ),
                      Expanded(
                        child: Form(
                          key: _formKey,
                          child: ListView(
                            children: [
                              Container(
                                color: Color(0xE9E7E7),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            "You can book your personalized video",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Constants.textColour3,
                                              fontFamily: "Segoe UI",
                                              fontSize: 14 * scalefactor,
                                            ),
                                          ),
                                          SizedBox(
                                            height: height * 0.01,
                                          ),
                                          Text(
                                            "shout-out simply by submitting this form",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Constants.textColour3,
                                              fontFamily: "Segoe UI",
                                              fontSize: 14 * scalefactor,
                                            ),
                                          ),
                                          SizedBox(
                                            height: height * 0.01,
                                          ),
                                          Text(
                                            "detailing your request.",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Constants.textColour3,
                                              fontFamily: "Segoe UI",
                                              fontSize: 14 * scalefactor,
                                            ),
                                          ),
                                          SizedBox(
                                            height: height * 0.01,
                                          ),
                                          Text(
                                            widget.name,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Constants.textColour6,
                                              fontFamily: "Segoe UI",
                                              fontSize: 14 * scalefactor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Enter your details below.",
                                    style: TextStyle(
                                      color: Constants.textColour3,
                                      fontFamily: "Segoe UI",
                                      fontSize: 14 * scalefactor,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              widget.isFriend == "1"
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          left: 32.0, right: 32.0),
                                      child: TextFormField(
                                        validator: (value) => value!.isNotEmpty
                                            ? null
                                            : 'Please Provide Name Of Your Friend.',
                                        controller: nameController,
                                        cursorColor: Colors.grey,
                                        decoration: InputDecoration(
                                          fillColor: Colors.white,
                                          filled: true,
                                          hintText: 'Enter Your Friend\'s Name',
                                          contentPadding:
                                              const EdgeInsets.all(16),
                                          hintStyle: TextStyle(
                                              fontSize: 14 * scalefactor,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "Segoe UI",
                                              color: Constants.textColour5),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Constants.textColour5,
                                                width: 2.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Constants.textColour4,
                                                width: 2.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Constants.textColour5,
                                                width: 2.0),
                                          ),
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 32.0, right: 32.0),
                                child: Container(
                                  height: 52,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        width: 2.0,
                                        style: BorderStyle.solid,
                                        color: Constants.textColour5,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    child: DropdownSearch<String>(
                                      dropdownSearchDecoration: InputDecoration(
                                          hintText: "  Select Occasion",
                                          hintStyle: TextStyle(
                                              fontSize: 14 * scalefactor,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "Segoe UI",
                                              color: Constants.textColour5),
                                          border: InputBorder.none),
                                      mode: Mode.MENU,
                                      showSelectedItems: true,
                                      items: listOfOccasion,
                                      onChanged: (data) {
                                        selectedText = data!;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 32.0, right: 32.0),
                                child: TextFormField(
                                  validator: (value) => value!.isNotEmpty
                                      ? null
                                      : 'Must Enter Details About Your Shoutout',
                                  controller: detailController,
                                  maxLines: 4,
                                  cursorColor: Colors.grey,
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText:
                                        'What Kind Of Shoutout You want. Please Provide Complete Details of Your Shoutout.',
                                    contentPadding: const EdgeInsets.all(16),
                                    hintStyle: TextStyle(
                                        fontSize: 14 * scalefactor,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "Segoe UI",
                                        color: Constants.textColour5),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: Constants.textColour5,
                                          width: 2.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: Constants.textColour4,
                                          width: 2.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
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
                                    horizontal: 32.0),
                                child: Container(
                                  height: 55,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Constants
                                            .textColour5,
                                        width: 2.0),
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
                                          .textColour5,thickness: 2.0,),
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
                                padding: const EdgeInsets.only(
                                    left: 24.0, right: 24.0),
                                child: Row(
                                  children: [
                                    Switch(
                                      value: isSwitched,
                                      onChanged: (value) {
                                        setState(() {
                                          isSwitched = value;
                                          print(isSwitched);
                                        });
                                      },
                                      activeTrackColor: Constants.textColour6,
                                      activeColor: Constants.textColour6,
                                    ),
                                    Text(
                                      "Make this video public on Jash\'n",
                                      style: TextStyle(
                                        color: Constants.textColour3,
                                        fontFamily: "Segoe UI",
                                        fontSize: 12 * scalefactor,
                                      ),
                                    ),
                                  ],
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
                                      if (isInternetDown == false) {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
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
                              ),
                              SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  settingModal() {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    double scalefactor = MediaQuery.of(context).textScaleFactor;

    var discount = promoValue == null ? "0" : promoValue.toString();

    var myCode = promoCode == null ? "No Promo" : promoCode.toString();
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
                              "Book Your Shoutout",
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
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     Container(
                    //       width: width*0.4,
                    //       child: Padding(
                    //         padding: const EdgeInsets.all(8.0),
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.start,
                    //           crossAxisAlignment: CrossAxisAlignment.end,
                    //           children: [
                    //             SizedBox(width: 20,),
                    //             promoCode == "null"
                    //             ?Text(
                    //               "No Promo",
                    //               style: TextStyle(
                    //                   color: Constants.textColour5,
                    //                   fontFamily: "Segoe UI",
                    //                   fontSize: 16,
                    //                   fontWeight: FontWeight.bold),
                    //             )
                    //             :Text(
                    //               promoCode.toString(),
                    //               style: TextStyle(
                    //                   color: Constants.textColour3,
                    //                   fontFamily: "Segoe UI",
                    //                   fontSize: 16,
                    //                   fontWeight: FontWeight.bold),
                    //             ),
                    //             SizedBox(width: 20,),
                    //             promoCode == "null"
                    //                 ?SizedBox()
                    //               : InkWell(
                    //                 onTap: () async{
                    //                   SharedPreferences _prefs=await SharedPreferences.getInstance();
                    //                   _prefs.remove("promoCode");
                    //                   _prefs.remove("promoValue");
                    //                   _prefs.remove("promoTotal");
                    //                   Navigator.pushReplacement(
                    //                       context,
                    //                       MaterialPageRoute(
                    //                           builder: (context) =>
                    //                               BookVideoShoutoutDetails(amount:widget.amount,name: widget.name,isFriend: widget.isFriend, offerId: widget.offerId,celebrityId: widget.celebrityId,)));
                    //                 },
                    //                 child: Icon(Icons.cancel,color: Constants.textColour5,))
                    //
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //     Expanded(
                    //       child: Padding(
                    //         padding: const EdgeInsets.all(8.0),
                    //         child: InkWell(
                    //           onTap: () async{
                    //             secondModal();
                    //           },
                    //           child: Row(
                    //             mainAxisAlignment: MainAxisAlignment.start,
                    //             crossAxisAlignment: CrossAxisAlignment.end,
                    //             children: [
                    //               SizedBox(width: 20,),
                    //               Stack(
                    //                 alignment: Alignment.center,
                    //                 children: [
                    //                   Icon(FontAwesomeIcons.certificate,color: Constants.buttonColourMix3,),
                    //                   Icon(FontAwesomeIcons.percent,color: Constants.textColour1,size: 12,)
                    //                 ],),
                    //               SizedBox(width: 20,),
                    //               Text(
                    //                 "Discounts".toUpperCase(),
                    //                 style: TextStyle(
                    //                     color: Constants.textColour5,
                    //                     fontFamily: "Segoe UI",
                    //                     fontSize: 16,
                    //                     fontWeight: FontWeight.bold),
                    //               ),
                    //               SizedBox(width: 20,),
                    //               Icon(Icons.arrow_drop_down,color: Constants.textColour3,)
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //
                    //   ],
                    // ),
                    Row(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: width * 0.2,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 28.0),
                          child: Row(
                            children: [
                              Text(
                                "Promo: ",
                                style: TextStyle(
                                    color: Constants.textColour3,
                                    fontFamily: "Segoe UI",
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                myCode.toString(),
                                style: TextStyle(
                                    color: Constants.textColour3,
                                    fontFamily: "Segoe UI",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              )
                            ],
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: width * 0.2,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 28.0),
                          child: Row(
                            children: [
                              Text(
                                "Sub Total: PKR. ",
                                style: TextStyle(
                                    color: Constants.textColour3,
                                    fontFamily: "Segoe UI",
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                widget.amount.toString(),
                                style: TextStyle(
                                    color: Constants.textColour3,
                                    fontFamily: "Segoe UI",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: width * 0.2,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 28.0),
                          child: Row(
                            children: [
                              Text(
                                "Discount: PKR. ",
                                style: TextStyle(
                                    color: Constants.textColour3,
                                    fontFamily: "Segoe UI",
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                discount.toString(),
                                style: TextStyle(
                                    color: Constants.textColour3,
                                    fontFamily: "Segoe UI",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: width * 0.2,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 28.0),
                          child: Row(
                            children: [
                              Text(
                                "Total Amount: PKR.",
                                style: TextStyle(
                                    color: Constants.textColour3,
                                    fontFamily: "Segoe UI",
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                totalValue == null
                                    ? widget.amount.toString()
                                    : totalValue.toString(),
                                style: TextStyle(
                                    color: Constants.textColour3,
                                    fontFamily: "Segoe UI",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
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
                                Text("Book Now", style: textTheme().subtitle1),
                              ],
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              thirdModal();
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: width / 1.3,
                          height: 50,
                          decoration: ShapeDecoration(
                            shape: StadiumBorder(),
                            color: Constants.textColour4,
                          ),
                          child: MaterialButton(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            shape: StadiumBorder(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Add Promo", style: textTheme().subtitle1),
                              ],
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              secondModal();
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
            );
          });
        });
  }

  secondModal() {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
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
              child: Padding(
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
                                "Add Promo",
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
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  Navigator.pop(context);
                                  promoController.clear();
                                  settingModal();
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
                            height: 50,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50, right: 50),
                        child: TextFormField(
                          controller: promoController,
                          cursorColor: Colors.grey,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Enter Promo Code',
                            contentPadding: const EdgeInsets.only(left: 24),
                            hintStyle: TextStyle(
                                fontSize: 12 * scalefactor,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Mulish',
                                color: Constants.textColour5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Constants.textColour5, width: 2.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Constants.textColour4, width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Constants.textColour5, width: 2.0),
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
                                  Text("Add", style: textTheme().subtitle1),
                                ],
                              ),
                              onPressed: () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());

                                print("API hit called");
                                _apiHit();

                                // promoController.clear();
                              },
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

  thirdModal() {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
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
              child: Padding(
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
                                  settingModal();
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
                                  _value = true;
                                });
                                print("$_value 1");
                                print("$_value2 1");
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
                                  _value2 = true;
                                });
                                print("$_value 2");
                                print("$_value2 2");
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
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());

                                print("API hit called");
                                _sendData();

                                Navigator.pop(context);

                                // promoController.clear();
                              },
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

  Future<void> _apiHit() async {
    if (promoController.text.isNotEmpty) {
      print(promoController.text);
      print(widget.celebrityId);
      print(widget.amount);
      print(id.toString());
      print(token.toString());
      var promoResponse = await http.post(
        Uri.parse(url2),
        body: ({
          "coupon": promoController.text,
          "celebrity_id": widget.celebrityId,
          "total": widget.amount,
          "customer_id": id.toString(),
        }),
        headers: ({
          "Authorization": "Bearer $token",
        }),
      );
      print("in if condition response coming");
      print(promoResponse.body);
      if (promoResponse.statusCode == 200) {
        print(" in if condition status code 200");
        Map body = jsonDecode(promoResponse.body);
        print(body.toString());
        if (body["success"] == true) {
          promoCode = body["code"];
          promoValue = body["value"];
          totalValue = body["total"];
          promoId = body["promo_id"];
          settingModal();
          _messageDialog(context, "Promo Code Accepted", "OK");
        } else {
          _messageDialog(context, body["message"], "OK");
        }
      } else {
        print(" in else condition else condition");
        _messageDialog(context, "Not Allowed to submit", "OK");
        print("Response = ${promoResponse.statusCode}");
      }
    } else {
      print("No Promo code");
      _messageDialog(context, "Enter Promo code First", "OK");
    }
  }

  Future<void> _sendData() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var name = _prefs.getString("name");
    number = phoneController.text;
    String phoneNumber = "$myCode$number";
    String typeId = isSwitched ? "1" : "2";
    print(selectedText);

    print(name.toString());
    print(selectedText.toString());
    print(detailController.text);
    print(phoneNumber);
    print(id.toString());
    print(widget.offerId);
    print(typeId);
    print(widget.celebrityId);
    print(isSwitched.toString());
    print(promoCode.toString());
    print(promoId.toString());
    print(totalValue.toString());
    print(_value);
    print(token.toString());

    if (typeId == "2") {
      print(" in if condition");
      var shoutOutResponse = await http.post(
        Uri.parse(url3),
        body: ({
          "shoutout_for": nameController.text,
          "occasion": selectedText,
          "instruction": detailController.text,
          "mobile": phoneNumber,
          "customer_id": id.toString(),
          "paid_offer_id": widget.offerId,
          "shoutout_type": typeId,
          "celebrity_id": widget.celebrityId,
          "isPublic": isSwitched ? "1" : "0",
          "promo_code": promoCode != null ? promoCode.toString() : "",
          "promo_id": promoId != null ? promoId.toString() : "",
          "total": totalValue == null ? widget.amount : totalValue.toString(),
          "payment_mode_id": _value ? "2" : "1"
        }),
        headers: ({
          "Authorization": "Bearer ${token.toString()}",
        }),
      );

      print(" in if condition response coming");

      if (shoutOutResponse.statusCode == 200) {
        print(" in if condition code 200");
        print(shoutOutResponse.body);
        Map responseBody = jsonDecode(shoutOutResponse.body.toString());
        if (responseBody["success"] == true) {
          print(" in if condition success= true");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Form has been submitted."
                "Thank You"),
          ));
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BottomBar(
                    currentIndex: 2, categoryId: 1, categoryName: "All"),
              ));
        } else if (responseBody["success"] == false) {
          print(" in if condition success = false");
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("You are not authorize to use this api")));
        }
      } else {
        print(shoutOutResponse.body.toString());
        print(" in if condition else condition");
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Not Allowed to submit")));
        print("Response = ${shoutOutResponse.statusCode}");
      }
    } else {
      print(" in else condition");
      print(selectedText);
      var shoutOutResponse = await http.post(
        Uri.parse(url3),
        body: ({
          "shoutout_for": name.toString(),
          "occasion": selectedText,
          "instruction": detailController.text,
          "mobile": phoneNumber,
          "customer_id": id.toString(),
          "paid_offer_id": widget.offerId,
          "shoutout_type": typeId,
          "celebrity_id": widget.celebrityId,
          "isPublic": isSwitched ? "1" : "0",
          "promo_code": promoCode != null ? promoCode.toString() : "",
          "promo_id": promoId != null ? promoId.toString() : "",
          "total": totalValue == null ? widget.amount : totalValue.toString(),
          "payment_mode_id": _value ? "2" : "1"
        }),
        headers: ({
          "Authorization": "Bearer $token",
        }),
      );
      print(" in else condition response coming");
      if (shoutOutResponse.statusCode == 200) {
        print(" in else condition status code 200");
        String body = shoutOutResponse.body;
        print(body.toString());
        print(body);
        var jsonBody = jsonDecode(body);
        if (jsonBody["success"] == true) {
          print(" in else condition success ==true");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Form has been submitted."
                "Thank You"),
          ));
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BottomBar(
                    currentIndex: 2, categoryId: 1, categoryName: "All"),
              ));
        }
        if (jsonBody["success"] == false) {
          print(" in else condition success ==false");

          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("You are not authorize to use this api")));
        }
      } else {
        print(" in else condition else condition");
        print(shoutOutResponse.body.toString());
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Not Allowed to submit")));
        print("Response = ${shoutOutResponse.statusCode}");
      }
    }
  }

  Future<bool> onWillPop() {
    Navigator.pop(context);
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
