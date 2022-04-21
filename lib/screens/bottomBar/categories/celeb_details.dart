import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:jashn_user/screens/bottomBar/add_review.dart';
import 'package:jashn_user/styles/colors.dart';

import 'package:http/http.dart' as http;
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../../../styles/api_handler.dart';
import '../../../styles/strings.dart';
import '../review_screen.dart';
import '../shoutout.dart';
import 'bookBusinessShoutout/business_shoutout_details.dart';
import 'bookvideoshoutout/book_video_shoutout.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:developer' as developer;
import 'dart:async';
import 'package:flutter/services.dart';

class CelebDetails extends StatefulWidget {
  final String id;

  CelebDetails({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  CelebDetailsState createState() => CelebDetailsState();
}

class CelebDetailsState extends State<CelebDetails> {
  double rated = 0.0;
  bool slided = false;
  double rating = 3.0;

  bool getDataCalled = false;
  bool isConnected = false;
  bool isInternetDown = false;
  bool isDelaying = false;
  int limit = 0;

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
      _fetchData().whenComplete(() {
        setStateIfMounted(() {
          getDataCalled = true;
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

  Map mapCelebrityDetails = {};
  Map mapDetailsData = {};

  List<dynamic> listDetailsLinks = [];
  List<dynamic> listDetailsOffers = [];

  Future _fetchData() async {
    Handler handler = Handler(
        'unauthorized/home/celebrity_detail?id=${widget.id.toString()}');
    String url1 = handler.getUrl();

    print("Click on fetch data");
    var detailsUrl = Uri.parse(url1);
    var detailsResponse = await http.get(detailsUrl);
    if (detailsResponse.statusCode == 200) {
      print("Response coming :${detailsResponse.statusCode}");
      setState(() {
        mapCelebrityDetails = json.decode(detailsResponse.body);
        mapDetailsData = mapCelebrityDetails["data"]["details"];
        listDetailsLinks = mapCelebrityDetails["data"]["links"];
        listDetailsOffers = mapCelebrityDetails["data"]["offers"];
      });
      print("offers = ${listDetailsOffers.length}");
      print("Details Response Coming");
    } else {
      print("Request failed to response :${detailsResponse.statusCode}");
    }

    Handler handler2 = Handler(
        'unauthorized/home/celebrity_shoutout?celebrity_id=${widget.id.toString()}');
    String url = handler2.getUrl();

    print(url);

    var shoutOutUrl = Uri.parse(url);
    var shoutOutResponse = await http.get(shoutOutUrl);
    if (shoutOutResponse.statusCode == 200) {
      print("Response coming :${shoutOutResponse.statusCode}");
      var jsonBody = jsonDecode(shoutOutResponse.body);
      if (jsonBody["success"] == true) {
        setState(() {
          mapShoutOut = jsonBody;
          listShoutData = mapShoutOut["data"];
          if (listShoutData.length >= 3) limit = 3;
          if (listShoutData.length < 3) limit = listShoutData.length;
          _isPlay = List.generate(3, (index) => false);
        });
      } else if (jsonBody["success"] == false) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(jsonBody["message"])));
      }
    } else {
      print("Request failed to response :${shoutOutResponse.statusCode}");
    }
  }

  Widget _widget() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double scalefactor = MediaQuery.of(context).textScaleFactor;

    return SafeArea(
      child: Scaffold(
        body: Visibility(
          visible: isDelaying,
          replacement: Center(
            child: CupertinoActivityIndicator(
              color: Constants.textColour6,
              radius: 20.0,
            ),
          ),
          child: Visibility(
              visible: isInternetDown == false || isConnected,
              replacement: Column(
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
                            color: Constants.textColour4,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'OOPS !',
                            style: TextStyle(
                                color: Colors.grey,
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
                                color: Colors.grey,
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
              child: mapDetailsData.isNotEmpty
                  ? Visibility(
                      visible: isConnected &&
                          getDataCalled &&
                          mapDetailsData.isNotEmpty,
                      replacement: Center(
                        child: CupertinoActivityIndicator(
                          color: Constants.textColour6,
                          radius: 20.0,
                        ),
                      ),
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            width: width,
                            height: height,
                            progressIndicatorBuilder:
                                (context, url, progress) => Center(
                              child: CircularProgressIndicator(
                                value: progress.progress,
                              ),
                            ),
                            imageUrl: mapDetailsData["image"],
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, right: 16, top: 16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomBar(0)));
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          Icons.arrow_back_ios_new_rounded,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  : SizedBox()),
        ),
        bottomSheet: SolidBottomSheet(
            maxHeight: height * 0.6,
            onShow: () {
              print('shown');
              setState(() {
                slided == true ? slided = false : slided = true;
              });
            },
            headerBar: mapDetailsData.isNotEmpty
                ? Visibility(
                    visible: isInternetDown == false || isConnected,
                    replacement: Column(
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
                                  color: Constants.textColour4,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'No Featured Celebrity',
                                  style: TextStyle(
                                      color: Colors.grey,
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
                    child: Visibility(
                      visible: isConnected && getDataCalled,
                      replacement: SizedBox(),
                      child: Container(
                          padding: EdgeInsets.all(30),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(50),
                                  topRight: Radius.circular(32))),
                          height: height * 0.23,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    mapDetailsData["celebrity_name"],
                                    //listOfDetail[]["details"]["celebrity_name"],
                                    style: TextStyle(
                                        fontFamily: "Segoe UI",
                                        color: Constants.textColour3,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16 * scalefactor),
                                  ),
                                  mapDetailsData["isVerifiedLinks"] == "1"
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Icon(
                                            Icons.verified,
                                            color: Colors.blue,
                                            size: 20,
                                          ),
                                        )
                                      : SizedBox()
                                  // Row(
                                  //   children: [
                                  //     Text(
                                  //       "For Rating",
                                  //       style: TextStyle(
                                  //           color: Colors.black,
                                  //           fontSize: 18 * scalefactor),
                                  //     ),
                                  //     SizedBox(
                                  //       width: width * 0.02,
                                  //     ),
                                  //     Icon(FontAwesomeIcons.longArrowAltRight),
                                  //   ],
                                  // ),
                                  // RichText(
                                  //   text: TextSpan(
                                  //       text: "Rating: ",
                                  //       style: TextStyle(
                                  //           color: Colors.black,
                                  //           fontSize: 15 * scalefactor),
                                  //       children: [
                                  //         TextSpan(
                                  //           text: "${rated.toString()}",
                                  //           style: TextStyle(
                                  //               color: Colors.black,
                                  //               fontSize: 15 * scalefactor),
                                  //         )
                                  //       ]),
                                  // ),
                                ],
                              ),
                              Text(
                                mapDetailsData["label"],
                                //listOfDetail[]["details"]["category"],
                                style: TextStyle(
                                    fontFamily: "Segoe UI",
                                    fontWeight: FontWeight.w600,
                                    color: Constants.textColour3,
                                    fontSize: 10 * scalefactor),
                              ),
                              SizedBox(
                                height: height * 0.03,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ReviewScreen(
                                                    name: mapDetailsData[
                                                        "celebrity_name"],
                                                    celebrityId: mapDetailsData[
                                                            "celebrity_id"]
                                                        .toString(),
                                                    image:
                                                        mapDetailsData["image"],
                                                    rating: mapDetailsData[
                                                            "ratings"]
                                                        .toString(),
                                                    category: mapDetailsData[
                                                        "category"],
                                                  )));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      padding: EdgeInsets.all(8),
                                      // width: width * 0.3,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              RatingBarIndicator(
                                                // initialRating: rating,
                                                // minRating: rating,
                                                // maxRating: rating,
                                                direction: Axis.horizontal,
                                                // allowHalfRating: true,
                                                rating: double.parse(
                                                    mapDetailsData["ratings"]),
                                                itemCount: 5,
                                                itemSize: 15,
                                                itemBuilder: (context, _) =>
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
                                              SizedBox(
                                                width: 6,
                                              ),
                                              Text(
                                                mapDetailsData["ratings"],
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "${mapDetailsData["total_reviews"]} reviews",
                                                style: TextStyle(
                                                    color:
                                                        Constants.textColour5,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12 * scalefactor),
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              CircleAvatar(
                                                  backgroundColor: Colors.grey,
                                                  radius: 7,
                                                  child: Icon(
                                                    Icons
                                                        .arrow_forward_ios_rounded,
                                                    size: 8,
                                                    color: Colors.white,
                                                  )),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    padding: EdgeInsets.all(8),
                                    // width: width * 0.3,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.access_time_filled,
                                              color: Colors.grey,
                                              size: 18,
                                            ),
                                            SizedBox(
                                              width: 6,
                                            ),
                                            Text(
                                              "2 days",
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Response time',
                                              style: TextStyle(
                                                  color: Constants.textColour5,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12 * scalefactor),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                    ),
                  )
                : SizedBox(),
            body: mapDetailsData.isNotEmpty
                ? Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: ListView(
                      children: [
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Add an Experience",
                                      style: textTheme().subtitle1),
                                ],
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddReview(
                                            celebrityId:
                                                mapDetailsData["celebrity_id"]
                                                    .toString())));
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        // Container(
                        //   height: 100,
                        //   child: ListView.builder(
                        //     itemCount: listDetailsOffers.length,
                        //       shrinkWrap: true,
                        //       scrollDirection: Axis.horizontal,
                        //       itemBuilder: (context, index){
                        //     return Padding(
                        //       padding: const EdgeInsets.all(8.0),
                        //       child: InkWell(
                        //         onTap: () {
                        //           Navigator.pushReplacement(
                        //               context,
                        //               MaterialPageRoute(
                        //                   builder: (context) =>
                        //                       BookVideoShoutout(amount: listDetailsOffers[index]["amount"], name: mapDetailsData["celebrity_name"],offerId: listDetailsOffers[index]["celebrity_offer_id"].toString(),celebrityId: mapDetailsData["celebrity_id"].toString(),)));
                        //         },
                        //         child: Column(
                        //           children: [
                        //             Container(
                        //               width: 30,
                        //               height: 30,
                        //               decoration: BoxDecoration(
                        //                 image: DecorationImage(
                        //                   image: NetworkImage(
                        //                     listDetailsOffers[index]["image"],
                        //                   ),
                        //                   fit: BoxFit.fill
                        //                 )
                        //               ),
                        //             ),
                        //             SizedBox(
                        //               height: 10,
                        //             ),
                        //             Text(
                        //               listDetailsOffers[index]["title"],
                        //               style: TextStyle(
                        //                 color: Colors.black,
                        //                 fontFamily: "Segoe UI",
                        //                 fontSize: 12 * scalefactor,
                        //               ),
                        //               textAlign: TextAlign.center,
                        //             )
                        //           ],
                        //         ),
                        //       ),
                        //     );
                        //   }),
                        // ),

                        Text(
                          mapDetailsData["description"],
                          style: TextStyle(
                              color: Constants.textColour3,
                              fontFamily: "Segoe UI",
                              fontSize: 10 * scalefactor,
                              fontWeight: FontWeight.normal),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        listDetailsLinks.isNotEmpty
                            ? Text(
                                'Follow:',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: "Segoe UI",
                                    fontSize: 14 * scalefactor,
                                    fontWeight: FontWeight.w600),
                              )
                            : SizedBox(),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        listDetailsLinks.isNotEmpty
                            ? Container(
                                width: width,
                                height: 50,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: listDetailsLinks.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (ctx, index) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(left: 18.0),
                                        child: InkWell(
                                          onTap: () {
                                            launchUrl(index);
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(25.0),
                                              child: CachedNetworkImage(
                                                width: 50,
                                                height: 50,
                                                progressIndicatorBuilder:
                                                    (context, url, progress) =>
                                                        Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    value: progress.progress,
                                                  ),
                                                ),
                                                imageUrl:
                                                    listDetailsLinks[index]
                                                        ['image'],
                                                fit: BoxFit.cover,
                                                alignment: Alignment.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              )
                            : SizedBox(),

                        SizedBox(
                          height: height * 0.02,
                        ),

                        // Container(
                        //   padding: EdgeInsets.all(16),
                        //   decoration: BoxDecoration(
                        //       color: Colors.purple[100],
                        //       borderRadius: BorderRadius.circular(12)),
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: [
                        //       Row(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           SvgPicture.asset(
                        //             'assets/handshake.svg',
                        //             width: 30,
                        //             color: Constants.textColour3,
                        //           ),
                        //           SizedBox(
                        //             width: 20,
                        //           ),
                        //           Text(
                        //             'Share Your Kindness',
                        //             style: TextStyle(
                        //                 color: Colors.black,
                        //                 fontFamily: "Segoe UI",
                        //                 fontSize: 12 * scalefactor,
                        //                 fontWeight: FontWeight.w600),
                        //           )
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: height * 0.02,
                        // ),
                        Text(
                          'JASH’N EXPERIENCE',
                          style: TextStyle(
                              color: Constants.textColour3,
                              fontFamily: "Segoe UI",
                              fontSize: 12 * scalefactor,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Text(
                          "Book a celebrity to create a personalized shout-out to surprise your beloved ones or get your brand the"
                          "recognition it deserves by requesting a business shout-out.",
                          style: TextStyle(
                              color: Constants.textColour3,
                              fontFamily: "Segoe UI",
                              fontSize: 10 * scalefactor,
                              fontWeight: FontWeight.normal),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        listDetailsOffers.isEmpty
                            ? SizedBox()
                            : Column(
                                children: [
                                  ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: listDetailsOffers.length,
                                      shrinkWrap: true,
                                      itemBuilder: (ctx, index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Container(
                                            padding: EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey),
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            CachedNetworkImage(
                                                              width:
                                                                  width * 0.04,
                                                              height:
                                                                  height * 0.03,
                                                              progressIndicatorBuilder:
                                                                  (context, url,
                                                                          progress) =>
                                                                      Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  value: progress
                                                                      .progress,
                                                                ),
                                                              ),
                                                              imageUrl:
                                                                  listDetailsOffers[
                                                                          index]
                                                                      ["image"],
                                                              fit: BoxFit.fill,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                              listDetailsOffers[
                                                                      index]
                                                                  ["title"],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      "Segoe UI",
                                                                  fontSize: 12 *
                                                                      scalefactor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            )
                                                          ],
                                                        ),
                                                        // listDetailsOffers[index]["isBusiness"] == 0
                                                        //     ?SizedBox()
                                                        // :
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          "PKR ${listDetailsOffers[index]["amount"]}",
                                                          style: TextStyle(
                                                              color: Constants
                                                                  .textColour6,
                                                              fontFamily:
                                                                  "Segoe UI",
                                                              fontSize: 12 *
                                                                  scalefactor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      ],
                                                    ),
                                                    Container(
                                                      constraints:
                                                          BoxConstraints(
                                                              maxWidth: 80,
                                                              maxHeight: 30.0),
                                                      decoration:
                                                          ShapeDecoration(
                                                        shape: StadiumBorder(),
                                                        gradient:
                                                            LinearGradient(
                                                          begin: Alignment
                                                              .topCenter,
                                                          end: Alignment
                                                              .bottomCenter,
                                                          colors: [
                                                            Constants
                                                                .buttonColourMix3,
                                                            Constants
                                                                .buttonColourMix2
                                                          ],
                                                        ),
                                                      ),
                                                      child: MaterialButton(
                                                        materialTapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                        shape: StadiumBorder(),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              "Book",
                                                              style: TextStyle(
                                                                  color: Constants
                                                                      .textColour1,
                                                                  fontFamily:
                                                                      "Segoe UI",
                                                                  fontSize: 12 *
                                                                      scalefactor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ],
                                                        ),
                                                        onPressed: () {
                                                          listDetailsOffers[
                                                                          index]
                                                                      [
                                                                      "isBusiness"] ==
                                                                  0
                                                              ? Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) => BusinessShoutoutDetails(
                                                                          celebrityId: mapDetailsData["celebrity_id"]
                                                                              .toString(),
                                                                          amount: listDetailsOffers[index]
                                                                              [
                                                                              "amount"],
                                                                          offerId: listDetailsOffers[index]["celebrity_offer_id"]
                                                                              .toString())))
                                                              : Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              BookVideoShoutout(
                                                                                amount: listDetailsOffers[index]["amount"],
                                                                                name: mapDetailsData["celebrity_name"],
                                                                                offerId: listDetailsOffers[index]["celebrity_offer_id"].toString(),
                                                                                celebrityId: mapDetailsData["celebrity_id"].toString(),
                                                                              )));
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    listDetailsOffers[index]
                                                        ["description"],
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily: "Segoe UI",
                                                        fontSize:
                                                            12 * scalefactor,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                    textAlign:
                                                        TextAlign.justify,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                ],
                              ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Recent Experience',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Segoe UI",
                                    fontSize: 14 * scalefactor,
                                    fontWeight: FontWeight.bold),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ShoutOut(
                                                id: widget.id,
                                                name: mapDetailsData[
                                                    "celebrity_name"],
                                              )));
                                },
                                child: Text(
                                  'See all',
                                  style: TextStyle(
                                      color: Constants.textColour6,
                                      fontFamily: "Segoe UI",
                                      fontSize: 14 * scalefactor,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        listShoutData.isNotEmpty
                            ? Column(
                                children: [
                                  GridView.builder(
                                    itemCount: limit,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 30,
                                      childAspectRatio: (width * 0.5 / 250),
                                    ),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return new GridTile(
                                        child: new Column(
                                          children: [
                                            _isPlay[index] == true
                                                ? _videoController != null &&
                                                        _videoController!
                                                            .value.isInitialized
                                                    ? Stack(
                                                        children: [
                                                          Container(
                                                            width: width * 0.5,
                                                            height: 180,
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              child: VideoPlayer(
                                                                  _videoController!),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Container(
                                                              width: width,
                                                              height: 160,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                              ),
                                                              child: Column(
                                                                children: [
                                                                  Spacer(),
                                                                  _isPlayed
                                                                      ? Align(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          child:
                                                                              InkWell(
                                                                            onTap:
                                                                                () {
                                                                              _videoController!.initialize().then((value) => _videoController!.play());
                                                                              setState(() {
                                                                                _isPlayed = false;
                                                                              });
                                                                            },
                                                                            child: _isPlayed
                                                                                ? Icon(
                                                                                    Icons.replay,
                                                                                    color: Colors.white,
                                                                                    size: 50,
                                                                                  )
                                                                                : SizedBox(),
                                                                          ),
                                                                        )
                                                                      : Align(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          child:
                                                                              InkWell(
                                                                            onTap:
                                                                                () {
                                                                              if (_isPlaying) {
                                                                                setState(() {
                                                                                  _videoController!.pause();
                                                                                });
                                                                              } else {
                                                                                setState(() {
                                                                                  _videoController!.play();
                                                                                });
                                                                              }
                                                                            },
                                                                            child:
                                                                                Icon(
                                                                              _isPlaying ? Icons.pause : Icons.play_arrow,
                                                                              color: Colors.white,
                                                                              size: 50,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                  Spacer(),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            _videoController!.value.volume == 0
                                                                                ? _videoController!.setVolume(100)
                                                                                : _videoController!.setVolume(0);
                                                                          });
                                                                        },
                                                                        child: Icon(
                                                                            _videoController!.value.volume == 0
                                                                                ? Icons.volume_off
                                                                                : Icons.volume_up_outlined,
                                                                            color: Constants.buttonColour1),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : Container(
                                                        width: width * 0.5,
                                                        height: 180,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          image: listShoutData[
                                                                          index]
                                                                      [
                                                                      "thumbnail"] ==
                                                                  ""
                                                              ? DecorationImage(
                                                                  image: AssetImage(
                                                                      "assets/fag.jpeg"),
                                                                  fit: BoxFit
                                                                      .cover)
                                                              : DecorationImage(
                                                                  image: NetworkImage(
                                                                      listShoutData[
                                                                              index]
                                                                          [
                                                                          "thumbnail"]),
                                                                  fit: BoxFit
                                                                      .cover),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              CircularProgressIndicator(),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                : Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.0),
                                                        child: listShoutData[
                                                                        index][
                                                                    "thumbnail"] !=
                                                                ""
                                                            ? CachedNetworkImage(
                                                                width:
                                                                    width * 0.5,
                                                                height: 180,
                                                                progressIndicatorBuilder:
                                                                    (context,
                                                                            url,
                                                                            progress) =>
                                                                        Center(
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    value: progress
                                                                        .progress,
                                                                  ),
                                                                ),
                                                                imageUrl: listShoutData[
                                                                        index][
                                                                    "thumbnail"],
                                                                fit: BoxFit
                                                                    .cover,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                              )
                                                            : SizedBox(
                                                                width:
                                                                    width * 0.5,
                                                                height: 180,
                                                              ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Center(
                                                          child: InkWell(
                                                            onTap: () {
                                                              print(
                                                                  "123\n\n\n\n\n\n\n\n\n ${_isPlaying.toString()}\n\n\n\n\n\n\n\n\n");
                                                              setState(() {
                                                                if (_isPlaying) {
                                                                  print(
                                                                      "123\n\n\n\n\n\n\n\n\n ${_isPlaying.toString()}\n\n\n\n\n\n\n\n\n");
                                                                  _videoController!
                                                                      .pause();
                                                                  _videoController!
                                                                      .dispose();
                                                                  // _videoController=null;
                                                                  setState(
                                                                      () {});
                                                                  _tapVideo(
                                                                      index);
                                                                } else {
                                                                  _tapVideo(
                                                                      index);
                                                                }
                                                              });
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .black12,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              40)),
                                                              child: Icon(
                                                                _isPlay[index]
                                                                    ? Icons
                                                                        .pause
                                                                    : Icons
                                                                        .play_arrow,
                                                                color: Colors
                                                                    .white,
                                                                size: 50,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                            // Padding(
                                            //   padding: const EdgeInsets.only(
                                            //       top: 15.0),
                                            //   child: Text(
                                            //     "${listShoutData[index]["shoutout_for"]}",
                                            //     maxLines: 1,
                                            //     overflow: TextOverflow.clip,
                                            //     textAlign: TextAlign.center,
                                            //     style: TextStyle(
                                            //         fontFamily: "Segoe UI",
                                            //         fontWeight:
                                            //         FontWeight.w400,
                                            //         fontSize:
                                            //         12 * scalefactor),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                        footer: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15.0),
                                          child: Text(
                                            "${listShoutData[index]["shoutout_for"]}",
                                            maxLines: 1,
                                            overflow: TextOverflow.clip,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: "Segoe UI",
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12 * scalefactor),
                                          ),
                                        ), //just for testing, will fill with image later
                                      );
                                    },
                                  ),
                                ],
                              )
                            : SizedBox(),
                        SizedBox(
                          height: height * 0.03,
                        ),
                      ],
                    ),
                  )
                : SizedBox()),
      ),
    );
  }

  void launchUrl(int ind) async {
    final String string = listDetailsLinks[ind]["link"];
    if (string.startsWith("http")) {
      if (!await launch(listDetailsLinks[ind]["link"]))
        throw 'Could not launch ${listDetailsLinks[ind]["link"]}';
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Link is Not Valid")));
    }
  }

  var _updateControllerTime;

  List<bool> _isPlay = [];

  bool _isPlaying = false;

  bool _disposed = false;

  bool _isPlayed = false;

  int _isPlayingIndex = 100;

  bool isInitialized = false;

  Map mapShoutOut = {};
  Map mapShoutOutData = {};
  List<dynamic> listShoutData = [];

  late VideoPlayerController? _videoController;

  void _onControllerUpdate() async {
    if (_disposed) {
      return;
    }
    _updateControllerTime = 0;

    final now = DateTime.now().millisecondsSinceEpoch;
    if (_updateControllerTime > now) {
      return;
    }
    _updateControllerTime = now * 500;

    final controller = _videoController;
    if (controller == null) {
      print("Value of controller is null");
      return;
    }
    if (!controller.value.isInitialized) {
      print("Value of controller is not initialized");
      return;
    }
    // if(controller.value.isPlaying)
    //   {
    //     _videoController.pause();
    //   }
    if (_videoController!.value.position == _videoController!.value.duration) {
      setState(() {
        _isPlayed = !_isPlayed;
      });
    }
    final playing = _videoController!.value.isPlaying;

    _isPlaying = playing;
  }

  _initializeVideo(int index) {
    final controller =
        VideoPlayerController.network(listShoutData[index]["shoutout_videos"]);
    final VideoPlayerController? old;

    _videoController = controller;

    if (_videoController!.value.isInitialized) {
      old = _videoController;

      if (old != null) {
        old.removeListener(_onControllerUpdate);
        old.pause();
      }
    }

    _isPlay[_isPlayingIndex] = true;

    setState(() {});
    controller
      ..initialize().then((_) {
        // if(old!= null)
        // {
        //   old.dispose();
        // }
        controller.addListener(_onControllerUpdate);
        // _videoController.dispose();
        controller.play();
        setState(() {});
      });

    print(_isPlaying.toString());
    print(index);
  }

  _tapVideo(int index) {
    if (_isPlayingIndex != 100) {
      print("in if condition");
      _isPlay[_isPlayingIndex] = false;
    }
    isInitialized = true;
    _isPlayingIndex = index;
    _initializeVideo(index);
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

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    print("In Dispose");
    print(isInitialized);
    if (isInitialized) {
      _disposed = true;
      _videoController!.pause();
      _videoController!.dispose();
      _videoController = null;
    }

    super.dispose();
  }
}
