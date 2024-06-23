// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siz/Utils/Colors.dart';
import 'package:siz/Utils/ListingController.dart';
import 'package:siz/Utils/Value.dart';

class AdditionalPhotos extends StatefulWidget {
  const AdditionalPhotos({super.key});

  @override
  State<AdditionalPhotos> createState() => _AdditionalPhotosState();
}

class _AdditionalPhotosState extends State<AdditionalPhotos> {

  
  String additionalOne = "";
  String additionalTwo = "";
  String additionalThree = "";
  String additionalFour = "";
  String additionalFive = "";

  ListingController controller = Get.put(ListingController());

   
   @override
     initState()
   {
   getadditonalValues();
    
    super.initState();
   }


   getadditonalValues() async
   {
     

    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();

    setState(() {

       additionalOne=sharedPreferences.getString(SizValue.additional1).toString();
       additionalTwo=sharedPreferences.getString(SizValue.additional2).toString();
       additionalThree=sharedPreferences.getString(SizValue.additional3).toString();
       additionalFour=sharedPreferences.getString(SizValue.additional4).toString();
       additionalFive=sharedPreferences.getString(SizValue.additional5).toString();
      
    });
   

   }

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
              const EdgeInsets.only(left: 20, right: 20),
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

        // heading
        Container(
            margin: const EdgeInsets.only(top: 30, bottom: 30),
            alignment: Alignment.center,
            child: Text(
              'Add photos of the item when worn',
              style:
                  GoogleFonts.dmSerifDisplay(fontSize: 20,fontWeight: FontWeight.w400, color: Colors.black),
            )),

        // row one ===============

        Container(
          margin: const EdgeInsets.only(left: 15, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // if user selected front emirate id iamge

              additionalOne.isEmpty
                  ?

                  // if user not select emirate front image
                  Flexible(
                      flex: 1,
                      child: InkWell(
                        onTap: () async {
                          // show choose option form gallery or camera

                          // show bottom sheet for select images from camera and gallery

                          await mybottomSheet("add1");

                          setState(() {});
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border: Border.all(
                                  color:
                                      const Color(0xff818181),
                                  width: 1)),
                          margin: const EdgeInsets.all(2.5),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            direction: Axis.vertical,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                               Text("+",style: GoogleFonts.lexendDeca(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 16
                                          ),),
                             
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border: Border.all(
                                  color:
                                      const Color(0xff818181),
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
                                    barrierColor: Colors.black.withOpacity(0.5),
                                    transitionDuration:
                                        const Duration(milliseconds: 100),
                                    pageBuilder: (_, __, ___) {
                                      return Center(
                                          child: Container(
                                              alignment: Alignment.center,
                                              height: 400,
                                              child: Wrap(
                                                children: [
                                                  Image.file(
                                                      File(additionalOne))
                                                ],
                                              )));
                                    },
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  child: SizedBox(
                                    height: 117,
                                    width: MediaQuery.of(context).size.width,
                                    child: Image.file(
                                      File(additionalOne),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    additionalOne = "";
                                    controller.addValue(SizValue.additional1, "");
                                  });
                                },
                                child: Container(
                                    transform:
                                        Matrix4.translationValues(3, -3, 0),
                                    padding: const EdgeInsets.all(5),
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey, blurRadius: 2)
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

              additionalTwo.isEmpty
                  ?

                  // emirate id back
                  Flexible(
                      flex: 1,
                      child: InkWell(
                        onTap: () async {
                          // show bottom sheet for select images from camera and gallery
                          await mybottomSheet("add2");

                          setState(() {});
                        },
                        child: Container(
                          height: 117,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(top: 15, bottom: 15),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border: Border.all(
                                  color:
                                      const Color(0xff818181),
                                  width: 1)),
                          margin: const EdgeInsets.all(2.5),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            direction: Axis.vertical,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                             Text("+",style: GoogleFonts.lexendDeca(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 16
                                          ),),
                            
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border: Border.all(
                                  color:
                              const Color(0xff818181),
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
                                    barrierColor: Colors.black.withOpacity(0.5),
                                    transitionDuration:
                                        const Duration(milliseconds: 100),
                                    pageBuilder: (_, __, ___) {
                                      return Center(
                                          child: Container(
                                              alignment: Alignment.center,
                                              height: 400,
                                              child: Wrap(
                                                children: [
                                                  Image.file(
                                                      File(additionalTwo))
                                                ],
                                              )));
                                    },
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  child: SizedBox(
                                    height: 117,
                                    width: MediaQuery.of(context).size.width,
                                    child: Image.file(
                                      File(additionalTwo),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    additionalTwo = "";
                                     controller.addValue(SizValue.additional2, "");
                                  });
                                },
                                child: Container(
                                    transform:
                                        Matrix4.translationValues(3, -3, 0),
                                    padding: const EdgeInsets.all(5),
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey, blurRadius: 2)
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

        // row two ===============

        Container(
          margin: const EdgeInsets.only(left: 15, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // if user selected front emirate id iamge

              additionalThree.isEmpty
                  ?

                  // if user not select emirate front image
                  Flexible(
                      flex: 1,
                      child: InkWell(
                        onTap: () async {
                          // show choose option form gallery or camera

                          // show bottom sheet for select images from camera and gallery

                          await mybottomSheet("add3");

                          setState(() {});
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border: Border.all(
                                  color:
                                     const Color(0xff818181),
                                  width: 1)),
                          margin: const EdgeInsets.all(2.5),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            direction: Axis.vertical,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                            Text("+",style: GoogleFonts.lexendDeca(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 16
                                          ),),
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border: Border.all(
                                  color:
                                const Color(0xff818181),
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
                                    barrierColor: Colors.black.withOpacity(0.5),
                                    transitionDuration:
                                        const Duration(milliseconds: 100),
                                    pageBuilder: (_, __, ___) {
                                      return Center(
                                          child: Container(
                                              alignment: Alignment.center,
                                              height: 400,
                                              child: Wrap(
                                                children: [
                                                  Image.file(
                                                      File(additionalThree))
                                                ],
                                              )));
                                    },
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  child: SizedBox(
                                    height: 117,
                                    width: MediaQuery.of(context).size.width,
                                    child: Image.file(
                                      File(additionalThree),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    additionalThree = "";
                                     controller.addValue(SizValue.additional3, "");
                                  });
                                },
                                child: Container(
                                    transform:
                                        Matrix4.translationValues(3, -3, 0),
                                    padding: const EdgeInsets.all(5),
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey, blurRadius: 2)
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

              additionalFour.isEmpty
                  ?

                  // emirate id back
                  Flexible(
                      flex: 1,
                      child: InkWell(
                        onTap: () async {
                          // show bottom sheet for select images from camera and gallery
                          await mybottomSheet("add4");

                          setState(() {});
                        },
                        child: Container(
                          height: 117,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(top: 15, bottom: 15),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border: Border.all(
                                  color:
                                   const Color(0xff818181),
                                  width: 1)),
                          margin: const EdgeInsets.all(2.5),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            direction: Axis.vertical,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text("+",style: GoogleFonts.lexendDeca(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 16
                                          ),),
                             
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border: Border.all(
                                  color:
                                   const Color(0xff818181),
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
                                    barrierColor: Colors.black.withOpacity(0.5),
                                    transitionDuration:
                                        const Duration(milliseconds: 100),
                                    pageBuilder: (_, __, ___) {
                                      return Center(
                                          child: Container(
                                              alignment: Alignment.center,
                                              height: 400,
                                              child: Wrap(
                                                children: [
                                                  Image.file(
                                                      File(additionalFour))
                                                ],
                                              )));
                                    },
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  child: SizedBox(
                                    height: 117,
                                    width: MediaQuery.of(context).size.width,
                                    child: Image.file(
                                      File(additionalFour),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    additionalFour = "";
                                     controller.addValue(SizValue.additional4, "");
                                  });
                                },
                                child: Container(
                                    transform:
                                        Matrix4.translationValues(3, -3, 0),
                                    padding: const EdgeInsets.all(5),
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey, blurRadius: 2)
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

        // row three ===============



         Container(
          margin: const EdgeInsets.only(left: 15, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // if user selected front emirate id iamge

              additionalFive.isEmpty
                  ?

                  // if user not select emirate front image
                  Flexible(
                      flex: 1,
                      child: InkWell(
                        onTap: () async {
                          // show choose option form gallery or camera

                          // show bottom sheet for select images from camera and gallery

                          await mybottomSheet("add5");

                          setState(() {});
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border: Border.all(
                                  color:
                                    const Color(0xff818181),
                                  width: 1)),
                          margin: const EdgeInsets.all(2.5),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            direction: Axis.vertical,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text("+",style: GoogleFonts.lexendDeca(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 16
                                          ),),
                             
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border: Border.all(
                                  color:
                                    const Color(0xff818181),
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
                                    barrierColor: Colors.black.withOpacity(0.5),
                                    transitionDuration:
                                        const Duration(milliseconds: 100),
                                    pageBuilder: (_, __, ___) {
                                      return Center(
                                          child: Container(
                                              alignment: Alignment.center,
                                              height: 400,
                                              child: Wrap(
                                                children: [
                                                  Image.file(
                                                      File(additionalFive))
                                                ],
                                              )));
                                    },
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  child: SizedBox(
                                    height: 117,
                                    width: MediaQuery.of(context).size.width,
                                    child: Image.file(
                                      File(additionalFive),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    additionalFive = "";
                                     controller.addValue(SizValue.additional5, "");
                                  });
                                },
                                child: Container(
                                    transform:
                                        Matrix4.translationValues(3, -3, 0),
                                    padding: const EdgeInsets.all(5),
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey, blurRadius: 2)
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

             
                  // emirate id back
                  Flexible(
                      flex: 1,
                      child: InkWell(
                        onTap: () async {
                       
                        },
                        child: Container(
                          height: 117,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(top: 15, bottom: 15),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border: Border.all(
                                  color:
                                     const Color(0xff818181),
                                  width: 1)),
                          margin: const EdgeInsets.all(2.5),
                          child: const Text("Good pictures make a listing better!\n\nMake sure you use the best photos\npossible: photos of yourself,your\nfriends or past renters wearing the\nitem generate the most interest.",style: TextStyle(fontSize: 8, fontWeight: FontWeight.w300,color: Colors.grey),),
                        ),
                      ),
                    )
               
            ],
          ),
        ),

      
      ],
    ));
  }

  mybottomSheet(String stringForpdate) {
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
                        style:  GoogleFonts.lexendDeca(
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
                                if (stringForpdate.toString() == "add1") {
                                  additionalOne = image.path;
                                  controller.addValue(
                                      SizValue.additional1, additionalOne);
                                } else if (stringForpdate.toString() ==
                                    "add2") {
                                  additionalTwo = image.path;
                                  controller.addValue(
                                      SizValue.additional2, additionalTwo);
                                } else if (stringForpdate.toString() ==
                                    "add3") {
                                  additionalThree = image.path;
                                  controller.addValue(
                                      SizValue.additional3, additionalThree);
                                } else if (stringForpdate.toString() ==
                                    "add4") {
                                  additionalFour = image.path;
                                  controller.addValue(
                                      SizValue.additional4, additionalFour);
                                } else if (stringForpdate.toString() ==
                                    "add5") {
                                  additionalFive = image.path;
                                  controller.addValue(
                                      SizValue.additional5, additionalFive);
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
                                if (stringForpdate.toString() == "add1") {
                                  additionalOne = image.path;
                                  controller.addValue(
                                      SizValue.additional1, additionalOne);
                                } else if (stringForpdate.toString() ==
                                    "add2") {
                                  additionalTwo = image.path;
                                  controller.addValue(
                                      SizValue.additional2, additionalTwo);
                                } else if (stringForpdate.toString() ==
                                    "add3") {
                                  additionalThree = image.path;
                                  controller.addValue(
                                      SizValue.additional3, additionalThree);
                                } else if (stringForpdate.toString() ==
                                    "add4") {
                                  additionalFour = image.path;
                                  controller.addValue(
                                      SizValue.additional4, additionalFour);
                                } else if (stringForpdate.toString() ==
                                    "add5") {
                                  additionalFive = image.path;
                                  controller.addValue(
                                      SizValue.additional5, additionalFive);
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
                                style:GoogleFonts.lexendDeca(
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
