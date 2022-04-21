import 'dart:isolate';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';

import '../../styles/api_handler.dart';
import '../../styles/colors.dart';
import '../../styles/strings.dart';
import 'package:http/http.dart' as http;

class ViewShoutout extends StatefulWidget {
  final String? image;
  final String video;
  final String shareLink;
  final String share;

  const ViewShoutout(
      {Key? key,
      required this.image,
      required this.video,
      required this.share,
      required this.shareLink})
      : super(key: key);

  @override
  _ViewShoutoutState createState() => _ViewShoutoutState();
}

class _ViewShoutoutState extends State<ViewShoutout> {
  bool _isPlaying = false;

  bool _disposed = false;

  bool _isPlayed = false;

  bool isPlay = false;

  bool isInitialized = false;

  late VideoPlayerController? _videoController;

  Widget _widget() {
    print(widget.video);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // double scalefactor = MediaQuery.of(context).textScaleFactor;

    return SafeArea(
      child: Scaffold(
        body: WillPopScope(
          onWillPop: onWillPop,
          child: Container(
            width: width,
            height: height,
            child: Stack(
              children: [
                // Column(
                //   children: [
                //     SizedBox(height: 10,),
                //     Padding(
                //       padding: const EdgeInsets.only(left: 16.0, right: 16),
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           InkWell(
                //             onTap: () {
                //               Navigator.pop(context);
                //               //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomBar(0)));
                //             },
                //             child: CircleAvatar(
                //               backgroundColor: Colors.white,
                //               child: Icon(
                //                 Icons.arrow_back_ios_new_rounded,
                //                 color: Colors.black,
                //               ),
                //             ),
                //           ),
                //           InkWell(
                //             onTap: () {
                //               Navigator.pop(context);
                //               //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomBar(0)));
                //             },
                //             child: CircleAvatar(
                //               backgroundColor: Colors.white,
                //               child: Image.asset("assets/share.png",width: 20,height: 20,),
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //     SizedBox(height: height*0.4,),

                //   ],
                // ),
                isPlay == true
                    ? _videoController != null &&
                            _videoController!.value.isInitialized
                        ? Stack(
                            children: [
                              Container(
                                width: width,
                                height: height,
                                child: VideoPlayer(_videoController!),
                              ),
                              Container(
                                width: width,
                                height: height,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0, right: 16, top: 16.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.pop(context);
                                              //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomBar(0)));
                                            },
                                            child: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              child: Icon(
                                                Icons
                                                    .arrow_back_ios_new_rounded,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              shareModal();
                                              //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomBar(0)));
                                            },
                                            child: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              child: Image.asset(
                                                "assets/share.png",
                                                width: 20,
                                                height: 20,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    _isPlayed
                                        ? Align(
                                            alignment: Alignment.center,
                                            child: InkWell(
                                              onTap: () {
                                                _videoController!
                                                    .initialize()
                                                    .then((value) =>
                                                        _videoController!
                                                            .play());
                                                setState(() {
                                                  _isPlayed = false;
                                                });
                                              },
                                              child: _isPlayed
                                                  ? Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.black12,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      40)),
                                                      child: Icon(
                                                        Icons.replay,
                                                        color: Colors.white,
                                                        size: 50,
                                                      ))
                                                  : SizedBox(),
                                            ),
                                          )
                                        : Align(
                                            alignment: Alignment.center,
                                            child: InkWell(
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
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.black12,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            40)),
                                                child: Icon(
                                                  _isPlaying
                                                      ? Icons.pause
                                                      : Icons.play_arrow,
                                                  color: Colors.white,
                                                  size: 70,
                                                ),
                                              ),
                                            ),
                                          ),
                                    Spacer(),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Stack(
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
                                imageUrl: widget.image!,
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, right: 16, top: 16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                        InkWell(
                                          onTap: () {
                                            shareModal();
                                            //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomBar(0)));
                                          },
                                          child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            child: Image.asset(
                                              "assets/share.png",
                                              width: 20,
                                              height: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  InkWell(
                                    onTap: () {
                                      print(
                                          "123\n\n\n\n\n\n\n\n\n ${_isPlaying.toString()}\n\n\n\n\n\n\n\n\n");
                                      setState(() {
                                        if (_isPlaying) {
                                          print(
                                              "123\n\n\n\n\n\n\n\n\n ${_isPlaying.toString()}\n\n\n\n\n\n\n\n\n");
                                          _videoController!.pause();
                                          _videoController!.dispose();
                                          // _videoController=null;
                                          setState(() {});
                                          _tapVideo();
                                        } else {
                                          _tapVideo();
                                        }
                                      });
                                    },
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                  ),
                                  Spacer(),
                                ],
                              )
                            ],
                          )
                    : Stack(
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
                            imageUrl: widget.image!,
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, right: 16, top: 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
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
                                    InkWell(
                                      onTap: () {
                                        shareModal();
                                        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomBar(0)));
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: Image.asset(
                                          "assets/share.png",
                                          width: 20,
                                          height: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  print(
                                      "123\n\n\n\n\n\n\n\n\n ${_isPlaying.toString()}\n\n\n\n\n\n\n\n\n");
                                  setState(() {
                                    if (_isPlaying) {
                                      print(
                                          "123\n\n\n\n\n\n\n\n\n ${_isPlaying.toString()}\n\n\n\n\n\n\n\n\n");
                                      _videoController!.pause();
                                      _videoController!.dispose();
                                      // _videoController=null;
                                      setState(() {});
                                      _tapVideo();
                                    } else {
                                      _tapVideo();
                                    }
                                  });
                                },
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Icon(
                                    Icons.play_arrow,
                                    color: Constants.textColour1,
                                    size: 80,
                                  ),
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                        ],
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }





  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
    IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  @override
  void dispose() {
    print("In Dispose");
    if (isInitialized) {
      _videoController!.pause();
      _videoController!.dispose();
      _videoController = null;
    }

    super.dispose();
  }

  shareModal() {
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
                          onButtonTap(Share.share_system);
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

                          downloadFile();
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

  downloadModal() {
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
                            "File is Downloading...",
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
      setState(() {
        _isPlayed = !_isPlayed;
      });
    }
    final playing = _videoController!.value.isPlaying;

    _isPlaying = playing;
  }

  _initializeVideo() {
    final controller = VideoPlayerController.network(widget.video);

    _videoController = controller;

    isPlay = true;
    isInitialized = true;
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
  }

  _tapVideo() {
    _initializeVideo();
  }

  Future<bool> onWillPop() {
    Navigator.pop(context);
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => Celeb_Details()));
    return Future.value(true);
  }

  bool videoEnable = false;

  bool downloading = false;
  String progressString = '';

  Future<void> onButtonTap(Share share) async {
    String msg =
        'Flutter share is great!!\n Check out full example at https://pub.dev/packages/flutter_share_me';
    String url = widget.shareLink;

    String? response;
    final FlutterShareMe flutterShareMe = FlutterShareMe();
    switch (share) {
      case Share.share_system:
        response = await flutterShareMe.shareToSystem(msg: url);
        _onDownload();
        break;
    }
    debugPrint(response);
  }

  Future<void> downloadFile() async {
    String url = '';
    url = widget.shareLink;

    var uuid = Uuid();
    var dio = Dio();

    setState(() {
      Navigator.pop(context);
      downloadModal();
      _onDownload();
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

  var myId;
  var token;

  Future<void> _onDownload() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    myId = prefs.getString("customer_id");
    Handler handler = Handler('user/download');
    String url1 = handler.getUrl();

    print("Click on fetch data");
    var url = Uri.parse(url1);
    print(url);
    print(myId.toString());
    print(token.toString());
    print(widget.share);

    var response = await http.post(url,
        body: ({"link": widget.share, "customer_id": myId.toString()}),
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
}

enum Share {
  share_system,
}


class _TaskInfo {
  final String? name;
  final String? link;

  String? taskId;
  int? progress = 0;
  DownloadTaskStatus? status = DownloadTaskStatus.undefined;

  _TaskInfo({this.name, this.link});
}

class _ItemHolder {
  final String? name;
  final _TaskInfo? task;

  _ItemHolder({this.name, this.task});
}
