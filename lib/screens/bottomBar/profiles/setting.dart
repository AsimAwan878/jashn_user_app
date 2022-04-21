import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jashn_user/provider_class.dart';
import 'package:jashn_user/screens/bottomBar/profiles/privacy_policy.dart';
import 'package:jashn_user/screens/bottomBar/profiles/terms_of_use.dart';
import 'package:jashn_user/screens/landing.dart';
import 'package:jashn_user/styles/colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../styles/api_handler.dart';
import '../../../styles/strings.dart';
import '../bottom_bar.dart';
import 'change_password.dart';

// ignore: must_be_immutable
class Setting extends StatefulWidget {
  var isSocial;

  Setting({Key? key, required this.isSocial}) : super(key: key);

  @override
  SettingState createState() => SettingState();
}

class SettingState extends State<Setting> {
  bool isSwitched = false;
  static Handler handler = Handler('auth/logout');
  static String url1 = handler.getUrl();
  var id;
  var token;

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
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BottomBar(
                                    currentIndex: 3,
                                    categoryId: 1,
                                    categoryName: "All",
                                  )));
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
            "Settings",
            style: homeTextTheme().subtitle2,
          ),
        ),
        body: WillPopScope(
          onWillPop: onWillPop,
          child: Visibility(
            visible: isSwitched == false,
            replacement: Center(
              child: CupertinoActivityIndicator(
                color: Constants.textColour6,
                radius: 20.0,
              ),
            ),
            child: Container(
              width: width,
              height: height,
              color: Constants.textColour1,
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 16.0,right: 16.0),
                  //   child: ListTile(
                  //     leading: Icon(Icons.notifications,color: Colors.grey[800],),
                  //     title:  Text(
                  //       "Jash\'n request updates",
                  //       style: TextStyle(
                  //           fontWeight: FontWeight.w800,
                  //           fontFamily: "Segoe UI",
                  //           color: Colors.black,
                  //           fontSize: 12 * scalefactor),
                  //     ),
                  //     trailing: Switch(
                  //       value: isSwitched,
                  //       onChanged: (value) {
                  //         setState(() {
                  //           isSwitched = value;
                  //           print(isSwitched);
                  //         });
                  //       },
                  //       activeTrackColor: Constants.button_colour_mix4,
                  //       activeColor: Constants.button_colour_mix4,
                  //     ),
                  //
                  //   ),
                  // ),
                  Divider(
                    color: Constants.textColour2,
                    height: 2.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: ListTile(
                      minLeadingWidth: 20,
                      leading: Icon(
                        Icons.lock,
                        color: Colors.grey[800],
                        size: 20,
                      ),
                      title: Stack(
                        children: [
                          Text(
                            "Change password",
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontFamily: "Segoe UI",
                                color: Colors.black,
                                fontSize: 14 * scalefactor),
                            textAlign: TextAlign.start,
                          ),
                          widget.isSocial == "1"
                              ? Container(
                                  width: width,
                                  height: 20,
                                  color: Colors.white54,
                                )
                              : SizedBox(),
                        ],
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.grey[800],
                      ),
                      onTap: () {
                        if (widget.isSocial == "0") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPassword()));
                        }
                      },
                    ),
                  ),
                  Divider(
                    color: Constants.textColour2,
                    height: 2.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TermsOfUse()));
                      },
                      minLeadingWidth: 20,
                      leading: Icon(
                        Icons.description,
                        color: Colors.grey[800],
                        size: 20,
                      ),
                      title: Text(
                        "Terms of use",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontFamily: "Segoe UI",
                            color: Colors.black,
                            fontSize: 14 * scalefactor),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                  Divider(
                    color: Constants.textColour2,
                    height: 2.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PrivacyPolicy()));
                      },
                      minLeadingWidth: 20,
                      leading: Image.asset(
                        "assets/insurance (1).png",
                        width: 20,
                        height: 20,
                      ),
                      title: Text(
                        "Privacy policy",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontFamily: "Segoe UI",
                            color: Colors.black,
                            fontSize: 14 * scalefactor),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                  Divider(
                    color: Constants.textColour2,
                    height: 2.0,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Divider(
                    color: Constants.textColour2,
                    height: 2.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: ListTile(
                      onTap: () {
                        settingModal();
                      },
                      minLeadingWidth: 20,
                      leading: Image.asset(
                        "assets/logout.png",
                        width: 20,
                        height: 20,
                      ),
                      title: Text(
                        "Log Out",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontFamily: "Segoe UI",
                            color: Constants.textColour6,
                            fontSize: 12 * scalefactor),
                      ),
                    ),
                  ),
                  Divider(
                    color: Constants.textColour2,
                    height: 2.0,
                  ),
                ],
              )),
            ),
          ),
        ),
      ),
    );
  }

  Map emailResponse = {};
  bool isSent = false;
  var jsonBody;
  var email;

  Future<bool> onWillPop() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => BottomBar(
                  currentIndex: 3,
                  categoryId: 1,
                  categoryName: "All",
                )));
    return Future.value(true);
  }

  settingModal() {
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
              child: ChangeNotifierProvider(
                create: (context) => MyProvider(),
                child: StreamBuilder(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (context, snapshot) {
                      return Container(
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
                                  "Log out",
                                  style: TextStyle(
                                      color: Constants.textColour3,
                                      fontFamily: "Segoe UI",
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    "Are you sure, You want to log Out?",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Constants.textColour6,
                                      fontFamily: "Segoe UI",
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  child: Container(
                                    constraints: BoxConstraints(
                                        maxWidth: 120, minHeight: 35.0),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                          color: Constants.textColour3,
                                          fontFamily: "Segoe UI",
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                            side: BorderSide(
                                                color: Constants.textColour2,
                                                width: 1.0))),
                                    backgroundColor: MaterialStateProperty.all(
                                        Constants.textColour2),
                                  ),
                                ),
                                ElevatedButton(
                                  child: Container(
                                    constraints: BoxConstraints(
                                        maxWidth: 120, minHeight: 35.0),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Log out",
                                      style: TextStyle(
                                          color: Constants.textColour1,
                                          fontFamily: "Segoe UI",
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                      isSwitched = true;
                                    });
                                    final provider = Provider.of<MyProvider>(
                                        context,
                                        listen: false);
                                    provider.logoutWithGoogle();

                                    Navigator.pop(context);

                                    logout();
                                  },
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                            side: BorderSide(
                                                color: Constants.textColour6,
                                                width: 1.0))),
                                    backgroundColor: MaterialStateProperty.all(
                                        Constants.textColour6),
                                  ),
                                ),
                              ],
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
                      );
                    }),
              ),
            );
          });
        });
  }

  Future<void> logout() async {
    print("Inside logout method");
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    id = _prefs.getString("customer_id");
    token = _prefs.getString("token");
    var response = await http.post(Uri.parse(url1),
        body: ({
          "customer_id": id.toString(),
        }),
        headers: ({"Authorization": "Bearer: ${token.toString()}"}));
    var jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (jsonResponse["status"] == true) {
        _prefs.clear();

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Landing()));
      } else {
        print(response.body);
        setState(() {
          isSwitched = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(jsonResponse["message"])));
      }
    } else {
      setState(() {
        isSwitched = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(jsonResponse["message"])));
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
