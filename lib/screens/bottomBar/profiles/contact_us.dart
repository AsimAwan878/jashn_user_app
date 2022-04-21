import 'package:flutter/material.dart';

class ContactUs extends StatefulWidget {
  @override
  ContactUsState createState() => ContactUsState();
}

class ContactUsState extends State<ContactUs> {

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
            "Contact Us",
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
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0,bottom: 16),
                  child: Container(
                    padding: EdgeInsets.only(left: 10,bottom: 10,top: 10),
                    height: 50,
                    width: double.infinity,
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
                        borderRadius: BorderRadius.circular(32)),
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: (){
                          },
                          child: Icon(Icons.attach_file, color: Colors.black, size: 20, ),
                        ),
                        SizedBox(width: 15,),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                                hintText: "Write message...",
                                hintStyle:TextStyle(
                                    fontFamily: "Segoe UI",
                                    color: Colors.black,
                                    fontSize: 12* scalefactor),
                                border: InputBorder.none
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.send,color: Colors.black,size: 20,),
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
