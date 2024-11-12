// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siz/Pages/Cart.dart';
import 'package:siz/Pages/RentDetails.dart';
import 'package:siz/Pages/Wishlist.dart';
import 'package:siz/Utils/Colors.dart';
import 'dart:io';

import 'package:siz/Utils/Value.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class MyRental extends StatefulWidget {
  const MyRental({super.key});

  @override
  State<MyRental> createState() => _MyRentalState();
}

class _MyRentalState extends State<MyRental> {



  


  Map<String, dynamic> myrentalResponse = {};
  List<dynamic> decordedMyrentalReponse = [];

    bool isLoadingMoreMRT = false;
  bool oncesCallMRT = false;
  bool noMoreDataMRT = false;
  bool showLazyIndicatorMRT = false;
   
  getmyRentals(int pageno) async {


      if (pageno <= 1) {
      dialodShow(context);
    } else {

      setState(() {

         showLazyIndicatorMRT = true;
        
      });
     
     
    }

   
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    
    try {
      final response = await http.post(Uri.parse(SizValue.myrentals), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey),

        'page':pageno.toString()
  
      });

  


     myrentalResponse = jsonDecode(response.body);

     print(myrentalResponse.toString());

      if (myrentalResponse["success"] == true) {



          if (pageno <= 1) {


          setState(() {

             decordedMyrentalReponse = myrentalResponse["list"];
            isLoadingMoreMRT = false;
            oncesCallMRT = false;
            
          });
           
           
          } else {

            setState(() {

             decordedMyrentalReponse.addAll(myrentalResponse["list"]);
            isLoadingMoreMRT = false;
            oncesCallMRT = false;
              
            });
          

            
          }

          if (myrentalResponse["list"].toString() == "[]") {

            setState(() {

            noMoreDataMRT = true;
            isLoadingMoreMRT = false;
            oncesCallMRT = false;
              
            });
          

          
          }

          if (pageno <= 1) {
            Navigator.pop(context);
          } else {

            setState(() {

              showLazyIndicatorMRT = false;
              
            });
            
           
          }


     
      } else if (myrentalResponse["success"] == false) {
        if (pageno <= 1) {
            Navigator.pop(context);
          } else {

            setState(() {

              showLazyIndicatorMRT = false;
              
            });
            
           
          }
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(myrentalResponse["error"].toString(),style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
    
      }

      
    

   
    } on ClientException {
       if (pageno <= 1) {
            Navigator.pop(context);
          } else {

            setState(() {

              showLazyIndicatorMRT = false;
              
            });
            
           
          }
      mysnackbar(
          "Server not responding please try again after sometimev fg", context);
    } on SocketException {
      if (pageno <= 1) {
            Navigator.pop(context);
          } else {

            setState(() {

              showLazyIndicatorMRT = false;
              
            });
            
           
          }
      mysnackbar(
          "No Internet connection 😑 please try again after sometime", context);
    } on HttpException {
      if (pageno <= 1) {
            Navigator.pop(context);
          } else {

            setState(() {

              showLazyIndicatorMRT = false;
              
            });
            
           
          }
      mysnackbar("Something went wrong please try after sometime", context);
    } on FormatException {
       if (pageno <= 1) {
            Navigator.pop(context);
          } else {

            setState(() {

              showLazyIndicatorMRT = false;
              
            });
            
           
          }
      mysnackbar("Something went wrong please try after sometime", context);
    }
  }


  
   firebaseEventCalled() {
    try {
      FacebookAppEvents facebookAppEvents = FacebookAppEvents();

      facebookAppEvents.logEvent(
        name: "OrderHistoryAndroid",
      );
    } catch (e) {}
  }


  @override
  initState()
  {


    firebaseEventCalled();
     _scrollControllerMRT.addListener(()async  {
    
     
      scrollListenerMRT();
    });
    getmyRentals(1);


    super.initState();
  }

  

  final ScrollController _scrollControllerMRT=ScrollController();
    int pagenoMRT=1;

    Future<void> scrollListenerMRT() async {
   
    if (isLoadingMoreMRT) return;

    _scrollControllerMRT.addListener(() {

    
      if (_scrollControllerMRT.offset >=_scrollControllerMRT.position.maxScrollExtent-200) {


        setState(() {
           isLoadingMoreMRT = true;
          
        });
           
          
          if (!oncesCallMRT) {

          if(noMoreDataMRT)
          {

            return ;

          }

          else{

            getmyRentals(++pagenoMRT);

             setState(() {

               oncesCallMRT = true;
               
             });

          }

             
            
             

          
          
          }
      }
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
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Color.fromARGB(255, 208, 208, 208),offset: Offset(0, 3),blurRadius: 3)]
            ),
            padding: const EdgeInsets.only(left: 20, right: 20,),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                   onTap: ()
                  {
      
                    Navigator.pop(context);
                  },
                  child: SvgPicture.asset("assets/images/backarrow.svg",width: 20,height: 20,)),
                Container(
                    margin: const EdgeInsets.only(left: 30),
                    child:  Text(
                      "My orders".toUpperCase(),
                    style: SizValue.toolbarStyle,
                    )),

   const SizedBox(width: 30)
                    
                // Wrap(
                //   alignment: WrapAlignment.center,
                //   crossAxisAlignment: WrapCrossAlignment.center,
                //   direction: Axis.horizontal,
                //   children: [
                //     InkWell(
                //       onTap: () {
                //         Navigator.push(context, MaterialPageRoute(builder: (context)=> Wishlist()));
                //       },
                //       child: SvgPicture.asset("assets/images/heart.svg",width: 20,height: 20,)),
                //     const SizedBox(width: 20),
                //     InkWell(
                //       onTap: () {
                //         Navigator.push(context, MaterialPageRoute(builder: (context)=>const Cart()));
                //       },
                //       child: SvgPicture.asset("assets/images/bag.svg",width: 20,height: 20,)),
                //   ],
                // )
              ],
            ),
          ),
      
      
          // my rental list =============================================================================
      
          // decordedMyrentalReponse
           

             Expanded(
               child: 
               
                             decordedMyrentalReponse.isEmpty
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
                                      child:  Text("No orders found",style: GoogleFonts.lexendDeca(
                                                    fontWeight: FontWeight.w300,color: Colors.grey,fontSize: 13))),
                                ],
                                  ):
               
                Stack(
                  children: [
                    Container(
                                margin: const EdgeInsets.only(
                                  top: 20,
                                    left: 20, right: 20, bottom: 20),
                                child: DynamicHeightGridView(
                                  physics: const ClampingScrollPhysics(),
                                  controller: _scrollControllerMRT,
                                  shrinkWrap: true,
                                  itemCount: decordedMyrentalReponse.length,
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 15,
                                  builder: (context, index) {
                                    return InkWell(
                                              onTap: () {
                                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>  RentDetails(
                                        productId: decordedMyrentalReponse[index]["id"].toString(),
                                      )));
                                              },
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  
                                                  Stack(
                                                   
                                                    children: [
                                                      Hero(
                                                        tag: decordedMyrentalReponse[index]["image_id"].toString(),
                                                        child: CachedNetworkImage(
                                                          
                                                          imageUrl:
                                                        
                                                     decordedMyrentalReponse[index]["img_url"].toString(),
                                                          height: 220,
                                                          width: MediaQuery.of(context).size.width,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      // InkWell(
                                                      //     onTap: () {
                                                      //       //  if( decordedMyrentalReponse[index]["wishlist"]==0)
                                                      //       //  {

                                                      //       // controller.addWishlist(context, decordedMyrentalReponse[index]["id"].toString(), index,"1");

                                                      //       //  }

                                                      //       //  else

                                                      //       //  {

                                                      //       //   controller.removeWishlist(context,decordedMyrentalReponse[index]["id"].toString(), index,"1");


                                                      //       //  }
                                                      //     },
                                                      //     child: Container(
                                                      //       alignment: Alignment.topRight,
                                                      //       padding:
                                                      //           const EdgeInsets.all(3),
                                                      //       margin:
                                                      //           const EdgeInsets.all(4),
                                                      //       decoration:
                                                      //           const BoxDecoration(
                                                      //               shape:
                                                      //                   BoxShape.circle,
                                                      //               boxShadow: [
                                                      //                  BoxShadow(
                                                      //                 color: Color
                                                      //                     .fromARGB(27,
                                                      //                         0, 0, 0),
                                                      //                 blurRadius: 3)
                                                      //           ]),
                                                      //       child: SvgPicture.asset(
                                                      //          decordedMyrentalReponse[index]["wishlist"]==0
                                                      //           ? "assets/images/likebefore.svg"
                                                      //           : "assets/images/likeafter.svg"),
                                                      //     )),



                                                          Visibility(

                                                            visible:decordedMyrentalReponse[index]["type"]==1?false:true,
                                                            
                                                            child: Positioned(
                                                          
                                                              bottom: 0,
                                                              left: 0,
                                                              child: Container(
                                                                margin: const EdgeInsets.all(5),
                                                              
                                                                padding: const EdgeInsets.only(left: 3,right: 3),
                                                               
                                                                decoration: const BoxDecoration(
                                                                  color: Colors.white,
                                                                  borderRadius: BorderRadius.all(Radius.circular(50))
                                                                ),
                                                               
                                                              
                                                                child: 
                                                                Text("MANAGED",style: GoogleFonts.lexendExa(
                                                                  fontSize: 10,
                                                                  fontWeight: FontWeight.w400,
                                                              
                                                                  color: MyColors.themecolor
                                                                ),),
                                                              ),
                                                            ),
                                                          )
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
                                                            CrossAxisAlignment.center,
                                                        children: [
                                                          Expanded(
                                                            child: Container(
                                                              alignment:
                                                                  Alignment.centerLeft,
                                                              margin:
                                                                  const EdgeInsets.only(),
                                                              child: Text(
                                                              decordedMyrentalReponse[index]["brand_name"].toString(),
                                                                textAlign: TextAlign.left,
                                                                maxLines: 1,
                                                                overflow: TextOverflow.ellipsis,
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

                                                           decordedMyrentalReponse[index]["category_id"].toString()=="1"?
                                                        


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
                                                                  decordedMyrentalReponse[
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

                                                        Container(
                                                            padding:
                                                                const EdgeInsets.all(5),
                                                                margin: const EdgeInsets.only(top: 5),
                                                                height: 20,
                                                                width: 10,
                                                           
                                                          
                                                          )
                                                        ],
                                                      ),
                                                      Container(
                                                        alignment: Alignment.centerLeft,
                                                        margin: const EdgeInsets.only(
                                                            top: 3,
                                                            bottom: 5),
                                                        child: Text(
                                                         decordedMyrentalReponse[index]["title"].toString(),
                                                          
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
                                                        alignment: Alignment.centerLeft,
                                                        margin: const EdgeInsets.only(
                                                            top: 3,
                                                            bottom: 5),
                                                        child: Text(
                                                          "RENT AED ${decordedMyrentalReponse[
                                                                        index]
                                                                    ["total_amount"]} | ${decordedMyrentalReponse[
                                                                        index]
                                                                    ["days"]} DAYS",
                                                          overflow:
                                                              TextOverflow.ellipsis,
                                                          maxLines: 1,
                                                          textAlign: TextAlign.left,
                                                          style: GoogleFonts.lexendExa(
                                                            fontWeight: FontWeight.w300,
                                                            color: MyColors.themecolor,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        alignment: Alignment.centerLeft,
                                                        margin: const EdgeInsets.only(
                                                            top: 3,
                                                            bottom: 20),
                                                        child: Text(
                                                         "Retail AED ${decordedMyrentalReponse[index]["retail_price"]}",
                                                          overflow:
                                                              TextOverflow.ellipsis,
                                                          maxLines: 1,
                                                          textAlign: TextAlign.left,
                                                          style: GoogleFonts.lexendDeca(
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
                                     visible: showLazyIndicatorMRT, 
                                  
                                  
                                  
                                      
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
             ),
        
      
        ],
      ),
    );
  }
}