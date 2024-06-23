// ignore_for_file: use_build_context_synchronously, unrelated_type_equality_checks, non_constant_identifier_names, deprecated_member_use, must_be_immutable, empty_catches, prefer_const_constructors_in_immutables
import 'dart:convert';
import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:device_information/device_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siz/Controllers/BottomNavController.dart';
import 'package:siz/Controllers/ProfileController.dart';
import 'package:siz/LoginSignUp/LoginPage.dart';
import 'package:siz/Pages/Home.dart';
import 'package:siz/Utils/Colors.dart';
import 'package:siz/Utils/Value.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import '../Controllers/ChatController.dart';

class BasicLoginInfo extends StatefulWidget {

  String? productId="";
  String fromWhere = "";

  BasicLoginInfo({super.key, required this.fromWhere ,this.productId });

  @override
  State<BasicLoginInfo> createState() => _BasicLoginInfoState();
}

class _BasicLoginInfoState extends State<BasicLoginInfo> {
  int index = 0;

     String deviceName="";

  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController referralController = TextEditingController();

 late CountdownController controller;
    bool showresent = false;
  

  bool checkBox = false;

  validateEmail(String email) {
    final bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    return emailValid;
  }

  // submit information  =================================================================================================================
 
  Map<dynamic, dynamic> basicInfoList = {};

  void BasicInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    dialodShow();
    try {
      final response = await http.post(Uri.parse(SizValue.completeSignup), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey).toString(),
        'first_name': firstnameController.text,
        'last_name': lastnameController.text,
        'email': emailController.text,
        'instagram': "",
        'source': 'Android',
        'phone': contactController.text,
        'newsletter': checkBox.toString(),
        'referral': referralController.text,
      });

      basicInfoList = jsonDecode(response.body);

      print("basic info api ======  " + basicInfoList.toString());

      if (basicInfoList["success"] == true) {
    

        
       
   

        sharedPreferences.setString(
            SizValue.firstname, basicInfoList["first_name"].toString());
        sharedPreferences.setString(
            SizValue.lastname, basicInfoList["last_name"].toString());
        sharedPreferences.setString(
            SizValue.username, basicInfoList["username"].toString());
        sharedPreferences.setString(
            SizValue.email, basicInfoList["email"].toString());
        sharedPreferences.setString(
            SizValue.instagramhandle, basicInfoList["instagram"].toString());
        sharedPreferences.setString(
            SizValue.referral, basicInfoList["referral_code"].toString());
        sharedPreferences.setString(
            SizValue.bio, basicInfoList["bio"].toString());
        sharedPreferences.setString(
            SizValue.profile, basicInfoList["profile"].toString());
        sharedPreferences.setString(
            SizValue.mobile, basicInfoList["mobile_no"].toString());
        sharedPreferences.setString(
            SizValue.channelId, basicInfoList["id"].toString());
        sharedPreferences.setString(SizValue.isLogged, "2");

        ChatController chatController = Get.put(ChatController());
        chatController.getProfleValue();
        profileController pController = Get.put(profileController());
        pController.getProfleValue();

        if(widget.fromWhere==SizValue.phoneSource)
        {

          Navigator.pop(context);
          Navigator.pop(context);

        }

        else
        {


        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);

        }


       
      } else if (basicInfoList["success"] == false) {


        print("basic info api ======  " + basicInfoList.toString());




        if(widget.fromWhere==SizValue.phoneSource)
        {

      
        Navigator.pop(context);

        }

        else
        {


        Navigator.pop(context);
        Navigator.pop(context);
       

        }
        

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(basicInfoList["error"],
                style: GoogleFonts.lexendDeca(
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                    color: Colors.white))));
      }

      setState(() {});
    } on http.ClientException {
       if(widget.fromWhere==SizValue.phoneSource)
        {

      
        Navigator.pop(context);

        }

        else
        {


        Navigator.pop(context);
        Navigator.pop(context);
       

        }
      Mysnackbar("Server not responding please try again after sometime");
    } on SocketException {
        if(widget.fromWhere==SizValue.phoneSource)
        {

      
        Navigator.pop(context);

        }

        else
        {


        Navigator.pop(context);
        Navigator.pop(context);
       

        }
      Mysnackbar("No Internet connection 😑 please try again after sometime");
    } on HttpException {
  if(widget.fromWhere==SizValue.phoneSource)
        {

      
        Navigator.pop(context);

        }

        else
        {


        Navigator.pop(context);
        Navigator.pop(context);
       

        }
      Mysnackbar("Something went wrong please try after sometime");
    } on FormatException {
     if(widget.fromWhere==SizValue.phoneSource)
        {

      
        Navigator.pop(context);

        }

        else
        {


        Navigator.pop(context);
        Navigator.pop(context);
       

        }
      Mysnackbar("Something went wrong please try after sometime");
    }
  }


  //send otp verify number verification ===================================================================================


 Map<dynamic, dynamic> otpResult = {};

     void verifyNumber() async {
   

      
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
      final response = await http.post(Uri.parse(SizValue.otpcheck), body: {
         'code':"971",
         'phone': contactController.text,
         'device': deviceName,
         'user_key':sharedPreferences.getString(SizValue.userKey).toString()
      });

    
      otpResult = jsonDecode(response.body);

      print("otp send response ===  "+otpResult.toString());

      if (otpResult["success"] == true) {

       
   


             setState(() {
              tabbedOnNext=false;
                     showresent=false;
                   });
              controller = CountdownController(autoStart: true);
              showOtpDialog();



                

                                Flushbar(
                                  backgroundColor: Colors.black,
                                  messageText: Text("OTP sent successfully",
                                  
                                  style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white)
                                  
                                  ),
                                  
                                  duration: const Duration(seconds: 1),
                                  
                                ).show(context);
    
    
       
     
      } else if (otpResult["success"] == false) {

        setState(() {
            tabbedOnNext=false;
        });
       

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(otpResult["error"],style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
      }

     
    } on ClientException {

         setState(() {
            tabbedOnNext=false;
        });
    
  
      Mysnackbar("Server not responding please try again after sometime");
    } on SocketException {

         setState(() {
            tabbedOnNext=false;
        });
      

      Mysnackbar("No Internet connection 😑 please try again after sometime");
    } on HttpException {

         setState(() {
            tabbedOnNext=false;
        });

   
      Mysnackbar("Something went wrong please try after sometime");
    } on FormatException {

         setState(() {
            tabbedOnNext=false;
        });
  

      Mysnackbar("Something went wrong please try after sometime");
    }
  }




     // verify otp  =================================================================================================================
  

 Map<dynamic, dynamic> otpverifyResponse = {};

   
  void verifyOTP(String otp, String token) async {

   

   SharedPreferences sharedPreferences=await SharedPreferences.getInstance();


   
    try {
      final response = await http.post(Uri.parse(SizValue.otpverification), body: {
         'otp': otp,
         'token': token,
         'user_key': sharedPreferences.getString(SizValue.userKey).toString()
       
      });


       

      otpverifyResponse = jsonDecode(response.body);

      print("Verify otp ===  "+otpverifyResponse.toString());

   

      if (otpverifyResponse["success"] == true) {

      
        // Navigator.pop(context);


        BasicInfo();

        

      


        
      } else if (otpverifyResponse["success"] == false) {
        // Navigator.pop(context);


                Flushbar(
                  flushbarStyle: FlushbarStyle.GROUNDED,
                                  backgroundColor: Colors.black,
                                  messageText: Text(otpverifyResponse["error"].toString(),
                                  
                                  style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white)
                                  
                                  ),
                                  
                                  duration: const Duration(seconds: 3),
                                  
                                ).show(context);
                                
        
          }

      setState(() {});
    } on ClientException {
      // Navigator.pop(context);
      Mysnackbar("Server not responding please try again after sometime");
    } on SocketException {
      // Navigator.pop(context);
      Mysnackbar("No Internet connection 😑 please try again after sometime");
    } on HttpException {
      // Navigator.pop(context);
      Mysnackbar("Something went wrong please try after sometime");
    } on FormatException {
      // Navigator.pop(context);
      Mysnackbar("Something went wrong please try after sometime");
    }
  }


    
  void basicInfoDialogSkip()
  {


                    showGeneralDialog(
              
                context: context,
                barrierLabel: "Barrier",
                barrierDismissible:false,
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
                        padding: const EdgeInsets.only(left: 30,right: 20),
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
                             Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                               child: Text(
                                 basicInfoSkipDialogText,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis
                               ,textAlign: TextAlign.center,style: GoogleFonts.lexendDeca(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                             
                                color: Colors.black
                                
                                ),),
                             ),

                             Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [

                                   Flexible(
                                     child: InkWell(
                                      onTap: () async {

                                       
                                      

                                        if(widget.productId.toString()=="null")
                                        {

                                        
                   print("called null function");
                                       
                       BottomNavController controller=Get.put(BottomNavController());
                       controller.updateIndex(0);
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const Home()), (route) => false);


                                        }

                                        else
                                        {

                                           print("function");
                                         addWishlist();

                                           BottomNavController controller=Get.put(BottomNavController());
                                            controller.updateIndex(0);
                                             Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const Home()), (route) => false);


                                        }



                  
                                        
                                      },
                                       child: Container(
                                        
                                                                       width: MediaQuery.of(context).size.width,
                                                                       alignment: Alignment.center,
                                                                       margin: const EdgeInsets.only(top: 20,right: 10),
                                                                       height: 40,
                                                                       decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(5)
                                                                       ),
                                                                       child:  Text(
                                        "GO TO HOME",
                                                                       textAlign: TextAlign.center,
                                                                      style: GoogleFonts.lexendExa(
                                             
                                             fontSize: 16,color: Colors.white,fontWeight: FontWeight.w300)),
                                                                     ),
                                     ),
                                   ),

                                   Flexible(
                                     child: InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                       child: Container(
                                                                       width: MediaQuery.of(context).size.width,
                                                                       alignment: Alignment.center,
                                                                       margin: const EdgeInsets.only(top: 20,left:10),
                                                                       height: 40,
                                                                       decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(5)
                                                                       ),
                                                                       child:  Text(
                                        "proceed".toUpperCase(),
                                                                       textAlign: TextAlign.center,
                                                                      style: GoogleFonts.lexendExa(
                                             
                                             fontSize: 16,color: Colors.white,fontWeight: FontWeight.w300)),
                                                                     ),
                                     ),
                                   ),

                              ],
                             )
                  
                             
                              
                          ],
                        )),
                      ),
                    ),
                  );
                },
              );






  }


  // snackbar  =================================================================================================================

  Mysnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message,
            style: GoogleFonts.lexendDeca(
                fontSize: 13,
                fontWeight: FontWeight.w300,
                color: Colors.white))));
  }

  dialodShow() {
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

  @override
  void initState() {
    //  getvalue();
    getEmiratesValues();
    super.initState();
  }

  //  getvalue() async
  //  {

  //   SharedPreferences sharedPreferences=await SharedPreferences.getInstance();

  //   if(widget.fromWhere==SizValue.authSource)
  //   {

  //      firstnameController.text=sharedPreferences.getString(SizValue.firstname).toString();
  //      lastnameController.text=sharedPreferences.getString(SizValue.lastname).toString();
  //      emailController.text=sharedPreferences.getString(SizValue.email).toString();

  //       setState(() {

  //       });

  //   }

  //   else if(widget.fromWhere==SizValue.phoneSource)
  //   {

  //      contactController.text=sharedPreferences.getString(SizValue.mobile).toString();

  //       setState(() {});
  //   }

  //  }


  String basicInfoSkipDialogText = "";



  getEmiratesValues() async
  {



    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();


    setState(() {

          basicInfoSkipDialogText=sharedPreferences.getString(SizValue.basicdialogInfo).toString();
        
      
    });




  }


  showOtpDialog()
  {


    TextEditingController otpfieldController = TextEditingController();

    return showDialog(context: context,
    

     builder: (context)


    {

    

      return StatefulBuilder(

        builder: (BuildContext context, void Function(void Function()) setState) { 

          return Center(
          child: Container(
            
            width: MediaQuery.of(context).size.width,
            height: 220,
           
        
           margin: const EdgeInsets.only(left: 20,right: 20,bottom: 100),
        
            decoration: const BoxDecoration(
        
               color: Colors.white,
               borderRadius: BorderRadius.all(Radius.circular(10))
              
            ),
            
        
            child: Scaffold(
              backgroundColor: Colors.transparent,
      
              resizeToAvoidBottomInset: false,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
              
                children: [
      
                  
      
                  Text("One Time Password has been sent to +971-${contactController.text}",
                  textAlign: TextAlign.center,
                  
                     style: GoogleFonts.lexendDeca(fontSize: 16, color: Colors.black,fontWeight: FontWeight.w300),
                  
                  
                  ),
      
                  const SizedBox(height: 15),
      
      
                       Container(
                        alignment: Alignment.center,
                      width: 160,
                      child: PinCodeTextField(
                        appContext: context,
                        length: 4,
                        obscureText: false,
                        animationType: AnimationType.fade,
                        keyboardType: TextInputType.number,
                        controller: otpfieldController,
                        autoFocus: true,
                        
                        textStyle: GoogleFonts.lexendDeca(fontSize: 16,color: Colors.black,  fontWeight: FontWeight.w300),
                        pinTheme: PinTheme(
                          
                          selectedFillColor: MyColors.themecolor,
                          selectedColor: MyColors.themecolor,
                          activeColor: MyColors.themecolor,
                          inactiveColor: const Color.fromARGB(255, 199, 199, 199),
                          inactiveFillColor: const Color.fromARGB(255, 240, 240, 240),
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: 50,
                          fieldWidth: 30,
                          activeFillColor: Colors.white,
                        ),
                        animationDuration: const Duration(milliseconds: 300),
                
                        enableActiveFill: true,
                
                        // controller: textEditingController,
                        onCompleted: (v) {
                       

                    
                         print("token id ====  "+otpResult["token"].toString());
                         verifyOTP(v.toString(),otpResult["token"].toString());  
                  
                         
                    
                        },
                       
                        beforeTextPaste: (text) {
                          return true;
                        },
                      ),
                    ),
      
      
                      Container(
                        width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                       Text("Didn't receive OTP?",style: GoogleFonts.lexendDeca(fontSize: 16,color: Colors.black,  fontWeight: FontWeight.w300),),
                      Visibility(
                          visible: showresent ? false : true,
                          child:  Text(" wait for" , style: GoogleFonts.lexendDeca(fontSize: 16,color: Colors.black,  fontWeight: FontWeight.w300),)),
                      Visibility(
                          visible: showresent ? true : false,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                showresent = false;
                                controller.start();
                                // sendotp();
            
                                
                              });
                            },
                            child:  Text(
                              " RESEND OTP",
                              style: GoogleFonts.lexendDeca(fontSize: 16,color: MyColors.themecolor,  fontWeight: FontWeight.w400)
                            ),
                          )),
                      const SizedBox(
                        width: 2,
                      ),
                      Visibility(
                        visible: showresent ? false : true,
                        child: Countdown(
                          controller: controller,
                          seconds: 30,
                          build: (BuildContext context, double time) => Text(
                            "${time.toString().replaceAll(".0", "")} seconds",
                            style: GoogleFonts.lexendDeca(fontSize: 16,color: MyColors.themecolor,  fontWeight: FontWeight.w300),
                          ),
                          interval: const Duration(seconds: 1),
                          onFinished: () {
                            setState(() {
                              showresent = true;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
      
                    const SizedBox(height: 10),
      
                ],
              ),
            ),
          ),
        );


         },
       
      );
    });

  }


  bool tabbedOnNext=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 30, right: 30),
          child: Column(
            children: [
              // top icon ============================================
              Container(
                margin: const EdgeInsets.only(top: 80),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset(
                          "assets/images/backarrow.svg",
                          width: 20,
                          height: 20,
                        )),
                    Image.asset(
                      "assets/images/appiconpng.png",
                      width: 68,
                      height: 68,
                    ),
                    const SizedBox(
                      height: 20,
                      width: 20,
                    )
                  ],
                ),
              ),

              // heading text ============================================

              Container(
                margin: const EdgeInsets.only(top: 30),
                alignment: Alignment.center,
                child: Text(
                  "Hello",
                  style: GoogleFonts.dmSerifDisplay(
                      color: MyColors.themecolor,
                      fontWeight: FontWeight.w400,
                      fontSize: 28),
                ),
              ),

              //sub  heading text ============================================
              Container(
                margin: const EdgeInsets.only(top: 15),
                alignment: Alignment.center,
                child: Text(
                  "Looks like you're new here!",
                  style: GoogleFonts.lexendDeca(
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                      fontSize: 16),
                ),
              ),

              //sub  heading text ============================================
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 30),
                alignment: Alignment.center,
                child: Text(
                  "Please provide some basic details",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lexendDeca(
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                      fontSize: 16),
                ),
              ),

              // textformfield first name last name row ========================================================================================

              Visibility(
                visible:
                    widget.fromWhere == SizValue.phoneSource ? true : false,
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Container(
                          height: 54,
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.only(right: 7, top: 17.5),
                          child: Theme(
                            data: Theme.of(context)
                                .copyWith(splashColor: Colors.transparent),
                            child: TextFormField(
                              controller: firstnameController,
                              onTapOutside: (event) {
                                FocusScope.of(context).unfocus();
                              },
                              style: GoogleFonts.lexendDeca(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300),
                              decoration: InputDecoration(
                                hintText: "",
                                hintStyle: GoogleFonts.lexendDeca(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w300),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 211, 211, 211),
                                      width: 1),
                                  borderRadius: BorderRadius.circular(5.5),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 211, 211, 211),
                                      width: 1),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                labelText: "FIRST NAME",
                                labelStyle: GoogleFonts.lexendExa(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          height: 54,
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.only(left: 7, top: 17.5),
                          child: Theme(
                            data: Theme.of(context)
                                .copyWith(splashColor: Colors.transparent),
                            child: TextFormField(
                              controller: lastnameController,
                              onTapOutside: (event) {
                                FocusScope.of(context).unfocus();
                              },
                              style: GoogleFonts.lexendDeca(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300),
                              decoration: InputDecoration(
                                hintText: "",
                                hintStyle: GoogleFonts.lexendDeca(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w300),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 211, 211, 211),
                                      width: 1),
                                  borderRadius: BorderRadius.circular(5.5),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 211, 211, 211),
                                      width: 1),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                labelText: "LAST NAME",
                                labelStyle: GoogleFonts.lexendExa(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // email textformfield ============================================================================================================

              Visibility(
                visible: widget.fromWhere==SizValue.phoneSource,
                child: Container(
                  height: 54,
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(top: 17.5),
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(splashColor: Colors.transparent),
                    child: TextFormField(
              
                       controller: emailController,
              
                   
              
                      onTapOutside: (event) {
                        FocusScope.of(context).unfocus();
                      },
              
                      style: GoogleFonts.lexendDeca(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w300),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "",
                        hintStyle: GoogleFonts.lexendDeca(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w300),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 211, 211, 211),
                              width: 1),
                          borderRadius: BorderRadius.circular(5.5),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 211, 211, 211),
                              width: 1),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "EMAIL ADDRESS",
                        labelStyle: GoogleFonts.lexendExa(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                ),
              ),

              Visibility(
                visible: widget.fromWhere==SizValue.authSource,
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      margin: const EdgeInsets.only(top: 15),
                      height: 54,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: const Color.fromARGB(255, 211, 211, 211),
                          ),
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        "+971",
                        style: GoogleFonts.lexendExa(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 54,
                        margin: const EdgeInsets.only(top: 15, left: 15),
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(splashColor: Colors.transparent),
                          child: TextFormField(
                            controller: contactController,
                            onTapOutside: (event) {
                              FocusScope.of(context).unfocus();
                            },
                            style: GoogleFonts.lexendDeca(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w300),
                            maxLength: 10,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              counterText: "",
                              hintText: "",
                              hintStyle: GoogleFonts.lexendDeca(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w300),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 211, 211, 211),
                                    width: 1),
                                borderRadius: BorderRadius.circular(5.5),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 211, 211, 211),
                                    width: 1),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              labelText: "Contact Number".toUpperCase(),
                              labelStyle: GoogleFonts.lexendExa(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // // instagram handle textformfield ============================================================================================================

              // Container(
              //   height: 54,
              //   width: MediaQuery.of(context).size.width,
              //   margin: const EdgeInsets.only(top: 17.5),
              //   child: Theme(
              //     data: Theme.of(context)
              //         .copyWith(splashColor: Colors.transparent),
              //     child: TextFormField(

              //       controller: instagramController,
              //       onTapOutside: (event) {
              //         FocusScope.of(context).unfocus();
              //       },

              //       style: GoogleFonts.lexendDeca(
              //           fontSize: 14,
              //           color: Colors.black,
              //           fontWeight: FontWeight.w300),
              //       keyboardType: TextInputType.emailAddress,
              //       decoration: InputDecoration(
              //         hintText: "",
              //         hintStyle: GoogleFonts.lexendDeca(
              //             fontSize: 12,
              //             color: Colors.grey,
              //             fontWeight: FontWeight.w300),
              //         focusedBorder: OutlineInputBorder(
              //           borderSide: const BorderSide(
              //               color: Color.fromARGB(255, 211, 211, 211),
              //               width: 1),
              //           borderRadius: BorderRadius.circular(5.5),
              //         ),
              //         enabledBorder: const OutlineInputBorder(
              //           borderSide: BorderSide(
              //               color: Color.fromARGB(255, 211, 211, 211),
              //               width: 1),
              //         ),
              //         filled: true,
              //         fillColor: Colors.white,
              //         labelText: "INSTAGRAM HANDLE (OPTIONAL)",
              //         labelStyle: GoogleFonts.lexendExa(
              //             color: Colors.grey,
              //             fontSize: 12,
              //             fontWeight: FontWeight.w300),
              //       ),
              //     ),
              //   ),
              // ),

              // REFERRAL CODE textformfield ============================================================================================================

              Container(
                height: 54,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(top: 15),
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(splashColor: Colors.transparent),
                  child: TextFormField(
                    controller: referralController,
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                    style: GoogleFonts.lexendDeca(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w300),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "",
                      hintStyle: GoogleFonts.lexendDeca(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w300),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 211, 211, 211),
                            width: 1),
                        borderRadius: BorderRadius.circular(5.5),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 211, 211, 211),
                            width: 1),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "REFERRAL CODE ( OPTIONAL )",
                      labelStyle: GoogleFonts.lexendExa(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                ),
              ),

              // check box bottom ==========================================================================

              Container(
                margin: const EdgeInsets.only(left: 5, top: 10),
                child: Row(
                  children: [
                    SizedBox(
                      width: 15,
                      height: 20,
                      child: Checkbox(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3)),
                          value: checkBox,
                          onChanged: (value) {
                            setState(() {
                              checkBox = value!;
                            });
                          }),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 15, top: 15),
                        child: Text(
                          "I want to be the first to know the latest promotions and new releases",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: GoogleFonts.lexendDeca(
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                              color: Colors.black),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 25),

              InkWell(
                onTap:
                
              tabbedOnNext?null:

                 () {


              
                 
                  if (widget.fromWhere == SizValue.phoneSource) {
                    if (firstnameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Firstname cannot be empty",
                            style: GoogleFonts.lexendDeca(
                                fontSize: 13,
                                fontWeight: FontWeight.w300,
                                color: Colors.white)),
                        duration: const Duration(seconds: 1),
                      ));
                    } else if (lastnameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Lastname cannot be empty",
                            style: GoogleFonts.lexendDeca(
                                fontSize: 13,
                                fontWeight: FontWeight.w300,
                                color: Colors.white)),
                        duration: const Duration(seconds: 1),
                      ));
                    } else if (emailController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Please enter email",
                            style: GoogleFonts.lexendDeca(
                                fontSize: 13,
                                fontWeight: FontWeight.w300,
                                color: Colors.white)),
                        duration: const Duration(seconds: 1),
                      ));
                    }

                    else    if(!validateEmail(emailController.text))
                    {

                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Please enter valid email",
                            style: GoogleFonts.lexendDeca(
                                fontSize: 13,
                                fontWeight: FontWeight.w300,
                                color: Colors.white)),
                        duration: const Duration(seconds: 1),
                      ));

                    }
                    // call verify number api


                 

                    else
                    { 

                      BasicInfo();

                    }

                   
                

                    //  BasicInfo();
                  
                  } else if(widget.fromWhere==SizValue.authSource)
                  {

                     if (contactController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Please enter contact number",
                          style: GoogleFonts.lexendDeca(
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                              color: Colors.white)),
                      duration: const Duration(seconds: 1),
                    ));
                  } 
                   else   if(contactController.text.length<7)
                    {

                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Please enter valid number",
                            style: GoogleFonts.lexendDeca(
                                fontSize: 13,
                                fontWeight: FontWeight.w300,
                                color: Colors.white)),
                        duration: const Duration(seconds: 1),
                      ));

                    }
                  
                  else {
                    // call api


                    setState(() {
                      tabbedOnNext=true;
                    });

                   verifyNumber();

                    //  BasicInfo();
                    
                  }

                  }
                },
                child: Container(
                  height: 40,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: 
                  
                   tabbedOnNext?
                  
                   const SizedBox(
                    width: 20,
                    height: 20,
                    child:
                    
                   
                     CircularProgressIndicator(
                      color: Colors.white,
                      
                    ),
                  ):
                  
                   Text(
                    "NEXT",
                    style: GoogleFonts.lexendExa(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w300),
                  ),
                ),
              ),

              const SizedBox(height: 60),

              InkWell(
                onTap: () async {
                  SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();

                  sharedPreferences.setString(SizValue.underReview, "null");
                  sharedPreferences.setString(SizValue.isLogged, "null");

                  ChatController chatController = Get.put(ChatController());
                  chatController.getProfleValue();
                  profileController pController = Get.put(profileController());
                  pController.getProfleValue();

                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginPage(otpNumber: "")));
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    "Use another account ?".toUpperCase(),
                    style: GoogleFonts.lexendDeca(
                        decoration: TextDecoration.underline,
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w300),
                  ),
                ),
              ),

              InkWell(
                onTap: () async {

                 
                 basicInfoDialogSkip();


                },
                child: Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 50),
                  child: Text(
                    "SKIP FOR NOW >",
                    style: GoogleFonts.lexendDeca(
                        decoration: TextDecoration.underline,
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w300),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // add to wishlist =====================================================================================



    

     // add wishlist ==============================================================================================

  Map<String, dynamic> wishlistaddReponse = {};

   addWishlist() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

 
    try {
      final response = await http.post(Uri.parse(SizValue.addWishlist), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey).toString(),
        'product': widget.productId,
      });

      wishlistaddReponse = jsonDecode(response.body);

        if (wishlistaddReponse["success"] == true) {

          
      } else if (wishlistaddReponse["success"] == false) {
      
      }
    } on ClientException {
     
    } on SocketException {
     
    } on HttpException {
     
    } on FormatException {
     
  }
}








}