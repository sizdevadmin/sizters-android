// ignore_for_file: use_build_context_synchronously

import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siz/Utils/Colors.dart';
import 'dart:io';

import 'package:siz/Utils/Value.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class  CartPromoController extends GetxController{

  
   
  Map<String, dynamic> cartResponse = {};
  List<dynamic> decordedReponse = [];


    Map<String, dynamic> removeReponse = {};
 
// get cart details ===============================================================================

  getCart(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    
    try {
      final response =
          await http.post(Uri.parse(SizValue.getCart), body: {
          'user_key': sharedPreferences.getString(SizValue.userKey),
           });

      cartResponse = jsonDecode(response.body);
     

        

      if (cartResponse["success"] == true) {
       
          decordedReponse = cartResponse["list"];

        
        
        

        

          
           update();
        
      } else if (cartResponse["success"] == false) {
       
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(cartResponse["error"].toString(),style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
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

  // remove item from cart ======================================================================================





  
    removeCart(BuildContext context, String cartId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

     
     
    try {
      final response =
          await http.post(Uri.parse(SizValue.removeCart), body: {
          'user_key': sharedPreferences.getString(SizValue.userKey),
          'cart': cartId,
           });

      removeReponse = jsonDecode(response.body);

    
  

      if (removeReponse["success"] == true)
      
       {


        getCart(context);
          
      } else if (removeReponse["success"] == false) {
       
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(removeReponse["error"].toString(),style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
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


   Map<String, dynamic> promocodeResponse= {};
  List<dynamic> decordedResponsePromo = [];


  // get products =====================================================================================

  getPromoCode(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    dialodShow(context);
    try {
      final response = await http.post(Uri.parse(SizValue.promoCodeList), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey),
      
  
      });

     promocodeResponse = jsonDecode(response.body);

     print(promocodeResponse.toString());

      if (promocodeResponse["success"] == true) {

      

         decordedResponsePromo=promocodeResponse["list"];
      
        Navigator.pop(context);
          
      update();
        
      

     
      } else if (promocodeResponse["success"] == false) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(promocodeResponse["error"].toString(),style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
    
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





  // apply promocode =====================================================================================

     Map<String, dynamic> applyPromoCodeResponse= {};

     String appliedPromoCode="";

  applyPromocode(BuildContext context,String promocode) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    dialodShow(context);
    try {
      final response = await http.post(Uri.parse(SizValue.promoAppy), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey),
        'promocode': promocode
      
  
      });

     applyPromoCodeResponse = jsonDecode(response.body);
   
      if (applyPromoCodeResponse["success"] == true) {


    
        appliedPromoCode=applyPromoCodeResponse["id"].toString();
       
        Navigator.pop(context);
        update();
        
      

     
      } else if (applyPromoCodeResponse["success"] == false) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(applyPromoCodeResponse["error"].toString(),style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white)),duration: const Duration(seconds: 1),));
    
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


  forseUpdate(){

    update();
  }



}