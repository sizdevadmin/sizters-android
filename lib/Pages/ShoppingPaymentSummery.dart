// ignore_for_file: deprecated_member_use, must_be_immutable, use_build_context_synchronously
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siz/AddItemsPages/Addaddress.dart';
import 'package:siz/Controllers/BottomNavController.dart';
import 'package:siz/Pages/Home.dart';
import 'package:siz/Pages/Wishlist.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:siz/Utils/Colors.dart';
import 'package:siz/Utils/KeepliveWidget.dart';
import 'package:siz/Utils/ManageAddressController.dart';
import 'package:siz/Utils/MyRadioCustom.dart';
import 'package:siz/Utils/Value.dart';

class ShoppingPaymentSummery extends StatefulWidget {
  String carttype = "";
  String promoCode="";
  String damageProtection="";
  String price="";
  String oldPrice="";
  String couponCodePrice="";
  String damageProtectionPrice="";
  String balance="";
  String cartID="";


  ShoppingPaymentSummery({super.key, required this.carttype,required this.promoCode,required this.damageProtection,required this.price, required this.oldPrice, required this.couponCodePrice,required this.damageProtectionPrice, required this.balance,required this.cartID});

  @override
  State<ShoppingPaymentSummery> createState() => _ShoppingPaymentSummeryState();
}

class _ShoppingPaymentSummeryState extends State<ShoppingPaymentSummery>
    with TickerProviderStateMixin {
  List<String> grouprationlist = ["Pick up", "Delivery"];
   Map<String,dynamic> paymentIntent={};
  
  String selectedshipping = "Pick up";
  String pickupAddress = "";
  String deliveryAddress = "";
  bool savecard = false;

  late ManageAddressController controller;

  var preSelectedAddress = '';
  String currentAddress = "";
  late SharedPreferences sharedPreferences;

 

  late TabController tabController2;


  // summary details  

  String orderNumber="";
  String finalamount="";
  Map<String, dynamic> orderPunchReponse = {};
  Map<String, dynamic> placedAddress = {};
  List<dynamic> placedOrderList = [];

   String deliveryType="";

    bool checkSizCredit=false;
    double creditAppliedAmount=0;
    double afterAppliedAmount=0;
    double grandTotal=0;

  @override
  void initState() {
    iniTialShare();
    controller = Get.put(ManageAddressController());
    controller.getAddress(context, true);

    grandTotal=double.parse(widget.price);
    

    if(widget.carttype=="2")
    {

      controller.getPickupAddress(context);



    }

    super.initState();

    tabController2 = TabController(length: 3, vsync: this, initialIndex: 0);

     Stripe.publishableKey =
               "pk_live_51M7VrIECtd4SVPRIXvTGiqB1bn5uxwFuihTOvKnglsvkUWuPfe740SScccqqrXmGm06mYMUMulOuUoAaXyTjEEg800b37HJ9qk";
  }

  iniTialShare() async
  {
    sharedPreferences=await SharedPreferences.getInstance();
  }

   

    
     

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: GetBuilder(
          init: ManageAddressController(),
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

                        tabController2.index == 2?

                        const SizedBox(height: 20,width: 20)
                        :

                        InkWell(
                            onTap: () {

                              if(tabController2.index==1)
                              {
                                tabController2.animateTo(0);
                              }

                              else
                              {

                                 Navigator.pop(context);

                              }
                            
                               
                              
                            },
                            child: SvgPicture.asset(
                                "assets/images/backarrow.svg", color:Colors.black,width: 20,height: 20,)),
                        Container(
                            margin: const EdgeInsets.only(),
                            child:  Text(

                             tabController2.index==0? "ADDRESS": "ORDER DETAILS",
               
                            
                             
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

                  //tabbar=======================================================================================================

                  IgnorePointer(
                    ignoring: true,
                    child: TabBar(
                      splashFactory: NoSplash.splashFactory,
                      indicatorColor: Colors.black,
                      indicatorWeight: 4,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.black,
                      labelStyle: GoogleFonts.lexendDeca(
                          fontSize: 16
                          , fontWeight: FontWeight.w300),
                      tabs: const [
                        Tab(text: "Shipping"),
                       Tab(text: "Payment"),
                        Tab(text: "Summary"),
                       
                      ],
                      controller: tabController2,
                    ),
                  ),

                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 10,right: 10),
                      child: TabBarView(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: tabController2,
                          children: [
                            // tabview one 1 ===========================================================================================
                            widget.carttype.toString() == "1"
                    
                                // if cart item is listed by app ==== carttype ==1 =============================
                                ? Column(
                                    children: [
                                      Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                              alignment: Alignment.centerLeft,
                                              padding:
                                                  const EdgeInsets.only(right: 30),
                                              margin: const EdgeInsets.only(
                                                  left: 10,
                                                 
                                                  top: 20,
                                                 ),
                                              child: Text(
                                                "Delivery Address",
                                                style: GoogleFonts.lexendDeca(
                                                  fontWeight: FontWeight.w400,
                                                    color: Colors.black,
                                                    fontSize: 20),
                                              )),

                                                  // add address button ==================================================================================
                    
                                      InkWell(
                                        onTap: () {
                                          controller.addValue(
                                              SizValue.address, currentAddress);
                    
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ManageAddress(
                                                        from:
                                                            'ShoppingPaymentSummery',
                                                        appartment: "",
                                                        buildingName: "",
                                                        area: "",
                                                        state: "",
                                                        pickupUpName: "",
                                                        mobile: "",
                                                        edit: false,
                                                        type: "",
                                                        addressId: "",
                                                      )));
                                        },
                                        child: Container(
                                                 
                                                  margin: const EdgeInsets.only(right: 10, top: 20),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: const Color(0xff1E1E1E),
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(5)),
                                           
                                                   width: 120,
                                                  height: 40,
                                                  child: Text(
                                                    "+ ADD NEW",
                                                    style:
                                                        GoogleFonts.lexendExa(
                                                            color:
                                                                Colors.white,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300),
                                                  ),
                                                ),
                                      ),
                                        ],
                                      ),
                    
                                  
                    
                                      // address list =========================================================================
                    
                                      Expanded(
                                        child: Container(
                                           padding:
                                                      const EdgeInsets.only(
                                                          right: 10),
                                                  margin:
                                                      const EdgeInsets.all(
                                                          10),
                                          decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    // color:
                                                    //     const Color.fromARGB(
                                                    //         22, 175, 16, 16),
                                                  ),
                                          child: ListView.builder(
                                              itemCount: controller
                                                  .decordedResponse.length,
                                              padding: EdgeInsets.zero,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                 padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  bottom: 8),
                                                  child: RadioListTile(
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                            left: 0),
                                                    activeColor:
                                                        MyColors.themecolor,
                                                    title: 
                                                        // else background color grey
                                                         Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                                Container(
                                                                    margin: const EdgeInsets.only(top: 15,bottom: 5),
                                                                  child: Text(
                                                                  controller
                                                                  .decordedResponse[
                                                                      index]
                                                                      [
                                                                      "type_str"]
                                                                  .toString(),
                                                                  style:  GoogleFonts.lexendExa(
                                                                            letterSpacing: 1.0,
                                                                                                                                        color: Colors.black,
                                                                                                                                      
                                                                                                                                        fontWeight:
                                                                                                                                            FontWeight.w300,
                                                                                                                                        fontSize: 12)
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                    onTap: () {
                                                                      bottomsheet(
                                                                          controller.decordedResponse[index]["type_str"]
                                                                              .toString(),
                                                                          controller.decordedResponse[index]["id"]
                                                                              .toString(),
                                                                          controller.decordedResponse[index]["apartment"]
                                                                              .toString(),
                                                                          controller
                                                                              .decordedResponse[index][
                                                                                  "area_name"]
                                                                              .toString(),
                                                                          controller
                                                                              .decordedResponse[index][
                                                                                  "city"]
                                                                              .toString(),
                                                                          controller
                                                                              .decordedResponse[index][
                                                                                  "state"]
                                                                              .toString(),
                                                                          controller
                                                                              .decordedResponse[index][
                                                                                  "contact_name"]
                                                                              .toString(),
                                                                          controller
                                                                              .decordedResponse[index][
                                                                                  "mobile_number"]
                                                                              .toString(),
                                                                          controller
                                                                              .decordedResponse[index]["type"]
                                                                              .toString());
                                                                    },
                                                                    child:
                                                                        Container(
                                                                             margin: const EdgeInsets.only(right: 5,top: 15,bottom: 5),

                                                                      child: SvgPicture
                                                                          .asset(
                                                                        "assets/images/threedot.svg",
                                                                        width: 30,
                                                                        height:
                                                                            25,
                                                                      ),
                                                                    ))
                                                              ]),
                                                    subtitle: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "${controller.decordedResponse[index]["contact_name"]}",
                                                          style: GoogleFonts.lexendDeca(
                                                          color: const Color.fromARGB(255, 88, 88, 88),
                                                          fontWeight: FontWeight.w300,
                                                          fontSize: 12),
                                                        ),
                                                        const SizedBox(height: 5),
                                                        Text(
                                                          controller
                                                              .decordedResponse[
                                                                  index][
                                                                  "mobile_number"]
                                                              .toString(),
                                                          style:  GoogleFonts.lexendDeca(
                                                          color: const Color.fromARGB(255, 88, 88, 88),
                                                          fontWeight: FontWeight.w300,
                                                          fontSize: 12),
                                                        ),
                                                        const SizedBox(height: 5),
                                                        Text(
                                                          controller
                                                              .decordedResponse[index]
                                                                  ["full_address"]
                                                              .toString(),
                                                          style:GoogleFonts.lexendDeca(
                                                          color: const Color.fromARGB(255, 88, 88, 88),
                                                          fontWeight: FontWeight.w300,
                                                          fontSize: 12),
                                                        ),
                                                      ],
                                                    ),
                                                    value: controller
                                                        .decordedResponse[index]
                                                            ["id"]
                                                        .toString(),
                                                    groupValue:
                                                        preSelectedAddress,
                                                    // ignore: avoid_types_as_parameter_names
                                                    onChanged: (value) {
                                                      setState(() {
                                                        preSelectedAddress =
                                                            value.toString();
                    
                                                           
                                                      });
                                                    },
                                                  ),
                                                );
                                              }),
                                        ),
                                      ),
                    
                                      InkWell(
                                        onTap: () {
                                          if (preSelectedAddress.isEmpty) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar( SnackBar(
                                              content:
                                                  Text("Please select address",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white)),
                                              duration: const Duration(seconds: 1),
                                            ));
                                          } else {
                    
                                              setState(() {
                                              deliveryType="1";
                                              tabController2.animateTo(1);
                                            });
                    
                                              // makePayment();
                                           
                                              
                                          
                                          }
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              left: 10,
                                              right: 10,
                                              bottom: 40,
                                              top: 10),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 40,
                                          child: Text(
                                            "Confirm address".toUpperCase(),
                                            style: GoogleFonts.lexendExa(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                :
                    
                                // else cart item is listed by backend ==== carttype ==2
                    
                                KeepPageAlive(
                                  child: Column(
                                    children: [
                                      // top radio pickup delivery
                                      Container(
                                        margin:
                                            const EdgeInsets.only(left: 30),
                                        child: Theme(
                                          data: ThemeData(
                                              splashFactory:
                                                  NoSplash.splashFactory,
                                              primarySwatch:
                                                  const MaterialColor(
                                                      0xFFAF1010, {
                                                50: Color(0xFFAF1010),
                                                100: Color(0xFFAF1010),
                                                200: Color(0xFFAF1010),
                                                300: Color(0xFFAF1010),
                                                400: Color(0xFFAF1010),
                                                500: Color(0xFFAF1010),
                                                600: Color(0xFFAF1010),
                                                700: Color(0xFFAF1010),
                                                800: Color(0xFFAF1010),
                                                900: Color(0xFFAF1010),
                                              }),
                                              splashColor:
                                                  Colors.transparent),
                                          child: RadioGroup<String>.builder(
                                            direction: Axis.horizontal,
                                            groupValue:selectedshipping.toString(),
                                            onChanged: (value) =>
                                          setState(() {
                                              selectedshipping = value.toString();
                                              setState(() {
                                                preSelectedAddress="";
                                              });
                                            }),
                                            textStyle: GoogleFonts.lexendDeca(
                                                color: const Color.fromARGB(255, 76, 76, 76),
                                                fontWeight: FontWeight.w300,
                                                fontSize: 18),
                                            items: grouprationlist,
                                            itemBuilder: (item) =>
                                                RadioButtonBuilder(
                                              item,
                                            ),
                                          ),
                                        ),
                                      ),
                                
                                      // pickup ==============================================================
                                
                                      Visibility(
                                   
                                        visible: selectedshipping == "Pick up"
                                            ? true
                                            : false,
                                        child: SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height -
                                              240,
                                          child: Column(
                                            children: [
                                              Container(
                    
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  margin:
                                                      const EdgeInsets.only(
                                                          left: 20,
                                                          top: 20,
                                                          bottom: 10),
                                                  child:  Text(
                                                    "Pick Up Address",
                                                    style:GoogleFonts.lexendDeca(
                                                      fontWeight: FontWeight.w300,
                                                        color: Colors.black,
                                                        fontSize: 20),
                                                  )),
                                              Expanded(
                                                child: Container(
                                                  transform: Matrix4.translationValues(0, -50, 0),
                                                  margin:
                                                      const EdgeInsets.only(
                                                          left: 17,
                                                          right: 17),
                                                  child: MYRadioGroup(
                                                      items:controller.pickupAddressList,
                                                      selectedItem:preSelectedAddress,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          preSelectedAddress =
                                                              value['id']
                                                                  .toString();
                                
                                                                 
                                                        });
                                                      },
                                                      labelBuilder:
                                                          (ctx, index) {
                                                        return Flexible(
                                                          child: Container(
                                                            margin: const EdgeInsets.only(left: 10,top: 20),
                                                            child: Column(
                                                                                                                 
                                                              children: [
                                                                Container(
                                                          
                                                                  transform: Matrix4.translationValues(0, 10, 0),
                                                                  margin: const EdgeInsets.only(bottom: 0),
                                                                  alignment: Alignment.centerLeft,
                                                                  child: Text(
                                                                     controller. pickupAddressList[
                                                                                  index]
                                                                              [
                                                                              "apartment"]
                                                                          .toString().toUpperCase(),
                                                                          textAlign: TextAlign.left,
                                                                              style: GoogleFonts.lexendExa(
                                                                                                                                        letterSpacing: 1.0,
                                                                                                                                        color: Colors.black,
                                                                                                                                      
                                                                                                                                        fontWeight:
                                                                                                                                            FontWeight.w300,
                                                                                                                                        fontSize: 12),
                                                                          
                                                                          ),
                                                                ),
                                                                Container(
                                                                      transform: Matrix4.translationValues(0, 20, 0),
                                                                  alignment: Alignment.centerLeft,
                                                                  child: Text(
                                                                     controller. pickupAddressList[
                                                                                  index]
                                                                              [
                                                                              "area_name"]
                                                                          .toString(),
                                                                          
                                                                             style: GoogleFonts.lexendDeca(
                                                          color: const Color.fromARGB(255, 88, 88, 88),
                                                          fontWeight: FontWeight.w300,
                                                          fontSize: 12)
                                                                          
                                                                          ),
                                                                ),
                                                                Container(
                                                                  margin: const EdgeInsets.only(top: 5),
                                                                  
                                                                    transform: Matrix4.translationValues(0, 20, 0),
                                                                  alignment: Alignment.centerLeft,
                                                                  child: Text(
                                                                     controller. pickupAddressList[
                                                                                  index]
                                                                              [
                                                                              "city"]
                                                                          .toString(),
                                                                          
                                                                             style: GoogleFonts.lexendDeca(
                                                          color: const Color.fromARGB(255, 88, 88, 88),
                                                          fontWeight: FontWeight.w300,
                                                          fontSize: 12)
                                                                          
                                                                          ),
                                                                ),
                                                                Container(
                                                                    margin: const EdgeInsets.only(top: 5),
                                                                    transform: Matrix4.translationValues(0, 20, 0),
                                                                  alignment: Alignment.centerLeft,
                                                                  child: Text(
                                                                     controller. pickupAddressList[
                                                                                  index]
                                                                              [
                                                                              "state"]
                                                                          .toString(),
                                                                          
                                                                             style:   GoogleFonts.lexendDeca(
                                                          color: const Color.fromARGB(255, 88, 88, 88),
                                                          fontWeight: FontWeight.w300,
                                                          fontSize: 12)
                                                                          
                                                                          ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      shrinkWrap: true,
                                                      disabled: false),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  if (preSelectedAddress.isEmpty) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                             SnackBar(
                                                      content: Text(
                                                          "Please select pickup address",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white)),
                                                      duration: const Duration(
                                                          seconds: 1),
                                                    ));
                                                  } else {
                    
                                                     setState(() {
                                                          deliveryType="2";
                                                          tabController2.animateTo(1);
                                                        });
                    
                                                      // makePayment();
                                                  
                                
                                                       
                                                  }
                                                },
                                                child: Container(
                                                  margin:
                                                      const EdgeInsets.only(
                                                          left: 10,
                                                          right: 10,
                                                          top: 10),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(5)),
                                                  width:
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width,
                                                  height: 40,
                                                  child: Text(
                                                    "Confirm address".toUpperCase(),
                                                    style:
                                                        GoogleFonts.lexendExa(
                                                            color:
                                                                Colors.white,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                
                                      // Delivery address ===========================
                                
                                      Visibility(
                                       
                                        visible: selectedshipping == "Pick up"
                                            ? false
                                            : true,
                                
                                        child: SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height -
                                              240,
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                      alignment: Alignment.centerLeft,
                                                    
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 20,
                                                              right: 10,
                                                              top: 10
                                                             ),
                                                      child: Text(
                                                        "Delivery Address ",
                                                        textAlign: TextAlign.start,
                                                        style: GoogleFonts.lexendDeca(
                                                          fontWeight: FontWeight.w300,
                                                            color: Colors.black,
                                                            fontSize: 20),
                                                      )),
                    
                                                       InkWell(
                                                onTap: () {
                                                  controller.addValue(
                                                      SizValue.address,
                                                      currentAddress);
                                
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ManageAddress(
                                                                from:
                                                                    'ShoppingPaymentSummery',
                                                                appartment:
                                                                    "",
                                                                buildingName:
                                                                    "",
                                                                area: "",
                                                                state: "",
                                                                pickupUpName:
                                                                    "",
                                                                mobile: "",
                                                                edit: false,
                                                                type: "",
                                                                addressId: "",
                                                              )));
                                                },
                                                child: Container(
                                                 
                                                  margin: const EdgeInsets.only(right: 25, top: 10),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: const Color(0xff1E1E1E),
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(5)),
                                           
                                                   width: 120,
                                                  height: 40,
                                                  child: Text(
                                                    "+ ADD NEW",
                                                    style:
                                                        GoogleFonts.lexendExa(
                                                            color:
                                                                Colors.white,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300),
                                                  ),
                                                ),
                                              )
                                                ],
                                              ),
                                
                                              // add address button ==================================================================================
                                
                                             
                                
                                              // address list =========================================================================
                                
                                              Expanded(
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10),
                                                  margin:
                                                      const EdgeInsets.all(
                                                          10),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    // color:
                                                    //     const Color.fromARGB(
                                                    //         22, 175, 16, 16),
                                                  ),
                                                  child: ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount: controller
                                                          .decordedResponse
                                                          .length,
                                                      padding:
                                                          EdgeInsets.zero,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  bottom: 8),
                                                          child:
                                                              RadioListTile(
                                                            contentPadding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 0),
                                                            activeColor:
                                                                MyColors
                                                                    .themecolor,
                                                            title: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                        Container(
                                                                          margin: const EdgeInsets.only(top: 15,bottom: 5),
                                                                          child: Text(
                                                                            controller.decordedResponse[index]["type_str"].toString().toUpperCase(),
                                                                            style: GoogleFonts.lexendExa(
                                                                                                                                        letterSpacing: 1.0,
                                                                                                                                        color: Colors.black,
                                                                                                                                      
                                                                                                                                        fontWeight:
                                                                                                                                            FontWeight.w300,
                                                                                                                                        fontSize: 12)
                                                                          ),
                                                                        ),
                                                                        InkWell(
                                                                            onTap: () {
                                                                              bottomsheet(controller.decordedResponse[index]["type_str"].toString(), controller.decordedResponse[index]["id"].toString(), controller.decordedResponse[index]["apartment"].toString(), controller.decordedResponse[index]["area_name"].toString(), controller.decordedResponse[index]["city"].toString(), controller.decordedResponse[index]["state"].toString(), controller.decordedResponse[index]["contact_name"].toString(), controller.decordedResponse[index]["mobile_number"].toString(), controller.decordedResponse[index]["type"].toString());
                                                                            },
                                                                            child: Container(
                                                                              margin: const EdgeInsets.only(right: 5,top: 15,bottom: 5),
                                                                              child: SvgPicture.asset(
                                                                                "assets/images/threedot.svg",
                                                                                width: 30,
                                                                                height: 25,
                                                                              ),
                                                                            ))
                                                                      ]),
                                                            subtitle: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "${controller.decordedResponse[index]["contact_name"]}",
                                                                  style: GoogleFonts.lexendDeca(
                                                          color: const Color.fromARGB(255, 88, 88, 88),
                                                          fontWeight: FontWeight.w300,
                                                          fontSize: 12)
                                                                ),
                                                                const SizedBox(
                                                                    height:
                                                                        5),
                                                                Text(
                                                                  controller
                                                                      .decordedResponse[
                                                                          index]
                                                                          ["mobile_number"]
                                                                      .toString(),
                                                                  style:  GoogleFonts.lexendDeca(
                                                          color: const Color.fromARGB(255, 88, 88, 88),
                                                          fontWeight: FontWeight.w300,
                                                          fontSize: 12)
                                                                ),
                                                                const SizedBox(
                                                                    height:
                                                                        5),
                                                                Text(
                                                                  controller
                                                                      .decordedResponse[
                                                                          index]
                                                                          ["full_address"]
                                                                      .toString(),
                                                                  style: GoogleFonts.lexendDeca(
                                                          color: const Color.fromARGB(255, 88, 88, 88),
                                                          fontWeight: FontWeight.w300,
                                                          fontSize: 12)
                                                                ),
                                                              ],
                                                            ),
                                                            value: controller
                                                                .decordedResponse[
                                                                    index]
                                                                    ["id"]
                                                                .toString(),
                                                            groupValue:
                                                                preSelectedAddress,
                                                            // ignore: avoid_types_as_parameter_names
                                                            onChanged:
                                                                (value) {
                                                              setState(() {
                    
                                                              
                                                                preSelectedAddress = value.toString();
                                                             
                                                               
                                                              });
                                                            },
                                                          ),
                                                        );
                                                      }),
                                                ),
                                              ),
                                
                                              InkWell(
                                                onTap: () async {
                                                  if (preSelectedAddress .isEmpty) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                             SnackBar(
                                                      content: Text(
                                                          "Please select address",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white)),
                                                      duration: const Duration(
                                                          seconds: 1),
                                                    ));
                                                  } else {
                    
                                                           setState(() {
                                                                  deliveryType="1";
                                                                   tabController2.animateTo(1);
                                                                });
 



                    
                                                    // makePayment();
                                                   
                                                  }
                                                },
                                                child: Container(
                                                  margin:
                                                      const EdgeInsets.only(
                                                          left: 10,
                                                          right: 10,
                                                          top: 10),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(5)),
                                                  width:
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width,
                                                  height: 40,
                                                  child: Text(
                                                    "Confirm Address".toUpperCase(),
                                                    style:
                                                        GoogleFonts.lexendExa(
                                                            color:
                                                                Colors.white,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                
                                        
                                      ),
                                
                                      // not start yet
                                    ],
                                  ),
                                ),


                 // tabview two 2 summary ===========================================================================================






               KeepPageAlive(
                 child: Column(
                  children: [

                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 30,bottom: 30),
                        child: Text("Bill Summary",style: GoogleFonts.lexendDeca(
                                  fontWeight: FontWeight.w300,
                                       
                                  fontSize: 20
                                )),
                      ),


                      Visibility(
                        visible: widget.balance=="0"?false:true,
                        child: Row(
                          children: [
                      
                            Checkbox(value: checkSizCredit,
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                             onChanged: (value){
                      
                              setState(() {
                                checkSizCredit=value as bool;
                                
                      
                                if(checkSizCredit)
                                {
                                  if(double.parse(widget.balance)<=double.parse(widget.price))
                                  {
                                    
                                    setState(() {
                      
                                       creditAppliedAmount=double.parse(widget.balance);
                                       afterAppliedAmount=0;
                                       grandTotal=double.parse(widget.price)-double.parse(widget.balance);
                      
                                       
                                      
                                    });
                      
                                  
                                   
                                  }
                      
                                  else
                                  {
                      
                      
                                    setState(() {
                      
                                        creditAppliedAmount=double.parse(widget.price);
                                        afterAppliedAmount=double.parse(widget.balance)-double.parse(widget.price);
                                        grandTotal=0;
                                      
                                    });
                      
                                  
                      
                      
                      
                                  }
                                }
                      
                                else
                                {
                      
                                setState(() {
                                  grandTotal=double.parse(widget.price);
                                });
                      
                                }
                      
                      
                      
                              });
                      
                            }),
                      
                              Text("Use your ",style: GoogleFonts.lexendDeca(
                                    fontWeight: FontWeight.w300,
                                       
                                    fontSize: 15
                                  ),),
                              Text("AED ${widget.balance}",style: GoogleFonts.lexendDeca(
                                    fontWeight: FontWeight.w500,
                                       color: MyColors.themecolor,
                                    fontSize: 16
                                  ),),
                              Text(" Siz Credits balance",style: GoogleFonts.lexendDeca(
                                    fontWeight: FontWeight.w300,
                                       
                                    fontSize: 15
                                  ),),
                      
                            
                      
                          ],
                        ),
                      ),

                  
                     Expanded(
                       child: Column(
                        children: [
                     
                              Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: [BoxShadow(
                            color: Color.fromARGB(255, 208, 208, 208),
                            blurRadius: 2,
                                    
                            offset: Offset(0, 5)
                          )]
                        ),
                        child: Column(
                          children: [
                                         
                            // amount
                                   
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Amount",style: GoogleFonts.lexendDeca(
                                  fontWeight: FontWeight.w300,
                                     
                                  fontSize: 15
                                ),),
                                Text("AED ${widget.oldPrice}",style: GoogleFonts.lexendDeca(
                                  fontWeight: FontWeight.w300,
                                     
                                  fontSize: 15
                                ),)
                              ],
                            ),
                                         
                          
                                         
                            // Discount
                            Visibility(
                              visible: widget.couponCodePrice=="0"?false:true,
                              child: Container(
                                margin: const EdgeInsets.only(top: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("Discount",style: GoogleFonts.lexendDeca(
                                      fontWeight: FontWeight.w300,
                                         
                                      fontSize: 15
                                    ),),
                                    Text("- AED ${widget.couponCodePrice}",style: GoogleFonts.lexendDeca(
                                      fontWeight: FontWeight.w300,
                                         
                                      fontSize: 15
                                    ),)
                                  ],
                                ),
                              ),
                            ),
                                         
                           
                            Visibility(
                             visible: widget.damageProtectionPrice=="0"?false:true,
                              child: Container(
                                margin: const EdgeInsets.only(top: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("Damage Protection",style: GoogleFonts.lexendDeca(
                                      fontWeight: FontWeight.w300,
                                         
                                      fontSize: 15
                                    ),),
                                    Text("AED ${widget.damageProtectionPrice}",style: GoogleFonts.lexendDeca(
                                      fontWeight: FontWeight.w300,
                                         
                                      fontSize: 15
                                    ),)
                                  ],
                                ),
                              ),
                            ),
                                         
                            const SizedBox(height: 15,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Delivery",style: GoogleFonts.lexendDeca(
                                  fontWeight: FontWeight.w300,
                                     
                                  fontSize: 15
                                ),),
                                Text("AED 0",style: GoogleFonts.lexendDeca(
                                  fontWeight: FontWeight.w300,
                                     
                                  fontSize: 15
                                ),)
                              ],
                            ),
                                         
                           
                            Visibility(
                              visible: checkSizCredit,
                              child: Container(
                                margin: const EdgeInsets.only(top: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("SIZ Credits",style: GoogleFonts.lexendDeca(
                                      fontWeight: FontWeight.w300,
                                         
                                      fontSize: 15
                                    ),),
                                    Text("-AED $creditAppliedAmount",style: GoogleFonts.lexendDeca(
                                      fontWeight: FontWeight.w300,
                                         
                                      fontSize: 15
                                    ),)
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 25,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Grand Total",style: GoogleFonts.lexendDeca(
                                         
                                  fontWeight: FontWeight.w300,
                                     
                                  fontSize: 20
                                ),),
                                Text("AED $grandTotal",style: GoogleFonts.lexendDeca(
                                   fontWeight: FontWeight.w300,
                                     
                                  fontSize: 20
                                ),)
                              ],
                            ),
                                         
                          
                                   
                          ],
                        ),
                                         )
                     
                        ],
                       ),
                     ),



                     InkWell(
                      onTap: () {

                        
                          if(grandTotal==0)
                          {


                            orderPunch("");

                            firebaseEventCalled();
                            setState(() {
                            tabController2.animateTo(2);
          
        });
  
                           

                          }

                          else{

                              makePayment();

                          }

                      },
                       
                            
                      
                       child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                          bottom: 40,
                                                            left: 25,
                                                            right: 25,
                                                            top: 10),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        color: Colors.black,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: 40,
                                                    child: Text(
                                                  grandTotal==0? "PLACE ORDER": "SELECT PAYMENT METHOD",
                                                      style:
                                                          GoogleFonts.lexendExa(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300),
                                                    ),
                                                  ),
                     ),
               
    
                  ],
                 ),
               ),








                         
                            // tabview three 3 summary ===========================================================================================
                            KeepPageAlive(
                                child: Container(
                              color: const Color(0xffF6F5F1),
                              padding: const EdgeInsets.all(10),
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Column(
                                  children: [
                                    // tick mark row order place text

                                    Container(
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.only(top: 20),
                                      child: SvgPicture.asset(
                                                "assets/images/tickmark.svg"),
                                    ),

                                     Container(
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.only(top: 10),

                                       child: Text(
                                                    "Thank you! ${sharedPreferences.getString(SizValue.firstname)}",
                                                    style: GoogleFonts.lexendDeca(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.w500),
                                                  ),
                                     ),

                                     Container(
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.only(top: 10),
                                      child:  Text(
                                                  "Your rent request #$orderNumber has been\nsubmitted.",
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  textAlign: TextAlign.center,
                                                  style:  GoogleFonts.lexendDeca(
                                                    fontWeight: FontWeight.w300,
                                                      color: Colors.black,
                                                      fontSize: 14),
                                                ),
                                     ),
                    
                                 
                    
                                    const SizedBox(height: 10),
                                    // text 2
                    
                                    Container(
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.only(
                                          left: 10, right: 10,top: 10),
                                      child:  Text(
                                        "We sent an acknowledgement email to ",
                                        maxLines: 2,
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.lexendDeca(
                                          fontWeight: FontWeight.w400,
                                            color: const Color.fromARGB(255, 105, 105, 105), fontSize: 14),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.only(
                                          left: 10, right: 10,),
                                      child:  Text(
                                        "${sharedPreferences.getString(SizValue.email)}",
                                        maxLines: 2,
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.lexendDeca(
                                          decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.w400,
                                            color: Colors.blue, fontSize: 14),
                                      ),
                                    ),
                    
                                    const SizedBox(height: 20),
                    
                                    Container(
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child:  Text(
                                        "We’ll keep you updated on your rental status.",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style:  GoogleFonts.lexendDeca(
                                          fontWeight: FontWeight.w300,
                                            color: Colors.black, fontSize: 14),
                                      ),
                                    ),

                                    Container(
                                      margin: const EdgeInsets.only(top: 30),
                                      width: MediaQuery.of(context).size.width,
                                      height: 1,
                                      color:const Color(0xffC9C9C9)
                                    ),
                                    // text 3
                    
                                    // const SizedBox(height: 20),
                    
                                    // Container(
                                    //   alignment: Alignment.centerLeft,
                                    //   margin: const EdgeInsets.only(
                                    //       left: 10, right: 10),
                                    //   child:  Text(
                                    //     "Time placed: ${DateTime.now()}",
                                    //     maxLines: 2,
                                    //     overflow: TextOverflow.ellipsis,
                                    //     style:  GoogleFonts.lexendDeca(
                                    //       fontWeight: FontWeight.w400,
                                    //         color: Colors.black, fontSize: 14),
                                    //   ),
                                    // ),
                                    // text 4
                    
                                    const SizedBox(height: 30),
                    
                                    // Shipping details=========================================
                    
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      margin: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child:  Text(
                                        orderPunchReponse["delivery_type"].toString()=="2"?  "Pickup Address"  : "Shipping Address",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style:  GoogleFonts.lexendDeca(
                                          fontWeight: FontWeight.w300,
                                            color: Colors.black, fontSize: 14),
                                      ),
                                    ),
                    
                                    // company name
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      margin: const EdgeInsets.only(
                                          left: 20,
                                          right: 10,
                                          top: 10,
                                          bottom: 5),
                                      child:  Text(
                    
                                          placedAddress.isEmpty?"":  placedAddress["name"].toString(),
                                        
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style:  GoogleFonts.lexendDeca(
                                          fontWeight: FontWeight.w300,
                                          letterSpacing: 2,
                                            color: Colors.black, fontSize: 15),
                                      ),
                                    ),
                                
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      margin: const EdgeInsets.only(
                                          left: 20, right: 10),
                                      child:  Text(
                                         placedAddress.isEmpty?"":  placedAddress["number"].toString(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.lexendDeca(
                                          fontWeight: FontWeight.w300,
                                            color: const Color(0xff6F6F6F), fontSize: 13),
                                      ),
                                    ),
                                    // company address
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      margin: const EdgeInsets.only(
                                          left: 20, right: 10, top: 5),
                                      child:  Text(
                                       placedAddress.isEmpty?"":  placedAddress["full_address"].toString(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style:  GoogleFonts.lexendDeca(
                                          fontWeight: FontWeight.w300,
                                            color: const Color(0xff6F6F6F), fontSize: 13),
                                      ),
                                    ),


                                     Container(
                                      margin: const EdgeInsets.only(top: 30),
                                      width: MediaQuery.of(context).size.width,
                                      height: 1,
                                      color:const Color(0xffC9C9C9)
                                    ),
                    
                                    // Billing details=========================================
                    
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      margin: const EdgeInsets.only(
                                          left: 10, right: 10, top: 30),
                                      child: Text(
                                        "Billing",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style:  GoogleFonts.lexendDeca(
                                          fontWeight: FontWeight.w300,
                                            color: Colors.black, fontSize: 14),
                                      ),
                                    ),
                    
                                    // company name
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      margin: const EdgeInsets.only(
                                          left: 20,
                                          right: 10,
                                          top: 10,
                                          bottom: 5),
                                      child:  Text(
                                     placedAddress.isEmpty?"":  placedAddress["name"].toString(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style:   GoogleFonts.lexendDeca(
                                          fontWeight: FontWeight.w300,
                                          letterSpacing: 2,
                                            color: Colors.black, fontSize: 15),
                                      ),
                                    ),
                                  
                                    // company phone
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      margin: const EdgeInsets.only(
                                          left: 20, right: 10),
                                      child:  Text(
                                        placedAddress.isEmpty?"":  placedAddress["number"].toString(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style:   GoogleFonts.lexendDeca(
                                          fontWeight: FontWeight.w300,
                                            color: const Color(0xff6F6F6F), fontSize: 13),
                                      ),
                                    ),
                                    // company address
                                     Container(
                                      alignment: Alignment.centerLeft,
                                      margin: const EdgeInsets.only(
                                          left: 20, right: 10, top: 5),
                                      child:  Text(
                                       placedAddress.isEmpty?"":  placedAddress["full_address"].toString(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style:   GoogleFonts.lexendDeca(
                                          fontWeight: FontWeight.w300,
                                            color: const Color(0xff6F6F6F), fontSize: 13),
                                      ),
                                    ),


                                     Container(
                                      margin: const EdgeInsets.only(top: 30),
                                      width: MediaQuery.of(context).size.width,
                                      height: 1,
                                      color:const Color(0xffC9C9C9)
                                    ),
                    
                                    // order items text
                    
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      margin: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 30,
                                          bottom: 20),
                                      child:  Text(
                                        "Order Items",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.lexendDeca(
                                          fontWeight: FontWeight.w300,
                                            color: Colors.black, fontSize: 14),
                                      ),
                                    ),
                    
                                  
                    
                                    // list of items ordered
                                    ListView.builder(
                                      
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: placedOrderList.length,
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            margin:
                                                const EdgeInsets.only(bottom: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                // image
                                               CachedNetworkImage(
                                                imageUrl: placedOrderList[index]["img_url"],
                                                
                                                  width: 94,
                                                  height: 91,
                                                  fit: BoxFit.cover,
                                                ),
                    
                                                // text des
                    
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                       Text(
                                                      placedOrderList[index]["title"].toString(),
                                                        style: GoogleFonts.lexendDeca(
                                                            color: Colors.black,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w300),
                                                      ),
                                                      const SizedBox(height: 5),
                                                       Text(
                                                        "Color: ${placedOrderList[index]["color"]}",
                                                        style: GoogleFonts.lexendDeca(
                                                          fontWeight: FontWeight.w300,
                                                          color:
                                                              const Color(0xff868E96),
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 3),


                                                      placedOrderList[index]["category_id"].toString()=="1"?


                                                        Text(
                                                       "Size: ${placedOrderList[index]["size_name"]}",
                                                       style:GoogleFonts.lexendDeca(
                                                          fontWeight: FontWeight.w300,
                                                           color: const Color(
                                                               0xff868E96),
                                                           fontSize: 15,
                                                          ),
                                                          ):


                                                      Text(
                                                       "Refundable deposit: AED ${placedOrderList[index]["deposit_amount"]}",
                                                       style:GoogleFonts.lexendDeca(
                                                          fontWeight: FontWeight.w300,
                                                           color: const Color(
                                                               0xff868E96),
                                                           fontSize: 15,
                                                          ),
                                                          ),

                                                          Container(
                                                            alignment: Alignment.centerRight,
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 5),
                                                            child:  Text(
                                                              
                                                              "AED ${placedOrderList[index]["total_amount"]}",
                                                              style: GoogleFonts.lexendDeca(
                                                                color:
                                                                    Colors.black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                          ),
                                                    ],
                                                  ),
                                                ),
                    
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                    
                                    // order summery text
                    
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      margin: const EdgeInsets.only(
                                          left: 10, right: 10, top: 20),
                                      child:  Text(
                                        "Order Summary",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.lexendDeca(
                                          fontWeight: FontWeight.w300,
                                            color: Colors.black, fontSize: 15),
                                      ),
                                    ),
                    
                                    // row one subtotal
                    
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 10, right: 10, top: 10),
                                      child:  Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                           Text(
                                            "Subtotal",
                                            style: GoogleFonts.lexendDeca(
                                              fontWeight: FontWeight.w300,
                                                color: Colors.black,
                                                fontSize: 13),
                                          ),
                                          Text(
                                          "AED ${orderPunchReponse["sub_amount"]}",
                                            style:  GoogleFonts.lexendDeca(
                                              fontWeight: FontWeight.w300,
                                                color: Colors.black,
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // row two Shipping
                    
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 10, right: 10, top: 7),
                                      child:  Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Shipping",
                                            style: GoogleFonts.lexendDeca(
                                              fontWeight: FontWeight.w300,
                                                color: Colors.black,
                                                fontSize: 13),
                                          ),
                                          Text(
                                            "AED 0",
                                            style:  GoogleFonts.lexendDeca(
                                              fontWeight: FontWeight.w300,
                                                color: Colors.black,
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Visibility(
                                       visible: orderPunchReponse["wallet_amount"].toString()=="0"?false:true,
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 10, right: 10, top: 7),
                                        child:  Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Used Siz Credit",
                                              style: GoogleFonts.lexendDeca(
                                                fontWeight: FontWeight.w300,
                                                  color: Colors.black,
                                                  fontSize: 13),
                                            ),
                                            Text(
                                              "AED ${orderPunchReponse["wallet_amount"]}",
                                              style:  GoogleFonts.lexendDeca(
                                                fontWeight: FontWeight.w300,
                                                  color: Colors.black,
                                                  fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: orderPunchReponse["discount"].toString()=="0"?false:true,
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 10, right: 10, top: 7),
                                        child:  Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Discount",
                                              style: GoogleFonts.lexendDeca(
                                                fontWeight: FontWeight.w300,
                                                  color: Colors.black,
                                                  fontSize: 13),
                                            ),
                                            Text(
                                              "- AED ${orderPunchReponse["discount"]}",
                                              style:  GoogleFonts.lexendDeca(
                                                fontWeight: FontWeight.w300,
                                                  color: Colors.black,
                                                  fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: orderPunchReponse["damage_protection_amt"].toString()=="0"?false:true,
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 10, right: 10, top: 7),
                                        child:  Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Damage Protection",
                                              style: GoogleFonts.lexendDeca(
                                                fontWeight: FontWeight.w300,
                                                  color: Colors.black,
                                                  fontSize: 13),
                                            ),
                                            Text(
                                              "AED ${orderPunchReponse["damage_protection_amt"]}",
                                              style:  GoogleFonts.lexendDeca(
                                                fontWeight: FontWeight.w300,
                                                  color: Colors.black,
                                                  fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                    
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 1,
                                      color: const Color(0xffEEEFF0),
                                      margin: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 10,
                                          bottom: 5),
                                    ),
                                    // row three total
                    
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 10, right: 10, top: 5),
                                      child:  Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                           Text(
                                            "Total",
                                            style: GoogleFonts.lexendDeca(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w300),
                                          ),
                                          Text(
                                            "AED $finalamount",
                                            style: GoogleFonts.lexendDeca(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ],
                                      ),
                                    ),
                    
                                    // back to shopping button
                    
                                    InkWell(
                                      onTap: () {

                     final BottomNavController controller = Get.put(BottomNavController());
                       
                        controller.updateIndex(0);
  


                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const Home()),
                                            (route) => false);
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            bottom: 20,
                                            top: 20),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        width: MediaQuery.of(context).size.width,
                                        height: 40,
                                        child: Text(
                                          "BACK TO HOME",
                                          style: GoogleFonts.lexendExa(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )),
                          ]),
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }

  bottomsheet(
      String typestr,
      String addressID,
      String appartment,
      String buildingname,
      String area,
      String state,
      String contactname,
      String mobilenumber,
      String type) {
    return showModalBottomSheet(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
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
                        const SizedBox(height: 10),
                        Row(

                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                        
                          children: [
                            InkWell(
                              onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ManageAddress(
                                    from: 'ShoppingPaymentSummery',
                                    appartment: appartment,
                                    buildingName: buildingname,
                                    area: area,
                                    state: state,
                                    pickupUpName: contactname,
                                    mobile: mobilenumber,
                                    edit: true,
                                    type: type,
                                    addressId: addressID,
                                  )));
                    },
                              child: Container(
                                padding: const EdgeInsets.only(left: 10,right:10),
                             
                                alignment: Alignment.center,
                                height: 40,
                                
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(5)
                                ),
                                child: Text(
                                  "Edit Address".toUpperCase(),
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
                      deleteAddressbottomsheet(addressID);
                    },
                              child: Container(
                                padding: const EdgeInsets.only(left: 10,right:10),
                              
                                 alignment: Alignment.center,
                                height: 40,
                                
                                decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(5)
                                ),
                                child: Text(
                                  "Delete Address".toUpperCase(),
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


  // Payment =============================================================================================================================

  Map<String, dynamic> paymentIntentResponse = {};

    createPaymentIntent() async {

       dialodShow();

      SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    try {
      //Request body
      Map<String, dynamic> body = {
        "user_key":sharedPreferences.getString(SizValue.userKey).toString(),
        'amount': grandTotal.toString(),
        'cart_type': widget.carttype
      };

      //Make post request to Stripe
      var response = await http.post(
          Uri.parse(SizValue.stripeIntent),
       
        body: body,
      );

      paymentIntentResponse=json.decode(response.body);

      print(paymentIntentResponse.toString());

      if(paymentIntentResponse["success"]==true)
      {
         Navigator.pop(context);
         return json.decode(response.body);
        
      }
      else if(paymentIntentResponse["success"]==false)
      { 
        Navigator.pop(context);
        mysnackbar(paymentIntentResponse["error"].toString(), context);
      }

  
     
    

   
        }  on ClientException {
      Navigator.pop(context);
      mysnackbar(
          "Server not responding please try again after sometimev", context);
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



  makePayment() async {

    

    
    try {
     
      //STEP 1: Create Payment Intent
      paymentIntent = await createPaymentIntent();
      
      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
            
              paymentSheetParameters: SetupPaymentSheetParameters(
                 
                  paymentIntentClientSecret: paymentIntent['client_secret'], //Gotten from payment intent
                  customerId: paymentIntent['customer'],
                   
                  customerEphemeralKeySecret: paymentIntent['ephemeralKey'],
                  style: ThemeMode.light,
                 
                  merchantDisplayName: 'SIZ'))
          .then((value) {

          });

       displayPaymentSheet(paymentIntent["pid"].toString());
    } catch (err) {
      throw Exception(err);
    }
  }



  firebaseEventCalled()
  {
    
     try {
      FacebookAppEvents facebookAppEvents = FacebookAppEvents();

      facebookAppEvents.logEvent(
        name: "OrderPlaceAndroid",
      );
    } catch (e) {}
  }


  displayPaymentSheet(String paymentId) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {

        
      
        //Clear paymentIntent variable after successful payment
         orderPunch(paymentId);

        paymentIntent.clear();

        firebaseEventCalled();

      


        setState(() {
           tabController2.animateTo(2);
          
        });
       

                                                                                              

      
      })
      .onError((error, stackTrace) {
        throw Exception(error);
      });
    } 
    on StripeException catch (e) {
    print('Error is:---> $e'); 
    } 
    catch (e) {
      print('$e');
    }
  }



  // order punch =====================================================================================

  orderPunch(String paymentID) async {
    


    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    dialodShow();
    try {
      final response = await http.post(Uri.parse(SizValue.orderCreate), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey),
        'address_id': preSelectedAddress,
        'promocode_id': widget.promoCode,
        'delivery_type': deliveryType,
        'damage_protection': widget.damageProtection,
        'total_amount':widget.price,
        'wallet_amount':creditAppliedAmount.toString(),
        'paid_amount':grandTotal.toString(),
        'cart_ids':widget.cartID,
        'payment_ref':paymentID
       
      });

   
     orderPunchReponse = jsonDecode(response.body);

    

  

      if (orderPunchReponse["success"] == true) {


        setState(() {

           finalamount=orderPunchReponse["final_amount"].toString();
           orderNumber=orderPunchReponse["order_no"].toString();
           placedAddress=orderPunchReponse["address"];
           placedOrderList=orderPunchReponse["order_list"];
            
          
           
          
        });
        
       
      
        Navigator.pop(context);

     
      } else if (orderPunchReponse["success"] == false) {

       print(orderPunchReponse.toString());
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(orderPunchReponse["error"].toString(),style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
    
      }

      


   
    } on ClientException {
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

  // simple dialog =============================================================================================

   dialodShow() {
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



    // confirm delete address

    deleteAddressbottomsheet(String id) {
      showModalBottomSheet(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          context: context,
          builder: (context) {
            return Container(
                margin: const EdgeInsets.only(top: 10, bottom: 30),
                child: Wrap(
                  children: [
                    Column(
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
                          margin: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 10),
                          child:  Text(
                              "Sure do you want to delete this address?",
                              style: GoogleFonts.lexendDeca(
                                  color: MyColors.themecolor,
                                  fontSize: 15,
                                  
                                  fontWeight: FontWeight.w400)),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                
                              },
                              child: Container(
                                  padding: const EdgeInsets.only(left: 10,right:10),
                                                        
                              alignment: Alignment.center,
                              height: 40,
                              
                              decoration: BoxDecoration(
                                                        color: Colors.black,
                                                        borderRadius: BorderRadius.circular(5)
                              ),
                                child: Text(
                                  "No".toUpperCase(),
                                  style:  GoogleFonts.lexendExa(
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

                              

                              controller.deleteAddress(context, id, true);
                              
                              Navigator.pop(context);
                                
                              },
                              child: Container(
                                padding: const EdgeInsets.only(left: 10,right:10),
                              
                                alignment: Alignment.center,
                                height: 40,
                                
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
                      ],
                    )
                  ],
                ));
          });
    }
}
