import 'dart:convert';
import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jashn_user/styles/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../styles/api_handler.dart';
import '../../../styles/strings.dart';
import '../bottom_bar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:developer' as developer;
import 'dart:async';


// ignore: must_be_immutable
class EditProfile extends StatefulWidget {
  var token;
  var myId;
  var myName;
  var email;
  var phone;
  var myImage;

  EditProfile(
      {Key? key,
      required this.token,
      required this.myId,
      required this.myName,
      required this.email,
      required this.phone,
      required this.myImage})
      : super(key: key);

  @override
  EditProfileState createState() => EditProfileState();
}

class EditProfileState extends State<EditProfile> {
  static Handler handler = Handler('user/updateprofile"');
  static String url1 = handler.getUrl();

  String countryCode = "+92";
  String myCode = "92";

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  late File pickedFile;

  bool isClicked = false;
  String countryCodeName = "PK";

  bool isDelaying = false;
  bool isConnected = false;
  bool isInternetDown = false;

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

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
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => BottomBar(
                                                currentIndex: 3,
                                                categoryId: 1,
                                                categoryName: "All",
                                              )));
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
                          "Edit Profile",
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
                    visible: isClicked==false,
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
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          FutureBuilder<PickedFile?>(
                            builder: (context, snap) {
                              if (image != null) {
                                return InkWell(
                                  onTap: () {
                                    pictureModal();
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        image: DecorationImage(
                                          image: FileImage(image!),
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                                );
                              } else if (widget.myImage != null) {
                                return InkWell(
                                  onTap: () {
                                    pictureModal();
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        image: DecorationImage(
                                            image: NetworkImage(widget.myImage),
                                            fit: BoxFit.cover)),
                                  ),
                                );
                              } else {
                                return InkWell(
                                  child: CircleAvatar(
                                    radius: 52,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundColor:
                                          Constants.buttonColourMix1,
                                      child: Text(
                                        'W',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 40 * scalefactor),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    pictureModal();
                                  },
                                );
                              }
                            },
                            // future: pickedFile,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Profile photo",
                            style: TextStyle(
                                fontFamily: "Segoe UI",
                                color: Colors.black,
                                fontSize: 12 * scalefactor),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 50.0, right: 50.0),
                            child: TextFormField(
                              cursorColor: Colors.grey,
                              // initialValue: widget.email.toString(),style: TextStyle(color: Constants.text_colour3),
                              controller: nameController,
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
                                contentPadding: const EdgeInsets.all(16),
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
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 50.0, right: 50.0),
                            child: TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.name,
                              cursorColor: Colors.grey,
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
                                contentPadding: const EdgeInsets.all(16),
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
                            height: 15,
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
                                  setStateIfMounted(() {
                                    isClicked = true;
                                  });
                                  _submit();
                                } else {
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
                              },
                            ),
                          ),
                        ],
                      ),
                    )),
                  ),

                  // InkWell(
                  //        child: Container(
                  //          width: 100,
                  //          height: 100,
                  //          decoration: BoxDecoration(
                  //              borderRadius: BorderRadius.circular(50),
                  //              image: DecorationImage(
                  //                image: FileImage(image!),
                  //                fit: BoxFit.cover,
                  //              )),
                  //        ),
                  //        onTap: () {
                  //          pictureModal();
                  //        }),
                  //    widget.myImage != null
                  //        ? InkWell(
                  //            onTap: () {
                  //              pictureModal();
                  //            },
                  //            child: Container(
                  //              width: 100,
                  //              height: 100,
                  //              decoration: BoxDecoration(
                  //                  borderRadius: BorderRadius.circular(50),
                  //                  image: DecorationImage(
                  //                      image: NetworkImage(widget.myImage),
                  //                      fit: BoxFit.cover)),
                  //            ),
                  //          )
                  //        : InkWell(
                  //            onTap: () {
                  //              pictureModal();
                  //            },
                  //            child:
                  //                Image.asset("assets/profile-photo.png")),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  pictureModal() {
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
                      padding: const EdgeInsets.all(16.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Upload Profile Photo",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Constants.textColour3,
                                  fontFamily: "Segoe UI",
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.clear,
                                  size: 30,
                                )),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 30,
                        ),
                        Column(
                          children: [
                            InkWell(
                              onTap: () async {
                                // pickedFile = picker
                                //     .getImage(source: ImageSource.camera)
                                //     .whenComplete(() => {setState(() {})});
                                getProfilePic(ImageSource.camera);
                                Navigator.pop(context);
                                // myFile= picker
                                //     .getImage(source: ImageSource.camera)
                                //     .whenComplete(() => {setState(() {})}) ;
                              },
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Constants.textColour2,
                                child: CircleAvatar(
                                  radius: 28,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Constants.textColour1,
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: Constants.buttonColourMix3,
                                        size: 30,
                                      )),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text("Camera",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Segoe UI",
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal)),
                          ],
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Column(
                          children: [
                            InkWell(
                              onTap: () async {
                                // pickedFile = picker.getImage(source: ImageSource.gallery).whenComplete(() => {setState(() {})});
                                getProfilePic(ImageSource.gallery);
                                Navigator.pop(context);
                              },
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Constants.textColour2,
                                child: CircleAvatar(
                                  radius: 28,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Constants.textColour1,
                                      child: Icon(
                                        Icons.filter,
                                        color: Constants.buttonColourMix3,
                                        size: 30,
                                      )),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Gallery",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Segoe UI",
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                        Spacer(),
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

  File? image;
  bool showSpinner = false;

  Future getProfilePic(ImageSource source) async {
    try {
      final image = await _picker.pickImage(
          source: source, preferredCameraDevice: CameraDevice.front);
      if (image == null) {
        return;
      } else {
        final imageTemporary = (File(image.path));
        setState(() => this.image = imageTemporary);
      }
    } on PlatformException catch (e) {
      print("Failed to pick Image: $e");
    }
  }

  Map mapData = {};
  Map innerMAp = {};

  Future<void> _submit() async {
    print(widget.myId.toString());
    print(widget.token.toString());

    Map<String, String> data = {
      "customer_id": widget.myId.toString(),
      "name": nameController.text,
      "phone": phoneController.text,
      "code": myCode,
      "email": emailController.text,
      "country_code": countryCodeName,
    };
    Map<String, String> auth = {
      "Authorization": "Bearer ${widget.token.toString()}"
    };
    // print(jsonEncode(data));
    var multiPort;
    var url = Uri.parse("http://haulers.tech/jashn/mobile/user/updateprofile");
    var request = new http.MultipartRequest('POST', url);
    if (image != null) {
      var stream = new http.ByteStream(image!.openRead());
      stream.cast();
      var length = await image!.length();
      multiPort = new http.MultipartFile('image', stream, length,
          filename: image!.path);
      request.files.add(multiPort);
    }

    request.fields.addAll(data);
    request.headers.addAll(auth);

    var response = await request.send();

    print(response.statusCode);

    if (response.statusCode == 200) {
      // final respStr = await response.stream.bytesToString();
      print("Inside response.body");
      var myResponse = await http.Response.fromStream(response);
      print(myResponse.body);
      var jsonBody = jsonDecode(myResponse.body);
      if (jsonBody["success"] == true) {
        innerMAp = jsonBody["data"];

        SharedPreferences _prefs = await SharedPreferences.getInstance();
        _prefs.remove("name");
        _prefs.remove("email");
        _prefs.remove("phone");
        _prefs.remove("image");

        _prefs.setString("token", widget.token);
        _prefs.setString("customer_id", widget.myId);
        _prefs.setString("email", innerMAp["email"]);
        _prefs.setString("name", innerMAp["name"]);
        _prefs.setString("phone", innerMAp["phone"]);
        _prefs.setString("image", innerMAp["image"]);
        setStateIfMounted(() {
          isClicked = false;
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BottomBar(
                    currentIndex: 3, categoryId: 1, categoryName: "All"),
              ));
        });
      } else if (jsonBody["success"] == false) {
        setStateIfMounted(() {
          isClicked = false;
        });
        print(jsonBody["message"]);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(jsonBody["message"])));
      } else {
        setStateIfMounted(() {
          isClicked = false;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(jsonBody["message"])));
        });
      }
    } else {
      setStateIfMounted(() {
        isClicked = false;
      });
      print(response.statusCode);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Email is already used.")));
    }
  }

  Future<bool> onWillPop() {
    setState(() {
      isClicked = false;
    });
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              BottomBar(currentIndex: 3, categoryId: 1, categoryName: "All"),
        ));
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
    image = null;
    _connectivitySubscription.cancel();
    super.dispose();
  }
}
