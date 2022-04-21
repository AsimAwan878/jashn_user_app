//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:jashn_user/styles/colors.dart';
//
// class PinEntryTextFieldforotp extends StatefulWidget {
//   final String? lastPin;
//   final int fields;
//   final fieldWidth;
//   final fontSize;
//   final isTextObscure;
//   final showFieldAsBox;
//
//   PinEntryTextFieldforotp(
//       {required this.lastPin,
//         this.fields: 4,
//         this.fieldWidth: 40.0,
//         this.fontSize: 20.0,
//         this.isTextObscure: false,
//         this.showFieldAsBox: false})
//       : assert(fields > 0);
//
//   @override
//   State createState() {
//     return PinEntryTextFieldforotpState();
//   }
// }
//
// class PinEntryTextFieldforotpState extends State<PinEntryTextFieldforotp> {
//
//   late List<String> _pin;
//   late List<FocusNode> _focusNodes;
//   late List<TextEditingController> _textControllers;
//   Widget textFields = Container();
//
//   @override
//   void initState() {
//     super.initState();
//     // _pin = List<String>.generate(widget.fields, (index) => );
//     // _focusNodes = List<FocusNode>.generate(widget.fields, (index) => );
//     // _textControllers = List<TextEditingController>.generate(widget.fields, (index) => );
//     WidgetsBinding.instance!.addPostFrameCallback((_) {
//       setState(() {
//         if (widget.lastPin != null) {
//           for (var i = 0; i < widget.lastPin!.length; i++) {
//             _pin.add(widget.lastPin![i]);
//           }
//         }
//         textFields = generateTextFields(context);
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     _textControllers.forEach((TextEditingController t) => t.dispose());
//     super.dispose();
//   }
//
//   Widget generateTextFields(BuildContext context) {
//     List<Widget> textFields = List.generate(widget.fields, (int i) {
//       return buildTextField(i, context);
//     });
//
//     if (_pin.first != null) {
//       FocusScope.of(context).requestFocus(_focusNodes[0]);
//     }
//
//     return Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         verticalDirection: VerticalDirection.down,
//         children: textFields);
//   }
//
//   void clearTextFields() {
//     _textControllers.forEach(
//             (TextEditingController tEditController) => tEditController.clear());
//     _pin.clear();
//   }
//
//   Widget buildTextField(int i, BuildContext context) {
//     if (_focusNodes[i] == null) {
//       _focusNodes[i] = FocusNode();
//     }
//     if (_textControllers[i] == null) {
//       _textControllers[i] = TextEditingController();
//       if (widget.lastPin != null) {
//         _textControllers[i].text = widget.lastPin![i];
//       }
//     }
//
//     _focusNodes[i].addListener(() {
//       if (_focusNodes[i].hasFocus) {}
//     });
//
//     final String lastDigit = _textControllers[i].text;
//
//     return Container(
//       width: widget.fieldWidth,
//       margin: EdgeInsets.only(right: 10.0),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(10.0),
//         child: Container(
//           color: Constants.textColour1,
//           child: TextField(
//
//             cursorColor: Colors.black,
//             controller: _textControllers[i],
//             keyboardType: TextInputType.number,
//             textAlign: TextAlign.center,
//             maxLength: 1,
//             style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//                 fontSize: widget.fontSize),
//             focusNode: _focusNodes[i],
//             obscureText: widget.isTextObscure,
//             decoration: InputDecoration(
//                 enabledBorder: UnderlineInputBorder(
//                   borderSide: BorderSide(
//                     width: 1,
//                     color: Constants.textColour4,
//                   ),
//                 ),
//                 focusedBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(
//                       width: 1,
//                       color: Constants.textColour4,
//                     )),
//                 counterText: "",
//                 border: widget.showFieldAsBox
//                     ? OutlineInputBorder(
//                     borderSide: BorderSide(width: 2.0, color: Colors.black))
//                     : null),
//             onChanged: (String str) {
//               setState(() {
//                 _pin[i] = str;
//               });
//               if (i + 1 != widget.fields) {
//                 _focusNodes[i].unfocus();
//                 if (lastDigit != null && _pin[i] == '') {
//                   FocusScope.of(context).requestFocus(_focusNodes[i - 1]);
//                 } else {
//                   FocusScope.of(context).requestFocus(_focusNodes[i + 1]);
//                 }
//               } else {
//                 _focusNodes[i].unfocus();
//                 if (lastDigit != null && _pin[i] == '') {
//                   FocusScope.of(context).requestFocus(_focusNodes[i - 1]);
//                 }
//               }
//               if (_pin.every((String digit) => digit != null && digit != '')) {
//                 widget.onSubmit(_pin.join());
//               }
//             },
//             onSubmitted: (String str) {
//               if (_pin.every((String digit) => digit != null && digit != '')) {
//                 widget.onSubmit(_pin.join());
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return textFields;
//   }
// }