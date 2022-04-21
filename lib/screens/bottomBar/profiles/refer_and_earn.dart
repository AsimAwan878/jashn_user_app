// import 'package:flutter/material.dart';
// import 'package:jashn_user/styles/colors.dart';
//
// class Refer_And_Earn extends StatefulWidget {
//   @override
//   Refer_And_EarnState createState() => Refer_And_EarnState();
// }
//
// class Refer_And_EarnState extends State<Refer_And_Earn> {
//   Widget _widget() {
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;
//     double scalefactor = MediaQuery.of(context).textScaleFactor;
//
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           elevation: 0,
//           centerTitle: true,
//           leading: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Material(
//               elevation: 6,
//               borderRadius: BorderRadius.circular(64),
//               child: InkWell(
//                 onTap: () {
//                   // Navigator.pushReplacement(context,
//                   //     MaterialPageRoute(builder: (context) => BottomBar(3)));
//                 },
//                 child: CircleAvatar(
//                   backgroundColor: Colors.white,
//                   child: Icon(
//                     Icons.arrow_back_ios_new_rounded,
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           title: Text(
//             "Refer and Earn",
//             style: TextStyle(
//                 fontWeight: FontWeight.w800,
//                 fontFamily: "Segoe UI",
//                 color: Colors.black,
//                 fontSize: 18 * scalefactor),
//           ),
//         ),
//         body: WillPopScope(
//           onWillPop: onWillPop,
//           child: Container(
//             width: width,
//             height: height,
//             color: Colors.white,
//             child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       height: 30,
//                     ),
//                     Image.asset("assets/gift.png"),
//                     SizedBox(
//                       height: 15,
//                     ),
//                     Text(
//                       "Give 30%, Get 30%",
//                       style: TextStyle(
//                           fontFamily: "Segoe UI",
//                           color: Colors.black,
//                           fontSize: 18 * scalefactor),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 64.0,right: 64.0),
//                       child: Text(
//                         "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum printing and typesetting industry. Lorem Ipsum  ",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontFamily: "Segoe UI",
//                           fontSize: 10 * scalefactor,
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 5,
//                     ),
//                     Text(
//                       "(UP TO USD 16)",
//                       style: TextStyle(
//                           fontFamily: "Segoe UI",
//                           color: Colors.grey,
//                           fontSize: 14 * scalefactor),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Text(
//                       "View promo codes",
//                       style: TextStyle(
//                           fontFamily: "Segoe UI",
//                           color: Colors.red,
//                           fontSize: 12 * scalefactor),
//                     ),
//                     SizedBox(
//                       height: 40,
//                     ),
//                     ElevatedButton(
//                       child: Container(
//                         constraints:
//                         BoxConstraints(maxWidth: width / 1.4, minHeight: 45.0),
//                         alignment: Alignment.center,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               "Share with contacts",
//                               style: TextStyle(
//                                   color: Constants.textColour1,
//                                   fontFamily: "Segoe UI",
//                                   fontSize: 12 * scalefactor,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                       ),
//                       onPressed: () {},
//                       style: ButtonStyle(
//                         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                             RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(30.0),
//                             )),
//                         backgroundColor:
//                         MaterialStateProperty.all(Constants.buttonColourMix4),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 15,
//                     ),
//                     Text(
//                       "Terms & Condition",
//                       style: TextStyle(
//                           fontFamily: "Segoe UI",
//                           color: Colors.red,
//                           fontSize: 12 * scalefactor),
//                     ),
//                   ],
//                 )),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<bool> onWillPop() {
//     // Navigator.pushReplacement(
//     //     context, MaterialPageRoute(builder: (context) => BottomBar(3)));
//     return Future.value(true);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     final md = MediaQuery.of(context);
//     if (md.orientation == Orientation.landscape) {
//       return _widget();
//     }
//     return _widget();
//   }
// }
