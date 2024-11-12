// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siz/Controllers/BottomNavController.dart';
import 'package:siz/Controllers/FilterController.dart';
import 'package:siz/LoginSignUp/AccuntCreate.dart';
import 'package:siz/LoginSignUp/BasicLoginInfo.dart';
import 'package:siz/LoginSignUp/LoginPage.dart';
import 'package:siz/Pages/Cart.dart';
import 'package:siz/Pages/ChatInside.dart';
import 'package:siz/Pages/Home.dart';
import 'package:siz/Pages/ProductView.dart';
import 'package:siz/Pages/Wishlist.dart';
import 'package:siz/Utils/Colors.dart';
import 'dart:convert';
import 'dart:io';
import 'package:siz/Utils/Value.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ProfileView extends StatefulWidget {
  String lenderId = "";
  ProfileView({super.key, required this.lenderId});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with TickerProviderStateMixin {



  FilterController controller=Get.put(FilterController());

 


  bool isLoadingMoreR = false;
  bool oncesCallR = false;
  bool noMoreDataR = false;
  bool showLazyIndicatorR = false;

 

  // add wishlist ==============================================================================================

  Map<String, dynamic> wishlistaddReponse = {};

  addWishlist(
    BuildContext context,
    String productId,
    int index,
  ) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    dialodShow(context);
    try {
      final response = await http.post(Uri.parse(SizValue.addWishlist), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey),
        'product': productId,
      });

      wishlistaddReponse = jsonDecode(response.body);

      if (wishlistaddReponse["success"] == true) {
        setState(() {
         controller. lenderListDecorded[index]["wishlist"] = 1;
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Item added in your wishlist",
              style: GoogleFonts.lexendDeca(
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                  color: Colors.white)),
          duration: const Duration(seconds: 1),
        ));

        Navigator.pop(context);
      } else if (wishlistaddReponse["success"] == false) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(wishlistaddReponse["error"].toString(),
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


  
   decordedResponse(String response) {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    return stringToBase64.decode(response);
  }


  // remove wishlist ==============================================================================================

  Map<String, dynamic> wishlistremoveReponse = {};

  removeWishlist(String productId, int index) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    dialodShow(context);

    try {
      final response =
          await http.post(Uri.parse(SizValue.removeWishlist), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey),
        'product': productId,
      });

      wishlistremoveReponse = jsonDecode(response.body);

      if (wishlistremoveReponse["success"] == true) {
        Navigator.pop(context);

        setState(() {
         controller. lenderListDecorded[index]["wishlist"] = 0;
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Item removed from wishlist",
              style: GoogleFonts.lexendDeca(
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                  color: Colors.white)),
          duration: const Duration(seconds: 1),
        ));
      } else if (wishlistremoveReponse["success"] == false) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(wishlistremoveReponse["error"].toString(),
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

  // followlender =====================================================================================

  Map<String, dynamic> followResponse = {};

  followLender() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      final response = await http.post(Uri.parse(SizValue.followLender), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey),
        'id': widget.lenderId
      });

      followResponse = jsonDecode(response.body);

      if (followResponse["success"] == true) {

        setState(() {
         controller. lenderReponse["follower"] =
              (int.parse(controller. lenderReponse["follower"].toString()) + 1).toString();
         controller. follow = true;
        });

      } else if (followResponse["success"] == false) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(followResponse["error"].toString(),
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

  // unfollowlender =====================================================================================

  Map<String, dynamic> unfollowResponse = {};

  unfollowLender() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      final response = await http.post(Uri.parse(SizValue.unfollowLender),
          body: {
            'user_key': sharedPreferences.getString(SizValue.userKey),
            'id': widget.lenderId
          });

      unfollowResponse = jsonDecode(response.body);

      if (unfollowResponse["success"] == true) {
        setState(() {
        controller.  lenderReponse["follower"] =
              (int.parse(controller. lenderReponse["follower"].toString()) - 1).toString();
         controller. follow = false;
        });
      } else if (unfollowResponse["success"] == false) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(unfollowResponse["error"].toString(),
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

  // lenderReview =====================================================================================

  Map<String, dynamic> lenderReviewResponse = {};
  List<dynamic> lenderdecordedListReview = [];

  bool tabbedReviews = false;

  getlenderReview(int pageno) async {
    if (pageno <= 1) {
      dialodShow(context);
    } else {
      setState(() {
        showLazyIndicatorR = true;
      });
    }

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      final response = await http.post(Uri.parse(SizValue.lenderReview), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey).toString(),
        'id': widget.lenderId,
        'page': pageno.toString()
      });

      lenderReviewResponse = jsonDecode(response.body);

      if (lenderReviewResponse["success"] == true) {
        setState(() {
          if (pageno <= 1) {
            setState(() {
              lenderdecordedListReview = lenderReviewResponse["list"];

              print("review  =======  $lenderdecordedListReview");

              isLoadingMoreR = false;
              oncesCallR = false;
            });
          } else {
            setState(() {
              lenderdecordedListReview.addAll(lenderReviewResponse["list"]);
              isLoadingMoreR = false;
              oncesCallR = false;
            });
          }

          if (lenderReviewResponse["list"].toString() == "[]") {
            setState(() {
              noMoreDataR = true;
              isLoadingMoreR = false;
              oncesCallR = false;
            });
          }

          if (pageno <= 1) {
            Navigator.pop(context);
          } else {
            setState(() {
              showLazyIndicatorR = false;
            });
          }
        });
      } else if (lenderReviewResponse["success"] == false) {
        if (pageno <= 1) {
          Navigator.pop(context);
        } else {
          setState(() {
            showLazyIndicatorR = false;
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(lenderReviewResponse["error"].toString(),
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
          showLazyIndicatorR = false;
        });
      }

      mysnackbar(
          "Server not responding please try again after sometimev fg", context);
    } on SocketException {
      if (pageno <= 1) {
        Navigator.pop(context);
      } else {
        setState(() {
          showLazyIndicatorR = false;
        });
      }

      mysnackbar(
          "No Internet connection 😑 please try again after sometime", context);
    } on HttpException {
      if (pageno <= 1) {
        Navigator.pop(context);
      } else {
        setState(() {
          showLazyIndicatorR = false;
        });
      }

      mysnackbar("Something went wrong please try after sometime", context);
    } on FormatException {
      if (pageno <= 1) {
        Navigator.pop(context);
      } else {
        setState(() {
          showLazyIndicatorR = false;
        });
      }

      mysnackbar("Something went wrong please try after sometime", context);
    }
  }


  // block users==============================================================================================

  


  Map<String, dynamic> blockuserReponse = {};

  blockUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    dialodShow(context);

    try {
      final response =
          await http.post(Uri.parse(SizValue.blockUser), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey).toString(),
        'id': widget.lenderId,
      });

      blockuserReponse = jsonDecode(response.body);

      

      if (blockuserReponse["success"] == true) {

        
        


      setState(() {


            Future.delayed(const Duration(milliseconds: 1), () {
            controller. dialogBlockedProfile(context,widget.lenderId);
    
    
    });

          
           
        
      });
       
     


         Navigator.pop(context);
      
       

       
      } else if (blockuserReponse["success"] == false) {

           Navigator.pop(context);
      
       
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





  // report and scam  =====================================================

   Map<String, dynamic> reportScamReponse = {};

  reportScam(String message) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    dialodShow(context);

    try {
      final response =
          await http.post(Uri.parse(SizValue.lenderReport), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey).toString(),
        'id': widget.lenderId,
        'comment':message
      });

      reportScamReponse = jsonDecode(response.body);

   

      

      if (reportScamReponse["success"] == true) {

            Future.delayed(const Duration(milliseconds: 1), () {
            reportTextdialog();

      });

       Navigator.pop(context);

  

       
      } else if (reportScamReponse["success"] == false) {
         Navigator.pop(context);
      
       
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

  ScrollController scrollController = ScrollController();

  late TabController tabController;


    firebaseEventCalled()
  {
    
     try {
      FacebookAppEvents facebookAppEvents = FacebookAppEvents();

      facebookAppEvents.logEvent(
        name: "ProfileViewAndroid",
      );
    } catch (e) {}
  }

  

  @override
  void initState() {
    firebaseEventCalled();
   controller. getlenderProfile(context,widget.lenderId,  pagenoC);
    tabController = TabController(length: 2, vsync: this, initialIndex: 0);

    _scrollControllerC.addListener(() async {
      scrollListenerC();
    });
    _scrollControllerR.addListener(() async {
      scrollListenerR();
    });

    super.initState();
  }

// lender closets
  final ScrollController _scrollControllerC = ScrollController();
  int pagenoC = 1;

  Future<void> scrollListenerC() async {
    if (controller. isLoadingMoreCP) return;

    _scrollControllerC.addListener(() {
      if (_scrollControllerC.offset >=
          _scrollControllerC.position.maxScrollExtent) {
        setState(() {
         controller. isLoadingMoreCP = true;
        });

        if (! controller. oncesCallCP) {
        controller.  getlenderProfile(context,widget.lenderId,  ++pagenoC);

          setState(() {
           controller. oncesCallCP = true;
          });
        }
      }
    });
  }

// review
  final ScrollController _scrollControllerR = ScrollController();
  int pagenoR = 1;

  Future<void> scrollListenerR() async {
    if (isLoadingMoreR) return;

    _scrollControllerR.addListener(() {
      if (_scrollControllerR.offset >=
          _scrollControllerR.position.maxScrollExtent) {
        setState(() {
          isLoadingMoreR = true;
        });

         if (!oncesCallR) {
          getlenderReview(++pagenoR);

          setState(() {
            oncesCallR = true;
          });
        }
      }
    });
  }

  @override
   Widget build(BuildContext context) {
    return GetBuilder(
      init: FilterController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
              controller. lenderListDecorded.clear();
              controller. lenderReponse.clear();
             Navigator.pop(context,"showdialog");
            return false;
          },
          child: Scaffold(

             appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              toolbarHeight: 0,
            ),
        
            
            backgroundColor: Colors.white,
            body: Column(
              children: [
                // top four icons ==============================================================================================
        
                Container(
                  alignment: Alignment.center,
                  height: 60,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: const BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(255, 216, 216, 216),
                        blurRadius: 1,
                        offset: Offset(0, 2))
                  ]),
                  padding:
                      const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap: () {

                             controller. lenderListDecorded.clear();
                              controller. lenderReponse.clear();
                            
                            Navigator.pop(context,"showdialog");
                          },
                          child: SvgPicture.asset(
                            "assets/images/backarrow.svg",
                            width: 20,
                            height: 20,
                          )),
                      Container(
                          margin: const EdgeInsets.only(left: 30),
                          child: Image.asset(
                            "assets/images/appiconpng.png",
                            width: 40,
                            height: 40,
                          )),
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
                                }        else if(sharedPreferences.getString(SizValue.isLogged).toString()=="1")
                             {

                                Navigator.push(context, MaterialPageRoute(builder: (context)=>BasicLoginInfo(fromWhere: sharedPreferences.getString(SizValue.source).toString())));

                             }
                            //  else if(sharedPreferences.getString(SizValue.isLogged).toString()=="2")
                            //  {

                            //     Navigator.push(context, MaterialPageRoute(builder: (context)=>AccountCreate()));

                            // }
                            // else if (sharedPreferences
                            //             .getString(SizValue.underReview)
                            //             .toString() ==
                            //         "0") {
                            //       showReviewdialog(
                            //           sharedPreferences
                            //               .getString(SizValue.underReviewMsg)
                            //               .toString(),
                            //           sharedPreferences
                            //               .getString(SizValue.underReview)
                            //               .toString());
                            //     }
                                
                                 else if (sharedPreferences
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
                                  gotoWishlist();
                                }
                              },
                              child: SvgPicture.asset(
                                "assets/images/heart.svg",
                                width: 20,
                                height: 20,
                              )),
                          const SizedBox(width: 20),
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
                                          builder: (context) => AccountCreate()));
                                } 
                                
                                
                                
                                  else if(sharedPreferences.getString(SizValue.isLogged).toString()=="2")
                             {

                                Navigator.push(context, MaterialPageRoute(builder: (context)=>AccountCreate()));

                            }
                                
                                else if (sharedPreferences
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
                        ],
                      )
                    ],
                  ),
                ),
        
                // profile info ========================================================================================
        
                Container(
                  decoration: const BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(255, 230, 230, 230),
                        blurRadius: 1,
                        offset: Offset(0, 2))
                  ]),
                  padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // one colum
                      Flexible(
                          flex: 1,
                          child: Wrap(
                            direction: Axis.vertical,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            alignment: WrapAlignment.center,
                            children: [
                              const SizedBox(height: 10),
                             controller. lenderReponse.isEmpty
                                  ? const SizedBox(
                                      width: 75,
                                      height: 75,
                                    )
                                  : Container(
                                      width: 75,
                                      height: 75,
                                      decoration:
                                          const BoxDecoration(shape: BoxShape.circle),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(1000),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                            controller.  lenderReponse["profile_img"].toString(),
                                          fit: BoxFit.cover,
                                          height: 75,
                                          width: 75,
                                        ),
                                      ),
                                    ),
                              const SizedBox(height: 5),
                              Container(
                                alignment: Alignment.center,
                                width: 90,
                                child: Text(
                                  controller.  lenderReponse.isEmpty?"":  "${controller.lenderReponse["username"]}",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.dmSerifDisplay(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ),
                              const SizedBox(height: 2),
                              SizedBox(
                                width: 80,
                                child: Text(
                                controller.  lenderReponse.isEmpty?"":  "${controller.lenderReponse["bio"]}",
                                
                                  textAlign: TextAlign.center,
                                  
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  
                                  
                                  style: GoogleFonts.lexendDeca(
                                      fontSize: 10,
                                      color: Colors.black,
                                      
                                      fontWeight: FontWeight.w300),
                                ),
                              ),
                              const SizedBox(height: 5)
                            ],
                          )),
        
                      // second column
                      Flexible(
                          flex: 3,
                          child: Container(
                            margin: const EdgeInsets.only(left: 20, right: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // first row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                   
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: RatingBarIndicator(
                                        rating:controller. lenderReponse.isEmpty
                                            ? 0
                                            : double.parse(
                                               controller. lenderReponse["rating"].toString()),
                                        itemBuilder: (context, index) => const Icon(
                                          Icons.star,
                                          color: Color(0xffCAAB05),
                                        ),
                                        itemCount: 5,
                                        itemSize: 20.0,
                                        direction: Axis.horizontal,
                                      ),
                                    ),
        
        
                                       Container(
                                          transform: Matrix4.translationValues(15, 0, 0),
                                         child: PopupMenuButton<int>(
                                          iconSize: 20,
                                          padding: EdgeInsets.zero,
                                          icon: const Icon(
                                                                       Icons.more_horiz_rounded
                                                                     ),
                                                 onSelected: (item)async {
                                       
                                                   if(item==0)
                                                   {
        
                                                  
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
                                          }        else if(sharedPreferences.getString(SizValue.isLogged).toString()=="1")
                             {

                                Navigator.push(context, MaterialPageRoute(builder: (context)=>BasicLoginInfo(fromWhere: sharedPreferences.getString(SizValue.source).toString())));

                             }
                            //  else if(sharedPreferences.getString(SizValue.isLogged).toString()=="2")
                            //  {

                            //     Navigator.push(context, MaterialPageRoute(builder: (context)=>AccountCreate()));

                            // }
                            
                            // else if (sharedPreferences
                            //                       .getString(SizValue.underReview)
                            //                       .toString() ==
                            //                   "0") {
                            //                 showReviewdialog(
                            //                     sharedPreferences
                            //                         .getString(
                            //                             SizValue.underReviewMsg)
                            //                         .toString(),
                            //                     sharedPreferences
                            //                         .getString(SizValue.underReview)
                            //                         .toString());
                            //               } 
                                          
                                          else if (sharedPreferences
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
                                           } 
        
                                           else
                                           {
        
                                            
                                                    blockUser();
        
                                           }
        
        
        
        
        
                                       
                                       
                                                   }
                                       
                                                   else
                                                   {
        
        
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
                                          }        else if(sharedPreferences.getString(SizValue.isLogged).toString()=="1")
                             {

                                Navigator.push(context, MaterialPageRoute(builder: (context)=>BasicLoginInfo(fromWhere: sharedPreferences.getString(SizValue.source).toString())));

                             }

                            //  else if(sharedPreferences.getString(SizValue.isLogged).toString()=="2")
                            //  {

                            //     Navigator.push(context, MaterialPageRoute(builder: (context)=>AccountCreate()));

                            // }
                            
                            // else if (sharedPreferences
                            //                       .getString(SizValue.underReview)
                            //                       .toString() ==
                            //                   "0") {
                            //                 showReviewdialog(
                            //                     sharedPreferences
                            //                         .getString(
                            //                             SizValue.underReviewMsg)
                            //                         .toString(),
                            //                     sharedPreferences
                            //                         .getString(SizValue.underReview)
                            //                         .toString());
                            //               } 
                                          
                                          else if (sharedPreferences
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
                                           } 
        
                                           else
                                           {
        
                                             reportLender();
        
                                           }
          
                                                   }
                                       
                                       
                                       
                                                 },
                                                  itemBuilder: (context) => [
                                                    PopupMenuItem<int>(value: 0, child: Text('Block',style: GoogleFonts.lexendDeca(fontWeight: FontWeight.w300),)),
                                                    PopupMenuItem<int>(value: 1, child: Text('Report',style: GoogleFonts.lexendDeca(fontWeight: FontWeight.w300))),
                                                 ],
                                               ),
                                       ),
        
                                  ],
                                ),
        
                                const SizedBox(
                                  height: 10,
                                ),
        
                                // second row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // first colum
                                    Wrap(
                                      alignment: WrapAlignment.center,
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      direction: Axis.vertical,
                                      children: [
                                        Text(
                                       controller. lenderReponse.isEmpty?"":  controller.lenderReponse["total_item"].toString(),
                                          style: GoogleFonts.lexendDeca(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 17,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          "Items",
                                          style: GoogleFonts.lexendDeca(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 12,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                    // second colum
                                    Wrap(
                                      alignment: WrapAlignment.center,
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      direction: Axis.vertical,
                                      children: [
                                        Text(
                                        controller.  lenderReponse.isEmpty
                                              ? ""
                                              : MoneyFormatter(
                                                      amount: double.parse(
                                                         controller. lenderReponse[
                                                                  "closet_value"]
                                                              .toString()))
                                                  .output
                                                  .compactNonSymbol,
                                          style: GoogleFonts.lexendDeca(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 17,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          "Closet Value",
                                          style: GoogleFonts.lexendDeca(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 12,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                    // third colum
                                    Wrap(
                                      alignment: WrapAlignment.center,
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      direction: Axis.vertical,
                                      children: [
                                        Text(
                                        controller.  lenderReponse.isEmpty
                                              ? ""
                                              : MoneyFormatter(
                                                      amount: double.parse(
                                                          controller.lenderReponse["follower"]
                                                              .toString()))
                                                  .output
                                                  .compactNonSymbol,
                                          style: GoogleFonts.lexendDeca(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 17,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          "Followers",
                                          style: GoogleFonts.lexendDeca(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 12,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
        
                                // third row
        
                                const SizedBox(
                                  height: 10,
                                ),
        
                                Row(
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: InkWell(
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
                                          }       else if(sharedPreferences.getString(SizValue.isLogged).toString()=="1")
                             {

                                Navigator.push(context, MaterialPageRoute(builder: (context)=>BasicLoginInfo(fromWhere: sharedPreferences.getString(SizValue.source).toString())));

                             }
                            //  else if(sharedPreferences.getString(SizValue.isLogged).toString()=="2")
                            //  {

                            //     Navigator.push(context, MaterialPageRoute(builder: (context)=>AccountCreate()));

                            // }
                            
                            // else if (sharedPreferences
                            //                       .getString(SizValue.underReview)
                            //                       .toString() ==
                            //                   "0") {
                            //                 showReviewdialog(
                            //                     sharedPreferences
                            //                         .getString(
                            //                             SizValue.underReviewMsg)
                            //                         .toString(),
                            //                     sharedPreferences
                            //                         .getString(SizValue.underReview)
                            //                         .toString());
                            //               } 
                                          
                                          else if (sharedPreferences
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
                                           
        
                                                        goToChat(context, controller. lenderReponse["chat_user_id"].toString(), "", widget.lenderId);
                                          }
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(right: 5),
                                          alignment: Alignment.center,
                                          width: MediaQuery.of(context).size.width,
                                          padding: const EdgeInsets.only(
                                              top: 7, bottom: 7, left: 20, right: 20),
                                          decoration: const BoxDecoration(
                                            borderRadius:
                                                BorderRadius.all(Radius.circular(5)),
                                            color: Colors.black,
                                          ),
                                          child: Text("MESSAGE",
                                              style: GoogleFonts.lexendExa(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 11)),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: InkWell(
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
                                          }        else if(sharedPreferences.getString(SizValue.isLogged).toString()=="1")
                             {

                                Navigator.push(context, MaterialPageRoute(builder: (context)=>BasicLoginInfo(fromWhere: sharedPreferences.getString(SizValue.source).toString())));

                             }
                            //  else if(sharedPreferences.getString(SizValue.isLogged).toString()=="2")
                            //  {

                            //     Navigator.push(context, MaterialPageRoute(builder: (context)=>AccountCreate()));

                            // }
                            
                            //  else if (sharedPreferences
                            //                       .getString(SizValue.underReview)
                            //                       .toString() ==
                            //                   "0") {
                            //                 showReviewdialog(
                            //                     sharedPreferences
                            //                         .getString(
                            //                             SizValue.underReviewMsg)
                            //                         .toString(),
                            //                     sharedPreferences
                            //                         .getString(SizValue.underReview)
                            //                         .toString());
                            //               } 
                                          
                                          else if (sharedPreferences
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
                                            if (controller.follow) {
                                              unfollowLender();
                                            } else {
                                              followLender();
                                            }
                                          }
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(left: 5),
                                          alignment: Alignment.center,
                                          width: MediaQuery.of(context).size.width,
                                          padding: const EdgeInsets.only(
                                            top: 7,
                                            bottom: 7,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(5)),
                                            color: controller.follow
                                                ? Colors.transparent
                                                : MyColors.themecolor,
                                          ),
                                          child: Text(controller.follow ? "FOLLOWING" : "FOLLOW",
                                              style: GoogleFonts.lexendExa(
                                                  color: controller.follow
                                                      ? Colors.black
                                                      : Colors.white,
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 11)),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
        
                //tabbar  ========================================================================================================
        
                Theme(
                  data: ThemeData(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      //This is for background color
                      color: Colors.white.withOpacity(0.0),
                      //This is for bottom border that is needed
                    ),
                    child: TabBar(
                      splashFactory: NoSplash.splashFactory,
                      indicatorColor: Colors.black,
                      indicatorWeight: 4,
                      onTap: (value) {
                        if (value == 1) {
                          setState(() {
                            pagenoR = 1;
                          });
        
                          getlenderReview(1);
                        } else if (value == 0) {
                          setState(() {
                            pagenoC = 1;
                          });
                         controller. getlenderProfile( context,widget.lenderId, 1);
                        }
                      },
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.black,
                      labelStyle: GoogleFonts.lexendExa(
                          fontSize: 16, fontWeight: FontWeight.w300),
                      tabs: const [
                        Tab(text: "CLOSET"),
                        Tab(text: "REVIEWS"),
                      ],
                      controller: tabController,
                    ),
                  ),
                ),
        
                Expanded(
                  child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: tabController,
                      children: [
                        // tab one ==============================================================================================
        
                        Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 20),
                              child: DynamicHeightGridView(
                                controller: _scrollControllerC,
                                physics: const ClampingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount:controller. lenderListDecorded.length,
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                builder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ProductView(
                                                   index: index,
                                                    id:controller. lenderListDecorded[index]
                                                            ["id"]
                                                        .toString(),
                                                    fromCart: false,
                                                    comesFrom: "4",
                                                  )));
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          top: index == 0
                                              ? 10
                                              : index == 1
                                                  ? 10
                                                  : 0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Stack(
                                            children: [
                                              Hero(
                                                tag:controller. lenderListDecorded[index]
                                                        ["image_id"]
                                                    .toString(),
                                                child: CachedNetworkImage(
                                                  imageUrl: controller.lenderListDecorded[index]
                                                          ["img_url"]
                                                      .toString(),
                                                  height: 220,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              InkWell(
                                                  onTap: () async {
                                                    SharedPreferences
                                                        sharedPreferences =
                                                        await SharedPreferences
                                                            .getInstance();
        
                                                    if (sharedPreferences
                                                            .getString(
                                                                SizValue.isLogged)
                                                            .toString() ==
                                                        "null") {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  LoginPage(
                                                                      otpNumber:
                                                                          "")));
                                                    }        else if(sharedPreferences.getString(SizValue.isLogged).toString()=="1")
                             {

                                Navigator.push(context, MaterialPageRoute(builder: (context)=>BasicLoginInfo(fromWhere: sharedPreferences.getString(SizValue.source).toString())));

                             }
                            //  else if(sharedPreferences.getString(SizValue.isLogged).toString()=="2")
                            //  {

                            //     Navigator.push(context, MaterialPageRoute(builder: (context)=>AccountCreate()));

                            // }
                            
                            //  else if (sharedPreferences
                            //                                 .getString(
                            //                                     SizValue.underReview)
                            //                                 .toString() ==
                            //                             "0") {
                            //                           showReviewdialog(
                            //                               sharedPreferences
                            //                                   .getString(SizValue
                            //                                       .underReviewMsg)
                            //                                   .toString(),
                            //                               sharedPreferences
                            //                                   .getString(SizValue
                            //                                       .underReview)
                            //                                   .toString());
                            //                         } 
                                                    
                                                    
                                                    else if (sharedPreferences
                                                            .getString(
                                                                SizValue.underReview)
                                                            .toString() ==
                                                        "2") {
                                                      showReviewdialog(
                                                          sharedPreferences
                                                              .getString(SizValue
                                                                  .rejectedReviewMSG)
                                                              .toString(),
                                                          sharedPreferences
                                                              .getString(SizValue
                                                                  .underReview)
                                                              .toString());
                                                    } else if (sharedPreferences
                                                            .getString(
                                                                SizValue.underReview)
                                                            .toString() ==
                                                        "3") {
                                                      showReviewdialog(
                                                          sharedPreferences
                                                              .getString(SizValue
                                                                  .incompleteMessage)
                                                              .toString(),
                                                          sharedPreferences
                                                              .getString(SizValue
                                                                  .underReview)
                                                              .toString());
                                                    } else {
                                                      if (controller.lenderListDecorded[index]
                                                              ["wishlist"] ==
                                                          0) {
                                                        addWishlist(
                                                            context,
                                                            controller.lenderListDecorded[index]
                                                                    ["id"]
                                                                .toString(),
                                                            index);
                                                      } else {
                                                        removeWishlist(
                                                           controller. lenderListDecorded[index]
                                                                    ["id"]
                                                                .toString(),
                                                            index);
                                                      }
                                                    }
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.centerRight,
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(3),
                                                      margin: const EdgeInsets.all(4),
                                                      decoration: const BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: Color.fromARGB(
                                                                    27, 0, 0, 0),
                                                                blurRadius: 3)
                                                          ]),
                                                      child: SvgPicture.asset(
                                                         controller. lenderListDecorded[index]
                                                                      ["wishlist"] ==
                                                                  0
                                                              ? "assets/images/likebefore.svg"
                                                              : "assets/images/likeafter.svg"),
                                                    ),
                                                  )),
                                              Visibility(
                                                visible:controller. lenderListDecorded[index]
                                                            ["type"] ==
                                                        1
                                                    ? false
                                                    : true,
                                                child: Positioned(
                                                  bottom: 0,
                                                  left: 0,
                                                  child: Container(
                                                    margin: const EdgeInsets.all(5),
                                                    padding: const EdgeInsets.only(
                                                        left: 3, right: 3),
                                                    decoration: const BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(50))),
                                                    child: Text(
                                                      "MANAGED",
                                                      style: GoogleFonts.lexendExa(
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.w400,
                                                          color: MyColors.themecolor),
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
                                             
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      alignment: Alignment.centerLeft,
                                                      margin: const EdgeInsets.only(),
                                                      child: Text(
                                                       controller. lenderListDecorded[index]
                                                                ["brand_name"]
                                                            .toString(),
                                                        textAlign: TextAlign.left,
                                                        maxLines: 1,
                                                        overflow:TextOverflow.ellipsis,
                                                        style:
                                                            GoogleFonts.dmSerifDisplay(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  controller.lenderListDecorded[index]
                                                                  ["category_id"]
                                                              .toString() ==
                                                          "1"
                                                      ? Container(
                                                          height: 15,
                                                          padding:
                                                              const EdgeInsets.only(
                                                                  left: 5, right: 5),
                                                          alignment: Alignment.center,
                                                          constraints:
                                                              const BoxConstraints(
                                                                  minWidth: 20),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .all(
                                                                      Radius.circular(
                                                                          50)),
                                                              border: Border.all(
                                                                  color: Colors.black,
                                                                  width: 1)),
                                                          child: Text(
                                                            controller.lenderListDecorded[index]
                                                                    ["size_name"]
                                                                .toString(),
                                                            style: GoogleFonts
                                                                .lexendDeca(
                                                                    fontSize: 8,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color:
                                                                        Colors.black),
                                                          ),
                                                        )
                                                      : Container(
                                                          padding:
                                                              const EdgeInsets.all(5),
                                                          margin:
                                                              const EdgeInsets.only(
                                                                  top: 5),
                                                          height: 20,
                                                          width: 10,
                                                        )
                                                ],
                                              ),
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                margin: const EdgeInsets.only(
                                                    top: 3, bottom: 5),
                                                child: Text(
                                                 controller. lenderListDecorded[index]["title"]
                                                      .toString(),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  textAlign: TextAlign.left,
                                                  style: GoogleFonts.lexendDeca(
                                                    fontWeight: FontWeight.w300,
                                                    color: const Color.fromARGB(
                                                        255, 97, 97, 97),
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                margin: const EdgeInsets.only(
                                                    top: 3, bottom: 5),
                                                child: Text(
                                                 controller. lenderListDecorded[index]
                                                                  ["category_id"]
                                                              .toString() ==
                                                          "1"
                                                      ? "RENT AED ${controller.lenderListDecorded[index]["rent_amount"]} | 3 DAYS"
                                                      : "RENT AED ${controller.lenderListDecorded[index]["rent_amount"]} | 8 DAYS",
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
                                                margin: const EdgeInsets.only(
                                                    top: 3, bottom: 20),
                                                child: Text(
                                                  "Retail AED ${controller.lenderListDecorded[index]["retail_price"]}",
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  textAlign: TextAlign.left,
                                                  style: GoogleFonts.lexendDeca(
                                                    decoration:
                                                        TextDecoration.lineThrough,
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
                                    ),
                                  );
                                },
                              ),
                            ),
                            Visibility(
                              visible:controller. showLazyIndicatorCP,
                              child: Positioned(
                                bottom: 0,
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.only(right: 20),
                                    margin: const EdgeInsets.only(bottom: 10),
                                    child: const CircularProgressIndicator()),
                              ),
                            )
                          ],
                        ),
        
                        // tab two ==========================================================================================
        
                        lenderdecordedListReview.isEmpty
                            ? Center(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "No Review",
                                    style: GoogleFonts.lexendDeca(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.grey),
                                  ),
                                ),
                              )
                            : Stack(
                                children: [
                                  ListView.builder(
                                      controller: _scrollControllerR,
                                      physics: const ClampingScrollPhysics(),
                                      itemCount: lenderdecordedListReview.length,
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      itemBuilder: ((context, index) {
                                        List<dynamic> myImages =
                                            lenderdecordedListReview[index]["images"];
        
                                        // for lender review UI =============================
        
                                        return lenderdecordedListReview[index]["type"]
                                                    .toString() ==
                                                "2"
                                            ? Container(
                                                padding: const EdgeInsets.only(
                                                    top: 10,
                                                    bottom: 10,
                                                    left: 10,
                                                    right: 10),
                                                margin: const EdgeInsets.only(
                                                    top: 10, bottom: 10),
                                                width:
                                                    MediaQuery.of(context).size.width,
                                                decoration: const BoxDecoration(
                                                    color: Color(0xffF6F5F1)),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Wrap(
                                                      direction: Axis.horizontal,
                                                      alignment: WrapAlignment.center,
                                                      crossAxisAlignment:
                                                          WrapCrossAlignment.center,
                                                      children: [
                                                        Container(
                                                          width: 55,
                                                          height: 55,
                                                          padding:
                                                              const EdgeInsets.all(2),
                                                          decoration:
                                                              const BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    1000),
                                                            child: CachedNetworkImage(
                                                              imageUrl:
                                                                  lenderdecordedListReview[
                                                                              index][
                                                                          "profile_img"]
                                                                      .toString(),
                                                              fit: BoxFit.cover,
                                                              height: 55,
                                                              width: 55,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(width: 10),
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment.start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "${lenderdecordedListReview[index]["username"]} ",
                                                              style: GoogleFonts
                                                                  .dmSerifDisplay(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                      fontSize: 15),
                                                            ),
                                                            RatingBarIndicator(
                                                              rating: double.parse(
                                                                  lenderdecordedListReview[
                                                                              index]
                                                                          ["rating"]
                                                                      .toString()),
                                                              itemBuilder:
                                                                  (context, index) =>
                                                                      const Icon(
                                                                Icons.star,
                                                                color:
                                                                    Color(0xffCAAB05),
                                                              ),
                                                              itemCount: 5,
                                                              itemSize: 15.0,
                                                              direction:
                                                                  Axis.horizontal,
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                    Container(
                                                      margin: const EdgeInsets.only(
                                                          top: 10, left: 20),
                                                      child: Text(
                                                        'LENDER REVIEW',
                                                        style: GoogleFonts.lexendExa(
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            fontSize: 12,
                                                            color: Colors.black),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: const EdgeInsets.only(
                                                          top: 10,
                                                          bottom: 10,
                                                          left: 20),
                                                      child: Text(

                                                 decordedResponse( lenderdecordedListReview[
                                                                index]["comment_enc"]
                                                            .toString(),),

                                                       
                                                        style: GoogleFonts.lexendDeca(
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            fontSize: 12,
                                                            color: Colors.black),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            : Container(
                                                margin: const EdgeInsets.only(
                                                    top: 10, bottom: 10, right: 10),
                                                child: Wrap(
                                                  alignment: WrapAlignment.start,
                                                  crossAxisAlignment:
                                                      WrapCrossAlignment.start,
                                                  direction: Axis.vertical,
                                                  children: [
                                                    Wrap(
                                                      direction: Axis.horizontal,
                                                      alignment: WrapAlignment.center,
                                                      crossAxisAlignment:
                                                          WrapCrossAlignment.center,
                                                      children: [
                                                        const SizedBox(width: 10),
                                                        Container(
                                                          width: 55,
                                                          height: 55,
                                                          padding:
                                                              const EdgeInsets.all(2),
                                                          decoration:
                                                              const BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    1000),
                                                            child: CachedNetworkImage(
                                                              imageUrl:
                                                                  lenderdecordedListReview[
                                                                              index][
                                                                          "profile_img"]
                                                                      .toString(),
                                                              fit: BoxFit.cover,
                                                              height: 55,
                                                              width: 55,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(width: 10),
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment.start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "${lenderdecordedListReview[index]["username"]} ",
                                                              style: GoogleFonts
                                                                  .dmSerifDisplay(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                      fontSize: 15),
                                                            ),
                                                            RatingBarIndicator(
                                                              rating: double.parse(
                                                                  lenderdecordedListReview[
                                                                              index]
                                                                          ["rating"]
                                                                      .toString()),
                                                              itemBuilder:
                                                                  (context, index) =>
                                                                      const Icon(
                                                                Icons.star,
                                                                color:
                                                                    Color(0xffCAAB05),
                                                              ),
                                                              itemCount: 5,
                                                              itemSize: 15.0,
                                                              direction:
                                                                  Axis.horizontal,
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
        
                                                    const SizedBox(height: 10),
        
                                                    // horizontal list
        
                                                    SizedBox(





                                                      width: MediaQuery.of(context)
                                                          .size
                                                          .width,
                                                      height:
                                                          myImages.isEmpty ? 0 : 100,
                                                      child: ListView.builder(
                                                          physics:
                                                              const BouncingScrollPhysics(
                                                                  parent:
                                                                      ScrollPhysics()),
                                                          itemCount: myImages.length,
                                                          shrinkWrap: true,
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          itemBuilder:
                                                              (context, index2) {
                                                            return InkWell(
                                                              onTap: () {
                                                                // view image dialog  ============================================
                                                                showGeneralDialog(
                                                                  context: context,
                                                                  barrierLabel:
                                                                      "Barrier",
                                                                  barrierDismissible:
                                                                      true,
                                                                  barrierColor: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.5),
                                                                  transitionDuration:
                                                                      const Duration(
                                                                          milliseconds:
                                                                              100),
                                                                  pageBuilder:
                                                                      (_, __, ___) {
                                                                    return Center(
                                                                        child: Container(
                                                                            alignment: Alignment.center,
                                                                            height: 400,
                                                                            child: CachedNetworkImage(
                                                                              imageUrl:
                                                                                  myImages[index2].toString(),
                                                                              height:
                                                                                  400,
                                                                              fit: BoxFit
                                                                                  .contain,
                                                                              width: MediaQuery.of(context)
                                                                                  .size
                                                                                  .width,
                                                                            )));
                                                                  },
                                                                );
                                                              },
                                                              child: Container(
                                                                margin:
                                                                    EdgeInsets.only(
                                                                        left:
                                                                            index2 ==
                                                                                    0
                                                                                ? 30
                                                                                : 5),
                                                                child:
                                                                    CachedNetworkImage(
                                                                  imageUrl:
                                                                      myImages[index2]
                                                                          .toString(),
                                                                  width: 88,
                                                                  height: 100,
                                                                  fit: BoxFit.cover,
                                                                ),
                                                              ),
                                                            );
                                                          }),
                                                    ),
        
                                                    SizedBox(
                                                        height: myImages.isEmpty
                                                            ? 0
                                                            : 10),
        
                                                    Container(
                                                      padding: const EdgeInsets.only(
                                                          right: 5, left: 30),
                                                      width: MediaQuery.of(context)
                                                          .size
                                                          .width,
                                                      child: Text(
                                                         decordedResponse( lenderdecordedListReview[
                                                                index]["comment_enc"]
                                                            .toString()),
                                                        style: GoogleFonts.lexendDeca(
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            color:
                                                                const Color.fromARGB(
                                                                    255, 37, 37, 37),
                                                            fontSize: 12),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              );
                                      })),
                                  Visibility(
                                    visible: showLazyIndicatorR,
                                    child: Positioned(
                                      bottom: 0,
                                      child: Container(
                                          width: MediaQuery.of(context).size.width,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.only(right: 20),
                                          margin: const EdgeInsets.only(bottom: 10),
                                          child: const CircularProgressIndicator()),
                                    ),
                                  )
                                ],
                              )
                      ]),
                )
              ],
            ),
          ),
        );
      }
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
          child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                   margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(13)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
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
                                final BottomNavController controller =
                                    Get.put(BottomNavController());
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
                  ),
                ),
              )),
        );
      },
    );
  }


// report bottom sheet=====================================================




   
reportLender() {
  return

      // logut yes or no

      showModalBottomSheet(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10))),
          context: context,
          builder: (context) {
               
          
          return Wrap(children: [
                Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 20),
                    
                    child: Column(
                    
                      children: [

                      Container(
                            alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 10),
                   
                   child: Text("Report",style:GoogleFonts.lexendDeca(
                      fontSize: 18,
                      fontWeight: FontWeight.w300
                   )),
                  ),

                        Container(
                            alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 10,bottom: 10),
                    width: 35,
                    height: 2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: const Color(0xff9D9D9D)),
                  ),

                    Container(
                            alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 0,left: 20,right:20),
                   
                   child: Text("This will only be shared with Sizters App support team. We aim to get back to you within 1 business day.",
                   
                   
                   style:GoogleFonts.lexendDeca(
                      fontSize: 14,
                      color: Colors.grey,

                      fontWeight: FontWeight.w300
                   )),
                  ),

                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    reportScam("User is asking for payment outside the Sizters App");
                      
                    },
                    child: Container(
                       margin: const EdgeInsets.only(left: 20,right:20,top: 30),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text("User is asking for payment outside the Sizters App",style: GoogleFonts.lexendDeca(
                              fontSize: 16,
                              fontWeight: FontWeight.w300
                            ),),
                          ),
                    
                    
                          const Icon(Icons.arrow_forward_ios,size: 15,)
                        ],
                      ),
                    ),
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 1,
                    color: const Color.fromARGB(255, 235, 235, 235),
                    margin: const EdgeInsets.only(left: 30,right: 30,top: 20,bottom:20),
                  ),

                   InkWell(
                    onTap: () {
                      Navigator.pop(context);
                       reportScam("User has damaged or lost an item");
                      
                    },
                    child: Container(
                       margin: const EdgeInsets.only(left: 20,right:20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text("User has damaged or lost an item",style: GoogleFonts.lexendDeca(
                              fontSize: 16,
                              fontWeight: FontWeight.w300
                            ),),
                          ),
                    
                    
                          const Icon(Icons.arrow_forward_ios,size: 15,)
                        ],
                      ),
                    ),
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 1,
                    color: const Color.fromARGB(255, 235, 235, 235),
                    margin: const EdgeInsets.only(left: 30,right: 30,top: 20,bottom:20),
                  ),


                  

                  InkWell(
                    onTap: () {

                      Navigator.pop(context);

                    reportScam("User is inappropriate");
                      
                    },
                    child: Container(
                       margin: const EdgeInsets.only(left: 20,right:20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text("User is inappropriate",style: GoogleFonts.lexendDeca(
                              fontSize: 16,
                              fontWeight: FontWeight.w300
                            ),),
                          ),
                    
                    
                          const Icon(Icons.arrow_forward_ios,size: 15,)
                        ],
                      ),
                    ),
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 1,
                    color: const Color.fromARGB(255, 235, 235, 235),
                    margin: const EdgeInsets.only(left: 30,right: 30,top: 20,bottom:20),
                  ),


                     InkWell(
                      onTap: () {

                        Navigator.pop(context);
                        reportScam("User is unresponsive");
                        
                      },
                       child: Container(
                        margin: const EdgeInsets.only(left: 20,right:20),
                                         child: Row(
                        children: [
                          Expanded(
                            child: Text("User is unresponsive",style: GoogleFonts.lexendDeca(
                              fontSize: 16,
                              fontWeight: FontWeight.w300
                            ),),
                          ),
                                       
                                       
                          const Icon(Icons.arrow_forward_ios,size: 15,)
                        ],
                                         ),
                                       ),
                     ),

    

                          const SizedBox(height: 30),
                      ],
                    )),
              ]);
            }
          
          
          
          
          );
}


reportTextdialog()
{
  return showGeneralDialog(
                context: context,
                barrierLabel: "Barrier",
                barrierDismissible: false,
                barrierColor: Colors.black.withOpacity(0.5),
                transitionDuration: const Duration(milliseconds: 300),
                pageBuilder: (_, __, ___) {
                  return WillPopScope(
                    onWillPop: () async{
                      return false;
                    },
                    child: Center(
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: 20,right: 20),
                        height: 180,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(13)),
                        child:  Scaffold(
                          backgroundColor: Colors.transparent,
                            body: Column( 
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                             Text(
                                "Thank you, we received you report",textAlign: TextAlign.center,style: GoogleFonts.lexendDeca(fontSize: 18,fontWeight: FontWeight.w400),),
                            const SizedBox(height: 10,),
                            
                             Text(
                                "While you wait for our decision, we'd like you to know that you can choose to block this account",textAlign: TextAlign.center,style: GoogleFonts.lexendDeca(fontSize: 14,fontWeight: FontWeight.w300),),



                     const SizedBox(height: 15),               

   
                    Row(
                                  children: [

                                    Flexible(
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                         
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.only(left: 20,right:5),
                                          decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Colors.black,
                                        ),
                                          width: MediaQuery.of(context).size.width,
                                          height: 40,
                                      
                                          child: Text("OK",style: GoogleFonts.lexendExa(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300
                                          ),),
                                        ),
                                      ),
                                    ),
                                   Flexible(
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                         blockUser();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: Colors.black,
                                          ),
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.only(left: 5,right:20),
                                          
                                          width: MediaQuery.of(context).size.width,
                                          height: 40,
                                      
                                          child: Text("BLOCK",style: GoogleFonts.lexendExa(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300
                                          ),),
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                          
    
      
                          ],
                        )),
                      ),
                    ),
                  );
                },
              );
}



userblockedMe()
{
  return showGeneralDialog(
                context: context,
                barrierLabel: "Barrier",
                barrierDismissible: false,
                barrierColor: Colors.black.withOpacity(0.5),
                transitionDuration: const Duration(milliseconds: 300),
                pageBuilder: (_, __, ___) {
                  return WillPopScope(
                    onWillPop: () async{
                      return false;
                    },
                    child: Center(
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: 20,right: 20),
                        height: 100,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(13)),
                        child:  Scaffold(
                          backgroundColor: Colors.transparent,
                            body: Column( 
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                             Text(
                                "Currently this account not available",textAlign: TextAlign.center,style: GoogleFonts.lexendDeca(fontSize: 14,fontWeight: FontWeight.w300),),
                  
                                InkWell(
                                  onTap: () {
                                   Navigator.pop(context);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(top: 15),
                                    padding: const EdgeInsets.only(top: 10,bottom: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(5)
                                    ),
                                    child:  Text("OK",
                                    textAlign: TextAlign.center,
                                   style: GoogleFonts.lexendExa(
        
        fontSize: 16,color: Colors.white,fontWeight: FontWeight.w300)),
                                  ),
                                )
                          ],
                        )),
                      ),
                    ),
                  );
                },
              );
}



 Future<void> goToChat(BuildContext context, String chatID  ,String productId , String lenderId) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  ChatInside( lenderId: chatID,product: productId,order: "",)),
    );

  
    if (!context.mounted) return;

    if(result.toString()=="true")
    {

      controller.dialogBlockedProfile(context,lenderId);

    }

  
    
    
  }



   Future<void> gotoWishlist() async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Wishlist(from: "profile")),
    );

  
    if (!context.mounted) return;

    if(result.toString()=="true")
    {  


       setState(() {
         pagenoC=1;
         controller. lenderListDecorded.clear();
       });
        controller. getlenderProfile(context,widget.lenderId,  1);
      

    }

  
    
    
  }







}
