
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:jashn_user/styles/colors.dart';

import '../bottom_bar.dart';

class PromoCodes extends StatefulWidget {
  @override
  PromoCodesState createState() => PromoCodesState();
}

class PromoCodesState extends State<PromoCodes> {
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
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => BottomBar(currentIndex: 3,categoryId: 1,categoryName: "All")));
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
            "Promo codes",
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
                    // Navigator.pushReplacement(context,
                    //     MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.info_outline,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),

        body: Container(
          width: width,
          height: height,
          color: Colors.white,
          child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    child: Container(
                      constraints:
                      BoxConstraints(maxWidth: width / 1.3, minHeight: 45.0),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Add promo code",
                            style: TextStyle(
                                color: Constants.textColour1,
                                fontFamily: "Segoe UI",
                                fontSize: 12 * scalefactor,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    onPressed: () {
                      PromoModal();
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          )),
                      backgroundColor:
                      MaterialStateProperty.all(Constants.buttonColourMix4),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                      width: width / 1.25,
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Want free promo codes?",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Segoe UI",
                                  fontSize: 18 * scalefactor,),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 24.0,right: 24),
                              child: Text(
                                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum printing and typesetting industry. Lorem Ipsum  ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Segoe UI",
                                  fontSize: 10 * scalefactor,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            ElevatedButton(
                              child: Container(
                                constraints: BoxConstraints(
                                    maxWidth: width / 3.2, minHeight: 40.0),
                                alignment: Alignment.center,
                                child: Text(
                                  "Share Referral link",
                                  style: TextStyle(
                                      color: Constants.textColour3,
                                      fontFamily: "Segoe UI",
                                      fontSize: 12 * scalefactor,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                              onPressed: () {
                                referralModal();
                              },
                              style: ButtonStyle(
                                shape:
                                MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30.0),
                                        side: BorderSide(
                                            color: Colors.black, width: 2.0))),
                                backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                          ],
                        ),
                      )),
                ],
              )),
        ),
      ),
    );
  }

  Future<bool> onWillPop() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => BottomBar(currentIndex: 3,categoryId: 1,categoryName: "All",)));
    return Future.value(true);
  }

  // ignore: non_constant_identifier_names
  PromoModal() {
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
                              "Add promo code",
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
                        Padding(
                          padding: const EdgeInsets.only(right: 64.0,left: 64),
                          child: Text(
                            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Constants.textColour3,
                              fontFamily: "Segoe UI",
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 32, right: 32),
                          child: TextFormField(
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(
                              hintText: 'Promo Code',
                              contentPadding: const EdgeInsets.only(left: 24),
                              hintStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Mulish',
                                  color: Constants.textColour5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                    color: Constants.textColour5, width: 2.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                    color: Constants.textColour4, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                    color: Constants.textColour5, width: 2.0),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: 40,
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
                                      "Add",
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
                              height: 40,
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

  referralModal() {
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
  Widget build(BuildContext context) {
    // TODO: implement build
    final md = MediaQuery.of(context);
    if (md.orientation == Orientation.landscape) {
      return _widget();
    }
    return _widget();
  }
}
