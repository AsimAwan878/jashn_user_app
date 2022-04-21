import 'package:flutter/material.dart';

class VideoShoutout extends StatefulWidget {
  @override
  VideoShoutoutState createState() => VideoShoutoutState();
}

class VideoShoutoutState extends State<VideoShoutout> {
  List images = [
    'assets/aima_baig.png',
    'assets/asim_azhar.jpg',
    'assets/atif.jpg',
    'assets/hania_aamir.jpg',
    'assets/imran_abbas.jpg',
    'assets/Mahira_khan.jpg',
    'assets/Maya-Ali.jpg',
    'assets/momina.jpg',
    'assets/Sajal_aly.jpg',
  ];
  List names = [
    'Aima Baig',
    'Asim Azhar',
    'Atif Aslam',
    'Hania Aamir',
    'Imran Abbas',
    'Mahira Khan',
    'Maya Ali',
    'Momina Mustehsaan',
    'Sajal Aly',
  ];
  List icons = ['assets/stars.png', 'assets/masks.png', 'assets/music.png', ''];
  List color = [Colors.amber, Colors.redAccent, Colors.purple, Colors.grey];
  List label = ['New', 'Actors', 'Musician', 'All'];

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
                  // Navigator.pushReplacement(
                  //     context, MaterialPageRoute(builder: (context) => Celeb_Details()));

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
            "Fan Shoutout",
            style: TextStyle(
                fontWeight: FontWeight.w800,
                fontFamily: "Segoe UI",
                color: Colors.black,
                fontSize: 18 * scalefactor),
          ),
        ),
        body: WillPopScope(
          onWillPop: onWillPop,
          child: Container(
            width: width,
            height: height,
            child: Container(
              height: height,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: Container(
                      child: GridView.count(
                        padding: EdgeInsets.all(16),
                        // physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        children: [
                          for (int i = 0; i < names.length; i++)
                            InkWell(
                              onTap: () {
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: DecorationImage(
                                      image: AssetImage(images[i]),
                                      fit: BoxFit.cover,
                                    )),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        names[i],
                                        style: TextStyle(
                                            fontFamily: "Segoe UI",
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14 * scalefactor),
                                      ),
                                      Text(
                                        'Actress',
                                        style: TextStyle(
                                            fontFamily: "Segoe UI",
                                            color: Colors.white,
                                            fontSize: 14 * scalefactor),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> onWillPop() {
    Navigator.pop(context);
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => Celeb_Details()));
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
