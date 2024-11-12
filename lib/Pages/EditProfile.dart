// ignore_for_file: use_build_context_synchronously, unused_catch_clause

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siz/Controllers/ProfileController.dart';
import 'package:siz/Pages/Cart.dart';
import 'package:siz/Pages/Wishlist.dart';
import 'package:siz/Utils/Colors.dart';
import 'package:siz/Utils/Value.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {


  TextEditingController firstnamecontroller = TextEditingController();
  TextEditingController lastnamecontroller = TextEditingController();
  TextEditingController emailnamecontroller = TextEditingController();
  TextEditingController insagramcontroller = TextEditingController();
  TextEditingController biocontroller = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController referralController = TextEditingController();


  bool buttonEnabled = false;

  String profileImage="";
   late profileController controller;

   String referralAmount="";



  @override
  void initState() {

   controller=Get.put(profileController());
    controller.getProfleValue();
    getUserValue();
    super.initState();
  }




  getUserValue() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  

    setState(() {
      if (sharedPreferences.getString(SizValue.firstname).toString() ==
          "null") {
        firstnamecontroller.text = "";
      } else {
        firstnamecontroller.text =
            sharedPreferences.getString(SizValue.firstname).toString();
      }
      if (sharedPreferences.getString(SizValue.lastname).toString() == "null") {
        lastnamecontroller.text = "";
      } else {
        lastnamecontroller.text =
            sharedPreferences.getString(SizValue.lastname).toString();
      }
      if (sharedPreferences.getString(SizValue.email).toString() == "null") {
        emailnamecontroller.text = "";
      } else {
        emailnamecontroller.text =
            sharedPreferences.getString(SizValue.email).toString();
      }
      if (sharedPreferences.getString(SizValue.instagramhandle).toString() ==
          "null") {
        insagramcontroller.text = "";
      } else {
        insagramcontroller.text =
            sharedPreferences.getString(SizValue.instagramhandle).toString();
      }
      if (sharedPreferences.getString(SizValue.bio).toString() == "null") {
        biocontroller.text = "";
      } else {
        biocontroller.text =
            sharedPreferences.getString(SizValue.bio).toString();
      }
      if (sharedPreferences.getString(SizValue.mobile).toString() == "null") {
        contactController.text = "";
      } else {
        contactController.text =
            sharedPreferences.getString(SizValue.mobile).toString();
      }
      if (sharedPreferences.getString(SizValue.username).toString() == "null") {
        userNameController.text = "";
      } else {
        userNameController.text =
            sharedPreferences.getString(SizValue.username).toString();
      }

       if (sharedPreferences.getString(SizValue.referral).toString() == "null") {
        referralController.text = "";
      } else {
        referralController.text =
            sharedPreferences.getString(SizValue.referral).toString();
      }


      referralAmount=sharedPreferences.getString(SizValue.referralAmount).toString();

    });
  }

   // email validation

  validateEmail(String email) {
    final bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);

    return emailValid;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: profileController(),
      builder: (controller) {
        return Scaffold(

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
             
                decoration: const BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(255, 204, 204, 204),
                      blurRadius: 2,
                      offset: Offset(0, 3))
                ]),
                padding:
                    const EdgeInsets.only( left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset("assets/images/backarrow.svg",width: 20,height: 20,)),
                    Container(
                      margin: const EdgeInsets.only(left: 30),
                      child:  Text(
                        "Edit Profile".toUpperCase(),
                          style:SizValue.toolbarStyle
                      ),
                    ),


                       const SizedBox(width: 30)
                    // Wrap(
                    //   alignment: WrapAlignment.center,
                    //   crossAxisAlignment: WrapCrossAlignment.center,
                    //   direction: Axis.horizontal,
                    //   children: [
                    //     InkWell(
                    //         onTap: () {
                    //           Navigator.push(
                    //               context,
                    //               MaterialPageRoute(
                    //                   builder: (context) =>  Wishlist()));
                    //         },
                    //         child: SvgPicture.asset("assets/images/heart.svg",width: 20,height: 20,)),
                    //     const SizedBox(width: 20),
                    //     InkWell(
                    //         onTap: () {
                    //           Navigator.push(
                    //               context,
                    //               MaterialPageRoute(
                    //                   builder: (context) => const Cart()));
                    //         },
                    //         child: SvgPicture.asset("assets/images/bag.svg",width: 20,height: 20,)),
                    //   ],
                    // )
                  ],
                ),
              ),

              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    // profile photo ============================================================================================

                    Container(
                      margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 10, right: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              // show pick image dialog==========================

                              showModalBottomSheet(
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20))),
                                  builder: (context) {
                                    return Container(
                                        height: 220,
                                        padding: const EdgeInsets.only(
                                            top: 10, bottom: 20),
                                        child: Column(
                                          children: [
                                            // text heading
                                            Container(
                                                alignment: Alignment.centerLeft,
                                                margin: const EdgeInsets.only(
                                                  top: 5,
                                                    left: 15, bottom: 15),
                                                child:  Text(
                                                  "Select image from",
                                                  style:  GoogleFonts.lexendDeca(
                              color: MyColors.themecolor,
                              fontWeight: FontWeight.w300,
                              fontSize: 16),
                                                )),

                                            // row
                                            Column(
                                              children: [
                                                // ontap of camera

                                                InkWell(
                                                  onTap: () async{



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
                                                             profileImage =image.path;

                                                             if(firstnamecontroller.text.isEmpty)
                                                             {


                 ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("First name cannot be empty",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));


                                                             }

                                                             else if(lastnamecontroller.text.isEmpty)
                                                             {


                   ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("Last name cannot be empty",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));


                                                             }

                                                             else if(userNameController.text.isEmpty)
                                                             {

                                                                                 ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("User name cannot be empty",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));


                                                             }

                                                             else
                                                             {

                                                              uploadData();

                                                             }


                                                             
                                                              }
                                                            });
                                                    

   



                                                  },
                                                  child: Container(
                                                    margin: const EdgeInsets.only(
                                                        left: 10,
                                                        right: 10,
                                                        bottom: 10),
                                                    padding: const EdgeInsets.only(
                                                        left: 15,
                                                        right: 15,
                                                        top: 15,
                                                        bottom: 15),
                                                    decoration: const BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(7)),
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: Color.fromARGB(
                                                                  255, 209, 209, 209),
                                                              blurRadius: 2,
                                                              offset: Offset(0, 3))
                                                        ]),
                                                    child: Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                            "assets/images/camera.svg"),
                                                        const SizedBox(width: 10),
                                                         Text(
                                                          "Use your Camera",
                                                          style:  GoogleFonts.lexendDeca(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              fontSize: 14),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),

                                                // ontab on gallery
                                                InkWell(
                                                  onTap: ()async {
                                                    
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

                                                            Navigator.pop(context);

                                                            setState(() {
                                                              if (image != null) {
                                                             profileImage =image.path;
                                                             


                                                        if(firstnamecontroller.text.isEmpty)
                                                             {


                 ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("First name cannot be empty",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));


                                                             }

                                                             else if(lastnamecontroller.text.isEmpty)
                                                             {


                   ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("Last name cannot be empty",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));


                                                             }

                                                             else if(userNameController.text.isEmpty)
                                                             {

                                                                                 ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("User name cannot be empty",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));


                                                             }

                                                             else
                                                             {

                                                               uploadData();
                                                              
                                                             }



                                                             
                                                              }
                                                            });
                                                    

   
                                                  },
                                                  child: Container(
                                                    margin: const EdgeInsets.all(10),
                                                    padding: const EdgeInsets.only(
                                                        left: 15,
                                                        right: 15,
                                                        top: 15,
                                                        bottom: 15),
                                                    decoration: const BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(7)),
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: Color.fromARGB(
                                                                  255, 209, 209, 209),
                                                              blurRadius: 2,
                                                              offset: Offset(0, 3))
                                                        ]),
                                                    child: Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                            "assets/images/gallery.svg"),
                                                        const SizedBox(width: 10),
                                                         Text(
                                                          "Pick from Gallery",
                                                          style: GoogleFonts.lexendDeca(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              fontSize: 14),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ));
                                  });
                            },
                            child: Container(
                                width: 85,
                                    height: 85,
                                   
                                    decoration: const BoxDecoration(
                                      
                                        shape: BoxShape.circle),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(1000),
                                child:controller.profileImage.isEmpty? 
                                
                                const SizedBox(
                                  width: 85,
                                  height: 85,
                                )
                                
                                : CachedNetworkImage(
                              
                                  imageUrl:controller.profileImage,
                              
                                  fit: BoxFit.cover,
                                
                                  height: 85,
                                  width: 85,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                              child: Text(
                            "${firstnamecontroller.text} ${lastnamecontroller.text}",
                         
                            

                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: GoogleFonts.lexendDeca(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              fontSize: 18),
                          ))
                        ],
                      ),
                    ),

                    // details ================================================================================================

                    Container(
                      margin: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 10, top: 10),
                      padding: const EdgeInsets.only(
                          top: 20, bottom: 30, left: 10, right: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),

                      // column
                      child: Column(
                        children: [
                          // textfromfield one

                          Container(
                            alignment: Alignment.centerLeft,
                            child:  Text(
                              "Personal Details",
                              style: GoogleFonts.dmSerifDisplay(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              fontSize: 20),
                            ),
                          ),

                          const SizedBox(height: 30),
                          TextFormField(
                            
                            controller: firstnamecontroller,

                            style: GoogleFonts.lexendDeca(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                               fontSize: 14),
                           
                            decoration:  InputDecoration(
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
                            onChanged: (value) {
                              setState(() {
                                buttonEnabled = true;
                              });
                            },
                          ),

                          const SizedBox(height: 15),

                          
                          TextFormField(
                            controller: lastnamecontroller,

                            style: GoogleFonts.lexendDeca(
                              color: Colors.black,
                                fontWeight: FontWeight.w300,
                              fontSize: 14),
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
                            onChanged: (value) {
                              setState(() {
                                buttonEnabled = true;
                              });
                            },
                          ),

                          const SizedBox(height: 15),
                          TextFormField(

                            readOnly: true,
                            controller: emailnamecontroller,
                            style: GoogleFonts.lexendDeca(
                              color: Colors.black,
                                fontWeight: FontWeight.w300,
                              fontSize: 14),
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
                                labelText: "@EMAIL",
                                labelStyle: GoogleFonts.lexendExa(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300),
                              ),
                            onChanged: (value) {
                              setState(() {
                                buttonEnabled = true;
                              });
                            },
                          ),

                          const SizedBox(height: 15),
                             TextFormField(
                             
                            controller: userNameController,

                            style: GoogleFonts.lexendDeca(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              fontSize: 14),

                            decoration:  InputDecoration(
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
                                labelText: "USER NAME",
                                labelStyle: GoogleFonts.lexendExa(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300),
                              ),
                            onChanged: (value) {
                              setState(() {
                                buttonEnabled = true;
                              });
                            },
                          ),

                          const SizedBox(height: 15),

                          TextFormField(
                              readOnly: true,
                            controller: contactController,

                            style: GoogleFonts.lexendDeca(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              fontSize: 14),

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
                                labelText: "CONTACT NUMBER",
                                labelStyle: GoogleFonts.lexendExa(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300),
                              ),
                            onChanged: (value) {
                              setState(() {
                                buttonEnabled = true;
                              });
                            },
                          ),

                          const SizedBox(height: 15),

                          
                          TextFormField(
                            controller: insagramcontroller,
                            style: GoogleFonts.lexendDeca(
                              color: Colors.black,
                                fontWeight: FontWeight.w300,
                              fontSize: 14),
                            decoration:InputDecoration(
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
                                labelText: "INSTAGRAM",
                                labelStyle: GoogleFonts.lexendExa(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300),
                              ),
                            onChanged: (value) {
                              setState(() {
                                buttonEnabled = true;
                              });
                            },
                          ),
                         


                            const SizedBox(height: 15),

                          
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  readOnly: true,
                                  controller: referralController,
                                  style: GoogleFonts.lexendDeca(
                                    color: Colors.black,
                                      fontWeight: FontWeight.w300,
                                    fontSize: 14),
                                  decoration:InputDecoration(
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
                                      labelText: "Referral".toUpperCase(),
                                      labelStyle: GoogleFonts.lexendExa(
                                          color: Colors.grey,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  onChanged: (value) {
                                    setState(() {
                                      buttonEnabled = true;
                                    });
                                  },
                                ),
                              ),

                              InkWell(
                                onTap: () {

 


                                  Share.share("Hey Siz! I got you this $referralAmount% discount code from Sizters Fashion Rental App! 😘🎁\n\nIf you need an outfit to wear, download the app here and rent your dress to impress📲 https://linktr.ee/siztersapp\n\nMake sure you register and enter the code *${referralController.text}* upon signing up and checking out to avail of the discount ❤👗");
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(left: 15),
                                  width: 50,
                                  height: 50,
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromARGB(255, 216, 216, 216)
                                  ),
                              
                                  child: const Icon(Icons.share,color: MyColors.themecolor,),
                                ),
                              )
                            ],
                          ),



                        ],
                      ),
                    ),

                    // bio ==============================================================================================

                    Container(
                      margin: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        bottom: 20,
                      ),
                      padding: const EdgeInsets.only(
                          top: 20, bottom: 30, left: 10, right: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),

                      // column
                      child: Column(
                        children: [
                          // textfromfield one

                          Container(
                            alignment: Alignment.centerLeft,
                            child:  Text(
                              "Bio",
                              style: GoogleFonts.dmSerifDisplay(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              fontSize: 20),
                            ),
                          ),

                          const SizedBox(height: 10),
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10),
                            height: 80,
                          
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                border: Border.all(
                          
                                          color: const Color.fromARGB(255, 211, 211, 211),)),
                            child: TextFormField(
                              controller: biocontroller,

                              style: GoogleFonts.lexendDeca(
                              color: const Color.fromARGB(255, 206, 206, 206),
                               fontWeight: FontWeight.w300,
                              fontSize: 14),
                              maxLength:25,
                              maxLines: 1,
                              onChanged: (value) {
                                setState(() {
                                  buttonEnabled = true;
                                });
                              },
                              decoration:  InputDecoration(
                                  hintStyle: GoogleFonts.lexendDeca(
                              color: const Color.fromARGB(255, 206, 206, 206),
                              fontWeight: FontWeight.w300,
                              fontSize: 14),
                                  border: InputBorder.none,
                                  hintText: "Placeholder text..."),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),



              InkWell(
                              onTap:buttonEnabled? () {

                                if(!validateEmail(emailnamecontroller.text))
                                {

                                   ScaffoldMessenger.of(context).showSnackBar(
                                     SnackBar(
                                        duration: const Duration(seconds: 1),
                                        content: Text(
                                            "Please enter valid email address",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));

                                }

                                
                                                   else     if(firstnamecontroller.text.isEmpty)
                                                             {


                 ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("First name cannot be empty",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));


                                                             }

                                                             else if(lastnamecontroller.text.isEmpty)
                                                             {


                   ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("Last name cannot be empty",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));


                                                             }

                                                             else if(userNameController.text.isEmpty)
                                                             {

                                                                                 ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("User name cannot be empty",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));


                                                             }

                                else{

                                     uploadData();

                                }

                             
                              
                              }:null,
                              child:  Container(
          width: MediaQuery.of(context).size.width,
          height: 40,
          margin: const EdgeInsets.only(left: 20,right: 20,top: 15,bottom: 40),
          alignment: Alignment.center,
          decoration: BoxDecoration(color: buttonEnabled? Colors.black: Colors.grey,
          borderRadius: BorderRadius.circular(5)
          
          ),
          child:  Text("SUBMIT",style: GoogleFonts.lexendExa(fontSize: 16,color: Colors.white,fontWeight: FontWeight.w300),),
            ),
                            )

              // Edit Photo =============================================================================================
            ],
          ),
        );
      }
    );
  }

   

uploadData()
  async {


    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();

    List<dynamic>? documents = [];
    Map<String,dynamic>  decordedResponse={};

    final dio = Dio();
     

     if(profileImage.isNotEmpty)
     {
       
         documents.add(
          await MultipartFile.fromFile(profileImage, filename: profileImage.split("/").last));
    
     }
    

    final formData = FormData.fromMap(
      
      
      {
      'user_key':sharedPreferences.getString(SizValue.userKey),
      'first_name': firstnamecontroller.text,
      'last_name': lastnamecontroller.text,
      'email': emailnamecontroller.text,
      'instagram': insagramcontroller.text,
      'source': 'iOS',
      'username': userNameController.text,
      'profile':profileImage.isEmpty?"": documents,
      'bio':biocontroller.text
      }
    
    );


  dialodShow();

     try {

   


      final response = await dio.post(
        SizValue.editAccount,
        data: formData,
        onSendProgress: (count, total) {
         
        },
      ).timeout(const Duration(hours: 1));

    

      decordedResponse=jsonDecode(response.data);


      print("edit Profile ===   "+ decordedResponse.toString());

    

      if(decordedResponse["success"]==true)
      {
       


       

      
        Navigator.pop(context);
         
         
        
          sharedPreferences.setString(SizValue.firstname, decordedResponse["first_name"].toString());
          sharedPreferences.setString(SizValue.lastname, decordedResponse["last_name"].toString());
          sharedPreferences.setString(SizValue.email, decordedResponse["email"].toString());
          sharedPreferences.setString(SizValue.profile, decordedResponse["profile"].toString());
          sharedPreferences.setString(SizValue.instagramhandle, decordedResponse["instagram"].toString());
          sharedPreferences.setString(SizValue.bio, decordedResponse["bio"].toString());
          sharedPreferences.setString(SizValue.username, decordedResponse["username"].toString());


          getUserValue();

          controller.getProfleValue();
          

         

         setState(() {

            buttonEnabled=false;
           
         });
        

      }

      else if(decordedResponse["success"]==false)

      {
         Navigator.pop(context);
         ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(decordedResponse["error"].toString(),style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
      }

     



     

     
    } on DioException catch (e) {

       Navigator.pop(context);
     
      
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Something went wrong",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white)),
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

}


