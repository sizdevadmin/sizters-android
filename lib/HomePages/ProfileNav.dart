// ignore_for_file: depend_on_referenced_packages, file_names, use_build_context_synchronously, prefer_interpolation_to_compose_strings, avoid_print

import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_chart/commons/config_render.dart';
import 'package:d_chart/commons/data_model.dart';

import 'package:d_chart/ordinal/bar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:money_formatter/money_formatter.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:siz/Controllers/BottomNavController.dart';
import 'package:siz/Controllers/ChatController.dart';
import 'package:siz/Controllers/ProfileController.dart';
import 'package:siz/LoginSignUp/AccuntCreate.dart';
import 'package:siz/LoginSignUp/BasicLoginInfo.dart';
import 'package:siz/LoginSignUp/LoginPage.dart';
import 'package:siz/Pages/AllOrderRequest.dart';
import 'package:siz/Pages/Creditpage.dart';
import 'package:siz/Pages/Home.dart';
import 'package:siz/Pages/ManageItem.dart';
import 'package:siz/Pages/MyListing.dart';
import 'package:siz/Pages/Myrental.dart';
import 'package:siz/Pages/ProductView.dart';
import 'package:siz/Pages/RentDetails.dart';
import 'dart:io';
import 'package:badges/badges.dart' as badges;
import 'package:siz/Utils/Value.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:siz/Pages/BasicSetting.dart';
import 'package:siz/Pages/EditProfile.dart';
import 'package:siz/Utils/Colors.dart';
import 'package:siz/Utils/CustomCalender.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileNav extends StatefulWidget {
  const ProfileNav({super.key});

  @override
  State<ProfileNav> createState() => _ProfileNavState();
}

final titles = <String>['Aug', 'Sept', 'Oct', 'Nov', 'Dec'];

class _ProfileNavState extends State<ProfileNav> with TickerProviderStateMixin {
  late TabController tabController;
  late TabController tabController2;

  int touchedGroupIndex = -1;

  var scrollParent = false;

  profileController controller = Get.put(profileController());

  // get renting and lending details ===============================================================================

  final List<String> yearslending = [
    '2024',
    '2023',
  ];
  String? selectedyearLender;

  final List<String> yearsrenting = [
    '2024',
    '2023',
  ];
  String? selectedyearRender;

  List<dynamic> lentingGraph = [];

  // get my rental =========================================================================================

  bool rentalTabbed = false;
  bool calenderTabbed = false;
  bool requestTabbed = false;

  Map<String, dynamic> myrentalResponse = {};
  List<dynamic> decordedMyrentalReponse = [];

  bool isLoadingMoreMRT = false;
  bool oncesCallMRT = false;
  bool noMoreDataMRT = false;
  bool showLazyIndicatorMRT = false;

  getmyRentals(int pageno) async {
    print(pageno);

    if (pageno <= 1) {
      dialodShow(context);
    } else {
      setState(() {
        showLazyIndicatorMRT = true;
      });
    }

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      final response = await http.post(Uri.parse(SizValue.myrentals), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey),
        'page': pageno.toString()
      });

      myrentalResponse = jsonDecode(response.body);

      if (myrentalResponse["success"] == true) {
        if (pageno <= 1) {
          setState(() {
            decordedMyrentalReponse = myrentalResponse["list"];
            isLoadingMoreMRT = false;
            oncesCallMRT = false;
          });
        } else {
          setState(() {
            decordedMyrentalReponse.addAll(myrentalResponse["list"]);
            isLoadingMoreMRT = false;
            oncesCallMRT = false;
          });
        }

        if (myrentalResponse["list"].toString() == "[]") {
          setState(() {
            noMoreDataMRT = true;
            isLoadingMoreMRT = false;
            oncesCallMRT = false;
          });
        }

        if (pageno <= 1) {
          Navigator.pop(context);
        } else {
          setState(() {
            showLazyIndicatorMRT = false;
          });
        }
      } else if (myrentalResponse["success"] == false) {
        if (pageno <= 1) {
          Navigator.pop(context);
        } else {
          setState(() {
            showLazyIndicatorMRT = false;
          });
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(myrentalResponse["error"].toString(),
                style: GoogleFonts.lexendDeca(
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                    color: Colors.white))));
      }
    } on ClientException {
      if (pageno <= 1) {
        Navigator.pop(context);
      } else {
        setState(() {
          showLazyIndicatorMRT = false;
        });
      }
      mysnackbar(
          "Server not responding please try again after sometimev fg", context);
    } on SocketException {
      if (pageno <= 1) {
        Navigator.pop(context);
      } else {
        setState(() {
          showLazyIndicatorMRT = false;
        });
      }
      mysnackbar(
          "No Internet connection 😑 please try again after sometime", context);
    } on HttpException {
      if (pageno <= 1) {
        Navigator.pop(context);
      } else {
        setState(() {
          showLazyIndicatorMRT = false;
        });
      }
      mysnackbar("Something went wrong please try after sometime", context);
    } on FormatException {
      if (pageno <= 1) {
        Navigator.pop(context);
      } else {
        setState(() {
          showLazyIndicatorMRT = false;
        });
      }
      mysnackbar("Something went wrong please try after sometime", context);
    }
  }

  // get calender data =====================================================================================

  Map<String, dynamic> calenderResponse = {};
  List<dynamic> decordedCalenderResponse = [];

  getcalenderData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      final response =
          await http.post(Uri.parse(SizValue.calenderRequest), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey),
      });

      calenderResponse = jsonDecode(response.body);

      if (calenderResponse["success"] == true) {
        setState(() {
          decordedCalenderResponse = calenderResponse["list"];
        });
      } else if (calenderResponse["success"] == false) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(calenderResponse["error"].toString(),
                style: GoogleFonts.lexendDeca(
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                    color: Colors.white))));
      }
    } on ClientException {
      mysnackbar(
          "Server not responding please try again after sometimev fg", context);
    } on SocketException {
      mysnackbar(
          "No Internet connection 😑 please try again after sometime", context);
    } on HttpException {
      mysnackbar("Something went wrong please try after sometime", context);
    } on FormatException {
      mysnackbar("Something went wrong please try after sometime", context);
    }
  }

  // myrequests =================================================================================================

  Map<String, dynamic> myrequesttReponse = {};
  List<dynamic> decordedrequestResponse = [];

  bool isLoadingMoreMR = false;
  bool oncesCallMR = false;
  bool noMoreDataMR = false;
  bool showLazyIndicatorMR = false;

  myrequests(int pageno) async {
    if (pageno > 1) {
      setState(() {
        showLazyIndicatorMR = true;
      });
    }

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      final response = await http.post(Uri.parse(SizValue.myrequest), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey),
        'page': pageno.toString()
      });

      myrequesttReponse = jsonDecode(response.body);

      // print(myrequesttReponse);

      if (myrequesttReponse["success"] == true) {
        if (pageno <= 1) {
          setState(() {
            decordedrequestResponse = myrequesttReponse["list"];
            isLoadingMoreMR = false;
            oncesCallMR = false;
          });
        } else {
          setState(() {
            decordedrequestResponse.addAll(myrequesttReponse["list"]);
            isLoadingMoreMR = false;
            oncesCallMR = false;
          });
        }

        if (myrequesttReponse["list"].toString() == "[]") {
          setState(() {
            noMoreDataMR = true;
            isLoadingMoreMR = false;
            oncesCallMR = false;
          });
        }

        if (pageno > 1) {
          setState(() {
            showLazyIndicatorMR = false;
          });
        }
      } else if (myrequesttReponse["success"] == false) {
        if (pageno > 1) {
          setState(() {
            showLazyIndicatorMR = false;
          });
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(myrequesttReponse["error"].toString(),
                style: GoogleFonts.lexendDeca(
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                    color: Colors.white))));
      }
    } on ClientException {
      if (pageno > 1) {
        setState(() {
          showLazyIndicatorMR = false;
        });
      }
      mysnackbar(
          "Server not responding please try again after sometimev fg", context);
    } on SocketException {
      if (pageno > 1) {
        setState(() {
          showLazyIndicatorMR = false;
        });
      }
      mysnackbar(
          "No Internet connection 😑 please try again after sometime", context);
    } on HttpException {
      if (pageno > 1) {
        setState(() {
          showLazyIndicatorMR = false;
        });
      }
      mysnackbar("Something went wrong please try after sometime", context);
    } on FormatException {
      if (pageno > 1) {
        setState(() {
          showLazyIndicatorMR = false;
        });
      }
      mysnackbar("Something went wrong please try after sometime", context);
    }
  }

  // update mycloset status ====================================================================

  Map<String, dynamic> updateclosetResponse = {};

  updatemyClosetsStatus(String id, int index) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      final response =
          await http.post(Uri.parse(SizValue.updateClosetStatus), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey),
        'id': id,
      });

      updateclosetResponse = jsonDecode(response.body);

      if (updateclosetResponse["success"] == true) {
        setState(() {
          controller.decordedClosetsResponse[index]["lender_status"] =
              updateclosetResponse["status"];
        });
      } else if (updateclosetResponse["success"] == false) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(updateclosetResponse["error"].toString(),
                style: GoogleFonts.lexendDeca(
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                    color: Colors.white))));
      }
    } on ClientException {
      mysnackbar(
          "Server not responding please try again after sometimev fg", context);
    } on SocketException {
      mysnackbar(
          "No Internet connection 😑 please try again after sometime", context);
    } on HttpException {
      mysnackbar("Something went wrong please try after sometime", context);
    } on FormatException {
      mysnackbar("Something went wrong please try after sometime", context);
    }
  }

  // request approve and rejected ====================================================================

  Map<String, dynamic> requestApproveRejectedResponse = {};

  requestApproveRejected(String id, String action, int index) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      final response =
          await http.post(Uri.parse(SizValue.requestAction), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey),
        'id': id,
        'status': action,
      });

      requestApproveRejectedResponse = jsonDecode(response.body);

      if (requestApproveRejectedResponse["success"] == true) {
        setState(() {
          decordedrequestResponse[index]["status"] =
              requestApproveRejectedResponse["status"];

          controller.decordedlendingReponse["pending_request"] =
              requestApproveRejectedResponse["pending_rental"].toString();
          controller.forseUpdate();
        });
      } else if (requestApproveRejectedResponse["success"] == false) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(requestApproveRejectedResponse["error"].toString(),
                style: GoogleFonts.lexendDeca(
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                    color: Colors.white))));
      }
    } on ClientException {
      mysnackbar(
          "Server not responding please try again after sometimev fg", context);
    } on SocketException {
      mysnackbar(
          "No Internet connection 😑 please try again after sometime", context);
    } on HttpException {
      mysnackbar("Something went wrong please try after sometime", context);
    } on FormatException {
      mysnackbar("Something went wrong please try after sometime", context);
    }
  }

  // request on and off all closets ====================================================================

  Map<String, dynamic> allclosetsResponse = {};

  updateAllClosets() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    dialodShow(context);
    try {
      final response = await http.post(Uri.parse(SizValue.updateAllCloset),
          body: {'user_key': sharedPreferences.getString(SizValue.userKey)});

      allclosetsResponse = jsonDecode(response.body);

      if (allclosetsResponse["success"] == true) {
        setState(() {
          controller.closetsReponse["closet_status"] =
              allclosetsResponse["status"].toString();
        });

        Navigator.pop(context);
      } else if (allclosetsResponse["success"] == false) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(allclosetsResponse["error"].toString(),
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

  Widget _individualTab(String text) {
    return Container(
      // height: 50 + MediaQuery.of(context).padding.bottom,
      padding: const EdgeInsets.all(0),
      width: double.infinity,
      decoration: const BoxDecoration(
          border: Border(
              right: BorderSide(
                  color: Color.fromARGB(255, 34, 34, 34),
                  width: 1,
                  style: BorderStyle.solid))),
      child: Tab(
        text: text,
      ),
    );
  }

  final ScrollController _scrollControllerMC = ScrollController();
  int pagenoMC = 1;

  Future<void> scrollListenerMC() async {
    if (controller.isLoadingMoreMC) return;

    _scrollControllerMC.addListener(() {
      bool isTop = _scrollControllerMC.position.pixels == 0;
      if (isTop) {
        setState(() {
          requestScroll = false;
        });
      }

      if (_scrollControllerMC.offset >=
          _scrollControllerMC.position.maxScrollExtent - 400) {
        controller.isLoadingMoreMC = true;
        controller.forseUpdate();
        if (!controller.oncesCallMC) {
          if (controller.noMoreDataMC) {
            return;
          } else {
            controller.getclosets(context, ++pagenoMC);
            controller.oncesCallMC = true;
            controller.forseUpdate();
          }
        }
      }
    });
  }

// my list pagination ==========================================================

  final ScrollController _scrollControllerMR = ScrollController();
  int pagenoMR = 1;

  Future<void> scrollListenerMR() async {
    if (isLoadingMoreMR) return;

    _scrollControllerMR.addListener(() {
      bool isTop = _scrollControllerMR.position.pixels == 0;
      if (isTop) {
        setState(() {
          requestScroll = false;
        });
      }

      if (_scrollControllerMR.offset >=
          _scrollControllerMR.position.maxScrollExtent - 400) {
        setState(() {
          isLoadingMoreMR = true;
        });

        if (!oncesCallMR) {
          if (noMoreDataMR) {
            return;
          } else {
            myrequests(++pagenoMR);

            setState(() {
              oncesCallMR = true;
            });
          }
        }
      }
    });
  }

  // my rental pagination =================================

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
            getmyRentals(++pagenoMRT);

            setState(() {
              oncesCallMRT = true;
            });
          }
        }
      }
    });
  }

  List<OrdinalData> ordinalList = [
    OrdinalData(domain: 'Mon', measure: 1500),
    OrdinalData(domain: 'Tue', measure: 1200),
    OrdinalData(domain: 'Wed', measure: 800),
    OrdinalData(domain: 'Thu', measure: 1600),
  ];
  List<OrdinalData> ordinalList2 = [
    OrdinalData(domain: 'Mon', measure: 100),
    OrdinalData(domain: 'Tue', measure: 800),
    OrdinalData(domain: 'Wed', measure: 600),
    OrdinalData(domain: 'Thu', measure: 1000),
  ];

  bool requestScroll = false;

  final ScrollController tabOnController = ScrollController();

     firebaseEventCalled()
  {
    
     try {
      FacebookAppEvents facebookAppEvents = FacebookAppEvents();

      facebookAppEvents.logEvent(
        name: "DashboardAndroid",
      );
    } catch (e) {}
  }

  @override
  void initState() {



    super.initState();


    firebaseEventCalled();

    checkValues();

    tabOnController.addListener(() {
      if (tabOnController.offset >= tabOnController.position.maxScrollExtent) {
        setState(() {
          requestScroll = true;
        });
      } else {
        if (requestScroll) {
          setState(() {
            requestScroll = false;
          });
        }
      }
    });

    _scrollControllerMRT.addListener(() async {
      scrollListenerMRT();
    });

    _scrollControllerMC.addListener(() async {
      scrollListenerMC();
    });
    _scrollControllerMR.addListener(() async {
      scrollListenerMR();
    });

    tabController = TabController(length: 2, vsync: this);
    tabController2 = TabController(length: 3, vsync: this, initialIndex: 1);
  }

  checkValues() async {
    await controller.getProfleValue();

     if (controller.review == "3") {
    } else if (controller.review == "2") {
    } else if (controller.loginStatus == "1") {
    }
    
    //  else if (controller.loginStatus == "2") {
    // }
     else if (controller.loginStatus == "null") {
    } else {
      controller.getaccontDetails(context, "2024");
    }
  }

  double renterRating = 0.0;
  TextEditingController renterReviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: profileController(),
        builder: (controller) {
          return SafeArea(
            child: Scaffold(
              body: 
                   controller.review == "2"
                      ? Container(
                          margin: const EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  child: LottieBuilder.asset(
                                    "assets/images/rejectanimation.json",
                                    fit: BoxFit.cover,
                                    width: 100,
                                    height: 100,
                                  )),
                              Container(
                                alignment: Alignment.center,
                                child: Text(
                                  controller.reviewRejectMSG,
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
                                onTap: () async {
                                  SharedPreferences sharedPreferences =
                                      await SharedPreferences.getInstance();
                                  sharedPreferences.clear();

                                  final BottomNavController controller =
                                      Get.put(BottomNavController());
                                  controller.updateIndex(0);

                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const Home()),
                                      (Route<dynamic> route) => false);
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      top: 20, left: 20, right: 20),
                                  alignment: Alignment.center,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                      color: Colors.black,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: Text(
                                    "LOGOUT".toUpperCase(),
                                    style: GoogleFonts.lexendExa(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                              ),

                              InkWell(
                                onTap: ()async {
                                    var androidUrl = "whatsapp://send?phone=+971553674923&text=";
                                   await launchUrl(Uri.parse(androidUrl));
                                },
                                child: Container(
                                    margin: const EdgeInsets.only(
                                        top: 20, left: 20, right: 20),
                                    alignment: Alignment.center,
                                    height: 40,
                                    decoration: const BoxDecoration(
                                        color: Colors.black,
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(5))),
                                    child: Text(
                                      "Talk to support".toUpperCase(),
                                      style: GoogleFonts.lexendExa(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ),
                              ),
                            ],
                          ),
                        )
                      : controller.review == "3"
                          ? Container(
                              margin:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      child: LottieBuilder.asset(
                                        "assets/images/incomplete.json",
                                        fit: BoxFit.cover,
                                        width: 100,
                                        height: 100,
                                      )),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      controller.incompleteMsg,
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
                                    onTap: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AccountCreate()));
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          top: 20, left: 20, right: 20),
                                      alignment: Alignment.center,
                                      height: 40,
                                      decoration: const BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      child: Text(
                                        "COMPLETE SIGNUP".toUpperCase(),
                                        style: GoogleFonts.lexendExa(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w300),
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
                                          SizValue.underReview, "null");
                                      sharedPreferences.setString(
                                          SizValue.isLogged, "null");

                                      ChatController chatController =
                                          Get.put(ChatController());
                                      chatController.getProfleValue();
                                      profileController pController =
                                          Get.put(profileController());
                                      pController.getProfleValue();

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginPage(otpNumber: "")));
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          top: 60, bottom: 10),
                                      child: Text(
                                        "Use another account ?".toUpperCase(),
                                        style: GoogleFonts.lexendDeca(
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: 16,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : controller.loginStatus == "1"
                              ? Container(
                                  margin: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 20),
                                          child: LottieBuilder.asset(
                                            "assets/images/incomplete.json",
                                            fit: BoxFit.cover,
                                            width: 100,
                                            height: 100,
                                          )),
                                      Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          controller.incompleteMsg,
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
                                        onTap: () async {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      BasicLoginInfo(
                                                          fromWhere: controller
                                                              .source)));
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              top: 20, left: 20, right: 20),
                                          alignment: Alignment.center,
                                          height: 40,
                                          decoration: const BoxDecoration(
                                              color: Colors.black,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                          child: Text(
                                            "COMPLETE SIGNUP".toUpperCase(),
                                            style: GoogleFonts.lexendExa(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        splashFactory: NoSplash.splashFactory,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          SharedPreferences sharedPreferences =
                                              await SharedPreferences
                                                  .getInstance();

                                          sharedPreferences.setString(
                                              SizValue.underReview, "null");
                                          sharedPreferences.setString(
                                              SizValue.isLogged, "null");

                                          ChatController chatController =
                                              Get.put(ChatController());
                                          chatController.getProfleValue();
                                          profileController pController =
                                              Get.put(profileController());
                                          pController.getProfleValue();

                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginPage(
                                                          otpNumber: "")));
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              top: 60, bottom: 10),
                                          child: Text(
                                            "Use another account ?"
                                                .toUpperCase(),
                                            style: GoogleFonts.lexendDeca(
                                                decoration:
                                                    TextDecoration.underline,
                                                fontSize: 16,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              // : controller.loginStatus == "2"
                              //     ? Container(
                              //         margin: const EdgeInsets.only(
                              //             left: 20, right: 20),
                              //         child: Column(
                              //           mainAxisAlignment:
                              //               MainAxisAlignment.center,
                              //           crossAxisAlignment:
                              //               CrossAxisAlignment.center,
                              //           children: [
                              //             Container(
                              //                 margin: const EdgeInsets.only(
                              //                     bottom: 20),
                              //                 child: LottieBuilder.asset(
                              //                   "assets/images/incomplete.json",
                              //                   fit: BoxFit.cover,
                              //                   width: 100,
                              //                   height: 100,
                              //                 )),
                              //             Container(
                              //               alignment: Alignment.center,
                              //               child: Text(
                              //                 controller.incompleteMsg,
                              //                 maxLines: 4,
                              //                 overflow: TextOverflow.ellipsis,
                              //                 textAlign: TextAlign.center,
                              //                 style: GoogleFonts.lexendDeca(
                              //                     fontSize: 16,
                              //                     fontWeight: FontWeight.w300,
                              //                     color: Colors.black),
                              //               ),
                              //             ),
                              //             InkWell(
                              //               onTap: () async {
                              //                 Navigator.push(
                              //                     context,
                              //                     MaterialPageRoute(
                              //                         builder: (context) =>
                              //                             AccountCreate()));
                              //               },
                              //               child: Container(
                              //                 margin: const EdgeInsets.only(
                              //                     top: 20, left: 20, right: 20),
                              //                 alignment: Alignment.center,
                              //                 height: 40,
                              //                 decoration: const BoxDecoration(
                              //                     color: Colors.black,
                              //                     borderRadius:
                              //                         BorderRadius.all(
                              //                             Radius.circular(5))),
                              //                 child: Text(
                              //                   "COMPLETE SIGNUP".toUpperCase(),
                              //                   style: GoogleFonts.lexendExa(
                              //                       color: Colors.white,
                              //                       fontSize: 16,
                              //                       fontWeight:
                              //                           FontWeight.w300),
                              //                 ),
                              //               ),
                              //             ),
                              //             InkWell(
                              //               splashFactory:
                              //                   NoSplash.splashFactory,
                              //               highlightColor: Colors.transparent,
                              //               onTap: () async {
                              //                 SharedPreferences
                              //                     sharedPreferences =
                              //                     await SharedPreferences
                              //                         .getInstance();

                              //                 sharedPreferences.setString(
                              //                     SizValue.underReview, "null");
                              //                 sharedPreferences.setString(
                              //                     SizValue.isLogged, "null");

                              //                 ChatController chatController =
                              //                     Get.put(ChatController());
                              //                 chatController.getProfleValue();
                              //                 profileController pController =
                              //                     Get.put(profileController());
                              //                 pController.getProfleValue();

                              //                 Navigator.push(
                              //                     context,
                              //                     MaterialPageRoute(
                              //                         builder: (context) =>
                              //                             LoginPage(
                              //                                 otpNumber: "")));
                              //               },
                              //               child: Container(
                              //                 margin: const EdgeInsets.only(
                              //                     top: 60, bottom: 10),
                              //                 child: Text(
                              //                   "Use another account ?"
                              //                       .toUpperCase(),
                              //                   style: GoogleFonts.lexendDeca(
                              //                       decoration: TextDecoration
                              //                           .underline,
                              //                       fontSize: 16,
                              //                       color: Colors.grey,
                              //                       fontWeight:
                              //                           FontWeight.w300),
                              //                 ),
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //       )
                                  : controller.loginStatus == "null"
                                      ? Container(
                                          margin: const EdgeInsets.only(
                                              left: 20, right: 20),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                  margin: const EdgeInsets.only(
                                                      bottom: 20),
                                                  child: LottieBuilder.asset(
                                                    "assets/images/underprocess.json",
                                                    fit: BoxFit.cover,
                                                    width: 100,
                                                    height: 100,
                                                  )),
                                              Container(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "Please login to continue",
                                                  maxLines: 4,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.lexendDeca(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: Colors.black),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              LoginPage(
                                                                otpNumber: "",
                                                              )));
                                                },
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 20,
                                                      left: 20,
                                                      right: 20,
                                                      bottom: 0),
                                                  alignment: Alignment.center,
                                                  height: 40,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.black,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                  child: Text(
                                                    "Login".toUpperCase(),
                                                    style:
                                                        GoogleFonts.lexendExa(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      : Column(
                                          children: [

                                         

                                            Visibility(
                                              
                                          visible:  controller.review == "0",
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                left: 20,
                                                right: 20,
                                                top: 10,
                                                bottom: 10),
                                            color: Colors.yellow,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                    child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Your profile is under review, try refreshing",
                                                      style: GoogleFonts
                                                          .lexendDeca(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300),
                                                    ),
                                                    Text(
                                                      "OR",
                                                      style: GoogleFonts
                                                          .lexendDeca(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300),
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        
                                                          SharedPreferences sharedPreferences =
                                    await SharedPreferences.getInstance();

                                sharedPreferences.setString(
                                    SizValue.underReview, "null");
                                sharedPreferences.setString(
                                    SizValue.isLogged, "null");

                                ChatController chatController =
                                    Get.put(ChatController());
                                chatController.getProfleValue();
                                profileController pController =
                                    Get.put(profileController());
                                pController.getProfleValue();

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            LoginPage(otpNumber: "")));
                                                      },
                                                      child: Text(
                                                        "Use another account ?".toUpperCase(),
                                                        style: GoogleFonts
                                                            .lexendDeca(
                                                                decoration: TextDecoration.underline,
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300),
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                                InkWell(
                                                    onTap: () async {
                                                    
                                                     final BottomNavController controller =
                                  Get.put(BottomNavController());

                              dialodShow(context);

                              if (await controller.getHomeData(context, "")) {
                                Navigator.pop(context);

                                checkValues();

                                ChatController chatController =
                                    Get.put(ChatController());

                                chatController.getProfleValue();
                              }
                                                    },
                                                    child: const Icon(
                                                        Icons.refresh))
                                              ],
                                            ),
                                          ),
                                        ),




                                               Visibility(
                                          visible:controller.loginStatus == "2",
                                          child: InkWell(
                                            onTap: () {
                                                 Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AccountCreate()));
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.only(
                                                  left: 20,
                                                  right: 20,
                                                  top: 10,
                                                  bottom: 10),
                                              color: const Color.fromARGB(255, 255, 155, 147),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                      child: Container(
                                                        margin: const EdgeInsets.only(left: 30),
                                                        alignment: Alignment.center,
                                                        child: Text(
                                                          "Please complete Id verification",
                                                          style: GoogleFonts
                                                              .lexendDeca(
                                                                  color:
                                                                      Colors.black,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300),
                                                        ),
                                                      )),
                                                  const Icon(
                                                      Icons.keyboard_double_arrow_right_sharp,size: 30,)
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),


                                            // top four icons ==============================================================================================

                                            Container(
                                              alignment: Alignment.center,
                                              height: 60,
                                              decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Color.fromARGB(
                                                            255, 230, 230, 230),
                                                        blurRadius: 1,
                                                        offset: Offset(0, 2))
                                                  ]),
                                              padding: const EdgeInsets.only(
                                                  left: 20, right: 20),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const SizedBox(
                                                    height: 0,
                                                    width: 20,
                                                  ),
                                                  Text(
                                                    "DASHBOARD".toUpperCase(),
                                                    style:
                                                        SizValue.toolbarStyle,
                                                  ),
                                                  InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const BasicSetting()));
                                                      },
                                                      child: SvgPicture.asset(
                                                        "assets/images/threeline.svg",
                                                        width: 20,
                                                        height: 20,
                                                      )),
                                                ],
                                              ),
                                            ),

                                            Container(
                                              height: 40,
                                              decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Color.fromARGB(
                                                            255, 203, 203, 203),
                                                        blurRadius: 2,
                                                        offset: Offset(0, 3))
                                                  ]),
                                              child: TabBar(
                                                controller: tabController,
                                                tabs: [
                                                  _individualTab('LENDING'),
                                                  _individualTab('RENTING'),
                                                ],
                                                labelColor: Colors.white,
                                                unselectedLabelColor:
                                                    Colors.black,
                                                indicator: const BoxDecoration(
                                                    color: MyColors.themecolor),
                                                onTap: (value) {
                                                  if (value == 1) {
                                                    if (!rentalTabbed) {
                                                      getmyRentals(pagenoMRT);
                                                    }

                                                    setState(() {
                                                      rentalTabbed = true;
                                                    });
                                                  }
                                                },
                                                indicatorWeight: 0,
                                                indicatorColor: Colors.white,
                                                indicatorSize:
                                                    TabBarIndicatorSize.tab,
                                                labelPadding:
                                                    const EdgeInsets.all(0),
                                                labelStyle:
                                                    GoogleFonts.lexendExa(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w300),
                                                indicatorPadding:
                                                    const EdgeInsets.all(0),
                                              ),
                                            ),
// tabbar view one ======================================================================================
                                            Expanded(
                                              child: TabBarView(
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  controller: tabController,
                                                  children: [
                                                    SingleChildScrollView(
                                                      physics:
                                                          const BouncingScrollPhysics(),
                                                      controller:
                                                          tabOnController,
                                                      // physics: const BouncingScrollPhysics(),
                                                      child: Column(
                                                        children: [
                                                          // profile info =======================================================================================

                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 20),
                                                            decoration:
                                                                const BoxDecoration(),
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 10,
                                                                    right: 10,
                                                                    bottom: 10),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                controller
                                                                        .profileImage
                                                                        .isEmpty
                                                                    ? const SizedBox(
                                                                        width:
                                                                            60,
                                                                        height:
                                                                            60)
                                                                    : InkWell(
                                                                        onTap:
                                                                            () async {
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(builder: (context) => MyListing(fromListing: false, initialIndex: 0)));
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              60,
                                                                          height:
                                                                              60,
                                                                          decoration:
                                                                              const BoxDecoration(shape: BoxShape.circle),
                                                                          child:
                                                                              ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(1000),
                                                                            child:
                                                                                CachedNetworkImage(
                                                                              imageUrl: controller.profileImage,
                                                                              fit: BoxFit.cover,
                                                                              height: 55,
                                                                              width: 55,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                Container(
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              5),
                                                                  width: 80,
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Container(
                                                                        margin: const EdgeInsets
                                                                            .only(
                                                                            left:
                                                                                5),
                                                                        child:
                                                                            Text(
                                                                          controller
                                                                              .profileName,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style: GoogleFonts.lexendDeca(
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.w300,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      RatingBarIndicator(
                                                                        itemPadding:
                                                                            EdgeInsets.zero,
                                                                        rating: controller.decordedlendingReponse.isEmpty
                                                                            ? 0
                                                                            : double.parse(controller.decordedlendingReponse["rating"].toString()),
                                                                        itemBuilder:
                                                                            (context, index) =>
                                                                                const Icon(
                                                                          Icons
                                                                              .star_rate_rounded,
                                                                          color:
                                                                              Color(0xffCAAB05),
                                                                        ),
                                                                        itemCount:
                                                                            5,
                                                                        itemSize:
                                                                            15.0,
                                                                        direction:
                                                                            Axis.horizontal,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                const AllOrderRequest()));
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10),
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    margin: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            10),
                                                                    height: 31,
                                                                    decoration: const BoxDecoration(
                                                                        color: MyColors
                                                                            .themecolor,
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(5))),
                                                                    child: Text(
                                                                        "RENTAL HISTORY",
                                                                        style: GoogleFonts.lexendExa(
                                                                            fontWeight:
                                                                                FontWeight.w300,
                                                                            color: Colors.white,
                                                                            fontSize: 12)),
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                const EditProfile()));
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    margin: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            10),
                                                                    width: 31,
                                                                    height: 31,
                                                                    decoration: const BoxDecoration(
                                                                        color: Color(
                                                                            0xffD9D9D9),
                                                                        shape: BoxShape
                                                                            .circle),
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: SvgPicture
                                                                        .asset(
                                                                            "assets/images/editsmall.svg"),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),

                                                          // credit amount =========================================================================

                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 15,
                                                                    right: 15,
                                                                    top: 0),
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            height: 50,
                                                            decoration: const BoxDecoration(
                                                                color: Color(
                                                                    0xffFFFCEB),
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10))),
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                  child: Row(
                                                                    children: [
                                                                      Container(
                                                                        margin: const EdgeInsets
                                                                            .only(
                                                                            left:
                                                                                10),
                                                                        child:
                                                                            Text(
                                                                          "SIZ CREDITS",
                                                                          style: GoogleFonts.lexendExa(
                                                                              fontSize: 10.5,
                                                                              fontWeight: FontWeight.w300,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        margin: const EdgeInsets
                                                                            .only(
                                                                            left:
                                                                                10),
                                                                        child:
                                                                            Text(
                                                                          controller.decordedlendingReponse.isEmpty
                                                                              ? ""
                                                                              : "AED " + controller.decordedlendingReponse["current_balance"].toString(),
                                                                          style: GoogleFonts.lexendExa(
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w300,
                                                                              color: MyColors.themecolor),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  onTap: 
                                                                  
                                                                  controller
                                                                              .decordedlendingReponse["current_balance"]
                                                                              .toString() ==
                                                                          "0"
                                                                      ? null
                                                                      : 
                                                                      
                                                                      () {
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(builder: (context) => CreditPage(earning: controller.decordedlendingReponse["current_balance"].toString(), totalearning: controller.decordedlendingReponse["total_balance"].toString())));
                                                                        },
                                                                  child:
                                                                      Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    margin: const EdgeInsets
                                                                        .only(
                                                                        left: 5,
                                                                        right:
                                                                            10),
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10),
                                                                    height: 31,
                                                                    decoration: BoxDecoration(
                                                                        color: controller.decordedlendingReponse["current_balance"].toString() ==
                                                                                "0"
                                                                            ? Colors
                                                                                .grey
                                                                            : Colors
                                                                                .black,
                                                                        borderRadius: const BorderRadius
                                                                            .all(
                                                                            Radius.circular(5))),
                                                                    child: Text(
                                                                        "USE CREDITS",
                                                                        style: GoogleFonts.lexendExa(
                                                                            fontWeight:
                                                                                FontWeight.w300,
                                                                            color: Colors.white,
                                                                            fontSize: 10)),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),

                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 20,
                                                                    bottom: 30),
                                                            child: Row(
                                                              children: [
                                                                Flexible(
                                                                  child:
                                                                      Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    height: 100,
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            Text(
                                                                              "AED",
                                                                              style: GoogleFonts.lexendDeca(
                                                                                fontWeight: FontWeight.w300,
                                                                                color: MyColors.themecolor,
                                                                                fontSize: 25,
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            Text(
                                                                              controller.decordedlendingReponse.isEmpty ? "" : MoneyFormatter(amount: double.parse(controller.decordedlendingReponse["total_income"].toString())).output.compactNonSymbol,
                                                                              style: GoogleFonts.lexendDeca(
                                                                                fontWeight: FontWeight.w300,
                                                                                color: MyColors.themecolor,
                                                                                fontSize: 30,
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                        Container(
                                                                          margin: const EdgeInsets
                                                                              .only(
                                                                              top: 10),
                                                                          child:
                                                                              Text(
                                                                            "TOTAL INCOME",
                                                                            style:
                                                                                GoogleFonts.lexendExa(
                                                                              fontWeight: FontWeight.w300,
                                                                              color: const Color(0xff868E96),
                                                                              fontSize: 12,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  height: 100,
                                                                  width: 1,
                                                                  color: const Color(
                                                                      0xffE2E2E2),
                                                                ),
                                                                Flexible(
                                                                  child:
                                                                      SizedBox(
                                                                    height: 100,
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            const SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            Text(
                                                                              controller.decordedlendingReponse.isEmpty ? "" : controller.decordedlendingReponse["pending_request"].toString(),
                                                                              style: GoogleFonts.lexendDeca(
                                                                                fontWeight: FontWeight.w300,
                                                                                color: MyColors.themecolor,
                                                                                fontSize: 30,
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                        Container(
                                                                          margin: const EdgeInsets
                                                                              .only(
                                                                              top: 10),
                                                                          child:
                                                                              Text(
                                                                            "PENDING REQUESTS",
                                                                            style:
                                                                                GoogleFonts.lexendExa(
                                                                              fontWeight: FontWeight.w300,
                                                                              color: const Color(0xff868E96),
                                                                              fontSize: 12,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),

                                                          Container(
                                                            color: const Color(
                                                                0xffFFFCEB),
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child:
                                                                DropdownButtonHideUnderline(
                                                              child:
                                                                  DropdownButton2<
                                                                      String>(
                                                                isExpanded:
                                                                    true,
                                                                hint: Text(
                                                                  '2024',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .hintColor,
                                                                  ),
                                                                ),
                                                                items:
                                                                    yearslending
                                                                        .map((String
                                                                                item) =>
                                                                            DropdownMenuItem<String>(
                                                                              value: item,
                                                                              child: Text(
                                                                                item,
                                                                                style: const TextStyle(
                                                                                  fontSize: 14,
                                                                                ),
                                                                              ),
                                                                            ))
                                                                        .toList(),
                                                                value:
                                                                    selectedyearLender,
                                                                onChanged:
                                                                    (String?
                                                                        value) {
                                                                  setState(() {
                                                                    selectedyearLender =
                                                                        value;
                                                                    controller.getaccontDetails(
                                                                        context,
                                                                        selectedyearLender
                                                                            .toString());
                                                                  });
                                                                },
                                                                buttonStyleData:
                                                                    const ButtonStyleData(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              16),
                                                                  height: 40,
                                                                  width: 100,
                                                                ),
                                                                menuItemStyleData:
                                                                    const MenuItemStyleData(
                                                                  height: 40,
                                                                ),
                                                              ),
                                                            ),
                                                          ),

// graph bar and values ========================================================================================

                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              AnimatedContainer(
                                                                duration:
                                                                    const Duration(
                                                                        milliseconds:
                                                                            500),
                                                                color: const Color(
                                                                    0xffFFFCEB),
                                                                margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            15),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            30,
                                                                        bottom:
                                                                            10),
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                height: controller
                                                                        .lentingGraph
                                                                        .isEmpty
                                                                    ? 100
                                                                    : 250,
                                                                child:
                                                                    DefaultTextStyle(
                                                                  style: GoogleFonts.lexendDeca(
                                                                      fontSize:
                                                                          8,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300),
                                                                  child: DChartBarO(
                                                                      configRenderBar: ConfigRenderBar(
                                                                        radius:
                                                                            0,
                                                                      ),
                                                                      animate: false,
                                                                      fillColor: (group, ordinalData, index) {
                                                                        return Colors
                                                                            .black;
                                                                      },
                                                                      groupList: [
                                                                        OrdinalGroup(
                                                                          id: '1',
                                                                          data: controller
                                                                              .lentingGraph
                                                                              .map(
                                                                                (e) => OrdinalData(domain: e["month"].toString(), measure: e["earn"]),
                                                                              )
                                                                              .toList(),
                                                                        ),
                                                                      ]),
                                                                ),
                                                              ),
                                                            ],
                                                          ),

                                                          const SizedBox(
                                                              height: 20),

                                                          //tabbar two inside tabbar one ========================================================================================================

                                                          Theme(
                                                            data: ThemeData(
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              splashColor: Colors
                                                                  .transparent,
                                                            ),
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                //This is for background color
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.0),
                                                                //This is for bottom border that is needed
                                                              ),
                                                              child: TabBar(
                                                                splashFactory:
                                                                    NoSplash
                                                                        .splashFactory,
                                                                indicatorColor:
                                                                    Colors
                                                                        .black,
                                                                indicatorWeight:
                                                                    4,
                                                                labelColor:
                                                                    Colors
                                                                        .black,
                                                                unselectedLabelColor:
                                                                    Colors
                                                                        .black,
                                                                labelStyle: GoogleFonts.lexendExa(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300),
                                                                tabs: [
                                                                  const Tab(
                                                                      text:
                                                                          "CALENDAR"),
                                                                  const Tab(
                                                                      text:
                                                                          "MY CLOSET"),
                                                                  controller.decordedlendingReponse["pending_request"]
                                                                              .toString() ==
                                                                          "0"
                                                                      ? const Tab(
                                                                          text:
                                                                              "REQUESTS")
                                                                      : badges
                                                                          .Badge(
                                                                          badgeContent:
                                                                              Text(
                                                                            controller.decordedlendingReponse.isEmpty
                                                                                ? ""
                                                                                : controller.decordedlendingReponse["pending_request"].toString(),
                                                                            style:
                                                                                GoogleFonts.lexendDeca(fontSize: 10, color: Colors.white),
                                                                          ),
                                                                          child:
                                                                              const Tab(text: "REQUESTS"),
                                                                        ),
                                                                ],
                                                                onTap: (value) {
                                                                  if (value ==
                                                                      0) {
                                                                    if (!calenderTabbed) {
                                                                      getcalenderData();
                                                                    }

                                                                    setState(
                                                                        () {
                                                                      calenderTabbed ==
                                                                          true;
                                                                    });
                                                                  } else if (value ==
                                                                      2) {
                                                                    if (!requestTabbed) {
                                                                      myrequests(
                                                                          pagenoMR);
                                                                    }

                                                                    setState(
                                                                        () {
                                                                      requestTabbed ==
                                                                          true;
                                                                    });
                                                                  }
                                                                },
                                                                controller:
                                                                    tabController2,
                                                              ),
                                                            ),
                                                          ),

                                                          // tabbar view two =====================================================================================
                                                          SizedBox(
                                                            height: 500,
                                                            child: TabBarView(
                                                                physics:
                                                                    const NeverScrollableScrollPhysics(),
                                                                controller:
                                                                    tabController2,
                                                                children: [
                                                                  // tabbar two first tab
                                                                  MyCustomCalender(
                                                                    appointmentsList: decordedCalenderResponse
                                                                        .map((e) => Appointment(
                                                                            startTime:
                                                                                DateTime.parse(e["startTime"]),
                                                                            endTime: DateTime.parse(e["endTime"]),
                                                                            subject: e["subject"].toString(),
                                                                            color: const Color(0xffF6F5F1)))
                                                                        .toList(),
                                                                    onViewChanged:
                                                                        (details) {},
                                                                    onAddEvent:
                                                                        (details) {},
                                                                    onAppointmentResizeEndCell:
                                                                        (details) {},
                                                                    onAppointmentResizeStartCell:
                                                                        (details) {},
                                                                    onAppointmentResizeUpdateCell:
                                                                        (details) {},
                                                                    onSelectionChangedCell:
                                                                        (details) {},
                                                                  ),

                                                                  // tabbar two second tab=====================

                                                                  controller.decordedClosetsResponse
                                                                              .isEmpty &&
                                                                          pagenoMC ==
                                                                              1
                                                                      ? Center(
                                                                          child:
                                                                              Text(
                                                                            "No Approved Closets Found",
                                                                            style: GoogleFonts.lexendDeca(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w300,
                                                                                color: Colors.grey),
                                                                          ),
                                                                        )
                                                                      : Column(
                                                                          children: [
                                                                            Container(
                                                                              margin: const EdgeInsets.only(top: 5),
                                                                              padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                                                                              decoration: const BoxDecoration(color: Color(0xffF6F5F1)),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Container(
                                                                                    width: 50,
                                                                                    alignment: Alignment.centerLeft,
                                                                                    child: Text('No', style: GoogleFonts.lexendDeca(color: Colors.black, fontWeight: FontWeight.w300, fontSize: 13)),
                                                                                  ),
                                                                                  Container(
                                                                                    width: 80,
                                                                                    alignment: Alignment.centerLeft,
                                                                                    child: Text('Product', style: GoogleFonts.lexendDeca(color: Colors.black, fontWeight: FontWeight.w300, fontSize: 13)),
                                                                                  ),
                                                                                  Container(
                                                                                    width: 80,
                                                                                    alignment: Alignment.centerLeft,
                                                                                    child: Text('Brand', style: GoogleFonts.lexendDeca(color: Colors.black, fontWeight: FontWeight.w300, fontSize: 13)),
                                                                                  ),
                                                                                  Text('Status', style: GoogleFonts.lexendDeca(color: Colors.black, fontWeight: FontWeight.w300, fontSize: 13)),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              child: Column(
                                                                                children: [
                                                                                  Expanded(
                                                                                    child: Stack(
                                                                                      children: [
                                                                                        ListView.builder(
                                                                                            controller: _scrollControllerMC,
                                                                                            physics: requestScroll ? const ClampingScrollPhysics() : const NeverScrollableScrollPhysics(),
                                                                                            itemCount: controller.decordedClosetsResponse.length,
                                                                                            shrinkWrap: true,
                                                                                            itemBuilder: (context, index) {
                                                                                              return Column(
                                                                                                children: [
                                                                                                  InkWell(
                                                                                                    onTap: () {
                                                                                                      Navigator.push(
                                                                                                          context,
                                                                                                          MaterialPageRoute(
                                                                                                              builder: (context) => ManageItem(
                                                                                                                    productID: controller.decordedClosetsResponse[index]["id"].toString(),
                                                                                                                  )));
                                                                                                    },
                                                                                                    child: Container(
                                                                                                      padding: const EdgeInsets.only(left: 15, right: 10, top: 10, bottom: 10),
                                                                                                      child: Row(
                                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                        children: [
                                                                                                          Container(
                                                                                                            width: 45,
                                                                                                            alignment: Alignment.centerLeft,
                                                                                                            child: Wrap(
                                                                                                              alignment: WrapAlignment.center,
                                                                                                              crossAxisAlignment: WrapCrossAlignment.center,
                                                                                                              direction: Axis.horizontal,
                                                                                                              children: [
                                                                                                                Text(
                                                                                                                  "${index + 1}",
                                                                                                                  style: GoogleFonts.lexendDeca(color: Colors.black, fontWeight: FontWeight.w300, fontSize: 13),
                                                                                                                ),
                                                                                                                Container(
                                                                                                                  transform: Matrix4.translationValues(20, 0, 0),
                                                                                                                  child: CachedNetworkImage(
                                                                                                                    imageUrl: controller.decordedClosetsResponse[index]["img_url"].toString(),
                                                                                                                    height: 25,
                                                                                                                    width: 25,
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ],
                                                                                                            ),
                                                                                                          ),
                                                                                                          Container(
                                                                                                            alignment: Alignment.centerLeft,
                                                                                                            width: 80,
                                                                                                            child: Text(
                                                                                                              controller.decordedClosetsResponse[index]["title"].toString(),
                                                                                                              textAlign: TextAlign.left,
                                                                                                              style: GoogleFonts.lexendDeca(color: Colors.black, fontWeight: FontWeight.w300, fontSize: 13),
                                                                                                              maxLines: 1,
                                                                                                              overflow: TextOverflow.ellipsis,
                                                                                                            ),
                                                                                                          ),
                                                                                                          Container(
                                                                                                            alignment: Alignment.centerLeft,
                                                                                                            width: 80,
                                                                                                            child: Text(
                                                                                                              controller.decordedClosetsResponse[index]["brand_name"].toString(),
                                                                                                              maxLines: 1,
                                                                                                              overflow: TextOverflow.ellipsis,
                                                                                                              style: GoogleFonts.lexendDeca(color: Colors.black, fontWeight: FontWeight.w300, fontSize: 13),
                                                                                                            ),
                                                                                                          ),
                                                                                                          controller.closetsReponse["closet_status"].toString() == "1"
                                                                                                              ? FlutterSwitch(
                                                                                                                  activeColor: const Color(0xFF76EE59),
                                                                                                                  inactiveColor: const Color.fromARGB(255, 219, 219, 219),
                                                                                                                  height: 20,
                                                                                                                  width: 40,
                                                                                                                  value: controller.decordedClosetsResponse[index]["lender_status"] == 1 ? true : false,
                                                                                                                  borderRadius: 20.0,
                                                                                                                  toggleSize: 15,
                                                                                                                  showOnOff: false,
                                                                                                                  onToggle: (val) {
                                                                                                                    setState(() {
                                                                                                                      updatemyClosetsStatus(controller.decordedClosetsResponse[index]["id"].toString(), index);
                                                                                                                    });
                                                                                                                  },
                                                                                                                )
                                                                                                              : Container(
                                                                                                                  width: 40,
                                                                                                                  height: 20,
                                                                                                                  alignment: Alignment.centerRight,
                                                                                                                  child: Text("Paused", overflow: TextOverflow.ellipsis, style: GoogleFonts.lexendDeca(color: const Color.fromARGB(255, 168, 168, 168), fontWeight: FontWeight.w300, fontSize: 11)),
                                                                                                                )
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                  Container(
                                                                                                    width: MediaQuery.of(context).size.width,
                                                                                                    height: 1,
                                                                                                    color: const Color.fromARGB(255, 211, 211, 211),
                                                                                                  )
                                                                                                ],
                                                                                              );
                                                                                            }),
                                                                                        Visibility(
                                                                                          visible: controller.showLazyIndicator,
                                                                                          child: Positioned(
                                                                                            bottom: 0,
                                                                                            child: Container(width: MediaQuery.of(context).size.width, alignment: Alignment.center, padding: const EdgeInsets.only(right: 20), margin: const EdgeInsets.only(bottom: 10), child: const CircularProgressIndicator()),
                                                                                          ),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                  ),

                                                                                  // for closed all closets ===================================================================================

                                                                                  Container(
                                                                                    padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                                                                                    decoration: const BoxDecoration(color: Colors.white),
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                      children: [
                                                                                        Text("PAUSE MY CLOSET", style: GoogleFonts.lexendExa(fontWeight: FontWeight.w300, color: Colors.black, fontSize: 16)),
                                                                                        FlutterSwitch(
                                                                                          activeColor: const Color(0xFF76EE59),
                                                                                          inactiveColor: const Color.fromARGB(255, 219, 219, 219),
                                                                                          height: 20,
                                                                                          width: 40,
                                                                                          value: controller.closetsReponse["closet_status"].toString() == "1" ? false : true,
                                                                                          borderRadius: 20.0,
                                                                                          toggleSize: 15,
                                                                                          showOnOff: false,
                                                                                          onToggle: (val) {
                                                                                            updateAllClosets();
                                                                                          },
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                  // tabbar two third tab======================================================================

                                                                  decordedrequestResponse
                                                                              .isEmpty &&
                                                                          pagenoMR ==
                                                                              1
                                                                      ? Center(
                                                                          child:
                                                                              Text(
                                                                            "No Requests",
                                                                            style: GoogleFonts.lexendDeca(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w300,
                                                                                color: Colors.grey),
                                                                          ),
                                                                        )
                                                                      : Stack(
                                                                          children: [
                                                                            Container(
                                                                              margin: const EdgeInsets.only(top: 5),
                                                                              child: ListView.builder(
                                                                                  controller: _scrollControllerMR,
                                                                                  physics: requestScroll ? const ClampingScrollPhysics() : const NeverScrollableScrollPhysics(),
                                                                                  itemCount: decordedrequestResponse.length,
                                                                                  shrinkWrap: true,
                                                                                  itemBuilder: (context, index) {
                                                                                    return Container(
                                                                                      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                                                                                      padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 15),
                                                                                      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Color(0xffF6F5F1)),
                                                                                      child: Column(
                                                                                        children: [
                                                                                          Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                                            children: [
                                                                                              // itemscount text and product image
                                                                                              const SizedBox(width: 10),
                                                                                              InkWell(
                                                                                                onTap: () {
                                                                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProductView(index: 0, id: decordedrequestResponse[index]["product_id"].toString(), comesFrom: "", fromCart: false)));
                                                                                                },
                                                                                                child: Container(
                                                                                                  margin: const EdgeInsets.only(top: 00),
                                                                                                  child: ClipRRect(
                                                                                                    borderRadius: BorderRadius.circular(5),
                                                                                                    child: CachedNetworkImage(
                                                                                                      imageUrl: decordedrequestResponse[index]["img_url"].toString(),
                                                                                                      width: 80,
                                                                                                      fit: BoxFit.cover,
                                                                                                      height: 180,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),

                                                                                              const SizedBox(width: 20),

                                                                                              // heading

                                                                                              Column(
                                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                children: [
                                                                                                  Container(
                                                                                                    alignment: Alignment.centerLeft,
                                                                                                    constraints: const BoxConstraints(maxWidth: 100),
                                                                                                    margin: const EdgeInsets.only(bottom: 10),
                                                                                                    child: Text(
                                                                                                      "Order No ",
                                                                                                      maxLines: 1,
                                                                                                      overflow: TextOverflow.ellipsis,
                                                                                                      style: GoogleFonts.lexendDeca(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 12),
                                                                                                    ),
                                                                                                  ),
                                                                                                  Container(
                                                                                                    alignment: Alignment.centerLeft,
                                                                                                    constraints: const BoxConstraints(maxWidth: 100),
                                                                                                    margin: const EdgeInsets.only(bottom: 10),
                                                                                                    child: Text(
                                                                                                      "Item Name",
                                                                                                      maxLines: 1,
                                                                                                      overflow: TextOverflow.ellipsis,
                                                                                                      style: GoogleFonts.lexendDeca(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 12),
                                                                                                    ),
                                                                                                  ),
                                                                                                  Container(
                                                                                                    alignment: Alignment.centerLeft,
                                                                                                    constraints: const BoxConstraints(maxWidth: 100),
                                                                                                    margin: const EdgeInsets.only(bottom: 10),
                                                                                                    child: Text(
                                                                                                      "Renter",
                                                                                                      maxLines: 1,
                                                                                                      overflow: TextOverflow.ellipsis,
                                                                                                      style: GoogleFonts.lexendDeca(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 12),
                                                                                                    ),
                                                                                                  ),
                                                                                                  Container(
                                                                                                    alignment: Alignment.centerLeft,
                                                                                                    constraints: const BoxConstraints(maxWidth: 100),
                                                                                                    margin: const EdgeInsets.only(bottom: 10),
                                                                                                    child: Text(
                                                                                                      "Renter Rating",
                                                                                                      maxLines: 1,
                                                                                                      overflow: TextOverflow.ellipsis,
                                                                                                      style: GoogleFonts.lexendDeca(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 12),
                                                                                                    ),
                                                                                                  ),
                                                                                                  Container(
                                                                                                    alignment: Alignment.centerLeft,
                                                                                                    constraints: const BoxConstraints(maxWidth: 100),
                                                                                                    margin: const EdgeInsets.only(bottom: 10),
                                                                                                    child: Text(
                                                                                                      "Rental Fees",
                                                                                                      maxLines: 1,
                                                                                                      overflow: TextOverflow.ellipsis,
                                                                                                      style: GoogleFonts.lexendDeca(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 12),
                                                                                                    ),
                                                                                                  ),
                                                                                                  Container(
                                                                                                    alignment: Alignment.centerLeft,
                                                                                                    margin: const EdgeInsets.only(bottom: 10),
                                                                                                    constraints: const BoxConstraints(maxWidth: 100),
                                                                                                    child: Text(
                                                                                                      "Rental Duration",
                                                                                                      maxLines: 1,
                                                                                                      overflow: TextOverflow.ellipsis,
                                                                                                      style: GoogleFonts.lexendDeca(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 12),
                                                                                                    ),
                                                                                                  ),
                                                                                                  Container(
                                                                                                    margin: const EdgeInsets.only(bottom: 10),
                                                                                                    alignment: Alignment.centerLeft,
                                                                                                    constraints: const BoxConstraints(maxWidth: 100),
                                                                                                    child: Text(
                                                                                                      "Rental Start",
                                                                                                      maxLines: 1,
                                                                                                      overflow: TextOverflow.ellipsis,
                                                                                                      style: GoogleFonts.lexendDeca(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 12),
                                                                                                    ),
                                                                                                  ),
                                                                                                  Container(
                                                                                                    alignment: Alignment.centerLeft,
                                                                                                    constraints: const BoxConstraints(maxWidth: 100),
                                                                                                    child: Text(
                                                                                                      "Rental End",
                                                                                                      maxLines: 1,
                                                                                                      overflow: TextOverflow.ellipsis,
                                                                                                      style: GoogleFonts.lexendDeca(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 12),
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),

                                                                                              const SizedBox(width: 5),

                                                                                              // values
                                                                                              Expanded(
                                                                                                child: Column(
                                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                  children: [
                                                                                                    Container(
                                                                                                      alignment: Alignment.centerLeft,
                                                                                                      constraints: const BoxConstraints(maxWidth: 100),
                                                                                                      margin: const EdgeInsets.only(bottom: 10),
                                                                                                      child: Text(decordedrequestResponse[index]["order_no"].toString(), maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.lexendDeca(color: Colors.black, fontWeight: FontWeight.w300, fontSize: 12)),
                                                                                                    ),
                                                                                                    // value one

                                                                                                    Container(
                                                                                                      alignment: Alignment.centerLeft,
                                                                                                      constraints: const BoxConstraints(maxWidth: 100),
                                                                                                      margin: const EdgeInsets.only(bottom: 10),
                                                                                                      child: Text(decordedrequestResponse[index]["title"].toString(), maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.lexendDeca(color: Colors.black, fontWeight: FontWeight.w300, fontSize: 12)),
                                                                                                    ),

                                                                                                    // value two

                                                                                                    Container(
                                                                                                      alignment: Alignment.centerLeft,
                                                                                                      constraints: const BoxConstraints(maxWidth: 100),
                                                                                                      margin: const EdgeInsets.only(bottom: 10),
                                                                                                      child: Text(decordedrequestResponse[index]["first_name"].toString(), maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.lexendDeca(color: Colors.black, fontWeight: FontWeight.w300, fontSize: 12)),
                                                                                                    ),

                                                                                                    Container(
                                                                                                      constraints: const BoxConstraints(maxWidth: 100),
                                                                                                      margin: const EdgeInsets.only(bottom: 10),
                                                                                                      alignment: Alignment.centerLeft,
                                                                                                      child: RatingBarIndicator(
                                                                                                        itemPadding: EdgeInsets.zero,
                                                                                                        rating: myrequesttReponse.isEmpty ? 0 : double.parse(decordedrequestResponse[index]["rating"].toString()),
                                                                                                        itemBuilder: (context, index) => const Icon(
                                                                                                          Icons.star_rate_rounded,
                                                                                                          color: Color(0xffCAAB05),
                                                                                                        ),
                                                                                                        itemCount: 5,
                                                                                                        itemSize: 15.0,
                                                                                                        direction: Axis.horizontal,
                                                                                                      ),
                                                                                                    ),

                                                                                                    // value three

                                                                                                    Container(
                                                                                                      alignment: Alignment.centerLeft,
                                                                                                      constraints: const BoxConstraints(maxWidth: 100),
                                                                                                      margin: const EdgeInsets.only(bottom: 10),
                                                                                                      child: Text("AED ${decordedrequestResponse[index]["amount"]}", maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.lexendDeca(color: Colors.black, fontWeight: FontWeight.w300, fontSize: 12)),
                                                                                                    ),

                                                                                                    // value four

                                                                                                    Container(
                                                                                                      alignment: Alignment.centerLeft,
                                                                                                      margin: const EdgeInsets.only(bottom: 10),
                                                                                                      constraints: const BoxConstraints(maxWidth: 100),
                                                                                                      child: Text("${decordedrequestResponse[index]["days"]} Days", maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.lexendDeca(color: Colors.black, fontWeight: FontWeight.w300, fontSize: 12)),
                                                                                                    ),

                                                                                                    Container(
                                                                                                      alignment: Alignment.centerLeft,
                                                                                                      child: Text("${decordedrequestResponse[index]["start_date"]}", maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.lexendDeca(color: Colors.black, fontWeight: FontWeight.w300, fontSize: 12)),
                                                                                                    ),

                                                                                                    const SizedBox(height: 10),

                                                                                                    Container(
                                                                                                      alignment: Alignment.centerLeft,
                                                                                                      child: Text("${decordedrequestResponse[index]["end_date"]}", maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.lexendDeca(color: Colors.black, fontWeight: FontWeight.w300, fontSize: 12)),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                          Container(
                                                                                            margin: const EdgeInsets.only(top: 10, right: 10, bottom: 10),
                                                                                            alignment: Alignment.centerRight,
                                                                                            child: decordedrequestResponse[index]["status"] == 0
                                                                                                ? Wrap(
                                                                                                    alignment: WrapAlignment.center,
                                                                                                    direction: Axis.horizontal,
                                                                                                    children: [
                                                                                                      InkWell(
                                                                                                        onTap: () {
                                                                                                          requestApproveRejected(decordedrequestResponse[index]["id"].toString(), "2", index);
                                                                                                        },
                                                                                                        child: Container(
                                                                                                          alignment: Alignment.center,
                                                                                                          width: 60,
                                                                                                          padding: const EdgeInsets.all(5),
                                                                                                          decoration: BoxDecoration(color: MyColors.themecolor, borderRadius: BorderRadius.circular(5)),
                                                                                                          child: Text(
                                                                                                            "REJECT".toUpperCase(),
                                                                                                            style: GoogleFonts.lexendExa(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 9),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                      const SizedBox(width: 3),
                                                                                                      InkWell(
                                                                                                        onTap: () {
                                                                                                          requestApproveRejected(decordedrequestResponse[index]["id"].toString(), "1", index);
                                                                                                        },
                                                                                                        child: Container(
                                                                                                          alignment: Alignment.center,
                                                                                                          width: 60,
                                                                                                          padding: const EdgeInsets.all(5),
                                                                                                          decoration: BoxDecoration(color: const Color(0xff10AF3D), borderRadius: BorderRadius.circular(5)),
                                                                                                          child: Text(
                                                                                                            "APPROVE".toUpperCase(),
                                                                                                            style: GoogleFonts.lexendExa(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 9),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ],
                                                                                                  )
                                                                                                :

                                                                                                //  if status == 1 means approved

                                                                                                decordedrequestResponse[index]["status"] == 1
                                                                                                    ? Container(
                                                                                                        alignment: Alignment.center,
                                                                                                        width: 120,
                                                                                                        padding: const EdgeInsets.all(5),
                                                                                                        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(5)),
                                                                                                        child: Text(
                                                                                                          "APPROVED".toUpperCase(),
                                                                                                          style: GoogleFonts.lexendExa(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 9),
                                                                                                        ),
                                                                                                      )
                                                                                                    :

                                                                                                    //  if status == 2 means rejected

                                                                                                    decordedrequestResponse[index]["status"] == 2
                                                                                                        ? Container(
                                                                                                            alignment: Alignment.center,
                                                                                                            width: 120,
                                                                                                            padding: const EdgeInsets.all(5),
                                                                                                            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(5)),
                                                                                                            child: Text(
                                                                                                              "REJECTED".toUpperCase(),
                                                                                                              style: GoogleFonts.lexendExa(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 9),
                                                                                                            ),
                                                                                                          )
                                                                                                        :

                                                                                                        //  if status == 4 means delivered

                                                                                                        decordedrequestResponse[index]["status"] == 3
                                                                                                            ? Container(
                                                                                                                alignment: Alignment.center,
                                                                                                                width: 120,
                                                                                                                padding: const EdgeInsets.all(5),
                                                                                                                decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(5)),
                                                                                                                child: Text(
                                                                                                                  "In Progress".toUpperCase(),
                                                                                                                  style: GoogleFonts.lexendExa(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 9),
                                                                                                                ),
                                                                                                              )
                                                                                                            : decordedrequestResponse[index]["status"] == 4
                                                                                                                ? Container(
                                                                                                                    alignment: Alignment.center,
                                                                                                                    width: 120,
                                                                                                                    padding: const EdgeInsets.all(5),
                                                                                                                    decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(5)),
                                                                                                                    child: Text(
                                                                                                                      "In Progress".toUpperCase(),
                                                                                                                      style: GoogleFonts.lexendExa(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 9),
                                                                                                                    ),
                                                                                                                  )
                                                                                                                : decordedrequestResponse[index]["status"] == 5
                                                                                                                    ? Container(
                                                                                                                        alignment: Alignment.center,
                                                                                                                        width: 120,
                                                                                                                        padding: const EdgeInsets.all(5),
                                                                                                                        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(5)),
                                                                                                                        child: Text(
                                                                                                                          "In Progress".toUpperCase(),
                                                                                                                          style: GoogleFonts.lexendExa(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 9),
                                                                                                                        ),
                                                                                                                      )
                                                                                                                    : decordedrequestResponse[index]["status"] == 6
                                                                                                                        ? Row(
                                                                                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                                            children: [
                                                                                                                              Visibility(
                                                                                                                                visible: decordedrequestResponse[index]["status"] == 6 ? true : false,
                                                                                                                                child: InkWell(
                                                                                                                                  onTap: () {
                                                                                                                                    renterReviewDialog(decordedrequestResponse[index]["id"].toString(), decordedrequestResponse[index]["username"].toString(), decordedrequestResponse[index]["profile_img"].toString());
                                                                                                                                  },
                                                                                                                                  child: Container(
                                                                                                                                    alignment: Alignment.centerRight,
                                                                                                                                    margin: const EdgeInsets.only(right: 10),
                                                                                                                                    child: Container(
                                                                                                                                      alignment: Alignment.center,
                                                                                                                                      width: 120,
                                                                                                                                      padding: const EdgeInsets.all(5),
                                                                                                                                      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(5)),
                                                                                                                                      child: Text(
                                                                                                                                        "REVIEW RENTER".toUpperCase(),
                                                                                                                                        style: GoogleFonts.lexendExa(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 9),
                                                                                                                                      ),
                                                                                                                                    ),
                                                                                                                                  ),
                                                                                                                                ),
                                                                                                                              ),
                                                                                                                              Container(
                                                                                                                                alignment: Alignment.center,
                                                                                                                                width: 120,
                                                                                                                                padding: const EdgeInsets.all(5),
                                                                                                                                decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(5)),
                                                                                                                                child: Text(
                                                                                                                                  "Completed".toUpperCase(),
                                                                                                                                  style: GoogleFonts.lexendExa(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 9),
                                                                                                                                ),
                                                                                                                              ),
                                                                                                                            ],
                                                                                                                          )


                                                                                                                                    :




                                                                   decordedrequestResponse[
                                                                      index]
                                                                  ["status"] ==
                                                              7
                                                          ? Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              width: 120,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .black,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5)),
                                                              child: Text(
                                                                "Cancelled"
                                                                    .toUpperCase(),
                                                                style: GoogleFonts.lexendExa(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                    fontSize:
                                                                        9),
                                                              ),
                                                            )
                                                                                                                        :

                                                                                                                        // else empty container

                                                                                                                        Container(),
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    );
                                                                                  }),
                                                                            ),
                                                                            Visibility(
                                                                              visible: showLazyIndicatorMR,
                                                                              child: Positioned(
                                                                                bottom: 0,
                                                                                child: Container(width: MediaQuery.of(context).size.width, alignment: Alignment.center, padding: const EdgeInsets.only(right: 20), margin: const EdgeInsets.only(bottom: 10), child: const CircularProgressIndicator()),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        )
                                                                ]),
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                    // second tab =================================================================================================================

                                                    SingleChildScrollView(
                                                      controller:
                                                          _scrollControllerMRT,
                                                      physics:
                                                          const ClampingScrollPhysics(),
                                                      child: Column(
                                                        children: [
                                                          // profile info second tab =======================================================================================

                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 20),
                                                            decoration:
                                                                const BoxDecoration(),
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 10,
                                                                    right: 10,
                                                                    bottom: 10),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                controller
                                                                        .profileImage
                                                                        .isEmpty
                                                                    ? const SizedBox(
                                                                        width:
                                                                            60,
                                                                        height:
                                                                            60)
                                                                    : Container(
                                                                        width:
                                                                            60,
                                                                        height:
                                                                            60,
                                                                        decoration:
                                                                            const BoxDecoration(shape: BoxShape.circle),
                                                                        child:
                                                                            ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(1000),
                                                                          child:
                                                                              CachedNetworkImage(
                                                                            imageUrl:
                                                                                controller.profileImage,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                            height:
                                                                                55,
                                                                            width:
                                                                                55,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                Container(
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              5),
                                                                  width: 80,
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Container(
                                                                        margin: const EdgeInsets
                                                                            .only(
                                                                            left:
                                                                                5),
                                                                        child:
                                                                            Text(
                                                                          controller
                                                                              .profileName,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style: GoogleFonts.lexendDeca(
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.w300,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      RatingBarIndicator(
                                                                        itemPadding:
                                                                            EdgeInsets.zero,
                                                                        rating: controller.decordedlendingReponse.isEmpty
                                                                            ? 0
                                                                            : double.parse(controller.decordedlendingReponse["rating"].toString()),
                                                                        itemBuilder:
                                                                            (context, index) =>
                                                                                const Icon(
                                                                          Icons
                                                                              .star_rate_rounded,
                                                                          color:
                                                                              Color(0xffCAAB05),
                                                                        ),
                                                                        itemCount:
                                                                            5,
                                                                        itemSize:
                                                                            15.0,
                                                                        direction:
                                                                            Axis.horizontal,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                const MyRental()));
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10),
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    margin: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            10),
                                                                    height: 31,
                                                                    decoration: const BoxDecoration(
                                                                        color: MyColors
                                                                            .themecolor,
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(5))),
                                                                    child: Text(
                                                                        "ORDER HISTORY",
                                                                        style: GoogleFonts.lexendExa(
                                                                            fontWeight:
                                                                                FontWeight.w300,
                                                                            color: Colors.white,
                                                                            fontSize: 12)),
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                const EditProfile()));
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    margin: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            10),
                                                                    width: 31,
                                                                    height: 31,
                                                                    decoration: const BoxDecoration(
                                                                        color: Color(
                                                                            0xffD9D9D9),
                                                                        shape: BoxShape
                                                                            .circle),
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: SvgPicture
                                                                        .asset(
                                                                            "assets/images/editsmall.svg"),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),

                                                          // profile info =======================================================================================

                                                          Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 15,
                                                                      right:
                                                                          15),
                                                              width: MediaQuery
                                                                      .of(
                                                                          context)
                                                                  .size
                                                                  .width,
                                                              height: 50,
                                                              decoration: const BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.all(Radius
                                                                          .circular(
                                                                              10))),
                                                              child: Stack(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                children: [
                                                                  Image.asset(
                                                                    "assets/images/CO2bg.png",
                                                                    height: 50,
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                  ),
                                                                  Container(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                          "SAVED CO2 FOOTPRINTS",
                                                                          style:
                                                                              GoogleFonts.lexendExa(
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.w300,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          controller.decordedrentingReponse.isEmpty
                                                                              ? ""
                                                                              : controller.decordedrentingReponse["co2_saved"].toString() + " Tonnes",
                                                                          style:
                                                                              GoogleFonts.lexendDeca(
                                                                            color: const Color.fromARGB(
                                                                                255,
                                                                                37,
                                                                                95,
                                                                                128),
                                                                            fontSize:
                                                                                20,
                                                                            fontWeight:
                                                                                FontWeight.w300,
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  )
                                                                ],
                                                              )),

                                                          // Container(
                                                          //   decoration: const BoxDecoration(
                                                          //       color: Colors.white,
                                                          //       boxShadow: [
                                                          //         BoxShadow(
                                                          //             color: Color.fromARGB(
                                                          //                 255, 230, 230, 230),
                                                          //             blurRadius: 1,
                                                          //             offset: Offset(0, 2))
                                                          //       ]),
                                                          //   padding: const EdgeInsets.only(
                                                          //       left: 10, right: 10, bottom: 10),
                                                          //   child: Row(
                                                          //     children: [
                                                          //       // one colum
                                                          //       SizedBox(
                                                          //         width: 100,
                                                          //         child: Column(
                                                          //           mainAxisAlignment:
                                                          //               MainAxisAlignment.center,
                                                          //           crossAxisAlignment:
                                                          //               CrossAxisAlignment.center,
                                                          //           children: [
                                                          //             const SizedBox(height: 10),
                                                          //             profileImage.isEmpty
                                                          //                 ? const SizedBox(
                                                          //                     width: 70, height: 70)
                                                          //                 : Container(
                                                          //                     width: 70,
                                                          //                     height: 70,

                                                          //                     decoration:
                                                          //                         const BoxDecoration(

                                                          //                             shape: BoxShape
                                                          //                                 .circle),
                                                          //                     child: ClipRRect(
                                                          //                       borderRadius:
                                                          //                           BorderRadius.circular(
                                                          //                               1000),
                                                          //                       child: CachedNetworkImage(
                                                          //                         imageUrl: profileImage,
                                                          //                         fit: BoxFit.cover,
                                                          //                         height: 55,
                                                          //                         width: 55,
                                                          //                       ),
                                                          //                     ),
                                                          //                   ),
                                                          //             // const SizedBox(height: 5),
                                                          //             // Text(
                                                          //             //   profileName,
                                                          //             //   overflow: TextOverflow.ellipsis,
                                                          //             //   style: GoogleFonts.lexendDeca(
                                                          //             //       fontSize: 12,
                                                          //             //       fontWeight: FontWeight.w400,
                                                          //             //       color: Colors.black),
                                                          //             // ),
                                                          //             // const SizedBox(height: 5),
                                                          //             // Text(
                                                          //             //   "Enterpreneur",
                                                          //             //   style: GoogleFonts.lexendDeca(
                                                          //             //       fontSize: 10,
                                                          //             //       fontWeight: FontWeight.w300,
                                                          //             //       color: Colors.black),
                                                          //             // )
                                                          //           ],
                                                          //         ),
                                                          //       ),

                                                          //       // second column
                                                          //       Expanded(
                                                          //         child: Container(
                                                          //           margin: const EdgeInsets.only(
                                                          //               left: 20, right: 10),
                                                          //           child: Column(
                                                          //             mainAxisAlignment:
                                                          //                 MainAxisAlignment.center,
                                                          //             crossAxisAlignment:
                                                          //                 CrossAxisAlignment.center,
                                                          //             children: [
                                                          //               // first row
                                                          //               Row(
                                                          //                 mainAxisAlignment:
                                                          //                     MainAxisAlignment
                                                          //                         .spaceBetween,
                                                          //                 crossAxisAlignment:
                                                          //                     CrossAxisAlignment.center,
                                                          //                 children: [
                                                          //                   const Text(
                                                          //                     "",
                                                          //                     style: TextStyle(
                                                          //                         fontSize: 15,
                                                          //                         color: Colors.black),
                                                          //                   ),
                                                          //                   Container(
                                                          //                     alignment:
                                                          //                         Alignment.centerLeft,
                                                          //                     child: RatingBarIndicator(
                                                          //                       rating:  controller.  decordedrentingReponse
                                                          //                               .isEmpty
                                                          //                           ? 0
                                                          //                           : double.parse(
                                                          //                                controller.  decordedrentingReponse[
                                                          //                                       "rating"]
                                                          //                                   .toString()),
                                                          //                       itemBuilder:
                                                          //                           (context, index) =>
                                                          //                               const Icon(
                                                          //                         Icons.star,
                                                          //                         color:
                                                          //                             Color(0xffCAAB05),
                                                          //                       ),
                                                          //                       itemCount: 5,
                                                          //                       itemSize: 20.0,
                                                          //                       direction:
                                                          //                           Axis.horizontal,
                                                          //                     ),
                                                          //                   ),
                                                          //                 ],
                                                          //               ),

                                                          //               const SizedBox(
                                                          //                 height: 10,
                                                          //               ),

                                                          //               // second row
                                                          //               Row(
                                                          //                 mainAxisAlignment:
                                                          //                     MainAxisAlignment
                                                          //                         .spaceBetween,
                                                          //                 crossAxisAlignment:
                                                          //                     CrossAxisAlignment.center,
                                                          //                 children: [
                                                          //                   // first colum
                                                          //                   Wrap(
                                                          //                     alignment:
                                                          //                         WrapAlignment.center,
                                                          //                     crossAxisAlignment:
                                                          //                         WrapCrossAlignment
                                                          //                             .center,
                                                          //                     direction: Axis.vertical,
                                                          //                     children: [
                                                          //                       Text(
                                                          //                         controller.   decordedrentingReponse
                                                          //                                 .isEmpty
                                                          //                             ? ""
                                                          //                             :  controller.  decordedrentingReponse[
                                                          //                                     "total_order"]
                                                          //                                 .toString(),
                                                          //                         style: GoogleFonts
                                                          //                             .lexendDeca(
                                                          //                                 fontSize: 17,
                                                          //                                 fontWeight:
                                                          //                                     FontWeight
                                                          //                                         .w400,
                                                          //                                 color: Colors
                                                          //                                     .black),
                                                          //                       ),
                                                          //                       Text(
                                                          //                         "Rentals",
                                                          //                         style: GoogleFonts
                                                          //                             .lexendDeca(
                                                          //                                 fontSize: 12,
                                                          //                                 fontWeight:
                                                          //                                     FontWeight
                                                          //                                         .w400,
                                                          //                                 color: Colors
                                                          //                                     .black),
                                                          //                       ),
                                                          //                     ],
                                                          //                   ),
                                                          //                   // second colum
                                                          //                   Wrap(
                                                          //                     alignment:
                                                          //                         WrapAlignment.center,
                                                          //                     crossAxisAlignment:
                                                          //                         WrapCrossAlignment
                                                          //                             .center,
                                                          //                     direction: Axis.vertical,
                                                          //                     children: [
                                                          //                       Text(
                                                          //                         controller.   lendingrentingResponse
                                                          //                                 .isEmpty
                                                          //                             ? ""
                                                          //                             : MoneyFormatter(
                                                          //                                     amount:  controller.  decordedrentingReponse
                                                          //                                             .isEmpty
                                                          //                                         ? 0
                                                          //                                         : double.parse(  controller. decordedrentingReponse["total_retail_amount"].toString().replaceAll(
                                                          //                                             ",",
                                                          //                                             "")))
                                                          //                                 .output
                                                          //                                 .compactNonSymbol,
                                                          //                         style: GoogleFonts
                                                          //                             .lexendDeca(
                                                          //                                 fontSize: 17,
                                                          //                                 fontWeight:
                                                          //                                     FontWeight
                                                          //                                         .w400,
                                                          //                                 color: Colors
                                                          //                                     .black),
                                                          //                       ),
                                                          //                       Text(
                                                          //                         "Retail Value",
                                                          //                         style: GoogleFonts
                                                          //                             .lexendDeca(
                                                          //                                 fontSize: 12,
                                                          //                                 fontWeight:
                                                          //                                     FontWeight
                                                          //                                         .w400,
                                                          //                                 color: Colors
                                                          //                                     .black),
                                                          //                       ),
                                                          //                     ],
                                                          //                   ),
                                                          //                   // third colum
                                                          //                   Wrap(
                                                          //                     alignment:
                                                          //                         WrapAlignment.center,
                                                          //                     crossAxisAlignment:
                                                          //                         WrapCrossAlignment
                                                          //                             .center,
                                                          //                     direction: Axis.vertical,
                                                          //                     children: [
                                                          //                       Text(
                                                          //                          controller.  lendingrentingResponse
                                                          //                                 .isEmpty
                                                          //                             ? ""
                                                          //                             : MoneyFormatter(
                                                          //                                     amount:  controller.  decordedrentingReponse
                                                          //                                             .isEmpty
                                                          //                                         ? 0
                                                          //                                         : double.parse(  controller. decordedrentingReponse["paid_value"].toString().replaceAll(
                                                          //                                             ",",
                                                          //                                             "")))
                                                          //                                 .output
                                                          //                                 .compactNonSymbol,
                                                          //                         style: GoogleFonts
                                                          //                             .lexendDeca(
                                                          //                                 fontSize: 17,
                                                          //                                 fontWeight:
                                                          //                                     FontWeight
                                                          //                                         .w400,
                                                          //                                 color: Colors
                                                          //                                     .black),
                                                          //                       ),
                                                          //                       Text(
                                                          //                         "Paid Value",
                                                          //                         style: GoogleFonts
                                                          //                             .lexendDeca(
                                                          //                                 fontSize: 12,
                                                          //                                 fontWeight:
                                                          //                                     FontWeight
                                                          //                                         .w400,
                                                          //                                 color: Colors
                                                          //                                     .black),
                                                          //                       ),
                                                          //                     ],
                                                          //                   ),
                                                          //                 ],
                                                          //               ),

                                                          //               // third row

                                                          //               const SizedBox(
                                                          //                 height: 10,
                                                          //               ),

                                                          //               Row(
                                                          //                 mainAxisAlignment: MainAxisAlignment.center,
                                                          //                 crossAxisAlignment: CrossAxisAlignment.center,
                                                          //                 children: [
                                                          //                   InkWell(
                                                          //                     onTap: () {
                                                          //                       Navigator.push(
                                                          //                           context,
                                                          //                           MaterialPageRoute(
                                                          //                               builder: (context) =>
                                                          //                                   const EditProfile()));
                                                          //                     },
                                                          //                     child: Container(
                                                          //                       margin:
                                                          //                           const EdgeInsets.only(
                                                          //                               right: 5),
                                                          //                       padding:
                                                          //                           const EdgeInsets.only(
                                                          //                               top: 7,
                                                          //                               bottom: 7,
                                                          //                               left: 10,
                                                          //                               right: 10),
                                                          //                       decoration: const BoxDecoration(
                                                          //                           color: Colors.black,
                                                          //                           borderRadius:
                                                          //                               BorderRadius.all(
                                                          //                                   Radius
                                                          //                                       .circular(
                                                          //                                           5))),
                                                          //                       child: Text(
                                                          //                         "EDIT PROFILE",
                                                          //                         style:  GoogleFonts
                                                          //                               .lexendExa(
                                                          //                                   fontWeight:
                                                          //                                       FontWeight
                                                          //                                           .w300,
                                                          //                                   color: Colors
                                                          //                                       .white,
                                                          //                                   fontSize:
                                                          //                                       10),
                                                          //                       ),
                                                          //                     ),
                                                          //                   ),
                                                          //                   InkWell(
                                                          //                     onTap: () {
                                                          //                       Navigator.push(
                                                          //                           context,
                                                          //                           MaterialPageRoute(
                                                          //                               builder: (context) =>
                                                          //                                   const MyRental()));
                                                          //                     },
                                                          //                     child: Container(
                                                          //                       margin:
                                                          //                           const EdgeInsets.only(
                                                          //                               left: 5),
                                                          //                       padding:
                                                          //                           const EdgeInsets.only(
                                                          //                               top: 7,
                                                          //                               bottom: 7,
                                                          //                               left: 10,
                                                          //                               right: 10),
                                                          //                       decoration: const BoxDecoration(
                                                          //                           color: MyColors
                                                          //                               .themecolor,
                                                          //                           borderRadius:
                                                          //                               BorderRadius.all(
                                                          //                                   Radius
                                                          //                                       .circular(
                                                          //                                           5))),
                                                          //                       child: Text("MY RENTALS",
                                                          //                           style: GoogleFonts
                                                          //                               .lexendExa(
                                                          //                                   fontWeight:
                                                          //                                       FontWeight
                                                          //                                           .w300,
                                                          //                                   color: Colors
                                                          //                                       .white,
                                                          //                                   fontSize:
                                                          //                                       10)),
                                                          //                     ),
                                                          //                   ),
                                                          //                 ],
                                                          //               )
                                                          //             ],
                                                          //           ),
                                                          //         ),
                                                          //       ),
                                                          //     ],
                                                          //   ),
                                                          // ),

                                                          // // top saving and month wise saving row =========================================================================

                                                          // Container(
                                                          //   margin: const EdgeInsets.only(
                                                          //       left: 10, right: 10, top: 20),
                                                          //   child: Row(
                                                          //     mainAxisAlignment:
                                                          //         MainAxisAlignment.spaceBetween,
                                                          //     crossAxisAlignment:
                                                          //         CrossAxisAlignment.center,
                                                          //     children: [
                                                          //       Wrap(
                                                          //         alignment: WrapAlignment.center,
                                                          //         crossAxisAlignment:
                                                          //             WrapCrossAlignment.start,
                                                          //         direction: Axis.vertical,
                                                          //         children: [
                                                          //           Text(
                                                          //             "Total Savings",
                                                          //             style: GoogleFonts.lexendDeca(
                                                          //                 fontSize: 13,
                                                          //                 fontWeight: FontWeight.w400,
                                                          //                 color: Colors.black),
                                                          //           ),
                                                          //           Text(
                                                          //              controller.  decordedrentingReponse.isEmpty
                                                          //                 ? ""
                                                          //                 : "AED " +
                                                          //                      controller.  decordedrentingReponse[
                                                          //                             "total_saving"]
                                                          //                         .toString(),
                                                          //             style: GoogleFonts.lexendDeca(
                                                          //                 fontSize: 10,
                                                          //                 fontWeight: FontWeight.w400,
                                                          //                 color: MyColors.themecolor),
                                                          //           )
                                                          //         ],
                                                          //       ),
                                                          //       Wrap(
                                                          //         alignment: WrapAlignment.center,
                                                          //         crossAxisAlignment:
                                                          //             WrapCrossAlignment.end,
                                                          //         direction: Axis.vertical,
                                                          //         children: [
                                                          //           Text(
                                                          //              controller.  decordedrentingReponse.isEmpty
                                                          //                 ? ""
                                                          //                 :  controller.  decordedrentingReponse[
                                                          //                             "month"]
                                                          //                         .toString() +
                                                          //                     " Savings",
                                                          //             style: GoogleFonts.lexendDeca(
                                                          //                 fontSize: 13,
                                                          //                 fontWeight: FontWeight.w400,
                                                          //                 color: Colors.black),
                                                          //           ),
                                                          //           Text(
                                                          //             controller.   decordedrentingReponse.isEmpty
                                                          //                 ? ""
                                                          //                 : "AED " +
                                                          //                      controller.  decordedrentingReponse[
                                                          //                             "month_saving"]
                                                          //                         .toString(),
                                                          //             style: GoogleFonts.lexendDeca(
                                                          //                 fontSize: 10,
                                                          //                 fontWeight: FontWeight.w400,
                                                          //                 color: MyColors.themecolor),
                                                          //           )
                                                          //         ],
                                                          //       )
                                                          //     ],
                                                          //   ),
                                                          // ),

                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 20,
                                                                    bottom: 30),
                                                            child: Row(
                                                              children: [
                                                                Flexible(
                                                                  child:
                                                                      Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    height: 100,
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            Text(
                                                                              "AED",
                                                                              style: GoogleFonts.lexendDeca(
                                                                                fontWeight: FontWeight.w300,
                                                                                color: MyColors.themecolor,
                                                                                fontSize: 25,
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            Text(
                                                                              //   controller.  decordedrentingReponse.isEmpty
                                                                              // ? ""
                                                                              // :
                                                                              //      controller.  decordedrentingReponse[
                                                                              //             "total_saving"]
                                                                              //         .toString()

                                                                              controller.decordedrentingReponse.isEmpty ? "" : MoneyFormatter(amount: double.parse(controller.decordedrentingReponse["total_saving"].toString())).output.compactNonSymbol,
                                                                              style: GoogleFonts.lexendDeca(
                                                                                fontWeight: FontWeight.w300,
                                                                                color: MyColors.themecolor,
                                                                                fontSize: 30,
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                        Container(
                                                                          margin: const EdgeInsets
                                                                              .only(
                                                                              top: 10),
                                                                          child:
                                                                              Text(
                                                                            "TOTAL SAVINGS",
                                                                            style:
                                                                                GoogleFonts.lexendExa(
                                                                              fontWeight: FontWeight.w300,
                                                                              color: const Color(0xff868E96),
                                                                              fontSize: 12,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  height: 100,
                                                                  width: 1,
                                                                  color: const Color(
                                                                      0xffE2E2E2),
                                                                ),
                                                                Flexible(
                                                                  child:
                                                                      Container(
                                                                    height: 100,
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            const SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            Text(
                                                                              controller.decordedrentingReponse.isEmpty ? "" : controller.decordedrentingReponse["saving_percentage"].toString(),
                                                                              style: GoogleFonts.lexendDeca(
                                                                                fontWeight: FontWeight.w300,
                                                                                color: MyColors.themecolor,
                                                                                fontSize: 30,
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                        Container(
                                                                          margin: const EdgeInsets
                                                                              .only(
                                                                              top: 10),
                                                                          child:
                                                                              Text(
                                                                            "SAVINGS PERCENTAGE",
                                                                            style:
                                                                                GoogleFonts.lexendExa(
                                                                              fontWeight: FontWeight.w300,
                                                                              color: const Color(0xff868E96),
                                                                              fontSize: 12,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),

                                                          // graph bar and values ========================================================================================

                                                          Container(
                                                            color: const Color(
                                                                0xffFFFCEB),
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child:
                                                                DropdownButtonHideUnderline(
                                                              child:
                                                                  DropdownButton2<
                                                                      String>(
                                                                isExpanded:
                                                                    true,
                                                                hint: Text(
                                                                  '2024',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .hintColor,
                                                                  ),
                                                                ),
                                                                items:
                                                                    yearsrenting
                                                                        .map((String
                                                                                item) =>
                                                                            DropdownMenuItem<String>(
                                                                              value: item,
                                                                              child: Text(
                                                                                item,
                                                                                style: const TextStyle(
                                                                                  fontSize: 14,
                                                                                ),
                                                                              ),
                                                                            ))
                                                                        .toList(),
                                                                value:
                                                                    selectedyearRender,
                                                                onChanged:
                                                                    (String?
                                                                        value) {
                                                                  setState(() {
                                                                    selectedyearRender =
                                                                        value;
                                                                    controller.getaccontDetails(
                                                                        context,
                                                                        selectedyearRender
                                                                            .toString());
                                                                  });
                                                                },
                                                                buttonStyleData:
                                                                    const ButtonStyleData(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              16),
                                                                  height: 40,
                                                                  width: 100,
                                                                ),
                                                                menuItemStyleData:
                                                                    const MenuItemStyleData(
                                                                  height: 40,
                                                                ),
                                                              ),
                                                            ),
                                                          ),

                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              AnimatedContainer(
                                                                duration:
                                                                    const Duration(
                                                                        milliseconds:
                                                                            500),
                                                                color: const Color(
                                                                    0xffFFFCEB),
                                                                margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            15),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            30,
                                                                        bottom:
                                                                            10),
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                height: controller
                                                                        .rentingGraph
                                                                        .isEmpty
                                                                    ? 100
                                                                    : 250,
                                                                child:
                                                                    DefaultTextStyle(
                                                                  style: GoogleFonts.lexendDeca(
                                                                      fontSize:
                                                                          8,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300),
                                                                  child: DChartBarO(
                                                                      configRenderBar: ConfigRenderBar(
                                                                        radius:
                                                                            0,
                                                                      ),
                                                                      animate: false,
                                                                      fillColor: (group, ordinalData, index) {
                                                                        return Colors
                                                                            .black;
                                                                      },
                                                                      groupList: [
                                                                        OrdinalGroup(
                                                                          id: '1',
                                                                          data: controller
                                                                              .rentingGraph
                                                                              .map(
                                                                                (e) => OrdinalData(domain: e["month"].toString(), measure: e["price"]),
                                                                              )
                                                                              .toList(),
                                                                        ),
                                                                      ]),
                                                                ),
                                                              ),
                                                              // Expanded(
                                                              //   child: Column(
                                                              //     children: [
                                                              //       Row(
                                                              //         mainAxisAlignment:
                                                              //             MainAxisAlignment.start,
                                                              //         crossAxisAlignment:
                                                              //             CrossAxisAlignment.center,
                                                              //         children: [
                                                              //           Container(
                                                              //             width: 20,
                                                              //             alignment: Alignment.center,
                                                              //             child: Text(
                                                              //               "5",
                                                              //               style: GoogleFonts.lexendDeca(
                                                              //                   fontWeight:
                                                              //                       FontWeight.w400,
                                                              //                   fontSize: 13,
                                                              //                   color:
                                                              //                       MyColors.themecolor),
                                                              //             ),
                                                              //           ),
                                                              //           const SizedBox(
                                                              //             width: 5,
                                                              //           ),
                                                              //           Expanded(
                                                              //             child: Text(
                                                              //               "Rentals completing\ntoday",
                                                              //               maxLines: 2,
                                                              //               overflow:
                                                              //                   TextOverflow.ellipsis,
                                                              //               textAlign: TextAlign.start,
                                                              //               style: GoogleFonts.lexendDeca(
                                                              //                   fontWeight:
                                                              //                       FontWeight.w400,
                                                              //                   fontSize: 11,
                                                              //                   color: Colors.black),
                                                              //             ),
                                                              //           )
                                                              //         ],
                                                              //       ),
                                                              //       const SizedBox(height: 10),
                                                              //       Row(
                                                              //         mainAxisAlignment:
                                                              //             MainAxisAlignment.start,
                                                              //         crossAxisAlignment:
                                                              //             CrossAxisAlignment.center,
                                                              //         children: [
                                                              //           Container(
                                                              //             width: 20,
                                                              //             alignment: Alignment.center,
                                                              //             child: Text(
                                                              //               "3",
                                                              //               style: GoogleFonts.lexendDeca(
                                                              //                   fontWeight:
                                                              //                       FontWeight.w400,
                                                              //                   fontSize: 13,
                                                              //                   color:
                                                              //                       MyColors.themecolor),
                                                              //             ),
                                                              //           ),
                                                              //           const SizedBox(
                                                              //             width: 5,
                                                              //           ),
                                                              //           Expanded(
                                                              //             child: Text(
                                                              //               "Current Active\nRentals",
                                                              //               maxLines: 2,
                                                              //               overflow:
                                                              //                   TextOverflow.ellipsis,
                                                              //               textAlign: TextAlign.start,
                                                              //               style: GoogleFonts.lexendDeca(
                                                              //                   fontWeight:
                                                              //                       FontWeight.w400,
                                                              //                   fontSize: 11,
                                                              //                   color: Colors.black),
                                                              //             ),
                                                              //           )
                                                              //         ],
                                                              //       ),
                                                              //       const SizedBox(height: 10),
                                                              //       Row(
                                                              //         mainAxisAlignment:
                                                              //             MainAxisAlignment.start,
                                                              //         crossAxisAlignment:
                                                              //             CrossAxisAlignment.center,
                                                              //         children: [
                                                              //           Container(
                                                              //             width: 20,
                                                              //             alignment: Alignment.center,
                                                              //             child: Text(
                                                              //               "6",
                                                              //               style: GoogleFonts.lexendDeca(
                                                              //                   fontWeight:
                                                              //                       FontWeight.w400,
                                                              //                   fontSize: 13,
                                                              //                   color:
                                                              //                       MyColors.themecolor),
                                                              //             ),
                                                              //           ),
                                                              //           const SizedBox(
                                                              //             width: 5,
                                                              //           ),
                                                              //           Expanded(
                                                              //             child: Text(
                                                              //               "Rentals requested",
                                                              //               maxLines: 2,
                                                              //               overflow:
                                                              //                   TextOverflow.ellipsis,
                                                              //               textAlign: TextAlign.start,
                                                              //               style: GoogleFonts.lexendDeca(
                                                              //                   fontWeight:
                                                              //                       FontWeight.w400,
                                                              //                   fontSize: 11,
                                                              //                   color: Colors.black),
                                                              //             ),
                                                              //           )
                                                              //         ],
                                                              //       ),
                                                              //       const SizedBox(height: 10),
                                                              //       Row(
                                                              //         mainAxisAlignment:
                                                              //             MainAxisAlignment.start,
                                                              //         crossAxisAlignment:
                                                              //             CrossAxisAlignment.center,
                                                              //         children: [
                                                              //           Container(
                                                              //             width: 20,
                                                              //             alignment: Alignment.center,
                                                              //             child: Text(
                                                              //               "20",
                                                              //               style: GoogleFonts.lexendDeca(
                                                              //                   fontWeight:
                                                              //                       FontWeight.w400,
                                                              //                   fontSize: 13,
                                                              //                   color:
                                                              //                       MyColors.themecolor),
                                                              //             ),
                                                              //           ),
                                                              //           const SizedBox(
                                                              //             width: 5,
                                                              //           ),
                                                              //           Expanded(
                                                              //             child: Text(
                                                              //               "Rentals completed\nthis month",
                                                              //               maxLines: 2,
                                                              //               overflow:
                                                              //                   TextOverflow.ellipsis,
                                                              //               textAlign: TextAlign.start,
                                                              //               style: GoogleFonts.lexendDeca(
                                                              //                   fontWeight:
                                                              //                       FontWeight.w400,
                                                              //                   fontSize: 11,
                                                              //                   color: Colors.black),
                                                              //             ),
                                                              //           )
                                                              //         ],
                                                              //       ),
                                                              //     ],
                                                              //   ),
                                                              // )
                                                            ],
                                                          ),

                                                          // const SizedBox(height: 15),

                                                          // // highlights values =========================================================================================

                                                          // Container(
                                                          //   width: MediaQuery.of(context).size.width,
                                                          //   padding: const EdgeInsets.only(
                                                          //       top: 15, bottom: 15, left: 25, right: 25),
                                                          //   decoration: const BoxDecoration(
                                                          //       color: Color(0xffF6F5F1)),
                                                          //   child: Column(
                                                          //     mainAxisAlignment: MainAxisAlignment.start,
                                                          //     crossAxisAlignment:
                                                          //         CrossAxisAlignment.start,
                                                          //     children: [
                                                          //       Text(
                                                          //         "Insights",
                                                          //         style: GoogleFonts.lexendDeca(
                                                          //             fontWeight: FontWeight.w400,
                                                          //             fontSize: 15,
                                                          //             color: Colors.black),
                                                          //       ),
                                                          //       const SizedBox(height: 15),

                                                          //       // row 1
                                                          //       Row(
                                                          //         mainAxisAlignment:
                                                          //             MainAxisAlignment.spaceBetween,
                                                          //         crossAxisAlignment:
                                                          //             CrossAxisAlignment.center,
                                                          //         children: [
                                                          //           Flexible(
                                                          //             flex: 1,
                                                          //             child: Container(
                                                          //               alignment: Alignment.centerLeft,
                                                          //               width: MediaQuery.of(context)
                                                          //                   .size
                                                          //                   .width,
                                                          //               child: Column(
                                                          //                 mainAxisAlignment:
                                                          //                     MainAxisAlignment.center,
                                                          //                 crossAxisAlignment:
                                                          //                     CrossAxisAlignment.center,
                                                          //                 children: [
                                                          //                   Wrap(
                                                          //                     crossAxisAlignment:
                                                          //                         WrapCrossAlignment
                                                          //                             .center,
                                                          //                     alignment:
                                                          //                         WrapAlignment.center,
                                                          //                     direction: Axis.vertical,
                                                          //                     children: [
                                                          //                       Text(
                                                          //                         "VALUE OF RENTALS",
                                                          //                         style: GoogleFonts
                                                          //                             .lexendDeca(
                                                          //                                 fontWeight:
                                                          //                                     FontWeight
                                                          //                                         .w300,
                                                          //                                 fontSize: 12,
                                                          //                                 color: Colors
                                                          //                                     .black),
                                                          //                       ),
                                                          //                       Text(
                                                          //                          controller.  decordedrentingReponse
                                                          //                                 .isEmpty
                                                          //                             ? ""
                                                          //                             : "AED " +
                                                          //                                   controller. decordedrentingReponse[
                                                          //                                         "total_retail_amount"]
                                                          //                                     .toString(),
                                                          //                         style: GoogleFonts
                                                          //                             .lexendDeca(
                                                          //                                 fontWeight:
                                                          //                                     FontWeight
                                                          //                                         .w400,
                                                          //                                 fontSize: 11,
                                                          //                                 color: MyColors
                                                          //                                     .themecolor),
                                                          //                       ),
                                                          //                     ],
                                                          //                   ),
                                                          //                   const SizedBox(height: 10),
                                                          //                   Wrap(
                                                          //                     crossAxisAlignment:
                                                          //                         WrapCrossAlignment
                                                          //                             .center,
                                                          //                     alignment:
                                                          //                         WrapAlignment.center,
                                                          //                     direction: Axis.vertical,
                                                          //                     children: [
                                                          //                       Text(
                                                          //                         "SAVING PERCENTAGE",
                                                          //                         style: GoogleFonts
                                                          //                             .lexendDeca(
                                                          //                                 fontWeight:
                                                          //                                     FontWeight
                                                          //                                         .w300,
                                                          //                                 fontSize: 12,
                                                          //                                 color: Colors
                                                          //                                     .black),
                                                          //                       ),
                                                          //                       Text(
                                                          //                          controller.  decordedrentingReponse
                                                          //                                 .isEmpty
                                                          //                             ? ""
                                                          //                             :  controller.  decordedrentingReponse[
                                                          //                                     "saving_percentage"]
                                                          //                                 .toString(),
                                                          //                         style: GoogleFonts
                                                          //                             .lexendDeca(
                                                          //                                 fontWeight:
                                                          //                                     FontWeight
                                                          //                                         .w400,
                                                          //                                 fontSize: 11,
                                                          //                                 color: MyColors
                                                          //                                     .themecolor),
                                                          //                       ),
                                                          //                     ],
                                                          //                   ),
                                                          //                 ],
                                                          //               ),
                                                          //             ),
                                                          //           ),
                                                          //           Flexible(
                                                          //             flex: 1,
                                                          //             child: Container(
                                                          //               alignment: Alignment.centerRight,
                                                          //               width: MediaQuery.of(context)
                                                          //                   .size
                                                          //                   .width,
                                                          //               child: Column(
                                                          //                 mainAxisAlignment:
                                                          //                     MainAxisAlignment.center,
                                                          //                 crossAxisAlignment:
                                                          //                     CrossAxisAlignment.center,
                                                          //                 children: [
                                                          //                   Wrap(
                                                          //                     crossAxisAlignment:
                                                          //                         WrapCrossAlignment
                                                          //                             .center,
                                                          //                     alignment:
                                                          //                         WrapAlignment.center,
                                                          //                     direction: Axis.vertical,
                                                          //                     children: [
                                                          //                       Text(
                                                          //                         "SAVED TREES",
                                                          //                         style: GoogleFonts
                                                          //                             .lexendDeca(
                                                          //                                 fontWeight:
                                                          //                                     FontWeight
                                                          //                                         .w300,
                                                          //                                 fontSize: 12,
                                                          //                                 color: Colors
                                                          //                                     .black),
                                                          //                       ),
                                                          //                       Text(
                                                          //                         controller.   decordedrentingReponse
                                                          //                                 .isEmpty
                                                          //                             ? ""
                                                          //                             :  controller.  decordedrentingReponse[
                                                          //                                     "tree_saved"]
                                                          //                                 .toString(),
                                                          //                         style: GoogleFonts
                                                          //                             .lexendDeca(
                                                          //                                 fontWeight:
                                                          //                                     FontWeight
                                                          //                                         .w400,
                                                          //                                 fontSize: 11,
                                                          //                                 color: MyColors
                                                          //                                     .themecolor),
                                                          //                       ),
                                                          //                     ],
                                                          //                   ),
                                                          //                   const SizedBox(height: 10),
                                                          //                   Wrap(
                                                          //                     crossAxisAlignment:
                                                          //                         WrapCrossAlignment
                                                          //                             .center,
                                                          //                     alignment:
                                                          //                         WrapAlignment.center,
                                                          //                     direction: Axis.vertical,
                                                          //                     children: [
                                                          //                       Text(
                                                          //                         "SAVED CO2 FOOTPRINTS",
                                                          //                         style: GoogleFonts
                                                          //                             .lexendDeca(
                                                          //                                 fontWeight:
                                                          //                                     FontWeight
                                                          //                                         .w300,
                                                          //                                 fontSize: 12,
                                                          //                                 color: Colors
                                                          //                                     .black),
                                                          //                       ),
                                                          //                       Text(
                                                          //                          controller.  decordedrentingReponse
                                                          //                                 .isEmpty
                                                          //                             ? ""
                                                          //                             :   controller. decordedrentingReponse[
                                                          //                                         "tree_saved"]
                                                          //                                     .toString() +
                                                          //                                 "%",
                                                          //                         style: GoogleFonts
                                                          //                             .lexendDeca(
                                                          //                                 fontWeight:
                                                          //                                     FontWeight
                                                          //                                         .w400,
                                                          //                                 fontSize: 11,
                                                          //                                 color: MyColors
                                                          //                                     .themecolor),
                                                          //                       ),
                                                          //                     ],
                                                          //                   ),
                                                          //                 ],
                                                          //               ),
                                                          //             ),
                                                          //           ),
                                                          //         ],
                                                          //       ),
                                                          //     ],
                                                          //   ),
                                                          // ),

                                                          // My rental list view ===================================================================================

                                                          const SizedBox(
                                                              height: 30),

                                                          Text(
                                                            "MY ORDERS",
                                                            style: GoogleFonts
                                                                .lexendExa(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .black),
                                                          ),

                                                          const SizedBox(
                                                              height: 15),
                                                          Container(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            height: 1,
                                                            color: Colors.black,
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 15,
                                                                    right: 15),
                                                          ),

                                                          Stack(
                                                            children: [
                                                              Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            20,
                                                                        right:
                                                                            20,
                                                                        bottom:
                                                                            20),
                                                                child:
                                                                    DynamicHeightGridView(
                                                                  physics:
                                                                      const NeverScrollableScrollPhysics(),
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemCount:
                                                                      decordedMyrentalReponse
                                                                          .length,
                                                                  crossAxisCount:
                                                                      2,
                                                                  crossAxisSpacing:
                                                                      15,
                                                                  builder:
                                                                      (context,
                                                                          index) {
                                                                    return InkWell(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(builder: (context) => RentDetails(productId: decordedMyrentalReponse[index]["id"].toString())));
                                                                      },
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          const SizedBox(
                                                                            height:
                                                                                20,
                                                                          ),
                                                                          Stack(
                                                                            children: [
                                                                              CachedNetworkImage(
                                                                                imageUrl: decordedMyrentalReponse[index]["img_url"].toString(),
                                                                                width: MediaQuery.of(context).size.width,
                                                                                height: 220,
                                                                                fit: BoxFit.cover,
                                                                              ),
                                                                              Visibility(
                                                                                visible: decordedMyrentalReponse[index]["type"] == 1 ? false : true,
                                                                                child: Positioned(
                                                                                  bottom: 0,
                                                                                  left: 0,
                                                                                  child: Container(
                                                                                    margin: const EdgeInsets.all(5),
                                                                                    padding: const EdgeInsets.only(left: 3, right: 3),
                                                                                    decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(50))),
                                                                                    child: Text(
                                                                                      "MANAGED",
                                                                                      style: GoogleFonts.lexendExa(fontSize: 10, fontWeight: FontWeight.w400, color: MyColors.themecolor),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          Column(
                                                                            children: [
                                                                              const SizedBox(height: 5),
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                  Expanded(
                                                                                    child: Container(
                                                                                      alignment: Alignment.centerLeft,
                                                                                      margin: const EdgeInsets.only(),
                                                                                      child: Text(
                                                                                        decordedMyrentalReponse[index]["brand_name"].toString(),
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
                                                                                  ),
                                                                                  decordedMyrentalReponse[index]["category_id"].toString() == "1"
                                                                                      ? Container(
                                                                                          height: 15,
                                                                                          padding: const EdgeInsets.only(left: 5, right: 5),
                                                                                          alignment: Alignment.center,
                                                                                          constraints: const BoxConstraints(minWidth: 20),
                                                                                          decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(50)), border: Border.all(color: Colors.black, width: 1)),
                                                                                          child: Text(
                                                                                            decordedMyrentalReponse[index]["size_name"].toString(),
                                                                                            style: GoogleFonts.lexendDeca(fontSize: 8, fontWeight: FontWeight.w400, color: Colors.black),
                                                                                          ),
                                                                                        )
                                                                                      : Container(
                                                                                          padding: const EdgeInsets.all(5),
                                                                                          margin: const EdgeInsets.only(top: 5),
                                                                                          height: 20,
                                                                                          width: 10,
                                                                                        )
                                                                                ],
                                                                              ),
                                                                              const SizedBox(height: 3),
                                                                              Container(
                                                                                alignment: Alignment.centerLeft,
                                                                                margin: const EdgeInsets.only(bottom: 3),
                                                                                child: Text(
                                                                                  decordedMyrentalReponse[index]["title"].toString(),
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  maxLines: 1,
                                                                                  textAlign: TextAlign.left,
                                                                                  style: GoogleFonts.lexendDeca(
                                                                                    fontWeight: FontWeight.w300,
                                                                                    color: const Color.fromARGB(255, 97, 97, 97),
                                                                                    fontSize: 12,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                alignment: Alignment.centerLeft,
                                                                                margin: const EdgeInsets.only(top: 3, bottom: 3),
                                                                                child: Text(
                                                                                  "RENT AED " + decordedMyrentalReponse[index]["total_amount"].toString() + " | " + decordedMyrentalReponse[index]["days"].toString() + " DAYS",
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  maxLines: 1,
                                                                                  textAlign: TextAlign.left,
                                                                                  style: GoogleFonts.lexendExa(
                                                                                    fontWeight: FontWeight.w300,
                                                                                    color: MyColors.themecolor,
                                                                                    fontSize: 12,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                alignment: Alignment.centerLeft,
                                                                                margin: const EdgeInsets.only(top: 3, bottom: 3),
                                                                                child: Text(
                                                                                  "Retail AED " + decordedMyrentalReponse[index]["retail_price"].toString(),
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  maxLines: 1,
                                                                                  textAlign: TextAlign.left,
                                                                                  style: GoogleFonts.lexendDeca(
                                                                                    decoration: TextDecoration.lineThrough,
                                                                                    color: Colors.grey,
                                                                                    fontWeight: FontWeight.w300,
                                                                                    fontSize: 12,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          )
                                                                        ],
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                              Visibility(
                                                                visible:
                                                                    showLazyIndicatorMRT,
                                                                child:
                                                                    Positioned(
                                                                  bottom: 0,
                                                                  child: Container(
                                                                      width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          right:
                                                                              20),
                                                                      margin: const EdgeInsets
                                                                          .only(
                                                                          bottom:
                                                                              10),
                                                                      child:
                                                                          const CircularProgressIndicator()),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ]),
                                            ),
                                          ],
                                        ),
            ),
          );
        });
  }

  renterReviewDialog(String id, String renterUsername, String renterProfile) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return Center(
                child: Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    height: 400,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Scaffold(
                      resizeToAvoidBottomInset: false,
                      backgroundColor: Colors.transparent,
                      body: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(bottom: 10),
                            child: SizedBox(
                              width: 55,
                              height: 55,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: CachedNetworkImage(
                                    imageUrl: renterProfile,
                                    width: 55,
                                    height: 55,
                                    fit: BoxFit.cover,
                                  )),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            alignment: Alignment.center,
                            child: Text(
                              renterUsername,
                              style: GoogleFonts.lexendDeca(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 20),
                                child: Text("Rating",
                                    style: GoogleFonts.lexendDeca(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w300)),
                              ),
                              RatingBar.builder(
                                itemSize: 30,
                                initialRating: 0,
                                glow: false,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemPadding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Color(0xffCAAB05),
                                ),
                                onRatingUpdate: (rating) {
                                  setState(() {
                                    renterRating = rating;
                                  });
                                },
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            margin: const EdgeInsets.only(top: 20),
                            width: MediaQuery.of(context).size.width,
                            height: 100,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey)),
                            child: TextFormField(
                              maxLines: 10,
                              controller: renterReviewController,
                              style: GoogleFonts.lexendDeca(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText:
                                      "Leave your feedback about this Renter",
                                  hintStyle: GoogleFonts.lexendDeca(
                                      fontSize: 16,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w300)),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              sendRenterReview(id, renterRating,
                                  renterReviewController.text);
                            },
                            child: Container(
                                margin: const EdgeInsets.only(top: 20),
                                width: MediaQuery.of(context).size.width,
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text("SUBMIT REVIEW",
                                    style: GoogleFonts.lexendExa(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300))),
                          )
                        ],
                      ),
                    )),
              );
            },
          );
        });
  }

// renter review =====================================================================================

  Map<String, dynamic> renterReviewResponse = {};

  sendRenterReview(String id, double rating, String comment) async {
    showMyDialog();

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      final response =
          await http.post(Uri.parse(SizValue.addrenterReview), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey).toString(),
        'id': id,
        'rating': rating.toString(),
        'comment': comment,
      });

      renterReviewResponse = jsonDecode(response.body);

      if (renterReviewResponse["success"] == true) {
        Navigator.pop(context);

        renterReviewController.text = "";

        Flushbar(
          flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.black,
          messageText: Text("Review Submit Successfully",
              style: GoogleFonts.lexendDeca(
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                  color: Colors.white)),
          duration: const Duration(seconds: 3),
        ).show(context);
      } else if (renterReviewResponse["success"] == false) {
        renterReviewController.text = "";

        Navigator.pop(context);

        Flushbar(
          flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.black,
          messageText: Text(renterReviewResponse["error"].toString(),
              style: GoogleFonts.lexendDeca(
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                  color: Colors.white)),
          duration: const Duration(seconds: 3),
        ).show(context);
      }
    } on ClientException {
      Navigator.pop(context);

      Flushbar(
        flushbarStyle: FlushbarStyle.GROUNDED,
        backgroundColor: Colors.black,
        messageText: Text(
            "Server not responding please try again after sometime",
            style: GoogleFonts.lexendDeca(
                fontSize: 13,
                fontWeight: FontWeight.w300,
                color: Colors.white)),
        duration: const Duration(seconds: 3),
      ).show(context);
    } on SocketException {
      Navigator.pop(context);

      Flushbar(
        flushbarStyle: FlushbarStyle.GROUNDED,
        backgroundColor: Colors.black,
        messageText: Text(
            "No Internet connection 😑 please try again after sometime",
            style: GoogleFonts.lexendDeca(
                fontSize: 13,
                fontWeight: FontWeight.w300,
                color: Colors.white)),
        duration: const Duration(seconds: 3),
      ).show(context);
    } on HttpException {
      Navigator.pop(context);

      Flushbar(
        flushbarStyle: FlushbarStyle.GROUNDED,
        backgroundColor: Colors.black,
        messageText: Text("Something went wrong please try after sometime",
            style: GoogleFonts.lexendDeca(
                fontSize: 13,
                fontWeight: FontWeight.w300,
                color: Colors.white)),
        duration: const Duration(seconds: 3),
      ).show(context);
    } on FormatException {
      Navigator.pop(context);

      Flushbar(
        flushbarStyle: FlushbarStyle.GROUNDED,
        backgroundColor: Colors.black,
        messageText: Text("Something went wrong please try after sometime",
            style: GoogleFonts.lexendDeca(
                fontSize: 13,
                fontWeight: FontWeight.w300,
                color: Colors.white)),
        duration: const Duration(seconds: 3),
      ).show(context);
    }
  }

  showMyDialog() {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(
              color: MyColors.themecolor,
            ),
          );
        });
  }
}
