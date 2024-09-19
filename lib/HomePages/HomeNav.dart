// ignore_for_file: file_names, use_build_context_synchronously, empty_catches, non_constant_identifier_names

import 'dart:async';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scroll_loop_auto_scroll/scroll_loop_auto_scroll.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siz/Controllers/BottomNavController.dart';
import 'package:siz/HomePages/AddNav.dart';
import 'package:siz/LoginSignUp/AccuntCreate.dart';
import 'package:siz/LoginSignUp/BasicLoginInfo.dart';
import 'package:siz/LoginSignUp/LoginPage.dart';
import 'package:siz/Pages/AllOrderRequest.dart';
import 'package:siz/Pages/Cart.dart';
import 'package:siz/Pages/Home.dart';
import 'package:siz/Pages/MyProfile.dart';
import 'package:siz/Pages/ProductView.dart';
import 'package:siz/Pages/ProfileView.dart';
import 'package:siz/Pages/SearchPage.dart';
import 'package:siz/Pages/Wishlist.dart';
import 'package:siz/Utils/Colors.dart';
import 'dart:convert';

import 'dart:io';

import 'package:siz/Utils/Value.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:siz/Utils/firebase_api.dart';

class HomeNav extends StatefulWidget {
  const HomeNav({super.key});

  @override
  State<HomeNav> createState() => _HomeNavState();
}

class _HomeNavState extends State<HomeNav> {
  final BottomNavController controller = Get.put(BottomNavController());

  List<String> toplist = [
    'I SEE IT',
    'I WANT IT',
    'I RENT IT',
    'I GOT IT',
  ];

  List<String> dropDownList = [
    'Clothes',
    'Bags',
  ];

  Timer? checkTypingTimer;

  List<Map<String, dynamic>> closetslist = [
    {"image": "assets/images/girlimagerec.png", "name": "Diana Ganeeva"},
    {"image": "assets/images/imagerectangle2delete.png", "name": "Kelly Marie"},
  ];
  List<Map<String, dynamic>> mostrentalList = [
    {
      "image": "assets/images/girlrect2.png",
      "name": "Zimmermann",
      "size": "SIZE 1",
      "rent": "RENT AED 960",
      "retail": "Retail AED 6,400",
    },
    {
      "image": "assets/images/girlrect3.png",
      "name": "Elisabetta Franchi",
      "size": "SIZE IT 38",
      "rent": "RENT AED 754",
      "retail": "Retail AED 3,770",
    },
  ];

  String earningCategory = "";
  TextEditingController retailcontroler = TextEditingController();
  String enterRetailPrice = "";

  int earning3Days = 0;
  int earning8Days = 0;
  int earning20Days = 0;

  bool tabafterfirst = false;
  bool showarrowsearch = false;
  String visiblityEarning = "";
  String searchInputValue = "";

  List<Map<dynamic, dynamic>> searchlist = [
    {"keyword": "Ralph Lauren"},
    {"keyword": "Louis Vuitton"},
    {"keyword": "Michael kors"},
    {"keyword": "Fendi"},
    {"keyword": "Pinko"},
    {"keyword": "Nadine Merabi"},
    {"keyword": "Louis Vuitton"},
    {"keyword": "Michael kors"},
    {"keyword": "Other"},
  ];

  List<String> countList = [
    "my1",
    "my2",
    "my3",
    "my4",
    "my5",
    "my6",
  ];
  
  
   Map<String, dynamic> lenderResponse = {};
  List<dynamic> decordedLenderReponse = [];

  bool isLoadingMoreMRT = false;
  bool oncesCallMRT = false;
  bool noMoreDataMRT = false;
  bool showLazyIndicatorMRT = false;

  getLenders(int pageno) async {
    if (pageno <= 1) {
    } else {
      setState(() {
        showLazyIndicatorMRT = true;
      });
    }

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      final response = await http.post(Uri.parse(SizValue.homeLenders), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey).toString(),
        'page': pageno.toString()
      });

      lenderResponse = jsonDecode(response.body);

      if (lenderResponse["success"] == true) {
        if (pageno <= 1) {
          setState(() {
            decordedLenderReponse = lenderResponse["user_list"];
           
            isLoadingMoreMRT = false;
            oncesCallMRT = false;
          });
        } else {
          setState(() {
            decordedLenderReponse.addAll(lenderResponse["user_list"]);
            isLoadingMoreMRT = false;
            oncesCallMRT = false;
          });
        }

        if (lenderResponse["user_list"].toString() == "[]") {
          setState(() {
            noMoreDataMRT = true;
            isLoadingMoreMRT = false;
            oncesCallMRT = false;
          });
        }

        if (pageno <= 1) {
        } else {
          setState(() {
            showLazyIndicatorMRT = false;
          });
        }
      } else if (lenderResponse["success"] == false) {
        if (pageno <= 1) {
        } else {
          setState(() {
            showLazyIndicatorMRT = false;
          });
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(lenderResponse["error"].toString(),
                style: GoogleFonts.lexendDeca(
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                    color: Colors.white))));
      }
    } on ClientException {
      if (pageno <= 1) {
      } else {
        setState(() {
          showLazyIndicatorMRT = false;
        });
      }
      mysnackbar(
          "Server not responding please try again after sometimev fg", context);
    } on SocketException {
      if (pageno <= 1) {
      } else {
        setState(() {
          showLazyIndicatorMRT = false;
        });
      }
      mysnackbar(
          "No Internet connection 😑 please try again after sometime", context);
    } on HttpException {
      if (pageno <= 1) {
      } else {
        setState(() {
          showLazyIndicatorMRT = false;
        });
      }
      mysnackbar("Something went wrong please try after sometime", context);
    } on FormatException {
      if (pageno <= 1) {
      } else {
        setState(() {
          showLazyIndicatorMRT = false;
        });
      }
      mysnackbar("Something went wrong please try after sometime", context);
    }
  }

  // search data ================================================================================

  Map<String, dynamic> searchResponse = {};
  List<dynamic> searchDecordedList = [];

  getSearch(String value) async {
    try {
      final response = await http.post(Uri.parse(SizValue.searchSuggestion),
          body: {'user_key': "", 'search': value});

      searchResponse = jsonDecode(response.body);

      if (searchResponse["success"] == true) {
        setState(() {
          searchDecordedList = searchResponse["list"];
        });
      } else if (searchResponse["success"] == false) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(searchResponse["error"].toString(),
                style: GoogleFonts.lexendDeca(
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                    color: Colors.white))));
      }
    } catch (e) {}
  }

// calculate earning =========================================================

  Map<String, dynamic> calulateReponse = {};

  calculateEarning() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    dialodShow(context);
    try {
      final response =
          await http.post(Uri.parse(SizValue.calculateEarning), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey).toString(),
        "retail_price": retailcontroler.text,
        'type': "2",
      });

      calulateReponse = jsonDecode(response.body);

      if (calulateReponse["success"] == true) {
        setState(() {
          Navigator.pop(context);
        });
      } else if (calulateReponse["success"] == false) {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(calulateReponse["error"].toString(),
                style: GoogleFonts.lexendDeca(
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                    color: Colors.white))));
      }
    } on ClientException {
      Navigator.pop(context);
      mysnackbar(
          "Server not responding please try again after sometimev fg", context);
    } on SocketException {
      Navigator.pop(context);
      mysnackbar(
          "No Internet connection 😑 please try again after sometime", context);
    } on HttpException {
      Navigator.pop(context);
      mysnackbar("Something went wrong please try after sometime", context);
    } on FormatException {
      Navigator.pop(context);
      mysnackbar("Something went wrong please try after sometime", context);
    }
  }

  checkwelcomeDialog() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString(SizValue.welcomeDialog).toString() ==
        "null") {
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) {
          welcomeDialogFirst();
        }
      });
    } else if (sharedPreferences
        .getString(SizValue.welcomeDialog)
        .toString()
        .isEmpty) {
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) {
          welcomeDialogFirst();
        }
      });
    }
  }

  validateEmail(String email) {
    final bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    return emailValid;
  }

  TextEditingController welcomeTextController = TextEditingController();

  welcomeDialogFirst() {
    return showGeneralDialog(
        context: context,
        pageBuilder: (_, __, ___) {
          return Center(
            child: Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              height: 400,
              width: MediaQuery.of(context).size.width,
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: Colors.transparent,
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/appiconpng.png",
                      width: 50,
                      height: 50,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Text(
                        "Join us and Enjoy",
                        style: GoogleFonts.lexendDeca(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: Text(
                        "10% OFF",
                        style: GoogleFonts.lexendDeca(
                            fontSize: 30,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: Text(
                        "Be part of the SIZTERHOOD and get 10% off your first designer rental!",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lexendDeca(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 245, 245, 245),
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5))),
                      child: TextFormField(
                        controller: welcomeTextController,
                        style: GoogleFonts.lexendDeca(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w300),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Email",
                          hintStyle: GoogleFonts.lexendDeca(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        if (welcomeTextController.text.isEmpty) {
                          Flushbar(
                            flushbarStyle: FlushbarStyle.GROUNDED,
                            backgroundColor: Colors.black,
                            messageText: Text("Please enter email",
                                style: GoogleFonts.lexendDeca(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white)),
                            duration: const Duration(seconds: 3),
                          ).show(context);
                        } else if (!validateEmail(welcomeTextController.text)) {
                          Flushbar(
                            flushbarStyle: FlushbarStyle.GROUNDED,
                            backgroundColor: Colors.black,
                            messageText: Text("Please enter valid email",
                                style: GoogleFonts.lexendDeca(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white)),
                            duration: const Duration(seconds: 3),
                          ).show(context);
                        } else {
                          Navigator.pop(context);
                          emailRegistered();
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: MyColors.themecolor,
                            borderRadius: BorderRadius.circular(5)),
                        margin: const EdgeInsets.only(top: 15),
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        alignment: Alignment.center,
                        child: Text(
                          "Get 10% OFF".toUpperCase(),
                          style: GoogleFonts.lexendExa(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    InkWell(
                      splashFactory: NoSplash.splashFactory,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        sharedPreferences.setString(
                            SizValue.welcomeDialog, "1");
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 20),
                        alignment: Alignment.center,
                        child: Text(
                          "No, Thanks",
                          style: GoogleFonts.lexendDeca(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  welcomeDialogSecond(String promoCode) {
    return showDialog(
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Center(
              child: Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                height: 280,
                width: MediaQuery.of(context).size.width,
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  backgroundColor: Colors.transparent,
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 30, width: 30),
                          Image.asset(
                            "assets/images/appiconpng.png",
                            width: 50,
                            height: 50,
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                  margin: const EdgeInsets.only(bottom: 40),
                                  width: 30,
                                  alignment: Alignment.center,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 248, 248, 248),
                                      border: Border.all(
                                          width: 1, color: Colors.grey),
                                      shape: BoxShape.circle),
                                  child: SvgPicture.asset(
                                      "assets/images/close.svg",
                                      width: 15,
                                      height: 15)))
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: Text(
                          "Great Decision",
                          style: GoogleFonts.lexendDeca(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: Text(
                          "Use coupon code below to claim 10% discount on your first rental",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lexendDeca(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 247, 247, 247),
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                width: 1,
                                color:
                                    const Color.fromARGB(255, 213, 213, 213))),
                        margin: const EdgeInsets.only(top: 15),
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        alignment: Alignment.center,
                        child: Wrap(
                          children: [
                            Text(
                              promoCode.toUpperCase(),
                              style: GoogleFonts.lexendExa(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  color: MyColors.themecolor),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            InkWell(
                                onTap: () async {
                                  await Clipboard.setData(
                                      ClipboardData(text: promoCode));

                                  Flushbar(
                                    flushbarStyle: FlushbarStyle.GROUNDED,
                                    backgroundColor: Colors.black,
                                    messageText: Text("Copied Successfully",
                                        style: GoogleFonts.lexendDeca(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.white)),
                                    duration: const Duration(seconds: 3),
                                  ).show(context);
                                },
                                child: const Icon(
                                  Icons.copy_all_outlined,
                                  color: MyColors.themecolor,
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

// registeresd email =====================================================================================

  Map<String, dynamic> registeredEmailResponse = {};

  emailRegistered() async {
    dialodShow(context);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      final response = await http.post(Uri.parse(SizValue.newslettersignup),
          body: {'email': welcomeTextController.text});

      registeredEmailResponse = jsonDecode(response.body);

      if (registeredEmailResponse["success"] == true) {
        Navigator.pop(context);

        sharedPreferences.setString(SizValue.welcomeDialog, "1");

        welcomeDialogSecond(registeredEmailResponse["code"].toString());

        print(
            "registered email =====    " + registeredEmailResponse.toString());
      } else if (registeredEmailResponse["success"] == false) {
        Navigator.pop(context);

        Flushbar(
          flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.black,
          messageText: Text(registeredEmailResponse["error"].toString(),
              style: GoogleFonts.lexendDeca(
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                  color: Colors.white)),
          duration: const Duration(seconds: 3),
        ).show(context);
      }
    } catch (e) {
      Navigator.pop(context);

      Flushbar(
        flushbarStyle: FlushbarStyle.GROUNDED,
        backgroundColor: Colors.black,
        messageText: Text("Something went wrong",
            style: GoogleFonts.lexendDeca(
                fontSize: 13,
                fontWeight: FontWeight.w300,
                color: Colors.white)),
        duration: const Duration(seconds: 3),
      ).show(context);
    }
  }

  // snackbar ==================================================================================================

  mysnackbar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 1),
        content: Text(message,
            style: GoogleFonts.lexendDeca(
                fontSize: 13,
                fontWeight: FontWeight.w300,
                color: Colors.white))));
  }

  // simple dialog =============================================================================================

  dialodShow(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return const Center(
                child: CircularProgressIndicator(
                  color: MyColors.themecolor,
                ),
              );
            });
      },
    );
  }

  @override
  void initState() {
    checkFirebaseError();

    _scrollControllerMRT.addListener(() async {
      scrollListenerMRT();
    });

    FirebaseApi().initNotifications(context);

    checkwelcomeDialog();
    super.initState();
  }

  checkFirebaseError() async {
    try {
      final firebaseMessaging = FirebaseMessaging.instance;
      final FCMToken = await firebaseMessaging.getToken();
     

      if(await controller.getHomeData(context, FCMToken.toString()))
      {

         getLenders(1);

      }
    } catch (e) {

       if(await controller.getHomeData(context, ""))
      {

         getLenders(1);

      }

    
    }
  }

  final ScrollController _scrollControllerMRT = ScrollController();
  int pagenoMRT = 1;

  Future<void> scrollListenerMRT() async {
    if (isLoadingMoreMRT) return;

    _scrollControllerMRT.addListener(() {
      if (_scrollControllerMRT.offset >=
          _scrollControllerMRT.position.maxScrollExtent - 200) {
        setState(() {
          isLoadingMoreMRT = true;
        });

        if (!oncesCallMRT) {
          if (noMoreDataMRT) {
            return;
          } else {
            getLenders(++pagenoMRT);

            setState(() {
              oncesCallMRT = true;
            });
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: BottomNavController(),
      builder: (controller) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Stack(
                children: [
                  // top main image========================================================================================
                  Container(
                    margin: const EdgeInsets.only(top: 170),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Image.asset(
                              "assets/images/homeimage.png",
                              height: 485,
                              width: MediaQuery.of(context).size.width,
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 60),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      // show rental details screen dialog =====================================

                                      showDialogRental();
                                    },
                                    child: Container(
                                      width: 160,
                                      alignment: Alignment.center,
                                      height: 40,
                                      margin: const EdgeInsets.only(right: 4.5),
                                      decoration: const BoxDecoration(
                                          borderRadius:
                                              BorderRadius.all(Radius.circular(7)),
                                          color: MyColors.themecolor),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text("BECOME A",
                                              style: GoogleFonts.lexendExa(
                                                  color: Colors.white,
                                                  fontSize: 8,
                                                  letterSpacing: 2,
                                                  fontWeight: FontWeight.w300)),
                                          Text("RENTER",
                                              style: GoogleFonts.lexendExa(
                                                  letterSpacing: 1,
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w300))
                                        ],
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      SharedPreferences sharedPreferences =
                                          await SharedPreferences.getInstance();

                                      if (sharedPreferences
                                              .getString(SizValue.isLogged)
                                              .toString() ==
                                          "null") {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginPage(otpNumber: "")));
                                      } else if (sharedPreferences
                                              .getString(SizValue.isLogged)
                                              .toString() ==
                                          "1") {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BasicLoginInfo(
                                                        fromWhere: sharedPreferences
                                                            .getString(
                                                                SizValue.source)
                                                            .toString())));
                                      } else if (sharedPreferences
                                              .getString(SizValue.isLogged)
                                              .toString() ==
                                          "2") {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AccountCreate()));
                                      } else if (sharedPreferences
                                              .getString(SizValue.underReview)
                                              .toString() ==
                                          "0") {
                                        showReviewdialog(
                                            sharedPreferences
                                                .getString(SizValue.underReviewMsg)
                                                .toString(),
                                            sharedPreferences
                                                .getString(SizValue.underReview)
                                                .toString());
                                      } else if (sharedPreferences
                                              .getString(SizValue.underReview)
                                              .toString() ==
                                          "2") {
                                        showReviewdialog(
                                            sharedPreferences
                                                .getString(
                                                    SizValue.rejectedReviewMSG)
                                                .toString(),
                                            sharedPreferences
                                                .getString(SizValue.underReview)
                                                .toString());
                                      } else if (sharedPreferences
                                              .getString(SizValue.underReview)
                                              .toString() ==
                                          "3") {
                                        showReviewdialog(
                                            sharedPreferences
                                                .getString(
                                                    SizValue.incompleteMessage)
                                                .toString(),
                                            sharedPreferences
                                                .getString(SizValue.underReview)
                                                .toString());
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => AddNav(
                                                      fromhome: false,
                                                    )));
                                      }
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                        left: 4.5,
                                      ),
                                      width: 160,
                                      alignment: Alignment.center,
                                      height: 40,
                                      decoration: const BoxDecoration(
                                          borderRadius:
                                              BorderRadius.all(Radius.circular(7)),
                                          color: Color(0xffF6F5F1)),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text("BECOME A",
                                              style: GoogleFonts.lexendExa(
                                                  color: Colors.black,
                                                  fontSize: 8,
                                                  letterSpacing: 2,
                                                  fontWeight: FontWeight.w300)),
                                          Text("LENDER",
                                              style: GoogleFonts.lexendExa(
                                                  color: Colors.black,
                                                  letterSpacing: 1,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w300))
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),

                        const SizedBox(height: 30),

                        // brands horizontal slide================================================================================

                        ScrollLoopAutoScroll(
                            //required
                            scrollDirection: Axis.horizontal, //required
                            delay: const Duration(seconds: 1),
                            duration: const Duration(seconds: 300),
                            gap: 0,
                            reverseScroll: false,
                            // duplicateChild: 25,
                            enableScrollInput: true,
                            delayAfterScrollInput: const Duration(seconds: 1),
                            child: Row(
                              children: [
                                Container(
                                  height: 30,
                                  margin:
                                      const EdgeInsets.only(left: 10, right: 10),
                                  child: Image.asset(
                                    "assets/images/brand1.png",
                                    height: 57,
                                  ),
                                ),
                                Container(
                                  height: 30,
                                  margin:
                                      const EdgeInsets.only(left: 10, right: 10),
                                  child: Image.asset(
                                    "assets/images/brand2.png",
                                    height: 57,
                                  ),
                                ),
                                Container(
                                  height: 30,
                                  margin:
                                      const EdgeInsets.only(left: 10, right: 10),
                                  child: Image.asset(
                                    "assets/images/brand3.png",
                                    height: 57,
                                  ),
                                ),
                                Container(
                                  height: 30,
                                  margin:
                                      const EdgeInsets.only(left: 10, right: 10),
                                  child: Image.asset(
                                    "assets/images/brand4.png",
                                    height: 57,
                                  ),
                                ),
                                Container(
                                  height: 30,
                                  margin:
                                      const EdgeInsets.only(left: 10, right: 10),
                                  child: Image.asset(
                                    "assets/images/brand5.png",
                                    height: 57,
                                  ),
                                ),
                              ],
                            )),

                        const SizedBox(height: 20),

                        // Text center rent wardrobe===========================================================================

                        Container(
                          margin: const EdgeInsets.only(
                            top: 10,
                          ),
                          child: Text(
                            "Rent their closets",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.dmSerifDisplay(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                        ),

                        Container(
                          margin: const EdgeInsets.only(top: 11, bottom: 20),
                          width: 50,
                          height: 1,
                          color: Colors.black,
                        ),

                        // horizontal list =========================================================================================

                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          height: 300,
                          child: Stack(
                            children: [
                              ListView.builder(
                                controller: _scrollControllerMRT,
                                itemCount: decordedLenderReponse.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () async {
                                      SharedPreferences sharedPreferences =
                                          await SharedPreferences.getInstance();

                                      if (sharedPreferences
                                              .getString(SizValue.channelId)
                                              .toString() ==
                                          decordedLenderReponse[index]["id"]
                                              .toString()) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const MyProfile()));
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => ProfileView(
                                                      lenderId:
                                                          decordedLenderReponse[
                                                                  index]["id"]
                                                              .toString(),
                                                    )));
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Visibility(
                                            visible: index == 0 ? true : false,
                                            child: const SizedBox(width: 15)),
                                        Stack(
                                          alignment: Alignment.bottomRight,
                                          children: [
                                            CachedNetworkImage(
                                              imageUrl: decordedLenderReponse[index]
                                                      ["profile_img"]
                                                  .toString(),
                                              fit: BoxFit.cover,
                                              width: 200,
                                              height: 300,
                                            ),
                                            Container(
                                              width: 200,
                                              alignment: Alignment.bottomCenter,
                                              margin:
                                                  const EdgeInsets.only(bottom: 25),
                                              child: Text(
                                                "${decordedLenderReponse[index]["username"]}",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.dmSerifDisplay(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: Container(
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                margin: const EdgeInsets.all(5),
                                                height: 25,
                                                decoration: const BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(50))),
                                                child: Text(
                                                  decordedLenderReponse[index]
                                                          ["size"]
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight.w400,
                                                      color: MyColors.themecolor,
                                                      fontSize: 12),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(width: 10),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              Visibility(
                                visible: showLazyIndicatorMRT,
                                child: Positioned(
                                  right: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.only(right: 20),
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: const CircularProgressIndicator()),
                                ),
                              )
                            ],
                          ),
                        ),

                        // free delivery text and icon ============================================================================

                        InkWell(
                          onTap: () {
                            controller.addPages(1);
                            controller.updateIndex(1);
                          },
                          child: Container(
                              width: 200,
                              alignment: Alignment.center,
                              height: 40,
                              decoration: const BoxDecoration(
                                  color: MyColors.themecolor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              // padding: const EdgeInsets.only(
                              //     left: 20, right: 20, top: 15, bottom: 15),
                              child: Text("BROWSE CLOSETS",
                                  style: GoogleFonts.lexendExa(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300))),
                        ),

                        const SizedBox(height: 30),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 115,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/freedelivery.png",
                                    height: 50,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "Free delivery and pick up",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lexendDeca(
                                        color:
                                            const Color.fromARGB(255, 89, 89, 89),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 115,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/fitsize.png",
                                    height: 50,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "With fit guarantee policy",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lexendDeca(
                                        color:
                                            const Color.fromARGB(255, 89, 89, 89),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 115,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/verification.png",
                                    height: 50,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "With ID verification of sizters",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lexendDeca(
                                        color:
                                            const Color.fromARGB(255, 89, 89, 89),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 110,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/freedry.png",
                                    height: 50,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "Free drycleaning or bag spa",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lexendDeca(
                                        color:
                                            const Color.fromARGB(255, 89, 89, 89),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        // Text most rental ========================================================================================

                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: Text(
                            "Most Rented",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.dmSerifDisplay(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                        ),

                        Container(
                          margin: const EdgeInsets.only(top: 15, bottom: 15),
                          width: 50,
                          height: 1,
                          color: Colors.black,
                        ),

                        // horizontal list Most rented 1 =========================================================================================

                        SizedBox(
                          height: 400,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount:controller. productList.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProductView(
                                                index: 0,
                                                comesFrom: "",
                                                id:controller. productList[index]["id"]
                                                    .toString(),
                                                fromCart: false,
                                              )));
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(left: 18),
                                      child: Hero(
                                        tag:controller. productList[index]["image_id"]
                                            .toString(),
                                        child: CachedNetworkImage(
                                          imageUrl:controller. productList[index]["img_url"]
                                              .toString(),
                                          fit: BoxFit.cover,
                                          height: 300,
                                          width: 200,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 200,
                                      margin:
                                          const EdgeInsets.only(top: 5, left: 18),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            margin: const EdgeInsets.only(),
                                            child: Text(
                                            controller.  productList[index]["brand_name"]
                                                  .toString(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style: GoogleFonts.dmSerifDisplay(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                          controller.  productList[index]["title"].toString(),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.lexendDeca(
                                                color: const Color.fromARGB(
                                                    255, 83, 83, 83),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w300),
                                          ),
                                          const SizedBox(height: 7),
                                          Text(
                                          controller.  productList[index]["category_id"]
                                                        .toString() ==
                                                    "1"
                                                ? "RENT AED ${controller.productList[index]["rent_amount"]} | 3 DAYS"
                                                : "RENT AED ${controller.productList[index]["rent_amount"]} | 8 DAYS",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.lexendExa(
                                                color: MyColors.themecolor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w300),
                                          ),
                                          const SizedBox(height: 7),
                                          Text(
                                            "Retail AED ${controller.productList[index]["retail_price"]}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.lexendDeca(
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                color: const Color.fromARGB(
                                                    255, 89, 89, 89),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),

                        // Tab bar =============================================================================================

                        Container(
                          margin: const EdgeInsets.only(
                            top: 20,
                          ),
                          child: Text(
                            "How it works",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.dmSerifDisplay(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                        ),

                        Container(
                          margin: const EdgeInsets.only(top: 13, bottom: 15),
                          width: 50,
                          height: 1,
                          color: Colors.black,
                        ),

                        SizedBox(
                          height: 680,
                          child: DefaultTabController(
                            length: 2,
                            child: Column(
                              children: <Widget>[
                                ButtonsTabBar(
                                  radius: 5,
                                  backgroundColor: Colors.transparent,
                                  unselectedBackgroundColor: Colors.transparent,
                                  unselectedLabelStyle: GoogleFonts.lexendExa(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300),
                                  labelStyle: GoogleFonts.lexendExa(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300),
                                  tabs: [
                                    Tab(
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: 160,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color: MyColors.themecolor,
                                            borderRadius: BorderRadius.circular(5)),
                                        child: const Text(
                                          "HOW TO RENT",
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.white),
                                        ),
                                      ),
                                      // text: "",
                                    ),
                                    Tab(
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: 160,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.circular(5)),
                                        child: const Text(
                                          "HOW TO LEND",
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.white),
                                        ),
                                      ),
                                      // text: "",
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: TabBarView(
                                    children: <Widget>[
                                      // Tap one ===============================================================================================
                                      Column(
                                        children: [
                                          const SizedBox(height: 20),

                                          // step 1
                                          Stack(
                                            children: [
                                              Container(
                                                  height: 130,
                                                  margin: const EdgeInsets.only(
                                                      left: 55, right: 15),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.black,
                                                          width: 1),
                                                      color: Colors.white,
                                                      borderRadius:
                                                          const BorderRadius.only(
                                                              bottomRight:
                                                                  Radius.circular(
                                                                      60),
                                                              topLeft:
                                                                  Radius.circular(
                                                                      10),
                                                              topRight:
                                                                  Radius.circular(
                                                                      10),
                                                              bottomLeft:
                                                                  Radius.circular(
                                                                      10)),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                            color: Color.fromARGB(
                                                                255, 211, 211, 211),
                                                            blurRadius: 1,
                                                            offset: Offset(0.0, 4))
                                                      ])),
                                              Container(
                                                height: 130,
                                                margin: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: Row(
                                                  children: [
                                                    const SizedBox(width: 5),
                                                    Container(
                                                      width: 90,
                                                      height: 90,
                                                      alignment: Alignment.center,
                                                      decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: const Color(
                                                              0xffF5F6F1),
                                                          border: Border.all(
                                                              color: Colors.black,
                                                              width: 1)),
                                                      child: Image.asset(
                                                        "assets/images/rentfirst.png",
                                                        width: 50,
                                                        height: 50,
                                                      ),
                                                    ),
                                                    Flexible(
                                                      child: Container(
                                                          margin:
                                                              const EdgeInsets.only(
                                                                  right: 10,
                                                                  left: 15),
                                                          child: SizedBox(
                                                            width: 249,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "Browse",
                                                                  style: GoogleFonts.dmSerifDisplay(
                                                                      color: MyColors
                                                                          .themecolor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300),
                                                                ),
                                                                const SizedBox(
                                                                    height: 3),
                                                                Text(
                                                                  "Browse the most stylish closets on the\napp (you can filter items by size,\navailability, occasion, brand, and more!)\n\nPick a style you love from your sizter’s closet.",
                                                                  style: GoogleFonts.lexendDeca(
                                                                      color: const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          98,
                                                                          98,
                                                                          98),
                                                                      fontSize:
                                                                          10.5,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300),
                                                                ),
                                                                const SizedBox(
                                                                    height: 5),
                                                              ],
                                                            ),
                                                          )),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 20),

                                          // step 2
                                          Stack(
                                            children: [
                                              Container(
                                                  height: 130,
                                                  margin: const EdgeInsets.only(
                                                      right: 55, left: 15),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.black,
                                                          width: 1),
                                                      color: Colors.white,
                                                      borderRadius:
                                                          const BorderRadius.only(
                                                              bottomLeft:
                                                                  Radius.circular(
                                                                      60),
                                                              topLeft:
                                                                  Radius.circular(
                                                                      10),
                                                              topRight:
                                                                  Radius.circular(
                                                                      10),
                                                              bottomRight:
                                                                  Radius.circular(
                                                                      10)),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                            color: Color.fromARGB(
                                                                255, 211, 211, 211),
                                                            blurRadius: 1,
                                                            offset: Offset(0.0, 4))
                                                      ])),
                                              Container(
                                                height: 130,
                                                margin: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Flexible(
                                                          child: Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      right: 10,
                                                                      left: 10),
                                                              child: SizedBox(
                                                                width:
                                                                    MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Text(
                                                                      "Request rental",
                                                                      style: GoogleFonts.dmSerifDisplay(
                                                                          color: MyColors
                                                                              .themecolor,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w300),
                                                                    ),
                                                                    const SizedBox(
                                                                        height: 5),
                                                                    Text(
                                                                      "Choose dates, send your rental request,\nand communicate securely with the\n lender through our messaging system.\n\nYou will be charged once it’s accepted.",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .end,
                                                                      style: GoogleFonts.lexendDeca(
                                                                          color: const Color
                                                                              .fromARGB(
                                                                              255,
                                                                              98,
                                                                              98,
                                                                              98),
                                                                          fontSize:
                                                                              10.5,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w300),
                                                                    ),
                                                                    const SizedBox(
                                                                        height: 5),
                                                                  ],
                                                                ),
                                                              )),
                                                        ),
                                                        const SizedBox(width: 5),
                                                        Container(
                                                          width: 90,
                                                          height: 90,
                                                          alignment:
                                                              Alignment.center,
                                                          decoration: BoxDecoration(
                                                              shape:
                                                                  BoxShape.circle,
                                                              color: const Color(
                                                                  0xffF5F6F1),
                                                              border: Border.all(
                                                                  color:
                                                                      Colors.black,
                                                                  width: 1)),
                                                          child: Image.asset(
                                                            "assets/images/rentsecond.png",
                                                            width: 50,
                                                            height: 50,
                                                          ),
                                                        ),
                                                        const SizedBox(width: 5)
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),

                                          // step 3

                                          const SizedBox(height: 20),
                                          Stack(
                                            children: [
                                              Container(
                                                  height: 130,
                                                  margin: const EdgeInsets.only(
                                                      left: 55, right: 15),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.black,
                                                          width: 1),
                                                      color: Colors.white,
                                                      borderRadius:
                                                          const BorderRadius.only(
                                                              bottomRight:
                                                                  Radius.circular(
                                                                      60),
                                                              topLeft:
                                                                  Radius.circular(
                                                                      10),
                                                              topRight:
                                                                  Radius.circular(
                                                                      10),
                                                              bottomLeft:
                                                                  Radius.circular(
                                                                      10)),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                            color: Color.fromARGB(
                                                                255, 211, 211, 211),
                                                            blurRadius: 1,
                                                            offset: Offset(0.0, 4))
                                                      ])),
                                              Container(
                                                height: 130,
                                                margin: const EdgeInsets.only(
                                                    left: 15, right: 10),
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: 90,
                                                        height: 90,
                                                        alignment: Alignment.center,
                                                        decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: const Color(
                                                                0xffF5F6F1),
                                                            border: Border.all(
                                                                color: Colors.black,
                                                                width: 1)),
                                                        child: Image.asset(
                                                          "assets/images/rentthird.png",
                                                          width: 50,
                                                          height: 50,
                                                        ),
                                                      ),
                                                      Flexible(
                                                        child: Container(
                                                            margin: const EdgeInsets
                                                                .only(
                                                                right: 15,
                                                                left: 15),
                                                            child: SizedBox(
                                                              width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    "Wear",
                                                                    style: GoogleFonts.dmSerifDisplay(
                                                                        color: MyColors
                                                                            .themecolor,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w300),
                                                                  ),
                                                                  const SizedBox(
                                                                      height: 3),
                                                                  Text(
                                                                    "Receive your item and enjoy your outfit!\n\nWhen your rental period is up, just place your item back in the garment bag they came in. We'll handle the pick up and dry cleaning.",
                                                                    style: GoogleFonts.lexendDeca(
                                                                        color: const Color
                                                                            .fromARGB(
                                                                            255,
                                                                            98,
                                                                            98,
                                                                            98),
                                                                        fontSize:
                                                                            10.5,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w300),
                                                                  ),
                                                                  const SizedBox(
                                                                      height: 5),
                                                                ],
                                                              ),
                                                            )),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 20),

                                          // step 4
                                          Stack(
                                            children: [
                                              Container(
                                                  height: 130,
                                                  margin: const EdgeInsets.only(
                                                      right: 55, left: 15),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.black,
                                                          width: 1),
                                                      color: Colors.white,
                                                      borderRadius:
                                                          const BorderRadius.only(
                                                              bottomLeft:
                                                                  Radius.circular(
                                                                      60),
                                                              topLeft:
                                                                  Radius.circular(
                                                                      10),
                                                              topRight:
                                                                  Radius.circular(
                                                                      10),
                                                              bottomRight:
                                                                  Radius.circular(
                                                                      10)),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                            color: Color.fromARGB(
                                                                255, 211, 211, 211),
                                                            blurRadius: 1,
                                                            offset: Offset(0.0, 4))
                                                      ])),
                                              Container(
                                                height: 130,
                                                margin: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                padding: const EdgeInsets.only(
                                                    top: 10, bottom: 10),
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Row(
                                                    children: [
                                                      Flexible(
                                                        child: Container(
                                                            margin: const EdgeInsets
                                                                .only(
                                                                right: 10,
                                                                left: 10),
                                                            child: SizedBox(
                                                              width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Text(
                                                                    "Rate and review",
                                                                    style: GoogleFonts.dmSerifDisplay(
                                                                        color: MyColors
                                                                            .themecolor,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w300),
                                                                  ),
                                                                  const SizedBox(
                                                                      height: 3),
                                                                  Text(
                                                                    "After returning your rental, share your honest feedback with fellow Sizters and flaunt your fabulous look on socials.\n\nDon't forget to tag @sizters.app",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .end,
                                                                    style: GoogleFonts.lexendDeca(
                                                                        color: const Color
                                                                            .fromARGB(
                                                                            255,
                                                                            98,
                                                                            98,
                                                                            98),
                                                                        fontSize:
                                                                            10.5,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w300),
                                                                  ),
                                                                  const SizedBox(
                                                                      height: 5),
                                                                ],
                                                              ),
                                                            )),
                                                      ),
                                                      Container(
                                                        width: 90,
                                                        height: 90,
                                                        alignment: Alignment.center,
                                                        decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: const Color(
                                                                0xffF5F6F1),
                                                            border: Border.all(
                                                                color: Colors.black,
                                                                width: 1)),
                                                        child: Image.asset(
                                                          "assets/images/rentfour.png",
                                                          width: 50,
                                                          height: 50,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),

                                      // Tap 2 ===============================================================================================
                                      Column(
                                        children: [
                                          const SizedBox(height: 20),

                                          // step 1

                                          Stack(
                                            children: [
                                              Container(
                                                  height: 130,
                                                  margin: const EdgeInsets.only(
                                                      right: 55, left: 15),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.black,
                                                          width: 1),
                                                      color: Colors.white,
                                                      borderRadius:
                                                          const BorderRadius.only(
                                                              bottomLeft:
                                                                  Radius.circular(
                                                                      60),
                                                              topLeft:
                                                                  Radius.circular(
                                                                      10),
                                                              topRight:
                                                                  Radius.circular(
                                                                      10),
                                                              bottomRight:
                                                                  Radius.circular(
                                                                      10)),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                            color: Color.fromARGB(
                                                                255, 211, 211, 211),
                                                            blurRadius: 1,
                                                            offset: Offset(0.0, 4))
                                                      ])),
                                              Container(
                                                height: 130,
                                                margin: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Flexible(
                                                          child: Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      right: 10,
                                                                      left: 10),
                                                              child: SizedBox(
                                                                width:
                                                                    MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Text(
                                                                      "List",
                                                                      style: GoogleFonts.dmSerifDisplay(
                                                                          color: MyColors
                                                                              .themecolor,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w400),
                                                                    ),
                                                                    const SizedBox(
                                                                        height: 3),
                                                                    Text(
                                                                        "You can opt for a managed closet by siz:\nsend us items to store, list, and lend.\n\nOr list an item in under 2 minutes,\nkeep and manage your own rental\nlistings through our platform.",
                                                                        textAlign:
                                                                            TextAlign
                                                                                .end,
                                                                        style: GoogleFonts.lexendDeca(
                                                                            color: const Color
                                                                                .fromARGB(
                                                                                255,
                                                                                98,
                                                                                98,
                                                                                98),
                                                                            fontSize:
                                                                                10.5,
                                                                            fontWeight:
                                                                                FontWeight.w300)),
                                                                    const SizedBox(
                                                                        height: 5),
                                                                  ],
                                                                ),
                                                              )),
                                                        ),
                                                        Container(
                                                          width: 90,
                                                          height: 90,
                                                          alignment:
                                                              Alignment.center,
                                                          decoration: BoxDecoration(
                                                              shape:
                                                                  BoxShape.circle,
                                                              color: const Color(
                                                                  0xffF5F6F1),
                                                              border: Border.all(
                                                                  color:
                                                                      Colors.black,
                                                                  width: 1)),
                                                          child: Image.asset(
                                                            "assets/images/lendfirst.png",
                                                            width: 50,
                                                            height: 50,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 20),

                                          // step 2

                                          Stack(
                                            children: [
                                              Container(
                                                  height: 130,
                                                  margin: const EdgeInsets.only(
                                                      left: 55, right: 15),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.black,
                                                          width: 1),
                                                      color: Colors.white,
                                                      borderRadius:
                                                          const BorderRadius.only(
                                                              bottomRight:
                                                                  Radius.circular(
                                                                      60),
                                                              topLeft:
                                                                  Radius.circular(
                                                                      10),
                                                              topRight:
                                                                  Radius.circular(
                                                                      10),
                                                              bottomLeft:
                                                                  Radius.circular(
                                                                      10)),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                            color: Color.fromARGB(
                                                                255, 211, 211, 211),
                                                            blurRadius: 1,
                                                            offset: Offset(0.0, 4))
                                                      ])),
                                              Container(
                                                height: 130,
                                                margin: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: Row(
                                                  children: [
                                                    const SizedBox(width: 5),
                                                    Container(
                                                      width: 90,
                                                      height: 90,
                                                      alignment: Alignment.center,
                                                      decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: const Color(
                                                              0xffF5F6F1),
                                                          border: Border.all(
                                                              color: Colors.black,
                                                              width: 1)),
                                                      child: Image.asset(
                                                        "assets/images/lendseond.png",
                                                        width: 50,
                                                        height: 50,
                                                      ),
                                                    ),
                                                    Flexible(
                                                      child: Container(
                                                          margin:
                                                              const EdgeInsets.only(
                                                                  right: 10,
                                                                  left: 15),
                                                          child: SizedBox(
                                                            width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "Approve rental",
                                                                  style: GoogleFonts.dmSerifDisplay(
                                                                      color: MyColors
                                                                          .themecolor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                ),
                                                                const SizedBox(
                                                                    height: 3),
                                                                Text(
                                                                  "You have the choice to approve or decline\nall rental request that you receive.\n\nCommunicate directly with our team or\nyour potential renter via our secure\nmessaging system.",
                                                                  style: GoogleFonts.lexendDeca(
                                                                      color: const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          98,
                                                                          98,
                                                                          98),
                                                                      fontSize:
                                                                          10.5,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300),
                                                                ),
                                                                const SizedBox(
                                                                    height: 5),
                                                              ],
                                                            ),
                                                          )),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),

                                          // step 3

                                          const SizedBox(height: 20),

                                          Stack(
                                            children: [
                                              Container(
                                                  height: 130,
                                                  margin: const EdgeInsets.only(
                                                      right: 55, left: 15),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.black,
                                                          width: 1),
                                                      color: Colors.white,
                                                      borderRadius:
                                                          const BorderRadius.only(
                                                              bottomLeft:
                                                                  Radius.circular(
                                                                      60),
                                                              topLeft:
                                                                  Radius.circular(
                                                                      10),
                                                              topRight:
                                                                  Radius.circular(
                                                                      10),
                                                              bottomRight:
                                                                  Radius.circular(
                                                                      10)),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                            color: Color.fromARGB(
                                                                255, 211, 211, 211),
                                                            blurRadius: 1,
                                                            offset: Offset(0.0, 4))
                                                      ])),
                                              Container(
                                                height: 130,
                                                margin: const EdgeInsets.only(
                                                    left: 10, right: 15),
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Row(
                                                    children: [
                                                      Flexible(
                                                        child: Container(
                                                            margin: const EdgeInsets
                                                                .only(
                                                                right: 10,
                                                                left: 10),
                                                            child: SizedBox(
                                                              width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Text(
                                                                    "Ship",
                                                                    style: GoogleFonts.dmSerifDisplay(
                                                                        color: MyColors
                                                                            .themecolor,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400),
                                                                  ),
                                                                  const SizedBox(
                                                                      height: 3),
                                                                  Text(
                                                                      "We take care of everything from pick-up\nto return once dry cleaned for your\nhassle-free lending.\n\nAll you have to do is approve rental\nrequest!",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .end,
                                                                      style: GoogleFonts.lexendDeca(
                                                                          color: const Color
                                                                              .fromARGB(
                                                                              255,
                                                                              98,
                                                                              98,
                                                                              98),
                                                                          fontSize:
                                                                              10.5,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w300)),
                                                                  const SizedBox(
                                                                      height: 5),
                                                                ],
                                                              ),
                                                            )),
                                                      ),
                                                      const SizedBox(width: 5),
                                                      Container(
                                                        width: 90,
                                                        height: 90,
                                                        alignment: Alignment.center,
                                                        decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: const Color(
                                                                0xffF5F6F1),
                                                            border: Border.all(
                                                                color: Colors.black,
                                                                width: 1)),
                                                        child: Image.asset(
                                                          "assets/images/lendthird.png",
                                                          width: 50,
                                                          height: 50,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 20),

                                          // step 4

                                          Stack(
                                            children: [
                                              Container(
                                                  height: 130,
                                                  margin: const EdgeInsets.only(
                                                      left: 55, right: 15),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.black,
                                                          width: 1),
                                                      color: Colors.white,
                                                      borderRadius:
                                                          const BorderRadius.only(
                                                              bottomRight:
                                                                  Radius.circular(
                                                                      60),
                                                              topLeft:
                                                                  Radius.circular(
                                                                      10),
                                                              topRight:
                                                                  Radius.circular(
                                                                      10),
                                                              bottomLeft:
                                                                  Radius.circular(
                                                                      10)),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                            color: Color.fromARGB(
                                                                255, 211, 211, 211),
                                                            blurRadius: 1,
                                                            offset: Offset(0.0, 4))
                                                      ])),
                                              Container(
                                                height: 130,
                                                margin: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: Row(
                                                  children: [
                                                    const SizedBox(width: 5),
                                                    Container(
                                                      width: 90,
                                                      height: 90,
                                                      alignment: Alignment.center,
                                                      decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: const Color(
                                                              0xffF5F6F1),
                                                          border: Border.all(
                                                              color: Colors.black,
                                                              width: 1)),
                                                      child: Image.asset(
                                                        "assets/images/lendfour.png",
                                                        width: 50,
                                                        height: 50,
                                                      ),
                                                    ),
                                                    Flexible(
                                                      child: Container(
                                                          margin:
                                                              const EdgeInsets.only(
                                                                  right: 10,
                                                                  left: 15),
                                                          child: SizedBox(
                                                            width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "Get paid and review",
                                                                  style: GoogleFonts.dmSerifDisplay(
                                                                      color: MyColors
                                                                          .themecolor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                ),
                                                                const SizedBox(
                                                                    height: 3),
                                                                Text(
                                                                    "Once your rental is completed, payment\nto your bank account will be processed\nwithin 10-15 days.\n\nLeave honest feedback for your fellow\nsizters!",
                                                                    style: GoogleFonts.lexendDeca(
                                                                        color: const Color
                                                                            .fromARGB(
                                                                            255,
                                                                            98,
                                                                            98,
                                                                            98),
                                                                        fontSize:
                                                                            10.5,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w300)),
                                                                const SizedBox(
                                                                    height: 5),
                                                              ],
                                                            ),
                                                          )),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        InkWell(
                          onTap: () {
                            showDialogRental();
                          },
                          child: Container(
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                  color: MyColors.themecolor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              height: 40,
                              width: 200,
                              child: Text("START RENTING",
                                  style: GoogleFonts.lexendExa(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300))),
                        ),

                        const SizedBox(height: 25),

                        // how much earn box with textformfield ========================================================================================

                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset("assets/images/Rectangle.png"),
                            Container(
                              margin: const EdgeInsets.only(top: 15),
                              child: Text(
                                "Do you have designer items you don't get to wear but you're\nnot ready to let go of them yet?\nIs your closet full of luxury pieces your don't use anymore?\n\nLend them now!",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lexendDeca(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        InkWell(
                          onTap: () async {
                            SharedPreferences sharedPreferences =
                                await SharedPreferences.getInstance();

                            if (sharedPreferences
                                    .getString(SizValue.isLogged)
                                    .toString() ==
                                "null") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          LoginPage(otpNumber: "")));
                            } else if (sharedPreferences
                                    .getString(SizValue.isLogged)
                                    .toString() ==
                                "1") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BasicLoginInfo(
                                          fromWhere: sharedPreferences
                                              .getString(SizValue.source)
                                              .toString())));
                            } else if (sharedPreferences
                                    .getString(SizValue.isLogged)
                                    .toString() ==
                                "2") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AccountCreate()));
                            } else if (sharedPreferences
                                    .getString(SizValue.underReview)
                                    .toString() ==
                                "0") {
                              showReviewdialog(
                                  sharedPreferences
                                      .getString(SizValue.underReviewMsg)
                                      .toString(),
                                  sharedPreferences
                                      .getString(SizValue.underReview)
                                      .toString());
                            } else if (sharedPreferences
                                    .getString(SizValue.underReview)
                                    .toString() ==
                                "2") {
                              showReviewdialog(
                                  sharedPreferences
                                      .getString(SizValue.rejectedReviewMSG)
                                      .toString(),
                                  sharedPreferences
                                      .getString(SizValue.underReview)
                                      .toString());
                            } else if (sharedPreferences
                                    .getString(SizValue.underReview)
                                    .toString() ==
                                "3") {
                              showReviewdialog(
                                  sharedPreferences
                                      .getString(SizValue.incompleteMessage)
                                      .toString(),
                                  sharedPreferences
                                      .getString(SizValue.underReview)
                                      .toString());
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddNav(
                                            fromhome: false,
                                          )));
                            }
                          },
                          child: Container(
                              alignment: Alignment.center,
                              width: 200,
                              decoration: const BoxDecoration(
                                  color: MyColors.themecolor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              height: 40,
                              child: Text("START LENDING",
                                  style: GoogleFonts.lexendExa(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300))),
                        ),

                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 20, right: 20),
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: Text(
                                  "How much can I earn with siz?",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.dmSerifDisplay(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),

                              Container(
                                margin: const EdgeInsets.only(top: 15, bottom: 20),
                                width: 50,
                                height: 1,
                                color: Colors.black,
                              ),
                              // textformfield category
                              // drop down ==================================================

                              // Row of items ==================================================

                              Row(
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                      
                                     
                                       decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Colors.grey,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5))),

                                             
                                      margin: const EdgeInsets.only(right: 5),
                                      child: CustomDropdown<String>(
                                        hideSelectedFieldWhenExpanded: false,
                                        hintText: 'Select Category',
                                        items: dropDownList,
                                        excludeSelected: false,
                                       
                                        // expandedBorder: Border.all(color: Colors.black),
                                        headerBuilder: (context, selectedItem) {
                                          return Text(
                                            selectedItem,
                                            style: GoogleFonts.lexendDeca(
                                                fontSize: 12,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w300),
                                          );
                                        },

                                        listItemBuilder: (context, item) {
                                          return Text(item,
                                              style: GoogleFonts.lexendDeca(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.black));
                                        },

                                        hintBuilder: (context, hint) {
                                          return Text(
                                            hint,
                                            style: GoogleFonts.lexendDeca(
                                                fontSize: 12,
                                                color: const Color.fromARGB(
                                                    255, 179, 179, 179),
                                                fontWeight: FontWeight.w300),
                                          );
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            earningCategory = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          bottom: 4, left: 12),
                                      alignment: Alignment.centerLeft,
                                      height: 50,
                                      margin: const EdgeInsets.only(left: 5),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Colors.grey,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5))),
                                      width: MediaQuery.of(context).size.width,
                                      child: TextFormField(
                                        controller: retailcontroler,
                                        maxLength: 5,
                                        style: GoogleFonts.lexendDeca(
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w300),
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          counterText: "",
                                          border: InputBorder.none,
                                          hintText: "Enter Retail Price",
                                          hintStyle: GoogleFonts.lexendDeca(
                                              fontSize: 12,
                                              color: const Color.fromARGB(
                                                  255, 179, 179, 179),
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 15),

                              InkWell(
                                onTap: () async {
                                  if (earningCategory.isEmpty) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text("Please select category",
                                          style: GoogleFonts.lexendDeca(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.white)),
                                      duration: const Duration(seconds: 1),
                                    ));
                                  } else if (retailcontroler.text.isEmpty) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text("Please enter retail price",
                                          style: GoogleFonts.lexendDeca(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.white)),
                                      duration: const Duration(seconds: 1),
                                    ));
                                  } else if (int.parse(retailcontroler.text) <
                                      500) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content:
                                          Text("Price cannot be less than 500"),
                                      duration: Duration(seconds: 1),
                                    ));
                                  } else {
                                    if (earningCategory == "Clothes") {
                                      await calculateEarning();

                                      setState(() {
                                        visiblityEarning = "Clothes";
                                      });
                                    } else {
                                      await calculateEarning();

                                      setState(() {
                                        visiblityEarning = "Bags";
                                      });
                                    }
                                  }
                                },
                                child: Container(
                                    alignment: Alignment.center,
                                    height: 40,
                                    width: 200,
                                    decoration: const BoxDecoration(
                                        color: MyColors.themecolor,
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(5))),
                                    child: Text("CALCULATE",
                                        style: GoogleFonts.lexendExa(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300))),
                              ),

                              const SizedBox(height: 10),

                              // for clothes earning ============================================================================================

                              visiblityEarning == "Clothes"
                                  ?

                                  // for clothes earning ============================================================================================

                                  Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        // close icon

                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              visiblityEarning = "";

                                              retailcontroler.text = "";
                                            });
                                          },
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            child: const Icon(
                                              Icons.close,
                                              size: 18,
                                            ),
                                          ),
                                        ),

                                        //  estimated earning text

                                        Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Estimated Earnings",
                                            style: GoogleFonts.dmSerifDisplay(
                                                fontSize: 20, color: Colors.black),
                                          ),
                                        ),

                                        // heading of days

                                        const SizedBox(height: 10),

                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              margin:
                                                  const EdgeInsets.only(right: 5),
                                              alignment: Alignment.center,
                                              width: 100,
                                              height: 30,
                                              color: const Color(0x0fff6f51),
                                              child: Text(
                                                "3 DAYS",
                                                style: GoogleFonts.lexendExa(
                                                    fontSize: 12,
                                                    color: Colors.black),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              width: 100,
                                              height: 30,
                                              color: const Color(0x0fff6f51),
                                              child: Text(
                                                "8 DAYS",
                                                style: GoogleFonts.lexendExa(
                                                    fontSize: 12,
                                                    color: Colors.black),
                                              ),
                                            ),
                                            Container(
                                              margin:
                                                  const EdgeInsets.only(left: 5),
                                              alignment: Alignment.center,
                                              width: 100,
                                              height: 30,
                                              color: const Color(0x0fff6f51),
                                              child: Text(
                                                "20 DAYS",
                                                style: GoogleFonts.lexendExa(
                                                    fontSize: 12,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 5),

                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              margin:
                                                  const EdgeInsets.only(right: 5),
                                              alignment: Alignment.center,
                                              width: 100,
                                              height: 30,
                                              color: const Color(0x0fff6f51),
                                              child: Text(
                                                calulateReponse.isEmpty
                                                    ? ""
                                                    : "AED ${calulateReponse["earn_3_days"]}",
                                                style: GoogleFonts.lexendExa(
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 16,
                                                    color: MyColors.themecolor),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              width: 100,
                                              height: 30,
                                              color: const Color(0x0fff6f51),
                                              child: Text(
                                                calulateReponse.isEmpty
                                                    ? ""
                                                    : "AED ${calulateReponse["earn_8_days"]}",
                                                style: GoogleFonts.lexendExa(
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 16,
                                                    color: MyColors.themecolor),
                                              ),
                                            ),
                                            Container(
                                              margin:
                                                  const EdgeInsets.only(left: 5),
                                              alignment: Alignment.center,
                                              width: 100,
                                              height: 30,
                                              color: const Color(0x0fff6f51),
                                              child: Text(
                                                calulateReponse.isEmpty
                                                    ? ""
                                                    : "AED ${calulateReponse["earn_20_days"]}",
                                                style: GoogleFonts.lexendExa(
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 16,
                                                    color: MyColors.themecolor),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  : visiblityEarning == "Bags"
                                      ?
                                      // for bags earning ============================================================================================

                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            // close icon

                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  visiblityEarning = "";

                                                  retailcontroler.text = "";
                                                });
                                              },
                                              child: Container(
                                                alignment: Alignment.centerRight,
                                                child: const Icon(
                                                  Icons.close,
                                                  size: 18,
                                                ),
                                              ),
                                            ),

                                            //  estimated earning text

                                            Container(
                                              alignment: Alignment.center,
                                              child: Text(
                                                "Estimated Earnings",
                                                style: GoogleFonts.dmSerifDisplay(
                                                    fontSize: 20,
                                                    color: Colors.black),
                                              ),
                                            ),

                                            // heading of days

                                            const SizedBox(height: 10),

                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 5),
                                                  alignment: Alignment.center,
                                                  width: 100,
                                                  height: 30,
                                                  color: const Color(0x0fff6f51),
                                                  child: Text(
                                                    "8 DAYS",
                                                    style: GoogleFonts.lexendExa(
                                                        fontSize: 12,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  width: 100,
                                                  height: 30,
                                                  color: const Color(0x0fff6f51),
                                                  child: Text(
                                                    "20 DAYS",
                                                    style: GoogleFonts.lexendExa(
                                                        fontSize: 12,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            const SizedBox(height: 5),

                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 5),
                                                  alignment: Alignment.center,
                                                  width: 100,
                                                  height: 30,
                                                  color: const Color(0x0fff6f51),
                                                  child: Text(
                                                    calulateReponse.isEmpty
                                                        ? ""
                                                        : "AED ${calulateReponse["earn_8_days"]}",
                                                    style: GoogleFonts.lexendExa(
                                                        fontWeight: FontWeight.w300,
                                                        fontSize: 16,
                                                        color: MyColors.themecolor),
                                                  ),
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  width: 100,
                                                  height: 30,
                                                  color: const Color(0x0fff6f51),
                                                  child: Text(
                                                    calulateReponse.isEmpty
                                                        ? ""
                                                        : "AED ${calulateReponse["earn_20_days"]}",
                                                    style: GoogleFonts.lexendExa(
                                                        fontWeight: FontWeight.w300,
                                                        fontSize: 16,
                                                        color: MyColors.themecolor),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        )
                                      : Container()
                            ],
                          ),
                        ),

                        // Bottom text =========================================================================================

                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Text(
                            "Benefits of renting",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.dmSerifDisplay(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                        ),

                        Container(
                          margin: const EdgeInsets.only(top: 15, bottom: 25),
                          width: 50,
                          height: 1,
                          color: Colors.black,
                        ),

                        //  Bottom  four images =======================================================================================

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Container(
                                margin: const EdgeInsets.only(
                                    left: 10, right: 5, bottom: 10),
                                width: MediaQuery.of(context).size.width,
                                height: 180,
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Image.asset(
                                      "assets/images/bottom1home.png",
                                      fit: BoxFit.cover,
                                      height: 180,
                                      width: MediaQuery.of(context).size.width,
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Unlimited Outfit",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.dmSerifDisplay(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 13,
                                              color: Colors.white),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          "Transform the way we keep\nup with the latest trends",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.lexendDeca(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 12,
                                              color: Colors.white),
                                        ),
                                        const SizedBox(height: 25)
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Flexible(
                              child: Container(
                                margin: const EdgeInsets.only(
                                    right: 10, left: 5, bottom: 10),
                                width: MediaQuery.of(context).size.width,
                                height: 180,
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Image.asset(
                                      "assets/images/bottom2home.png",
                                      fit: BoxFit.cover,
                                      height: 180,
                                      width: MediaQuery.of(context).size.width,
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Passive Income",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.dmSerifDisplay(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 13,
                                              color: Colors.white),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          "Earn from your existing rarely\nused fashion items",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.lexendDeca(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 12,
                                              color: Colors.white),
                                        ),
                                        const SizedBox(height: 25)
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        // row second 2

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Container(
                                margin: const EdgeInsets.only(
                                    left: 10, right: 5, bottom: 10),
                                height: 180,
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Image.asset(
                                      "assets/images/bottom3home.png",
                                      fit: BoxFit.cover,
                                      height: 180,
                                      width: MediaQuery.of(context).size.width,
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Social Experience",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.dmSerifDisplay(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 13,
                                              color: Colors.white),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          "More than just a community,\nwe are a sizterhood!",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.lexendDeca(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 12,
                                              color: Colors.white),
                                        ),
                                        const SizedBox(height: 25)
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Flexible(
                              child: Container(
                                margin: const EdgeInsets.only(
                                    right: 10, left: 5, bottom: 10),
                                height: 180,
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Image.asset(
                                      "assets/images/bottom4home.png",
                                      fit: BoxFit.cover,
                                      height: 180,
                                      width: MediaQuery.of(context).size.width,
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Sustainable Fashion",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.dmSerifDisplay(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 13,
                                              color: Colors.white),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          "Keep your wardrobe updated\nin an eco-friendly way",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.lexendDeca(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 12,
                                              color: Colors.white),
                                        ),
                                        const SizedBox(height: 25)
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // top heading and search =====================================================================================

                  Column(
                    children: [
                      // Top text=================================================================================

                      CarouselSlider.builder(
                          itemCount: toplist.length,
                          itemBuilder: (BuildContext context, int itemIndex,
                                  int pageViewIndex) =>
                              Container(
                                  padding:
                                      const EdgeInsets.only(top: 10, bottom: 10),
                                  decoration:
                                      const BoxDecoration(color: Color(0xffF6F5F1)),
                                  alignment: Alignment.center,
                                  child: Text(toplist[itemIndex],
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.lexendExa(
                                        fontWeight: FontWeight.w300,
                                        color: MyColors.themecolor,
                                        fontSize: 14,
                                      ))),
                          options: CarouselOptions(
                              height: 40.0,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 2))),

                      // top four icons ==============================================================================================

                      Container(
                        margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                                onTap: () async {
                                  SharedPreferences sharedPreferences =
                                      await SharedPreferences.getInstance();

                                  if (sharedPreferences
                                          .getString(SizValue.isLogged)
                                          .toString() ==
                                      "null") {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginPage(otpNumber: "")));
                                  } else if (sharedPreferences
                                          .getString(SizValue.isLogged)
                                          .toString() ==
                                      "1") {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => BasicLoginInfo(
                                                fromWhere: sharedPreferences
                                                    .getString(SizValue.source)
                                                    .toString())));
                                  } else if (sharedPreferences
                                          .getString(SizValue.isLogged)
                                          .toString() ==
                                      "2") {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AccountCreate()));
                                  } else if (sharedPreferences
                                          .getString(SizValue.underReview)
                                          .toString() ==
                                      "0") {
                                    showReviewdialog(
                                        sharedPreferences
                                            .getString(SizValue.underReviewMsg)
                                            .toString(),
                                        sharedPreferences
                                            .getString(SizValue.underReview)
                                            .toString());
                                  } else if (sharedPreferences
                                          .getString(SizValue.underReview)
                                          .toString() ==
                                      "2") {
                                    showReviewdialog(
                                        sharedPreferences
                                            .getString(SizValue.rejectedReviewMSG)
                                            .toString(),
                                        sharedPreferences
                                            .getString(SizValue.underReview)
                                            .toString());
                                  } else if (sharedPreferences
                                          .getString(SizValue.underReview)
                                          .toString() ==
                                      "3") {
                                    showReviewdialog(
                                        sharedPreferences
                                            .getString(SizValue.incompleteMessage)
                                            .toString(),
                                        sharedPreferences
                                            .getString(SizValue.underReview)
                                            .toString());
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const Cart()));
                                  }
                                },
                                child: SvgPicture.asset(
                                  "assets/images/bag.svg",
                                  width: 20,
                                  height: 20,
                                )),
                            Image.asset(
                              "assets/images/appiconpng.png",
                              width: 40,
                              height: 40,
                            ),
                            Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              direction: Axis.horizontal,
                              children: [
                                InkWell(
                                    onTap: () async {
                                      SharedPreferences sharedPreferences =
                                          await SharedPreferences.getInstance();

                                      if (sharedPreferences
                                              .getString(SizValue.isLogged)
                                              .toString() ==
                                          "null") {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginPage(otpNumber: "")));
                                      } else if (sharedPreferences
                                              .getString(SizValue.isLogged)
                                              .toString() ==
                                          "1") {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BasicLoginInfo(
                                                        fromWhere: sharedPreferences
                                                            .getString(
                                                                SizValue.source)
                                                            .toString())));
                                      } else if (sharedPreferences
                                              .getString(SizValue.isLogged)
                                              .toString() ==
                                          "2") {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AccountCreate()));
                                      } else if (sharedPreferences
                                              .getString(SizValue.underReview)
                                              .toString() ==
                                          "0") {
                                        showReviewdialog(
                                            sharedPreferences
                                                .getString(SizValue.underReviewMsg)
                                                .toString(),
                                            sharedPreferences
                                                .getString(SizValue.underReview)
                                                .toString());
                                      } else if (sharedPreferences
                                              .getString(SizValue.underReview)
                                              .toString() ==
                                          "2") {
                                        showReviewdialog(
                                            sharedPreferences
                                                .getString(
                                                    SizValue.rejectedReviewMSG)
                                                .toString(),
                                            sharedPreferences
                                                .getString(SizValue.underReview)
                                                .toString());
                                      } else if (sharedPreferences
                                              .getString(SizValue.underReview)
                                              .toString() ==
                                          "3") {
                                        showReviewdialog(
                                            sharedPreferences
                                                .getString(
                                                    SizValue.incompleteMessage)
                                                .toString(),
                                            sharedPreferences
                                                .getString(SizValue.underReview)
                                                .toString());
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Wishlist()));
                                      }
                                    },
                                    child: SvgPicture.asset(
                                      "assets/images/heart.svg",
                                      width: 20,
                                      height: 20,
                                    )),
                              ],
                            )
                          ],
                        ),
                      ),
                      AnimatedContainer(
                        alignment: Alignment.topCenter,
                        curve: Curves.easeInOutCubic,
                        height: tabafterfirst ? 500 : 48,
                        margin: const EdgeInsets.only(
                            left: 15, right: 15, bottom: 20, top: 20),
                        decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromARGB(223, 218, 218, 218),
                                  blurRadius: 2,
                                  offset: Offset(0, 0))
                            ],
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white),
                        duration: const Duration(milliseconds: 800),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const SizedBox(width: 15),
                                SvgPicture.asset("assets/images/search.svg"),
                                const SizedBox(width: 15),

                                // textformfield search

                                Flexible(
                                    child: TextFormField(
                                        textInputAction: TextInputAction.search,
                                        onChanged: (value) {
                                          if (value.isEmpty) {
                                            setState(() {
                                              showarrowsearch = false;
                                              searchInputValue = value;
                                            });
                                          } else {
                                            setState(() {
                                              searchInputValue = value;

                                              showarrowsearch = true;
                                            });
                                          }

                                          startTimer() {
                                            checkTypingTimer = Timer(
                                                const Duration(milliseconds: 600),
                                                () async {
                                              getSearch(value);
                                            });
                                          }

                                          checkTypingTimer?.cancel();
                                          startTimer();
                                        },
                                        onTapOutside: (event) {
                                          setState(() {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                          });
                                        },
                                        enableInteractiveSelection: false,
                                        onTap: () async {
                                          setState(() {
                                            tabafterfirst = true;

                                            if (searchDecordedList.isEmpty) {
                                              getSearch("");
                                            }
                                          });
                                        },
                                        onFieldSubmitted: (value) {
                                          if (value.isNotEmpty) {
                                            setState(() {
                                              tabafterfirst = false;
                                            });

                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SearchList(
                                                            searchKeyword:
                                                                searchInputValue)));
                                          }
                                        },
                                        style: GoogleFonts.lexendDeca(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 14),

                                        // hint style
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText:
                                              "Search for lenders, brands, colour...",
                                          hintStyle: GoogleFonts.lexendDeca(
                                              color: const Color.fromARGB(
                                                  255, 123, 123, 123),
                                              fontWeight: FontWeight.w300,
                                              fontSize: 14),
                                        ))),

                                // close button

                                Visibility(
                                  visible: tabafterfirst ? true : false,
                                  child: InkWell(
                                      onTap: showarrowsearch
                                          ? () {
                                              setState(() {
                                                tabafterfirst = false;
                                              });

                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          SearchList(
                                                              searchKeyword:
                                                                  searchInputValue)));
                                            }
                                          : () {
                                              setState(() {
                                                tabafterfirst = false;
                                              });
                                            },
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        padding: showarrowsearch
                                            ? const EdgeInsets.only(
                                                top: 8, bottom: 8)
                                            : const EdgeInsets.only(
                                                top: 16, bottom: 16),
                                        height: 45,
                                        width: 45,
                                        child: showarrowsearch
                                            ? Container(
                                                decoration: const BoxDecoration(
                                                    color: MyColors.themecolor,
                                                    shape: BoxShape.circle),
                                                child: const Icon(
                                                  Icons
                                                      .keyboard_arrow_right_rounded,
                                                  size: 25,
                                                  color: Colors.white,
                                                ))
                                            : SvgPicture.asset(
                                                "assets/images/close.svg",
                                                width: 11,
                                                height: 11,
                                              ),
                                      )),
                                ),

                                const SizedBox(width: 15)
                              ],
                            ),

                            // list search

                            Expanded(
                              child: searchDecordedList.isEmpty
                                  ? Center(
                                      child: Text(
                                        "No suggestion found\nTap on search for better result",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.lexendDeca(
                                            fontSize: 12, color: Colors.grey),
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 10),
                                        child: ListView.builder(
                                            physics: const BouncingScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: searchDecordedList.length,
                                            itemBuilder: ((context, index) {
                                              return InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              SearchList(
                                                                searchKeyword:
                                                                    searchDecordedList[
                                                                                index]
                                                                            ['word']
                                                                        .toString(),
                                                              )));
                                                },
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 20, left: 20),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              searchDecordedList[
                                                                      index]['word']
                                                                  .toString(),
                                                              maxLines: 1,
                                                              style: GoogleFonts
                                                                  .lexendDeca(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                      fontSize: 14),
                                                            ),
                                                          ),
                                                          Container(
                                                            margin: const EdgeInsets
                                                                .only(right: 10),
                                                            child: SvgPicture.asset(
                                                                "assets/images/arrowright2.svg"),
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                          margin:
                                                              const EdgeInsets.only(
                                                                  top: 10,
                                                                  bottom: 10),
                                                          child: const Divider())
                                                    ],
                                                  ),
                                                ),
                                              );
                                            })),
                                      )),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  showDialogRental() {
    return showGeneralDialog(
      context: context,
      barrierLabel: "",
      barrierDismissible: false,
      // barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 200),

      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
      pageBuilder: (_, __, ___) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 0,
          ),
          body: Column(
            children: [
              // top four icons ==============================================================================================

              Container(
                alignment: Alignment.center,
                height: 60,
                decoration:
                    const BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(255, 228, 228, 228),
                      blurRadius: 2,
                      offset: Offset(0, 2))
                ]),
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset("assets/images/backarrow.svg",
                            width: 20, height: 20)),
                    Image.asset(
                      "assets/images/appiconpng.png",
                      height: 40,
                      width: 40,
                    ),
                    const SizedBox(width: 30, height: 0)
                  ],
                ),
              ),

              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // heading text
                    const SizedBox(height: 20),

                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        "How to rent?",
                        style: GoogleFonts.dmSerifDisplay(
                            fontSize: 20, color: Colors.black),
                      ),
                    ),

                    // steps ==========================================================================================

                    const SizedBox(height: 10),

                    //step 1

                    Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 140,
                            width: 30,
                            child: Column(
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        shape: BoxShape.circle),
                                    child: const Text(
                                      "1",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18),
                                    )),
                                Expanded(
                                  child: Container(
                                    width: 1,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Container(
                              height: 130,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                        color:
                                            Color.fromARGB(255, 206, 206, 206),
                                        blurRadius: 2,
                                        offset: Offset(0, 3))
                                  ],
                                  border: Border.all(color: Colors.black),
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(60))),
                              child: Column(
                                children: [
                                  const SizedBox(height: 7),
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      margin: const EdgeInsets.only(left: 5),
                                      child: Text(
                                        "Browse",
                                        style: GoogleFonts.dmSerifDisplay(
                                            color: MyColors.themecolor),
                                      )),
                                  const SizedBox(height: 5),
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: const EdgeInsets.only(left: 30),
                                      child: Text(
                                          "Browse the most stylish closets on the app (you\ncan filter items by size,availablity,occasion,\nbrand,and more!)\n\nPick a style you love form your sizter's closet",
                                          textAlign: TextAlign.start,
                                          style: GoogleFonts.lexendDeca(
                                              color: const Color.fromARGB(
                                                  255, 98, 98, 98),
                                              fontSize: 10.5,
                                              fontWeight: FontWeight.w300))),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    //step 2

                    Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 140,
                            width: 30,
                            child: Column(
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        shape: BoxShape.circle),
                                    child: const Text(
                                      "2",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18),
                                    )),
                                Expanded(
                                  child: Container(
                                    width: 1,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Container(
                              height: 130,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                        color:
                                            Color.fromARGB(255, 206, 206, 206),
                                        blurRadius: 2,
                                        offset: Offset(0, 3))
                                  ],
                                  border: Border.all(color: Colors.black),
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(60))),
                              child: Column(
                                children: [
                                  const SizedBox(height: 7),
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      margin: const EdgeInsets.only(left: 5),
                                      child: Text(
                                        "Request rental",
                                        style: GoogleFonts.dmSerifDisplay(
                                            color: MyColors.themecolor),
                                      )),
                                  const SizedBox(height: 5),
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: const EdgeInsets.only(left: 30),
                                      child: Text(
                                          "Choose dates, send your rental request, and\ncommunicate securely with the lender through\nour messaging system.\n\nYou will be charged once it's accepted",
                                          textAlign: TextAlign.start,
                                          style: GoogleFonts.lexendDeca(
                                              color: const Color.fromARGB(
                                                  255, 98, 98, 98),
                                              fontSize: 10.5,
                                              fontWeight: FontWeight.w300))),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    //step 3

                    Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 140,
                            width: 30,
                            child: Column(
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        shape: BoxShape.circle),
                                    child: const Text(
                                      "3",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18),
                                    )),
                                Expanded(
                                  child: Container(
                                    width: 1,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Container(
                              height: 130,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                        color:
                                            Color.fromARGB(255, 206, 206, 206),
                                        blurRadius: 2,
                                        offset: Offset(0, 3))
                                  ],
                                  border: Border.all(color: Colors.black),
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(60))),
                              child: Column(
                                children: [
                                  const SizedBox(height: 7),
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      margin: const EdgeInsets.only(left: 5),
                                      child: Text(
                                        "Wear",
                                        style: GoogleFonts.dmSerifDisplay(
                                            color: MyColors.themecolor),
                                      )),
                                  const SizedBox(height: 5),
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: const EdgeInsets.only(left: 30),
                                      child: Text(
                                          "Receive your item and enjoy your outfit!\n\nWhen your rental period is up,just place your\nitem back in the garment bag they come in.\nWe'll handle the pick up and dry cleaning",
                                          textAlign: TextAlign.start,
                                          style: GoogleFonts.lexendDeca(
                                              color: const Color.fromARGB(
                                                  255, 98, 98, 98),
                                              fontSize: 10.5,
                                              fontWeight: FontWeight.w300))),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    //step 4

                    Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 140,
                            width: 30,
                            child: Column(
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        shape: BoxShape.circle),
                                    child: const Text(
                                      "4",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18),
                                    )),
                              ],
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Container(
                              height: 130,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                        color:
                                            Color.fromARGB(255, 206, 206, 206),
                                        blurRadius: 2,
                                        offset: Offset(0, 3))
                                  ],
                                  border: Border.all(color: Colors.black),
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(60))),
                              child: Column(
                                children: [
                                  const SizedBox(height: 7),
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      margin: const EdgeInsets.only(left: 5),
                                      child: Text(
                                        "Rate and review",
                                        style: GoogleFonts.dmSerifDisplay(
                                            color: MyColors.themecolor),
                                      )),
                                  const SizedBox(height: 5),
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: const EdgeInsets.only(left: 30),
                                      child: Text(
                                          "After returning your rental, share your honest\nfeedback with fellow Sizters and flaunt your\nfabulous look on social media.\n\nDon't forget to tag @sizters.app",
                                          textAlign: TextAlign.start,
                                          style: GoogleFonts.lexendDeca(
                                              color: const Color.fromARGB(
                                                  255, 98, 98, 98),
                                              fontSize: 10.5,
                                              fontWeight: FontWeight.w300))),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        controller.addPages(1);

                        controller.updateIndex(1);
                      },
                      child: Container(
                        width: 200,
                        height: 40,
                        margin: const EdgeInsets.only(
                            left: 70, right: 70, top: 10, bottom: 30),
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            color: MyColors.themecolor,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Text(
                          "START RENTING",
                          style: GoogleFonts.lexendExa(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showReviewdialog(String title, String value) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: value == "3" ? true : false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return WillPopScope(
          onWillPop: () async {
            return value == "3" ? true : false;
          },
          child: Center(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 30, right: 20),
              height: 180,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(13)),
              child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 280,
                        child: Text(
                          title,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lexendDeca(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: Colors.black),
                        ),
                      ),
                      InkWell(
                        onTap: value == "2"
                            ? () async {
                                Navigator.pop(context);
                                controller.updateIndex(0);

                                SharedPreferences sharedPreferences =
                                    await SharedPreferences.getInstance();
                                sharedPreferences.clear();

                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Home()),
                                    (Route<dynamic> route) => false);
                              }
                            : value == "3"
                                ? () {
                                    Navigator.pop(context);

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AccountCreate()));
                                  }
                                : () {
                                    Navigator.pop(context);
                                  },
                        child: Container(
                          width: 240,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(top: 20),
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                              value == "2"
                                  ? "LOGOUT"
                                  : value == "3"
                                      ? "COMPLETE SIGNUP"
                                      : "OK",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lexendExa(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300)),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        );
      },
    );
  }
}
