import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:jashn_user/screens/bottomBar/categories/celeb_details.dart';
import 'package:jashn_user/screens/bottomBar/profiles/profiles.dart';
import 'package:jashn_user/styles/colors.dart';
import 'package:jashn_user/styles/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';
import '../../styles/api_handler.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:developer' as developer;
import 'dart:async';
import 'package:flutter/services.dart';

class JashnMoments extends StatefulWidget {
  @override
  JashnMomentsState createState() => JashnMomentsState();
}

class JashnMomentsState extends State<JashnMoments> {
  bool isInitialized = false;
  bool downloading = false;
  String progressString = '';
  String myText = '';

  List<bool> _isPlay = [];

  VideoPlayerController? _videoController;

  bool _isPlaying = false;

  bool _disposed = false;

  bool _isPlayed = false;

  int? _isPlayingIndex = null;

  bool isInitializing = false;
  bool isDelaying = false;
  bool isConnected = false;
  bool isInternetDown = false;
  bool isLoadingMore = false;

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  ScrollController? _scrollController = ScrollController();

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
    print("Hi");
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
      _getVideos().whenComplete(() {
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
    double scaleFactor = MediaQuery.of(context).textScaleFactor;
    print("isPlaying${_isPlaying.toString()}");
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.textColour1,
          title: Text(
            "Moments",
            style: homeTextTheme().subtitle2,
          ),
          centerTitle: true,
        ),
        body: Visibility(
          visible: isDelaying,
          replacement: loadingCard(width, height),
          child: Visibility(
            visible: isInternetDown == false || isConnected,
            replacement: Scaffold(
              body: Container(
                width: width,
                height: height,
                color: Constants.textColour4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/sad-face-in-rounded-square.png",
                      color: Constants.textColour1,
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        "OOPS !",
                        style: homeTextTheme().bodyText1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        "No Internet Connection...",
                        style: textTheme().subtitle1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            child: Visibility(
              visible: isInitializing,
              replacement: loadingCard(width, height),
              child: Container(
                width: width,
                height: height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: reviewData.isNotEmpty
                          ? Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Container(
                                  width: width,
                                  height: height,
                                  color: Constants.textColour1,
                                  child: ListView.builder(
                                      controller: _scrollController,
                                      itemCount: reviewData.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: width,
                                                height: 550,
                                                decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.5),
                                                        spreadRadius: 5,
                                                        blurRadius: 7,
                                                        offset: Offset(0,
                                                            3), // changes position of shadow
                                                      ),
                                                    ],
                                                    color:
                                                        Constants.textColour1,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    _isPlay[index] == true
                                                        ? _videoController !=
                                                                    null &&
                                                                _videoController!
                                                                    .value
                                                                    .isInitialized
                                                            ? Stack(
                                                                children: [
                                                                  Container(
                                                                    width:
                                                                        width,
                                                                    height:
                                                                        400,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.only(
                                                                            topRight:
                                                                                Radius.circular(20),
                                                                            topLeft: Radius.circular(20))),
                                                                    child: VideoPlayer(
                                                                        _videoController!),
                                                                  ),
                                                                  Container(
                                                                    width:
                                                                        width,
                                                                    height:
                                                                        390,
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Spacer(),
                                                                        _isPlayed
                                                                            ? InkWell(
                                                                                onTap: () {
                                                                                  _videoController!.initialize().then((value) => _videoController!.play());
                                                                                  setState(() {
                                                                                    _isPlayed = false;
                                                                                  });
                                                                                },
                                                                                child: CircleAvatar(
                                                                                  radius: 33,
                                                                                  backgroundColor: Colors.black38,
                                                                                  child: _isPlayed
                                                                                      ? Icon(
                                                                                          Icons.replay,
                                                                                          color: Colors.white,
                                                                                          size: 50,
                                                                                        )
                                                                                      : SizedBox(),
                                                                                ),
                                                                              )
                                                                            : InkWell(
                                                                                onTap: () {
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
                                                                                child: CircleAvatar(
                                                                                  radius: 33,
                                                                                  backgroundColor: Colors.black38,
                                                                                  child: Icon(
                                                                                    _isPlaying ? Icons.pause : Icons.play_arrow,
                                                                                    color: Colors.white,
                                                                                    size: 50,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                        Spacer(),
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(
                                                                              bottom: 28.0,
                                                                              left: 8.0),
                                                                          child: Align(
                                                                              child: GestureDetector(
                                                                                onTap: () {
                                                                                  setState(() {
                                                                                    _videoController!.value.volume == 0 ? _videoController!.setVolume(100) : _videoController!.setVolume(0);
                                                                                  });
                                                                                },
                                                                                child: Icon(_videoController!.value.volume == 0 ? Icons.volume_off : Icons.volume_up_outlined, color: Constants.buttonColour1),
                                                                              ),
                                                                              alignment: Alignment.bottomLeft),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            : Container(
                                                                width: width,
                                                                height: 400,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius: BorderRadius.only(
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              20),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              20)),
                                                                  image: reviewData[index]
                                                                              [
                                                                              "thumbnail"] ==
                                                                          ""
                                                                      ? DecorationImage(
                                                                          image: AssetImage(
                                                                              "assets/fag.jpeg"),
                                                                          fit: BoxFit
                                                                              .cover)
                                                                      : DecorationImage(
                                                                          image: NetworkImage(reviewData[index]
                                                                              [
                                                                              "thumbnail"]),
                                                                          fit: BoxFit
                                                                              .cover),
                                                                ),
                                                                child: Center(
                                                                    child:
                                                                        CircularProgressIndicator()),
                                                              )
                                                        : Stack(
                                                            alignment: Alignment
                                                                .center,
                                                            children: [
                                                              reviewData[index][
                                                                          "thumbnail"] !=
                                                                      ""
                                                                  ? ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.only(topRight: Radius.circular(20.0),topLeft: Radius.circular(20.0)),
                                                                      child:
                                                                          CachedNetworkImage(
                                                                        width:
                                                                            width,
                                                                        height: 400,
                                                                        progressIndicatorBuilder: (context,
                                                                                url,
                                                                                progress) =>
                                                                            Center(
                                                                          child:
                                                                              CircularProgressIndicator(
                                                                            value:
                                                                                progress.progress,
                                                                          ),
                                                                        ),
                                                                        imageUrl:
                                                                            reviewData[index]["thumbnail"],
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        alignment:
                                                                            Alignment.center,
                                                                      ),
                                                                    )
                                                                  : SizedBox(
                                                                      width:
                                                                          width,
                                                                      height:
                                                                          height /
                                                                              2.2,
                                                                    ),
                                                              Center(
                                                                  child:
                                                                      InkWell(
                                                                onTap: () {
                                                                  print(
                                                                      "123\n\n\n\n\n\n\n\n\n ${_isPlaying.toString()}\n\n\n\n\n\n\n\n\n");
                                                                  setState(() {
                                                                    if (_videoController !=
                                                                        null) {
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
                                                                child:
                                                                    Container(
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .black12,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              40)),
                                                                  child: Icon(
                                                                    _isPlay[index]
                                                                        ? Icons
                                                                            .pause
                                                                        : Icons
                                                                            .play_arrow,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 70,
                                                                  ),
                                                                ),
                                                              )),
                                                            ],
                                                          ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 20,
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
                                                            imageUrl:reviewData[index]["image"],
                                                            fit: BoxFit.cover,
                                                            alignment: Alignment.center,
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        Text(
                                                          "${reviewData[index]["celebrity"]}"
                                                              .toUpperCase(),
                                                          style: TextStyle(
                                                              color: Constants
                                                                  .textColour3,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14 *
                                                                  scaleFactor),
                                                        ),
                                                        Spacer(
                                                          flex: 4,
                                                        ),
                                                        Container(
                                                          width: 69,
                                                          height: 28,
                                                          decoration:
                                                              ShapeDecoration(
                                                            shape:
                                                                StadiumBorder(),
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
                                                            shape:
                                                                StadiumBorder(),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text("Book",
                                                                    style: homeTextTheme()
                                                                        .subtitle1),
                                                              ],
                                                            ),
                                                            onPressed: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          CelebDetails(
                                                                              id: reviewData[index]["celebrity_id"])));
                                                            },
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 20,
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 22.0),
                                                      child: Text(
                                                        "${reviewData[index]["shoutout_for"]}",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Segoe UI",
                                                            color: Constants
                                                                .textColour4,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 10 *
                                                                scaleFactor),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Divider(
                                                      thickness: 1.0,
                                                      color:
                                                          Constants.textColour2,
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20.0),
                                                      child: InkWell(
                                                        child: Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Image.asset(
                                                              "assets/share.png",
                                                              width: 20,
                                                              height: 20,
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                              "Share video shoutout",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "Segoe UI",
                                                                  color: Constants
                                                                      .textColour3,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 10 *
                                                                      scaleFactor),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                            ),
                                                          ],
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                        ),
                                                        onTap: () {
                                                          shareModal(index);
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: height * 0.05,
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                ),
                                isLoadingMore
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          CupertinoActivityIndicator(
                                            color: Constants.textColour6,
                                            radius: 20.0,
                                          ),
                                          SizedBox(
                                            height: 50,
                                          ),
                                        ],
                                      )
                                    : SizedBox(),
                              ],
                            )
                          : Container(
                              width: width,
                              height: height,
                              color: Constants.textColour4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: width * 0.1,
                                    height: height * 0.05,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                      image: AssetImage(
                                        "assets/sad-face-in-rounded-square.png",
                                      ),
                                      fit: BoxFit.fill,
                                    )),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "No Moments",
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
                                        "When the celebrity makes a shout-out, the shout-out videos will display here.",
                                        style: TextStyle(
                                            color: Constants.textColour1,
                                            fontFamily: "Segoe UI",
                                            fontSize: 20 * scaleFactor,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
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
    );
  }

  Container loadingCard(double width, double height) {
    return Container(
      color: Constants.textColour1,
      child: Column(
        children: [
          SizedBox(
            height: height * 0.01,
          ),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 32.0),
                  child: ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => SizedBox(
                      height: 20,
                    ),
                    itemCount: 1,
                    itemBuilder: (context, index) => Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Skeleton(
                            height: height * 0.6,
                            width: width * 0.95,
                            decoration: BorderRadius.all(Radius.circular(20))),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Skeleton(
                                height: height * 0.48,
                                width: width * 0.95,
                                decoration:
                                    BorderRadius.all(Radius.circular(12))),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Skeleton(
                                    height: 60,
                                    width: 60,
                                    decoration:
                                        BorderRadius.all(Radius.circular(30))),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  children: [
                                    Skeleton(
                                        height: 25,
                                        width: width * 0.3,
                                        decoration: BorderRadius.all(
                                            Radius.circular(2.0))),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ))),
        ],
      ),
    );
  }

  var _updateControllerTime;

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
      setStateIfMounted(() {
        _isPlayed = !_isPlayed;
      });
    }
    final playing = _videoController!.value.isPlaying;

    _isPlaying = playing;
  }

  _initializeVideo(int index) {
    final controller =
        VideoPlayerController.network(reviewData[index]["video"]);
    final VideoPlayerController? old;

    _videoController = controller;

    if (_videoController!.value.isInitialized) {
      old = _videoController;

      if (old != null) {
        old.removeListener(_onControllerUpdate);
        old.pause();
      }
    }

    _isPlay[_isPlayingIndex!] = true;

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
    if (_isPlayingIndex != null) {
      print("in if condition");
      _isPlay[_isPlayingIndex!] = false;
    }
    _isPlayingIndex = index;
    _initializeVideo(index);
  }

  var myId;
  var token;

  Map reviewMap = {};
  List dummyData = [];
  List reviewData = [];

  Future _getVideos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    myId = prefs.getString("customer_id");

    Handler handler = Handler('user/moments?customer_id=$myId');
    String url1 = handler.getUrl();
    print(url1);

    var getReviewsResponse = await http.get(Uri.parse(url1),
        headers: ({
          "Authorization": "Bearer ${token.toString()}",
        }));
    print(myId.toString());
    print(token.toString());
    if (getReviewsResponse.statusCode == 200) {
      var reviewVariable = jsonDecode(getReviewsResponse.body);
      if (reviewVariable["success"] == true) {
        reviewMap = reviewVariable;
        dummyData = reviewVariable["data"];
        reviewData = List.generate(_currentMax, (index) => dummyData[index]);
        _isPlay = List.generate(reviewData.length, (index) => false);
        _scrollController!.addListener(() {
          if (_scrollController!.position.pixels ==
              _scrollController!.position.maxScrollExtent) {
            isLoadingMore = true;
            setStateIfMounted(() {});
            Future.delayed(const Duration(seconds: 3), () {
              _getMoreVideos();
            });
          }
        });
        print(reviewData[0]["video"]);
        print(reviewData);
        print(token.toString());
      } else if (reviewVariable["success"] == false) {}
      print(reviewVariable["success"]);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("No data found")));
    }
  }

  int _currentMax = 3;

  _getMoreVideos() {
    print(reviewData.length);
    print(dummyData.length);
    print(_isPlay.length);
    if (reviewData.length <= dummyData.length) {
      if (reviewData.length + 3 <= dummyData.length) {
        print("In if condition");
        for (int i = _currentMax; i < _currentMax + 3; i++) {
          reviewData.add(dummyData[i]);
          _isPlay.add(false);
        }
        isLoadingMore = false;
        _currentMax = _currentMax + 3;
      } else {
        print("In Else Condition");
        var _currentIncrement = dummyData.length - reviewData.length;
        print("Current Max = ${_currentIncrement}");
        for (int i = _currentMax; i < _currentMax + _currentIncrement; i++) {
          reviewData.add(dummyData[i]);
          _isPlay.add(false);
        }
        isLoadingMore = false;
        _currentMax = _currentMax + _currentIncrement;
      }
      setStateIfMounted(() {});
    } else {
      print("In else condition og getting more videos");
    }
  }

  bool videoEnable = false;

  shareModal(int index) {
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
                      Row(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          onButtonTap(Share.share_system, index);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Share to...",
                              style: TextStyle(
                                  color: Constants.textColour4,
                                  fontFamily: "Segoe UI",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                      Divider(
                        color: Constants.textColour4,
                        height: 1.0,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          print("tap on gesture detecter");

                          downloadFile(index);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Download video",
                              style: TextStyle(
                                  color: Constants.textColour4,
                                  fontFamily: "Segoe UI",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                      Divider(
                        color: Constants.textColour4,
                        height: 1.0,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Cancel",
                              style: TextStyle(
                                  color: Constants.textColour4,
                                  fontFamily: "Segoe UI",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
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

  downloadModal(int index) {
    final width = MediaQuery.of(context).size.width;
    return showModalBottomSheet(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        ),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context, setState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  child: Wrap(
                    children: <Widget>[
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
                          Text(
                            "Task Added",
                            style: TextStyle(
                                color: Constants.textColour3,
                                fontFamily: "Segoe UI",
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
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
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                border:
                                    Border.all(color: Constants.buttonColour3)),
                            child: Center(
                                child: Icon(
                              Icons.check,
                              color: Constants.buttonColour3,
                              size: 30,
                            )),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "${reviewData[index]["shoutout_for"]} is Downloading",
                            style: TextStyle(
                                color: Constants.textColour4,
                                fontFamily: "Segoe UI",
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
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
                            constraints: BoxConstraints(
                                maxWidth: width / 1.3, maxHeight: 50.0),
                            alignment: Alignment.center,
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
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              shape: StadiumBorder(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("OK", style: textTheme().subtitle1),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: 30,
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

  Future<void> downloadFile(int index) async {
    String url = '';
    url = reviewData[index]["video"];

    var uuid = Uuid();
    var dio = Dio();

    setState(() {
      Navigator.pop(context);
      downloadModal(index);
      _onDownload(index);
    });

    try {
      await dio.download(url, "/storage/emulated/0/Download/${uuid.v4()}.mp4",
          onReceiveProgress: (rec, total) {
        print("Rec: $rec , Total: $total");

        setState(() {
          downloading = true;

          progressString = ((rec / total) * 100).toStringAsFixed(0);
          print(progressString);
        });
      });
    } catch (e) {
      print(e);
    }

    setState(() {
      downloading = false;
    });
    print("Download completed");
  }

  // Future<void> _showProgressNotification() async {
  //   const int maxProgress = 50;
  //   for (int i = 0; i <= maxProgress; i++) {
  //     await Future<void>.delayed(const Duration(seconds: 1), () async {
  //       final AndroidNotificationDetails androidPlatformChannelSpecifics =
  //       AndroidNotificationDetails('progress channel', 'progress channel',
  //           channelShowBadge: false,
  //           importance: Importance.max,
  //           priority: Priority.high,
  //           playSound: false,
  //           onlyAlertOnce: true,
  //           showProgress: true,
  //           maxProgress: maxProgress,
  //           progress: i);
  //       final NotificationDetails platformChannelSpecifics =
  //       NotificationDetails(android: androidPlatformChannelSpecifics);
  //       await flutterLocalNotificationsPlugin.show(
  //           0,
  //           'Task Downloading...',
  //           '',
  //           platformChannelSpecifics,
  //           payload: 'my item');
  //     });
  //   }
  // }

  Future<void> onButtonTap(Share share, int index) async {
    String msg =
        'Flutter share is great!!\n Check out full example at https://pub.dev/packages/flutter_share_me';
    String url = reviewData[index]["share_link"];

    String? response;
    final FlutterShareMe flutterShareMe = FlutterShareMe();
    switch (share) {
      case Share.share_system:
        {
          response = await flutterShareMe.shareToSystem(msg: url);
          _onDownload(index);
          break;
        }
    }
    debugPrint(response);
  }

  Future<void> _onDownload(int index) async {
    Handler handler = Handler('user/download');
    String url1 = handler.getUrl();

    print("Click on fetch data");
    var url = Uri.parse(url1);
    print(url);
    print(myId.toString());
    print(token.toString());
    print(dummyData[index]["share"]);

    var response = await http.post(url,
        body: ({
          "link": dummyData[index]["share"],
          "customer_id": myId.toString()
        }),
        headers: ({
          "Authorization": "Bearer ${token.toString()}",
        }));
    if (response.statusCode == 200) {
      print("Response coming :${response.statusCode}");
    } else {
      print(response.body.toString());
      print("Request failed to response :${response.statusCode}");
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

    print("In Dispose");
    if (isInitialized) {
      _disposed = true;
      _videoController!.pause();
      _videoController!.dispose();
      _videoController = null;
    }
    super.dispose();
  }
}

enum Share {
  share_system,
}
