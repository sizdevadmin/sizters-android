// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:info_popup/info_popup.dart';
import 'package:lottie/lottie.dart';
import 'package:siz/Controllers/CartPromoController.dart';
import 'package:siz/Pages/ProductView.dart';
import 'package:siz/Pages/Promocode.dart';
import 'package:siz/Pages/ShoppingPaymentSummery.dart';
import 'package:siz/Pages/Wishlist.dart';
import 'package:siz/Utils/Colors.dart';
import 'package:siz/Utils/Value.dart';
import 'package:url_launcher/url_launcher.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  bool damageProtection = false;
  late CartPromoController controller;

  @override
  void initState() {

    print("herjkhoreihjio");
    controller = Get.put(CartPromoController());
    controller.appliedPromoCode = "";
    controller.forseUpdate();
    controller.getCart(context);
    super.initState();
  }

  String inputCoupon = "";

  bool renterTermsCheck=false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.appliedPromoCode = "";
        controller.forseUpdate();
        Navigator.pop(context);

        return false;
      },
      child: GetBuilder(
          init: CartPromoController(),
          builder: (controller) {
            return 
            
            // if cart is empty =====================================

             controller.decordedReponse.isEmpty?
            
            Scaffold(
              backgroundColor: Colors.white,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [


                Image.asset("assets/images/cartempty.png",
                width: 200,
                height: 200,
                
                ),

                Container(
                  alignment: Alignment.center,
                  child: Text("Your cart is empty",
                  textAlign: TextAlign.center,
                  style:GoogleFonts.lexendDeca(
                    fontSize: 17,
                    fontWeight: FontWeight.w300,
                    color: Colors.black



                  )),
                ),

                Container(
                  margin: const EdgeInsets.only(top: 5),
                  alignment: Alignment.center,
                  child: Text("Why don’t you try something\nfrom our shop?",
                  textAlign: TextAlign.center,
                  style:GoogleFonts.lexendDeca(
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                    color: Colors.grey
                  )),
                ),


                  InkWell(
                          onTap: () {

                            Navigator.pop(context);

                             
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(
                                left: 30, right: 30, top: 40),
                          height: 40,
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                                color: Colors.black,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: Text(
                              "GO BACK",
                              style: GoogleFonts.lexendExa(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        )





                ],
              ),
            ):



            // else =====================================
            
             Scaffold(

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
                   
                    decoration:
                        const BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(255, 197, 197, 197),
                          blurRadius: 2,
                          offset: Offset(0, 3))
                    ]),
                    padding: const EdgeInsets.only(
                        left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                             onTap: () {
                              controller.appliedPromoCode = "";
                              controller.forseUpdate();

                              Navigator.pop(context);
                            },
                            child: SvgPicture.asset(
                                "assets/images/backarrow.svg",width: 20,height: 20,)),
                        Container(
                            margin: const EdgeInsets.only(),
                            child:  Text(
                              "Cart".toUpperCase(),
                                style: SizValue.toolbarStyle,
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
                                          builder: (context) =>
                                               Wishlist()));
                                },
                                child: SvgPicture.asset(
                                    "assets/images/heart.svg",width: 20,height: 20,)),
                          ],
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // list of cart===================================================================================================
                  
                 

                  Expanded(
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: controller.decordedReponse.length,
                        itemBuilder: (context, index) {
                          return Container(
                            
                            margin: const EdgeInsets.only(bottom: 5),
                            padding:  EdgeInsets.only(
                                left: 20, right: 20,top: index==0?10:0),
                          
                            child: Column(

                              
                              children: [
                                Stack(
                                  children: [
                                    
                                    InkWell(
                                      onTap: () {
                                       Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductView( index: 0, comesFrom: "", id: controller.decordedReponse[index]["product_id"].toString(), fromCart: true,)));

                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                                            child: CachedNetworkImage(
                                              imageUrl: controller.decordedReponse[index]
                                                      ["img_url"]
                                                  .toString(),
                                              width: 120,
                                              height: 150,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                    
                                          const SizedBox(width: 10,),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // heading
                                                Row(
                                                  children: [
                                                    Flexible(
                                                      child: SizedBox(
                                                        width: MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                        child: Text(
                                                          controller
                                                              .decordedReponse[index]
                                                                  ["brand_name"]
                                                              .toString(),

                                                        
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                          style:
                                                              GoogleFonts.dmSerifDisplay(
                                                                fontWeight: FontWeight.w400,
                                                                  color:
                                                                      MyColors.themecolor,
                                                                  fontSize: 18),
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                        onTap: () {
                                                          bottomsheet(index);
                                                        },
                                                        child: const Icon(Icons.close,size: 20,))
                                                  ],
                                                ),
                                                              
                                                const SizedBox(height: 3),
                                                              
                                                // dress details row
                                                              
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    SizedBox(
                                                      width: 120,
                                                      child: Text(
                                                        controller.decordedReponse[index]
                                                                ["title"]
                                                            .toString(),
                                                        overflow: TextOverflow.ellipsis,
                                                        style:
                                                            GoogleFonts.lexendDeca(fontSize: 12,fontWeight: FontWeight.w300,color: Colors.black),
                                                      ),
                                                    ),


                                                    
                                                    Visibility(
                                                      visible: controller.decordedReponse[index]["category_id"].toString()=="2"?false:true,
                                                      child: 


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
                                                                   controller.decordedReponse[index]
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


         


                                                    ),
                                                  ],
                                                ),



                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [

                                                     Container(
                                                    constraints: const BoxConstraints(
                                                      maxWidth: 120,
                                                    ),
                                                  
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                  
                                                                      
                                                  const SizedBox(height: 10),
                                                  
                                                   Text(
                                                      "RENTAL PERIOD",
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    style:  GoogleFonts.lexendExa(fontSize: 12,fontWeight: FontWeight.w300,color: Colors.black),
                                                  ),
                                                
                                                  const SizedBox(height: 5),
                                                                
                                                                                              
                                                                
                                                  Text(
                                                      "Start date:",
                                                       maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    style:  GoogleFonts.lexendDeca(fontSize: 12,fontWeight: FontWeight.w300,color: Colors.black),
                                                  ),
                                                
                                                  const SizedBox(height: 5),
                                                                
                                                  Text(
                                                      "End date:",
                                                       maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    style:  GoogleFonts.lexendDeca(fontSize: 12,fontWeight: FontWeight.w300,color: Colors.black),
                                                  ),
                                                  const SizedBox(height: 5),
                                                                
                                                                                           
                                                  Text(
                                                    "Duration:",
                                                     maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                   style: GoogleFonts.lexendDeca(fontSize: 12,fontWeight: FontWeight.w300,color: Colors.black),
                                                  ),
                                                
                                                
                                                         const SizedBox(height: 5),                                     
                                                  Text(
                                                    "Rental Fee:",
                                                     maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                   style: GoogleFonts.lexendDeca(fontSize: 12,fontWeight: FontWeight.w300,color: Colors.black),
                                                  ),
                                                         const SizedBox(height: 5),                                     
                                                  Visibility(
                                                    visible: controller.decordedReponse[index]["security_amount"].toString()=="0"?false:true,
                                                    child: Text(
                                                      "Refundable Deposit:",
                                                       maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                     style: GoogleFonts.lexendDeca(fontSize: 12,fontWeight: FontWeight.w300,color: Colors.black),
                                                    ),
                                                  ),
                                                                
                                                  const SizedBox(height: 5),
                                                  
                                                    ],
                                                  ),
                                                ),


                                                   Expanded(
                                                     child: Container(
                                                      margin: const EdgeInsets.only(left: 10),
                                                                                                     
                                                                                                     child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                                                                     
                                                                        
                                                                                                     const SizedBox(height: 11),
                                                   
                                                      Text(
                                                        "",
                                                      style:  GoogleFonts.lexendExa(fontSize: 12,fontWeight: FontWeight.w300,color: Colors.black),
                                                                                                     ),
                                                                                                     
                                                                                                  
                                                                                                   
                                                                                                     const SizedBox(height: 5),
                                                                  
                                                                                                
                                                                  
                                                                                                     Text(
                                                        "${controller.decordedReponse[index]["start_date"]}",
                                                          maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style:  GoogleFonts.lexendDeca(fontSize: 12,fontWeight: FontWeight.w300,color: Colors.black),
                                                                                                     ),
                                                                                                   
                                                                                                     const SizedBox(height: 5),
                                                                  
                                                                                                     Text(
                                                        "${controller.decordedReponse[index]["end_date"]}",
                                                          maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style:  GoogleFonts.lexendDeca(fontSize: 12,fontWeight: FontWeight.w300,color: Colors.black),
                                                                                                     ),
                                                                                                     const SizedBox(height: 5),
                                                                  
                                                                                             
                                                                                                     Text(
                                                      "${controller.decordedReponse[index]["days"]} Days",
                                                        maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                     style: GoogleFonts.lexendDeca(fontSize: 12,fontWeight: FontWeight.w300,color: Colors.black),
                                                                                                     ),
                                                                                                   
                                                                                                   
                                                           const SizedBox(height: 5),                                     
                                                                                                     Text(
                                                      "AED ${controller.decordedReponse[index]["rent_amount"]}",
                                                        maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                     style: GoogleFonts.lexendDeca(fontSize: 12,fontWeight: FontWeight.w300,color: Colors.black),
                                                                                                     ),
                                                           const SizedBox(height: 5),                                     
                                                                                                     Visibility(
                                                      visible: controller.decordedReponse[index]["security_amount"].toString()=="0"?false:true,
                                                      child: Text(
                                                        "AED ${controller.decordedReponse[index]["security_amount"]}",
                                                          maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                       style: GoogleFonts.lexendDeca(fontSize: 12,fontWeight: FontWeight.w300,color: Colors.black),
                                                      ),
                                                                                                     ),
                                                                  
                                                                                                     const SizedBox(height: 5),
                                                                                                     
                                                      ],
                                                                                                     ),
                                                                                                   ),
                                                   ),
                                              

                                                ],
                                              ),


                                             


                                                
                                             
                                                              
                                                Container(
                                                  alignment: Alignment.centerRight,
                                                
                                                  child: Text(
                                                    "AED ${controller.decordedReponse[index]["security_amount"]+controller.decordedReponse[index]["rent_amount"]}",
                                                    style: GoogleFonts.lexendDeca(fontSize: 15,fontWeight: FontWeight.w300,color: Colors.black),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
 
                                    
                                   Visibility(
                                    visible: controller.decordedReponse[index]["is_available"].toString()=="0"?true:false,
                                     child: InkWell(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductView( index: 0, comesFrom: "", id: controller.decordedReponse[index]["product_id"].toString(), fromCart: true,)));
                                      },
                                       child: Container(
                                        color: const Color.fromARGB(230, 255, 255, 255),
                                        height: 160,
                                        width: MediaQuery.of(context).size.width,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text("Item no longer available",style: GoogleFonts.lexendDeca(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                        color:MyColors.themecolor )),
                                        const SizedBox(height: 10),
                                     
                                         InkWell(
                                          onTap: () {

                                             bottomsheet(index);
                                          
                                          },
                                           child: Wrap(
                                            direction: Axis.horizontal,
                                            alignment: WrapAlignment.center,
                                            crossAxisAlignment: WrapCrossAlignment.center,
                                            children: [
                                         
                                         
                                            const Icon(Icons.close),
                                            Text("Remove",style: GoogleFonts.lexendDeca(
                                         
                                              
                                            ),)
                                         
                                            ],
                                                                               ),
                                         )
                                     
                                     
                                          ],
                                        ),
                                       ),
                                     ),
                                   ),
                                  ],
                                ),

                                Container(
                                  
                                  width: MediaQuery.of(context).size.width,
                                  height: 1,
                                  color: const Color.fromARGB(255, 212, 212, 212),
                                  margin: const EdgeInsets.only(top: 15,bottom: 10),
                                )
                              ],
                            ),
                          );
                        }),
                  ),

                  // bottom container =========================================================================================

                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 5),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Row(
                                                               
                                      children: [
                                        SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: Checkbox(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(3)),
                                              value: damageProtection,
                                              onChanged: (value) {
                                                setState(() {

                                                   damageProtection = value!;

                                                });
                                              }),
                                        ),
                                        const SizedBox(width: 10),
                                         Expanded(
                                           child: Row(
                                             children: [
                                               Text(
                                                "Get damage protection coverage",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                                                     style: GoogleFonts.lexendDeca(fontSize: 14,fontWeight: FontWeight.w300,color: Colors.black),
                                                                                     ),


                                                                                     Container(
                                                                                      margin: const EdgeInsets.only(bottom: 10),
                                                                                       child: InfoPopupWidget(
                                                                                                                   contentTitle:controller.cartResponse.isEmpty?"": controller.cartResponse["damage_protection_text"],
                                                                                                                     contentTheme: InfoPopupContentTheme(
                                                                                                                     infoTextStyle: GoogleFonts.lexendDeca(
                                                                                                                       fontSize: 14,
                                                                                                                       fontWeight: FontWeight.w300
                                                                                                                     )
                                                                                                                   ),
                                                                                                                   child:  const Icon(Icons.info_outline,size: 18,)
                                                                                     
                                                                                                                     ),
                                                                                     )


                                             ],
                                           ),
                                         )
                                      ],
                                    ),
                                  ),
                                  Text(
                                    "AED ${controller.cartResponse["damage_amount"]}",
                                    style: GoogleFonts.lexendDeca(fontSize: 18,fontWeight: FontWeight.w300,color:MyColors.themecolor),

                                  )
                                ],
                              ),

                            const SizedBox(height: 10),

                              Visibility(
                                visible:
                                    controller.appliedPromoCode.isNotEmpty ? false : true,
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)),
                                      border: Border.all(color: Colors.black)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                            bottom: 5,
                                          ),
                                          child: TextFormField(


                                            style:  GoogleFonts.lexendDeca(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 14),
                                            decoration:  InputDecoration(
                                                border: InputBorder.none,
                                                hintText: "Add Coupon...",
                                                hintStyle: GoogleFonts.lexendDeca(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 13)),
                                            onChanged: (value) {
                                              setState(() {
                                                inputCoupon = value;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      InkWell(
                                        onTap:
                                        inputCoupon.isEmpty?null:
                                        
                                         () {
                                        
                                            controller.applyPromocode(
                                                context, inputCoupon);
                                          
                                        },
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(right: 5),
                                          padding: const EdgeInsets.only(
                                              top: 5,
                                              bottom: 5,
                                              left: 10,
                                              right: 10),
                                          decoration: BoxDecoration(
                                              color:inputCoupon.isEmpty?Colors.grey: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child:  Text(
                                            "Apply".toUpperCase(),
                                            style: GoogleFonts.lexendExa(
                                              fontWeight: FontWeight.w300,
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),

                                Visibility(
                                visible:
                                    controller.appliedPromoCode.isNotEmpty ? false : true,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 5),
                                    Container(
                                        alignment: Alignment.centerRight,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const PromoCode()));
                                          },
                                          child:  Text(
                                            "Find Coupon >",
                                            style: GoogleFonts.lexendDeca(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 13,
                                                decoration:
                                                    TextDecoration.underline),
                                          ),
                                        )),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),

                              // after apply promocode layout ==============================================================

                              Visibility(
                                visible: controller.appliedPromoCode.isNotEmpty?true:false,
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, top: 15, bottom: 10),
                                  margin:
                                      const EdgeInsets.only(top: 15, bottom: 5),
                                  decoration: BoxDecoration(
                                      color:
                                          const Color.fromARGB(43, 175, 16, 16),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Wrap(
                                        direction: Axis.vertical,
                                        children: [
                                          Wrap(
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            alignment: WrapAlignment.center,
                                            direction: Axis.horizontal,
                                            children: [
                                               Text(
                                                "Applied ",
                                                style: GoogleFonts.lexendDeca(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              const SizedBox(width: 5),
                                              DottedBorder(
                                                color: Colors.black,
                                                borderType: BorderType.RRect,
                                                radius:
                                                    const Radius.circular(7),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(7)),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10,
                                                            right: 5,
                                                            top: 5,
                                                            bottom: 5),
                                                    color: MyColors.themecolor,
                                                    child: Wrap(
                                                      direction:
                                                          Axis.horizontal,
                                                      alignment:
                                                          WrapAlignment.center,
                                                      crossAxisAlignment:
                                                          WrapCrossAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          controller
                                                              .applyPromoCodeResponse[
                                                                  "promocode"]
                                                              .toString(),
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          Wrap(
                                              alignment: WrapAlignment.center,
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              direction: Axis.horizontal,
                                              children: [
                                                Text(
                                                  "AED ${controller.applyPromoCodeResponse["discount_amount"]} off",
                                                  style: GoogleFonts.lexendDeca(
                                                      color: const Color(0xff00C94B),
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                                const SizedBox(width: 5),
                                                LottieBuilder.asset(
                                                  "assets/images/tick.json",
                                                  width: 25,
                                                  height: 25,
                                                )
                                              ])
                                        ],
                                      ),
                                      InkWell(
                                        onTap: () {
                                          controller.appliedPromoCode = "";
                                          controller.forseUpdate();
                                        },
                                        child:  Text(
                                          "Remove",
                                          style: GoogleFonts.lexendDeca(
                                              color: MyColors.themecolor,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 13),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),

                              // first row

                              const SizedBox(height: 10),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                   Text(
                                    "Subtotal",
                                    style: GoogleFonts.lexendDeca(
                                      fontWeight: FontWeight.w300,
                                        color: Colors.black, fontSize: 15),
                                  ),
                                  Text(
                                    "AED ${controller.cartResponse["total_amt"]}",
                                    style: GoogleFonts.lexendDeca(
                                      fontWeight: FontWeight.w300,
                                        color: Colors.black, fontSize: 15),
                                  ),
                                ],
                              ),

                              //  second row

                              Visibility(
                                visible: controller.appliedPromoCode.isNotEmpty?true:false,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                         Text(
                                          "Discount",
                                          style: GoogleFonts.lexendDeca(
                                      fontWeight: FontWeight.w300,
                                        color: Colors.black, fontSize: 15),
                                        ),
                                        Text(
                                          "AED -${controller.applyPromoCodeResponse["discount_amount"]}",
                                          style:  GoogleFonts.lexendDeca(
                                            fontWeight: FontWeight.w300,
                                              color: const Color.fromARGB(
                                                  255, 24, 175, 29),
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // third row

                              const SizedBox(height: 5),

                              Visibility(
                                visible: damageProtection,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                         Text(
                                          "Damage Protection",
                                          style:GoogleFonts.lexendDeca(
                                      fontWeight: FontWeight.w300,
                                        color: Colors.black, fontSize: 15),
                                        ),
                                        Text(
                                          "AED +${controller.cartResponse["damage_amount"]}",
                                          style: GoogleFonts.lexendDeca(
                                      fontWeight: FontWeight.w300,
                                        color: Colors.black, fontSize: 15),
                                        ),
                                      ],
                                    ),
                                    // fourth row

                                    const SizedBox(height: 5),
                                  ],
                                ),
                              ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                   Text(
                                    "Amount to be paid",
                                    style: GoogleFonts.lexendDeca(
                                      fontWeight: FontWeight.w300,
                                        color: Colors.black, fontSize: 15),
                                  ),
                                  Text(
                                    // ignore: prefer_interpolation_to_compose_strings

                                    controller.appliedPromoCode.isNotEmpty
                                        ? damageProtection
                                            ? "AED ${(int.parse(controller.applyPromoCodeResponse["taxable_amount"].toString()) + int.parse(controller.cartResponse["damage_amount"].toString())).toString().replaceAll("-", "")}"
                                            : "AED ${controller.applyPromoCodeResponse["taxable_amount"]}"
                                        : damageProtection
                                            ? "AED ${(int.parse(controller.cartResponse["total_amt"].toString()) + int.parse(controller.cartResponse["damage_amount"].toString())).toString().replaceAll("-", "")}"
                                            : "AED ${controller.cartResponse["total_amt"]}",
                                    style: GoogleFonts.lexendDeca(
                                      fontWeight: FontWeight.w300,
                                        color: Colors.black, fontSize: 15),
                                  ),
                                ],
                              ),
                              // five row

                              const SizedBox(height: 5),
                            ],
                          ),
                        ),

                          Container(
                  margin: const EdgeInsets.only(left:10, right: 20,bottom: 10),
                  
                  child: Row(
                    children: [
                
                      Checkbox(value: renterTermsCheck,

                    shape:  RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(3)),

                      
                       onChanged: (value){


                
                        setState(() {
                          renterTermsCheck=value!;
                        });
                
                      }),
                
                      Expanded(child:
                       RichText(text: TextSpan(
                        children: [
                
                            TextSpan(
                  text: "Please check the box to confirm that you've read and agree to the ",
                               style: GoogleFonts.lexendDeca(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              fontSize: 12),
                   recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    
                  }),
                            TextSpan(
                  text: "renter's terms and conditions.",
                               style: GoogleFonts.lexendDeca(
                              color: Colors.blue,
                              fontWeight: FontWeight.w300,
                              fontSize: 12),
                   recognizer: TapGestureRecognizer()
                  ..onTap = () {
                
                  launchUrl(Uri.parse("https://siz.ae/pages/terms-conditions-renter"));
                    
                  }),
                        ]
                       ))
                      
                      )
                
                    ],
                  ),
                ),


                         InkWell(
                          onTap:
                          
                          !renterTermsCheck?null:
                          
                             controller.cartResponse["cart_status"].toString()=="0"?
                          
                           null
                          : () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                         ShoppingPaymentSummery(carttype: controller.cartResponse["cart_type"].toString(),
                                         promoCode:  controller.appliedPromoCode.isNotEmpty? controller.appliedPromoCode:"",
                                         damageProtection: damageProtection==true?"1":"0",
                                         price:  controller.appliedPromoCode.isNotEmpty
                                        ? damageProtection
                                            ? (int.parse(controller.applyPromoCodeResponse["taxable_amount"].toString()) + int.parse(controller.cartResponse["damage_amount"].toString())).toString().replaceAll("-", "")
                                            : "${controller.applyPromoCodeResponse["taxable_amount"]}"
                                        : damageProtection
                                            ? (int.parse(controller.cartResponse["total_amt"].toString()) + int.parse(controller.cartResponse["damage_amount"].toString())).toString().replaceAll("-", "")
                                            : "${controller.cartResponse["total_amt"]}",
                                            oldPrice: controller.cartResponse["total_amt"].toString(),
                                            couponCodePrice:controller.appliedPromoCode.isNotEmpty? controller.applyPromoCodeResponse["discount_amount"].toString():"0",
                                            damageProtectionPrice: damageProtection?controller.cartResponse["damage_amount"].toString():"0",
                                            balance:controller.cartResponse["balance"].toString(),
                                            cartID: controller.cartResponse["cart_verify_id"].toString(),
                                         )));
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(
                                left: 15, right: 15, bottom: 20),
                           height: 40,
                            width: MediaQuery.of(context).size.width,
                            decoration:  BoxDecoration(
                                color:  !renterTermsCheck? Colors.grey:  controller.cartResponse["cart_status"].toString()=="0"?Colors.grey: Colors.black,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5))),
                            child: Text(
                              "SEND REQUEST TO RENT",
                              style: GoogleFonts.lexendExa(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }

  bottomsheet(int index) {
    return

   

        showModalBottomSheet(
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))),
            context: context,
            builder: (context) {
              return Wrap(children: [
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
                            "Do you really want to remove this item from your cart?",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lexendDeca(
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
                                  controller.removeCart(
                                      context,
                                      controller.decordedReponse[index]["id"]
                                          .toString());
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
            }
            
            );
  }
}
