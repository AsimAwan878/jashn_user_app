import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jashn_user/styles/colors.dart';
import 'package:jashn_user/styles/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../styles/api_handler.dart';
import '../../bottom_bar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:developer' as developer;
import 'dart:async';
import 'package:flutter/services.dart';

class JashnWallet extends StatefulWidget {

  final String name;

  const JashnWallet({Key? key, required this.name}) : super(key: key);
  @override
  JashnWalletState createState() => JashnWalletState();
}

class JashnWalletState extends State<JashnWallet> {
  bool isInitializing = false;
  bool isInitializingBalance = false;
  bool isDelaying = false;
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
      _getAllTransaction().whenComplete(() {
        setStateIfMounted(() {
          isInitializing = false;
        });
      });
      _getBalance().whenComplete(() {
        setStateIfMounted(() {
          isInitializingBalance = false;
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

  Map mapResponse = {};

  var customerId;
  var token;
  List myList = [];
  var balance;

  Future _getAllTransaction() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    customerId = _prefs.getString("customer_id");
    token = _prefs.getString("token");

    Handler handler = Handler('user/wallet?customer_id=$customerId');
    String url1 = handler.getUrl();

    print(customerId.toString());
    print(token.toString());

    print("Click on fetch data");

    var response = await http.get(Uri.parse(url1),
        headers: ({
          "Authorization": "Bearer ${token.toString()}",
        }));

    if (response.statusCode == 200) {
      var jsonBody=jsonDecode(response.body);
      if(jsonBody["success"] ==true)
      {
        setState(() {
          mapResponse = jsonDecode(response.body);
          myList = mapResponse["data"];
          // listOfData = mapResponse["data"];
          print("Lenngth is:${myList.length}");
        });
      }
      else if(jsonBody["success"] ==false){

      }

    } else {
      print(response.body);
      print("Request failed to response :${response.statusCode}");
    }
  }

  Future _getBalance() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    customerId = _prefs.getString("customer_id");
    token = _prefs.getString("token");

    Handler handler = Handler('user/mybalance?customer_id=$customerId');
    String url1 = handler.getUrl();

    print("Click on fetch data");

    var response = await http.get(Uri.parse(url1),
        headers: ({
          "Authorization": "Bearer ${token.toString()}",
        }));

    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      if (jsonBody["success"] == true) {
        setStateIfMounted(() {
          Map data = jsonBody["data"];
          balance = data["balance"];
        });
      } else if (jsonBody["success"] == false) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(jsonBody["message"])));
      }
    } else {
      print(response.body);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Server Error!")));
    }
  }

  Widget _widget() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double scalefactor = MediaQuery.of(context).textScaleFactor;

    return SafeArea(
      child: Scaffold(
        body: WillPopScope(
          onWillPop: onWillPop,
          child: Visibility(
            visible: isDelaying,
            replacement: Scaffold(
              body: Center(
                child: CupertinoActivityIndicator(
                  color: Constants.textColour6,
                  radius: 20.0,
                ),
              ),
            ),
            child: Container(
              width: width,
              height: height,
              color:
                  myList.isEmpty ? Constants.textColour4 : Constants.textColour1,
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Container(
                  width: width,
                  height: 270,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Constants.buttonColourMix2,
                          Constants.buttonColourMix3,
                          Constants.buttonColourMix4,
                          Constants.buttonColourMix1,
                        ],
                        begin: const FractionalOffset(0.2, 0.0),
                        // end: const FractionalOffset(0.0, 1.0),
                      ),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => BottomBar(
                                              currentIndex: 3,
                                              categoryId: 1,
                                              categoryName: "All")));
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
                          ],
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 28.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Image.asset(
                                "assets/logo.png",
                                height: 46,
                                width: 174,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Wallet", style: homeTextTheme().bodyText1),
                        SizedBox(
                          height: 20,
                        ),
                        isInitializingBalance
                            ? Text(
                                "Loading..",
                                style: TextStyle(
                                    color: Constants.textColour1,
                                    fontFamily: "Segoe UI",
                                    fontSize: 20 * scalefactor,
                                    fontWeight: FontWeight.w600),
                              )
                            : Text(
                                balance != null?"PKR ${balance.toString()}": "PKR 0",
                                style: TextStyle(
                                    color: Constants.textColour1,
                                    fontFamily: "Segoe UI",
                                    fontSize: 20 * scalefactor,
                                    fontWeight: FontWeight.w600),
                              ),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Total Amount", style: textTheme().bodyText2),
                      ],
                    ),
                  ),
                ),
                isInitializing
                    ? Expanded(
                        child: Center(
                            child: CupertinoActivityIndicator(
                        color: Constants.textColour6,
                        radius: 20.0,
                      )))
                    : myList.isNotEmpty
                        ? Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: height * 0.06,
                                  ),
                                  Center(
                                    child: Text(
                                      "Recent Transactions",
                                      style: homeTextTheme().subtitle2,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.06,
                                  ),
                                  ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: myList.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () async {
                                            await showDialog(
                                                context: context,
                                                builder: (_) => ImageDialog(
                                                      date: myList[index]
                                                          ["paid_date"],
                                                      amount: myList[index]
                                                          ["amount"],
                                                      name: myList[index]
                                                          ["celebrity"],
                                                      id: myList[index]
                                                          ["transactionId"],
                                                  myName: widget.name,

                                                    ));
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12.0, horizontal: 28),
                                            child: Container(
                                              width: width / 1.25,
                                              height: 170,
                                              decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.3),
                                                      spreadRadius: 1,
                                                      blurRadius: 30,
                                                      offset: Offset(0,
                                                          3), // changes position of shadow
                                                    ),
                                                  ],
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(25)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 28.0,
                                                        horizontal: 18.0),
                                                child: Column(
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "PKR",
                                                          style: TextStyle(
                                                              color: Constants
                                                                  .buttonColourMix1,
                                                              fontFamily:
                                                                  "Segoe UI",
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              fontSize: 26 *
                                                                  scalefactor),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        Text(
                                                          "${myList[index]["amount"]}",
                                                          style: TextStyle(
                                                              color: Constants
                                                                  .buttonColourMix1,
                                                              fontFamily:
                                                                  "Segoe UI",
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              fontSize: 26 *
                                                                  scalefactor),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Celebrity : ${myList[index]["celebrity"]}",
                                                          style: TextStyle(
                                                              color: Colors.grey,
                                                              fontFamily:
                                                                  "Segoe UI",
                                                              fontSize: 14 *
                                                                  scalefactor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 3,
                                                        ),
                                                        Text(
                                                          myList[index]
                                                              ["paid_date"],
                                                          style: TextStyle(
                                                              color: Colors.grey,
                                                              fontFamily:
                                                                  "Segoe UI",
                                                              fontSize: 14 *
                                                                  scalefactor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ],
                              ),
                            ),
                          )
                        : Expanded(
                            child: Center(
                            child: Text(
                              "No Transactions",
                              style: homeTextTheme().bodyText1,
                              textAlign: TextAlign.center,
                            ),
                          )),

                // Expanded(
                //   flex: 2,
                //   child: SingleChildScrollView(
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.stretch,
                //       children: [
                //         myList.isEmpty
                //             ? Container(
                //             decoration: BoxDecoration(
                //                 boxShadow: [
                //                   BoxShadow(
                //                     color: Colors.grey.withOpacity(0.5),
                //                     spreadRadius: 1,
                //                     blurRadius: 30,
                //                     offset:
                //                     Offset(0, 3), // changes position of shadow
                //                   ),
                //                 ],
                //                 color: Colors.white,
                //                 borderRadius: BorderRadius.circular(15)),
                //             child: Padding(
                //               padding: const EdgeInsets.all(8.0),
                //               child: Column(
                //                 children: [
                //                   Row(
                //                     children: [
                //                       SizedBox(
                //                         width: 10,
                //                       ),
                //                       Text(
                //                         "No Recent Transactions",
                //                         style: TextStyle(
                //                             color: Colors.grey,
                //                             fontFamily: "Segoe UI",
                //                             fontSize: 12 * scalefactor),
                //                       )
                //                     ],
                //                   ),
                //                   SizedBox(
                //                     height: 30,
                //                   ),
                //                   Text("PKR",
                //                     style: TextStyle(
                //                         fontWeight: FontWeight.bold,
                //                         fontFamily: "Segoe UI",
                //                         color: Colors.black,
                //                         fontSize: 28 * scalefactor),),
                //                   SizedBox(
                //                     height: 10,
                //                   ),
                //                   Text(
                //                     "No recent transactions",
                //                     style: TextStyle(
                //                         color: Colors.grey,
                //                         fontFamily: "Segoe UI",
                //                         fontSize: 12 * scalefactor,
                //                         fontWeight: FontWeight.bold),
                //                   ),
                //                   SizedBox(
                //                     height: 10,
                //                   ),
                //                   Padding(
                //                     padding:
                //                     const EdgeInsets.only(left: 24.0, right: 24),
                //                     child: Text(
                //                       "When You will done a shoutout payment, it will show up here",
                //                       textAlign: TextAlign.center,
                //                       style: TextStyle(
                //                         color: Colors.grey,
                //                         fontFamily: "Segoe UI",
                //                         fontSize: 10 * scalefactor,
                //                       ),
                //                     ),
                //                   ),
                //                   SizedBox(
                //                     height: 30,
                //                   ),
                //                 ],
                //               ),
                //             ))
                //             : Column(
                //               children: [
                //                 Container(
                //                   height: height,
                //                   color: Constants.textColour1,
                //                   child: ListView.builder(
                //                       physics: ClampingScrollPhysics(),
                //                   itemCount: myList.length,
                //                   shrinkWrap: true,
                //                   itemBuilder: (context, index) {
                //                     return Padding(
                //                       padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 28),
                //                       child: Container(
                //                           width: width / 1.25,
                //                           height: 170,
                //                           decoration: BoxDecoration(
                //                               boxShadow: [
                //                                 BoxShadow(
                //                                   color: Colors.grey.withOpacity(0.2),
                //                                   spreadRadius: 1,
                //                                   blurRadius: 30,
                //                                   offset:
                //                                   Offset(0, 3), // changes position of shadow
                //                                 ),
                //                               ],
                //                               color: Colors.white,
                //                               borderRadius: BorderRadius.circular(15)),
                //                           child: Padding(
                //                             padding: const EdgeInsets.all(8.0),
                //                             child: Column(
                //                               children: [
                //                                 SizedBox(
                //                                   height: 30,
                //                                 ),
                //                                 Row(
                //                                   mainAxisAlignment: MainAxisAlignment.center,
                //                                   children: [
                //                                     SizedBox(
                //                                       width: 10,
                //                                     ),
                //                                     Text(
                //                                       "PKR. ${myList[index]["amount"]}",
                //                                       style: TextStyle(
                //                                           color: Colors.red,
                //                                           fontFamily: "Segoe UI",
                //                                           fontSize: 32 * scalefactor),
                //                                       overflow: TextOverflow.ellipsis,
                //                                     )
                //                                   ],
                //                                 ),
                //                                 SizedBox(
                //                                   height: 10,
                //                                 ),
                //                                 Padding(
                //                                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                //                                   child: Row(
                //                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //                                     children: [
                //                                       Container(
                //                                         width: MediaQuery.of(context).size.width *0.4,
                //                                         child: Column(
                //                                           children: [
                //                                             Text(
                //                                               "Celebrity : ${myList[index]["celebrity"]}",
                //                                               style: TextStyle(
                //                                                   color: Colors.grey,
                //                                                   fontFamily: "Segoe UI",
                //                                                   fontSize: 12 * scalefactor,
                //                                                   fontWeight: FontWeight.bold),
                //                                               overflow: TextOverflow.ellipsis,
                //                                               maxLines: 3,
                //                                             ),
                //                                           ],
                //                                         ),
                //                                       ),
                //                                       Text(
                //                                         myList[index]["paid_date"],
                //                                         style: TextStyle(
                //                                             color: Colors.grey,
                //                                             fontFamily: "Segoe UI",
                //                                             fontSize: 12 * scalefactor,
                //                                             fontWeight: FontWeight.bold),
                //                                       ),
                //                                     ],
                //                                   ),
                //                                 ),
                //                                 SizedBox(
                //                                   height: 30,
                //                                 ),
                //                               ],
                //                             ),
                //                           )),
                //                     );
                //                   }),
                //                 ),
                //               ],
                //             )
                //
                //       ],
                //     ),
                //   ),
                // )
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> onWillPop() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => BottomBar(
                currentIndex: 3, categoryId: 1, categoryName: "All")));
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
    super.dispose();
  }
}

class ImageDialog extends StatefulWidget {
  final String name;
  final String amount;
  final String date;
  final String id;
  final String myName;


  const ImageDialog(
      {Key? key,
      required this.name,
      required this.amount,
      required this.date,
      required this.id,required this.myName,
      })
      : super(key: key);

  @override
  State<ImageDialog> createState() => _ImageDialogState();
}

class _ImageDialogState extends State<ImageDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: 550,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.red,
                        child: Icon(
                          Icons.clear,
                          color: Constants.textColour1,
                          size: 15,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Icon(
                  Icons.check_circle_sharp,
                  color: Colors.green,
                  size: 50,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Your payment\nhas been processed",
                  style: homeTextTheme().bodyText2,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Amount Sent",
                  style: homeTextTheme().button,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "PKR ${widget.amount}",
                  style: homeTextTheme().bodyText2,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.date,
                  style: homeTextTheme().button,
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Paid To",
                  style: homeTextTheme().button,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.name,
                  style: homeTextTheme().bodyText2,
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Paid From",
                  style: homeTextTheme().button,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.myName,
                  style: homeTextTheme().bodyText2,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.id,
                  style: homeTextTheme().button,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
