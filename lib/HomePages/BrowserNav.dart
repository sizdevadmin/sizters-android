// ignore_for_file: sized_box_for_whitespace, use_build_context_synchronously, empty_catches

import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siz/Controllers/BottomNavController.dart';
import 'package:siz/Controllers/FilterController.dart';
import 'package:siz/Filters/BagsHomeFilter.dart';
import 'package:siz/Filters/ClothesHomeFilter.dart';
import 'package:siz/Filters/FilterBagsSort.dart';
import 'package:siz/Filters/FilterClothesSort.dart';
import 'package:badges/badges.dart' as badges;
import 'package:siz/LoginSignUp/AccuntCreate.dart';
import 'package:siz/LoginSignUp/BasicLoginInfo.dart';
import 'package:siz/Pages/Cart.dart';
import 'package:siz/Pages/Home.dart';
import 'package:siz/Pages/ProductView.dart';
import 'package:siz/Pages/SearchPage.dart';
import 'package:siz/Pages/Wishlist.dart';
import 'package:siz/Utils/Colors.dart';
import 'package:siz/Utils/Value.dart';
import 'package:http/http.dart' as http;
import 'package:visible_opacity/visible_opacity.dart';

import '../LoginSignUp/LoginPage.dart';

class BrowserNav extends StatefulWidget {
  const BrowserNav({super.key});

  @override
  State<BrowserNav> createState() => _BrowserNavState();
}

class _BrowserNavState extends State<BrowserNav> with TickerProviderStateMixin {
  bool bagclicked = false;

  bool tabafterfirst = false;
  bool showarrowsearch = false;
  String searchInputValue = "";
  int currentTab = 0;
  late MyTabController tabController;
  bool checkbox = false;

  // get search result ===================================================================

  Map<String, dynamic> searchResponse = {};
  List<dynamic> searchDecordedList = [];

  getSearch(String value) async {
    //  dialodShow(context);
    try {
      final response = await http.post(Uri.parse(SizValue.searchSuggestion),
          body: {'user_key': "", 'search': value});

      searchResponse = jsonDecode(response.body);

      if (searchResponse["success"] == true) {
        setState(() {
          searchDecordedList = searchResponse["list"];
        });
      } else if (searchResponse["success"] == false) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(searchResponse["error"].toString(),
                style: GoogleFonts.lexendDeca(
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                    color: Colors.white))));
      }
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

  FilterController controller = Get.put(FilterController());
  final ScrollController _scrollControllerC = ScrollController();
  final ScrollController _scrollControllerB = ScrollController();

  Timer? checkTypingTimer;

  firebaseEventCalled() {
    try {
      FacebookAppEvents facebookAppEvents = FacebookAppEvents();

      facebookAppEvents.logEvent(
        name: "BrowseAndroid",
      );
    } catch (e) {}
  }

  @override
  void initState() {
    firebaseEventCalled();
    _scrollControllerC.addListener(() async {
      scrollListenerclothes();
    });
    _scrollControllerB.addListener(() async {
      scrollListenerBags();
    });

    tabController = MyTabController(length: 2, vsync: this);

    controller.getProducts(context, "1", 0, "", 1);

    super.initState();
  }

  bool isVisible = true;

  Future<void> scrollListenerclothes() async {
    if (controller.isLoadingMoreC) return;

    _scrollControllerC.addListener(() {
      if (_scrollControllerC.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (isVisible) {
          setState(() {
            isVisible = false;
            tabafterfirst = false;
            // Here you can write your code for open new view
          });
        }
      }
      if (_scrollControllerC.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!isVisible) {
          setState(() {
            isVisible = true;
            tabafterfirst = false;
          });
        }
      }

      if (_scrollControllerC.offset >=
          _scrollControllerC.position.maxScrollExtent - 300) {
        controller.isLoadingMoreC = true;
        controller.forseUpdate();
        if (!controller.oncesCallC) {
          if (controller.noMoreDataC) {
            return;
          } else {
            controller.getProducts(context, "1", 0, "", ++controller.pagenoC);
            controller.oncesCallC = true;
            controller.forseUpdate();
          }
        }
      }
    });
  }

  bool isVisibleBags = true;

  Future<void> scrollListenerBags() async {
    if (controller.isLoadingMoreB) return;

    _scrollControllerB.addListener(() {
      if (_scrollControllerB.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (isVisibleBags) {
          setState(() {
            isVisibleBags = false;
            tabafterfirst = false;
            // Here you can write your code for open new view
          });
        }
      }
      if (_scrollControllerB.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!isVisibleBags) {
          setState(() {
            isVisibleBags = true;
            tabafterfirst = false;
          });
        }
      }

      if (_scrollControllerB.offset >=
          _scrollControllerB.position.maxScrollExtent - 300) {
        controller.isLoadingMoreB = true;
        controller.forseUpdate();
        if (!controller.oncesCallB) {
          if (controller.noMoreDataB) {
            return;
          } else {
            controller.getProducts(context, "2", 1, "", ++controller.pagenoB);
            controller.oncesCallB = true;
            controller.forseUpdate();
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: FilterController(),
        builder: (controller) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Column(
                children: [
                  // top four icons ==============================================================================================

                  Container(
                    decoration:
                        const BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(255, 230, 230, 230),
                          blurRadius: 1,
                          offset: Offset(0, 2))
                    ]),
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(
                          height: 0,
                          width: 25,
                        ),
                        Container(
                            margin: const EdgeInsets.only(left: 30),
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
                                  //  else if(sharedPreferences.getString(SizValue.isLogged).toString()=="2")
                                  //  {

                                  //     Navigator.push(context, MaterialPageRoute(builder: (context)=>AccountCreate()));

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
// tab bar ==========================================================================================

                  Container(
                    height: 40,
                    decoration:
                        const BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(255, 203, 203, 203),
                          blurRadius: 2,
                          offset: Offset(0, 3))
                    ]),
                    child: TabBar(
                      controller: tabController,
                      tabs: [
                        _individualTab('CLOTHES'),
                        _individualTab('BAGS'),
                      ],
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      indicator:
                          const BoxDecoration(color: MyColors.themecolor),
                      onTap: (value) {
                        setState(() {
                          currentTab = value;
                          isVisible = true;
                          isVisibleBags = true;
                        });

                        if (value == 1) {
                          if (!bagclicked) {
                            controller.getProducts(context, "2", 1, "", 1);
                          }

                          setState(() {
                            bagclicked = true;
                          });
                        }
                      },
                      indicatorWeight: 0,
                      indicatorColor: Colors.white,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelPadding: const EdgeInsets.all(0),
                      labelStyle: GoogleFonts.lexendExa(
                          fontSize: 16, fontWeight: FontWeight.w300),
                      indicatorPadding: const EdgeInsets.all(0),
                    ),
                  ),

                  Expanded(
                    child: Stack(
                      children: [
                        // Tabbar VIEW========================================================================================
                        TabBarView(
                            physics: const NeverScrollableScrollPhysics(),
                            controller: tabController,
                            children: [
                              // clothes tab  ========================================================================================================

                              Container(
                                margin:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: SingleChildScrollView(
                                  physics: const ClampingScrollPhysics(),
                                  controller: _scrollControllerC,
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 10),
                                      Stack(
                                        children: [
                                          DynamicHeightGridView(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: controller
                                                .decordedResponse.length,
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 10,
                                            mainAxisSpacing: 10,
                                            builder: (context, index) {
                                              return InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ProductView(
                                                                index: index,
                                                                id: controller
                                                                    .decordedResponse[
                                                                        index]
                                                                        ["id"]
                                                                    .toString(),
                                                                fromCart: false,
                                                                comesFrom: "1",
                                                              )));
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      top: (index == 0 ||
                                                              index == 1)
                                                          ? 100
                                                          : 0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Stack(
                                                        children: [
                                                          Hero(
                                                            tag: controller
                                                                .decordedResponse[
                                                                    index]
                                                                    ["image_id"]
                                                                .toString(),
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl: controller
                                                                  .decordedResponse[
                                                                      index][
                                                                      "img_url"]
                                                                  .toString(),
                                                              height: 220,
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                          InkWell(
                                                              onTap: () async {
                                                                SharedPreferences
                                                                    sharedPreferences =
                                                                    await SharedPreferences
                                                                        .getInstance();

                                                                if (sharedPreferences
                                                                        .getString(SizValue
                                                                            .isLogged)
                                                                        .toString() ==
                                                                    "null") {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              LoginPage(otpNumber: "")));
                                                                } else if (sharedPreferences
                                                                        .getString(
                                                                            SizValue.isLogged)
                                                                        .toString() ==
                                                                    "1") {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              BasicLoginInfo(fromWhere: sharedPreferences.getString(SizValue.source).toString())));
                                                                }
                                                                //  else if(sharedPreferences.getString(SizValue.isLogged).toString()=="2")
                                                                //  {

                                                                //     Navigator.push(context, MaterialPageRoute(builder: (context)=>AccountCreate()));

                                                                // }

                                                                // else if (sharedPreferences
                                                                //         .getString(SizValue
                                                                //             .underReview)
                                                                //         .toString() ==
                                                                //     "0") {
                                                                //   showReviewdialog(
                                                                //       sharedPreferences
                                                                //           .getString(SizValue
                                                                //               .underReviewMsg)
                                                                //           .toString(),
                                                                //       sharedPreferences
                                                                //           .getString(
                                                                //               SizValue.underReview)
                                                                //           .toString());
                                                                // }
                                                                
                                                                 else if (sharedPreferences
                                                                        .getString(SizValue
                                                                            .underReview)
                                                                        .toString() ==
                                                                    "2") {
                                                                  showReviewdialog(
                                                                      sharedPreferences
                                                                          .getString(SizValue
                                                                              .rejectedReviewMSG)
                                                                          .toString(),
                                                                      sharedPreferences
                                                                          .getString(
                                                                              SizValue.underReview)
                                                                          .toString());
                                                                } else if (sharedPreferences
                                                                        .getString(
                                                                            SizValue.underReview)
                                                                        .toString() ==
                                                                    "3") {
                                                                  showReviewdialog(
                                                                      sharedPreferences
                                                                          .getString(SizValue
                                                                              .incompleteMessage)
                                                                          .toString(),
                                                                      sharedPreferences
                                                                          .getString(
                                                                              SizValue.underReview)
                                                                          .toString());
                                                                } else {
                                                                  if (controller
                                                                              .decordedResponse[index]
                                                                          [
                                                                          "wishlist"] ==
                                                                      0) {
                                                                    controller.addWishlist(
                                                                        context,
                                                                        controller
                                                                            .decordedResponse[index]["id"]
                                                                            .toString(),
                                                                        index,
                                                                        "1",
                                                                        "1");
                                                                  } else {
                                                                    controller.removeWishlist(
                                                                        context,
                                                                        controller
                                                                            .decordedResponse[index]["id"]
                                                                            .toString(),
                                                                        index,
                                                                        "1",
                                                                        "1");
                                                                  }
                                                                }
                                                              },
                                                              child: Container(
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          3),
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          4),
                                                                  decoration: const BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                            color: Color.fromARGB(
                                                                                27,
                                                                                0,
                                                                                0,
                                                                                0),
                                                                            blurRadius:
                                                                                3)
                                                                      ]),
                                                                  child: SvgPicture.asset(controller.decordedResponse[index]
                                                                              [
                                                                              "wishlist"] ==
                                                                          0
                                                                      ? "assets/images/likebefore.svg"
                                                                      : "assets/images/likeafter.svg"),
                                                                ),
                                                              )),
                                                          Visibility(
                                                            visible: controller.decordedResponse[
                                                                            index]
                                                                        [
                                                                        "type"] ==
                                                                    1
                                                                ? false
                                                                : true,
                                                            child: Positioned(
                                                              bottom: 0,
                                                              left: 0,
                                                              child: Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                        .all(5),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left: 3,
                                                                        right:
                                                                            3),
                                                                decoration: const BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(50))),
                                                                child: Text(
                                                                  "MANAGED",
                                                                  style: GoogleFonts.lexendExa(
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                      color: MyColors
                                                                          .themecolor),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [
                                                          const SizedBox(
                                                              height: 5),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .only(),
                                                                  child: Text(
                                                                    controller
                                                                        .decordedResponse[
                                                                            index]
                                                                            [
                                                                            "brand_name"]
                                                                        .toString(),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: GoogleFonts
                                                                        .dmSerifDisplay(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                      fontSize:
                                                                          16,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                height: 15,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left: 5,
                                                                        right:
                                                                            5),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                constraints:
                                                                    const BoxConstraints(
                                                                        minWidth:
                                                                            20),
                                                                decoration: BoxDecoration(
                                                                    borderRadius: const BorderRadius
                                                                        .all(
                                                                        Radius.circular(
                                                                            50)),
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .black,
                                                                        width:
                                                                            1)),
                                                                child: Text(
                                                                  controller
                                                                      .decordedResponse[
                                                                          index]
                                                                          [
                                                                          "size_name"]
                                                                      .toString(),
                                                                  style: GoogleFonts.lexendDeca(
                                                                      fontSize:
                                                                          8,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          Container(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 3,
                                                                    bottom: 5),
                                                            child: Text(
                                                              controller
                                                                  .decordedResponse[
                                                                      index]
                                                                      ["title"]
                                                                  .toString(),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 1,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: GoogleFonts
                                                                  .lexendDeca(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                color: const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    97,
                                                                    97,
                                                                    97),
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 3,
                                                                    bottom: 5),
                                                            child: Text(
                                                              "RENT AED ${controller.decordedResponse[index]["rent_amount"]} | 3 DAYS",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 1,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: GoogleFonts
                                                                  .lexendExa(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                color: MyColors
                                                                    .themecolor,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 3,
                                                                    bottom: 20),
                                                            child: Text(
                                                              "Retail AED ${controller.decordedResponse[index]["retail_price"]}",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 1,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: GoogleFonts
                                                                  .lexendDeca(
                                                                decoration:
                                                                    TextDecoration
                                                                        .lineThrough,
                                                                color:
                                                                    Colors.grey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          Visibility(
                                            visible:
                                                controller.showLazyIndicator,
                                            child: Positioned(
                                              bottom: 0,
                                              child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  alignment: Alignment.center,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 20),
                                                  margin: const EdgeInsets.only(
                                                      bottom: 10),
                                                  child:
                                                      const CircularProgressIndicator()),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // bags tab 2 ========================================================================================================

                              Container(
                                margin:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: SingleChildScrollView(
                                  controller: _scrollControllerB,
                                  physics: const ClampingScrollPhysics(),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 10),
                                      Stack(
                                        children: [
                                          DynamicHeightGridView(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: controller
                                                .decordedResponsebag.length,
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 10,
                                            mainAxisSpacing: 10,
                                            builder: (context, index) {
                                              return InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ProductView(
                                                                index: index,
                                                                id: controller
                                                                    .decordedResponsebag[
                                                                        index]
                                                                        ["id"]
                                                                    .toString(),
                                                                fromCart: false,
                                                                comesFrom: "2",
                                                              )));
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      top: (index == 0 ||
                                                              index == 1)
                                                          ? 100
                                                          : 0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Stack(
                                                        children: [
                                                          Hero(
                                                            tag: controller
                                                                .decordedResponsebag[
                                                                    index]
                                                                    ["image_id"]
                                                                .toString(),
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl: controller
                                                                  .decordedResponsebag[
                                                                      index][
                                                                      "img_url"]
                                                                  .toString(),
                                                              height: 220,
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                          InkWell(
                                                              onTap: () async {
                                                                SharedPreferences
                                                                    sharedPreferences =
                                                                    await SharedPreferences
                                                                        .getInstance();

                                                                if (sharedPreferences
                                                                        .getString(SizValue
                                                                            .isLogged)
                                                                        .toString() ==
                                                                    "null") {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              LoginPage(otpNumber: "")));
                                                                } else if (sharedPreferences
                                                                        .getString(
                                                                            SizValue.isLogged)
                                                                        .toString() ==
                                                                    "1") {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              BasicLoginInfo(fromWhere: sharedPreferences.getString(SizValue.source).toString())));
                                                                }
                                                                //  else if(sharedPreferences.getString(SizValue.isLogged).toString()=="2")
                                                                //  {

                                                                //     Navigator.push(context, MaterialPageRoute(builder: (context)=>AccountCreate()));

                                                                // }

                                                                // else if (sharedPreferences
                                                                //         .getString(SizValue
                                                                //             .underReview)
                                                                //         .toString() ==
                                                                //     "0") {
                                                                //   showReviewdialog(
                                                                //       sharedPreferences
                                                                //           .getString(SizValue
                                                                //               .underReviewMsg)
                                                                //           .toString(),
                                                                //       sharedPreferences
                                                                //           .getString(
                                                                //               SizValue.underReview)
                                                                //           .toString());
                                                                // } 
                                                                
                                                                else if (sharedPreferences
                                                                        .getString(SizValue
                                                                            .underReview)
                                                                        .toString() ==
                                                                    "2") {
                                                                  showReviewdialog(
                                                                      sharedPreferences
                                                                          .getString(SizValue
                                                                              .rejectedReviewMSG)
                                                                          .toString(),
                                                                      sharedPreferences
                                                                          .getString(
                                                                              SizValue.underReview)
                                                                          .toString());
                                                                } else if (sharedPreferences
                                                                        .getString(
                                                                            SizValue.underReview)
                                                                        .toString() ==
                                                                    "3") {
                                                                  showReviewdialog(
                                                                      sharedPreferences
                                                                          .getString(SizValue
                                                                              .incompleteMessage)
                                                                          .toString(),
                                                                      sharedPreferences
                                                                          .getString(
                                                                              SizValue.underReview)
                                                                          .toString());
                                                                } else {
                                                                  if (controller
                                                                              .decordedResponsebag[index]
                                                                          [
                                                                          "wishlist"] ==
                                                                      0) {
                                                                    controller.addWishlist(
                                                                        context,
                                                                        controller
                                                                            .decordedResponsebag[index]["id"]
                                                                            .toString(),
                                                                        index,
                                                                        "2",
                                                                        "2");
                                                                  } else {
                                                                    controller.removeWishlist(
                                                                        context,
                                                                        controller
                                                                            .decordedResponsebag[index]["id"]
                                                                            .toString(),
                                                                        index,
                                                                        "2",
                                                                        "2");
                                                                  }
                                                                }
                                                              },
                                                              child: Container(
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          3),
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          4),
                                                                  decoration: const BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                            color: Color.fromARGB(
                                                                                27,
                                                                                0,
                                                                                0,
                                                                                0),
                                                                            blurRadius:
                                                                                3)
                                                                      ]),
                                                                  child: SvgPicture.asset(controller.decordedResponsebag[index]
                                                                              [
                                                                              "wishlist"] ==
                                                                          0
                                                                      ? "assets/images/likebefore.svg"
                                                                      : "assets/images/likeafter.svg"),
                                                                ),
                                                              )),
                                                          Visibility(
                                                            visible: controller.decordedResponsebag[
                                                                            index]
                                                                        [
                                                                        "type"] ==
                                                                    1
                                                                ? false
                                                                : true,
                                                            child: Positioned(
                                                              bottom: 0,
                                                              left: 0,
                                                              child: Container(
                                                                alignment: Alignment
                                                                    .bottomLeft,
                                                                margin:
                                                                    const EdgeInsets
                                                                        .all(5),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left: 3,
                                                                        right:
                                                                            3),
                                                                decoration: const BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(50))),
                                                                child: Text(
                                                                  "MANAGED",
                                                                  style: GoogleFonts.lexendExa(
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: MyColors
                                                                          .themecolor),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [
                                                          const SizedBox(
                                                              height: 5),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .only(),
                                                                  child: Text(
                                                                    controller
                                                                        .decordedResponsebag[
                                                                            index]
                                                                            [
                                                                            "brand_name"]
                                                                        .toString(),
                                                                    maxLines: 1,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: GoogleFonts
                                                                        .dmSerifDisplay(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontSize:
                                                                          16,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(5),
                                                                margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top: 5),
                                                                height: 20,
                                                                width: 0,
                                                              )
                                                            ],
                                                          ),
                                                          Container(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 3,
                                                                    bottom: 5),
                                                            child: Text(
                                                              controller
                                                                  .decordedResponsebag[
                                                                      index]
                                                                      ["title"]
                                                                  .toString(),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 1,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: GoogleFonts
                                                                  .lexendDeca(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                color: const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    97,
                                                                    97,
                                                                    97),
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 3,
                                                                    bottom: 5),
                                                            child: Text(
                                                              "RENT AED ${controller.decordedResponsebag[index]["rent_amount"]} | 8 DAYS",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 1,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: GoogleFonts.lexendExa(
                                                                  color: MyColors
                                                                      .themecolor,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300),
                                                            ),
                                                          ),
                                                          Container(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 3,
                                                                    bottom: 20),
                                                            child: Text(
                                                              "Retail AED ${controller.decordedResponsebag[index]["retail_price"]}",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 1,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: GoogleFonts.lexendDeca(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough,
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          Visibility(
                                            visible:
                                                controller.showLazyIndicator,
                                            child: Positioned(
                                              bottom: 0,
                                              child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  alignment: Alignment.center,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 20),
                                                  margin: const EdgeInsets.only(
                                                      bottom: 10),
                                                  child:
                                                      const CircularProgressIndicator()),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                        // search bar TOP ===================================================================================
                        VisibleOpacity(
                          visible: tabController.index == 0
                              ? isVisible
                              : isVisibleBags,
                          duration: const Duration(milliseconds: 500),
                          child: AnimatedContainer(
                            alignment: Alignment.topCenter,
                            curve: Curves.easeInOutCubic,
                            height: tabafterfirst ? 500 : 90,
                            margin: const EdgeInsets.only(
                                left: 15, right: 15, bottom: 20, top: 10),
                            decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                      color: Color.fromARGB(223, 218, 218, 218),
                                      blurRadius: 2,
                                      offset: Offset(0, 0))
                                ],
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white),
                            duration: const Duration(milliseconds: 500),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(width: 15),
                                    SvgPicture.asset(
                                        "assets/images/search.svg"),
                                    const SizedBox(width: 15),

                                    // textformfield search

                                    Flexible(
                                        child: TextFormField(
                                            textInputAction:
                                                TextInputAction.search,
                                            onChanged: (value) {
                                              if (value.isEmpty) {
                                                setState(() {
                                                  showarrowsearch = false;
                                                  searchInputValue = value;
                                                });
                                              } else {
                                                setState(() {
                                                  showarrowsearch = true;
                                                  searchInputValue = value;
                                                });
                                              }

                                              startTimer() {
                                                checkTypingTimer = Timer(
                                                    const Duration(
                                                        milliseconds: 600),
                                                    () async {
                                                  getSearch(value);
                                                });
                                              }

                                              checkTypingTimer?.cancel();
                                              startTimer();
                                            },
                                            onTapOutside: (event) {
                                              setState(() {
                                                FocusManager
                                                    .instance.primaryFocus
                                                    ?.unfocus();
                                              });
                                            },
                                            enableInteractiveSelection: false,
                                            onTap: () async {
                                              setState(() {
                                                tabafterfirst = true;

                                                if (searchDecordedList
                                                    .isEmpty) {
                                                  getSearch("");
                                                }
                                              });
                                            },
                                            onFieldSubmitted: (value) {
                                              if (value.isNotEmpty) {
                                                setState(() {
                                                  tabafterfirst = false;
                                                });

                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            SearchList(
                                                                searchKeyword:
                                                                    searchInputValue)));
                                              }
                                            },
                                            style: GoogleFonts.lexendDeca(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 14),

                                            // hint style
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText:
                                                  "Search for lenders, brands, colour...",
                                              hintStyle: GoogleFonts.lexendDeca(
                                                  color: const Color.fromARGB(
                                                      255, 123, 123, 123),
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 14),
                                            ))),

                                    // close button

                                    Visibility(
                                      visible: tabafterfirst ? true : false,
                                      child: InkWell(
                                          onTap: showarrowsearch
                                              ? () {
                                                  setState(() {
                                                    tabafterfirst = false;
                                                  });

                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              SearchList(
                                                                  searchKeyword:
                                                                      searchInputValue)));
                                                }
                                              : () {
                                                  setState(() {
                                                    tabafterfirst = false;
                                                  });
                                                },
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            // padding: showarrowsearch? const EdgeInsets.only(
                                            //     top: 8, bottom: 8): const EdgeInsets.only(
                                            //     top: 16, bottom: 16),
                                            height: 45,
                                            width: 45,

                                            child: showarrowsearch
                                                ? Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                            color: MyColors
                                                                .themecolor,
                                                            shape: BoxShape
                                                                .circle),
                                                    child: const Icon(
                                                      Icons
                                                          .keyboard_arrow_right_rounded,
                                                      size: 25,
                                                      color: Colors.white,
                                                    ))
                                                : SvgPicture.asset(
                                                    "assets/images/close.svg",
                                                    width: 11,
                                                    height: 11,
                                                  ),
                                          )),
                                    ),

                                    const SizedBox(width: 15)
                                  ],
                                ),

                                // list search

                                Expanded(
                                  child: searchDecordedList.isEmpty
                                      ? Center(
                                          child: Container(
                                            alignment: Alignment.center,
                                            margin:
                                                const EdgeInsets.only(top: 5),
                                            child: Text(
                                              "No suggestion found\nTap on search for better result",
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.lexendDeca(
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 12,
                                                  color: Colors.grey),
                                            ),
                                          ),
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                top: 10, bottom: 10),
                                            child: ListView.builder(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount:
                                                    searchDecordedList.length,
                                                itemBuilder: ((context, index) {
                                                  return InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      SearchList(
                                                                        searchKeyword:
                                                                            searchDecordedList[index]['word'].toString(),
                                                                      )));
                                                    },
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 20,
                                                              left: 20),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  searchDecordedList[
                                                                              index]
                                                                          [
                                                                          'word']
                                                                      .toString(),
                                                                  maxLines: 1,
                                                                  style: GoogleFonts.lexendDeca(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                      fontSize:
                                                                          14),
                                                                ),
                                                              ),
                                                              Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            10),
                                                                child: SvgPicture
                                                                    .asset(
                                                                        "assets/images/arrowright2.svg"),
                                                              ),
                                                            ],
                                                          ),
                                                          Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 10,
                                                                      bottom:
                                                                          10),
                                                              child:
                                                                  const Divider())
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                })),
                                          )),
                                ),

                                Container(
                                  margin: const EdgeInsets.only(
                                      bottom: 12, left: 15, right: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: currentTab == 0
                                            ? () {
                                                setState(() {
                                                  tabafterfirst = false;
                                                });

                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const ClothesHomeFilter()));
                                              }
                                            : () {
                                                setState(() {
                                                  tabafterfirst = false;
                                                });

                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const BagsHomeFilter()));
                                              },
                                        child: currentTab == 0
                                            ? controller.productResponse[
                                                            "filter_count"]
                                                        .toString() ==
                                                    "0"
                                                ? Wrap(
                                                    alignment:
                                                        WrapAlignment.center,
                                                    crossAxisAlignment:
                                                        WrapCrossAlignment
                                                            .center,
                                                    direction: Axis.horizontal,
                                                    children: [
                                                      SvgPicture.asset(
                                                          "assets/images/filter.svg"),
                                                      const SizedBox(width: 10),
                                                      Text(
                                                        "Filter",
                                                        style: GoogleFonts
                                                            .lexendDeca(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                fontSize: 14),
                                                      )
                                                    ],
                                                  )
                                                : badges.Badge(
                                                    badgeContent: Text(
                                                      controller.productResponse
                                                              .isEmpty
                                                          ? ""
                                                          : controller
                                                              .productResponse[
                                                                  "filter_count"]
                                                              .toString()

                                                      //  controller. productResponsebag.isEmpty?"":controller. productResponsebag["filter_count"].toString()

                                                      ,
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    child: Wrap(
                                                      alignment:
                                                          WrapAlignment.center,
                                                      crossAxisAlignment:
                                                          WrapCrossAlignment
                                                              .center,
                                                      direction:
                                                          Axis.horizontal,
                                                      children: [
                                                        SvgPicture.asset(
                                                            "assets/images/filter.svg"),
                                                        const SizedBox(
                                                            width: 10),
                                                        Text(
                                                          "Filter",
                                                          style: GoogleFonts
                                                              .lexendDeca(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  fontSize: 14),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                            : controller.productResponsebag[
                                                            "filter_count"]
                                                        .toString() ==
                                                    "0"
                                                ? Wrap(
                                                    alignment:
                                                        WrapAlignment.center,
                                                    crossAxisAlignment:
                                                        WrapCrossAlignment
                                                            .center,
                                                    direction: Axis.horizontal,
                                                    children: [
                                                      SvgPicture.asset(
                                                          "assets/images/filter.svg"),
                                                      const SizedBox(width: 10),
                                                      Text(
                                                        "Filter",
                                                        style: GoogleFonts
                                                            .lexendDeca(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                fontSize: 14),
                                                      )
                                                    ],
                                                  )
                                                : badges.Badge(
                                                    badgeContent: Text(
                                                      controller
                                                              .productResponsebag
                                                              .isEmpty
                                                          ? ""
                                                          : controller
                                                              .productResponsebag[
                                                                  "filter_count"]
                                                              .toString(),
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    child: Wrap(
                                                      alignment:
                                                          WrapAlignment.center,
                                                      crossAxisAlignment:
                                                          WrapCrossAlignment
                                                              .center,
                                                      direction:
                                                          Axis.horizontal,
                                                      children: [
                                                        SvgPicture.asset(
                                                            "assets/images/filter.svg"),
                                                        const SizedBox(
                                                            width: 10),
                                                        Text(
                                                          "Filter",
                                                          style: GoogleFonts
                                                              .lexendDeca(
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
                                      ),
                                      InkWell(
                                        onTap: currentTab == 0
                                            ? () {
                                                setState(() {
                                                  tabafterfirst = false;
                                                });

                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const FilterClothesSort()));
                                              }
                                            : () {
                                                setState(() {
                                                  tabafterfirst = false;
                                                });

                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const FilterBagsSort()));
                                              },
                                        child: Wrap(
                                          alignment: WrapAlignment.center,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          direction: Axis.horizontal,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/images/sortt.svg",
                                              height: 18,
                                              width: 14,
                                            ),
                                            const SizedBox(width: 7),
                                            Text(
                                              "Sort",
                                              style: GoogleFonts.lexendDeca(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 14),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _individualTab(String text) {
    return Container(
      // height: 50 + MediaQuery.of(context).padding.bottom,
      padding: const EdgeInsets.all(0),
      width: double.infinity,
      decoration: const BoxDecoration(
          border: Border(
              right: BorderSide(
                  color: Color.fromARGB(255, 34, 34, 34),
                  width: 1,
                  style: BorderStyle.solid))),
      child: Tab(
        text: text,
      ),
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
                                final BottomNavController controller =
                                    Get.put(BottomNavController());
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
}

class MyTabController extends TabController {
  MyTabController({
    required super.length,
    required super.vsync,
  });

  @override
  void animateTo(int value, {Duration? duration, Curve curve = Curves.ease}) {
    /// your customization
    super.animateTo(value,
        duration: const Duration(milliseconds: 600), curve: Curves.easeOutBack);
  }
}
