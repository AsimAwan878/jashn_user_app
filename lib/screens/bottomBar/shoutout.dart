import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jashn_user/styles/colors.dart';
import 'package:video_player/video_player.dart';

import '../../styles/api_handler.dart';
import '../../styles/strings.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:developer' as developer;
import 'dart:async';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class ShoutOut extends StatefulWidget {
  var id;
  final String name;

  ShoutOut({Key? key, required this.id, required this.name}) : super(key: key);

  @override
  ShoutOutState createState() => ShoutOutState();
}

class ShoutOutState extends State<ShoutOut> {
  bool isInitialized = false;
  bool isInitializedData=false;
  List listOfThumbnail = [];

  bool isDelaying = false;
  bool isConnected = false;
  bool isInternetDown = false;

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
          isInitializedData = true;
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
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leadingWidth: 100,
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
            "Shoutouts",
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
                    visible: isInternetDown==false || isConnected,
                    replacement: Container(
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
                    child: Visibility(
                      visible: isConnected && isInitializedData,
                      replacement: Center(
                        child: CupertinoActivityIndicator(
                          color: Constants.textColour6,
                          radius: 20.0,
                        ),
                      ),
                      child: Visibility(
                        visible: listShoutData.isNotEmpty,
                        replacement: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Text("No shout for now..."),
                            ),
                          ],
                        ),
                        child: Container(
                          width: width,
                          height: height,
                          child: Column(
                            children: [
                              SizedBox(
                                height: height * 0.01,
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 18.0),
                                  child: Container(
                                    width: width,
                                    height: height,
                                    child: GridView.count(
                                      scrollDirection: Axis.vertical,
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 30,
                                      childAspectRatio: (width * 0.5 / 250),
                                      children: [
                                        for (int i = 0; i < listShoutData.length; i++)
                                          listShoutData.isEmpty
                                              ? Center(
                                                  child: CupertinoActivityIndicator(
                                                    color: Constants.textColour6,
                                                    radius: 20.0,
                                                  ),
                                                )
                                              : Column(
                                                  children: [
                                                    _isPlay[i] == true
                                                        ? _videoController != null &&
                                                                _videoController!
                                                                    .value
                                                                    .isInitialized
                                                            ? Stack(
                                                                children: [
                                                                  Container(
                                                                    width:
                                                                        width * 0.5,
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
                                                                                    onTap: () {
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
                                                                                    child: Icon(
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
                                                                                  setState(() {
                                                                                    _videoController!.value.volume == 0 ? _videoController!.setVolume(100) : _videoController!.setVolume(0);
                                                                                  });
                                                                                },
                                                                                child: Icon(
                                                                                    _videoController!.value.volume == 0 ? Icons.volume_off : Icons.volume_up_outlined,
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
                                                                          .circular(
                                                                              20),
                                                                  image: listShoutData[
                                                                                  i][
                                                                              "thumbnail"] ==
                                                                          ""
                                                                      ? DecorationImage(
                                                                          image: AssetImage(
                                                                              "assets/fag.jpeg"),
                                                                          fit: BoxFit
                                                                              .cover)
                                                                      : DecorationImage(
                                                                          image: NetworkImage(
                                                                              listShoutData[i]
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
                                                        : Container(
                                                            width: width * 0.5,
                                                            height: 180,
                                                            child: Stack(
                                                              children: [
                                                                listShoutData[i]["thumbnail"] != ""
                                                                    ? ClipRRect(
                                                                  borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(25)),
                                                                  child: CachedNetworkImage(
                                                                    width: width * 0.5,
                                                                    height: 180,
                                                                    progressIndicatorBuilder: (context, url, progress) => Center(
                                                                      child: CircularProgressIndicator(
                                                                        value: progress.progress,
                                                                      ),
                                                                    ),
                                                                    imageUrl: listShoutData[i]["thumbnail"],
                                                                    fit: BoxFit.cover,
                                                                    alignment: Alignment.center,
                                                                  ),
                                                                )
                                                                    : SizedBox(),
                                                                Padding(
                                                                  padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                                  child: Center(
                                                                    child: InkWell(
                                                                      onTap: () {
                                                                        print(
                                                                            "123\n\n\n\n\n\n\n\n\n ${_isPlaying.toString()}\n\n\n\n\n\n\n\n\n");
                                                                        if (_videoController == null) {
                                                                          setStateIfMounted((){
                                                                            _tapVideo(i);
                                                                          });

                                                                        } else {
                                                                          print("Else condition");
                                                                          print(
                                                                              "323\n\n\n\n\n\n\n\n\n ${_isPlaying.toString()}\n\n\n\n\n\n\n\n\n");
                                                                          _videoController!
                                                                              .pause();
                                                                          _videoController!
                                                                              .dispose();
                                                                          // _videoController=null;
                                                                          setState(
                                                                                  () {});
                                                                          _tapVideo(i);
                                                                        }
                                                                      },
                                                                      child: Container(
                                                                        decoration:BoxDecoration(
                                                                            color:Colors.black12,
                                                                            borderRadius: BorderRadius.circular(40)

                                                                        ),
                                                                        child: Icon(
                                                                          _isPlay[i]
                                                                              ? Icons.pause
                                                                              : Icons
                                                                              .play_arrow,
                                                                          color:
                                                                          Colors.white,
                                                                          size: 50,
                                                                        ),
                                                                      ),
                                                                  ),
                                                                ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(
                                                          top: 15.0),
                                                      child: Text(
                                                        "${listShoutData[i]["shoutout_for"]}",
                                                        maxLines: 1,
                                                        overflow: TextOverflow.clip,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            fontFamily: "Segoe UI",
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize:
                                                                12 * scalefactor),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: height * 0.01,
                              ),
                            ],
                          ),
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
    return Future.value(true);
  }

  var _updateControllerTime;

  List<bool> _isPlay = [];

  bool _isPlaying = false;

  bool _disposed = false;

  bool _isPlayed = false;

  int? _isPlayingIndex = null;

  VideoPlayerController? _videoController;

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
    isInitialized = true;
    _isPlayingIndex = index;
    _initializeVideo(index);
  }

  Map mapShoutOut = {};
  Map mapShoutOutData = {};
  List<dynamic> listShoutData = [];

  Future<void> _fetchData() async {
    Handler handler = Handler(
        'unauthorized/home/celebrity_shoutout?celebrity_id=${widget.id.toString()}');
    String url = handler.getUrl();
    print(widget.id);
    print(url);
    print("Click on fetch data");
    var shoutOutUrl = Uri.parse(url);
    var shoutOutResponse = await http.get(shoutOutUrl);
    if (shoutOutResponse.statusCode == 200) {
      print("Response coming :${shoutOutResponse.statusCode}");
      var jsonBody = jsonDecode(shoutOutResponse.body);
      if (jsonBody["success"] == true) {
        setState(() {
          mapShoutOut = jsonBody;
          listShoutData = mapShoutOut["data"];
          _isPlay = List.generate(listShoutData.length, (index) => false);
        });
      } else if (jsonBody["success"] == false) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(jsonBody["message"])));
      }
    } else {
      print("Request failed to response :${shoutOutResponse.statusCode}");
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
