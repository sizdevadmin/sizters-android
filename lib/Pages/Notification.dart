// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siz/Pages/AllOrderRequest.dart';
import 'package:siz/Pages/MyListing.dart';
import 'package:siz/Pages/RentDetails.dart';
import 'package:siz/Pages/Wishlist.dart';
import 'package:siz/Utils/Colors.dart';
import 'dart:convert';

import 'dart:io';

import 'package:siz/Utils/Value.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class MyNotification extends StatefulWidget {
  const MyNotification({super.key});

  @override
  State<MyNotification> createState() => _MyNotificationState();
}

class _MyNotificationState extends State<MyNotification> {


   

  Map<String, dynamic> notificationResponse = {};
  List<dynamic> notificationList = [];
 




  // get notifcations =====================================================================================

  getNotifications() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    dialodShow();
    try {
      final response = await http.post(Uri.parse(SizValue.getnotications), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey),
       
      });

   
     notificationResponse = jsonDecode(response.body);
     

      if (notificationResponse["success"] == true) {
      
        Navigator.pop(context);

        setState(() {
          notificationList=notificationResponse["list"];
        });


     
      } else if (notificationResponse["success"] == false) {

        
     
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(notificationResponse["error"].toString(),style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
    
      }


   
    } on ClientException {

     
      Navigator.pop(context);
      mysnackbar(
          "Server not responding please try again after sometime", context);
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

   dialodShow() {
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
  initState()
  {
    getNotifications();
    super.initState();
  }

  


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
        padding: const EdgeInsets.only(left: 20, right: 20,),

         
           decoration: const BoxDecoration(
             color: Colors.white,
             boxShadow: [BoxShadow(
               color: Color.fromARGB(255, 212, 212, 212),blurRadius: 2,
               offset: Offset(0, 3)
             )]
           ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: ()
              {

                Navigator.pop(context);
              },
              child: SvgPicture.asset("assets/images/backarrow.svg",width: 20,height: 20,)),
            Container(
                margin: const EdgeInsets.only(left: 30),
                child:   Text(
                  "Notifications".toUpperCase(),
                          style:SizValue.toolbarStyle,
                )),

                 const SizedBox(width: 30)
            // Wrap(
            //   alignment: WrapAlignment.center,
            //   crossAxisAlignment: WrapCrossAlignment.center,
            //   direction: Axis.horizontal,
            //   children: [
            //     InkWell(
            //       onTap: () {
            //         Navigator.push(context, MaterialPageRoute(builder: (context)=> Wishlist()));
            //       },
            //       child: SvgPicture.asset("assets/images/heart.svg",width: 20,height: 20,)),
            //     const SizedBox(width: 20),
            //     SvgPicture.asset("assets/images/bag.svg",width: 20,height: 20,),
            //   ],
            // )
          ],
        ),
      ),



      Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: notificationList.length,
          padding: EdgeInsets.zero,
          itemBuilder: (context,index){

            return InkWell(
              onTap: () {
                if(notificationList[index]["type"]==1)
                {
                  if(notificationList[index]["sub_type"].toString()=="approved")
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>MyListing(fromListing: false,initialIndex: 0,)));
                  }

                  else if(notificationList[index]["sub_type"].toString()=="rejected") {

                   Navigator.push(context, MaterialPageRoute(builder: (context)=>MyListing(fromListing: false,initialIndex: 2,)));


                  }
                }

                else if(notificationList[index]["type"]==2){

                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const AllOrderRequest()));

                  
                }
                else if(notificationList[index]["type"]==3){


                  Navigator.push(context, MaterialPageRoute(builder: (context)=>RentDetails(productId: notificationList[index]["link_to"].toString())));


                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
            
                  Row(
            
                    
                    children: [
            
                      
                  Expanded(
                    child: Column(
                      children: [
                  
                         Container(
                           alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(top: index==0?20:0,left: 20,right: 20),
                      child: Text(notificationList[index]["remark"].toString(),
                    
                      textAlign: TextAlign.start,
                      
                      style: GoogleFonts.lexendDeca(
                    
                       fontSize: 15,fontWeight: FontWeight.w300
                      ),),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(left: 20,right: 20,top: 5),
                        
                      child: Text(notificationList[index]["created_at"].toString(),
                      
                         textAlign: TextAlign.start,
                      style: GoogleFonts.lexendDeca(
                    
                       fontSize: 12,fontWeight: FontWeight.w300
                      ),),
                    ),
                  
                      ],
                    ),
                  ),
            
                  Container(
                    margin:  EdgeInsets.only(right: 20,top: index==0?20:0),
                    child: const Icon(Icons.arrow_forward_ios,size: 15,color: Colors.grey,))
                      
                    ],
                  ),
            
                 
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: const Color.fromARGB(255, 226, 226, 226),
                    height: 1,
                    margin: const EdgeInsets.only(top: 20,bottom: 20,left: 20,right: 20),
                  )
                ],
              ),
            );
      
        }),
      )
    ],
      ),
    );
  }
}
