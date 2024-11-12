// ignore_for_file: use_build_context_synchronously, unrelated_type_equality_checks, must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siz/Controllers/FilterController.dart';
import 'package:siz/Pages/Cart.dart';
import 'package:siz/Pages/ProductView.dart';

import 'dart:convert';

import 'dart:io';

import 'package:siz/Utils/Colors.dart';
import 'package:siz/Utils/Value.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';


class Wishlist extends StatefulWidget {
  String? from="";
   Wishlist({super.key,this.from});

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  


      
  @override
  void initState() {

    getWishlist();
    
     super.initState();

     
  }

  

  Map<String, dynamic> wishlistResponse = {};
  List<dynamic> decordedResponse = [];


 bool tabbedRemove=false;


  
// get wishlist data=================================================================

  getWishlist() async {



     try {
      FacebookAppEvents facebookAppEvents = FacebookAppEvents();

      facebookAppEvents.logEvent(
        name: "WishlistAndroid",
      );
    } catch (e) {}

    //  dialodShow(context);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

   


    try {
      final response = await http.post(Uri.parse(SizValue.getWishlist), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey),
      
  
      });

     

     wishlistResponse = jsonDecode(response.body);



  
      if (wishlistResponse["success"] == true) {

          //  Navigator.pop(context);


        setState(() {

            decordedResponse=wishlistResponse["list"];
          
    
          
        });
        
      
     

     
      } else if (wishlistResponse["success"] == false) {
        // Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(wishlistResponse["error"].toString(),style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
    
      }

      

   

   
    } on ClientException {
      // Navigator.pop(context);
      mysnackbar(
          "Server not responding please try again after sometimev ", context);
    } on SocketException {
      // Navigator.pop(context);
      mysnackbar(
          "No Internet connection 😑 please try again after sometime", context);
    } on HttpException {
      // Navigator.pop(context);
      mysnackbar("Something went wrong please try after sometime", context);
    } on FormatException {
      // Navigator.pop(context);
      mysnackbar("Something went wrong please try after sometime", context);
    }
  }


   Map<String, dynamic> wishlistremoveReponse = {};

  removeWishlist(
  
    String productId,
    String productType,
    int index
  
  
  ) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  
    try {
      final response = await http.post(Uri.parse(SizValue.removeWishlist), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey),
        'product': productId,
  
      });

   

     wishlistremoveReponse = jsonDecode(response.body);

      if (wishlistremoveReponse["success"] == true) {

         
      

       if(productType=="1")
       {
        
         FilterController controller=Get.put(FilterController());
         controller.pagenoC=1;
        controller.getProducts(context,"1",0,"",1);

       }

       else if(productType=="2")
       {
       
        FilterController controller=Get.put(FilterController());
        controller.pagenoB=1;
        controller.getProducts(context, "2",1,"",1);

       }
        


       

        setState(() {

            decordedResponse.removeAt(index);
            ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Item removed from your wishlist",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white)),duration: const Duration(seconds: 1),));
          
        });


      
      

     
      } else if (wishlistremoveReponse["success"] == false) {
     
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(wishlistremoveReponse["error"].toString(),style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
    
      }

      

      
   
    } on ClientException {
    
      mysnackbar(
          "Server not responding please try again after sometimev fg", context);
    } on SocketException {
    
      mysnackbar(
          "No Internet connection 😑 please try again after sometime", context);
    } on HttpException {
     
      mysnackbar("Something went wrong please try after sometime", context);
    } on FormatException {
     
      mysnackbar("Something went wrong please try after sometime", context);
    }
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
      body:  Column(
        children: [
           // top four icons ==============================================================================================
      
        Container(

          alignment: Alignment.center,
          height: 60,
         
          padding: const EdgeInsets.only(left: 20,right: 20),
          decoration: const BoxDecoration(
             color: Colors.white,
            boxShadow: [BoxShadow(
              color: Colors.grey,
              blurRadius: 2,
              offset: Offset(0, 2)
            )]
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: ()
                {

                  if(tabbedRemove)
                  {

                     Navigator.pop(context,"true");

                  }

                  else
                  {

                      Navigator.pop(context);

                  }

                 
      
                 
                },
                child: SvgPicture.asset("assets/images/backarrow.svg",width: 20,height: 20,)),
               Text(
                "Wishlist".toUpperCase(),
                 style:SizValue.toolbarStyle,
                 
              ),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                direction: Axis.horizontal,
                children: [
                 
                 InkWell(
                  onTap: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>const Cart()));
                  },
                  child: SvgPicture.asset("assets/images/bag.svg",width: 20,height: 20,)),
                ],
              )
            ],
          ),
        ),
      
      // list wishlist ================================================================================================
      


         decordedResponse.isEmpty?


          Expanded(
          
           child: Center(
            child: Text("No wishlist found",
            style:GoogleFonts.lexendDeca(

              fontSize: 14,
              fontWeight: FontWeight.w300
            ),),
           ),
         ):
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 10),
              child: DynamicHeightGridView(
                                      
                                        shrinkWrap: true,
                                        itemCount: decordedResponse.length,
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
                                                           index: 0,
                                                             comesFrom: "",
                                                            id: decordedResponse[index]["product_id"].toString(),
                                                             fromCart: false,
                                                          )));
                                            },
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                
                                                Stack(
                                                  alignment: Alignment.topRight,
                                                  children: [
                                                    Hero(
                                                      tag: decordedResponse[index]["image_id"].toString(),
                                                      child: CachedNetworkImage(
                                                        
                                                        imageUrl:
                                                      
                                                       decordedResponse[index]["img_url"].toString(),
                                                        height: 220,
                                                        width: MediaQuery.of(context).size.width,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    InkWell(
                                                        onTap: () {

                                                        

                                                        setState(() {

                                                          tabbedRemove=true;
                                                          
                                                        });

                                                          
                                                          
            
                                                        // bottomsheet(index, );

                                                        removeWishlist(decordedResponse[index]["product_id"].toString(),decordedResponse[index]["category_id"].toString(),index);
          
          
          
                                                        },
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets.all(3),
                                                          margin:
                                                              const EdgeInsets.all(4),
                                                          decoration:
                                                              const BoxDecoration(
                                                                  shape:
                                                                      BoxShape.circle,
                                                                  boxShadow: [
                                                                BoxShadow(
                                                                    color: Color
                                                                        .fromARGB(27,
                                                                            0, 0, 0),
                                                                    blurRadius: 3)
                                                              ]),
                                                          child: SvgPicture.asset(
                                                              
                                                            "assets/images/likeafter.svg"),
                                                        ))
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
                                                              decordedResponse[index]["brand_name"].toString(),
                                                                     maxLines: 1,
                                                                         overflow: TextOverflow.ellipsis,
                                                              textAlign: TextAlign.left,
                                                              style:  GoogleFonts
                                                                  .dmSerifDisplay(
                                                                color: Colors.black,
                                                                fontWeight:
                                                                    FontWeight.w400,
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                          ),
                                                        ),


                                                        decordedResponse[index]["category_id"].toString()=="1"
                                                              ?
                                                           
                                                              
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
                                                                  decordedResponse[index]["size_name"].toString(),
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
                                                        decordedResponse[index]["title"].toString(),
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

                                                        decordedResponse[index]["category_id"].toString()=="1"?



                                                        
                                                        "RENT AED ${decordedResponse[index]["rent_amount"]} | 3 DAYS":

                                                         "RENT AED ${decordedResponse[index]["rent_amount"]} | 8 DAYS",
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
                                                       "Retail AED ${decordedResponse[index]["retail_price"]}",
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
          ),
      
        ],
      )
      ,
    );
  }

     
bottomsheet(int index,String productType) {
  return

      // logut yes or no

      showModalBottomSheet(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          context: context,
          builder: (context) {
           

            


          return  Wrap(children: [
                Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 20),
                    
                    child: Column(
                      children: [

                           Container(
                    margin: const EdgeInsets.only(top: 0,bottom: 10),
                    width: 35,
                    height: 2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: const Color(0xff9D9D9D)),
                  ),
                         Container(
                          margin: const EdgeInsets.only(left: 10,right:10),
                           child: Text(
                            "Do you really want to remove this item from your wishlist?",
                            textAlign: TextAlign.center,
                            style:  GoogleFonts.lexendDeca(
                              color:Colors.black,
                              fontSize: 15,
                             
                              fontWeight: FontWeight.w300),
                                                 ),
                         ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 40,
                                padding: const EdgeInsets.only(left: 20,right:20),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(5)
                                ),
                                child: Text(
                                  "No".toUpperCase(),
                                  style: GoogleFonts.lexendExa(
                                color: Colors.white,
                                fontSize: 16,
                                
                                fontWeight: FontWeight.w300),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            InkWell(
                              onTap: () {


                                
                                     
                                     Navigator.pop(context);
                              },
                              child: Container(
                                 alignment: Alignment.center,
                                height: 40,
                                padding: const EdgeInsets.only(left: 20,right:20),
                                decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(5)
                                ),
                                child: Text(
                                  "Yes".toUpperCase(),
                                  style:  GoogleFonts.lexendExa(
                                color: Colors.white,
                                fontSize: 16,
                                
                                fontWeight: FontWeight.w300),
                                ),
                              ),
                            )
                          ],
                        ),

                          const SizedBox(height: 10),
                      ],
                    )),
              ]);






          });
}
}