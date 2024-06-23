// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siz/Utils/Colors.dart';
import 'dart:io';

import 'package:siz/Utils/Value.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class RentDetailsController extends GetxController{


  
  Map<String, dynamic> rentalResponse = {};
  

  getRentalDetails(BuildContext context, String id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      final response =
          await http.post(Uri.parse(SizValue.rentalDetails), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey),
        'id': id,
     
      });

      rentalResponse = jsonDecode(response.body);



     

      if (rentalResponse["success"] == true) {
        
       update();
      } else if (rentalResponse["success"] == false) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(rentalResponse["error"].toString(),style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
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

   // snackbar ==================================================================================================

  mysnackbar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(duration: const Duration(seconds: 1), content: Text(message,style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
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



}