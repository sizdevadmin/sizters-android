// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siz/Pages/AllOrderRequest.dart';
import 'package:siz/Utils/Colors.dart';
import 'package:http/http.dart' as http;
import 'package:siz/Utils/Value.dart';

class BottomNavController extends GetxController{

  int currentIndex=0;

   List loadedPages = [0,];


  updateIndex(int index)
  {  

    currentIndex=index;

    update();
   
  }

  addPages(int index)
  {

    if(!loadedPages.contains(index))

    {

      loadedPages.add(index);
      update();

    }

    

  }

  forseUpdate()
  {
    update();
  }




    

  Map<String, dynamic> getHomeReponse = {};
  List<dynamic> productList = [];

  // get products =====================================================================================

  getHomeData( BuildContext context ,String firebaseToken) async {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
     
    try {
      final response = await http.post(Uri.parse(SizValue.getHome), body: {
        'user_key': sharedPreferences.getString(SizValue.isLogged).toString() ==
                "null"
            ? ""
            : sharedPreferences.getString(SizValue.isLogged).toString() == "1"
                ? ""
                : sharedPreferences.getString(SizValue.isLogged).toString() ==
                        "2"
                    ? ""
                    : sharedPreferences.getString(SizValue.userKey).toString(),

        "push_token": firebaseToken
      });

      getHomeReponse = jsonDecode(response.body);

      if (getHomeReponse["success"] == true) {
       

     
          productList = getHomeReponse["product_list"];

          sharedPreferences.setString(SizValue.manageIbutton,
              getHomeReponse["req_manage_closet_info"].toString());
          sharedPreferences.setString(SizValue.LMOIButton,
              getHomeReponse["add_own_list_info"].toString());
          sharedPreferences.setString(SizValue.underReview,
              getHomeReponse["id_user_verified"].toString());
          sharedPreferences.setString(SizValue.rejectedReviewMSG,
              getHomeReponse["user_reject_msg"].toString());
          sharedPreferences.setString(SizValue.incompleteMessage,
              getHomeReponse["user_incomplete_msg"].toString());
          sharedPreferences.setString(SizValue.underReviewMsg,
              getHomeReponse["user_review_msg"].toString());
          sharedPreferences.setString(SizValue.emirateIDInfo,
              getHomeReponse["emirates_id_info"].toString());
          sharedPreferences.setString(SizValue.basicdialogInfo,
              getHomeReponse["basic_info_skip_msg"].toString());
          sharedPreferences.setString(SizValue.emirateIDSkip,
              getHomeReponse["verify_id_skip_msg"].toString());
          sharedPreferences.setString(SizValue.referralAmount,
              getHomeReponse["referral_cart_discount_per"].toString());

          if (getHomeReponse["is_new_order"].toString() == "1") {
            showGeneralDialog(
              context: context,
              barrierLabel: "Barrier",
              barrierDismissible: false,
              barrierColor: Colors.black.withOpacity(0.5),
              transitionDuration: const Duration(milliseconds: 300),
              pageBuilder: (_, __, ___) {
                return WillPopScope(
                  onWillPop: () async {
                    return false;
                  },
                  child: Center(
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 30, right: 20),
                      height: 219,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(13)),
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
                                  getHomeReponse["request_text"].toString(),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lexendDeca(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AllOrderRequest()));
                                },
                                child: Container(
                                  width: 240,
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(top: 20),
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: MyColors.themecolor,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text("REQUESTS",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.lexendExa(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300)),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: 240,
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(top: 20),
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: const Color(0xffF6F5F1),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text("SKIP",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.lexendExa(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w300)),
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


          update();


          return true;
        
      } else if (getHomeReponse["success"] == false) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(getHomeReponse["error"].toString(),
                style: GoogleFonts.lexendDeca(
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                    color: Colors.white))));

                    return false;
      }
    } on http.ClientException {

      
      mysnackbar(
          "Server not responding please try again after sometime", context);

                              return false;



    } on SocketException {
      mysnackbar(
          "No Internet connection 😑 please try again after sometime", context);
                              return false;

    } on HttpException {
      mysnackbar("Something went wrong please try after sometime", context);
                          return false;

    } on FormatException {
      mysnackbar("Something went wrong please try after sometime", context);
                          return false;

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



  

}