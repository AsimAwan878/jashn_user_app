import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../styles/colors.dart';
import 'package:http/http.dart' as http;

import '../../styles/strings.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:developer' as developer;
import 'dart:async';
import 'package:flutter/services.dart';

class AddReview extends StatefulWidget {
  final String celebrityId;

  const AddReview({Key? key,required this.celebrityId,})
      : super(key: key);

  @override
  _AddReviewState createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  var _rating;
  TextEditingController reviewController=TextEditingController();

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

  Map mapData = {};
  List<dynamic> listOfData = [];
  var token;
  var name;
  var image;
  var id;

  Future _fetchData() async {
    SharedPreferences _prefs=await SharedPreferences.getInstance();
    name=_prefs.getString("name");
    token=_prefs.getString("token");
    id=_prefs.getString("customer_id");
    image=_prefs.getString("image");
    print(name.toString());
    print(token.toString());
    print(id.toString());
    print(image.toString());

  }

  Widget _widget() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double scalefactor = MediaQuery.of(context).textScaleFactor;
    IconData? _selectedIcon;

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
            "Add Your Rating",
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
                  color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: [
                      //     Spacer(flex: 1),
                      //     Container(
                      //       width: 100,
                      //       height: 100,
                      //       decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.circular(20.0),
                      //           image: DecorationImage(
                      //               image: NetworkImage(
                      //                   widget.image
                      //               ),fit: BoxFit.cover
                      //           )
                      //       ),
                      //     ),
                      //     Spacer(flex: 1),
                      //     Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Text(
                      //           widget.name,
                      //           textAlign: TextAlign.center,
                      //           style: TextStyle(
                      //               color: Constants.text_colour3,
                      //               fontFamily: "Segoe UI",
                      //               fontSize: 20 * scalefactor,
                      //               fontWeight: FontWeight.w600),
                      //         ),
                      //         SizedBox(height: 10,),
                      //         Row(
                      //           children: [
                      //             Text(
                      //               widget.rating,
                      //               style: TextStyle(
                      //                   color: Constants.text_colour3,
                      //                   fontFamily: "Segoe UI",
                      //                   fontSize: 14 * scalefactor,
                      //                   fontWeight: FontWeight.w400
                      //               ),
                      //             ),
                      //             Icon(Icons.star,size: 12,),
                      //           ],
                      //         )
                      //       ],
                      //     ),
                      //     Spacer(
                      //       flex: 2,
                      //     ),
                      //   ],
                      // ),
                      // listOfData.isEmpty
                      //     ? SizedBox(
                      //   child: Text("No Review"),
                      // )
                      //     :
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 8.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(height: 5,),
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
                                            imageUrl: image.toString(),
                                            fit: BoxFit.cover,
                                            alignment: Alignment.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 20,),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          name.toString(),
                                          style: TextStyle(
                                              color: Constants.textColour3,
                                              fontFamily: "Segoe UI",
                                              fontSize: 14 * scalefactor,
                                              fontWeight: FontWeight.w400
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: SizedBox(
                                            height: 70,
                                            width: width*0.6,
                                            child: Center(
                                              child: Text(
                                                "Ratings are public and include your account info.",
                                                style: TextStyle(
                                                    color: Constants.textColour4,
                                                    fontFamily: "Segoe UI",
                                                    fontSize: 14 * scalefactor,
                                                    fontWeight: FontWeight.w400
                                                ),
                                                textAlign: TextAlign.justify,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
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
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                RatingBar.builder(
                                initialRating: 0,
                                minRating: 1,
                                direction:  Axis.horizontal,
                                unratedColor: Constants.textColour2,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 50.0,
                                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) => Icon(
                                  _selectedIcon ?? Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  setState(() {
                                    _rating = rating;
                                    print(_rating);
                                  });
                                },
                                updateOnDrag: true,
                              ),
                                  // RatingBarIndicator(
                                  //   initialRating: 0.0,
                                  //   minRating: rating,
                                  //   maxRating: rating,
                                  //   direction: Axis.horizontal,
                                  //   allowHalfRating: true,
                                  //   // rating: 0.0,
                                  //   itemCount: 5,
                                  //   itemSize: 15,
                                  //   itemBuilder: (context, _) => Icon(
                                  //     Icons.star,
                                  //     color: Constants.button_colour_mix4,
                                  //   ),
                                  //   onRatingUpdate: (rating) {
                                  //     print(rating);
                                  //     setState(() {
                                  //       rated = rating;
                                  //     });
                                  //   },
                                  // ),
                                ],
                              ),
                              SizedBox(height: height*0.04,),
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
                                  materialTapTargetSize: MaterialTapTargetSize
                                      .shrinkWrap,
                                  shape: StadiumBorder(),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Submit",
                                          style: textTheme().subtitle1),
                                    ],
                                  ),
                                  onPressed: () {
                                    if(isInternetDown ==false)
                                      {
                                        isDelaying=false;
                                        setState(() {

                                        });
                                        _sendData();
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
                              // TextFormField(
                              //   controller: reviewController,
                              //   cursorColor: Colors.grey,
                              //   keyboardType: TextInputType.name,
                              //   decoration: InputDecoration(
                              //     fillColor: Colors.white,
                              //     filled: true,
                              //     hintText: 'Describe your experience (optional)',
                              //     contentPadding:
                              //     const EdgeInsets.only(left: 24),
                              //     hintStyle: TextStyle(
                              //         fontSize: 14 * scalefactor,
                              //         fontWeight: FontWeight.w400,
                              //         fontFamily: 'Mulish',
                              //         color: Constants.textColour5),
                              //     border: OutlineInputBorder(
                              //       borderRadius: BorderRadius.circular(10),
                              //       borderSide: BorderSide(
                              //           color: Constants.textColour5,
                              //           width: 2.0),
                              //     ),
                              //     focusedBorder: OutlineInputBorder(
                              //       borderRadius: BorderRadius.circular(10),
                              //       borderSide: BorderSide(
                              //           color: Constants.buttonColourMix4,
                              //           width: 2.0),
                              //     ),
                              //     enabledBorder: OutlineInputBorder(
                              //       borderRadius: BorderRadius.circular(10),
                              //       borderSide: BorderSide(
                              //           color: Constants.textColour5,
                              //           width: 2.0),
                              //     ),
                              //   ),
                              // ),
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

  Future _sendData() async {

    print(widget.celebrityId);
    var reviewResponse = await http.post(
      Uri.parse(
          "http://haulers.tech/jashn/mobile/request/add_review"),
      body: ({
        "customer_id":id.toString(),
        "celebrity_id":widget.celebrityId,
        "ratings": _rating.toString(),
        "comments": "",
        "celebrity_shoutout_id":"",
        "event_id":"",
      }),
      headers: ({
        "Authorization": "Bearer ${token.toString()}"
      })
    );

    if(reviewResponse.statusCode == 200){
      print("Inside response.body");
      var jsonBody=jsonDecode(reviewResponse.body);

      if(jsonBody["success"] == true)
      {
        setState(() {
          isDelaying=false;
          Navigator.pop(context);
        });
      }
      else if(jsonBody["success"] == false)
      {
        setState(() {
          isDelaying=false;
        });
        print(jsonBody["message"]);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonBody["message"])));
      }
    }
    else{
      setState(() {
        isDelaying=false;
      });
      print(reviewResponse.statusCode);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Server Error")));
    }
    // print("response comming");
    // if (reviewResponse.statusCode == 200) {
    //   print("status code =200");
    //   mapData = jsonDecode(reviewResponse.body);
    //   if (mapData["success"] == true) {
    //     print("Success is true");
    //     setState(() {
    //       listOfData = mapData["data"];
    //     });
    //   } else if (mapData["success"] == false) {
    //     print("status is false");
    //     ScaffoldMessenger.of(context)
    //         .showSnackBar(SnackBar(content: Text(mapData["message"])));
    //   }
    // } else {
    //   ScaffoldMessenger.of(context)
    //       .showSnackBar(SnackBar(content: Text("Fields not allowed")));
    // }
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
