// import 'package:flutter/material.dart';
// import 'package:jashn_user/screens/bottomBar/profiles/wallet/jashn_wallet.dart';
//
// class Payment_Methods extends StatefulWidget {
//   @override
//   Payment_MethodsState createState() => Payment_MethodsState();
// }
//
// class Payment_MethodsState extends State<Payment_Methods> {
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
//                   Navigator.pushReplacement(context,
//                       MaterialPageRoute(builder: (context) => JashnWallet()));
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
//             "Payment methods",
//             style: TextStyle(
//                 fontWeight: FontWeight.w800,
//                 fontFamily: "Segoe UI",
//                 color: Colors.black,
//                 fontSize: 18 * scalefactor),
//           ),
//           actions: [
//             Padding(
//               padding: const EdgeInsets.only(top: 16.0,right: 16),
//               child: Text(
//                 "Edit",
//                 style: TextStyle(
//                     fontWeight: FontWeight.w800,
//                     fontFamily: "Segoe UI",
//                     color: Colors.black,
//                     fontSize: 12 * scalefactor),
//               ),
//             ),
//           ],
//         ),
//         body: WillPopScope(
//           onWillPop: onWillPop,
//           child: Container(
//             width: width,
//             height: height,
//             color: Colors.white,
//             child: SingleChildScrollView(
//                 child: Material(
//                   elevation: 0.2,
//                   child: Container(
//                     color: Colors.white,
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: 20.0,left: 20),
//                       child: InkWell(
//                         onTap: (){
//                             // Navigator.pushReplacement(
//                             //     context, MaterialPageRoute(builder: (context) => Add_Card()));
//
//                         },
//                         child: Row(
//                           children: [
//                             Icon(Icons.add_circle,color: Colors.grey,size: 30,),
//                             SizedBox(
//                               width: 15,
//                             ),
//                             Text(
//                               "Add credit or debit card",
//                               style: TextStyle(
//                                   fontFamily: "Segoe UI",
//                                   color: Colors.black,
//                                   fontSize: 12 * scalefactor),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 )),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<bool> onWillPop() {
//     Navigator.pushReplacement(
//         context, MaterialPageRoute(builder: (context) => JashnWallet()));
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
