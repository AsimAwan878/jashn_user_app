import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:jashn_user/screens/bottomBar/profiles/profiles.dart';
import 'package:jashn_user/screens/bottomBar/view_shoutout.dart';
import 'package:jashn_user/styles/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../styles/api_handler.dart';
import '../../styles/strings.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:developer' as developer;
import 'dart:async';
import 'package:flutter/services.dart';

class Experiences extends StatefulWidget {
  @override
  _ExperiencesState createState() => _ExperiencesState();
}

class _ExperiencesState extends State<Experiences> {

  var title = 'Experiences';
  double rated = 0.0;

  bool isInitializing = false;
  bool isDelaying=false;
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
      _fetchData().whenComplete(() {
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

  Widget _widget() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double scalefactor = MediaQuery.of(context).textScaleFactor;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          backgroundColor: Constants.textColour1,
          title: Text(
            title,
            style: homeTextTheme().subtitle2,
          ),
          centerTitle: true,
        ),
        body: Visibility(
          visible: isDelaying,
          replacement: loadingCard(width, height),
          child: Visibility(
            visible: isInternetDown == false || isConnected,
            replacement: Container(
              width: width,
              height: height,
              color: Constants.textColour4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/sad-face-in-rounded-square.png",color: Constants.textColour1,height: 50,width: 50,fit: BoxFit.cover,),
                  SizedBox(height: 20,),
                  Center(child: Text(
                    "OOPS !",
                    style: homeTextTheme().bodyText1,
                    textAlign: TextAlign.center,
                  ),),
                  SizedBox(height: 20,),
                  Center(child: Text(
                    "No Internet Connection...",
                    style: textTheme().subtitle1,
                    textAlign: TextAlign.center,
                  ),),
                ],
              ),
            ),
            child: Visibility(
              visible: isInitializing,
              replacement: loadingCard(width, height),
              child: Container(
                width: width,
                height: height,
                child: DefaultTabController(
                  length: 2, // length of tabs
                  initialIndex: 0,
                  child: Column(children: <Widget>[
                    Container(
                      color: Constants.textColour4,
                      child: TabBar(
                        labelColor: Colors.white,
                        automaticIndicatorColorAdjustment: true,
                        unselectedLabelColor: Colors.white,
                        tabs: [
                          Tab(text: 'Experiences'),
                          Tab(text: 'Requests'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                          //height of TabBarView
                          decoration: BoxDecoration(
                              color: Constants.textColour4,
                              border: Border(
                                  top: BorderSide(color: Colors.grey, width: 0.5))),
                          child: TabBarView(children: <Widget>[
                            list.isNotEmpty
                                ? Container(
                                    width: width,
                                    height: height,
                                    child: Padding(
                                        padding: const EdgeInsets.only(top: 16,bottom: 50,right: 16,left: 16),
                                        child: ListView(
                                          children: [
                                            for (int i = 0; i < list.length; i++)
                                              InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ViewShoutout(
                                                                shareLink: list[i]['share_link'],
                                                                share: list[i]['share'],
                                                                image: list[i]
                                                                    ['thumbnail'],
                                                                video: list[i]
                                                                    ["video"],
                                                              )));
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: 16.0),
                                                  child: Container(
                                                    height: 130,
                                                    decoration: BoxDecoration(
                                                        color: Colors.black
                                                            .withOpacity(0.7),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                16)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      children: [
                                                        Spacer(),
                                                        Stack(
                                                          alignment: Alignment.center,
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius: BorderRadius.circular(20.0),
                                                              child: CachedNetworkImage(
                                                                width: 100,
                                                                height: 100,
                                                                progressIndicatorBuilder: (context, url, progress) => Center(
                                                                  child: CircularProgressIndicator(
                                                                    value: progress.progress,
                                                                  ),
                                                                ),
                                                                imageUrl:list[i]["image"],
                                                                fit: BoxFit.cover,
                                                                alignment: Alignment.center,
                                                              ),
                                                            ),
                                                            Container(
                                                              width: 30,
                                                              height: 30,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    Colors.redAccent,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(15),
                                                              ),
                                                              child: Icon(
                                                                Icons.play_arrow,
                                                                color: Constants
                                                                    .textColour1,
                                                                size: 25,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(list[i]["celebrity"],
                                                                style: textTheme()
                                                                    .bodyText2),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                              myList[i]["paid_date"],
                                                              style: TextStyle(
                                                                  color: Constants
                                                                      .textColour1,
                                                                  fontFamily:
                                                                      "Segoe UI",
                                                                  fontSize: 11 *
                                                                      scalefactor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                            ),
                                                            RatingBarIndicator(
                                                              // initialRating: rating,
                                                              // minRating: rating,
                                                              // maxRating: rating,
                                                              direction:
                                                                  Axis.horizontal,
                                                              // allowHalfRating: true,
                                                              rating: double.parse(
                                                                  list[i]["ratings"]),
                                                              itemCount: 5,
                                                              itemSize: 15,
                                                              unratedColor: Constants
                                                                  .textColour1,
                                                              itemBuilder:
                                                                  (context, _) =>
                                                                      Icon(
                                                                Icons.star,
                                                                color: Colors.amber,
                                                              ),
                                                              // onRatingUpdate: (rating) {
                                                              //   print(rating);
                                                              //   setState(() {
                                                              //     rated = rating;
                                                              //   });
                                                              // },
                                                            ),
                                                          ],
                                                        ),
                                                        Spacer(flex: 5),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Icon(
                                                          Icons.arrow_back_ios,
                                                          color:
                                                              Constants.textColour1,
                                                        ),
                                                        Spacer(),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        )),
                                  )
                                : Container(
                                    width: width,
                                    height: height,
                                    color: Constants.textColour4,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "No Experiences",
                                          style: homeTextTheme().bodyText1,
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 18.0),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "When the celebrity gives a shout-out, the shout-out videos will display here.",
                                              style: TextStyle(
                                                  color: Constants.textColour1,
                                                  fontFamily: "Segoe UI",
                                                  fontSize: 20 * scalefactor,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            myList.isNotEmpty
                                ? Container(
                                    width: width,
                                    height: height,
                                    child: Padding(
                                        padding: const EdgeInsets.only(top: 16,bottom: 50,right: 16,left: 16),
                                        child: ListView(
                                          children: [
                                            for (int i = 0; i < myList.length; i++)
                                              InkWell(
                                                onTap: () {
                                                  // Navigator.push(
                                                  //     context, MaterialPageRoute(builder: (context) => Description(transactionId: listOfAcceptedShout[i]["transactionId"],id: "2",)));
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: 16.0),
                                                  child: Container(
                                                    height: 70,
                                                    decoration: BoxDecoration(
                                                        color: Colors.black
                                                            .withOpacity(0.7),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                12)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      children: [
                                                        Spacer(),
                                                        ClipRRect(
                                                          borderRadius: BorderRadius.circular(25.0),
                                                          child: CachedNetworkImage(
                                                            width: 50,
                                                            height: 50,
                                                            progressIndicatorBuilder: (context, url, progress) => Center(
                                                              child: CircularProgressIndicator(
                                                                value: progress.progress,
                                                              ),
                                                            ),
                                                            imageUrl:myList[i]["image"],
                                                            fit: BoxFit.cover,
                                                            alignment: Alignment.center,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(myList[i]["celebrity"],
                                                            style: textTheme()
                                                                .bodyText2),
                                                        Spacer(flex: 5),
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment.end,
                                                          children: [
                                                            Text(
                                                              "PKR ${myList[i]["amount"]}",
                                                              style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontSize: 11 *
                                                                      scalefactor),
                                                              textAlign:
                                                                  TextAlign.end,
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                              myList[i]["paid_date"],
                                                              style: TextStyle(
                                                                  color: Constants
                                                                      .textColour1,
                                                                  fontFamily:
                                                                      "Segoe UI",
                                                                  fontSize: 11 *
                                                                      scalefactor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        if (myList[i][
                                                                'request_status_id'] ==
                                                            "1")
                                                          Icon(
                                                            Icons.pending,
                                                            color: Colors.orange,
                                                          ),
                                                        if (myList[i][
                                                                'request_status_id'] ==
                                                            "2")
                                                          Icon(
                                                            Icons.check_circle_sharp,
                                                            color: Colors.green,
                                                          ),
                                                        if (myList[i][
                                                                'request_status_id'] ==
                                                            "3")
                                                          Icon(
                                                            Icons.cancel,
                                                            color: Colors.red,
                                                          ),
                                                        Spacer(),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        )),
                                  )
                                : Container(
                                    width: width,
                                    height: height,
                                    color: Constants.textColour4,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "No Requests",
                                          style: homeTextTheme().bodyText1,
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 18.0),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "When you request the celebrity for a video or business shout-out, it will display here",
                                              style: TextStyle(
                                                  color: Constants.textColour1,
                                                  fontFamily: "Segoe UI",
                                                  fontSize: 20 * scalefactor,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ])),
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  Container loadingCard(double width, double height) {
    return Container(
      color: Constants.textColour1,
      child: Column(
        children: [
          SizedBox(
            height: height*0.01,
          ),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 32.0),
                  child: ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => SizedBox(
                      height: 20,
                    ),
                    itemCount: 4,
                    itemBuilder: (context, index) => Stack(
                      alignment: Alignment.center,
                      children: [
                        Skeleton(height: 135, width: width*0.9, decoration: BorderRadius.all(Radius.circular(20))),
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0,top: 8,bottom: 8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Skeleton(
                                      height: 120,
                                      width: 90,
                                      decoration: BorderRadius.all(Radius.circular(12))),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    children: [
                                      Skeleton(
                                          height: 25,
                                          width: width * 0.3,
                                          decoration: BorderRadius.all(Radius.circular(2.0))),
                                      SizedBox(height: 10,),
                                      Skeleton(
                                          height: 25,
                                          width: width * 0.3,
                                          decoration: BorderRadius.all(Radius.circular(2.0))),
                                      SizedBox(height: 10,),
                                      Skeleton(
                                          height: 25,
                                          width: width * 0.3,
                                          decoration: BorderRadius.all(Radius.circular(2.0))),
                                    ],
                                  )
                                ],
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ))),
        ],
      ),
    );
  }

  Map mapResponse = {};

  var customerId;
  var token;
  List myList = [];
  Map mapResponse2 = {};
  List list = [];

  Future _fetchData() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    customerId = _prefs.getString("customer_id");
    print(customerId.toString());
    token = _prefs.getString("token");

    Handler handler = Handler('user/request?customer_id=$customerId');
    String url1 = handler.getUrl();
    print(url1);

    Handler handler2 = Handler('user/shoutout?customer_id=$customerId');
    String url2 = handler2.getUrl();
    print(url2);

    print(customerId.toString());
    print(token.toString());
    print("Click on fetch data");

    var response = await http.get(Uri.parse(url1),
        headers: ({
          "Authorization": "Bearer ${token.toString()}",
        }));

    if (response.statusCode == 200) {
      print("Response coming :${response.statusCode}");
        mapResponse = jsonDecode(response.body);
        myList = mapResponse["data"];
        // listOfData = mapResponse["data"];
        print("Lenngth is:${myList.toString()}");
    } else {
      print(response.body);
      print("Request failed to response :${response.statusCode}");
    }

    var secondResponse = await http.get(Uri.parse(url2),
        headers: ({"Authorization": "Bearer ${token.toString()}"}));

    if (secondResponse.statusCode == 200) {
      print("Response coming :${secondResponse.statusCode}");
        mapResponse2 = jsonDecode(secondResponse.body);
        list = mapResponse2["data"];
        // listOfData = mapResponse["data"];
        print("Length is:${list.toString()}");
    } else {
      print(secondResponse.body);
      print("Request failed to response :${secondResponse.statusCode}");
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
    _connectivitySubscription.cancel();
    super.dispose();
  }
}
