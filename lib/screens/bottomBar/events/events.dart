import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:jashn_user/styles/colors.dart';

import 'event-details.dart';

class Events extends StatefulWidget {
  final List listOfEvents;

  const Events({Key? key,required this.listOfEvents}) : super(key: key);

  @override
  EventsState createState() => EventsState();
}

class EventsState extends State<Events> {
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
          title: Text(
            "Events",
            style: TextStyle(
                fontWeight: FontWeight.w800,
                fontFamily: "Segoe UI",
                color: Colors.black,
                fontSize: 18 * scalefactor),
          ),
        ),
        body:
        //WillPopScope(
          // onWillPop: onWillPop,
          //child:
          Container(
            width: width,
            height: height,
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for(int i=0;i<widget.listOfEvents.length;i++)
                    Padding(
                    padding: const EdgeInsets.only(top:12.0,bottom: 12),
                    child: InkWell(
                      onTap:(){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>EventDetails(eventId: widget.listOfEvents[i]["event_id"],)));
                      },
                      child: Container(
                        width: width/1.25,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 30,
                                offset: Offset(0,3), // changes position of shadow
                              ),
                            ],
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.circular(20)),
                        child: Column(
                          children: [
                            Container(
                                width: width/1.25,
                                height: height*0.3,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(widget.listOfEvents[i]["image"]),
                                    fit: BoxFit.contain
                                  )
                                ),
                            ),
                            SizedBox(
                              height: 12
                              ,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  widget.listOfEvents[i]["title"],
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontFamily: "Segoe UI",
                                      color: Colors.black,
                                      fontSize: 12 * scalefactor),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius:
                                      BorderRadius.circular(8)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "REPLAY",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "Segoe UI",
                                          color: Constants.textColour1,
                                          fontSize: 12 * scalefactor),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                RatingBar.builder(
                                  initialRating: 3,
                                  itemSize: 25,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.blue,
                                  ),
                                  onRatingUpdate: (rating) {},
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0,right: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    widget.listOfEvents[i]["date"],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "Segoe UI",
                                        color: Constants.textColour3,
                                        fontSize: 12 * scalefactor),
                                  ),
                                  Image.asset("assets/down.png"),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        //),
      ),
    );
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
}
