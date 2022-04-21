import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:jashn_user/screens/bottomBar/bottom_bar.dart';
import '../../../models/search.dart';
import '../../../styles/api_handler.dart';
import '../../../styles/colors.dart';
import '../../../styles/strings.dart';
import 'celeb_details.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:developer' as developer;
import 'dart:async';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class Categories extends StatefulWidget {
  var title;
  final List allCategoriesList;
  final List allDataList;
  var categoryId;

  Categories(
      {required this.title,
      required this.allCategoriesList,
      required this.allDataList,
      required this.categoryId});

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  TextEditingController typeAheadController = TextEditingController();
  // ScrollController? controller = ScrollController();
  bool isMoreData = false;

  Map mapResponse = {};
  List listOfData = [];
  List dummyData=[];
  final List updatedList = [];
  int j = 0;

  bool isDelaying = false;
  bool getDataCalled=false;
  bool isConnected = false;
  bool isInternetDown = false;

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  ScrollController? _scrollController = ScrollController();
  int _currentMax = 8;
  bool isLoadingMore = false;

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
          getDataCalled=true;
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
    Handler handler = Handler('unauthorized/home/celebrity?type=all');
    String url1 = handler.getUrl();

    print("Click on fetch data");
    var url = Uri.parse(url1);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      print("Response coming :${response.statusCode}");
      setStateIfMounted(() {
        mapResponse = jsonDecode(response.body);
        dummyData = mapResponse["data"];
        listOfData =
            List.generate(_currentMax, (index) => dummyData[index]);
        _scrollController!.addListener(() {
          if (_scrollController!.position.pixels ==
              _scrollController!.position.maxScrollExtent) {
            isLoadingMore = true;
            setStateIfMounted(() {});
            Future.delayed(const Duration(seconds: 3), () {
              _getMoreData();
            });
          }
        });

        _update(0);
        // print(controller!.hasClients.toString());
        // controller!.addListener(() {
        //   if (controller!.position.pixels ==
        //       controller!.position.maxScrollExtent) {
        //     print(controller!.position.pixels.toString());
        //     print(controller!.position.maxScrollExtent.toString());
        //     print("In if condition");
        //     setStateIfMounted(() {
        //       isDelaying = false;
        //     });
        //
        //     Future.delayed(const Duration(seconds: 5), () {
        //       setStateIfMounted(() {
        //         isDelaying = true;
        //         if(getDataCalled ==false)
        //           {getDataCalled=true;
        //             print("get data called");
        //             _getMoreVideos();
        //           }
        //         else{
        //           return;
        //         }
        //       });
        //     });
        //   }
        // });
        print("Lenngth is:${listOfData.length}");
      });
    } else {
      print("Request failed to response :${response.statusCode}");
    }
  }

  _getMoreData() {
    if (listOfData.length <= dummyData.length) {
      if (listOfData.length + 8 <= dummyData.length) {
        print("In if condition");
        for (int i = _currentMax; i < _currentMax + 3; i++) {
          listOfData.add(dummyData[i]);
          updatedList.insert(i, listOfData[i]);
        }
        isLoadingMore = false;
        _currentMax = _currentMax + 3;
      } else {
        print("In Else Condition");
        var _currentIncrement = dummyData.length - listOfData.length;
        print("Current Max = ${_currentIncrement}");
        for (int i = _currentMax; i < _currentMax + _currentIncrement; i++) {
          listOfData.add(dummyData[i]);
          updatedList.insert(i, listOfData[i]);
        }
        isLoadingMore = false;
        _currentMax = _currentMax + _currentIncrement;
      }
      setStateIfMounted(() {});
    } else {
      print("In else condition og getting more videos");
    }
  }

  _update(int updatedIndex) {
    j = updatedIndex;
    print("In update method");
    print(listOfData.length);
    for (int i = updatedIndex; i < listOfData.length; i++) {
      if (widget.categoryId.toString() == listOfData[i]["category_id"]) {
        updatedList.insert(j, listOfData[i]);
        j++;
      } else if (widget.categoryId.toString() == '1') {
        print("else if condition called");
        updatedList.insert(i, listOfData[i]);
      } else {
        print("else condition called");
      }
    }
    print(widget.categoryId);
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
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              elevation: 6,
              borderRadius: BorderRadius.circular(64),
              child: InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BottomBar(
                                currentIndex: 0,
                                categoryId: 1,
                                categoryName: "All",
                              )));
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
            ),
          ),
          title: Text(widget.title, style: homeTextTheme().subtitle2),
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
                visible: getDataCalled,
                replacement: Center(
                  child: CupertinoActivityIndicator(
                    color: Constants.textColour6,
                    radius: 20.0,
                  ),
                ),
                child: Container(
                  width: width,
                  height: height,
                  child: Container(
                    height: height,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 25.0, right: 25, top: 30, bottom: 30),
                          child: Material(
                            elevation: 4,
                            borderRadius: BorderRadius.circular(32),
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(32)),
                                child: TypeAheadField<User?>(
                                  hideSuggestionsOnKeyboardHide: true,
                                  debounceDuration: Duration(milliseconds: 500),
                                  textFieldConfiguration: TextFieldConfiguration(
                                    controller: typeAheadController,
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.search,
                                          color: Constants.textColour3,
                                        ),
                                        hintText: 'Search celebrities',
                                        hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontFamily: "Segoe UI",
                                            fontSize: 14 * scalefactor),
                                        // suffixIcon: IconButton(
                                        //   icon: Icon(Icons.clear,color: Constants.textColour4,),
                                        //   onPressed: (){
                                        //     if(typeAheadController.text.isNotEmpty)
                                        //       {
                                        //         typeAheadController.clear();
                                        //       }
                                        //   },
                                        // ),
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none),
                                  ),
                                  suggestionsCallback: (pattern) async {
                                    return await UserApi.getUserSuggestions(pattern);
                                  },
                                  itemBuilder: (context, User? suggestion) {
                                    // Text("Recommended",
                                    //   style:TextStyle(
                                    //       color: Constants.text_colour3,
                                    //       fontFamily: "Segoe UI",
                                    //       fontSize: 14 * scalefactor),),
                                    final user = suggestion!;
                                    return ListTile(
                                      title: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
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
                                              imageUrl: user.image,
                                              fit: BoxFit.cover,
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  user.name,
                                                  style: TextStyle(
                                                      color: Constants.textColour3,
                                                      fontFamily: "Segoe UI",
                                                      fontSize: 14 * scalefactor),
                                                ),
                                                Text(
                                                  user.category,
                                                  style: TextStyle(
                                                      color: Constants.textColour4,
                                                      fontFamily: "Segoe UI",
                                                      fontSize: 14 * scalefactor),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                    //   GridView.count(
                                    //   physics: NeverScrollableScrollPhysics(),
                                    //   crossAxisCount: 2,
                                    //   crossAxisSpacing: 10,
                                    //   mainAxisSpacing: 10,
                                    //
                                    // );
                                  },
                                  onSuggestionSelected: (User? suggestion) {
                                    final user = suggestion!;
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CelebDetails(id: user.id)));
                                  },
                                  noItemsFoundBuilder: (context) => Container(
                                    height: 100,
                                    child: Center(
                                      child: Text(
                                        'No Celebrity Found',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 12),
                                      ),
                                    ),
                                  ),
                                )
                                // TextField(
                                //   cursorColor: Colors.grey,
                                //   decoration: InputDecoration(
                                //       prefixIcon: Icon(Icons.search,color: Constants.text_colour3,),
                                //       hintText: 'Search celebrities',
                                //       hintStyle: TextStyle(
                                //           color: Colors.grey, fontSize: 14 * scalefactor),
                                //       enabledBorder: InputBorder.none,
                                //       focusedBorder: InputBorder.none),
                                // ),
                                ),
                          ),
                        ),
                        Container(
                          height: 40,
                          child: ListView.builder(
                              itemCount: widget.allCategoriesList.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 4.0, right: 4),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Categories(
                                                    categoryId: widget
                                                            .allCategoriesList[index]
                                                        ["category_id"],
                                                    allCategoriesList:
                                                        widget.allCategoriesList,
                                                    title: widget
                                                            .allCategoriesList[index]
                                                        ["category_name"],
                                                    allDataList: widget.allDataList,
                                                  )));
                                    },
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: 37,
                                          padding:
                                              EdgeInsets.only(left: 16, right: 24),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: Color(int.parse(
                                                  widget.allCategoriesList[index]
                                                      ['background_color']))),
                                          child: Row(
                                            children: [
                                              CachedNetworkImage(
                                                width: 20,
                                                height: 19,
                                                progressIndicatorBuilder: (context, url, progress) => Center(
                                                  child: CircularProgressIndicator(
                                                    value: progress.progress,
                                                  ),
                                                ),
                                                imageUrl: widget.allCategoriesList[index]
                                                ['icon'],
                                                fit: BoxFit.cover,
                                                alignment: Alignment.center,
                                              ),
                                              SizedBox(
                                                width: width * 0.02,
                                              ),
                                              Text(
                                                  widget.allCategoriesList[index]
                                                      ['category_name'],
                                                  style: homeTextTheme().subtitle1),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 37,
                                          padding:
                                              EdgeInsets.only(left: 16, right: 24),
                                          decoration: widget.categoryId ==
                                                      widget.allCategoriesList[index]
                                                          ["category_id"] ||
                                                  widget.categoryId == 1
                                              ? BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Colors.transparent)
                                              : BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Colors.white54),
                                          child: Row(
                                            children: [
                                              CachedNetworkImage(
                                                width: 20,
                                                height: 19,
                                                progressIndicatorBuilder: (context, url, progress) => Center(
                                                  child: CircularProgressIndicator(
                                                    value: progress.progress,
                                                  ),
                                                ),
                                                imageUrl: widget.allCategoriesList[index]
                                              ['icon'],
                                                fit: BoxFit.cover,
                                                alignment: Alignment.center,
                                              ),
                                              SizedBox(
                                                width: width * 0.02,
                                              ),
                                              Text(
                                                widget.allCategoriesList[index]
                                                    ['category_name'],
                                                style: TextStyle(
                                                    color: Colors.transparent,
                                                    fontFamily: "Segoe UI",
                                                    fontSize: 12 * scalefactor,
                                                    fontWeight: FontWeight.normal),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Expanded(
                          child: widget.allDataList.isNotEmpty
                              ? Stack(
                            alignment: Alignment.bottomCenter,
                                children: [
                                  Container(
                                      child: GridView.count(
                                        controller: _scrollController,
                                        physics: AlwaysScrollableScrollPhysics(),
                                        // controller: controller,
                                        padding: EdgeInsets.all(16),
                                        // physics: NeverScrollableScrollPhysics(),
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 15,
                                        mainAxisSpacing: 15,
                                        children: [
                                          for (int i = 0; i < updatedList.length; i++)
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            CelebDetails(
                                                              id: updatedList[i]
                                                                  ["celebrity_id"],
                                                            )));
                                              },
                                              child: Stack(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(20.0),
                                                    child: CachedNetworkImage(
                                                      width:
                                                      width * 0.5,
                                                      height: height*0.4,
                                                      progressIndicatorBuilder: (context, url, progress) => Center(
                                                        child: CircularProgressIndicator(
                                                          value: progress.progress,
                                                        ),
                                                      ),
                                                      imageUrl: updatedList[i]["image"],
                                                      fit: BoxFit.cover,
                                                      alignment: Alignment.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                            updatedList[i]
                                                            ["celebrity_name"],
                                                            style: textTheme().subtitle2),
                                                        Text(updatedList[i]["category"],
                                                            style:
                                                            homeTextTheme().subtitle1),
                                                        SizedBox(
                                                          height: 10,
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  isLoadingMore
                                      ? Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
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
                              : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Text("No Celebrity for now..."),
                              ),
                            ],
                          ),
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


  // _getMoreVideos() async {
  //   print("In get more video method");
  //   print(updatedList.length);
  //   int index = updatedList.length - 1;
  //   print(index);
  //   print(updatedList[index]["celebrity_id"]);
  //   Handler handler = Handler(
  //       'unauthorized/home/loadmorecelebrity?type=all&celebrity_id=${updatedList[index]["celebrity_id"]}');
  //
  //   String url1 = handler.getUrl();
  //
  //   var url = Uri.parse(url1);
  //   var response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     var jsonBody = jsonDecode(response.body);
  //     if (jsonBody["success"] == true) {
  //       setStateIfMounted(() {
  //         Map myMap = jsonBody;
  //         List dummyData = myMap["data"];
  //         for (int i = 0; i < dummyData.length; i++) {
  //           listOfData.add(dummyData[i]);
  //           setStateIfMounted(() {});
  //         }
  //       });
  //       _update(updatedList.length);
  //     } else if (jsonBody["success"] == false) {
  //       print("else if condition");
  //       setStateIfMounted(() {
  //         isMoreData = true;
  //       });
  //     }
  //   } else {
  //     print(response.body);
  //     print("Request failed to response :${response.statusCode}");
  //   }
  // }

  Future<bool> onWillPop() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => BottomBar(
                  currentIndex: 0,
                  categoryId: 1,
                  categoryName: "All",
                )));
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
