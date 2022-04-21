import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jashn_user/models/search.dart';
import 'package:jashn_user/screens/bottomBar/profiles/profiles.dart';
import 'package:jashn_user/screens/bottomBar/shoutout.dart';
import 'package:jashn_user/styles/colors.dart';
import 'package:jashn_user/styles/strings.dart';
import '../../styles/api_handler.dart';
import 'bottom_bar.dart';
import 'categories/categories.dart';
import 'categories/celeb_details.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:developer' as developer;
import 'dart:async';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  var categoryId;
  var categoryName;

  HomeScreen({Key? key, required this.categoryId, required this.categoryName})
      : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List celebrities = [];
  String query = '';

  TextEditingController typeAheadController = TextEditingController();

  bool isDelaying = false;
  bool isDataLoading = false;
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
    print(updatedList.length);

    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    Future.delayed(const Duration(seconds: 5), () {
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

  // void searchCelebrity(){
  //   final celebrities=widget.allCelebrity.where((celebrity) {
  //
  //     final titleLower =celebrity.title.toLowerCase();
  //     final searchLower =query.toLowerCase();
  //
  //     return titleLower.contains(searchLower);
  //
  //   }).toList();
  //
  //   setState(() {
  //     this.query=query;
  //     this.celebrities=celebrities;
  //   });
  // }
  //
  // searchCelebrity(String text) async{
  //   _searchResult.clear();
  //   if (text.isEmpty) {
  //     setState(() {});
  //     return;
  //   }
  //
  //   _userDetails.forEach((userDetail) {
  //     if (userDetail.firstName.contains(text) || userDetail.lastName.contains(text))
  //       _searchResult.add(userDetail);
  //   });
  //
  //   setState(() {});
  // }

  Widget _widget() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double scalefactor = MediaQuery.of(context).textScaleFactor;

    return SafeArea(
      child: Scaffold(
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
              visible: isDataLoading,
              replacement: loadingCard(width, height),
              child: Container(
                width: width,
                height: height,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 25.0, right: 25, top: 32),
                            child: Material(
                              elevation: 4,
                              borderRadius: BorderRadius.circular(32),
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(32)),
                                  child: TypeAheadField<User?>(
                                    hideSuggestionsOnKeyboardHide: true,
                                    debounceDuration:
                                        Duration(milliseconds: 500),
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
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
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none),
                                    ),
                                    suggestionsCallback: (pattern) async {
                                      return await UserApi.getUserSuggestions(
                                          pattern);
                                    },
                                    itemBuilder: (context, User? suggestion) {
                                      final user = suggestion!;
                                      return ListTile(
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          user.image),
                                                      fit: BoxFit.cover)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    user.name,
                                                    style: TextStyle(
                                                        color: Constants
                                                            .textColour3,
                                                        fontFamily: "Segoe UI",
                                                        fontSize:
                                                            14 * scalefactor),
                                                  ),
                                                  Text(
                                                    user.category,
                                                    style: TextStyle(
                                                        color: Constants
                                                            .textColour4,
                                                        fontFamily: "Segoe UI",
                                                        fontSize:
                                                            14 * scalefactor),
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
                                              color: Colors.black,
                                              fontSize: 12),
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
                          SizedBox(
                            height: height * 0.03,
                          ),
                          SizedBox(
                            height: height * 0.29,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Center(
                                  child: Material(
                                    elevation: 4,
                                    borderRadius: BorderRadius.circular(32),
                                    child: Container(
                                      width: width,
                                      height: height * 0.4,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(32)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 32,vertical: 12.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            listOfData.isNotEmpty
                                                ? AutoSizeText(
                                                    'Featured',
                                                    style: textTheme().button,
                                                    minFontSize: 12,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  )
                                                : SizedBox(),
                                            listOfData.isNotEmpty
                                                ? AutoSizeText(
                                                    'Choose your favorite celebrity from the Featured List.',
                                                    style: TextStyle(
                                                        color: Constants
                                                            .textColour3,
                                                        fontFamily:
                                                            "Segoe UI",
                                                        fontSize:
                                                            12 * scalefactor,
                                                        fontWeight: FontWeight
                                                            .normal),
                                                    maxLines: 1,
                                                    minFontSize: 8,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  )
                                                : SizedBox(),
                                            Spacer(),
                                            listOfData.isNotEmpty
                                                ? GestureDetector(
                                                    onTap: () {
                                                      Navigator
                                                          .pushReplacement(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          Categories(
                                                                            categoryId: 1,
                                                                            allCategoriesList: listCategoryData,
                                                                            title: "All",
                                                                            allDataList: listOfData,
                                                                          )));
                                                    },
                                                    child: Row(
                                                      children: [
                                                        AutoSizeText(
                                                          'See all Celebrities',
                                                          style: TextStyle(
                                                              color: Constants
                                                                  .textColour6,
                                                              fontFamily:
                                                                  "Segoe UI",
                                                              fontSize: 12 *
                                                                  scalefactor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                        ),
                                                        SizedBox(
                                                          width: 12,
                                                        ),
                                                        Icon(
                                                          FontAwesomeIcons
                                                              .rightLong,
                                                          color: Constants
                                                              .textColour6,
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                : SizedBox()
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 12),
                                  height: height * 0.18,
                                  child: listOfData.isEmpty
                                      ? Column(
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
                                                      color:
                                                          Constants.textColour4,
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      'No Featured Celebrity',
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontFamily:
                                                              "Segoe UI",
                                                          fontSize:
                                                              20 * scalefactor),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: listOfFeatured.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: listOfFeatured[index]
                                                        .isEmpty
                                                    ? Center(
                                                        child:
                                                            CircularProgressIndicator())
                                                    : GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      CelebDetails(
                                                                          id: listOfFeatured[index]
                                                                              [
                                                                              "celebrity_id"])));
                                                        },
                                                        child: Stack(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius: BorderRadius.circular(20.0),
                                                              child: CachedNetworkImage(
                                                                width:
                                                                width * 0.3,
                                                                height: height*0.18,
                                                                progressIndicatorBuilder: (context, url, progress) => Center(
                                                                  child: CircularProgressIndicator(
                                                                    value: progress.progress,
                                                                  ),
                                                                ),
                                                                imageUrl: listOfFeatured[index]
                                                                ['image'],
                                                                fit: BoxFit.cover,
                                                                alignment: Alignment.center,
                                                              ),
                                                            ),
                                                            // Container(
                                                            //   width:
                                                            //       width * 0.3,
                                                            //   decoration: BoxDecoration(
                                                            //       image: DecorationImage(
                                                            //           image: NetworkImage(
                                                            //             listOfFeatured[index]
                                                            //                 ['image'],
                                                            //           ),
                                                            //           fit: BoxFit.cover),
                                                            //       borderRadius: BorderRadius.circular(20.0)),
                                                            //   // child: Image.network(
                                                            //   //     widget.list[index]['image']),
                                                            // ),
                                                            Container(
                                                              width:
                                                                  width * 0.3,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          8),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .black26,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20.0),
                                                              ),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Flexible(
                                                                    child: Text(
                                                                        listOfFeatured[index]
                                                                            ["celebrity_name"],
                                                                        style: textTheme()
                                                                            .subtitle2),
                                                                  ),
                                                                  Text(
                                                                      listOfFeatured[
                                                                              index]
                                                                          [
                                                                          "label"],
                                                                      style: homeTextTheme()
                                                                          .subtitle1),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                              ),
                                            );
                                          }),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          listCategoryData.isEmpty
                              ? SizedBox()
                              : Padding(
                                  padding: const EdgeInsets.only(left: 32.0),
                                  child: AutoSizeText(
                                    'Categories',
                                    style: textTheme().button,
                                    minFontSize: 12,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 24.0,right: 24.0),
                            child: Container(
                              height: 40,
                              child: listCategoryData.isEmpty
                                  ? SizedBox()
                                  : ListView.builder(
                                      itemCount:
                                          listCategoryData.length.clamp(0, 4),
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              left: 4.0, right: 4),
                                          child: InkWell(
                                            onTap: () {
                                              index != 3
                                                  ? Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder:
                                                              (context) =>
                                                                  BottomBar(
                                                                    currentIndex:
                                                                        0,
                                                                    categoryId:
                                                                        listCategoryData[index]
                                                                            [
                                                                            "category_id"],
                                                                    categoryName:
                                                                        listCategoryData[index]
                                                                            [
                                                                            "category_name"],
                                                                  )))
                                                  : Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Categories(
                                                                categoryId: 1,
                                                                allCategoriesList:
                                                                    listCategoryData,
                                                                title: "All",
                                                                allDataList:
                                                                    listOfData,
                                                              )));
                                            },
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Container(
                                                  height: 37,
                                                  padding: EdgeInsets.only(
                                                      left: 16, right: 24),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: Color(int.parse(
                                                        listCategoryData[index][
                                                            'background_color'])),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      index != 3
                                                          ? Image.network(
                                                              listCategoryData[
                                                                      index]
                                                                  ['icon'],
                                                              width: 20,
                                                              height: 19,
                                                            )
                                                          : SizedBox(),
                                                      SizedBox(
                                                        width: width * 0.02,
                                                      ),
                                                      Text(
                                                          index != 3
                                                              ? listCategoryData[
                                                                      index][
                                                                  'category_name']
                                                              : "See All",
                                                          style: homeTextTheme()
                                                              .subtitle1)
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  height: 37,
                                                  padding: EdgeInsets.only(
                                                      left: 16, right: 24),
                                                  decoration: widget
                                                                  .categoryId ==
                                                              listCategoryData[
                                                                      index][
                                                                  "category_id"] ||
                                                          widget.categoryId == 1
                                                      ? BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          color: Colors
                                                              .transparent)
                                                      : BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          color:
                                                              Colors.white54),
                                                  child: Row(
                                                    children: [
                                                      index != 3
                                                          ? CachedNetworkImage(
                                                        width: 20,
                                                        height: 19,
                                                        progressIndicatorBuilder: (context, url, progress) => Center(
                                                          child: CircularProgressIndicator(
                                                            value: progress.progress,
                                                          ),
                                                        ),
                                                        imageUrl: listCategoryData[
                                                        index]
                                                        ['icon'],
                                                        fit: BoxFit.cover,
                                                        alignment: Alignment.center,
                                                      )
                                                          : SizedBox(),
                                                      SizedBox(
                                                        width: width * 0.02,
                                                      ),
                                                      Text(
                                                        index != 3
                                                            ? listCategoryData[
                                                                    index][
                                                                'category_name']
                                                            : "See All",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .transparent,
                                                            fontFamily:
                                                                "Segoe UI",
                                                            fontSize: 12 *
                                                                scalefactor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          updatedList.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Discover',
                                        style: textTheme().button,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Spacer(),
                                      widget.categoryId != 1
                                          ? GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Categories(
                                                              categoryId: widget
                                                                  .categoryId,
                                                              allCategoriesList:
                                                                  listCategoryData,
                                                              title: widget
                                                                  .categoryName,
                                                              allDataList:
                                                                  updatedList,
                                                            )));
                                              },
                                              child: Text(
                                                "See all",
                                                style: TextStyle(
                                                    color:
                                                        Constants.textColour6,
                                                    fontFamily: "Segoe UI",
                                                    fontSize: 12 * scalefactor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )
                                          : SizedBox(),
                                    ],
                                  ),
                                )
                              : SizedBox(),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 32.0, right: 32),
                            child: Container(
                              child: updatedList.isEmpty
                                  ? Column(
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
                                                      fontSize:
                                                          30 * scalefactor),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  'No Celebrity Found',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontFamily: "Segoe UI",
                                                      fontSize:
                                                          20 * scalefactor),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : GridView.count(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      children: [
                                        for (int i = 0;
                                            i < updatedList.length;
                                            i++)
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ShoutOut(
                                                            id: updatedList[i][
                                                                "celebrity_id"],
                                                            name: updatedList[i]
                                                                [
                                                                "celebrity_name"],
                                                          )));
                                            },
                                            child: Stack(
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(20.0),
                                                  child: CachedNetworkImage(
                                                    width:
                                                    width * 0.4,
                                                    height: height*0.2,
                                                    progressIndicatorBuilder: (context, url, progress) => Center(
                                                      child: CircularProgressIndicator(
                                                        value: progress.progress,
                                                      ),
                                                    ),
                                                    imageUrl: updatedList[i]['image'],
                                                    fit: BoxFit.cover,
                                                    alignment: Alignment.center,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                            updatedList[i]
                                                            ["celebrity_name"],
                                                            style: textTheme()
                                                                .subtitle2),
                                                      ),
                                                      Text(
                                                          updatedList[i]["label"],
                                                          style: homeTextTheme()
                                                              .subtitle1),
                                                      SizedBox(
                                                        height: 10,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                      ],
                                    ),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.1,
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
      width: width,
      height: height,
      color: Constants.textColour1,
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Skeleton(
                height: 40,
                width: width,
                decoration: BorderRadius.all(Radius.circular(40))),
          ),
          Container(
            width: width,
            height: height * 0.3,
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.02,
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Center(
                      child: Container(
                        width: width,
                        height: height * 0.25,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                spreadRadius: 5,
                                blurRadius: 5,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                            color: Constants.textColour1,
                            borderRadius: BorderRadius.circular(32)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 22.0, vertical: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Skeleton(
                                  height: 50,
                                  width: width * 0.2,
                                  decoration:
                                      BorderRadius.all(Radius.circular(2.0))),
                              Spacer(),
                              Row(
                                children: [
                                  Skeleton(
                                      height: 20,
                                      width: width * 0.3,
                                      decoration: BorderRadius.all(
                                          Radius.circular(2.0))),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Icon(
                                    FontAwesomeIcons.rightLong,
                                    color: Constants.textColour2,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                            width: width,
                            height: height * 0.15,
                            decoration: BoxDecoration(
                              color: Constants.textColour1,
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Skeleton(
                                      width: width * 0.2,
                                      height: height * 0.12,
                                      decoration: BorderRadius.all(
                                          Radius.circular(25.0))),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Skeleton(
                                      width: width * 0.2,
                                      height: height * 0.12,
                                      decoration: BorderRadius.all(
                                          Radius.circular(25.0))),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Skeleton(
                                      width: width * 0.2,
                                      height: height * 0.12,
                                      decoration: BorderRadius.all(
                                          Radius.circular(25.0))),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Skeleton(
                                      width: width * 0.2,
                                      height: height * 0.12,
                                      decoration: BorderRadius.all(
                                          Radius.circular(25.0))),
                                ],
                              ),
                            )),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.02,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Skeleton(
                              width: width * 0.4,
                              height: height / 4.5,
                              decoration: BorderRadius.circular(10.0)),
                          Skeleton(
                              width: width * 0.4,
                              height: height / 4.5,
                              decoration: BorderRadius.circular(10.0)),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Skeleton(
                              width: width * 0.4,
                              height: height / 4.5,
                              decoration: BorderRadius.circular(10.0)),
                          Skeleton(
                              width: width * 0.4,
                              height: height / 4.5,
                              decoration: BorderRadius.circular(10.0)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Map mapResponse = {};
  List<dynamic> listOfData = [];
  Map mapCategoryResponse = {};
  List<dynamic> listCategoryData = [];
  Map eventMap = {};
  List<dynamic> listOfEvents = [];
  Map featuredMap = {};
  List<dynamic> listOfFeatured = [];
  Map mapAll = {};
  List<dynamic> allCelebrity = [];
  List dummyData = [];

  Future _fetchData() async {
    Handler handler = Handler('unauthorized/home/celebrity?type=new');
    String url1 = handler.getUrl();

    Handler handler2 = Handler('unauthorized/home/category');
    String url2 = handler2.getUrl();

    Handler handler3 = Handler('unauthorized/home/celebrity?type=featured');
    String url3 = handler3.getUrl();

    Handler handler4 = Handler('unauthorized/home/celebrity?type=all');
    String url4 = handler4.getUrl();

    print("Click on fetch data");
    var url = Uri.parse(url1);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      print("Response coming :${response.statusCode}");
      setStateIfMounted(() {
        mapResponse = jsonDecode(response.body);
        dummyData = mapResponse["data"];
        listOfData = List.generate(_currentMax, (index) => dummyData[index]);
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
        print("Lenngth is:${listOfData.length}");
      });
    } else {
      print("Request failed to response :${response.statusCode}");
    }

    var secondUrl = Uri.parse(url2);
    var categoryResponse = await http.get(secondUrl);
    if (categoryResponse.statusCode == 200) {
      print("Category Response also coming");
      setStateIfMounted(() {
        mapCategoryResponse = jsonDecode(categoryResponse.body);
        listCategoryData = mapCategoryResponse["data"];
      });
    } else {
      print("Request failed for Category response :${response.statusCode}");
    }

    var thirdUrl = Uri.parse(url3);
    var thirdResponse = await http.get(thirdUrl);
    if (thirdResponse.statusCode == 200) {
      print("Response coming :${thirdResponse.statusCode}");
      setStateIfMounted(() {
        featuredMap = jsonDecode(thirdResponse.body);
        listOfFeatured = featuredMap["data"];
        print("Lenngth is:${listOfFeatured.length}");
      });
    } else {
      print("Request failed to response :${thirdResponse.statusCode}");
    }

    var fourthUrl = Uri.parse(url4);
    var fourthResponse = await http.get(fourthUrl);
    if (fourthResponse.statusCode == 200) {
      print("Response coming :${fourthResponse.statusCode}");
      setStateIfMounted(() {
        mapAll = jsonDecode(thirdResponse.body);
        allCelebrity = mapAll["data"];
        print("Lenngth is:${listOfFeatured.length}");
        _update();
      });
    } else {
      print("Request failed to response :${fourthResponse.statusCode}");
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

  final List updatedList = [];

  int j = 0;

  _update() {
    print("1Length= ${updatedList.length}");
    print("1stLength= ${listOfData.length}");
    for (int i = 0; i < listOfData.length; i++) {
      if (widget.categoryId.toString() == listOfData[i]["category_id"]) {
        updatedList.insert(j, listOfData[i]);
        j++;

        print("2Length= ${updatedList.length}");
      } else if (widget.categoryId.toString() == '1') {
        print("else if condition called");
        updatedList.insert(i, listOfData[i]);
        print("2Length= ${updatedList.length}");
      } else {
        print("else condition called");
      }
    }
    print("4Length= ${updatedList.length}");
    print(widget.categoryId);
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
