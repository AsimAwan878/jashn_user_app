
//
// class Add_Card extends StatefulWidget {
//   @override
//   Add_CardState createState() => Add_CardState();
// }
//
// class Add_CardState extends State<Add_Card> {
//   bool isSwitched = false;
//
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
//           leading:  Padding(
//             padding: const EdgeInsets.only(top: 20.0,left: 16),
//             child: InkWell(
//               onTap: (){
//
//                   Navigator.pushReplacement(
//                       context, MaterialPageRoute(builder: (context) =>Payment_Methods()));
//
//               },
//               child: Text(
//                 "Cancel",
//                 style: TextStyle(
//                     fontWeight: FontWeight.w800,
//                     fontFamily: "Segoe UI",
//                     color: Colors.black,
//                     fontSize: 10 * scalefactor),
//               ),
//             ),
//           ),
//           title: Text(
//             "Add card",
//             style: TextStyle(
//                 fontWeight: FontWeight.w800,
//                 fontFamily: "Segoe UI",
//                 color: Colors.black,
//                 fontSize: 18 * scalefactor),
//           ),
//           actions: [
//             Padding(
//               padding: const EdgeInsets.only(top: 24.0,right: 16),
//               child: Text(
//                 "Done",
//                 style: TextStyle(
//                     fontWeight: FontWeight.w800,
//                     fontFamily: "Segoe UI",
//                     color: Colors.black,
//                     fontSize: 10 * scalefactor),
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
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Text(
//                       "We accept all major credit and debit cards",
//                       style: TextStyle(
//                           fontFamily: "Segoe UI",
//                           color: Colors.black,
//                           fontSize: 12 * scalefactor),
//                     ),
//                     SizedBox(
//                       height: 15,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Image.asset("assets/visa.png"),
//                         Image.asset("assets/visa.png"),
//                         Image.asset("assets/visa.png"),
//                         Image.asset("assets/visa.png"),
//                         Image.asset("assets/visa.png"),
//                         Image.asset("assets/visa.png")
//                       ],
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 24.0,right: 24.0),
//                       child: TextFormField(
//                         cursorColor: Colors.grey,
//                         decoration: InputDecoration(
//                           fillColor: Colors.white,
//                           filled: true,
//                           labelText: "Name on card",
//                           labelStyle: TextStyle(
//                               fontSize: 14 * scalefactor,
//                               fontWeight: FontWeight.w400,
//                               fontFamily: "Segoe UI",
//                               color: Constants.textColour5),
//                           contentPadding: const EdgeInsets.all(16),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: BorderSide(
//                                 color: Constants.textColour5, width: 1.0),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: BorderSide(
//                                 color: Constants.textColour4, width: 1.0),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: BorderSide(
//                                 color: Constants.textColour5, width: 1.0),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 24.0,right: 24.0),
//                       child: TextFormField(
//                         cursorColor: Colors.grey,
//                         decoration: InputDecoration(
//                           fillColor: Colors.white,
//                           filled: true,
//                           labelText: "Card Number",
//                           labelStyle: TextStyle(
//                               fontSize: 14 * scalefactor,
//                               fontWeight: FontWeight.w400,
//                               fontFamily: "Segoe UI",
//                               color: Constants.textColour5),
//                           contentPadding: const EdgeInsets.all(16),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: BorderSide(
//                                 color: Constants.textColour5, width: 1.0),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: BorderSide(
//                                 color: Constants.textColour4, width: 1.0),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: BorderSide(
//                                 color: Constants.textColour5, width: 1.0),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Padding(
//                             padding: const EdgeInsets.only(left: 24.0,right: 24.0),
//                             child: TextFormField(
//                               cursorColor: Colors.grey,
//                               decoration: InputDecoration(
//                                 fillColor: Colors.white,
//                                 filled: true,
//                                 labelText: "Expiry Date",
//                                 labelStyle: TextStyle(
//                                     fontSize: 14 * scalefactor,
//                                     fontWeight: FontWeight.w400,
//                                     fontFamily: "Segoe UI",
//                                     color: Constants.textColour5),
//                                 contentPadding: const EdgeInsets.all(16),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                   borderSide: BorderSide(
//                                       color: Constants.textColour5, width: 1.0),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                   borderSide: BorderSide(
//                                       color: Constants.textColour4, width: 1.0),
//                                 ),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                   borderSide: BorderSide(
//                                       color: Constants.textColour5, width: 1.0),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           child: Padding(
//                             padding: const EdgeInsets.only(left: 24.0,right: 24.0),
//                             child: TextFormField(
//                               cursorColor: Colors.grey,
//                               decoration: InputDecoration(
//                                 fillColor: Colors.white,
//                                 filled: true,
//                                 labelText: "Security code",
//                                 labelStyle: TextStyle(
//                                     fontSize: 14 * scalefactor,
//                                     fontWeight: FontWeight.w400,
//                                     fontFamily: "Segoe UI",
//                                     color: Constants.textColour5),
//                                 contentPadding: const EdgeInsets.all(16),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                   borderSide: BorderSide(
//                                       color: Constants.textColour5, width: 1.0),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                   borderSide: BorderSide(
//                                       color: Constants.textColour4, width: 1.0),
//                                 ),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                   borderSide: BorderSide(
//                                       color: Constants.textColour5, width: 1.0),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 24.0,right: 24.0),
//                       child: Row(
//                         children: [
//                           Switch(
//                             value: isSwitched,
//                             onChanged: (value) {
//                               setState(() {
//                                 isSwitched = value;
//                                 print(isSwitched);
//                               });
//                             },
//                             activeTrackColor: Constants.textColour6,
//                             activeColor: Constants.textColour6,
//                           ),
//                           Text(
//                             "Make this video public on Lorem lpsum",
//                             style: TextStyle(
//                               color: Constants.textColour3,
//                               fontFamily: "Segoe UI",
//                               fontSize: 14 * scalefactor,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 )),
//           ),
//         ),
//       ),
//     );
//   }
//
//
//   Future<bool> onWillPop() {
//     Navigator.pushReplacement(
//         context, MaterialPageRoute(builder: (context) => Payment_Methods()));
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
