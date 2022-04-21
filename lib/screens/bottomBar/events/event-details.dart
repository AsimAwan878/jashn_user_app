import 'dart:convert';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:jashn_user/styles/colors.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class EventDetails extends StatefulWidget {
   var eventId;

   EventDetails({Key? key,required this.eventId}) : super(key: key);
  @override
  EventDetailsState createState() => EventDetailsState();
}

class EventDetailsState extends State<EventDetails> {
  String countryCode = "+1";

  void _onCountryChange(CountryCode code) {
    setState(() {
      countryCode = code.toString();
    });
    print(countryCode);
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
            "Event Details",
            style: TextStyle(
                fontWeight: FontWeight.w800,
                fontFamily: "Segoe UI",
                color: Colors.black,
                fontSize: 18 * scalefactor),
          ),
          actions: [
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
                      child: Image.asset("assets/down.png")),
                ),
              ),
            ),
          ],
        ),
        body: Container(
          width: width,
          height: height,
          color: Colors.white,
          child: Column(
            children: [
              myList.isEmpty? Center(child: CircularProgressIndicator(),)
                  :Expanded(
                child:ListView(
                  children: [
                    Column(
                      children: [
                        Container(
                          height: height*0.2,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              myList[0]["image"]
                            ),
                            fit: BoxFit.contain,
                          )
                        ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: width / 1.12,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 30,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    myList[0]["title"],
                                    style: TextStyle(
                                        fontFamily: "Segoe UI",
                                        color: Colors.black,
                                        fontSize: 12 * scalefactor),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "LIVE",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Segoe UI",
                                            color: Constants.textColour1,
                                            fontSize: 12 * scalefactor),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "ONLINE EVENT",
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
                                height: 5,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    "Wed , 7 july    ${myList[0]["time"]}",

                                    style: TextStyle(
                                        fontFamily: "Segoe UI",
                                        color: Colors.red,
                                        fontSize: 12 * scalefactor),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Image.asset("assets/jashn-moments123.png"),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Image.asset("assets/jashn-moments123.png"),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Image.asset("assets/jashn-moments123.png"),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Image.asset("assets/jashn-moments123.png"),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    "About the event",
                                    style: TextStyle(
                                        fontFamily: "Segoe UI",
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 12 * scalefactor),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    myList[0]["description"],
                                     style: TextStyle(
                                        fontFamily: "Segoe UI",
                                        color: Colors.black,
                                        fontSize: 12 * scalefactor),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    "Price",
                                    style: TextStyle(
                                        fontFamily: "Segoe UI",
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 12 * scalefactor),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "Free",
                                      style: TextStyle(
                                          fontFamily: "Segoe UI",
                                          color: Colors.black,
                                          fontSize: 12 * scalefactor),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    myList[0]["date"],style: TextStyle(
                                        fontFamily: "Segoe UI",
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 12 * scalefactor),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "Wednesday, ${myList[0]["date"]}",
                                      style: TextStyle(
                                          fontFamily: "Segoe UI",
                                          color: Colors.black,
                                          fontSize: 12 * scalefactor),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Row(
                                  children: [
                                    Text(
                                myList[0]["time"],
                                      style: TextStyle(
                                          fontFamily: "Segoe UI",
                                          color: Colors.black,
                                          fontSize: 12 * scalefactor),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "Times are displayed in your local time zone",
                                      style: TextStyle(
                                          fontFamily: "Segoe UI",
                                          color: Colors.grey,
                                          fontSize: 12 * scalefactor),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    "Host",
                                    style: TextStyle(
                                        fontFamily: "Segoe UI",
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 12 * scalefactor),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "Logo",
                                      style: TextStyle(
                                          fontFamily: "Segoe UI",
                                          color: Colors.black,
                                          fontSize: 12 * scalefactor),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    "Host",
                                    style: TextStyle(
                                        fontFamily: "Segoe UI",
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 12 * scalefactor),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "Logo",
                                      style: TextStyle(
                                          fontFamily: "Segoe UI",
                                          color: Colors.black,
                                          fontSize: 12 * scalefactor),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 20,)
                      ],
                    ),

                  ],

                ),
              ),
              SizedBox(height: height*0.02,),
              Column(mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    SizedBox(width: 20,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        elevation: 6,
                        borderRadius: BorderRadius.circular(64),
                        child: InkWell(
                          onTap: () {
                            // Navigator.pushReplacement(context,
                            //     MaterialPageRoute(builder: (context) => HomeScreen()));
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.calendar_today,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20,),
                    ElevatedButton(
                      child: Container(
                        constraints: BoxConstraints(
                            maxWidth: width / 1.6, minHeight: 45.0),
                        alignment: Alignment.center,
                        child: Text(
                          "Remind me to join",
                          style: TextStyle(
                              color: Constants.textColour1,
                              fontFamily: "Segoe UI",
                              fontSize: 12 * scalefactor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      onPressed: () {
                        eventModal();
                      },
                      style: ButtonStyle(
                        shape:
                        MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            )),
                        backgroundColor: MaterialStateProperty.all(
                            Constants.buttonColourMix4),
                      ),
                    ),
                  ],
                ),
              ],),
              SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }


  Future<bool> onWillPop() {
    Navigator.pop(context);
    return Future.value(true);
  }

  eventModal() {
    return showModalBottomSheet(
      backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        ),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState
                  /*You can rename this!*/) {
                return SafeArea(
                  child: Container(
                    child: Wrap(
                      children: <Widget>[
                        Row(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Verify  your phone",
                              style: TextStyle(
                                  color: Constants.textColour3,
                                  fontFamily: "Segoe UI",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800),
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "to proceed , please verify your mobile number.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Constants.textColour3,
                                fontFamily: "Segoe UI",
                                fontSize: 14,
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
                        Padding(
                          padding: const EdgeInsets.only(left: 32.0,right: 32.0),
                          child: Row(
                            children: [
                              CountryCodePicker(
                                onChanged: _onCountryChange,
                                // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                initialSelection: 'US',
                                favorite: ['US', 'IE', '+966', 'PK'],
                                textStyle: TextStyle(color: Colors.black),
                                // optional. Shows only country name and flag
                                showCountryOnly: false,
                                // optional. Shows only country name and flag when popup is closed.
                                showOnlyCountryWhenClosed: false,
                                // optional. aligns the flag and the Text left
                                alignLeft: false,
                              ),
                              Expanded(
                                child: TextFormField(
                                  cursorColor: Colors.grey,
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText: '102358865',
                                    contentPadding: const EdgeInsets.all(16),
                                    hintStyle: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "Segoe UI",
                                        color: Constants.textColour5),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: Constants.textColour5, width: 1.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: Constants.textColour4, width: 1.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: Constants.textColour5, width: 1.0),
                                    ),
                                  ),
                                ),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              child: Container(
                                constraints:
                                BoxConstraints(maxWidth: 250, minHeight: 45.0),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Verify",
                                      style: TextStyle(
                                          color: Constants.textColour1,
                                          fontFamily: "Segoe UI",
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              onPressed: () {},
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    )),
                                backgroundColor:
                                MaterialStateProperty.all(Constants.buttonColourMix4),
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
                  ),
                );
              });
        });
  }
  @override
  void initState() {
    _fetchData().whenComplete((){
      setState(() {
      });
    });
    super.initState();
  }
  late Map mapEventResponse;
  List<dynamic> myList=[];

  Future _fetchData() async {
    print("Click on fetch data");
    var detailsUrl=Uri.parse("https://haulers.tech/jashn/mobile/unauthorized/home/event_detail?id=${widget.eventId.toString()}");
    var eventResponse = await http.get(detailsUrl);
    if (eventResponse.statusCode == 200) {
      print("Response coming :${eventResponse.statusCode}");
      setState(()  {
        print("Set State");
        mapEventResponse = jsonDecode(eventResponse.body);
        myList=mapEventResponse["data"];
        //listOfEventDetails = mapEventResponse["data"];
        // listDetails.insert(0, listDetails[0]["details"]);
        // print(listDetails[0]["celebrity_name"]);
        print("Events Response Coming and length of list is ${myList.length}");
      });
    }
    else{
      print("Request failed to response :${eventResponse.statusCode}");
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
