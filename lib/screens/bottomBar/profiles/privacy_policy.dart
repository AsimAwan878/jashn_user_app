import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../styles/colors.dart';
import '../../../styles/strings.dart';

class PrivacyPolicy extends StatefulWidget {
  @override
  PrivacyPolicyState createState() => PrivacyPolicyState();
}

class PrivacyPolicyState extends State<PrivacyPolicy> {
  bool isSwitched = false;

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
                        "Privacy Policy",
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
                            Text(
                              "We, UNIT52 (PVT.) LTD, are a company established under the laws of the Islamic Republic of Pakistan, having its registered office located at No.202-A, Kathiawar Cooperative Housing Society Ltd, Main Fatima Jinnah Road, Off Tipu Sultan Road, Karachi, Pakistan (hereinafter referred to as \"Unit52\"); and Unit52 owns website and Application named \"Jashn\" (the \"Platform\"), which allows actors, singers, athletes, artists, influencers, and other public figures (each hereinafter referred to as \"Celebrity\" or collectively \"Celebrities\") to create for the benefit and ownership of Jashn a personalized shout-out video or other media content to the users of the Platform upon their request to Jashn by the Celebrity of choice (hereinafter referred to as \"Content\").",
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
                                "Interpretation and Definitions",
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
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Interpretation",
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
                              "The words in which the initial letter is capitalized have meanings defined under the following conditions. The following definitions shall have the same meaning regardless of whether they appear singular or plural.",
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
                                "Definitions",
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
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "For the purposes of this Privacy Policy:",
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
                              "Account means a unique account created for You to access our Service or parts of our Service."
                                  "\nAffiliate means an entity that controls, is controlled by or is under common control with a party, where \"control\" means ownership of 50% or more of the shares, equity interest, or other securities entitled to vote for the election of directors or other managing authority."
                                  "\nApplication means the software program provided by the Company downloaded by You on any electronic device, named Jashn."
                                  "\nCompany (referred to as either \"the Company\", \"We\", \"Us\" or \"Our\" in this Agreement) refers to Unit52 (Pvt.) Ltd, Karachi, Pakistan."
                                  "\nCountry refers to Pakistan"
                                  "\nDevice means any device that can access the Service, such as a computer, a cellphone, or a digital tablet."
                                  "\nPersonal Data is any information that relates to an identified or identifiable individual."
                                  "\nService refers to the Application."
                                  "\nService Provider means any natural or legal person who processes the data on behalf of the Company. It refers to third-party companies or individuals employed by the Company to facilitate the Service, provide the Service on behalf of the Company, perform services related to the Service, or assist the Company in analyzing how the Service is used."
                                  "\nThird-party Social Media Service refers to any website or any social network website through which a User can log in or create an account to use the Service."
                                  "\nUsage Data refers to data collected automatically, either generated by the use of the Service or from the Service infrastructure itself (for example, the duration of a page visit)."
                                  "\nYou means the individual accessing or using the Service, or the Company, or other legal entity on behalf of which such individual is accessing or using the Service, as applicable.",
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
                                "Collecting and Using Your Personal Data"
                                    "\n"
                                    "\nTypes of Data Collected"
                                    "\n"
                                    "\nPersonal Data",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Segoe UI",
                                    color: Colors.black,
                                    fontSize: 14 * scaleFactor),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "\nWhile using Our Service, We may ask You to provide Us with certain personally identifiable information that can contact or identify You. Personally, identifiable information may include, but is not limited to:"
                                  "\n"
                                  "\nEmail address"
                                  "\n"
                                  "\nUsername"
                                  "\n"
                                  "\nPassword"
                                  "\n"
                                  "\nFirst name and last name"
                                  "\n"
                                  "\nPhone number"
                                  "\n"
                                  "\nUsage Data"
                                  "\n"
                                  "\nDebit/Credit Card Number"
                                  "\n"
                                  "\nAnd other similar information.",
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
                            SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Usage Data",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Segoe UI",
                                    color: Colors.black,
                                    fontSize: 14 * scaleFactor),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "\nUsage Data is collected automatically when using the Service."
                                  "\n"
                                  "\nUsage Data may include information such as Your Device's Internet Protocol address (e.g., IP address), browser type, browser version, the pages of our Service that You visit, the time and date of Your visit, the time spent on those pages, unique device identifiers and other diagnostic data.",
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
                              "When You access the Service by or through a mobile device, We may collect certain information automatically, including, but not limited to, the type of mobile device You use, Your mobile device unique ID."
                                  "\n"
                                  "\nWe may also collect information that Your browser sends whenever You visit our Service or when You access the Service by or through a mobile device.",
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
                                "Information from Third-Party Social Media Services",
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
                              "The Company allows You to create an account and log in to use the Service through the following Third-party Social Media Services",
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
                                "·        Google"
                                    "\n"
                                    "\n·        Facebook",
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
                              "If You decide to register through or otherwise grant us access to a Third-Party Social Media Service, We may collect Personal data that is already associated with Your Third-Party Social Media Service's account, such as Your name, Your email address or Your contact number associated with that account."
                                  "\n"
                                  "\nYou may also have the option of sharing additional information with the Company through Your Third-Party Social Media Service's account. If You choose to provide such information and Personal Data, during registration or otherwise, You are giving the Company permission to use, share, and store it in a manner consistent with this Privacy Policy."
                                  "\nInformation Collected while Using the Application",
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
                                "While using Our Application, in order to provide features of Our Application, We may collect, with Your prior permission:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Segoe UI",
                                    color: Colors.black,
                                    fontSize: 14 * scaleFactor),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "Pictures and other information from your Device's camera and photo library"
                                  "\n",
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
                                "Information about your hardware and software, such as unique application identifiers, apps installed, unique device identifiers and time zone;",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Segoe UI",
                                    color: Colors.black,
                                    fontSize: 14 * scaleFactor),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "We may collect information about your location. With your permission, we may also collect information about your precise location using methods that include GPS, wireless networks, cell towers, Wi-Fi access points, and other sensors, such as gyroscopes, accelerometers, and compasses."
                                  "\nWe use this information to provide features of Our Service, to improve and customize Our Service. The information may be uploaded to the Company's servers and/or a Service Provider's server or it may be simply stored on Your device."
                                  "\n"
                                  "\nYou can enable or disable access to this information at any time, through Your Device settings.",
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
                                "Use of Your Personal Data"
                                    "\n"
                                    "\nThe Company may use Personal Data for the following purposes:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Segoe UI",
                                    color: Colors.black,
                                    fontSize: 14 * scaleFactor),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "·        To provide and maintain our Service, including to monitor the usage of our Service."
                                    "\n"
                                    "\n·        To manage Your Account: to manage Your registration as a user of the Service. The Personal Data You provide can give You access to different functionalities of the Service that are available to You as a registered user."
                                    "\n"
                                    "\n·        For the performance of a contract: the development, compliance, and undertaking of the purchase contract for the products, items, or services You have purchased or of any other contract with Us through the Service."
                                    "\n"
                                    "\n·        To contact You: To contact You by email, telephone calls, SMS, or other equivalent forms of electronic communication, such as a mobile application's push notifications regarding updates or informative communications related to the functionalities, products, or contracted services, including the security updates, when necessary or reasonable for their implementation."
                                    "\n"
                                    "\n·        To provide You with news, special offers, and general information about other goods, services, and events which we offer that are similar to those that you have already purchased or enquired about unless You have opted not to receive such information."
                                    "\n"
                                    "\n·        To manage Your requests: To attend and manage Your requests to Us."
                                    "\n"
                                    "\n·        For business transfers: We may use Your information to evaluate or conduct a merger, divestiture, restructuring, reorganization, dissolution, or other sale or transfer of some or all of Our assets, whether as a going concern or as part of bankruptcy, liquidation, or similar proceeding, in which Personal Data held by Us about our Service users is among the assets transferred."
                                    "\n"
                                    "\n·        For other purposes: We may use Your information for other purposes, such as data analysis, identifying usage trends, determining the effectiveness of our promotional campaigns and to evaluate and improve our Service, products, services, marketing, and your experience.",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Segoe UI",
                                    color: Colors.black,
                                    fontSize: 14 * scaleFactor),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "We may share Your personal information in the following situations:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Segoe UI",
                                    color: Colors.black,
                                    fontSize: 14 * scaleFactor),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "·           With Service Providers: We may share Your personal information with Service Providers to monitor and analyze the use of our Service, to contact You."
                                    "\n"
                                    "\n·           For business transfers: We may share or transfer Your personal information in connection with, or during negotiations of, any merger, sale of Company assets, financing, or acquisition of all or a portion of Our business to another company."
                                    "\n"
                                    "\n·           With Affiliates: We may share Your information with Our affiliates, in which case we will require those affiliates to honor this Privacy Policy. Affiliates include Our parent company and any other subsidiaries, joint venture partners or other companies that We control or are under common control with Us."
                                    "\n"
                                    "\n·           With business partners: We may share Your information with Our business partners to offer You certain products, services, or promotions."
                                    "\n"
                                    "\n·           With other users: when You share personal information or otherwise interact in the public areas with other users, such information may be viewed by all users and may be publicly distributed outside. If You interact with other users or register through a Third-Party Social Media Service, Your contacts on the Third-Party Social Media Service may see Your name, profile, pictures and description of Your activity. Similarly, other users will be able to view descriptions of Your activity, communicate with You and view Your profile."
                                    "\n"
                                    "\n·           With Your consent: We may disclose Your personal information for any other purpose with Your consent.",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Segoe UI",
                                    color: Colors.black,
                                    fontSize: 14 * scaleFactor),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Retention of Your Personal Data",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Segoe UI",
                                    color: Colors.black,
                                    fontSize: 14 * scaleFactor),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "The Company will retain Your Personal Data only for as long as is necessary for the purposes set out in this Privacy Policy. We will retain and use Your Personal Data to the extent required to comply with our legal obligations (for example, if we are required to retain your data to comply with applicable laws), resolve disputes, and enforce our legal agreements and policies."
                                    "\n"
                                    "\nThe Company will also retain Usage Data for internal analysis purposes. Usage Data is generally retained for a shorter period of time, except when this data is used to strengthen the security or to improve the functionality of Our Service, or We are legally obligated to retain this data for longer time periods.",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Segoe UI",
                                    color: Colors.black,
                                    fontSize: 14 * scaleFactor),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Transfer of Your Personal Data",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Segoe UI",
                                    color: Colors.black,
                                    fontSize: 14 * scaleFactor),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Your information, including Personal Data, is processed at the Company's operating offices and in any other places where the parties involved in the processing are located. It means that this information may be transferred to — and maintained on — computers located outside of Your state, province, country, or other governmental jurisdiction where the data protection laws may differ from those from Your jurisdiction."
                                    "\n"
                                    "\nYour consent to this Privacy Policy followed by Your submission of such information represents Your agreement to that transfer."
                                    "\n"
                                    "\nThe Company will take all steps reasonably necessary to ensure that Your data is treated securely and in accordance with this Privacy Policy and no transfer of Your Personal Data will take place to an organization or a country unless there are adequate controls in place, including the security of Your data and other personal information.",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Segoe UI",
                                    color: Colors.black,
                                    fontSize: 14 * scaleFactor),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Disclosure of Your Personal Data"
                                    "\nBusiness Transactions",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Segoe UI",
                                    color: Colors.black,
                                    fontSize: 14 * scaleFactor),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "If the Company is involved in a merger, acquisition, or asset sale, Your Personal Data may be transferred. We will provide notice before Your Personal Data is transferred and becomes subject to a different Privacy Policy.",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Segoe UI",
                                    color: Colors.black,
                                    fontSize: 14 * scaleFactor),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Law enforcement",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Segoe UI",
                                    color: Colors.black,
                                    fontSize: 14 * scaleFactor),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Under certain circumstances, the Company may be required to disclose Your Personal Data if required to do so by law or in response to valid requests by public authorities (e.g., a court or a government agency).",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Segoe UI",
                                    color: Colors.black,
                                    fontSize: 14 * scaleFactor),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Other legal requirements"
                                    "\n"
                                    "\nThe Company may disclose Your Personal Data in the good faith belief that such action is necessary to:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Segoe UI",
                                    color: Colors.black,
                                    fontSize: 14 * scaleFactor),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "·        Comply with a legal obligation"
                                    "\n"
                                    "\n·        Protect and defend the rights or property of the Company"
                                    "\n"
                                    "\n·        Prevent or investigate possible wrongdoing in connection with the Service"
                                    "\n"
                                    "\n·        Protect the personal safety of Users of the Service or the public"
                                    "\n"
                                    "\n·        Protect against legal liability",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Segoe UI",
                                    color: Colors.black,
                                    fontSize: 14 * scaleFactor),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Security of Your Personal Data",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Segoe UI",
                                    color: Colors.black,
                                    fontSize: 14 * scaleFactor),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "The security of Your Personal Data is important to Us, but remember that no method of transmission over the Internet, or method of electronic storage is 100% secure. While We strive to use commercially acceptable means to protect Your Personal Data, We cannot guarantee its absolute security.",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Segoe UI",
                                    color: Colors.black,
                                    fontSize: 14 * scaleFactor),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Information Collection and Use",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Segoe UI",
                                    color: Colors.black,
                                    fontSize: 14 * scaleFactor),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "For a better experience, while using our Service, we may require you to provide us with certain personally identifiable information. The information we request will be retained by us and used as described in this privacy policy."
                                    "\n"
                                    "\nThe app does use third-party services that may collect information used to identify you."
                                    "\n"
                                    "\nLink to the privacy policy of third-party service providers used by the app",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Segoe UI",
                                    color: Colors.black,
                                    fontSize: 14 * scaleFactor),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                _launchUrl(0);
                              },
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "\n"
                                      "\nGoogle Play Services",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "Segoe UI",
                                      color: Colors.blue,
                                      fontSize: 14 * scaleFactor),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                _launchUrl(1);
                              },
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "\nGoogle Analytics for Firebase",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "Segoe UI",
                                      color: Colors.blue,
                                      fontSize: 14 * scaleFactor),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                _launchUrl(2);
                              },
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "\nFirebase Crashlytics",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "Segoe UI",
                                      color: Colors.blue,
                                      fontSize: 14 * scaleFactor),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                _launchUrl(3);
                              },
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "\nFacebook",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "Segoe UI",
                                      color: Colors.blue,
                                      fontSize: 14 * scaleFactor),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Cookies",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Segoe UI",
                                    color: Colors.black,
                                    fontSize: 14 * scaleFactor),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Cookies are files with a small amount of data commonly used as unique anonymous identifiers. These are sent to your browser from the websites you visit and stored on your device's internal memory."
                                    "\n"
                                    "\nThis Service does not use these \"cookies\" explicitly. However, the app may use third-party code and libraries that use \"cookies\" to collect information and improve their services. You have the option to either accept or refuse these cookies and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not use some portions of this Service.",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Segoe UI",
                                    color: Colors.black,
                                    fontSize: 14 * scaleFactor),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Service Providers",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Segoe UI",
                                    color: Colors.black,
                                    fontSize: 14 * scaleFactor),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "We may employ third-party companies and individuals due to the following reasons:"
                                    "\n"
                                    "\nTo facilitate our Service;"
                                    "\n"
                                    "\nTo provide the Service on our behalf;"
                                    "\n"
                                    "\nTo perform Service-related services; or"
                                    "\n"
                                    "\nTo assist us in analyzing how our Service is used."
                                    "\n"
                                    "\nWe want to inform users of this Service that these third parties have access to their Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose.",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Segoe UI",
                                    color: Colors.black,
                                    fontSize: 14 * scaleFactor),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Security",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Segoe UI",
                                    color: Colors.black,
                                    fontSize: 14 * scaleFactor),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "We value your trust in providing us with your Personal Information; thus, we strive to use commercially acceptable means of protecting it. But remember that no method of transmission over the Internet, or method of electronic storage is 100% secure and reliable, and we cannot guarantee its absolute security.",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Segoe UI",
                                    color: Colors.black,
                                    fontSize: 14 * scaleFactor),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Links to Other Sites",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Segoe UI",
                                    color: Colors.black,
                                    fontSize: 14 * scaleFactor),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "This Service may contain links to other sites. If you click on a third-party link, you will be directed to that site. Note that we do not operate these external sites. Therefore, we strongly advise you to review the Privacy Policy of these websites. We have no control over and assume no responsibility for any third-party sites or services' content, privacy policies, or practices.",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Segoe UI",
                                    color: Colors.black,
                                    fontSize: 14 * scaleFactor),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Children's Privacy",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Segoe UI",
                                    color: Colors.black,
                                    fontSize: 14 * scaleFactor),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "These Services do not address anyone under the age of 13. We do not knowingly collect personally identifiable information from children under 13 years of age. If we discover that a child under 13 has provided us with personal information, we immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please get in touch with us so that we will be able to take the necessary actions.",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Segoe UI",
                                    color: Colors.black,
                                    fontSize: 14 * scaleFactor),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Changes to This Privacy Policy",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Segoe UI",
                                    color: Colors.black,
                                    fontSize: 14 * scaleFactor),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "We may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Privacy Policy on this page.This policy is effective as of [effective date will be here]",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Segoe UI",
                                    color: Colors.black,
                                    fontSize: 14 * scaleFactor),
                                textAlign: TextAlign.justify,
                              ),
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
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "If you have any questions or suggestions about our Privacy Policy, do not hesitate to contact us at [email address]",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Segoe UI",
                                    color: Colors.black,
                                    fontSize: 14 * scaleFactor),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Account Deletion",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Segoe UI",
                                    color: Colors.black,
                                    fontSize: 14 * scaleFactor),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "We would hate to see you leave but in case you want to delete your account please contact our support team and they will be able to assist.",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Segoe UI",
                                    color: Colors.black,
                                    fontSize: 14 * scaleFactor),
                                textAlign: TextAlign.justify,
                              ),
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

  void _launchUrl(int id) async {
    print(id.toString());
    if(id == 0)
    {
      if (!await launch(MyStrings.googlePrivacyUrl)) throw 'Could not launch ${MyStrings.googlePrivacyUrl}';
    }
    else if(id == 1)
    {
      if (!await launch(MyStrings.googleAnalyticsUrl)) throw 'Could not launch ${MyStrings.googleAnalyticsUrl}';
    }
    else if(id == 2)
    {
      if (!await launch(MyStrings.firebaseUrl)) throw 'Could not launch ${MyStrings.firebaseUrl}';
    }
    else if(id == 3)
    {
      if (!await launch(MyStrings.facebookUrl)) throw 'Could not launch ${MyStrings.facebookUrl}';
    }
    else{
      throw 'Could not launch. Try Again !';
    }

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