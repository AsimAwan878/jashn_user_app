import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:jashn_user/styles/colors.dart';
import 'package:http/http.dart' as http;
import '../../styles/strings.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:developer' as developer;
import 'dart:async';
import 'package:flutter/services.dart';

class ReviewScreen extends StatefulWidget {
  final String name;
  final String celebrityId;
  final String image;
  final String rating;
  final String category;

  const ReviewScreen({Key? key,required this.name,required  this.celebrityId,required this.image,required this.rating,required this.category})
      : super(key: key);

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  bool isDelaying = false;
  bool isDataLoading = false;
  bool isConnected = false;
  bool isInternetDown = false;
  Map mapData = {};
  List<dynamic> listOfData = [];

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
      _fetchReviews().whenComplete(() {
        setStateIfMounted(() {
          isDataLoading=true;
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

  Future _fetchReviews() async {
    print(widget.celebrityId);
    print(listOfData.length);
    var reviewResponse = await http.get(
      Uri.parse(
          "http://haulers.tech/jashn/mobile/unauthorized/home/reviews?celebrity_id=${widget.celebrityId}"),
    );
    print("response comming");
    if (reviewResponse.statusCode == 200) {
      print("status code =200");
      mapData = jsonDecode(reviewResponse.body);
      if (mapData["success"] == true) {
        print("Success is true");
        setState(() {
          listOfData = mapData["data"];
          print(listOfData.length);
        });
      } else if (mapData["success"] == false) {
        print("status is false");
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(mapData["message"])));
      }
    } else {
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
          leadingWidth: 60,
          leading: Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0,bottom: 8.0,left: 8.0),
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
            "Rating & Reviews",
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
              visible: isInternetDown ==false || isConnected,
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
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: height*0.2,
                        color:Constants.textColour1,
                        child: Center(
                          child:    Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 38.0),
                            child: Container(
                              height: 135,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Constants.textColour3),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(12.0),bottomLeft: Radius.circular(12.0)),
                                    child: CachedNetworkImage(
                                      width: 115,
                                      height: 135,
                                      progressIndicatorBuilder: (context, url, progress) => Center(
                                        child: CircularProgressIndicator(
                                          value: progress.progress,
                                        ),
                                      ),
                                      imageUrl: widget.image,
                                      fit: BoxFit.cover,
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                  Spacer(flex: 1),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.name,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Constants.textColour3,
                                            fontFamily: "Segoe UI",
                                            fontSize: 18 * scalefactor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 5,),
                                      Text(
                                        widget.category,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Constants.textColour4,
                                            fontFamily: "Segoe UI",
                                            fontSize: 12 * scalefactor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 5,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.rating,
                                            style: TextStyle(
                                                color: Constants.textColour6,
                                                fontFamily: "Segoe UI",
                                                fontSize: 12 * scalefactor,
                                                fontWeight: FontWeight.w300
                                            ),
                                          ),
                                          SizedBox(width: width*0.01,),
                                          RatingBarIndicator(
                                            // initialRating: rating,
                                            // minRating: rating,
                                            // maxRating: rating,
                                            direction: Axis.horizontal,
                                            // allowHalfRating: true,
                                            rating: double.parse(widget.rating),
                                            itemCount: 5,
                                            itemSize: 15,
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: Constants.textColour6,
                                            ),
                                            // onRatingUpdate: (rating) {
                                            //   print(rating);
                                            //   setState(() {
                                            //     rated = rating;
                                            //   });
                                            // },
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Spacer(
                                    flex: 2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),

                      listOfData.isEmpty
                          ? Expanded(
                            child: Container(
                              color: Constants.textColour4,
                              child: Center(
                                  child: Text("No Reviews", style: homeTextTheme().bodyText1,
                                    textAlign: TextAlign.center,),

                                ),
                            ),
                          )
                          : Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Text(
                                    "Reviews",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Constants.textColour4,
                                        fontFamily: "Segoe UI",
                                        fontSize: 20 * scalefactor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 15,),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: listOfData.length,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 28.0,vertical: 8.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(color: Constants.textColour3),
                                                borderRadius: BorderRadius.circular(12)),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 28.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      listOfData[index]["image"] == ""
                                                          ?ClipRRect(
                                                        borderRadius: BorderRadius.circular(5.0),
                                                        child: CachedNetworkImage(
                                                          width: 40,
                                                          height: 40,
                                                          progressIndicatorBuilder: (context, url, progress) => Center(
                                                            child: CircularProgressIndicator(
                                                              value: progress.progress,
                                                            ),
                                                          ),
                                                          imageUrl: listOfData[index]["image"],
                                                          fit: BoxFit.cover,
                                                          alignment: Alignment.center,
                                                        ),
                                                      )
                                                      : Container (
                                                        width: 40,
                                                        height: 40,
                                                        decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                              image: AssetImage("assets/user.png"),fit: BoxFit.cover
                                                            ),
                                                            borderRadius:
                                                                BorderRadius.circular(5)),
                                                      ),
                                                      SizedBox(width: 20,),
                                                      Text(
                                                        listOfData[index]["username"],
                                                        style: TextStyle(
                                                          color: Constants.textColour4,
                                                          fontFamily: "Segoe UI",
                                                          fontSize: 12 * scalefactor,
                                                          fontWeight: FontWeight.bold
                                                        ),
                                                      ),
                                                      // Spacer(),
                                                      // PopupMenuButton<int>(
                                                      //   color: Constants.text_colour1,
                                                      //   onSelected: (value) {
                                                      //     if (value == 0) {
                                                      //
                                                      //     }
                                                      //     if (value == 1) {
                                                      //       Navigator.pop(context);
                                                      //     }
                                                      //   },
                                                      //   itemBuilder: (BuildContext context) {
                                                      //     return [
                                                      //       PopupMenuItem(
                                                      //         child: Text("Flag as inappropriate",style: TextStyle(
                                                      //             color: Constants.text_colour3,
                                                      //             fontFamily: "Segoe UI",
                                                      //             fontSize: 14 * scalefactor,
                                                      //             fontWeight: FontWeight.w400
                                                      //         ),),
                                                      //         value: 0,
                                                      //       ),
                                                      //       PopupMenuItem(
                                                      //         child: Text("Cancel",style: TextStyle(
                                                      //             color: Constants.text_colour3,
                                                      //             fontFamily: "Segoe UI",
                                                      //             fontSize: 14 * scalefactor,
                                                      //             fontWeight: FontWeight.w400
                                                      //         ),),
                                                      //         value: 1,
                                                      //       ),
                                                      //     ];
                                                      //   },
                                                      // ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10,),
                                                  Row(
                                                    children: [
                                                      RatingBarIndicator(
                                                        // initialRating: rating,
                                                        // minRating: rating,
                                                        // maxRating: rating,
                                                        direction: Axis.horizontal,
                                                        // allowHalfRating: true,
                                                        rating: double.parse(listOfData[index]["ratings"]),
                                                        itemCount: 5,
                                                        itemSize: 15,
                                                        itemBuilder: (context, _) => Icon(
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
                                                      SizedBox(width: 10,),
                                                      Text(
                                                        listOfData[index]["created_on"],
                                                        style: TextStyle(
                                                            color: Constants.textColour3,
                                                            fontFamily: "Segoe UI",
                                                            fontSize: 12 * scalefactor,
                                                            fontWeight: FontWeight.w400
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  // SizedBox(height: 30,),
                                                  // Row(
                                                  //   mainAxisAlignment: MainAxisAlignment.start,
                                                  //   children: [
                                                  //     Text(
                                                  //       "Was This review helpful?",
                                                  //       style: TextStyle(
                                                  //           color: Constants.text_colour3,
                                                  //           fontFamily: "Segoe UI",
                                                  //           fontSize: 12 * scalefactor,
                                                  //           fontWeight: FontWeight.w400
                                                  //       ),
                                                  //     ),
                                                  //     Spacer(),
                                                  //     SizedBox(
                                                  //       width: 60,
                                                  //       height: 30,
                                                  //       child: ElevatedButton(
                                                  //         child: Container(
                                                  //           height: 20,
                                                  //
                                                  //           alignment: Alignment.center,
                                                  //           child: Text(
                                                  //             "Yes",
                                                  //             style: TextStyle(
                                                  //                 color:
                                                  //                 Constants.text_colour3,
                                                  //                 fontFamily: "Segoe UI",
                                                  //                 fontSize:
                                                  //                 10 * scalefactor,
                                                  //                 fontWeight:
                                                  //                 FontWeight.normal),
                                                  //           ),
                                                  //         ),
                                                  //         onPressed: () async {
                                                  //           // pictureModel();
                                                  //         },
                                                  //         style: ButtonStyle(
                                                  //           shape: MaterialStateProperty.all<
                                                  //               RoundedRectangleBorder>(
                                                  //               RoundedRectangleBorder(
                                                  //                   borderRadius:
                                                  //                   BorderRadius.circular(
                                                  //                       25.0),
                                                  //                   side: BorderSide(
                                                  //                       color: Constants
                                                  //                           .text_colour3,
                                                  //                       width: 1.0))),
                                                  //           backgroundColor:
                                                  //           MaterialStateProperty.all(
                                                  //             Constants.text_colour1,
                                                  //           ),
                                                  //         ),
                                                  //       ),
                                                  //     ),
                                                  //     SizedBox(width: 10,),
                                                  //     SizedBox(
                                                  //       width: 60,
                                                  //       height: 30,
                                                  //       child: ElevatedButton(
                                                  //         child: Container(
                                                  //           height: 20,
                                                  //
                                                  //           alignment: Alignment.center,
                                                  //           child: Text(
                                                  //             "No",
                                                  //             style: TextStyle(
                                                  //                 color:
                                                  //                 Constants.text_colour3,
                                                  //                 fontFamily: "Segoe UI",
                                                  //                 fontSize:
                                                  //                 10 * scalefactor,
                                                  //                 fontWeight:
                                                  //                 FontWeight.normal),
                                                  //           ),
                                                  //         ),
                                                  //         onPressed: () async {
                                                  //           // pictureModel();
                                                  //         },
                                                  //         style: ButtonStyle(
                                                  //           shape: MaterialStateProperty.all<
                                                  //               RoundedRectangleBorder>(
                                                  //               RoundedRectangleBorder(
                                                  //                   borderRadius:
                                                  //                   BorderRadius.circular(
                                                  //                       25.0),
                                                  //                   side: BorderSide(
                                                  //                       color: Constants
                                                  //                           .text_colour3,
                                                  //                       width: 1.0))),
                                                  //           backgroundColor:
                                                  //           MaterialStateProperty.all(
                                                  //             Constants.text_colour1,
                                                  //           ),
                                                  //         ),
                                                  //       ),
                                                  //     ),
                                                  //
                                                  //
                                                  //   ],
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ],
                              ),
                            ),
                          )
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

  @override
  void dispose() {
    print("Dispose State called");
    _connectivitySubscription.cancel();

    super.dispose();
  }
}
