import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jashn_user/screens/splash.dart';
import 'package:jashn_user/styles/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:developer' as developer;
import 'dart:async';
import 'package:flutter/services.dart';
//
String? selectedNotificationPayload;

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String title;
  final String body;
  final String payload;
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'high Importance Notification',
  importance: Importance.high,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async{
  await Firebase.initializeApp();
  print("A message just showed Up4{message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {


  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool isConnected = false;
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {

    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

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
      _determinePosition().whenComplete(() {
        setStateIfMounted(() {
          isConnected = true;
        });
      });
    }
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  Future<void> _determinePosition() async{
    Position position= await _fetchPosition();
    print(position.longitude);
    print(position.latitude);
    getAddressFromLatLong(position);
    setState(() {

    });
  }

  Future<Position> _fetchPosition() async{
    bool serviceEnabled;
    LocationPermission permission;

    // String latitude;
    // String longitude;
    // Position? position;

    serviceEnabled=await Geolocator.isLocationServiceEnabled();

    if(!serviceEnabled)
    {
      await Geolocator.openLocationSettings();
      return Future.error("Location Service is Disabled");
    }
    permission=await Geolocator.checkPermission();
    if(permission == LocationPermission.denied)
    {
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied)
      {
        return Future.error("Location permission is denied");
      }
    }
    if(permission == LocationPermission.deniedForever)
    {

      return Future.error("Location permission are permanently denied");
    }

    Position currentPosition=await Geolocator.getCurrentPosition();
    return currentPosition;
    // setState(() {
    //   position = currentPosition;
    //   latitude=currentPosition.latitude.toString();
    //   longitude=currentPosition.longitude.toString();
    //   print("Latitude = ${latitude}");
    //   print("Latitude = ${longitude}");
    // });

  }

  Future<void> getAddressFromLatLong(Position position) async{
    List<Placemark> placeMark=await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placeMark.toString());

    Placemark place= placeMark[0];

    SharedPreferences _prefs= await SharedPreferences.getInstance();
    _prefs.setString("getCity", place.locality.toString());
    _prefs.setString("lat", position.latitude.toString());
    _prefs.setString("long", position.longitude.toString());
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Constants.textColour3,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
      //Status BAr
      systemNavigationBarColor: Constants.textColour1,
      systemNavigationBarIconBrightness:
          Brightness.dark, //Bottom of Screen Button
    ));
    return MaterialApp(
      scaffoldMessengerKey: _messengerKey,
      home: Splash(),
      title: 'Jash\'n ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          bottomSheetTheme:
              BottomSheetThemeData(backgroundColor: Colors.transparent)),
    );
  }

  @override
  void dispose() {
    print("Dispose State called");
    _connectivitySubscription.cancel();
    super.dispose();
  }
}

//8949e382-c33ba1122794922e2ae4c84566fdc5c8