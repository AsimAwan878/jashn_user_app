import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:jashn_user/screens/bottomBar/profiles/profiles.dart';
import 'package:jashn_user/styles/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../styles/api_handler.dart';
import '../../styles/strings.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:developer' as developer;
import 'dart:async';
import 'package:flutter/services.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({
    Key? key,
  }) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late int _selectedIndex = 1000;

  bool isInitializing = false;
  bool isDelaying=false;
  bool isConnected = false;
  bool isInternetDown = false;

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  Set active = {};
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
      _getNotification().whenComplete(() {
        setStateIfMounted(() {
          isInitializing = true;
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

  var id;
  var email;
  var token;
  List listData = [];

  Future<void> _getNotification() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    id = _prefs.getString("customer_id");
    email = _prefs.getString("email");
    token = _prefs.getString("token");

    Handler handler = Handler(
        'user/notifications?customer_id=${id.toString()}&email=${email.toString()}');
    String url1 = handler.getUrl();

    print(id);
    print(email);
    print(token);

    print("Click on get notifications");
    var url = Uri.parse(url1);
    var notificationResponse = await http.get(url,
        headers: ({"Authorization": "Bearer ${token.toString()}"}));
    if (notificationResponse.statusCode == 200) {
      var jsonBody = jsonDecode(notificationResponse.body);
      if (jsonBody["success"] == true) {
        listData = jsonBody["data"];
        print("if condition");
        if (listData.isEmpty) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(jsonBody["message"])));
        }
      } else if (jsonBody["success"] == false) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(jsonBody["message"])));
      }
    } else {
      print(notificationResponse.body);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Server Error!")));
    }
  }

  Widget _widget() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double scaleFactor = MediaQuery.of(context).textScaleFactor;
    return SafeArea(
      child: Scaffold(
        body: Visibility(
          visible: isDelaying,
          replacement: loadingCard(width, height),
          child: Container(
            width: width,
            height: height,
            color:
                listData.isEmpty ? Constants.textColour4 : Constants.textColour1,
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
                        "Notifications",
                        style: TextStyle(
                            color: Constants.textColour1,
                            fontFamily: "Segoe UI",
                            fontSize: 24 * scaleFactor,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                 listData.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                                itemCount: listData.length,
                                itemBuilder: ((context, index) {
                                  return Container(
                                    width: width,
                                    height: _selectedIndex == index ? 160 : 140,
                                    padding: EdgeInsets.only(
                                        left: 12, right: 12, top: 10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 15,
                                                height: 15,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7.5),
                                                    color: Colors.purple),
                                              ),
                                              SizedBox(
                                                width: width * 0.03,
                                              ),
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(20.0),
                                                child: CachedNetworkImage(
                                                  width: 40,
                                                  height: 40,
                                                  progressIndicatorBuilder: (context, url, progress) => Center(
                                                    child: CircularProgressIndicator(
                                                      value: progress.progress,
                                                    ),
                                                  ),
                                                  imageUrl:listData[index]
                                                  ["logo"],
                                                  fit: BoxFit.cover,
                                                  alignment: Alignment.center,
                                                ),
                                              ),
                                              SizedBox(
                                                width: width * 0.05,
                                              ),
                                              Text(
                                                listData[index]["subject"],
                                                style: TextStyle(
                                                    color: Constants.textColour3,
                                                    fontFamily: "Segoe UI",
                                                    fontSize: 14 * scaleFactor,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              Spacer(
                                                flex: 3,
                                              ),
                                              Text(
                                                listData[index]["time"],
                                                style: TextStyle(
                                                  color: Constants.textColour4,
                                                  fontFamily: "Segoe UI",
                                                  fontSize: 14 * scaleFactor,
                                                ),
                                              ),
                                              SizedBox(
                                                width: width * 0.03,
                                              ),
                                            ]),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 28.0, right: 28.0),
                                          child: Html(
                                            data: listData[index]["text"],
                                            style: {
                                              "p": _selectedIndex == index
                                                  ? Style(
                                                      fontFamily: "Segoe UI",
                                                      color:
                                                          Constants.textColour3,
                                                      fontSize: FontSize(14),
                                                      maxLines: 3,
                                                      textOverflow:
                                                          TextOverflow.ellipsis)
                                                  : Style(
                                                      fontFamily: "Segoe UI",
                                                      color:
                                                          Constants.textColour3,
                                                      fontSize: FontSize(14),
                                                      maxLines: 1,
                                                      textOverflow:
                                                          TextOverflow.ellipsis),
                                            },
                                          ),
                                        ),
                                        // _selectedIndex == index
                                        //     ? listData[index]["image"] == ""
                                        //     ?SizedBox()
                                        //     :InkWell(
                                        //   onTap: () async {
                                        //     await showDialog(
                                        //         context: context,
                                        //         builder: (_) => ImageDialog(imagePath: listData[index]["image"],)
                                        //     );
                                        //   },
                                        //       child: Align(
                                        //   alignment: Alignment.center,
                                        //         child: Container(
                                        //   width: width*0.7,
                                        //   height: 100,
                                        //   decoration: BoxDecoration(
                                        //         borderRadius: BorderRadius.circular(10),
                                        //         image: DecorationImage(
                                        //           image: NetworkImage(
                                        //             listData[index]["image"]
                                        //           ),
                                        //           fit: BoxFit.cover
                                        //         )
                                        //   ),
                                        // ),
                                        //       ),
                                        //     )
                                        //     : SizedBox(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              child: CircleAvatar(
                                                child: Icon(
                                                  _selectedIndex == index
                                                      ? Icons.keyboard_arrow_up
                                                      : Icons.keyboard_arrow_down,
                                                  size: 20,
                                                  color: Constants.textColour3,
                                                ),
                                                radius: 10,
                                                backgroundColor:
                                                    Constants.textColour1,
                                              ),
                                              onTap: () {
                                                print("OnTapped");
                                                if (_selectedIndex == index) {
                                                  setState(() {
                                                    _selectedIndex = 1000;
                                                    print(
                                                        "selectedIndex=${_selectedIndex.toString()}");
                                                  });
                                                } else {
                                                  setState(() {
                                                    _selectedIndex = index;
                                                    print(
                                                        "selectedIndex=${_selectedIndex.toString()}");
                                                  });
                                                }
                                              },
                                            )
                                          ],
                                        ),
                                        Divider(
                                          thickness: 2,
                                        ),
                                      ],
                                    ),
                                  );
                                })))
                        : Expanded(
                            child: Center(
                            child: Text(
                              "No Notification",
                              style: homeTextTheme().bodyText1,
                              textAlign: TextAlign.center,
                            ),
                          ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column loadingCard(double width, double height) {
    return Column(
      children: [
        Skeleton(
            width: width,
            height: height / 3,
            decoration: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40))),
        SizedBox(
          height: 22,
        ),
        Expanded(
            child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 32.0, vertical: 32.0),
                child: ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(
                    height: 20,
                  ),
                  itemCount: 3,
                  itemBuilder: (context, index) => Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Skeleton(
                              height: 50,
                              width: 50,
                              decoration: BorderRadius.all(Radius.circular(25))),
                          SizedBox(
                            width: 10,
                          ),
                          Skeleton(
                              height: 30,
                              width: width * 0.3,
                              decoration: BorderRadius.all(Radius.circular(2.0)))
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Skeleton(
                                height: 20,
                                width: width * 0.8,
                                decoration: BorderRadius.all(Radius.circular(2.0)))
                          ],
                        ),
                      ),
                    ],
                  ),
                ))),
      ],
    );
  }

  // Future myDialog(){
  //   return showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       backgroundColor: Constants.text_colour1,
  //       content: Text(
  //         'Are you sure you want to exit',
  //         style: TextStyle(color: Colors.white),
  //       ),
  //       actions: <Widget>[
  //         // FlatButton(
  //         //   onPressed: () => Navigator.of(context).pop(false),
  //         //   child: Text(
  //         //     'No',
  //         //     style: TextStyle(color: Colors.white),
  //         //   ),
  //         // ),
  //       ],
  //     ),
  //   );
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
    super.dispose();
  }
}

class ImageDialog extends StatefulWidget {
  final String imagePath;

  const ImageDialog({Key? key, required this.imagePath}) : super(key: key);

  @override
  State<ImageDialog> createState() => _ImageDialogState();
}

class _ImageDialogState extends State<ImageDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(widget.imagePath), fit: BoxFit.cover)),
      ),
    );
  }
}
