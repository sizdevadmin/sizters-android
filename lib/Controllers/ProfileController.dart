// ignore_for_file: camel_case_types, use_build_context_synchronously

import 'dart:convert';

import 'package:get/get.dart';






import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:siz/Utils/Colors.dart';

import 'dart:io';
import 'package:siz/Utils/Value.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';


class profileController extends GetxController{


  // true false ===========


    bool isLoadingMoreMC = false;
  bool oncesCallMC = false;
  bool noMoreDataMC = false;
   bool showLazyIndicator = false;



  String profileName = "";
  String profileImage = "";
  String review="";
  String reviewMSG="";
  String reviewRejectMSG="";
  String incompleteMsg="";
  String loginStatus="";
  String source="";



  

  getProfleValue() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  
    profileName = sharedPreferences.getString(SizValue.firstname).toString();
    profileImage = sharedPreferences.getString(SizValue.profile).toString();
    review=sharedPreferences.getString(SizValue.underReview).toString();
    loginStatus=sharedPreferences.getString(SizValue.isLogged).toString();
    reviewMSG=sharedPreferences.getString(SizValue.underReviewMsg).toString();
    reviewRejectMSG=sharedPreferences.getString(SizValue.rejectedReviewMSG).toString();
    incompleteMsg=sharedPreferences.getString(SizValue.incompleteMessage).toString();
    source= sharedPreferences.getString(SizValue.source).toString();

   

      update();
  
  }



    /// get my closets===================================================================================================

  Map<String, dynamic> closetsReponse = {};
  List<dynamic> decordedClosetsResponse = [];
 

  // get closets =====================================================================================

  getclosets(BuildContext context,int pageno) async {

  
   
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();


      if (pageno > 1) {

       showLazyIndicator = true;
       update();
    
    } 


    try {
      final response =
          await http.post(Uri.parse(SizValue.getmyproducts), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey),
        'type': "2",
        'page': pageno.toString(),
      });

      closetsReponse = jsonDecode(response.body);

   
      if (closetsReponse["success"] == true) {
       
        


         if (pageno <= 1) {
            decordedClosetsResponse = closetsReponse["list"];     
            isLoadingMoreMC = false;
            oncesCallMC = false;
            update();
          } else {
            decordedClosetsResponse.addAll(closetsReponse["list"]);
            isLoadingMoreMC = false;
            oncesCallMC = false;

            update();
          }

          if (closetsReponse["list"].toString() == "[]") {
            noMoreDataMC = true;
            isLoadingMoreMC = false;
            oncesCallMC = false;

            update();
          }

          if (pageno > 1) {
             showLazyIndicator = false;
            update();
          } 
       





       
      } else if (closetsReponse["success"] == false) {
          if (pageno > 1) {
             showLazyIndicator = false;
            update();
          } 
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(closetsReponse["error"].toString(),style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
      }
    } on ClientException {
        if (pageno > 1) {
             showLazyIndicator = false;
            update();
          } 
      mysnackbar(
          "Server not responding please try again after sometimev fg", context);
    } on SocketException {
        if (pageno > 1) {
             showLazyIndicator = false;
            update();
          } 
      mysnackbar(
          "No Internet connection 😑 please try again after sometime", context);
    } on HttpException {
        if (pageno > 1) {
             showLazyIndicator = false;
            update();
          } 
      mysnackbar("Something went wrong please try after sometime", context);
    } on FormatException {
        if (pageno > 1) {
             showLazyIndicator = false;
            update();
          } 
      mysnackbar("Something went wrong please try after sometime", context);
    }
  }

// account details ========================================================================================
   Map<dynamic, dynamic> lendingrentingResponse = {};
  Map<String, dynamic> decordedrentingReponse = {};
  Map<String, dynamic> decordedlendingReponse = {};
   List<dynamic> rentingGraph  = [];
    List<dynamic> lentingGraph  = [];


   getaccontDetails(BuildContext context,String year) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
   

   
    try {
      final response =
          await http.post(Uri.parse(SizValue.myaccontDetails), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey),
        'year':year
      });

      lendingrentingResponse = jsonDecode(response.body);

      if (lendingrentingResponse["success"] == true) {
         getclosets(context,1);

    
          decordedrentingReponse = lendingrentingResponse["renting_data"];
          decordedlendingReponse = lendingrentingResponse["lending_data"];
          rentingGraph=decordedrentingReponse["rental_graph"];
          lentingGraph=decordedlendingReponse["lender_graph"];

    
        

          update();


     

      
      } else if (lendingrentingResponse["success"] == false) {
        
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(lendingrentingResponse["error"].toString(),style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
      }
    } on ClientException {
  
      mysnackbar(
          "Server not responding please try again after sometime", context);
    } on SocketException {
   
      mysnackbar(
          "No Internet connection 😑 please try again after sometime", context);
    } on HttpException {
   
      mysnackbar("Something went wrong please try after sometime", context);
    } on FormatException {
      
      mysnackbar("Something went wrong please try after sometime", context);
    }
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



    // snackbar ==================================================================================================

  mysnackbar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(duration: const Duration(seconds: 1), content: Text(message,style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
  }

  forseUpdate()
  {
    update();
   }






   // my listings APIS ===============================================================================================


   // get  pending list

  Map<String, dynamic> pendingResponse = {};
  List<dynamic> decordedpendingResponse = [];

  // get  approve list

  Map<String, dynamic> rejectedResponse = {};
  List<dynamic> decordedrejectedReponse = [];

  // get  rejected list

  Map<String, dynamic> approveResponse = {};
  List<dynamic> decordedapproveReponse = [];

  bool clickedArroved = false;
  bool clickedRejected = false;
  bool clickedPending = false;

  // true false ==========================


  bool isLoadingMoreA = false;
  bool oncesCallA = false;
  bool noMoreDataA = false;
  bool showLazyIndicatorA = false;

   bool isLoadingMoreP = false;
  bool oncesCallP = false;
  bool noMoreDataP = false;
  bool showLazyIndicatorP = false;

   bool isLoadingMoreR = false;
  bool oncesCallR = false;
  bool noMoreDataR = false;
  bool showLazyIndicatorR = false;




  // get products =====================================================================================

   getProducts(BuildContext context, String type, int pageno) async {


    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  
    if (pageno <= 1) {
      dialodShow(context);
    } else {

     

         showLazyIndicatorA = true;
         update();
        
    
     
     
    }
    try {
      final response =
          await http.post(Uri.parse(SizValue.getmyproducts), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey),
        'type': type,
        'page': pageno.toString(),
      });

      if (type == "1") {
        pendingResponse = jsonDecode(response.body);

        if (pendingResponse["success"] == true) {
       
            if (pageno <= 1) {


            
             decordedpendingResponse = pendingResponse["list"];
            isLoadingMoreP = false;
            oncesCallP = false;

              update();
                
            
          
            
          } else {

          

            decordedpendingResponse.addAll(pendingResponse["list"]);
            isLoadingMoreP = false;
            oncesCallP = false;

              update();
              
        
           

           
          }

          if (pendingResponse["list"].toString() == "[]") {


         

              noMoreDataP = true;
            isLoadingMoreP = false;
            oncesCallP = false;

              update();
              
         
            

            
          }

          if (pageno <= 1) {
            Navigator.pop(context);
          } else {

           

               showLazyIndicatorA = false;
                 update();
              
          
           
          
          }


        } else if (pendingResponse["success"] == false) {
        if (pageno <= 1) {
            Navigator.pop(context);
          } else {

        
               showLazyIndicatorA = false;
                 update();
              
           
           
          
          }
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(pendingResponse["error"].toString(),style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
        }
      } else if (type == "2") {
        approveResponse = jsonDecode(response.body);

        
     

        if (approveResponse["success"] == true) {
        


         

           if (pageno <= 1) {


            

                   decordedapproveReponse = approveResponse["list"];
            isLoadingMoreA = false;
            oncesCallA = false;

              update();
            
          
            
          } else {

           

               decordedapproveReponse.addAll(approveResponse["list"]);
            isLoadingMoreA = false;
            oncesCallA = false;

              update();
              
           
           

           
          }

          if (approveResponse["list"].toString() == "[]") {


         

              noMoreDataA = true;
            isLoadingMoreA = false;
            oncesCallA = false;

              update();
              
          
            

            
          }

          if (pageno <= 1) {
            Navigator.pop(context);
          } else {

          

               showLazyIndicatorA = false;
              
            update();
           
          
          }





       
        } else if (approveResponse["success"] == false) {
          if (pageno <= 1) {
            Navigator.pop(context);
          } else {

           

               showLazyIndicatorA = false;
                 update();
              
          
           
          
          }
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(approveResponse["error"].toString(),style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
        }
      } else if (type == "3") {
        rejectedResponse = jsonDecode(response.body);

        if (rejectedResponse["success"] == true) {
         






          

           if (pageno <= 1) {


            

                   decordedrejectedReponse = rejectedResponse["list"];
            isLoadingMoreR = false;
            oncesCallR = false;

              update();
                
           
          
            
          } else {

            

               decordedrejectedReponse.addAll(rejectedResponse["list"]);
            isLoadingMoreR = false;
            oncesCallR = false;

              update();
              
         
           

           
          }

          if (rejectedResponse["list"].toString() == "[]") {


          

              noMoreDataR = true;
            isLoadingMoreR = false;
            oncesCallR = false;

              update();
              
       
            

            
          }

          if (pageno <= 1) {
            Navigator.pop(context);
          } else {

        

               showLazyIndicatorA = false;
                 update();
              
            
           
          
          }



          





         
        } else if (rejectedResponse["success"] == false) {
          if (pageno <= 1) {
            Navigator.pop(context);
          } else {

         

               showLazyIndicatorA = false;
                 update();
              
          
           
          
          }

          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(rejectedResponse["error"].toString(),style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
        }
      }
    } on ClientException {
     if (pageno <= 1) {
            Navigator.pop(context);
          } else {

          

               showLazyIndicatorA = false;
               showLazyIndicatorP = false;
  showLazyIndicatorR = false;
                 update();
        
           
          
          }

      mysnackbar(
          "Server not responding please try again after sometimev fg", context);
    } on SocketException {
     if (pageno <= 1) {
            Navigator.pop(context);
          } else {

         

               showLazyIndicatorA = false;
               showLazyIndicatorP = false;
  showLazyIndicatorR = false;

                 update();
              
          
           
          
          }

      mysnackbar(
          "No Internet connection 😑 please try again after sometime", context);
    } on HttpException {
      if (pageno <= 1) {
            Navigator.pop(context);
          } else {

        

               showLazyIndicatorA = false;
               showLazyIndicatorP = false;
  showLazyIndicatorR = false;
                 update();
              
          
           
          
          }

      mysnackbar("Something went wrong please try after sometime", context);
    } on FormatException {
      if (pageno <= 1) {
            Navigator.pop(context);
          } else {

        

               showLazyIndicatorA = false;
               showLazyIndicatorP = false;
  showLazyIndicatorR = false;
              
             update();
           
          
          }

      mysnackbar("Something went wrong please try after sometime", context);
    }
  }





}