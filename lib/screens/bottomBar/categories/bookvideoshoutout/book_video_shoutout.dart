import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jashn_user/styles/colors.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../styles/api_handler.dart';
import '../../../../styles/strings.dart';
import 'book_video_shoutout_details.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:developer' as developer;
import 'dart:async';
import 'package:flutter/services.dart';

class BookVideoShoutout extends StatefulWidget {
  final String name;
  final String offerId;
  final String celebrityId;
  final String amount;

  const BookVideoShoutout(
      {Key? key,
      required this.name,
      required this.offerId,
      required this.celebrityId,
      required this.amount})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return BookVideoShoutoutState();
  }
}

class BookVideoShoutoutState extends State<BookVideoShoutout> {
  Map mapShoutOutType = {};
  List<dynamic> listOfData = [];

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

  Future _fetchData() async {
    Handler handler = Handler('home/shoutouttype');
    String url1 = handler.getUrl();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token").toString();
    String id = prefs.getString("customer_id").toString();

    var shoutOutType = await http.post(Uri.parse(url1),
        body: ({
          "customer_id": id.toString(),
        }),
        headers: {
          "Authorization": " Bearer $token",
        });
    print("response comming");
    if (shoutOutType.statusCode == 200) {
      print("status code =200");
      mapShoutOutType = jsonDecode(shoutOutType.body);
      if (mapShoutOutType["success"] == true) {
        print("Success is true");
        setState(() {
          listOfData = mapShoutOutType["data"];
        });
      } else if (mapShoutOutType["success"] == false) {
        print("status is false");
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(mapShoutOutType["message"])));
      }
    } else {
      print(id);
      print(token.toString());
      print(shoutOutType.statusCode);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Fields not allowed")));
    }
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
                                    "Book your personalized",
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
                                    "video shout-out from",
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
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Who is this video shout-out for?",
                            style: TextStyle(
                              color: Constants.textColour3,
                              fontFamily: "Segoe UI",
                              fontSize: 14 * scalefactor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      listOfData.isEmpty
                          ? Center(
                              child: CupertinoActivityIndicator(
                                color: Constants.textColour6,
                                radius: 20.0,
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: listOfData.length,
                              itemBuilder: (context, index) {
                                return listOfData[index]["isBusiness"] == "1"
                                    ? SizedBox()
                                    : Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            BookVideoShoutoutDetails(
                                                              amount:
                                                                  widget.amount,
                                                              name: widget.name,
                                                              isFriend:
                                                                  listOfData[
                                                                          index]
                                                                      [
                                                                      "isFriend"],
                                                              offerId: widget
                                                                  .offerId,
                                                              celebrityId: widget
                                                                  .celebrityId,
                                                            )));
                                              },
                                              child: Container(
                                                height: 150,
                                                width: 280,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color:
                                                        Constants.textColour5,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    CachedNetworkImage(
                                                      progressIndicatorBuilder: (context, url, progress) => Center(
                                                        child: CircularProgressIndicator(
                                                          value: progress.progress,
                                                        ),
                                                      ),
                                                      imageUrl: listOfData[index]
                                                      ["icon"],
                                                      fit: BoxFit.cover,
                                                      alignment: Alignment.center,
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      listOfData[index]["type"],
                                                      style: TextStyle(
                                                        color: Constants
                                                            .textColour3,
                                                        fontFamily: "Segoe UI",
                                                        fontSize:
                                                            14 * scalefactor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                              })
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

  Future<bool> onWillPop() {
    Navigator.pop(context);
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => Celeb_Details()));
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
