// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:info_popup/info_popup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siz/Pages/ChatInside.dart';
import 'package:siz/Pages/ProfileView.dart';


import 'package:siz/Utils/Value.dart';
import 'package:http/http.dart' as http;


import 'package:siz/Controllers/RentDetailsController.dart';
import 'package:siz/Pages/RefundRequest.dart';
import 'package:siz/Utils/Colors.dart';


// ignore: must_be_immutable
class RentDetails extends StatefulWidget {
  String productId = "";
  RentDetails({super.key, required this.productId});

  @override
  State<RentDetails> createState() => _RentDetailsState();
}

class _RentDetailsState extends State<RentDetails> {
  double myRating = 0.0;
  String myReview = "";
  String myReviewRenter = "";
  double myRatingRenter = 0.0;
  List<dynamic> selectedImage = [];

  submitReview() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    List<dynamic>? documents = [];
    Map<String, dynamic> decordedResponse = {};

    final dio = Dio();

    for (int i = 0; i < selectedImage.length; i++) {
      documents.add(await MultipartFile.fromFile(selectedImage[i].toString(),
          filename: selectedImage[i].toString().split("/").last));
    }

    final formData = FormData.fromMap({
      'user_key': sharedPreferences.getString(SizValue.userKey),
      'id': widget.productId,
      'rating': myRating,
      'comment': myReview,
      'attachment': documents,
    });

    dialodShow();

    try {
      final response = await dio
          .post(
            SizValue.addReview,
            data: formData,
            onSendProgress: (count, total) {},
          )
          .timeout(const Duration(hours: 1));

      decordedResponse = jsonDecode(response.data);

      if (decordedResponse["success"] == true) {
        Navigator.pop(context);

        AwesomeDialog(
          context: context,
          animType: AnimType.scale,
          btnOkColor: Colors.black,
          dialogType: DialogType.success,
          buttonsBorderRadius: BorderRadius.circular(5),
          btnOkText: "OK",
          buttonsTextStyle: GoogleFonts.lexendExa(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.w300),
          body: Container(
            margin: const EdgeInsets.only(top: 10),
            alignment: Alignment.center,
            child: Text(
              'Congratulations! Your review has been successfully added.',
              textAlign: TextAlign.center,
              style: GoogleFonts.lexendDeca(
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                  fontSize: 14),
            ),
          ),
          title: '',
          desc: '',
          btnOkOnPress: () {
            Navigator.pop(context);
          },
        ).show();
      } else {
        Navigator.pop(context);
      
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Something went wrong")));
      }
    } on DioException catch (e) {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        duration: const Duration(days: 365),
      ));
    }
  }
  

  Map<String, dynamic> rentalReviewStatus = {};

    submitLenderReview() async {

        dialodShow();


      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      final response =
        await http.post(Uri.parse(SizValue.addLenderReview), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey),
        'id': widget.productId,
        'rating': myRatingRenter .toString(),
        'comment': myReviewRenter ,
     
      });

      rentalReviewStatus = jsonDecode(response.body);

      

      if (rentalReviewStatus["success"] == true) {

        Navigator.pop(context);

        AwesomeDialog(
          context: context,
          animType: AnimType.scale,
          btnOkColor: Colors.black,
          dialogType: DialogType.success,
          buttonsBorderRadius: BorderRadius.circular(5),
          btnOkText: "OK",
          buttonsTextStyle: GoogleFonts.lexendExa(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.w300),
          body: Container(
            margin: const EdgeInsets.only(top: 10),
            alignment: Alignment.center,
            child: Text(
              'Congratulations! Your review has been successfully added.',
              textAlign: TextAlign.center,
              style: GoogleFonts.lexendDeca(
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                  fontSize: 14),
            ),
          ),
          title: '',
          desc: '',
          btnOkOnPress: () {
            Navigator.pop(context);
          },
        ).show();
        
       
      } else if (rentalReviewStatus["success"] == false) {
          Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(rentalReviewStatus["error"].toString(),style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
      }
    } on http.ClientException {
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

 

  dialodShow() {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
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

  @override
  void initState() {
    RentDetailsController controller = Get.put(RentDetailsController());

    controller.getRentalDetails(context, widget.productId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: RentDetailsController(),
        builder: (controller) {
          return Scaffold(
              appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              toolbarHeight: 0,
            ),
            body: Column(
              children: [
                // top four row ================================================================
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
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: SvgPicture.asset(
                            "assets/images/backarrow.svg",
                            width: 20,
                            height: 20,
                          )),
                      Container(
                          margin: const EdgeInsets.only(),
                          child: Text("Rental Details".toUpperCase(),
                              style: SizValue.toolbarStyle)),
                      const SizedBox(
                        height: 20,
                        width: 20,
                      )
                    ],
                  ),
                ),

                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      // top text

                      Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(
                              left: 15, top: 15, bottom: 10),
                          child: Text(
                            controller.rentalResponse.isEmpty
                                ? ""
                                : "Order Number : #${controller.rentalResponse["order_no"]}",
                            style: GoogleFonts.lexendDeca(
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                                fontSize: 22),
                          )),

                      // main image
                      controller.rentalResponse.isEmpty
                          ? Container(
                              height: 300,
                            )
                          : Container(
                              margin: const EdgeInsets.only(
                                  left: 30, right: 30, top: 10, bottom: 10),
                              child: CachedNetworkImage(
                                imageUrl: controller
                                    .rentalResponse["product_img"]
                                    .toString(),
                                width: MediaQuery.of(context).size.width,
                                height: 300,
                                fit: BoxFit.cover,
                              )),

                      //rental status

                      Container(
                        margin:
                            const EdgeInsets.only(left: 15, top: 10, right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Rental Status : ",
                              style: GoogleFonts.lexendDeca(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 16),
                            ),
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 12, right: 12, top: 5, bottom: 5),
                                decoration: BoxDecoration(
                                  color: controller.rentalResponse["status"] ==
                                          "7"
                                      ? Colors.black
                                      : controller.rentalResponse["status"] ==
                                              "8"
                                          ? Colors.black
                                          : MyColors.themecolor,
                                ),
                                child: Text(
                                  controller.rentalResponse.isEmpty
                                      ? ""
                                      : controller.rentalResponse["status"] ==
                                              "0"
                                          ? "PENDING BY LENDER"
                                          : controller.rentalResponse[
                                                      "status"] ==
                                                  "1"
                                              ? "ACCEPTED BY LENDER"
                                              : controller.rentalResponse[
                                                          "status"] ==
                                                      "2"
                                                  ? "REJECTED BY LENDER"
                                                  : controller.rentalResponse[
                                                              "status"] ==
                                                          "3"
                                                      ? "IN PROGRESS"
                                                      : controller.rentalResponse[
                                                                  "status"] ==
                                                              "4"
                                                          ? "DELIVERED"

                                                           : controller.rentalResponse[
                                                                  "status"] ==
                                                              "5"
                                                          ? "RETURN IN PROGRESS"

                                                           : controller.rentalResponse[
                                                                  "status"] ==
                                                              "6"
                                                          ?"COMPLETED"
                                                          : controller.rentalResponse[
                                                                  "status"] ==
                                                              "7"
                                                          ?"CANCELLED"
                                                          :  "",
                                  style: GoogleFonts.lexendExa(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                      // details

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Flexible(
                            flex: 1,

                            //container 1
                            child: Container(
                              margin:
                                  const EdgeInsets.only(left: 15, right: 15),
                              alignment: Alignment.centerLeft,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      controller.rentalResponse.isEmpty
                                          ? ""
                                          : controller
                                              .rentalResponse["brand_name"]
                                              .toString(),
                                      style: GoogleFonts.dmSerifDisplay(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 22,
                                          color: Colors.black)),
                                  const SizedBox(height: 6),
                                  Text(
                                      controller.rentalResponse.isEmpty
                                          ? ""
                                          : "${controller.rentalResponse["color"]} ${controller.rentalResponse["sub_category"]}",
                                      style: GoogleFonts.lexendDeca(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 12)),
                                  const SizedBox(height: 7),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Rental Fees",
                                        style: GoogleFonts.lexendDeca(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 12),
                                      ),
                                      Text(
                                        controller.rentalResponse.isEmpty
                                            ? ""
                                            : "AED ${controller.rentalResponse["total_amount"]}",
                                        style: GoogleFonts.lexendDeca(
                                            color: MyColors.themecolor,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 7),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Savings",
                                        style: GoogleFonts.lexendDeca(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 12),
                                      ),
                                      Text(
                                        controller.rentalResponse.isEmpty
                                            ? ""
                                            : "AED ${controller.rentalResponse["saving_amt"]}",
                                        style: GoogleFonts.lexendDeca(
                                            color: MyColors.themecolor,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            //container 2

                            child: Container(
                              margin:
                                  const EdgeInsets.only(right: 10, left: 15),
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  Text(
                                    "Rental Period",
                                    style: GoogleFonts.lexendDeca(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 12),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    controller.rentalResponse.isEmpty
                                        ? ""
                                        : controller
                                                .rentalResponse["start_date"] +
                                            " to " +
                                            controller
                                                .rentalResponse["end_date"],
                                    style: GoogleFonts.lexendDeca(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 12),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    controller.rentalResponse.isEmpty
                                        ? ""
                                        : controller.rentalResponse["status"] ==
                                                "4"
                                            ? "Delivered On"
                                            : "Created On",
                                    style: GoogleFonts.lexendDeca(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 12),
                                  ),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  Text(
                                    controller.rentalResponse.isEmpty
                                        ? ""
                                        : controller.rentalResponse["status"] ==
                                                "4"
                                            ? controller
                                                .rentalResponse["delivered_at"]
                                                .toString()
                                            : controller
                                                .rentalResponse["created_at"]
                                                .toString(),
                                    style: GoogleFonts.lexendDeca(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      // grey divider
                      Container(
                        margin: const EdgeInsets.only(top: 20, bottom: 20),
                        width: MediaQuery.of(context).size.width,
                        height: 1,
                        color: const Color.fromARGB(255, 215, 215, 215),
                      ),



                             Visibility(
                         visible: controller.rentalResponse.isEmpty?false: controller.rentalResponse["status"] == "7"?false:true,
                       child: Column(
                        children: [

                             Container(
                          margin: const EdgeInsets.only(left: 15,right:15,bottom: 10),
                          child: Text(
                                      "For order cancellation or any other query related to this order please use below button",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.lexendDeca(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 12),
                                    ),
                        ),


                      InkWell(
                        onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatInside(lenderId:"1",product: "",order: widget.productId)));

                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 40,
                            margin: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 20),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                             "Talk to support".toUpperCase(),
                              style: GoogleFonts.lexendExa(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                      ),
                          
                        ],
                       ),
                     ),

                      Visibility(
               visible: controller.rentalResponse.isEmpty?false: controller.rentalResponse["status"] == "7"?false:     int.parse(controller.rentalResponse["status"].toString())>3?true:false,
                        child: Column(
                          children: [


                            // review

                      Container(
                          margin: const EdgeInsets.only(left: 15),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Product Review",
                            style: GoogleFonts.lexendDeca(
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                                fontSize: 22),
                          )),
                      // rating bar
                      const SizedBox(height: 5),
                      IgnorePointer(
                        ignoring:  controller.rentalResponse["is_product_review"].toString()=="1"?true:false,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10, left: 10),
                          alignment: Alignment.centerLeft,
                          child: RatingBar.builder(
                            itemSize: 30,
                            initialRating: 0,
                            
                            glow: false,
                             minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Color(0xffCAAB05),
                            ),
                            onRatingUpdate: (rating) {
                              setState(() {
                                myRating = rating;
                              });
                            },
                          ),
                        ),
                      ),

// add image button and list

                      Container(
                        margin:
                            const EdgeInsets.only(left: 10, right: 10, top: 10),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Visibility(
                              visible: selectedImage.length > 3 ? false : true,
                              child: InkWell(
                                onTap:
                                
                                 controller.rentalResponse["is_product_review"].toString()=="1"?

                                 null:
                                
                                 () async {
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
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 20,
                                                            top: 10,
                                                            bottom: 25),
                                                    child: Text(
                                                      "Select image from",
                                                      style: GoogleFonts
                                                          .lexendDeca(
                                                              color: MyColors
                                                                  .themecolor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                              fontSize: 15),
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

                                                          Navigator.pop(
                                                              context);

                                                          setState(() {
                                                            if (image != null) {
                                                              selectedImage.add(
                                                                  image.path);
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
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  fontSize: 14),
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
                                                                  source: ImageSource
                                                                      .gallery);

                                                          setState(() {
                                                            Navigator.pop(
                                                                context);

                                                            if (image != null) {
                                                              selectedImage.add(
                                                                  image.path);
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
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  fontSize: 14),
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
                                  alignment: Alignment.center,
                                  height: 120,
                                  width: 90,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: const Text(
                                    "+",
                                    style: TextStyle(
                                        fontSize: 40,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 120,
                                margin: const EdgeInsets.only(left: 10),
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: selectedImage.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                          margin:
                                              const EdgeInsets.only(right: 10),
                                          child: Stack(
                                            alignment: Alignment.topRight,
                                            children: [
                                              InkWell(
                                                  onTap: () {
                                                    // view image dialog  ============================================
                                                    showGeneralDialog(
                                                      context: context,
                                                      barrierLabel: "Barrier",
                                                      barrierDismissible: true,
                                                      barrierColor: Colors.black
                                                          .withOpacity(0.5),
                                                      transitionDuration:
                                                          const Duration(
                                                              milliseconds:
                                                                  100),
                                                      pageBuilder:
                                                          (_, __, ___) {
                                                        return Center(
                                                            child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                height: 400,
                                                                child:
                                                                    Image.file(
                                                                  File(
                                                                    selectedImage[
                                                                        index],
                                                                  ),
                                                                  height: 400,
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                )));
                                                      },
                                                    );
                                                  },
                                                  child: Image.file(
                                                    File(selectedImage[index]
                                                        .toString()),
                                                    height: 120,
                                                    width: 90,
                                                    fit: BoxFit.cover,
                                                  )),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    selectedImage
                                                        .removeAt(index);
                                                  });
                                                },
                                                child: Container(
                                                    margin:
                                                        const EdgeInsets.all(2),
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    decoration:
                                                        const BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: Colors
                                                                      .grey,
                                                                  blurRadius: 2)
                                                            ],
                                                            color:
                                                                Colors.white),
                                                    child: SvgPicture.asset(
                                                      "assets/images/close.svg",
                                                      height: 15,
                                                      width: 15,
                                                    )),
                                              ),
                                            ],
                                          ));
                                    }),
                              ),
                            )
                          ],
                        ),
                      ),

                      // review container and textformfield

                      Container(
                        margin: const EdgeInsets.only( top: 20,left: 10,bottom: 5),
                        alignment: Alignment.centerLeft,

                        child: Text("Leave your feedback about this item",style: GoogleFonts.lexendDeca(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12),),
                      ),

                      Container(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 10),
                        width: MediaQuery.of(context).size.width,
                        height: 150,
                        margin: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        child: TextFormField(
                          readOnly: controller.rentalResponse["is_product_review"].toString()=="1"?true:false,
                          maxLines: 8,
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          style: GoogleFonts.lexendDeca(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              fontSize: 13),
                          onChanged: (value) {
                            setState(() {
                              myReview = value;
                            });
                          },
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                             
                                  ),
                        ),
                      ),

// review submit button

                      InkWell(
                        onTap:
                        
                        controller.rentalResponse["is_product_review"].toString()=="1"?null:
                        
                         () {
                          if (myRating == 0.0) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar( SnackBar(
                              content: Text("Please select rating",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white)),
                              duration: const Duration(seconds: 1),
                            ));
                          } else if (myReview.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                 SnackBar(
                                    content: Text("Please type your review",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white)),
                                    duration: const Duration(seconds: 1)));
                          } else {
                            submitReview();
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          margin: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 20),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: controller.rentalResponse["is_product_review"].toString()=="1"?Colors.grey: Colors.black,
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            controller.rentalResponse.isEmpty?  "": controller.rentalResponse["is_product_review"].toString()=="1"?"Already Reviewed".toUpperCase(): "SUBMIT REVIEW",
                            style: GoogleFonts.lexendExa(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),

                      // grey divider
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        width: MediaQuery.of(context).size.width,
                        height: 1,
                        color: const Color.fromARGB(255, 215, 215, 215),
                      ),

                            
                          ],
                        ),
                      ),
                     

              

                     

                      // renter review======================================

                      Visibility(
                        visible: controller.rentalResponse.isEmpty?false: controller.rentalResponse["status"] == "7"?false:true,
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Wrap(
                                    alignment: WrapAlignment.center,
                                    crossAxisAlignment: WrapCrossAlignment.start,
                                    direction: Axis.vertical,
                                    children: [
                      
                      
                            
                            
                                      Container(
                                      margin: const EdgeInsets.only(left: 15,),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Lender Review",
                                        style: GoogleFonts.lexendDeca(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 22),
                                      )),
                                  // rating bar renter
                                  const SizedBox(height: 5),
                                  IgnorePointer(
                                    ignoring:  controller.rentalResponse["is_lender_review"].toString()=="1"?true:false,
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      alignment: Alignment.centerLeft,
                                      child: RatingBar.builder(
                                        itemSize: 30,
                                        initialRating: 0,
                                         glow: false,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemPadding:
                                            const EdgeInsets.symmetric(horizontal: 4.0),
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: Color(0xffCAAB05),
                                        ),
                                        onRatingUpdate: (rating) {
                                          setState(() {
                                            myRatingRenter = rating;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                            
                                    ],
                                  ),
                            
                            
                                  InkWell(
                                    onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileView(lenderId: controller.rentalResponse["lender_id"].toString())));
                      
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(100),
                                        child: CachedNetworkImage(imageUrl: controller.rentalResponse["user_img"].toString(),width: 55,height: 55,fit: BoxFit.cover,)),
                                    ),
                                  )
                                  
                            
                            
                                  // CachedNetworkImage(imageUrl: imageUrl)
                            
                            
                            
                                ],
                              ),
                            ),

                                       // review container and textformfield

                      Container(
                       padding: const EdgeInsets.only(left: 10,right: 10),
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        margin: const EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        child: TextFormField(

                          readOnly:  controller.rentalResponse["is_lender_review"].toString()=="1"?true:false,
                          maxLines: 1,
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          style: GoogleFonts.lexendDeca(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              fontSize: 13),
                          onChanged: (value) {
                            setState(() {
                              myReviewRenter = value;
                            });
                          },
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintStyle: GoogleFonts.lexendDeca(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12),
                              hintText:
                                  "Leave your feedback about this lender"),
                        ),
                      ),



// review submit button


  InkWell(
    onTap: 
      controller.rentalResponse["is_lender_review"].toString()=="1"?

null
      :
    
    () {

      if(myRatingRenter==0.0)
      {
        ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("Please select rating",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white)),duration: const Duration(seconds: 1),));
      }

      else if(myReviewRenter.isEmpty)
      {

         ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("Please type your review",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white)),duration: const Duration(seconds: 1)));
        
      }

       else{


        submitLenderReview();
      


       }

     
      
    },
    child: Container(
          width: MediaQuery.of(context).size.width,
          height: 40,
          margin: const EdgeInsets.only(left: 10,right: 10,bottom: 20),
          alignment: Alignment.center,
          decoration: BoxDecoration(color:  controller.rentalResponse["is_lender_review"].toString()=="1"?
          Colors.grey:
 Colors.black,
          borderRadius: BorderRadius.circular(5)
          
          ),
          child:  Text( controller.rentalResponse["is_lender_review"].toString()=="1"? "already reviewed".toUpperCase() : "SUBMIT LENDER REVIEW",style: GoogleFonts.lexendExa(fontSize: 16,color: Colors.white,fontWeight: FontWeight.w300),),
    ),
  ),


   

                      // grey divider
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        width: MediaQuery.of(context).size.width,
                        height: 1,
                        color: const Color.fromARGB(255, 215, 215, 215),
                      ),


                          ],
                        ),
                      ),

                      

           



// returm detals and button

                      Visibility(
                        visible: controller.rentalResponse.isEmpty
                            ? false
                            : controller.rentalResponse["status"].toString() ==
                                    "4"
                                ? controller.rentalResponse["is_returned"]
                                            .toString() ==
                                        "0"
                                    ? true
                                    : false
                                : false,
                        child: Column(
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Wrap(
                                    alignment: WrapAlignment.center,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    direction: Axis.horizontal,
                                    children: [
                                      Text(
                                        "Return",
                                        style: GoogleFonts.lexendDeca(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 22),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            bottom: 5, left: 5),
                                        child: const InfoPopupWidget(
                                          contentTitle: 'Info Popup Details',
                                          child: Icon(
                                            Icons.info_outline,
                                            color: Colors.black,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Wrap(
                                    alignment: WrapAlignment.center,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    direction: Axis.horizontal,
                                    children: [
                                      Visibility(
                                        visible:
                                            controller.rentalResponse.isEmpty
                                                ? false
                                                : controller.rentalResponse[
                                                                "is_can_return"]
                                                            .toString() ==
                                                        "0"
                                                    ? false
                                                    : true,
                                        child: Text(
                                          "Return window open only until",
                                          style: GoogleFonts.lexendDeca(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12),
                                        ),
                                      ),
                                      const SizedBox(width: 2),
                                      Visibility(
                                        visible:
                                            controller.rentalResponse.isEmpty
                                                ? false
                                                : controller.rentalResponse[
                                                                "is_can_return"]
                                                            .toString() ==
                                                        "0"
                                                    ? false
                                                    : true,
                                        child: Text(
                                          controller
                                              .rentalResponse["avl_return_time"]
                                              .toString(),
                                          style: GoogleFonts.lexendDeca(
                                              color: MyColors.themecolor,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: controller.rentalResponse.isEmpty
                                  ? null
                                  : controller.rentalResponse["is_can_return"]
                                              .toString() ==
                                          "0"
                                      ? null
                                      : () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      RefundRequest(
                                                          orderId: controller
                                                              .rentalResponse[
                                                                  "order_no"]
                                                              .toString(),
                                                          imageString: controller
                                                              .rentalResponse[
                                                                  "product_img"]
                                                              .toString(),
                                                          productId: controller
                                                              .rentalResponse[
                                                                  "id"]
                                                              .toString())));
                                        },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 40,
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                margin: const EdgeInsets.only(
                                    left: 10, right: 10, top: 15, bottom: 40),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: controller.rentalResponse.isEmpty
                                        ? Colors.grey
                                        : controller.rentalResponse[
                                                        "is_can_return"]
                                                    .toString() ==
                                                "0"
                                            ? Colors.grey
                                            : Colors.black,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text(
                                  controller.rentalResponse.isEmpty
                                      ? ""
                                      : controller.rentalResponse[
                                                      "is_can_return"]
                                                  .toString() ==
                                              "0"
                                          ? "RETURN WINDOW CLOSED ${controller.rentalResponse["avl_return_date"]} ${controller.rentalResponse["avl_return_time"]}"
                                          : "CREATE RETURN REQUEST",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lexendExa(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
