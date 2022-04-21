import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bottomBar/bottom_bar.dart';
import 'landing.dart';

class Splash extends StatefulWidget {
  //Splash
  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> {
  @override
  void initState() {
    startTime();
    super.initState();
  }

  startTime() async {
    var duration = new Duration(seconds: 5);
    return new Timer(duration, route);
  }

  route() async {

    SharedPreferences _prefs= await SharedPreferences.getInstance();
    if(_prefs.containsKey("token") && _prefs.containsKey("customer_id") && _prefs.containsKey("fcm"))
    {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => BottomBar(currentIndex: 0,categoryId: 1,categoryName: "All",)));
    }
    else{
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Landing()));
    }

  }

  Widget _widget() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/splash.png"), fit: BoxFit.cover,)),
            child: Center(
              child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Image.asset(
                    'assets/logo.png',
                    width: width*0.7,
                    height: height*0.1,
                  )),
            )),
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