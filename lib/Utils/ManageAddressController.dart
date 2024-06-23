// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';

import 'dart:io';


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siz/Utils/Colors.dart';
import 'package:siz/Utils/Value.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';


class ManageAddressController extends GetxController{

  
  // get address list

  Map<String, dynamic> addressResponse = {};
  List<dynamic> decordedResponse = [];



  // get address =====================================================================================

  getAddress(BuildContext context,bool allAddress) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  

   dialodShow(context);

    try {
      final response = await http.post(Uri.parse(SizValue.getAddress), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey).toString(),
       
        'type': allAddress?"":"1",
      });

      addressResponse = jsonDecode(response.body);

    

       print("getaddrewss====" +addressResponse.toString());


      if (addressResponse["success"] == true) {

         Navigator.pop(context);
  
          decordedResponse = addressResponse["list"];
         
          update();
      } 
      
      else if (addressResponse["success"] == false) {
         
        Navigator.pop(context);

            update();
      }

      
    } on ClientException {
      
     Navigator.pop(context);
      mysnackbar("Server not responding please try again after sometime",context);
    } on SocketException {
      Navigator.pop(context);
      mysnackbar("No Internet connection 😑 please try again after sometime",context);
    } on HttpException {
        Navigator.pop(context);
      mysnackbar("Something went wrong please try after sometime",context);
    } on FormatException {
      Navigator.pop(context);
      mysnackbar("Something went wrong please try after sometime",context);
    }
  }



  // addaddress list

    Map<String, dynamic> addAddressResponse = {};


  // addAddress =====================================================================================

  addAddress(BuildContext context, String appartment,String buildingName,String area,String state,String contactname,String mobile,String type,bool alladdress ) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

   
    
    try {
      final response = await http.post(Uri.parse(SizValue.addAddress), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey),
        // 'user_key': "a278b4cf294c22e796bc351139efffe30b17df2f",
        'apartment': appartment,
        'area_name': buildingName,
        'city': area,
        'state': state,
        'contact_name': contactname,
        'mobile_number': mobile,
        'type': type,
      });
       

      addAddressResponse = jsonDecode(response.body);

      
      if (addAddressResponse["success"] == true) {
        
         getAddress(context,alladdress);
         
      } 
      
      else if (addAddressResponse["success"] == false) {
        
        ScaffoldMessenger.of(context)
       .showSnackBar( SnackBar(content: Text(addAddressResponse["error"].toString(),style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
     
      }

      
    } on ClientException {
      Navigator.pop(context);
      mysnackbar("Server not responding please try again after sometimev fg",context);
    } on SocketException {
     Navigator.pop(context);
      mysnackbar("No Internet connection 😑 please try again after sometime",context);
    } on HttpException {
       Navigator.pop(context);
      mysnackbar("Something went wrong please try after sometime",context);
    } on FormatException {
       Navigator.pop(context);
      mysnackbar("Something went wrong please try after sometime",context);
    }
  }



    Map<String, dynamic> editAddressResponse = {};



    // editAddress =====================================================================================

  editAddress(BuildContext context,String appartment,String buildingName,String area,String state,String contactname,String mobile,String type ,String addressID,bool alladdress) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  
    try {
      final response = await http.post(Uri.parse(SizValue.editAddress), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey).toString(),
        'address_id': addressID,
        'apartment': appartment,
        'area_name': buildingName,
        'city': area,
        'state': state,
        'contact_name': contactname,
        'mobile_number': mobile,
        'type': type,
      });
       
      editAddressResponse = jsonDecode(response.body);
      
      if (editAddressResponse["success"] == true) {
       
         getAddress(context,alladdress);
        
      } 
      
      else if (editAddressResponse["success"] == false) {
        
        ScaffoldMessenger.of(context)
       .showSnackBar( SnackBar(content: Text(editAddressResponse["error"].toString(),style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
      
      }

      
    } on ClientException {
      Navigator.pop(context);
      mysnackbar("Server not responding please try again after sometimev fg",context);
    } on SocketException {
     Navigator.pop(context);
      mysnackbar("No Internet connection 😑 please try again after sometime",context);
    } on HttpException {
       Navigator.pop(context);
      mysnackbar("Something went wrong please try after sometime",context);
    } on FormatException {
       Navigator.pop(context);
      mysnackbar("Something went wrong please try after sometime",context);
    }
  }


      Map<String, dynamic> deleteAddressResponse = {};



    // delete address =====================================================================================

  deleteAddress(BuildContext context, String addressID,bool alladdress) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      final response = await http.post(Uri.parse(SizValue.deleteAddress), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey),
        'address_id': addressID,
     
      });
       
      deleteAddressResponse = jsonDecode(response.body);
       

       


      if (deleteAddressResponse["success"] == true) {
        
         getAddress(context,alladdress);
        
      } 
      
      else if (deleteAddressResponse["success"] == false) {
        
        ScaffoldMessenger.of(context)
       .showSnackBar( SnackBar(content: Text(deleteAddressResponse["error"].toString(),style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
       
      }

      
    } on ClientException {
    
      mysnackbar("Server not responding please try again after sometimev fg",context);
    } on SocketException {
    
      mysnackbar("No Internet connection 😑 please try again after sometime",context);
    } on HttpException {
      
      mysnackbar("Something went wrong please try after sometime",context);
    } on FormatException {
        
      mysnackbar("Something went wrong please try after sometime",context);
    }
  }



  // snackbar ==================================================================================================

  mysnackbar(String message ,BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 1), content: Text(message,style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
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



  addValue(String key,String value) async
  {
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    sharedPreferences.setString(key, value);
  }



   // get pickUpAddress =====================================================================================

  Map<String, dynamic> pickupAddressResponse = {};
  List<dynamic> pickupAddressList = [];

  getPickupAddress(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  

  

    try {
      final response = await http.post(Uri.parse(SizValue.getpickUpAddress), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey),
       
       
      });

      pickupAddressResponse = jsonDecode(response.body);

      print(response.body);

      if (pickupAddressResponse["success"] == true) {
  
          pickupAddressList = pickupAddressResponse["list"];
          print(pickupAddressList.toString());
        
          update();
      } 
      
      else if (pickupAddressResponse["success"] == false) {
       
        ScaffoldMessenger.of(context)
            .showSnackBar( SnackBar(content: Text("Empty",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));


            update();
      }

      
    } on ClientException {
     
      mysnackbar("Server not responding please try again after sometime",context);
    } on SocketException {
    
      mysnackbar("No Internet connection 😑 please try again after sometime",context);
    } on HttpException {
      
      mysnackbar("Something went wrong please try after sometime",context);
    } on FormatException {
     
      mysnackbar("Something went wrong please try after sometime",context);
    }
  }


}