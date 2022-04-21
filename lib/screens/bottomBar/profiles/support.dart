import 'package:flutter/material.dart';

class Support extends StatefulWidget {
  @override
  SupportState createState() => SupportState();
}

class SupportState extends State<Support> {

  Widget _widget() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double scalefactor = MediaQuery.of(context).textScaleFactor;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: InkWell(onTap:(){
            // Navigator.pushReplacement(context,
            //     MaterialPageRoute(builder: (context) => Help()));
          },child: Icon(Icons.arrow_back)),
          title: Text(
            "Support",
            style: TextStyle(
                fontFamily: "Segoe UI",
                color: Colors.white,
                fontSize: 16 * scalefactor),
          ),
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.search,
                    size: 26.0,
                  ),
                )
            ),
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Icon(
                      Icons.menu
                  ),
                )
            ),
          ],
        ),
        body: Container(
          width: width,
          height: height,
          color: Colors.white,
          child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                child: Column(
                  children: [
                    ExpansionTile(
                      collapsedBackgroundColor: Colors.white,
                      collapsedIconColor: Colors.black,
                      iconColor: Colors.black,
                      textColor: Colors.black,
                      collapsedTextColor: Colors.black,
                      backgroundColor: Colors.white,
                      title: Text(
                        "Users",
                        style: TextStyle(
                            fontFamily: "Segoe UI",
                            color: Colors.black,
                            fontSize: 14 * scalefactor),
                      ),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0,right: 16),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "FAQ",
                                    style: TextStyle(
                                        fontFamily: "Segoe UI",
                                        color: Colors.black,
                                        fontSize: 14 * scalefactor),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "How to watch jashn Events on your TV?",
                                      style: TextStyle(
                                          fontFamily: "Segoe UI",
                                          color: Colors.black,
                                          fontSize: 14 * scalefactor),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "IOS Purchase Refund",
                                      style: TextStyle(
                                          fontFamily: "Segoe UI",
                                          color: Colors.black,
                                          fontSize: 14 * scalefactor),
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          )
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
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
