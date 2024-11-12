// ignore_for_file: must_be_immutable, use_build_context_synchronously, avoid_print, deprecated_member_use, file_names

import 'dart:convert';

import 'package:accordion/accordion.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:info_popup/info_popup.dart';
import 'package:share_plus/share_plus.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:siz/Controllers/BottomNavController.dart';
import 'package:siz/Controllers/FilterController.dart';
import 'package:siz/LoginSignUp/AccuntCreate.dart';
import 'package:siz/LoginSignUp/BasicLoginInfo.dart';
import 'package:siz/LoginSignUp/LoginPage.dart';
import 'package:siz/Pages/Cart.dart';
import 'package:siz/Pages/ChatInside.dart';
import 'package:siz/Pages/DateSelector.dart';
import 'package:siz/Pages/Home.dart';
import 'package:siz/Pages/MyProfile.dart';
import 'package:siz/Pages/ProductImageView.dart';
import 'package:siz/Pages/ProfileView.dart';
import 'package:siz/Pages/Wishlist.dart';
import 'package:siz/Utils/Colors.dart';

import 'package:siz/Utils/ProductMultiImageCode.dart';

import 'package:siz/Utils/Value.dart';

class ProductView extends StatefulWidget {
  String id = "";
  int index = 0;
  bool fromCart = false;
  String comesFrom = "";

  ProductView(
      {super.key,
      required this.index,
      required this.id,
      required this.fromCart,
      required this.comesFrom});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final BottomNavController controller = Get.put(BottomNavController());
  final FilterController filtercontroller = Get.put(FilterController());

  List<String> checkoutlistt = [
    "assets/images/checkoutdelete1.png",
    "assets/images/checkoutdelete2.png",
    "assets/images/checkoutdelete3.png",
  ];
  List<String> similarStyleList = [
    "assets/images/checkoutdelete4.png",
    "assets/images/checkoutdelete5.png",
    "assets/images/checkoutdelete6.png",
  ];

  @override
  void initState() {
    filtercontroller.getProductsDetails(context, widget.id);
    firebaseEventCalled();
    super.initState();
  }

  firebaseEventCalled() {
    try {
      FacebookAppEvents facebookAppEvents = FacebookAppEvents();

      facebookAppEvents.logEvent(
        name: "ProductViewAndroid",
      );
    } catch (e) {}
  }

  // snackbar ==================================================================================================

  mysnackbar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 1),
        content: Text(message,
            style: GoogleFonts.lexendDeca(
                fontSize: 13,
                fontWeight: FontWeight.w300,
                color: Colors.white))));
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
    return GetBuilder(
        init: FilterController(),
        builder: (controller) {
          return WillPopScope(
            onWillPop: () async {
              if (widget.comesFrom == "uri") {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Home()),
                    (route) => false);
                controller.productDetailsResponse.clear();
                controller.productImages.clear();
                controller.moreRentalProduct.clear();
                controller.similarProducts.clear();
              } else {
                Navigator.pop(context);
                controller.productDetailsResponse.clear();
                controller.productImages.clear();
                controller.moreRentalProduct.clear();
                controller.similarProducts.clear();
              }
              return false;
            },
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                toolbarHeight: 0,
              ),
              backgroundColor: Colors.white,
              body: Column(
                children: [
                  // top four icon ===========================
                  Container(
                    alignment: Alignment.center,
                    height: 60,
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration:
                        const BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(255, 216, 216, 216),
                          blurRadius: 2,
                          offset: Offset(0, 2))
                    ]),
                    padding: const EdgeInsets.only(right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                            onTap: () {
                              if (widget.comesFrom == "uri") {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Home()),
                                    (route) => false);
                                controller.productDetailsResponse.clear();
                                controller.productImages.clear();
                                controller.moreRentalProduct.clear();
                                controller.similarProducts.clear();
                              } else {
                                Navigator.pop(context);
                                controller.productDetailsResponse.clear();
                                controller.productImages.clear();
                                controller.moreRentalProduct.clear();
                                controller.similarProducts.clear();
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              width: 50,
                              child: SvgPicture.asset(
                                "assets/images/backarrow.svg",
                                width: 20,
                                height: 20,
                              ),
                            )),
                        Container(
                            margin: const EdgeInsets.only(left: 20),
                            child: Image.asset(
                              "assets/images/appiconpng.png",
                              width: 40,
                              height: 40,
                            )),
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          direction: Axis.horizontal,
                          children: [
                            InkWell(
                                onTap: () async {
                                  SharedPreferences sharedPreferences =
                                      await SharedPreferences.getInstance();

                                  if (sharedPreferences
                                          .getString(SizValue.isLogged)
                                          .toString() ==
                                      "null") {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginPage(otpNumber: "")));
                                  } else if (sharedPreferences
                                          .getString(SizValue.isLogged)
                                          .toString() ==
                                      "1") {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BasicLoginInfo(
                                                    fromWhere: sharedPreferences
                                                        .getString(
                                                            SizValue.source)
                                                        .toString())));
                                  }

                                  // else if (sharedPreferences
                                  //         .getString(SizValue.isLogged)
                                  //         .toString() ==
                                  //     "2") {
                                  //   Navigator.push(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //           builder: (context) =>
                                  //               AccountCreate()));
                                  // }

                                  // else if (sharedPreferences
                                  //         .getString(SizValue.underReview)
                                  //         .toString() ==
                                  //     "0") {
                                  //   showReviewdialog(
                                  //       sharedPreferences
                                  //           .getString(SizValue.underReviewMsg)
                                  //           .toString(),
                                  //       sharedPreferences
                                  //           .getString(SizValue.underReview)
                                  //           .toString());
                                  // }
                                  
                                   else if (sharedPreferences
                                          .getString(SizValue.underReview)
                                          .toString() ==
                                      "2") {
                                    showReviewdialog(
                                        sharedPreferences
                                            .getString(
                                                SizValue.rejectedReviewMSG)
                                            .toString(),
                                        sharedPreferences
                                            .getString(SizValue.underReview)
                                            .toString());
                                  } else if (sharedPreferences
                                          .getString(SizValue.underReview)
                                          .toString() ==
                                      "3") {
                                    showReviewdialog(
                                        sharedPreferences
                                            .getString(
                                                SizValue.incompleteMessage)
                                            .toString(),
                                        sharedPreferences
                                            .getString(SizValue.underReview)
                                            .toString());
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Wishlist()));
                                  }
                                },
                                child: SvgPicture.asset(
                                  "assets/images/heart.svg",
                                  width: 20,
                                  height: 20,
                                )),
                            const SizedBox(width: 20),
                            InkWell(
                                onTap: () async {
                                  SharedPreferences sharedPreferences =
                                      await SharedPreferences.getInstance();

                                  if (sharedPreferences
                                          .getString(SizValue.isLogged)
                                          .toString() ==
                                      "null") {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginPage(otpNumber: "")));
                                  } else if (sharedPreferences
                                          .getString(SizValue.isLogged)
                                          .toString() ==
                                      "1") {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BasicLoginInfo(
                                                    fromWhere: sharedPreferences
                                                        .getString(
                                                            SizValue.source)
                                                        .toString())));
                                  } else if (sharedPreferences
                                          .getString(SizValue.isLogged)
                                          .toString() ==
                                      "2") {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AccountCreate()));
                                  } 
                                  
                                  else if (sharedPreferences
                                          .getString(SizValue.underReview)
                                          .toString() ==
                                      "0") {
                                    showReviewdialog(
                                        sharedPreferences
                                            .getString(SizValue.underReviewMsg)
                                            .toString(),
                                        sharedPreferences
                                            .getString(SizValue.underReview)
                                            .toString());
                                  } 
                                  
                                  else if (sharedPreferences
                                          .getString(SizValue.underReview)
                                          .toString() ==
                                      "2") {
                                    showReviewdialog(
                                        sharedPreferences
                                            .getString(
                                                SizValue.rejectedReviewMSG)
                                            .toString(),
                                        sharedPreferences
                                            .getString(SizValue.underReview)
                                            .toString());
                                  } else if (sharedPreferences
                                          .getString(SizValue.underReview)
                                          .toString() ==
                                      "3") {
                                    showReviewdialog(
                                        sharedPreferences
                                            .getString(
                                                SizValue.incompleteMessage)
                                            .toString(),
                                        sharedPreferences
                                            .getString(SizValue.underReview)
                                            .toString());
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Cart()));
                                  }
                                },
                                child: SvgPicture.asset(
                                  "assets/images/bag.svg",
                                  width: 20,
                                  height: 20,
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      children: [
                        // uploader image, name and contry

                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () async {
                                  if (controller
                                          .productDetailsResponse["is_owner"]
                                          .toString() ==
                                      "0") {
                                    navigateAndDisplaySelection(
                                        context, widget.id);
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const MyProfile()));
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(width: 10),
                                    Container(
                                      width: 55,
                                      height: 55,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(1000),
                                        child: controller
                                                .productDetailsResponse.isEmpty
                                            ? const SizedBox(
                                                width: 55,
                                                height: 55,
                                              )
                                            : CachedNetworkImage(
                                                imageUrl: controller
                                                    .productDetailsResponse[
                                                        "user_img"]
                                                    .toString(),
                                                fit: BoxFit.cover,
                                                height: 55,
                                                width: 55,
                                              ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          controller.productDetailsResponse
                                                  .isEmpty
                                              ? ""
                                              : controller
                                                  .productDetailsResponse[
                                                      "user_name"]
                                                  .toString(),
                                          style: GoogleFonts.dmSerifDisplay(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15),
                                        ),
                                        Visibility(
                                          visible: controller
                                                  .productDetailsResponse
                                                  .isEmpty
                                              ? false
                                              : controller.productDetailsResponse[
                                                              "top_lender"]
                                                          .toString() ==
                                                      "0"
                                                  ? false
                                                  : true,
                                          child: Text(
                                            "Top Lender",
                                            style: GoogleFonts.lexendDeca(
                                                fontSize: 13,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () async {
                                  SharedPreferences sharedPreferences =
                                      await SharedPreferences.getInstance();

                                  if (sharedPreferences
                                          .getString(SizValue.isLogged)
                                          .toString() ==
                                      "null") {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginPage(otpNumber: "")));
                                  } else if (sharedPreferences
                                          .getString(SizValue.isLogged)
                                          .toString() ==
                                      "1") {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BasicLoginInfo(
                                                    fromWhere: sharedPreferences
                                                        .getString(
                                                            SizValue.source)
                                                        .toString())));
                                  }
                                  //  else if (sharedPreferences
                                  //         .getString(SizValue.isLogged)
                                  //         .toString() ==
                                  //     "2") {
                                  //   Navigator.push(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //           builder: (context) =>
                                  //               AccountCreate()));
                                  // }
                                  // else if (sharedPreferences
                                  //         .getString(SizValue.underReview)
                                  //         .toString() ==
                                  //     "0") {
                                  //   showReviewdialog(
                                  //       sharedPreferences
                                  //           .getString(SizValue.underReviewMsg)
                                  //           .toString(),
                                  //       sharedPreferences
                                  //           .getString(SizValue.underReview)
                                  //           .toString());
                                  // }
                                  
                                   else if (sharedPreferences
                                          .getString(SizValue.underReview)
                                          .toString() ==
                                      "2") {
                                    showReviewdialog(
                                        sharedPreferences
                                            .getString(
                                                SizValue.rejectedReviewMSG)
                                            .toString(),
                                        sharedPreferences
                                            .getString(SizValue.underReview)
                                            .toString());
                                  } else if (sharedPreferences
                                          .getString(SizValue.underReview)
                                          .toString() ==
                                      "3") {
                                    showReviewdialog(
                                        sharedPreferences
                                            .getString(
                                                SizValue.incompleteMessage)
                                            .toString(),
                                        sharedPreferences
                                            .getString(SizValue.underReview)
                                            .toString());
                                  } else if (controller
                                          .productDetailsResponse["is_owner"]
                                          .toString() ==
                                      "0") {
                                    goToChat(
                                        context,
                                        controller
                                            .productDetailsResponse["chat_id"]
                                            .toString(),
                                        widget.id,
                                        controller
                                            .productDetailsResponse["lender_id"]
                                            .toString());
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 5),
                                  child: SvgPicture.asset(
                                    "assets/images/beforchat.svg",
                                    height: 25,
                                    width: 25,
                                  ),
                                ),
                              ),
                              InkWell(
                                  onTap: () {
                                 
                                      try {
                                        FacebookAppEvents facebookAppEvents =
                                            FacebookAppEvents();

                                        facebookAppEvents.logEvent(
                                          name: "ShareClosetAndroid",
                                        );
                                      } catch (e) {}
                                    

                                    Share.share(
                                        'Hey ! Check out this listing on Sizters App https://app.siz.ae/product/${widget.id}');
                                  },
                                  child: Container(
                                      margin: const EdgeInsets.only(
                                          right: 10, left: 10),
                                      child: SvgPicture.asset(
                                        "assets/images/shareupload.svg",
                                        height: 28,
                                        width: 28,
                                      )))
                            ],
                          ),
                        ),

                        // product image ==================================================================================================

                        const SizedBox(height: 7),

                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            controller.productImages.isEmpty
                                ? SizedBox(
                                    height: 475,
                                    width: MediaQuery.of(context).size.width,
                                  )
                                : InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AppProductImageView(
                                                      imageslist: controller
                                                          .productImages)));
                                    },
                                    child: Container(
                                      height: 475,
                                      width: MediaQuery.of(context).size.width,
                                      foregroundDecoration:
                                          const BoxDecoration(),
                                      child: ProductMultiImage(
                                        // herotag: widget.herotag,
                                        //required fields

                                        arrayImages: controller.productImages,

                                        sliderStyle: SliderStyle
                                            .overSlider, //.overSlider, .nextToSlider

                                        aspectRatio: 0.8,

                                        boxFit: BoxFit.cover,

                                        selectedImagePosition: 0,

                                        thumbnailAlignment:
                                            ThumbnailAlignment.left,

                                        thumbnailBorderType:
                                            ThumbnailBorderType.all,

                                        thumbnailBorderWidth: 1,

                                        thumbnailBorderRadius: 5,

                                        thumbnailWidth: 50,

                                        thumbnailHeight: 65,

                                        thumbnailBorderColor:
                                            MyColors.themecolor,
                                      ),
                                    ),
                                  ),
                            Visibility(
                              visible: controller.productDetailsResponse.isEmpty
                                  ? false
                                  : controller.productDetailsResponse[
                                                  "category"]
                                              .toString() ==
                                          "Clothing"
                                      ? true
                                      : false,
                              child: Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 5, bottom: 5),
                                  constraints:
                                      const BoxConstraints(minWidth: 50),
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                      color: Color.fromARGB(119, 0, 0, 0)),
                                  margin:
                                      const EdgeInsets.only(right: 20, top: 10),
                                  alignment: Alignment.center,
                                  child: Text(
                                    controller.productDetailsResponse.isEmpty
                                        ? ""
                                        : controller
                                            .productDetailsResponse["size_name"]
                                            .toString(),
                                    style: GoogleFonts.lexendDeca(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 20,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: controller.productDetailsResponse.isEmpty
                                  ? false
                                  : controller.productDetailsResponse["type"]
                                              .toString() ==
                                          "1"
                                      ? false
                                      : true,
                              child: Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      right: 10, bottom: 10),
                                  padding: const EdgeInsets.only(
                                      left: 7, right: 7, top: 2, bottom: 2),
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50))),
                                  child: Text(
                                    "MANAGED",
                                    style: GoogleFonts.lexendExa(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: MyColors.themecolor),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // View and like button at right ======================================================================

                        const SizedBox(height: 10),

                        // product name and rating ==========================================================================================

                        Container(
                          margin: const EdgeInsets.only(right: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                  left: 20,
                                ),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  controller.productDetailsResponse.isEmpty
                                      ? ""
                                      : controller
                                          .productDetailsResponse["brand_name"]
                                          .toString(),
                                  style: GoogleFonts.dmSerifDisplay(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                ),
                              ),

                              // rating stars =====================================================================================

                              Container(
                                margin:
                                    const EdgeInsets.only(right: 5, bottom: 5),
                                alignment: Alignment.centerLeft,
                                child: RatingBarIndicator(
                                  rating: controller
                                          .productDetailsResponse.isEmpty
                                      ? 0.0
                                      : int.parse(
                                              controller.productDetailsResponse[
                                                  "product_rating"])
                                          .toDouble(),
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: MyColors.themecolor,
                                  ),
                                  itemCount: 5,
                                  itemSize: 20.0,
                                  direction: Axis.horizontal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(left: 20),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  controller.productDetailsResponse.isEmpty
                                      ? ""
                                      : controller
                                          .productDetailsResponse["title"]
                                          .toString(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.lexendDeca(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300,
                                    color:
                                        const Color.fromARGB(255, 83, 83, 83),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                SharedPreferences sharedPreferences =
                                    await SharedPreferences.getInstance();

                                if (sharedPreferences
                                        .getString(SizValue.isLogged)
                                        .toString() ==
                                    "null") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              LoginPage(otpNumber: "")));
                                } else if (sharedPreferences
                                        .getString(SizValue.isLogged)
                                        .toString() ==
                                    "1") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => BasicLoginInfo(
                                              fromWhere: sharedPreferences
                                                  .getString(SizValue.source)
                                                  .toString())));
                                }
                                // else if (sharedPreferences
                                //         .getString(SizValue.isLogged)
                                //         .toString() ==
                                //     "2") {
                                //   Navigator.push(
                                //       context,
                                //       MaterialPageRoute(
                                //           builder: (context) =>
                                //               AccountCreate()));
                                // }
                                // else if (sharedPreferences
                                //         .getString(SizValue.underReview)
                                //         .toString() ==
                                //     "0") {
                                //   showReviewdialog(
                                //       sharedPreferences
                                //           .getString(SizValue.underReviewMsg)
                                //           .toString(),
                                //       sharedPreferences
                                //           .getString(SizValue.underReview)
                                //           .toString());
                                // } 
                                else if (sharedPreferences
                                        .getString(SizValue.underReview)
                                        .toString() ==
                                    "2") {
                                  showReviewdialog(
                                      sharedPreferences
                                          .getString(SizValue.rejectedReviewMSG)
                                          .toString(),
                                      sharedPreferences
                                          .getString(SizValue.underReview)
                                          .toString());
                                } else if (sharedPreferences
                                        .getString(SizValue.underReview)
                                        .toString() ==
                                    "3") {
                                  showReviewdialog(
                                      sharedPreferences
                                          .getString(SizValue.incompleteMessage)
                                          .toString(),
                                      sharedPreferences
                                          .getString(SizValue.underReview)
                                          .toString());
                                } else {
                                  if (controller
                                          .productDetailsResponse["wishlist"]
                                          .toString() ==
                                      "0") {
                                    controller.addWishlist(context, widget.id,
                                        widget.index, "4", widget.comesFrom);
                                  } else if (controller
                                          .productDetailsResponse["wishlist"]
                                          .toString() ==
                                      "1") {
                                    controller.removeWishlist(
                                        context,
                                        widget.id,
                                        widget.index,
                                        "4",
                                        widget.comesFrom);
                                  }
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 20),
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  direction: Axis.horizontal,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    const SizedBox(width: 3),
                                    SvgPicture.asset(
                                      controller.productDetailsResponse[
                                                      "wishlist"]
                                                  .toString() ==
                                              "0"
                                          ? "assets/images/likebeforeblack.svg"
                                          : "assets/images/likeafter.svg",
                                      width: 18,
                                      height: 15,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      controller.productDetailsResponse.isEmpty
                                          ? ""
                                          : controller.productDetailsResponse[
                                                  "wishlist_count"]
                                              .toString(),
                                      style: GoogleFonts.lexendDeca(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin:
                                    const EdgeInsets.only(left: 20, right: 10),
                                child: Text(
                                  controller.productDetailsResponse.isEmpty
                                      ? ""
                                      : "Retail AED ${controller.productDetailsResponse["retail_price"]}",
                                  style: GoogleFonts.lexendDeca(
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.grey),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 20),
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                direction: Axis.horizontal,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/images/eyeoutline.svg",
                                    width: 18,
                                    height: 20,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    controller.productDetailsResponse.isEmpty
                                        ? ""
                                        : controller
                                            .productDetailsResponse["views"]
                                            .toString(),
                                    style: GoogleFonts.lexendDeca(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // retal price and rent price ==========================================================================================

                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 20, top: 10),
                              child: Text(
                                controller.productDetailsResponse.isEmpty
                                    ? ""
                                    : controller.productDetailsResponse[
                                                    "category_id"]
                                                .toString() ==
                                            "1"
                                        ? "RENT AED ${controller.productDetailsResponse["rent_amount"]} | 3 DAYS"
                                        : "RENT AED ${controller.productDetailsResponse["price_8d"]} | 8 DAYS",
                                style: GoogleFonts.lexendExa(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                    color: MyColors.themecolor),
                              ),
                            ),

                            //
                          ],
                        ),

                        Visibility(
                          visible: controller.productDetailsResponse.isEmpty
                              ? false
                              : controller.productDetailsResponse["type"]
                                          .toString() ==
                                      "1"
                                  ? false
                                  : true,
                          child: InfoPopupWidget(
                            contentTitle:
                                controller.productDetailsResponse.isEmpty
                                    ? ""
                                    : controller.productDetailsResponse[
                                            "managed_product_text"]
                                        .toString(),
                            contentTheme: InfoPopupContentTheme(
                                infoTextStyle: GoogleFonts.lexendDeca(
                                    fontSize: 14, fontWeight: FontWeight.w300)),
                            child: Container(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              margin: const EdgeInsets.only(
                                  top: 20, left: 20, right: 20),
                              width: MediaQuery.of(context).size.width,
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: Color.fromARGB(255, 241, 241, 241)),
                              height: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/appiconpng.png",
                                    width: 30,
                                    height: 30,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "This listing is managed by ",
                                    style: GoogleFonts.lexendDeca(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    "@sizters.app",
                                    style: GoogleFonts.lexendDeca(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color: MyColors.themecolor),
                                  ),
                                  Container(
                                      margin: const EdgeInsets.only(left: 5),
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.info_outline,
                                        size: 20,
                                      ))
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Details =============================================================================================

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 20, bottom: 10, top: 20),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Details",
                                style: GoogleFonts.dmSerifDisplay(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: Colors.black),
                              ),
                            ),
                            Visibility(
                              visible: controller.productDetailsResponse.isEmpty
                                  ? false
                                  : controller.productDetailsResponse[
                                                  "category_id"]
                                              .toString() ==
                                          "1"
                                      ? true
                                      : false,
                              child: InkWell(
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
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              alignment: Alignment.center,
                                              height: 400,
                                              child: Image.asset(
                                                  "assets/images/chart.png")));
                                    },
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 20, right: 20, top: 20, bottom: 10),
                                  child: Text(
                                    "SIZE CHART",
                                    style: GoogleFonts.lexendExa(
                                        color: Colors.grey,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                        decoration: TextDecoration.underline),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // category ==================================================================================

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.only(left: 20, bottom: 10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Sub category",
                                style: GoogleFonts.lexendDeca(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black),
                              ),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.only(right: 20, bottom: 10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                controller.productDetailsResponse.isEmpty
                                    ? ""
                                    : controller
                                        .productDetailsResponse["sub_category"]
                                        .toString(),
                                style: GoogleFonts.lexendDeca(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Color ==================================================================================

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.only(left: 20, bottom: 10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Color",
                                style: GoogleFonts.lexendDeca(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black),
                              ),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.only(right: 20, bottom: 10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                controller.productDetailsResponse.isEmpty
                                    ? ""
                                    : controller.productDetailsResponse["color"]
                                        .toString(),
                                style: GoogleFonts.lexendDeca(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Size ==================================================================================

                        Visibility(
                          visible: controller
                                      .productDetailsResponse["category_id"]
                                      .toString() ==
                                  "2"
                              ? false
                              : true,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 20, bottom: 10),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Size",
                                  style: GoogleFonts.lexendDeca(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    right: 20, bottom: 10),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  controller.productDetailsResponse.isEmpty
                                      ? ""
                                      : controller
                                          .productDetailsResponse["size_name"]
                                          .toString(),
                                  style: GoogleFonts.lexendDeca(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // deposit amound ==================================================================================

                        Visibility(
                          visible: controller.productDetailsResponse.isEmpty
                              ? false
                              : controller.productDetailsResponse[
                                              "security_amount"]
                                          .toString() ==
                                      "0"
                                  ? false
                                  : true,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 20, bottom: 10),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Refundable deposit",
                                  style: GoogleFonts.lexendDeca(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    right: 20, bottom: 10),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "AED ${controller.productDetailsResponse["security_amount"]}",
                                  style: GoogleFonts.lexendDeca(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.only(left: 20, bottom: 10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Per day price",
                                style: GoogleFonts.lexendDeca(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black),
                              ),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.only(right: 20, bottom: 10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                controller.productDetailsResponse.isEmpty
                                    ? ""
                                    : "AED ${controller.productDetailsResponse["price_1d"]}",
                                style: GoogleFonts.lexendDeca(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.only(left: 20, bottom: 10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Minimum Rental Period",
                                style: GoogleFonts.lexendDeca(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black),
                              ),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.only(right: 20, bottom: 10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                controller.productDetailsResponse.isEmpty
                                    ? ""
                                    : controller.productDetailsResponse[
                                                    "category_id"]
                                                .toString() ==
                                            "1"
                                        ? "3 Days"
                                        : "8 Days",
                                style: GoogleFonts.lexendDeca(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Descriprion full ========================================================================================

                        Container(
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, top: 10),
                          width: MediaQuery.of(context).size.width,
                          height: 1,
                          color: const Color.fromARGB(255, 226, 226, 226),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          child: Accordion(
                              disableScrolling: true,
                              maxOpenSections: 1,
                              contentBackgroundColor: Colors.white,
                              headerBackgroundColor: Colors.white,
                              scaleWhenAnimating: false,
                              openAndCloseAnimation: true,
                              paddingListBottom: 0,
                              paddingListTop: 0,
                              // sectionOpeningHapticFeedback:
                              //     SectionHapticFeedback.heavy,
                              // sectionClosingHapticFeedback:
                              //     SectionHapticFeedback.light,
                              children: [
                                AccordionSection(
                                  headerPadding:
                                      const EdgeInsets.only(bottom: 5, top: 10),
                                  contentBorderRadius: 0,
                                  headerBorderRadius: 0,
                                  paddingBetweenClosedSections: 0,
                                  paddingBetweenOpenSections: 0,
                                  rightIcon: const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.black,
                                      size: 20),
                                  isOpen: false,
                                  header: Text(
                                    "Description",
                                    style: GoogleFonts.dmSerifDisplay(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                        color: Colors.black),
                                  ),
                                  content: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      controller.productDetailsResponse.isEmpty
                                          ? ""
                                          : decordedResponse(controller
                                              .productDetailsResponse[
                                                  "description"]
                                              .toString()),
                                      style: GoogleFonts.lexendDeca(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black),
                                    ),
                                  ),
                                  contentHorizontalPadding: 0,
                                  contentBorderWidth: 0,
                                ),
                              ]),
                        ),

                        Container(
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, top: 10),
                          width: MediaQuery.of(context).size.width,
                          height: 1,
                          color: const Color.fromARGB(255, 226, 226, 226),
                        ),

                        Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          child: Accordion(
                              disableScrolling: true,
                              maxOpenSections: 1,
                              contentBackgroundColor: Colors.white,
                              headerBackgroundColor: Colors.white,
                              scaleWhenAnimating: false,
                              openAndCloseAnimation: true,
                              paddingListBottom: 0,
                              paddingListTop: 0,
                              // sectionOpeningHapticFeedback:
                              //     SectionHapticFeedback.heavy,
                              // sectionClosingHapticFeedback:
                              //     SectionHapticFeedback.light,
                              children: [
                                AccordionSection(
                                  headerPadding:
                                      const EdgeInsets.only(bottom: 5, top: 10),
                                  contentBorderRadius: 0,
                                  headerBorderRadius: 0,
                                  paddingBetweenClosedSections: 0,
                                  paddingBetweenOpenSections: 0,
                                  rightIcon: const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.black,
                                      size: 20),
                                  isOpen: false,
                                  header: Text(
                                    "Size and fit",
                                    style: GoogleFonts.dmSerifDisplay(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                        color: Colors.black),
                                  ),
                                  content: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      controller.productDetailsResponse.isEmpty
                                          ? ""
                                          : decordedResponse(controller
                                              .productDetailsResponse[
                                                  "size_note"]
                                              .toString()),
                                      style: GoogleFonts.lexendDeca(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black),
                                    ),
                                  ),
                                  contentHorizontalPadding: 0,
                                  contentBorderWidth: 0,
                                ),
                              ]),
                        ),

                        Container(
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, top: 10),
                          width: MediaQuery.of(context).size.width,
                          height: 1,
                          color: const Color.fromARGB(255, 226, 226, 226),
                        ),

                        Container(
                          margin: const EdgeInsets.only(
                              left: 20, top: 15, bottom: 10),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Checkout more items from her closet",
                            style: GoogleFonts.dmSerifDisplay(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Colors.black),
                          ),
                        ),

                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                left: 20,
                              ),
                              alignment: Alignment.center,
                              width: 85,
                              height: 130,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      controller.productDetailsResponse[
                                                      "is_owner"]
                                                  .toString() ==
                                              "0"
                                          ? navigateAndDisplaySelection(
                                              context, widget.id)
                                          : Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const MyProfile()));
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 55,
                                          height: 55,
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(1000),
                                            child: controller
                                                    .productDetailsResponse
                                                    .isEmpty
                                                ? const SizedBox(
                                                    height: 55,
                                                    width: 55,
                                                  )
                                                : CachedNetworkImage(
                                                    imageUrl: controller
                                                        .productDetailsResponse[
                                                            "user_img"]
                                                        .toString(),
                                                    fit: BoxFit.cover,
                                                    height: 55,
                                                    width: 55,
                                                  ),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          controller.productDetailsResponse
                                                  .isEmpty
                                              ? ""
                                              : controller
                                                  .productDetailsResponse[
                                                      "user_name"]
                                                  .toString(),
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.lexendDeca(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        const SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      SharedPreferences sharedPreferences =
                                          await SharedPreferences.getInstance();

                                      if (sharedPreferences
                                              .getString(SizValue.isLogged)
                                              .toString() ==
                                          "null") {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginPage(otpNumber: "")));
                                      } else if (sharedPreferences
                                              .getString(SizValue.isLogged)
                                              .toString() ==
                                          "1") {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BasicLoginInfo(
                                                        fromWhere:
                                                            sharedPreferences
                                                                .getString(
                                                                    SizValue
                                                                        .source)
                                                                .toString())));
                                      }

                                      //  else if (sharedPreferences
                                      //         .getString(SizValue.isLogged)
                                      //         .toString() ==
                                      //     "2") {
                                      //   Navigator.push(
                                      //       context,
                                      //       MaterialPageRoute(
                                      //           builder: (context) =>
                                      //               AccountCreate()));
                                      // }

                                      // else if (sharedPreferences
                                      //         .getString(SizValue.underReview)
                                      //         .toString() ==
                                      //     "0") {
                                      //   showReviewdialog(
                                      //       sharedPreferences
                                      //           .getString(
                                      //               SizValue.underReviewMsg)
                                      //           .toString(),
                                      //       sharedPreferences
                                      //           .getString(SizValue.underReview)
                                      //           .toString());
                                      // }
                                      
                                       else if (sharedPreferences
                                              .getString(SizValue.underReview)
                                              .toString() ==
                                          "2") {
                                        showReviewdialog(
                                            sharedPreferences
                                                .getString(
                                                    SizValue.rejectedReviewMSG)
                                                .toString(),
                                            sharedPreferences
                                                .getString(SizValue.underReview)
                                                .toString());
                                      } else if (sharedPreferences
                                              .getString(SizValue.underReview)
                                              .toString() ==
                                          "3") {
                                        showReviewdialog(
                                            sharedPreferences
                                                .getString(
                                                    SizValue.incompleteMessage)
                                                .toString(),
                                            sharedPreferences
                                                .getString(SizValue.underReview)
                                                .toString());
                                      } else if (controller
                                              .productDetailsResponse[
                                                  "is_owner"]
                                              .toString() ==
                                          "0") {
                                        goToChat(
                                            context,
                                            controller.productDetailsResponse[
                                                    "chat_id"]
                                                .toString(),
                                            widget.id,
                                            controller.productDetailsResponse[
                                                    "lender_id"]
                                                .toString());
                                      }
                                    },
                                    child: SvgPicture.asset(
                                      "assets/images/beforchat.svg",
                                      height: 30,
                                      width: 30,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(left: 10),
                                height: 130,
                                child: ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount:
                                        controller.moreRentalProduct.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProductView(
                                                        index: 0,
                                                        id: controller
                                                            .moreRentalProduct[
                                                                index]["id"]
                                                            .toString(),
                                                        fromCart: false,
                                                        comesFrom: "",
                                                      )));
                                        },
                                        child: Container(
                                            margin:
                                                const EdgeInsets.only(right: 5),
                                            child: CachedNetworkImage(
                                              imageUrl: controller
                                                  .moreRentalProduct[index]
                                                      ["img_url"]
                                                  .toString(),
                                              width: 90,
                                              height: 130,
                                              fit: BoxFit.cover,
                                            )),
                                      );
                                    }),
                              ),
                            )
                          ],
                        ),

                        Visibility(
                          visible: controller.similarProducts.isNotEmpty,
                          child: Container(
                            margin: const EdgeInsets.only(
                                left: 20, top: 20, bottom: 5),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Similar style",
                              style: GoogleFonts.dmSerifDisplay(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                          ),
                        ),

                        Container(
                          margin: const EdgeInsets.only(left: 20, top: 10),
                          height:
                              controller.similarProducts.isNotEmpty ? 145 : 0,
                          child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: controller.similarProducts.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ProductView(
                                                  index: 0,
                                                  id: controller
                                                      .similarProducts[index]
                                                          ["id"]
                                                      .toString(),
                                                  fromCart: false,
                                                  comesFrom: "",
                                                )));
                                  },
                                  child: Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      child: CachedNetworkImage(
                                        imageUrl: controller
                                            .similarProducts[index]["img_url"]
                                            .toString(),
                                        width: 113,
                                        height: 145,
                                        fit: BoxFit.cover,
                                      )),
                                );
                              }),
                        ),
                      ],
                    ),
                  ),

                  // Bottom add to cart option ==============================================================================

                  controller.productDetailsResponse.isEmpty
                      ? Container()
                      : controller.productDetailsResponse["is_owner"]
                                  .toString() ==
                              "1"
                          ? Container(
                              alignment: Alignment.center,
                              padding:
                                  const EdgeInsets.only(bottom: 10, top: 10),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 222, 222, 222),
                                      width: 1)),
                              child: Text(
                                "Own Listing",
                                style: GoogleFonts.lexendDeca(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: MyColors.themecolor),
                              ),
                            )
                          : widget.fromCart
                              ? Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.only(
                                      bottom: 10, top: 10),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10)),
                                      border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 222, 222, 222),
                                          width: 1)),
                                  child: Text(
                                    "Already added in cart",
                                    style: GoogleFonts.lexendDeca(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: MyColors.themecolor),
                                  ),
                                )
                              : Container(
                                  height: 80,
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10)),
                                      border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 222, 222, 222),
                                          width: 1)),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 5),
                                      controller.productDetailsResponse[
                                                      "is_available"]
                                                  .toString() ==
                                              "1"
                                          ? Container(
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(
                                                            top: 10, bottom: 5),
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          controller.productDetailsResponse[
                                                                          "category_id"]
                                                                      .toString() ==
                                                                  "1"
                                                              ? "RENT AED ${controller.productDetailsResponse["rent_amount"]} | 3 DAYS"
                                                              : "RENT AED ${controller.productDetailsResponse["price_8d"]} | 8 DAYS",
                                                          style: GoogleFonts
                                                              .lexendExa(
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  color: MyColors
                                                                      .themecolor),
                                                        ),
                                                      ),
                                                      Container(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          "Shipping and Drycleaning included",
                                                          style: GoogleFonts
                                                              .lexendDeca(
                                                                  fontSize: 11,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  color: Colors
                                                                      .grey),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  InkWell(
                                                    onTap: () async {
                                                      //   if ((controller. productDetailsResponse["cart_status"] == 0)) {
                                                      //         cartWarning();
                                                      // }

                                                      // else {
                                                      //   Navigator.push(
                                                      //       context,
                                                      //       MaterialPageRoute(
                                                      //           builder: (context) => DateSelector(
                                                      //                 id: widget.id,
                                                      //                 type: controller. productDetailsResponse["type"]
                                                      //                     .toString(),
                                                      //                 replace: "",
                                                      //                 price3days:
                                                      //                     controller. productDetailsResponse["price_3d"]
                                                      //                         .toString(),
                                                      //                 price8days:
                                                      //                     controller. productDetailsResponse["price_8d"]
                                                      //                         .toString(),
                                                      //                 price20days:
                                                      //                     controller. productDetailsResponse["price_20d"]
                                                      //                         .toString(),
                                                      //                 availableDate: controller. productDetailsResponse[
                                                      //                         "next_available_date"]
                                                      //                     .toString(),
                                                      //               category: controller. productDetailsResponse[
                                                      //                         "category_id"]
                                                      //                     .toString(),

                                                      //                     tryonPrices:  controller. productDetailsResponse[
                                                      //                         "try_on_charges"]
                                                      //                     .toString(),
                                                      //               )));
                                                      // }

                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      DateSelector(
                                                                        id: widget
                                                                            .id,
                                                                        type: controller
                                                                            .productDetailsResponse["type"]
                                                                            .toString(),
                                                                        replace:
                                                                            "",
                                                                        price3days: controller
                                                                            .productDetailsResponse["price_3d"]
                                                                            .toString(),
                                                                        price8days: controller
                                                                            .productDetailsResponse["price_8d"]
                                                                            .toString(),
                                                                        price20days: controller
                                                                            .productDetailsResponse["price_20d"]
                                                                            .toString(),
                                                                        availableDate: controller
                                                                            .productDetailsResponse["next_available_date"]
                                                                            .toString(),
                                                                        category: controller
                                                                            .productDetailsResponse["category_id"]
                                                                            .toString(),
                                                                        tryonPrices: controller
                                                                            .productDetailsResponse["try_on_charges"]
                                                                            .toString(),
                                                                        tryon: controller
                                                                            .productDetailsResponse["is_try_on"]
                                                                            .toString(),
                                                                      )));
                                                    },

                                                    // befor tapped

                                                    child: Container(
                                                        margin: const EdgeInsets
                                                            .only(top: 10),
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 10,
                                                                right: 10),
                                                        alignment:
                                                            Alignment.center,
                                                        decoration: BoxDecoration(
                                                            color: Colors.black,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                        height: 40,
                                                        child: Text(
                                                          "RENT NOW",
                                                          style: GoogleFonts
                                                              .lexendExa(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300),
                                                        )),
                                                  )
                                                ],
                                              ),
                                            )
                                          : Container(
                                              margin: const EdgeInsets.only(
                                                  top: 10, bottom: 10),
                                              child: Text(
                                                "Currently Unavailable",
                                                style: GoogleFonts.lexendDeca(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: MyColors.themecolor),
                                              ),
                                            )
                                    ],
                                  ),
                                )
                ],
              ),
            ),
          );
        });
  }

  decordedResponse(String response) {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    return stringToBase64.decode(response);
  }

  // not found dialog

  void cartWarning() {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return Center(
          child: WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                height: 220,
                child: Scaffold(
                  backgroundColor: Colors.white,
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Replace cart item?",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 18),
                      ),
                      const SizedBox(height: 10),

                      Text(
                          "Your cart contains items from another lender. Do you want to discard the previews selection and add this item to your cart?",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lexendDeca(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.w300)),

                      const SizedBox(height: 20),

                      // yes or no row

                      Row(
                        children: [
                          Flexible(
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 40,
                                margin:
                                    const EdgeInsets.only(left: 10, right: 5),
                                width: MediaQuery.of(context).size.width,
                                decoration: const BoxDecoration(
                                    color: Colors.black,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                child: Text(
                                  "No".toUpperCase(),
                                  style: GoogleFonts.lexendExa(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DateSelector(
                                              id: widget.id,
                                              type: filtercontroller
                                                  .productDetailsResponse[
                                                      "type"]
                                                  .toString(),
                                              replace: "1",
                                              price3days: filtercontroller
                                                  .productDetailsResponse[
                                                      "price_3d"]
                                                  .toString(),
                                              price8days: filtercontroller
                                                  .productDetailsResponse[
                                                      "price_8d"]
                                                  .toString(),
                                              price20days: filtercontroller
                                                  .productDetailsResponse[
                                                      "price_20d"]
                                                  .toString(),
                                              availableDate: filtercontroller
                                                  .productDetailsResponse[
                                                      "next_available_date"]
                                                  .toString(),
                                              category: filtercontroller
                                                  .productDetailsResponse[
                                                      "category_id"]
                                                  .toString(),
                                              tryonPrices: filtercontroller
                                                  .productDetailsResponse[
                                                      "try_on_charges"]
                                                  .toString(),
                                              tryon: filtercontroller
                                                  .productDetailsResponse[
                                                      "is_try_on"]
                                                  .toString(),
                                            )));
                              },
                              child: Container(
                                height: 40,
                                alignment: Alignment.center,
                                margin:
                                    const EdgeInsets.only(left: 5, right: 10),
                                width: MediaQuery.of(context).size.width,
                                decoration: const BoxDecoration(
                                    color: Colors.black,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                child: Text(
                                  "Yes".toUpperCase(),
                                  style: GoogleFonts.lexendExa(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )),
          ),
        );
      },
    );
  }

  void showReviewdialog(String title, String value) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: value == "3" ? true : false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return WillPopScope(
          onWillPop: () async {
            return value == "3" ? true : false;
          },
          child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                   margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(13)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          title,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lexendDeca(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: Colors.black),
                        ),
                      ),
                      InkWell(
                        onTap: value == "2"
                            ? () async {
                                Navigator.pop(context);
                                controller.updateIndex(0);
                
                                SharedPreferences sharedPreferences =
                                    await SharedPreferences.getInstance();
                                sharedPreferences.clear();
                
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Home()),
                                    (Route<dynamic> route) => false);
                              }
                            : value == "3"
                                ? () {
                                    Navigator.pop(context);
                
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AccountCreate()));
                                  }
                                : () {
                                    Navigator.pop(context);
                                  },
                        child: Container(
                          width: 240,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(top: 20),
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                              value == "2"
                                  ? "LOGOUT"
                                  : value == "3"
                                      ? "COMPLETE SIGNUP"
                                      : "OK",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lexendExa(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300)),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        );
      },
    );
  }

  Future<void> navigateAndDisplaySelection(
      BuildContext context, String lenderId) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => ProfileView(
              lenderId: filtercontroller.productDetailsResponse["lender_id"]
                  .toString())),
    );

    if (!context.mounted) return;

    if (result.toString() == "true") {
      filtercontroller.dialogBlocked(context, lenderId);
    }
  }

  Future<void> goToChat(BuildContext context, String chatID, String productId,
      String lenderId) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ChatInside(
                lenderId: chatID,
                product: productId,
                order: "",
              )),
    );

    if (!context.mounted) return;

    if (result.toString() == "true") {
      filtercontroller.dialogBlocked(context, lenderId);
    }
  }
}
