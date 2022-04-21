import 'package:flutter/material.dart';
import '../../../styles/colors.dart';

class TermsOfUse extends StatefulWidget {
  @override
  TermsOfUseState createState() => TermsOfUseState();
}

class TermsOfUseState extends State<TermsOfUse> {
  bool isSwitched = false;
  //  String htmlData = r"""
  // <p><strong>Hey</strong>! Book you're shoutout now from Farhan Ali Agha</p>
  // """;

  Widget _widget() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double scaleFactor = MediaQuery.of(context).textScaleFactor;

    return SafeArea(
      child: Scaffold(
        body: WillPopScope(
          onWillPop: onWillPop,
          child: Container(
            width: width,
            height: height,
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  width: width,
                  height: height / 3,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Constants.buttonColourMix2,
                          Constants.buttonColourMix3,
                          Constants.buttonColourMix4,
                          Constants.buttonColourMix1,
                        ],
                        begin: const FractionalOffset(0.2, 0.0),
                        // end: const FractionalOffset(0.0, 1.0),
                      ),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height * 0.04,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18.0),
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
                        ],
                      ),
                      SizedBox(
                        height: height * 0.06,
                      ),
                      Image.asset(
                        "assets/logo.png",
                        height: 46,
                        width: 174,
                      ),

                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Terms Of Use",
                        style: TextStyle(
                            color: Constants.textColour1,
                            fontFamily: "Segoe UI",
                            fontSize: 24   * scaleFactor,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 24.0,right: 24.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            // Center(
                            //   child: Html(
                            //     data: htmlData,
                            //   ),
                            // ),
                            Row(
                              children: [
                                Text(
                                  "Users Terms of Use Agreement",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Segoe UI",
                                      color: Colors.black,
                                      fontSize: 16 * scaleFactor),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "The Platform allows you to send requests to Celebrities to create Content as specified by you (\"Content Request\" or \"Content Requests\"). When sending out any Content Request, you hereby agree to follow the Platform Usage Guidelines as updated solely by Jashn from time to time. You shall also follow the directions issued by Jashn regarding the implementation of the Content in accordance with the timeframes determined by Jashn and undertake to abide by the editorial policy of Jashn, as updated solely by Jashn from time to time.",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Segoe UI",
                                  color: Colors.black,
                                  fontSize: 12 * scaleFactor),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "You hereby acknowledge and understand that any Celebrity is entitled to approve or request your Content Request. In case your Content Request is refused by a Celebrity, or its duration expires, you will receive a refund of the amounts paid after deducting Jashn's management fees, as detailed below under \"Payments and Refunds\".",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Segoe UI",
                                  color: Colors.black,
                                  fontSize: 12 * scaleFactor),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "You hereby understand and accept that in case a Celebrity refuses your Content Request or in case Content created by a Celebrity in response to your Content Request is not up to your expectations, this shall not result in any liability on the Celebrity, Jashn, or any of its affiliates or employees.",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Segoe UI",
                                  color: Colors.black,
                                  fontSize: 12 * scaleFactor),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "Without prejudice to the foregoing, you understand that you shall not be entitled to any refund whatsoever, in whole or in part, if you have been found to be in breach of these Users Terms of Use after your Content Request has been processed.",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Segoe UI",
                                  color: Colors.black,
                                  fontSize: 12 * scaleFactor),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "You are solely responsible for any \"Content Request\" you issue. You hereby acknowledge that Jashn is not responsible for and shall not be held liable for any of your Content Requests or Content created by the Celebrity. You will defend and hold Jashn, its affiliates, and employees harmless against any claim or action by any Celebrity or third party in relation to your use of the Platform. You hereby acknowledge and agree to indemnify Jashn, its affiliates, and employees from and against any and all losses, damages, costs (including reasonable legal and other professional fees), expenses, any other liabilities incurred by or awarded against Jashn, its affiliates, or its employees in this regard.",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Segoe UI",
                                  color: Colors.black,
                                  fontSize: 12 * scaleFactor),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "You hereby acknowledge that you are using the Platform and issuing Content Requests in your personal capacity and that you may not use the Content for any commercial purposes. You understand, and that in case you violate the aforementioned requirements, you may be held liable by the Celebrities and/or Jashn and may be requested to pay compensation.",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Segoe UI",
                                  color: Colors.black,
                                  fontSize: 12 * scaleFactor),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "You hereby understand and agree that the Celebrities and/or Jashn may use your personal information or photos in application of these Users Terms of Use or in accordance with Jashn's Privacy Policy.",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Segoe UI",
                                  color: Colors.black,
                                  fontSize: 12 * scaleFactor),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "You hereby acknowledge and understand that Jashn may shut down your account or cancel your registration at any time at its sole discretion.", style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontFamily: "Segoe UI",
                                color: Colors.black,
                                fontSize: 12 * scaleFactor),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Ownership of the Content",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Segoe UI",
                                    color: Colors.black,
                                    fontSize: 14 * scaleFactor),
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "You hereby acknowledge that any Content created based upon a Content Request issued by you shall be the property of Jashn and that you possess no rights or title for the Content. You hereby irrevocably, unconditionally, perpetually, universally, and exclusively transfer, convey, waive and assign to Jashn, its affiliates, successors, and assignees, all and any right, title, interest, copyright, IP right, or commercial usage rights in and to the Content",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Segoe UI",
                                  color: Colors.black,
                                  fontSize: 12 * scaleFactor),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "You hereby accept that Jashn may use the Content in any way it deems appropriate with no rights due to you. For example, Jashn may use, distribute, advertise, promote, exhibit, license, or sublicense, display or create derivative works and freely exploit such Content."
                                  "\nJashn shall be entitled to place its commercial name and trademark on the Content. Jashn may also edit or modify the Content.",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Segoe UI",
                                  color: Colors.black,
                                  fontSize: 12 * scaleFactor),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Registration",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Segoe UI",
                                    color: Colors.black,
                                    fontSize: 14 * scaleFactor),
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "Participating in the Platform requires registration. Once you register in the Platform, you hereby agree to provide your true, accurate, current, integral and complete information as stipulated in Jashn's registration form, as well as any other information reasonably requested by Jashn, and promptly update your data to keep it true, accurate, current, and complete.",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Segoe UI",
                                  color: Colors.black,
                                  fontSize: 12 * scaleFactor),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "In the event that Jashn suspects that the information provided by you is misleading, inaccurate or incomplete, Jashn shall have the right to suspend or terminate your account and your use of the Platform. You acknowledge and hereby agree not to create or register an account on the Platform using a false identity or providing false information, or if it has previously been removed or banned from using or accessing the Platform.",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Segoe UI",
                                  color: Colors.black,
                                  fontSize: 12 * scaleFactor),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "You shall be responsible for maintaining the confidentiality of your account information, including your username and password. You further acknowledge and accept that you are responsible for all activities that occur on or in connection with your account and you agree to notify Jashn immediately of any unauthorized access, or breach, or use of your account. You further acknowledge and agree that Jashn is not and will not be responsible or liable for any damages, losses, costs, expenses, or liabilities related to any unauthorized access to or use of your account.",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Segoe UI",
                                  color: Colors.black,
                                  fontSize: 12 * scaleFactor),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Communications",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Segoe UI",
                                    color: Colors.black,
                                    fontSize: 14 * scaleFactor),
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "By using our Service, you agree to subscribe to newsletters, marketing or promotional materials, and other information we may send. However, you may opt-out of receiving any, or all, of these communications from us by following the unsubscribe link or by emailing at [email address]",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Segoe UI",
                                  color: Colors.black,
                                  fontSize: 12 * scaleFactor),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Accounts",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Segoe UI",
                                    color: Colors.black,
                                    fontSize: 14 * scaleFactor),
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "You are responsible for maintaining the confidentiality of your account and password, including but not limited to the restriction of access to your computer and/or account. You agree to accept responsibility for any and all activities or actions that occur under your account and/or password, whether your password is with our Service or a third-party service. You must notify us immediately upon becoming aware of any security breach or unauthorized use of your account",

                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Segoe UI",
                                  color: Colors.black,
                                  fontSize: 12 * scaleFactor),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "We reserve the right to refuse Service, terminate accounts, remove or edit Content, or cancel orders at our sole discretion.",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Segoe UI",
                                  color: Colors.black,
                                  fontSize: 12 * scaleFactor),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Payments and Refunds",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Segoe UI",
                                    color: Colors.black,
                                    fontSize: 14 * scaleFactor),
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "All payments by Users are made through Jashn's chosen payment gateway. You hereby acknowledge and understand that the payment gateway is an independent entity governed by its independent terms of use which are incorporated under these Terms of Use by reference and can currently be found here: [Payment Gateway Service Agreement Link]",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Segoe UI",
                                  color: Colors.black,
                                  fontSize: 12 * scaleFactor),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "You acknowledge that you are the legal owner of all credit cards, charge cards, debit cards or other payment methods used to perform payment and that you have legal authority to make use of such payment methods or you will be held liable",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Segoe UI",
                                  color: Colors.black,
                                  fontSize: 12 * scaleFactor),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "The transfer will be made to the same payment method used by you unless expressly communicated to Jashn by you and you are able to provide sufficient information as may be requested by Jashn to ensure that it is not an act of fraud.",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Segoe UI",
                                  color: Colors.black,
                                  fontSize: 12 * scaleFactor),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "Jashn shall not be liable in any manner for the refund of any fees made by third parties on such as payment gateways.",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Segoe UI",
                                  color: Colors.black,
                                  fontSize: 12 * scaleFactor),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Intellectual Property Rights of Jashn",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Segoe UI",
                                    color: Colors.black,
                                    fontSize: 14 * scaleFactor),
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "You acknowledge that Jashn is the sole exclusive owner of the Platform and owns all intellectual property rights (including, without limitation, tradename, copyright, trademark rights, knowhow, ideas, and patent rights) therein. You also acknowledge and understand that you are not licensed to use any of the aforementioned rights unless explicitly agreed upon with Jashn in writing.",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Segoe UI",
                                  color: Colors.black,
                                  fontSize: 12 * scaleFactor),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "Unless otherwise indicated, the Platform is our proprietary property and all source code, databases, functionality, software, designs, video, photographs, and graphics on the Platform (collectively, the \"Content\") and the trademarks, service marks, and logos contained therein (the \"Marks\") are owned or controlled by us or licensed to us, and are protected by copyright and trademark laws and various other intellectual property rights and unfair competition laws of the Islamic Republic of Pakistan, international copyright laws, and international conventions.",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Segoe UI",
                                  color: Colors.black,
                                  fontSize: 12 * scaleFactor),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "The Content and the Marks are provided on the Platform \"AS IS\" for your information and personal use only. Except as expressly provided in these Terms of Use, no part of the Platform and no Content or Marks may be copied, reproduced, aggregated, republished, uploaded, posted, publicly displayed, encoded, translated, transmitted, distributed, sold, licensed, or otherwise exploited for any commercial purpose whatsoever, without our express prior written permission. Provided that you are eligible to use the Platform, you are granted a limited license to access and use the Platform and to download or print a copy of any portion of the Content to which you have properly gained access solely for your personal, non-commercial use. We reserve all rights not expressly granted to you in and to the Platform, the Content and the Marks",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Segoe UI",
                                  color: Colors.black,
                                  fontSize: 12 * scaleFactor),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Changes To Services",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Segoe UI",
                                    color: Colors.black,
                                    fontSize: 14 * scaleFactor),
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "We reserve the right to withdraw or amend our Service, and any service or material we provide via Service, in our sole discretion without notice. We will not be liable if for any reason all or any part of Service is unavailable at any time or for any period. From time to time, we may restrict access to some parts of Service, or the entire Service, to users, including registered users.",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Segoe UI",
                                  color: Colors.black,
                                  fontSize: 12 * scaleFactor),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Amendments To Terms",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Segoe UI",
                                    color: Colors.black,
                                    fontSize: 14 * scaleFactor),
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "We may amend Terms at any time by posting the amended terms on this site. It is your responsibility to review these Terms periodically."
                                  "\nYour continued use of the Platform following the posting of revised Terms means that you accept and agree to the changes. You are expected to check this page frequently so you are aware of any changes, as they are binding on you.",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Segoe UI",
                                  color: Colors.black,
                                  fontSize: 12 * scaleFactor),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "By continuing to access or use our Service after any revisions become effective, you agree to be bound by the revised terms. If you do not agree to the new terms, you are no longer authorized to use Service.",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Segoe UI",
                                  color: Colors.black,
                                  fontSize: 12 * scaleFactor),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Privacy Policy",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Segoe UI",
                                    color: Colors.black,
                                    fontSize: 14 * scaleFactor),
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "We care about data privacy and security. Your use of the Platform/Service and any personal information provided or used by you to access the Platform/Service shall be collected, used, and/or stored in compliance with Our Privacy Policy. You hereby consent to all actions we take concerning your information consistent with the Privacy Policy [Link to Privacy Policy]",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Segoe UI",
                                  color: Colors.black,
                                  fontSize: 12 * scaleFactor),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Acknowledgement",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Segoe UI",
                                    color: Colors.black,
                                    fontSize: 14 * scaleFactor),
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "By using Service or other Services provided by us, you acknowledge that you have read these terms of use and agree to be bound by them.",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Segoe UI",
                                  color: Colors.black,
                                  fontSize: 12 * scaleFactor),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Contact Us",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Segoe UI",
                                    color: Colors.black,
                                    fontSize: 14 * scaleFactor),
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "Please send your feedback, comments, and requests for technical support by email: [email address]",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Segoe UI",
                                  color: Colors.black,
                                  fontSize: 12 * scaleFactor),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                          ],
                        ),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> onWillPop() {
    Navigator.pop(context);
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
