// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:siz/Controllers/BottomNavController.dart';
import 'package:siz/Controllers/ProfileController.dart';
import 'package:siz/Pages/Cart.dart';
import 'package:siz/Pages/Home.dart';
import 'package:siz/Pages/ManageItem.dart';
import 'package:siz/Pages/MyProfile.dart';

import 'package:siz/Pages/Wishlist.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:siz/Utils/Colors.dart';

import 'package:siz/Utils/Value.dart';


class MyListing extends StatefulWidget {
  bool fromListing = false;
  int initialIndex=0;
  MyListing({super.key, required this.fromListing,required this.initialIndex});

  @override
  State<MyListing> createState() => _MyListingState();
}

class _MyListingState extends State<MyListing> {
  String profileName = "";
  String profileImage = "";

  profileController controller=Get.put(profileController());

  getProfleValue() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      profileName =
          "${sharedPreferences.getString(SizValue.firstname)} ${sharedPreferences.getString(SizValue.lastname)}";
      profileImage = sharedPreferences.getString(SizValue.profile).toString();
    });
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

  // approved lazyload




  final ScrollController _scrollControllerA=ScrollController();
    int pagenoA=1;

    Future<void> scrollListenerA() async {
   
    if (controller. isLoadingMoreA) return;

    _scrollControllerA.addListener(() {

    
      if (_scrollControllerA.offset >=_scrollControllerA.position.maxScrollExtent-300) {


        setState(() {
          controller.  isLoadingMoreA = true;
          
        });
           
          
          if (!controller. oncesCallA) {

            if(controller. noMoreDataA)
            {
              return;
            }

            else
            {

              
            controller. getProducts(context, "2", ++pagenoA);

             setState(() {

              controller.  oncesCallA = true;
               
             });

            }

          
            
             

          
          
          }
      }
    });
  }
 // rejected lazyload ==========================================================

  final ScrollController _scrollControllerR=ScrollController();
    int pagenoR=1;

    Future<void> scrollListenerR() async {
   
    if (controller. isLoadingMoreR) return;

    _scrollControllerR.addListener(() {

    
      if (_scrollControllerR.offset >=_scrollControllerR.position.maxScrollExtent-300) {


        setState(() {
         controller.   isLoadingMoreR = true;
          
        });
           
          
          if (!controller. oncesCallR) {

            if(controller. noMoreDataR)
            {
              return;
            }

            else
            {

                
           controller.  getProducts(context, "3", ++pagenoR);

             setState(() {

              controller.  oncesCallR = true;
               
             });

            }

        
            
             

          
          
          }
      }
    });
  }
 // pending lazyload ==========================================================

  final ScrollController _scrollControllerP=ScrollController();
    int pagenoP=1;

    Future<void> scrollListenerP() async {
   
    if (controller. isLoadingMoreP) return;

    _scrollControllerP.addListener(() {

    
      if (_scrollControllerP.offset >=_scrollControllerP.position.maxScrollExtent-200) {


        setState(() {
          controller.  isLoadingMoreP = true;
          
        });
           
          
          if (!controller. oncesCallP) {

            if(controller. noMoreDataP)
            {
              return;
            }

            else
            {

                
           controller.  getProducts(context, "1", ++pagenoP);

             setState(() {

              controller.  oncesCallP = true;
               
             });
            

            }

        
             

          
          
          }
      }
    });
  }

  @override
  void initState() {



     _scrollControllerA.addListener(()async  {
    
     
      scrollListenerA();
    });
     _scrollControllerP.addListener(()async  {
    
     
      scrollListenerP();
    });
     _scrollControllerR.addListener(()async  {
    
     
      scrollListenerR();
    });

    if(widget.initialIndex==0){

     controller.  getProducts(context,  "2", 1);


    }

    else if(widget.initialIndex==1)
    {

     controller.    getProducts(context, "1",1);

    }

    else{

     controller.   getProducts(context, "3", 1);

    }
    
    getProfleValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.fromListing) {
          BottomNavController bottomNavController =
              Get.put(BottomNavController());
          bottomNavController.updateIndex(0);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Home()),
              (route) => false);
          return false;
        } else {
          return true;
        }
      },
      child: GetBuilder(
        init: profileController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              toolbarHeight: 0,
            ),
            backgroundColor: Colors.white,
            body: Column(
              children: [
                // top four icons ==============================================================================================

                Container(
                  alignment: Alignment.center,
                  height: 60,
                  padding: const EdgeInsets.only(
                    left: 20, right: 20),
                  decoration: const BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(255, 211, 211, 211),
                        blurRadius: 2,
                        offset: Offset(0, 3))
                  ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap: () {
                            if (widget.fromListing) {
                              BottomNavController bottomNavController =
                                  Get.put(BottomNavController());
                              bottomNavController.updateIndex(0);
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Home()),
                                  (route) => false);
                            } else {
                              Navigator.pop(context);
                            }
                          },
                          child: SvgPicture.asset("assets/images/backarrow.svg",width: 20,height: 20,)),
                      Container(
                          margin: const EdgeInsets.only(left: 30),
                          child:  Text(
                            "My Listings".toUpperCase(),
                          style:SizValue.toolbarStyle
                          )),
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        direction: Axis.horizontal,
                        children: [
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>  Wishlist()));
                              },
                              child: SvgPicture.asset("assets/images/heart.svg",width: 20,height: 20,)),
                          const SizedBox(width: 20),
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Cart()));
                              },
                              child: SvgPicture.asset("assets/images/bag.svg",width: 20,height: 20,)),
                        ],
                      )
                    ],
                  ),
                ),

                // Body ======================================================================================

                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const MyProfile()));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 15, top: 20),
                    child: Row(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                         
                          decoration: const BoxDecoration(
                              
                              shape: BoxShape.circle),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(1000),
                            child: CachedNetworkImage(
                              imageUrl: profileImage,
                              fit: BoxFit.cover,
                              height: 55,
                              width: 55,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          profileName,
                          style: GoogleFonts.lexendDeca(color: Colors.black,fontWeight: FontWeight.w300, fontSize: 19),
                        )
                      ],
                    ),
                  ),
                ),

                // tab bar =============================================================================

                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    child: DefaultTabController(
                      length: 3,
                      initialIndex: widget.initialIndex,
                      child: Column(
                        children: [
                          ButtonsTabBar(
                            
                            onTap: (value) {
                              if (value == 0) {


                                setState(() {

                                  pagenoA=1;
                                  
                                });
                               controller.  getProducts(context, "2", 1);
                               

                               

                        
                              } 
                              
                              else if (value == 1) {
                              


                              
                                setState(() {

                                  pagenoP=1;
                                  
                                });

                              controller.    getProducts(context, "1", 1);


                               
                              }
                              
                              else if (value == 2) {


                                
                                setState(() {

                                  pagenoR=1;
                                  
                                });

                                controller.  getProducts(context, "3", 1);
                              
                              }
                            },
                            radius: 10,
                            buttonMargin: const EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 5),
                            contentPadding:
                                const EdgeInsets.only(left: 20, right: 20),
                            backgroundColor: Colors.black,
                            unselectedBackgroundColor: const Color(0xffF6F5F1),
                            unselectedLabelStyle: GoogleFonts.lexendDeca(
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                            ),
                            labelStyle: GoogleFonts.lexendDeca(
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                            ),
                            tabs: const [
                              Tab(
                                text: "APPROVED",
                              ),
                              Tab(
                                text: "PENDING",
                              ),
                              Tab(
                                text: "REJECTED",
                              ),
                            ],
                          ),
                          Expanded(
                              child: TabBarView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                // tab one=======================================================================================================

                               controller.  decordedapproveReponse.isEmpty
                                    ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      LottieBuilder.asset(
                                        "assets/images/notfound.json",
                                        height: 200,
                                      ),
                                      Container(
                                          margin: const EdgeInsets.only(
                                              bottom: 70, top: 10),
                                          child: const Text("No data found")),
                                    ],
                                      ):Stack(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                left: 20,
                                                right: 20,
                                                top: 10,
                                                bottom: 15),
                                            child: DynamicHeightGridView(
                                               physics: const ClampingScrollPhysics(),
                                              controller:_scrollControllerA,
                                              shrinkWrap: true,
                                              itemCount:controller.  decordedapproveReponse.length,
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 15,
                                              mainAxisSpacing: 10,
                                              builder: (context, index) {
                                                return InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>  ManageItem(productID:controller.  decordedapproveReponse[index]["id"].toString())
                                                                                    ));
                                                  },
                                                   child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Stack(
                                                        children: [
                                                          CachedNetworkImage(
                                                            imageUrl:
                                                             controller.    decordedapproveReponse[
                                                                            index]
                                                                        ["img_url"]
                                                                    .toString(),
                                                            height: 220,
                                                            width:
                                                                MediaQuery.of(context)
                                                                    .size
                                                                    .width,
                                                            fit: BoxFit.cover,
                                                          ),
                                                          Visibility(
                                                            visible:controller.  decordedapproveReponse[
                                                                                index]
                                                                            ["type"]
                                                                        .toString() ==
                                                                    "1"
                                                                ? false
                                                                : true,
                                                            child: Positioned(
                                                              bottom: 0,
                                                              left: 0,
                                                              child: Container(
                                                                margin: const EdgeInsets
                                                                    .all(5),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left: 3,
                                                                        right: 3),
                                                                decoration: const BoxDecoration(
                                                                    color: Colors.white,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .all(Radius
                                                                                .circular(
                                                                                    50))),
                                                                child: Text(
                                                                  "MANAGED",
                                                                  style: GoogleFonts
                                                                      .lexendExa(
                                                                          fontSize: 10,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w400,
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
                                                          const SizedBox(height: 5),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [

                                                              Expanded(
                                                                child: Container(
                                                                  alignment: Alignment
                                                                      .centerLeft,
                                                                  margin: const EdgeInsets
                                                                      .only(),
                                                                  child: Text(
                                                                   controller.  decordedapproveReponse[
                                                                                index]
                                                                            ["brand_name"]
                                                                        .toString(),

                                                                 
                                                                        maxLines: 1,
                                                                        overflow: TextOverflow.ellipsis,
                                                                    textAlign:
                                                                        TextAlign.left,
                                                                    style: GoogleFonts
                                                                          .dmSerifDisplay(
                                                                        color: Colors.black,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        fontSize: 16,
                                                                      ),
                                                                  ),
                                                                 ),
                                                              ),

                                                             controller.   decordedapproveReponse[index]["category_id"].toString()=="1"?
                                                             


                                                                Container(
                                                                height: 15,
                                                                padding: const EdgeInsets.only(left: 5,right: 5),
                                                                alignment: Alignment.center,
                                                                constraints: const BoxConstraints(minWidth: 20),
                                                               
                                                                decoration: BoxDecoration(
                                                                   borderRadius: const BorderRadius.all(Radius.circular(50)),
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .black,
                                                                        width:
                                                                            1)),
                                                                child: Text(
                                                                   controller.  decordedapproveReponse[
                                                                              index]
                                                                          ["size_name"]
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


                                                              :

                                                              const SizedBox(
                                                                width: 23,
                                                                height: 23,
                                                              )
                                                            ],
                                                          ),
                                                          Container(
                                                            alignment:
                                                                Alignment.centerLeft,
                                                            margin:
                                                                const EdgeInsets.only(
                                                                    top: 3,
                                                                    bottom: 5),
                                                            child: Text(
                                                            controller.   decordedapproveReponse[
                                                                      index]["title"]
                                                                  .toString(),
                                                              overflow:
                                                                  TextOverflow.ellipsis,
                                                              maxLines: 1,
                                                              textAlign: TextAlign.left,
                                                              style:  GoogleFonts.lexendDeca(
                                                                fontWeight: FontWeight.w300,
                                                                color: const Color.fromARGB(255, 97, 97, 97),
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            alignment:
                                                                Alignment.centerLeft,
                                                            margin:
                                                                const EdgeInsets.only(
                                                                    top: 3,
                                                                    bottom: 5),
                                                            child: Text(


                                                             controller.  decordedapproveReponse[index]["category_id"].toString()=="1"?
                                                              "RENT AED ${controller. decordedapproveReponse[index]["rent_amount"].toString()} | 3 DAYS":
                                                              "RENT AED ${controller. decordedapproveReponse[index]["rent_amount"].toString()} | 8 DAYS",
                                                              overflow:
                                                                  TextOverflow.ellipsis,
                                                              maxLines: 1,
                                                              textAlign: TextAlign.left,
                                                              style:
                                                                GoogleFonts.lexendExa(
                                                                fontWeight: FontWeight.w300,
                                                                color: MyColors.themecolor,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            alignment:
                                                                Alignment.centerLeft,
                                                            margin:
                                                                const EdgeInsets.only(
                                                                    top: 3,
                                                                    bottom: 20),
                                                            child: Text(
                                                              "Retail AED ${controller. decordedapproveReponse[index]["retail_price"].toString()}",
                                                              overflow:
                                                                  TextOverflow.ellipsis,
                                                              maxLines: 1,
                                                              textAlign: TextAlign.left,
                                                              style:
                                                                   GoogleFonts.lexendDeca(
                                                                decoration: TextDecoration
                                                                    .lineThrough,
                                                                color: Colors.grey,
                                                                fontWeight: FontWeight.w300,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),

                                           
                                                Visibility(
                                        visible:controller.  showLazyIndicator,
                                      
                                          
                                          child: Positioned(
                                           bottom: 0,
                                          
                                            child: Container(
                                              width: MediaQuery.of(context).size.width,
                                              alignment: Alignment.center,
                                              padding: const EdgeInsets.only(right: 20),
                                              margin: const EdgeInsets.only(bottom: 10),
                                              child: const CircularProgressIndicator()),
                                          ),
                                        )

                                        ],
                                      ),

                                // tab two =======================================================================================================
                              controller.   decordedpendingResponse.isEmpty
                                    ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      LottieBuilder.asset(
                                        "assets/images/notfound.json",
                                        height: 200,
                                      ),
                                      Container(
                                          margin: const EdgeInsets.only(
                                              bottom: 70, top: 10),
                                          child: const Text("No data found")),
                                    ],
                                      )
                                    : Stack(
                                      children: [
                                        Container(
                                            margin: const EdgeInsets.only(
                                                left: 20,
                                                right: 20,
                                                top: 10,
                                                bottom: 15),
                                            child: DynamicHeightGridView(
                                              physics: const ClampingScrollPhysics(),
                                              controller:_scrollControllerP,
                                              shrinkWrap: true,
                                              itemCount:controller.  decordedpendingResponse.length,
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 15,
                                              mainAxisSpacing: 10,
                                              builder: (context, index) {
                                                return InkWell(
                                                  onTap: () {
                                                    // Navigator.push(
                                                    //     context,
                                                    //     MaterialPageRoute(
                                                    //         builder: (context) =>
                                                    //             ProductView(
                                                    //               herotag: controller.decordedResponse[index]["image_id"].toString(),

                                                    //               id: controller.decordedResponse[index]["id"].toString(),
                                                    //             )));
                                                  },
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Stack(
                                                        children: [
                                                          CachedNetworkImage(
                                                            imageUrl:
                                                              controller.   decordedpendingResponse[
                                                                            index]
                                                                        ["img_url"]
                                                                    .toString(),
                                                            height: 220,
                                                            width:
                                                                MediaQuery.of(context)
                                                                    .size
                                                                    .width,
                                                            fit: BoxFit.cover,
                                                          ),
                                                          Visibility(
                                                            visible:
                                                                controller. decordedpendingResponse[
                                                                                    index]
                                                                                ["type"]
                                                                            .toString() ==
                                                                        "1"
                                                                    ? false
                                                                    : true,
                                                            child: Positioned(
                                                              bottom: 0,
                                                              left: 0,
                                                              child: Container(
                                                                margin: const EdgeInsets
                                                                    .all(5),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left: 3,
                                                                        right: 3),
                                                                decoration: const BoxDecoration(
                                                                    color: Colors.white,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .all(Radius
                                                                                .circular(
                                                                                    50))),
                                                                child: Text(
                                                                  "MANAGED",
                                                                  style: GoogleFonts
                                                                      .lexendExa(
                                                                           fontSize: 10,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w400,
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
                                                          const SizedBox(height: 5),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Expanded(
                                                                child: Container(
                                                                  alignment: Alignment
                                                                      .centerLeft,
                                                                  margin: const EdgeInsets
                                                                      .only(),
                                                                  child: Text(
                                                                   controller.  decordedpendingResponse[
                                                                                index]
                                                                            ["brand_name"]
                                                                        .toString(),
                                                                        maxLines: 1,
                                                                        overflow: TextOverflow.ellipsis,
                                                                    textAlign:
                                                                        TextAlign.left,
                                                                    style:GoogleFonts
                                                                          .dmSerifDisplay(
                                                                        color: Colors.black,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        fontSize: 16,
                                                                      ),
                                                                  ),
                                                                ),
                                                              ),

                                                                controller. decordedpendingResponse[index]["category_id"].toString()=="1"?
                                                             



                                                               Container(
                                                                height: 15,
                                                                padding: const EdgeInsets.only(left: 5,right: 5),
                                                                alignment: Alignment.center,
                                                                constraints: const BoxConstraints(minWidth: 20),
                                                               
                                                                decoration: BoxDecoration(
                                                                   borderRadius: const BorderRadius.all(Radius.circular(50)),
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .black,
                                                                        width:
                                                                            1)),
                                                                child: Text(
                                                                   controller.   decordedpendingResponse[
                                                                              index]
                                                                          ["size_name"]
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
                                                              
                                                              
                                                              
                                                              
                                                              :

                                                              const SizedBox(width: 23,height: 23,)
                                                            ],
                                                          ),
                                                          Container(
                                                            alignment:
                                                                Alignment.centerLeft,
                                                            margin:
                                                                const EdgeInsets.only(
                                                                    top: 3,
                                                                    bottom: 5),
                                                            child: Text(
                                                            controller.   decordedpendingResponse[
                                                                      index]["title"]
                                                                  .toString(),
                                                              overflow:
                                                                  TextOverflow.ellipsis,
                                                              maxLines: 1,
                                                              textAlign: TextAlign.left,
                                                              style: GoogleFonts.lexendDeca(
                                                                fontWeight: FontWeight.w300,
                                                                color: const Color.fromARGB(255, 97, 97, 97),
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            alignment:
                                                                Alignment.centerLeft,
                                                            margin:
                                                                const EdgeInsets.only(
                                                                    top: 3,
                                                                    bottom: 5),
                                                            child: Text(

                                                               controller.  decordedpendingResponse[index]["category_id"].toString()=="1"?
                                                              "RENT AED ${controller. decordedpendingResponse[index]["rent_amount"].toString()} | 3 DAYS":
                                                              "RENT AED ${controller. decordedpendingResponse[index]["rent_amount"].toString()} | 8 DAYS",
                                                              overflow:
                                                                  TextOverflow.ellipsis,
                                                              maxLines: 1,
                                                              textAlign: TextAlign.left,
                                                              style:
                                                                 GoogleFonts.lexendExa(
                                                                fontWeight: FontWeight.w300,
                                                                color: MyColors.themecolor,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            alignment:
                                                                Alignment.centerLeft,
                                                            margin:
                                                                const EdgeInsets.only(
                                                                    top: 3,
                                                                    bottom: 20),
                                                            child: Text(
                                                              "Retail AED ${controller. decordedpendingResponse[index]["retail_price"].toString()}",
                                                              overflow:
                                                                  TextOverflow.ellipsis,
                                                              maxLines: 1,
                                                              textAlign: TextAlign.left,
                                                              style:
                                                                  GoogleFonts.lexendDeca(
                                                                decoration: TextDecoration
                                                                    .lineThrough,
                                                                color: Colors.grey,
                                                                fontWeight: FontWeight.w300,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),

                                              Visibility(
                                        visible: controller. showLazyIndicator,
                                      
                                          
                                          child: Positioned(
                                           bottom: 0,
                                          
                                            child: Container(
                                              width: MediaQuery.of(context).size.width,
                                              alignment: Alignment.center,
                                              padding: const EdgeInsets.only(right: 20),
                                              margin: const EdgeInsets.only(bottom: 10),
                                              child: const CircularProgressIndicator()),
                                          ),
                                        )
                                      ],
                                    ),

                                // tab three =====================================================================================================

                               controller.  decordedrejectedReponse.isEmpty
                                    ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      LottieBuilder.asset(
                                        "assets/images/notfound.json",
                                        height: 200,
                                      ),
                                      Container(
                                          margin: const EdgeInsets.only(
                                              bottom: 70, top: 10),
                                          child: const Text("No data found")),
                                    ],
                                      )
                                    : Stack(
                                      children: [
                                        Container(
                                            margin: const EdgeInsets.only(
                                                left: 20, right: 20, top: 10),
                                            child: DynamicHeightGridView(
                                              physics: const ClampingScrollPhysics(),
                                              controller:_scrollControllerR,
                                              shrinkWrap: true,
                                              itemCount:controller.  decordedrejectedReponse.length,
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 15,
                                              mainAxisSpacing: 10,
                                              builder: (context, index) {
                                                return InkWell(
                                                  onTap: () {
                                                   
                                                  },
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Stack(
                                                        children: [
                                                          CachedNetworkImage(
                                                            imageUrl:
                                                              controller.   decordedrejectedReponse[
                                                                            index]
                                                                        ["img_url"]
                                                                    .toString(),
                                                            height: 220,
                                                            width:
                                                                MediaQuery.of(context)
                                                                    .size
                                                                    .width,
                                                            fit: BoxFit.cover,
                                                          ),
                                                          Visibility(
                                                            visible:
                                                               controller.  decordedrejectedReponse[
                                                                                    index]
                                                                                ["type"]
                                                                            .toString() ==
                                                                        "1"
                                                                    ? false
                                                                    : true,
                                                            child: Positioned(
                                                              bottom: 0,
                                                              left: 0,
                                                              child: Container(
                                                                margin: const EdgeInsets
                                                                    .all(5),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left: 3,
                                                                        right: 3),
                                                                decoration: const BoxDecoration(
                                                                    color: Colors.white,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .all(Radius
                                                                                .circular(
                                                                                    50))),
                                                                child: Text(
                                                                  "MANAGED",
                                                                  style: GoogleFonts
                                                                      .lexendExa(
                                                                          fontSize: 10,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w400,
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
                                                          const SizedBox(height: 5),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Expanded(
                                                                child: Container(
                                                                  alignment: Alignment
                                                                      .centerLeft,
                                                                  margin: const EdgeInsets
                                                                      .only(),
                                                                  child: Text(
                                                                  controller.   decordedrejectedReponse[
                                                                                index]
                                                                            ["brand_name"]
                                                                        .toString(),
                                                                        maxLines: 1,
                                                                        overflow: TextOverflow.ellipsis,
                                                                    textAlign:
                                                                        TextAlign.left,
                                                                    style: GoogleFonts
                                                                          .dmSerifDisplay(
                                                                        color: Colors.black,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        fontSize: 16,
                                                                      ),
                                                                  ),
                                                                ),
                                                              ),

                                                              controller.  decordedrejectedReponse[index]["category_id"].toString()=="1"?
                                                             
                                                              

                                                              
                                                               Container(
                                                                height: 15,
                                                                padding: const EdgeInsets.only(left: 5,right: 5),
                                                                alignment: Alignment.center,
                                                                constraints: const BoxConstraints(minWidth: 20),
                                                               
                                                                decoration: BoxDecoration(
                                                                   borderRadius: const BorderRadius.all(Radius.circular(50)),
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .black,
                                                                        width:
                                                                            1)),
                                                                child: Text(
                                                                  controller.  decordedrejectedReponse[
                                                                              index]
                                                                          ["size_name"]
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
                                                            
                                                              
                                                              :

                                                              const SizedBox(width: 23,height: 23,)
                                                            ],
                                                          ),
                                                          Container(
                                                            alignment:
                                                                Alignment.centerLeft,
                                                            margin:
                                                                const EdgeInsets.only(
                                                                    top: 3,
                                                                    bottom: 5),
                                                            child: Text(
                                                             controller.  decordedrejectedReponse[
                                                                      index]["title"]
                                                                  .toString(),
                                                              overflow:
                                                                  TextOverflow.ellipsis,
                                                              maxLines: 1,
                                                              textAlign: TextAlign.left,
                                                              style: GoogleFonts.lexendDeca(
                                                                fontWeight: FontWeight.w300,
                                                                color: const Color.fromARGB(255, 97, 97, 97),
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            alignment:
                                                                Alignment.centerLeft,
                                                            margin:
                                                                const EdgeInsets.only(
                                                                    top: 3,
                                                                    bottom: 5),
                                                            child: Text(
                                                              controller.   decordedrejectedReponse[index]["category_id"].toString()=="1"?
                                                              "RENT AED ${controller. decordedrejectedReponse[index]["rent_amount"].toString()} | 3 DAYS":
                                                              "RENT AED ${controller. decordedrejectedReponse[index]["rent_amount"].toString()} | 8 DAYS",
                                                              overflow:
                                                                  TextOverflow.ellipsis,
                                                              maxLines: 1,
                                                              textAlign: TextAlign.left,
                                                              style:
                                                                   GoogleFonts.lexendExa(
                                                                fontWeight: FontWeight.w300,
                                                                color: MyColors.themecolor,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            alignment:
                                                                Alignment.centerLeft,
                                                            margin:
                                                                const EdgeInsets.only(
                                                                    top: 3,
                                                                    bottom: 20),
                                                            child: Text(
                                                              "Retail AED ${controller. decordedrejectedReponse[index]["retail_price"].toString()}",
                                                              overflow:
                                                                  TextOverflow.ellipsis,
                                                              maxLines: 1,
                                                              textAlign: TextAlign.left,
                                                              style:
                                                                 GoogleFonts.lexendDeca(
                                                                decoration: TextDecoration
                                                                    .lineThrough,
                                                                color: Colors.grey,
                                                                fontWeight: FontWeight.w300,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),


                                          
                                              Visibility(
                                        visible:controller.  showLazyIndicator,
                                      
                                          
                                          child: Positioned(
                                           bottom: 0,
                                          
                                            child: Container(
                                              width: MediaQuery.of(context).size.width,
                                              alignment: Alignment.center,
                                              padding: const EdgeInsets.only(right: 20),
                                              margin: const EdgeInsets.only(bottom: 10),
                                              child: const CircularProgressIndicator()),
                                          ),
                                        )
                                      ],
                                    ),
                              ]))
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}
