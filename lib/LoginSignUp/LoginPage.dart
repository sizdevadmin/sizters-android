// ignore_for_file: must_be_immutable, use_build_context_synchronously, non_constant_identifier_names, empty_catches

import 'dart:convert';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:device_information/device_information.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siz/Controllers/ChatController.dart';
import 'package:siz/Controllers/ProfileController.dart';
import 'package:siz/LoginSignUp/BasicLoginInfo.dart';
import 'package:siz/LoginSignUp/OtpVerify.dart';
import 'package:siz/Utils/Colors.dart';
import 'package:siz/Utils/Value.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {

 String otpNumber="";


   LoginPage({super.key , required this.otpNumber});



  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  String contrycode="+971";


  TextEditingController otpfieldController=TextEditingController();

     String deviceName="";

  @override
  initState()
  {

   setState(() {
     widget.otpNumber=otpfieldController.text;
   });
    super.initState();
  }

    Map<dynamic, dynamic> verifyResponse = {};
   


   checkFirebaseError(String email,String firstname,String lastname,String googleID) async
   {
     

     try{

        final firebaseMessaging = FirebaseMessaging.instance;
      final FCMToken = await firebaseMessaging.getToken();
      authLogin(email,firstname,lastname,googleID,FCMToken.toString());


     }
     catch(e){

        authLogin(email,firstname,lastname,googleID,"");


     }
    
    

   }



    
  void authLogin(String email,String firstname,String lastname,String googleID,String firebaseToken) async {


     dialodShow();


  

 
   



          
try {
        
     
      String modelName = await DeviceInformation.deviceModel;
      
      setState(() {
        deviceName=modelName;
      });
  
    
      
    } on PlatformException {
    setState(() {
        deviceName="Not Found";
      });
    }


      SharedPreferences sharedPreferences=await SharedPreferences.getInstance();

   

    try {
      final response = await http.post(Uri.parse(SizValue.googleLogin), body: 

// google parameter

           {
         
        
         'email': email,
         'first_name': firstname,
         'last_name': lastname,
         'device': deviceName,
         'google_id': googleID,
         'push_token': firebaseToken,
         'source': 'Android',
       
      }
      
      
      
      );


      
      verifyResponse = jsonDecode(response.body);



  

      if (verifyResponse["success"] == true) {

        Navigator.pop(context);

        print("app login response===== "+verifyResponse.toString());


       if(verifyResponse["account_status"].toString()=="1")
       {


        sharedPreferences.setString(SizValue.firstname, verifyResponse["first_name"].toString());
        sharedPreferences.setString(SizValue.lastname, verifyResponse["last_name"].toString());
        sharedPreferences.setString(SizValue.userKey, verifyResponse["user_key"].toString());
        sharedPreferences.setString(SizValue.email, verifyResponse["email"].toString());
        sharedPreferences.setString(SizValue.isLogged, "1");
        sharedPreferences.setString(SizValue.source, SizValue.authSource);
        sharedPreferences.setString(SizValue.channelId,        verifyResponse["id"].toString());

        
        ChatController chatController=Get.put(ChatController());
        chatController.getProfleValue();
        profileController pController=Get.put(profileController());
        pController.getProfleValue();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BasicLoginInfo(fromWhere:SizValue.authSource)));
       }

       else if(verifyResponse["account_status"].toString()=="2")
       {

        
        sharedPreferences.setString(SizValue.mobile, verifyResponse["mobile_no"].toString());
        sharedPreferences.setString(SizValue.channelId,        verifyResponse["id"].toString());
        sharedPreferences.setString(SizValue.userKey, verifyResponse["user_key"].toString());
        sharedPreferences.setString(SizValue.firstname, verifyResponse["first_name"].toString());
        sharedPreferences.setString(SizValue.lastname, verifyResponse["last_name"].toString());
        sharedPreferences.setString(SizValue.username, verifyResponse["username"].toString());
        sharedPreferences.setString(SizValue.email, verifyResponse["email"].toString());
        sharedPreferences.setString(SizValue.instagramhandle, verifyResponse["instagram"].toString());
        sharedPreferences.setString(SizValue.referral, verifyResponse["referral_code"].toString());
        sharedPreferences.setString(SizValue.bio, verifyResponse["bio"].toString());
        sharedPreferences.setString(SizValue.source, SizValue.authSource);
        sharedPreferences.setString(SizValue.profile, verifyResponse["profile"].toString());
        sharedPreferences.setString(SizValue.isLogged, "2");

        ChatController chatController=Get.put(ChatController());
        chatController.getProfleValue();
        profileController pController=Get.put(profileController());
        pController.getProfleValue();

           Navigator.pop(context);

        //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AccountCreate()));


       }

       else if(verifyResponse["account_status"].toString()=="3")
       {  

        
        sharedPreferences.setString(SizValue.mobile, verifyResponse["mobile_no"].toString());
        sharedPreferences.setString(SizValue.channelId,        verifyResponse["id"].toString());
        sharedPreferences.setString(SizValue.source, SizValue.authSource);
        sharedPreferences.setString(SizValue.underReview,      verifyResponse["id_user_verified"].toString());
        sharedPreferences.setString(SizValue.userKey, verifyResponse["user_key"].toString());
        sharedPreferences.setString(SizValue.firstname, verifyResponse["first_name"].toString());
        sharedPreferences.setString(SizValue.lastname, verifyResponse["last_name"].toString());
        sharedPreferences.setString(SizValue.username, verifyResponse["username"].toString());
        sharedPreferences.setString(SizValue.email, verifyResponse["email"].toString());
        sharedPreferences.setString(SizValue.instagramhandle, verifyResponse["instagram"].toString());
        sharedPreferences.setString(SizValue.referral, verifyResponse["referral_code"].toString());
        sharedPreferences.setString(SizValue.bio, verifyResponse["bio"].toString());
        sharedPreferences.setString(SizValue.profile, verifyResponse["profile"].toString());
        sharedPreferences.setString(SizValue.isLogged, "3");

        ChatController chatController=Get.put(ChatController());
        chatController.getProfleValue();
        profileController pController=Get.put(profileController());
        pController.getProfleValue();


        if( verifyResponse["id_user_verified"].toString()=="1")
        {

          
            chatController.onConnectPressed();
         chatController.getChatListOutside(1, "");
         pController. getaccontDetails(context,"2024");
         

        }


         Navigator.pop(context);


       }

   
        
      } else if (verifyResponse["success"] == false) {
        Navigator.pop(context);
        
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(verifyResponse["error"],style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
      }

      setState(() {});
    } on ClientException {
      Navigator.pop(context);
      Mysnackbar("Server not responding please try again after sometime");
    } on SocketException {
      Navigator.pop(context);
      Mysnackbar("No Internet connection 😑 please try again after sometime");
    } on HttpException {
      Navigator.pop(context);
      Mysnackbar("Something went wrong please try after sometime");
    } on FormatException {
      Navigator.pop(context);
      Mysnackbar("Something went wrong please try after sometime");
    }
  }


  
   


  
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

    // snackbar  =================================================================================================================

  Mysnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        
        content: Text(message,style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
  }



bool emailTab =false;
FocusNode f1 = FocusNode();




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColors.themecolor,
        body: SingleChildScrollView(
          child: Column(
          
            children: [


          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 60,left: 20),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back,color: Colors.white,))),




            Container(
              margin: const EdgeInsets.only(top: 30),
                alignment: Alignment.center,
                child:
                    Image.asset("assets/images/sizicon.png", height: 180)),
             
            Text(
              "WELCOME TO THE SIZTERHOOD",
              style: GoogleFonts.lexendExa(
                fontWeight: FontWeight.w300,
                  fontSize: 12, color: Colors.white),
            ),
            
            const SizedBox(height: 15),
            Text(
              "Sharing the dream\ndesigner closet",
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSerifDisplay(
                fontWeight: FontWeight.w400,
                  fontSize: 35, color: Colors.white),
            ),

            
            
            const SizedBox(height: 60),

              Text(
              "Log in to continue".toUpperCase(),
              style: GoogleFonts.lexendExa(
                fontWeight: FontWeight.w300,
                  fontSize: 12, color: Colors.white),
            ),
       
            // login with Google ===================================================================
            
              InkWell(
                onTap: () async {

               
                   try{

      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: <String>[
            'email',
        ],
    );
    
 
    var googleUser = await googleSignIn.signIn(); 




     // google login

    if(googleUser!=null)
    {

          checkFirebaseError(googleUser.email.toString(), googleUser.displayName.toString().split(" ")[0] ,googleUser.displayName.toString().split(" ")[1],googleUser.id.toString());


    }

   




   

    }
    catch(e)
    {

      Mysnackbar("Something went wrong");

    }

            
                },
                child: Container(
              
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(left: 20,right: 20,top: 10),
                
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                 
                  decoration: BoxDecoration(
                     color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                  ),
              
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
              
                   SvgPicture.asset("assets/images/googleIcon.svg",width: 25,height: 25,),
              
                   const SizedBox(width: 10),
                    Text("Continue with Google",style: GoogleFonts.lexendDeca(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black))
              
                  ],
                ),
              
                ),
              ),

              
              Container(
                margin: const EdgeInsets.only(top: 10),
                alignment: Alignment.center,
                child: Text("OR",style: GoogleFonts.lexendDeca(
                  fontSize: 14,

                  color: Colors.white,
                  fontWeight: FontWeight.w300
                ),),
              ),
               


              !emailTab?

               InkWell(
                onTap: () {

                

                  setState(() {

                    emailTab=true;
                  });

                  f1.requestFocus();
                  
                },
                 child: Container(
                             
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(left: 20,right: 20,top: 10),
                  
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                   
                    decoration: BoxDecoration(
                       color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                    ),
                             
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                             
                     const Icon(Icons.phone,color:MyColors.themecolor,size: 25,),
                             
                     const SizedBox(width: 10),
                      Text("Continue with Phone",style: GoogleFonts.lexendDeca(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black))
                             
                    ],
                  ),
                             
                  ),
               ):


               
                

            // bottom textformfield for mobile number====================================================================
            Container(
              margin:  const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    width: 100,
                   
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.all(Radius.circular(10))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset("assets/images/uaeflag.svg",width: 30,height: 30,),
                        Text("  +971",style: 
                        GoogleFonts.lexendDeca(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: Colors.black)
                        
                        )
                      ],
                    )
                  ),



                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      padding: const EdgeInsets.only(left: 20,right: 20),
                     
                      margin: const EdgeInsets.only(left: 10),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.all(Radius.circular(10))),
                       child: TextFormField(

                      focusNode: f1,


                        

                        controller: otpfieldController,
            
                     
                      
             
                         onTapOutside: (event) {
                           FocusScope.of(context).unfocus();
                         },
                          
            
                      
                        maxLines: 1,
                      
               textAlign: TextAlign.start,
                        
                        keyboardType: TextInputType.number,
                        maxLength: 15,
                        decoration:  InputDecoration(
                         
                            counterText: "",
                            border: InputBorder.none,
                            hintText: "Enter phone number",
                            hintStyle: GoogleFonts.lexendDeca(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: const Color.fromARGB(255, 199, 199, 199))),
                        style: GoogleFonts.lexendDeca(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: Colors.black)
                      ),
                    ),
                  )
                ],
              ),
),  

   
            
            Visibility(
              visible: otpfieldController.text.isEmpty?false:true,
              child: InkWell(
                onTap: () {



                  if(otpfieldController.text.length<7)
                  {
                     Flushbar(
      
                                flushbarStyle: FlushbarStyle.GROUNDED,
                                
                                backgroundColor: Colors.black,
                                messageText: Text("Please enter valid number",
                                
                                style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white)
                                
                                ),
                                
                                duration: const Duration(seconds: 3),
                                
                              ).show(context);
                   }

                   else
                   {

                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> OTPVerify(number: otpfieldController.text, countryCode: contrycode,)));


                   }



                },
                child: Container(
                  margin:
                      const EdgeInsets.only(top: 40, left: 20, right: 20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  child: Text(
                    "NEXT",
                    style: GoogleFonts.lexendDeca(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            color: MyColors.themecolor),
                  ),
                ),
              ),
            ),


                       const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Text(
                          "When you log in, you agree to our ",
                           textAlign: TextAlign.center,
                          style: GoogleFonts.lexendDeca(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: Colors.white),
                        ),
                      ),

                       InkWell(
                    onTap: () {
                       launchUrl(Uri.parse("https://siz.ae/policies/privacy-policy"));
                    },
                    child: Text(
                      "privacy policy",
                      style: GoogleFonts.lexendDeca(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                         
                          color: const Color(0xff5AB3E0)),
                    ),
                  )
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [


                       InkWell(
                        onTap: () {
                             launchUrl(Uri.parse("https://siz.ae/pages/terms-conditions-lender"));
                        },
                         child: Text(
                            "lender's terms of service",
                            
                            style: GoogleFonts.lexendDeca(
                              
                               
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                color: const Color(0xff5AB3E0)),
                                                    ),
                       ),

                                                  Text(
                          " and",
                           textAlign: TextAlign.center,
                          style: GoogleFonts.lexendDeca(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: Colors.white),
                        ),

                                              
                  InkWell(
                    onTap: () {
                       launchUrl(Uri.parse("https://siz.ae/pages/terms-conditions-renter"));
                    },
                    child: Text(
                            " renter's terms of service",
                            
                            style: GoogleFonts.lexendDeca(
                              
                               
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                color: const Color(0xff5AB3E0)),
                                                    ),
                  ),



                    ],
                  ),


            const SizedBox(height: 100)



            ],
          ),
        ));
  }
}
