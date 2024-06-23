// ignore_for_file: use_build_context_synchronously, unrelated_type_equality_checks, non_constant_identifier_names, deprecated_member_use, must_be_immutable, empty_catches, prefer_const_constructors_in_immutables, avoid_print
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:info_popup/info_popup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siz/Controllers/BottomNavController.dart';
import 'package:siz/Controllers/ProfileController.dart';
import 'package:siz/LoginSignUp/LoginPage.dart';
import 'package:siz/Pages/Home.dart';
import 'package:siz/Utils/Colors.dart';
import 'package:siz/Utils/Value.dart';

import '../Controllers/ChatController.dart';


class AccountCreate extends StatefulWidget {
  

 String? productId="";


  
   AccountCreate({super.key,this.productId });

  @override
  State<AccountCreate> createState() => _AccountCreateState();
}

class _AccountCreateState extends State<AccountCreate> {
 



 
 String emitatesIdValues="";
  String pathEmirateIDFront = "";
  String pathEmirateIDBack = "";
  String emitrateSkipDialogText="";

 

 getEmiratesValues() async
  {

    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();


    setState(() {

          emitatesIdValues=sharedPreferences.getString(SizValue.emirateIDInfo).toString();
          emitrateSkipDialogText=sharedPreferences.getString(SizValue.emirateIDSkip).toString();
      
});




}



@override
     initState()
   {

    getEmiratesValues();

     super.initState();
}

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
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
                        child: SvgPicture.asset("assets/images/backarrow.svg",width: 20,height: 20,)),


            
            
                  Image.asset(
                    "assets/images/appiconpng.png",
                    width: 68,
                    height: 68,
                  ),

                  const SizedBox(height: 20,width: 20,)
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
                    
                      margin: const EdgeInsets.only(top: 20 ,left: 20,right: 20),
                    alignment: Alignment.center,
                    child: Text(
                      "Kindly provide us your Emirates ID pictures for verification purpose",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lexendDeca(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 16),
                    ),
                  ),



                  InfoPopupWidget(
               contentTitle: emitatesIdValues,
                                    contentTheme: InfoPopupContentTheme(
                                    infoTextStyle: GoogleFonts.lexendDeca(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300
                                    )
                                  ),
               child: Container(
                      constraints: const BoxConstraints(
                       
                      ),
                        margin: const EdgeInsets.only(top: 20,left: 20,right:20),
                      alignment: Alignment.center,
                      child: Text(
                        "Why we need this?",
                        textAlign: TextAlign.center,
                      
                        style: GoogleFonts.lexendDeca(
                            color: Colors.blue,
                            fontWeight: FontWeight.w300,
                            decoration: TextDecoration.underline,
                            fontSize: 16),
                      ),
                    ),
),

          


            // IMAGES ====================================================================================================================================

            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // if user selected front emirate id iamge
            
                    pathEmirateIDFront.isEmpty
                        ?
            
                        // if user not select emirate front image
                        Flexible(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                // show choose option form gallery or camera
            
                                // show bottom sheet for select images from camera and gallery
                                showModalBottomSheet(
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20))),
                                    builder: (context) {
                                      return Container(
                                          padding: const EdgeInsets.only(
                                              top: 10, bottom: 30),
                                          child: Wrap(
                                            direction: Axis.vertical,
                                            children: [
                                              // text heading
                                              Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 20,
                                                      top: 10,
                                                      bottom: 25),
                                                  child: const Text(
                                                    "Select image from",
                                                    style: TextStyle(
                                                        color:
                                                            MyColors.themecolor,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        fontSize: 16),
                                                  )),
            
                                              // row
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    // ontap of camera
                                                    InkWell(
                                                      onTap: () async {
                                                        final ImagePicker
                                                            picker =
                                                            ImagePicker();
            
                                                        final XFile? image =
                                                            await picker.pickImage(
                                                                imageQuality:
                                                                    60,
                                                                source:
                                                                    ImageSource
                                                                        .camera);
            
                                                        Navigator.pop(context);
            
                                                        setState(() {
                                                          if (image != null) {
                                                            pathEmirateIDFront =
                                                                image.path;
                                                          }
                                                        });
                                                      },
                                                      child: Wrap(
                                                        direction:
                                                            Axis.vertical,
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/images/camera.svg",
                                                            width: 50,
                                                            height: 50,
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                           Text(
                                                            "Camera",
                                                            style: GoogleFonts.lexendDeca(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontSize: 16),
                                                          )
                                                        ],
                                                      ),
                                                    ),
            
                                                    // ontab on gallery
                                                    InkWell(
                                                      onTap: () async {
                                                        final ImagePicker
                                                            picker =
                                                            ImagePicker();
            
                                                        final XFile? image =
                                                            await picker.pickImage(
                                                                imageQuality:
                                                                    60,
                                                                source:
                                                                    ImageSource
                                                                        .gallery);
            
                                                        setState(() {
                                                          Navigator.pop(
                                                              context);
            
                                                          if (image != null) {
                                                            pathEmirateIDFront =
                                                                image.path;
                                                          }
                                                        });
                                                      },
                                                      child: Wrap(
                                                        direction:
                                                            Axis.vertical,
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/images/gallery.svg",
                                                            width: 50,
                                                            height: 50,
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                           Text(
                                                            "Gallery",
                                                            style: GoogleFonts.lexendDeca(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontSize: 16),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ));
                                    });
                              },
                              child: Container(
                                height: 80,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.only(
                                  top: 15,
                                  bottom: 15,
                                ),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 211, 211, 211),
                                        width: 1)),
                                margin: const EdgeInsets.all(2.5),
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  direction: Axis.vertical,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/images/plus2.svg",
                                      width: 15,
                                      height: 15,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "EMIRATES ID (FRONT)",
                                      style: GoogleFonts.lexendDeca(
                                          fontSize: 12,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w300),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Flexible(
                            flex: 1,
                            child: Container(
                                height: 80,
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 211, 211, 211),
                                        width: 1)),
                                margin: const EdgeInsets.all(2.5),
                                child: Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        showGeneralDialog(
                                          context: context,
                                          barrierLabel: "Barrier",
                                          barrierDismissible: true,
                                          barrierColor:
                                              Colors.black.withOpacity(0.5),
                                          transitionDuration:
                                              const Duration(milliseconds: 100),
                                          pageBuilder: (_, __, ___) {
                                            return Container(
                                                alignment: Alignment.center,
                                                height: 400,
                                                child: Image.file(File(
                                                    pathEmirateIDFront)));
                                          },
                                        );
                                      },
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5)),
                                        child: SizedBox(
                                          height: 80,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Image.file(
                                            File(pathEmirateIDFront),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          pathEmirateIDFront = "";
                                        });
                                      },
                                      child: Container(
                                          transform: Matrix4.translationValues(
                                              3, -3, 0),
                                          padding: const EdgeInsets.all(5),
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey,
                                                    blurRadius: 2)
                                              ],
                                              color: Colors.white),
                                          child: SvgPicture.asset(
                                            "assets/images/close.svg",
                                            height: 15,
                                            width: 15,
                                          )),
                                    ),
                                  ],
                                )),
                          ),
            
                    pathEmirateIDBack.isEmpty
                        ?
            
                        // emirate id back
                        Flexible(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                // show bottom sheet for select images from camera and gallery
                                showModalBottomSheet(
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20))),
                                    builder: (context) {
                                      return Container(
                                          padding: const EdgeInsets.only(
                                              top: 10, bottom: 30),
                                          child: Wrap(
                                            direction: Axis.vertical,
                                            children: [
                                              // text heading
                                              Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 20,
                                                      top: 10,
                                                      bottom: 25),
                                                  child: const Text(
                                                    "Select image from",
                                                    style: TextStyle(
                                                        color:
                                                            MyColors.themecolor,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        fontSize: 16),
                                                  )),
            
                                              // row
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    // ontap of camera
                                                    InkWell(
                                                      onTap: () async {
                                                        final ImagePicker
                                                            picker =
                                                            ImagePicker();
            
                                                        final XFile? image =
                                                            await picker.pickImage(
                                                                imageQuality:
                                                                    60,
                                                                source:
                                                                    ImageSource
                                                                        .camera);
            
                                                        Navigator.pop(context);
            
                                                        setState(() {
                                                          if (image != null) {
                                                            pathEmirateIDBack =
                                                                image.path;
                                                          }
                                                        });
                                                      },
                                                      child: Wrap(
                                                        direction:
                                                            Axis.vertical,
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/images/camera.svg",
                                                            width: 50,
                                                            height: 50,
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                           Text(
                                                            "Camera",
                                                            style: GoogleFonts.lexendDeca(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontSize: 16),
                                                          )
                                                        ],
                                                      ),
                                                    ),
            
                                                    // ontab on gallery
                                                    InkWell(
                                                      onTap: () async {
                                                        final ImagePicker
                                                            picker =
                                                            ImagePicker();
            
                                                        final XFile? image =
                                                            await picker.pickImage(
                                                                imageQuality:
                                                                    60,
                                                                source:
                                                                    ImageSource
                                                                        .gallery);
            
                                                        setState(() {
                                                          Navigator.pop(
                                                              context);
            
                                                          if (image != null) {
                                                            pathEmirateIDBack =
                                                                image.path;
                                                          }
                                                        });
                                                      },
                                                      child: Wrap(
                                                        direction:
                                                            Axis.vertical,
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/images/gallery.svg",
                                                            width: 50,
                                                            height: 50,
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                           Text(
                                                            "Gallery",
                                                            style: GoogleFonts.lexendDeca(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontSize: 16),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ));
                                    });
                              },
                              child: Container(
                                height: 80,
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.only(top: 15, bottom: 15),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 211, 211, 211),
                                        width: 1)),
                                margin: const EdgeInsets.all(2.5),
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  direction: Axis.vertical,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/images/plus2.svg",
                                      width: 15,
                                      height: 15,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "EMIRATES ID (BACK)",
                                      style: GoogleFonts.lexendDeca(
                                          fontSize: 12,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w300),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Flexible(
                            flex: 1,
                            child: Container(
                                height: 80,
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 211, 211, 211),
                                        width: 1)),
                                margin: const EdgeInsets.all(2.5),
                                child: Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        showGeneralDialog(
                                          context: context,
                                          barrierLabel: "Barrier",
                                          barrierDismissible: true,
                                          barrierColor:
                                              Colors.black.withOpacity(0.5),
                                          transitionDuration:
                                              const Duration(milliseconds: 100),
                                          pageBuilder: (_, __, ___) {
                                            return Container(
                                                alignment: Alignment.center,
                                                height: 400,
                                                child: Image.file(File(
                                                    pathEmirateIDBack)));
                                          },
                                        );
                                      },
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5)),
                                        child: SizedBox(
                                          height: 80,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Image.file(
                                            File(pathEmirateIDBack),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          pathEmirateIDBack = "";
                                        });
                                      },
                                      child: Container(
                                          transform: Matrix4.translationValues(
                                              3, -3, 0),
                                          padding: const EdgeInsets.all(5),
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey,
                                                    blurRadius: 2)
                                              ],
                                              color: Colors.white),
                                          child: SvgPicture.asset(
                                            "assets/images/close.svg",
                                            height: 15,
                                            width: 15,
                                          )),
                                    ),
                                  ],
                                )),
                          ),
                  ],
                ),
              ),
            ),

         



          

            InkWell(
              onTap: () {
                if (pathEmirateIDFront.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                    content: Text("Please select front emirate ID",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white)),
                    duration: const Duration(seconds: 1),
                  ));
                }
                
                
                 else if (pathEmirateIDBack.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                    content: Text("Please select back emirate ID",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white)),
                    duration: const Duration(seconds: 1),
                  ));
                } 
               
                
                
                else {


                uploadData(pathEmirateIDFront,pathEmirateIDBack); 

                
                }

               
              },
              child: Container(
                alignment: Alignment.center,
                margin:  const EdgeInsets.only(top: 25,bottom:  60),
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Text(
                  "UPLOAD",
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
                  onTap: ()  async {

                    


                   

                      showEmitateSkipDialog();

                
                    
                  },
                   child: Container(
                                 margin: const EdgeInsets.only(top: 20, bottom: 50),
                                 child: Text("SKIP FOR NOW >",style: GoogleFonts.lexendDeca(
                 
                                   decoration: TextDecoration.underline,
                               
                                   fontSize: 16,color: Colors.grey,fontWeight: FontWeight.w300
                                 ),),
                               ),
 ),
  


          ],
        ),
      ),
    );
  }


  uploadData(String frontImage,String backImage)
  async {
    

     


    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();

    List<dynamic>? documents = [];
    Map<String,dynamic>  decordedResponse={};

    final dio = Dio();
     
    
      documents.add(
          await MultipartFile.fromFile(frontImage, filename: frontImage.split("/").last));

      documents.add(
          await MultipartFile.fromFile(backImage, filename: backImage.split("/").last));    
    

    final formData = FormData.fromMap({
      'user_key':sharedPreferences.getString(SizValue.userKey).toString(),
      'id_proof': documents, 
    });


  dialodShow();

     try {

   


      final response = await dio.post(
        SizValue.uploadIdProof,
        data: formData,
        onSendProgress: (count, total) {
         
        },
      ).timeout(const Duration(hours: 1));

    

      decordedResponse=jsonDecode(response.data);

     print( "Upload ID Response ==== $decordedResponse");


      

      if(decordedResponse["success"]==true)
      {
          Navigator.pop(context);        
          sharedPreferences.setString(SizValue.isLogged, '3');
          sharedPreferences.setString(SizValue.underReview, "0");
          ChatController chatController=Get.put(ChatController());
          chatController.getProfleValue();
          profileController pController=Get.put(profileController());
          pController.getProfleValue();
          Navigator.pop(context);
          

      }

      else

      {
         Navigator.pop(context);
         ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(decordedResponse["error"].toString(),style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
      }

     


     
    } on DioException catch (e) {

       Navigator.pop(context);
     
      
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString(),style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white)),
        duration: const Duration(days: 365),
      ));
    }
  }

    dialodShow() {
      return showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return 
              WillPopScope(
                onWillPop: ()async {

                  return false;
                  
                },
                child: const Center(
                  child: CircularProgressIndicator(
                    color: MyColors.themecolor,
                  ),
                          ),
              );
          });
    }

   

   void showEmitateSkipDialog()
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
                                 emitrateSkipDialogText,
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
                                      onTap: () {

                        

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
    } on http.ClientException {
     
    } on SocketException {
     
    } on HttpException {
     
    } on FormatException {

}
}


}
