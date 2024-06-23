// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:siz/AddItemsPages/AdditionalPhotos.dart';
import 'package:siz/AddItemsPages/TitleDescription.dart';
import 'package:siz/Pages/ExampleGoodImages.dart';
import 'package:siz/Utils/Colors.dart';
import 'package:siz/Utils/ListingController.dart';
import 'package:siz/Utils/Value.dart';

class ImageSelect extends StatefulWidget {
  const ImageSelect({super.key});

  @override
  State<ImageSelect> createState() => _ImageSelectState();
}

class _ImageSelectState extends State<ImageSelect> {
  ListingController controller = Get.put(ListingController());
  
  
  String frontSide = "";
  String backSide = "";
  String tagSide = "";

  // late SharedPreferences sharedPreferences;

  // @override
  // void initState() {
  //   iniTShare();
  //   super.initState();
  // }

  // iniTShare() async
  // {

  //   sharedPreferences= await SharedPreferences.getInstance();

  // }

  @override
  Widget build(BuildContext context) {
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
                  color: Color.fromARGB(255, 228, 228, 228),
                  blurRadius: 2,
                  offset: Offset(0, 2))
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
                Image.asset(
                  "assets/images/appiconpng.png",
                  height: 40,
                  width: 40,
                ),
                const SizedBox(width: 30, height: 0)
              ],
            ),
          ),

          Container(
              margin: const EdgeInsets.only(top: 30 ),
              alignment: Alignment.center,
              child: Text(
                'Add some photos of your item.',
                  style: GoogleFonts.dmSerifDisplay(
                          fontWeight: FontWeight.w400,
                              fontSize: 20, color: Colors.black))),
          Container(
              margin: const EdgeInsets.only(top: 10),
              alignment: Alignment.center,
              child:  Text(
                'You will need two photos to get started.',
                style: GoogleFonts.lexendDeca(fontSize: 14,fontWeight: FontWeight.w300 ,color: Colors.grey),
              )),

          Expanded(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Align(
                  alignment: Alignment.bottomRight,
                  child: InkWell(
                    onTap: () {

                     if(frontSide.isEmpty)
                     {
                      ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("Please select front side image",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white)),duration: const Duration(seconds: 1),));
                     }

                     else if(backSide.isEmpty)
                     {
                      ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("Back side image cannot be empty",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white)),duration: const Duration(seconds: 1),));
                     }
                   

                     else


                     {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TitleDescription()));
  
                     }

                     


                    
                    },
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(
                          right: 15, left: 15, bottom: 30),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Colors.black),
                      child: Text(
                        "NEXT",
                        style: GoogleFonts.lexendExa(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                ),
                Column(

                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin:
                          const EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // if user selected front emirate id iamge

                          frontSide.isEmpty
                              ?

                              // if user not select emirate front image
                              Flexible(
                                  flex: 1,
                                  child: InkWell(
                                    onTap: () async{
                                      // show choose option form gallery or camera

                                      // show bottom sheet for select images from camera and gallery

                                      await mybottomSheet("front");

                                      setState(() {
                                        
                                      });
                                    },
                                    child: Container(
                                      height: 117,
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
                                              color: const Color(0xFF818181),
                                              width: 1)),
                                      margin: const EdgeInsets.all(2.5),
                                      child: Wrap(
                                        alignment: WrapAlignment.center,
                                        direction: Axis.vertical,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          Text("+",style: GoogleFonts.lexendDeca(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 16
                                          ),),
                                          const SizedBox(height: 10),
                                          Text(
                                            "Front side",
                                            style: GoogleFonts.lexendDeca(
                                                fontSize: 16,
                                              
                                                color: Colors.black,
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
                                      height: 117,
                                      alignment: Alignment.center,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5)),
                                          border: Border.all(
                                              color: const Color(0xFFD3D3D3),
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
                                                barrierColor: Colors.black
                                                    .withOpacity(0.5),
                                                transitionDuration:
                                                    const Duration(
                                                        milliseconds: 100),
                                                pageBuilder: (_, __, ___) {
                                                  return Center(
                                                      child: Container(
                                                        width: MediaQuery.of(context).size.width,
                                                          alignment:
                                                              Alignment.center,
                                                          height: 400,
                                                          child: Image.file(File(
                                                              frontSide))));
                                                },
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5)),
                                              child: SizedBox(
                                                height: 117,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Image.file(
                                                  File(frontSide),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                frontSide = "";

                                              });
                                            },
                                            child: Container(
                                                transform:
                                                    Matrix4.translationValues(
                                                        3, -3, 0),
                                                padding:
                                                    const EdgeInsets.all(5),
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

                          backSide.isEmpty
                              ?

                              // emirate id back
                              Flexible(
                                  flex: 1,
                                  child: InkWell(
                                    onTap: ()async {

                                    

                                          await mybottomSheet("back");
                                            setState(() {
                                        
                                      });


                                      
                                      // show bottom sheet for select images from camera and gallery
                                          

                                    
                                    },
                                    child: Container(
                                      height: 117,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.only(
                                          top: 15, bottom: 15),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5)),
                                          border: Border.all(
                                              color: const Color(0xFF818181),
                                              width: 1)),
                                      margin: const EdgeInsets.all(2.5),
                                      child: Wrap(
                                        alignment: WrapAlignment.center,
                                        direction: Axis.vertical,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                            Text("+",style: GoogleFonts.lexendDeca(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 16
                                          ),),
                                          const SizedBox(height: 10),
                                          Text(
                                            "Back Side",
                                            style: GoogleFonts.lexendDeca(
                                                fontSize: 16,
                                              
                                                color: Colors.black,
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
                                      height: 117,
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
                                                barrierColor: Colors.black
                                                    .withOpacity(0.5),
                                                transitionDuration:
                                                    const Duration(
                                                        milliseconds: 100),
                                                pageBuilder: (_, __, ___) {
                                                  return Center(
                                                      child: Container(
                                                        width: MediaQuery.of(context).size.width,
                                                          alignment:
                                                              Alignment.center,
                                                          height: 400,
                                                          child: Image.file(File(
                                                              backSide))));
                                                },
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5)),
                                              child: SizedBox(
                                                height: 117,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Image.file(
                                                  File(backSide),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                backSide = "";
                                              });
                                            },
                                            child: Container(
                                                transform:
                                                    Matrix4.translationValues(
                                                        3, -3, 0),
                                                padding:
                                                    const EdgeInsets.all(5),
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


                  Container(
                      margin:
                          const EdgeInsets.only( left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // if user selected front emirate id iamge

                          tagSide.isEmpty
                              ?

                              // if user not select emirate front image
                              Flexible(
                                  flex: 1,
                                  child: InkWell(
                                    onTap: () async{
                                      // show choose option form gallery or camera

                                      // show bottom sheet for select images from camera and gallery

                                     


                                         await mybottomSheet("tag");

                                          setState(() {
                                        
                                      });


                                      

                                     

                                     
                                    },
                                    child: Container(
                                      height: 117,
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
                                              color: const Color(0xff818181),
                                              width: 1)),
                                      margin: const EdgeInsets.all(2.5),
                                      child: Wrap(
                                        alignment: WrapAlignment.center,
                                        direction: Axis.vertical,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          Text("+",style: GoogleFonts.lexendDeca(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 16
                                          ),),
                                          const SizedBox(height: 10),
                                          Text(
                                            "Tag View",
                                            style: GoogleFonts.lexendDeca(
                                                fontSize: 16,
                                              
                                                color: Colors.black,
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
                                      height: 117,
                                      alignment: Alignment.center,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5)),
                                          border: Border.all(
                                              color: const Color(0xff818181),
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
                                                barrierColor: Colors.black
                                                    .withOpacity(0.5),
                                                transitionDuration:
                                                    const Duration(
                                                        milliseconds: 100),
                                                pageBuilder: (_, __, ___) {
                                                  return Center(
                                                      child: Container(
                                                        width: MediaQuery.of(context).size.width,
                                                          alignment:
                                                              Alignment.center,
                                                          height: 400,
                                                          child: Image.file(File(
                                                              tagSide))));
                                                },
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5)),
                                              child: SizedBox(
                                                height: 117,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Image.file(
                                                  File(tagSide),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                tagSide = "";
                                              });
                                            },
                                            child: Container(
                                                transform:
                                                    Matrix4.translationValues(
                                                        3, -3, 0),
                                                padding:
                                                    const EdgeInsets.all(5),
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


                              // additional 
                              
                              Flexible(
                                  flex: 1,
                                  child: InkWell(
                                    onTap: ()async {


                                       Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AdditionalPhotos()));
                                     
                                    },
                                    child: Container(
                                      height: 117,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.only(
                                          top: 15, bottom: 15),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5)),
                                          border: Border.all(
                                              color: const Color(0xff818181),
                                              width: 1)),
                                      margin: const EdgeInsets.all(2.5),
                                      child: Wrap(
                                        alignment: WrapAlignment.center,
                                        direction: Axis.vertical,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/images/picture.svg",
                                            width: 20,
                                            height: 20,
                                           
                                          ),
                                          const SizedBox(height: 10),
                                        

                                       
                                          Text(
                                            "Additional photos",
                                            style: GoogleFonts.lexendDeca(
                                                fontSize: 16,
                                              
                                                color: Colors.black,
                                                fontWeight: FontWeight.w300),
                                          )

                                          

                                           
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                        ],
                      ),
                    ),


                    Container(
                        margin: const EdgeInsets.only(top: 40, left: 15,bottom: 140),
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () {},
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ExampleGoodImages()));
                            },
                            child:  Text(
                              'Examples of good photos',
                              style: GoogleFonts.lexendDeca(
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14,
                                  color: MyColors.themecolor),
                            ),
                          ),
                        )),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

   mybottomSheet(String stringForpdate){
    return showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (context) {
          return Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 30),
                  child: Wrap(
                    direction: Axis.vertical,
                    children: [
                      // text heading
                      Container(
                          margin:
                              const EdgeInsets.only(left: 20, top: 10, bottom: 25),
                          child:  Text(
                            "Select image from",
                            style: GoogleFonts.lexendDeca(
                                color: MyColors.themecolor,
                                fontWeight: FontWeight.w300,
                                fontSize: 16),
                          )),

                      // row
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // ontap of camera
                            InkWell(
                              onTap: () async {
                                final ImagePicker picker = ImagePicker();

                                final XFile? image = await picker.pickImage(
                                    imageQuality: 60, source: ImageSource.camera);

                                Navigator.pop(context);

                                setState(() {
                                  if (image != null) {
                                    if (stringForpdate.toString() == "front") {
                                      frontSide = image.path;
                                        controller.addValue(SizValue.frontImage, frontSide);
                                    } else if (stringForpdate.toString() ==
                                        "back") {
                                      backSide = image.path;
                                      controller.addValue(SizValue.backImage, backSide);
                                    } else if (stringForpdate.toString() == "tag") {
                                      tagSide = image.path;
                                      controller.addValue(SizValue.tagview, tagSide);
                                    }
                                  }
                                });
                              },
                              child: Wrap(
                                direction: Axis.vertical,
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
                                        fontWeight: FontWeight.w300),
                                  )
                                ],
                              ),
                            ),

                            // ontab on gallery
                            InkWell(
                              onTap: () async {
                                final ImagePicker picker = ImagePicker();

                                final XFile? image = await picker.pickImage(
                                    imageQuality: 60, source: ImageSource.gallery);

                                

                                setState(() {
                                  Navigator.pop(context);

                                  if (image != null) {
                                    if (stringForpdate.toString() == "front") {
                                      frontSide = image.path;
                                      controller.addValue(SizValue.frontImage, frontSide);
                                      
                                    } else if (stringForpdate.toString() ==
                                        "back") {
                                      backSide = image.path;
                                      controller.addValue(SizValue.backImage, backSide);
                                   
                                    } else if (stringForpdate.toString() == "tag") {
                                      tagSide = image.path;
                                      controller.addValue(SizValue.tagview, tagSide);
                                    }
                                  }
                                });
                              },
                              child: Wrap(
                                direction: Axis.vertical,
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
                                        fontWeight: FontWeight.w300),
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
  }
}
