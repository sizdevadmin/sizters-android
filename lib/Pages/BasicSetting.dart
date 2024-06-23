// ignore_for_file: use_build_context_synchronously
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siz/Controllers/BottomNavController.dart';
import 'package:siz/Controllers/ChatController.dart';
import 'package:siz/Controllers/ProfileController.dart';
import 'package:siz/Pages/ContactUs.dart';
import 'package:siz/Pages/Faq.dart';
import 'package:siz/Pages/Home.dart';
import 'package:siz/Pages/ManageBasicAddress.dart';

import 'package:siz/Pages/Notification.dart';
import 'package:siz/Pages/SizePreference.dart';
import 'package:siz/Utils/Colors.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:io';

import 'package:siz/Utils/Value.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart'; 

class BasicSetting extends StatefulWidget {
  const BasicSetting({super.key});

  @override
  State<BasicSetting> createState() => _BasicSettingState();
}

class _BasicSettingState extends State<BasicSetting> {
  // final List<String> items = [
  //   'AED',
  //   'Currency 2',
  //   'Currency 3',
  //   'Currency 4',
  // ];

  String? selectedValue;

  Map<String,dynamic> deleteResponse={};

  

  deleteAccount() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

     dialodShow(context);
    try {
      final response =
          await http.post(Uri.parse(SizValue.accountDelete), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey),
        
      });

      deleteResponse = jsonDecode(response.body);

      if (deleteResponse["success"] == true) {
        

          Navigator.pop(context);
          if(deleteResponse["type"].toString()=="1")
          {
              final BottomNavController controller = Get.put(BottomNavController());
              controller.updateIndex(0);


               SharedPreferences sharedPreferences =
                                    await SharedPreferences.getInstance();
                                sharedPreferences.clear();



                                sharedPreferences.setString(SizValue.isLogged, "null");

                                ChatController chatController=Get.put(ChatController());
                                chatController.forseUpdate();

                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>    const Home()),
                                    (Route<dynamic> route) => false);



          }

          else
          {

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(deleteResponse["error"].toString(),style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));

          }


          

       
      } else if (deleteResponse["success"] == false) {
          Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(deleteResponse["error"].toString(),style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              toolbarHeight: 0,
            ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // top four icons ==============================================================================================

            Container(

              alignment: Alignment.center,
              height: 60,
            
              decoration:
                  const BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    color: Color.fromARGB(255, 230, 230, 230),
                    blurRadius: 1,
                    offset: Offset(0, 2))
              ]),
              padding: const EdgeInsets.only(
                  left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SvgPicture.asset("assets/images/backarrow.svg",width: 20,height: 20,)),
                   Text(
                    "Profile".toUpperCase(),
                            style: SizValue.toolbarStyle
                  ),
                  const SizedBox(
                    width: 30,
                    height: 0,
                  )
                ],
              ),
            ),

            // body page==============================================================================================

            Container(
                margin: const EdgeInsets.only(top: 30, left: 10),
                alignment: Alignment.centerLeft,
                child:  Text(
                  "General",
                  style:  GoogleFonts.lexendDeca(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 17),
                )),

                const SizedBox(height: 15),

            // // first row ================================================================================================

            InkWell(
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const ManageBasicAddress()));
              },
              child: Container(
                margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Wrap(
                      direction: Axis.horizontal,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.center,
                      children: [
                        SizedBox(
                            height: 24,
                            width: 24,
                            child: SvgPicture.asset(
                                "assets/images/location.svg")),
                        const SizedBox(width: 10),
                         Text(
                          "Address",
                          style: GoogleFonts.lexendDeca(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 15),
                        )
                      ],
                    ),
                    SvgPicture.asset("assets/images/arrowright.svg")
                  ],
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 10),
              width: MediaQuery.of(context).size.width,
              height: 1,
              color: const Color(0xffC7C6C6),
            ),
            // second row ================================================================================================

            InkWell(

              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,

              onTap: () {
         Navigator.push(context, MaterialPageRoute(builder: (context)=>const SizePreference()));

              },
              child: Container(
                margin: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Wrap(
                      direction: Axis.horizontal,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.center,
                      children: [
                        SizedBox(
                            height: 24,
                            width: 24,
                            child: Image.asset("assets/images/size.png")),
                        const SizedBox(width: 10),
                         Text(
                          "Size Preference",
                          style: GoogleFonts.lexendDeca(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 15),
                        )
                      ],
                    ),
                    SvgPicture.asset("assets/images/arrowright.svg")
                  ],
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 10),
              width: MediaQuery.of(context).size.width,
              height: 1,
              color: const Color(0xffC7C6C6),
            ),
            // third second ================================================================================================

            InkWell(
                  highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
              onTap: () {
         Navigator.push(context, MaterialPageRoute(builder: (context)=>const MyNotification()));

              },
              child: Container(
                margin: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Wrap(
                      direction: Axis.horizontal,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.center,
                      children: [
                        SizedBox(
                            height: 24,
                            width: 24,
                            child: SvgPicture.asset(
                                "assets/images/notification.svg")),
                        const SizedBox(width: 10),
                         Text(
                          "Notification",
                          style: GoogleFonts.lexendDeca(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 15),
                        )
                      ],
                    ),
                    SvgPicture.asset("assets/images/arrowright.svg")
                  ],
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 10),
              width: MediaQuery.of(context).size.width,
              height: 1,
              color: const Color(0xffC7C6C6),
            ),
            // forth second ================================================================================================

            InkWell(
                highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,

              onTap: () {

                             launchUrl(Uri.parse("https://siz.ae/policies/privacy-policy"));



                // Navigator.push(context, MaterialPageRoute(builder: (context)=>Webview(heading: "Privacy Policy", link: "https://siz.ae/policies/privacy-policy")));
                
              },
              child: Container(
                margin: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Wrap(
                      direction: Axis.horizontal,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.center,
                      children: [
                        SizedBox(
                            height: 24,
                            width: 24,
                            child:
                                SvgPicture.asset("assets/images/privacy.svg")),
                        const SizedBox(width: 10),
                         Text(
                          "Privacy Policy",
                          style:  GoogleFonts.lexendDeca(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 15),
                        )
                      ],
                    ),
                    SvgPicture.asset("assets/images/arrowright.svg")
                  ],
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 10),
              width: MediaQuery.of(context).size.width,
              height: 1,
              color: const Color(0xffC7C6C6),
            ),
            // five second ================================================================================================

            InkWell(
                highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
              onTap: () {

             launchUrl(Uri.parse("https://siz.ae/policies/refund-policy"));

        //  Navigator.push(context, MaterialPageRoute(builder: (context)=>Webview(heading: "Refund Policy", link: "")));

              },
              child: Container(
                margin: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Wrap(
                      direction: Axis.horizontal,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.center,
                      children: [
                        SizedBox(
                            height: 24,
                            width: 24,
                            child:
                                SvgPicture.asset("assets/images/refund.svg")),
                        const SizedBox(width: 10),
                         Text(
                          "Refund Policy",
                          style:  GoogleFonts.lexendDeca(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 15),
                        )
                      ],
                    ),
                    SvgPicture.asset("assets/images/arrowright.svg")
                  ],
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 10),
              width: MediaQuery.of(context).size.width,
              height: 1,
              color: const Color(0xffC7C6C6),
            ),
            // six second ================================================================================================

            InkWell(
                highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
              onTap: () {

                  launchUrl(Uri.parse("https://siz.ae/pages/terms-conditions-lender"));


              },
              child: Container(
                margin: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Wrap(
                      direction: Axis.horizontal,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.center,
                      children: [
                        SizedBox(
                            height: 24,
                            width: 24,
                            child: SvgPicture.asset("assets/images/terms.svg")),
                        const SizedBox(width: 10),
                         Text(
                          "Terms & Conditions - Lender",
                          style:  GoogleFonts.lexendDeca(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 15),
                        )
                      ],
                    ),
                    SvgPicture.asset("assets/images/arrowright.svg")
                  ],
                ),
              ),
            ),

               Container(
              margin: const EdgeInsets.only(top: 12, bottom: 10),
              width: MediaQuery.of(context).size.width,
              height: 1,
              color: const Color(0xffC7C6C6),
            ),
            InkWell(
                highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
              onTap: () {

                  launchUrl(Uri.parse("https://siz.ae/pages/terms-conditions-renter"));


              },
              child: Container(
                margin: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Wrap(
                      direction: Axis.horizontal,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.center,
                      children: [
                        SizedBox(
                            height: 24,
                            width: 24,
                            child: SvgPicture.asset("assets/images/terms.svg")),
                        const SizedBox(width: 10),
                         Text(
                          "Terms & Conditions - Renter",
                          style:  GoogleFonts.lexendDeca(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 15),
                        )
                      ],
                    ),
                    SvgPicture.asset("assets/images/arrowright.svg")
                  ],
                ),
              ),
            ),

           
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 10),
              width: MediaQuery.of(context).size.width,
              height: 1,
              color: const Color(0xffC7C6C6),
            ),

            // Help section =========================================================================================

            Container(
                margin: const EdgeInsets.only(top: 30, left: 10),
                alignment: Alignment.centerLeft,
                child:  Text(
                  "Help",
                  style:  GoogleFonts.lexendDeca(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 17),
                )),

            // first row ================================================================================================

            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const ContactUs()));
              },
              child: Container(
                margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Wrap(
                      direction: Axis.horizontal,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.center,
                      children: [
                        SizedBox(
                            height: 24,
                            width: 24,
                            child: SvgPicture.asset("assets/images/phone.svg")),
                        const SizedBox(width: 10),
                         Text(
                          "Contact Us ",
                          style:  GoogleFonts.lexendDeca(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 15),
                        )
                      ],
                    ),
                    SvgPicture.asset("assets/images/arrowright.svg")
                  ],
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 10),
              width: MediaQuery.of(context).size.width,
              height: 1,
              color: const Color(0xffC7C6C6),
            ),
            // second row ================================================================================================

            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: ((context) => const FAQ())));
              },
              child: Container(
                margin: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Wrap(
                      direction: Axis.horizontal,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.center,
                      children: [
                        SizedBox(
                            height: 24,
                            width: 24,
                            child: SvgPicture.asset("assets/images/faq.svg")),
                        const SizedBox(width: 10),
                         Text(
                          "FAQ",
                          style: GoogleFonts.lexendDeca(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 15),
                        )
                      ],
                    ),
                    SvgPicture.asset("assets/images/arrowright.svg")
                  ],
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 10),
              width: MediaQuery.of(context).size.width,
              height: 1,
              color: const Color(0xffC7C6C6),
            ),

            // Logout delete account button ======================================================================================

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {


                    bottomsheet(context,false);
                    
                  },
                  child: Container(
                
                    alignment: Alignment.center,
                    width: 175,
                    height: 40,
                    
                  
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Colors.black,
                    ),
                    child:  Text(
                      "LOGOUT",
                      textAlign: TextAlign.center,
                         style: GoogleFonts.lexendExa(fontSize: 14,color: Colors.white,fontWeight: FontWeight.w300)
                    ),
                  ),
                ),
              
                InkWell(
                  onTap: ()
                  {
                      bottomsheet(context,true);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 175,
                    height: 40,
                    
                    decoration: const BoxDecoration(
                      color: MyColors.themecolor,
                      borderRadius: BorderRadius.all(Radius.circular(5))
                    ),
                    child:  Text(
                      "DELETE ACCOUNT",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lexendExa(fontSize: 14,color: Colors.white,fontWeight: FontWeight.w300)
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
   


   
bottomsheet(BuildContext context, bool forDeleteAccount) {
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
                    margin: const EdgeInsets.only(top: 0,bottom: 10),
                    width: 35,
                    height: 2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: const Color(0xff9D9D9D)),
                   ),
                         Container(
                          margin: const EdgeInsets.only(left: 10,right:10),
                           child: Text(
                            forDeleteAccount? "Are you sure you really want to delete your account?"  :"Are you sure you want to logout?",
                            textAlign: TextAlign.center,
                            style:  GoogleFonts.lexendDeca(
                              color:Colors.black,
                              fontSize: 15,
                             
                              fontWeight: FontWeight.w300),
                                                 ),
                         ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 40,
                                padding: const EdgeInsets.only(left: 20,right:20),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(5)
                                ),
                                child: Text(
                                  "No",
                                  style: GoogleFonts.lexendDeca(
                                color: Colors.white,
                                fontSize: 16,
                                
                                fontWeight: FontWeight.w300),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            InkWell(
                              onTap:forDeleteAccount?
                              
                              
                              ()

                              {

                                Navigator.pop(context);
                                deleteAccount();

                              }
                              
                              :   () async {

                              Navigator.pop(context);

                                transferredRequest();




                              },
                              child: Container(
                                 alignment: Alignment.center,
                                height: 40,
                                padding: const EdgeInsets.only(left: 20,right:20),
                                decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(5)
                                ),
                                child: Text(
                                  "Yes",
                                  style:  GoogleFonts.lexendDeca(
                                color: Colors.white,
                                fontSize: 16,
                                
                                fontWeight: FontWeight.w300),
                                ),
                              ),
                            )
                          ],
                        ),

                          const SizedBox(height: 10),
                      ],
                    )),
              ]);
            }
          
          
          
          
          );
}



   Map<String, dynamic> deleteAccountResponse = {};


   transferredRequest() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();


    dialodShow(context);
    try {
      final response =
          await http.post(Uri.parse(SizValue.logoutAccount), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey).toString(),
       
      });

 

      deleteAccountResponse = jsonDecode(response.body);

     

      if (deleteAccountResponse["success"] == true) {   

      
       


        Navigator.pop(context);


        
                                SharedPreferences sharedPreferences =
                                    await SharedPreferences.getInstance();
                                sharedPreferences.clear();

                                 final BottomNavController controller = Get.put(BottomNavController());
                                   controller.updateIndex(0);

                                sharedPreferences.setString(SizValue.isLogged, "null");

                                ChatController chatController=Get.put(ChatController());
                                chatController.forseUpdate();

                                profileController pController=Get.put(profileController());
                                pController.update();

                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>  const Home()),
                                    (Route<dynamic> route) => false);




      } else if (deleteAccountResponse["success"] == false) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(deleteAccountResponse["error"].toString(),style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
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




}
