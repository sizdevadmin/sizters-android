// ignore_for_file: use_build_context_synchronously

import 'package:custom_radio_group_list/custom_radio_group_list.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siz/Controllers/CartPromoController.dart';
import 'package:siz/Utils/Colors.dart';


class PromoCode extends StatefulWidget {
  const PromoCode({super.key});

  @override
  State<PromoCode> createState() => _PromoCodeState();
}

class _PromoCodeState extends State<PromoCode> {
  String selectedItemNew="";
  late CartPromoController controller;
   

       
  @override
  void initState() {
    controller=Get.put(CartPromoController());
    controller.getPromoCode(context);
    
    super.initState();

     
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
  
  String inputCoupon="";


  @override
  Widget build(BuildContext context) {
    return GetBuilder(
    init: CartPromoController(),
      builder: (controller) {
        return Scaffold(
          
             appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              toolbarHeight: 0,
            ),
        
          body: Column(
        children: [
          // row of apply coupon code ================================================================================
         
          Container(
            margin: const EdgeInsets.only(left: 15,top: 30,bottom: 20),
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: SvgPicture.asset("assets/images/backarrow.svg",width: 20,height: 20,))),

          Row(
            children: [
              Expanded(
                  child: Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                margin: const EdgeInsets.only(left: 30, right: 15),
                decoration: const BoxDecoration(color: Color(0xffF5F5F5)),
                child: TextFormField(
                  decoration:  InputDecoration(
                      border: InputBorder.none,
                      hintText: "Have a coupon code?",
                      hintStyle:
                          GoogleFonts.lexendDeca(fontSize: 13, fontWeight: FontWeight.w300, color: const Color(0xff727272))),

                          onChanged: (value) {
                          setState(() {
                            inputCoupon=value;
                          });
                          },
                ),
              )),
              InkWell(
                onTap: ()async {
                    if(inputCoupon.isEmpty)
                                    {
                                      ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("Please enter promocode",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white)),duration: const Duration(seconds:1),));
                                    }

                                    else

                                    {
                                     await controller.applyPromocode(context, inputCoupon);
                                     Navigator.pop(context);
                                      
                                    }
                },
                child: Container(
                    margin: const EdgeInsets.only(right: 30),
                    child:  Text(
                      "APPLY",
                      style: GoogleFonts.lexendDeca(fontSize: 15, fontWeight: FontWeight.w300, color: Colors.black),

                    )),
              )
            ],
          ),

          const SizedBox(height: 20),

          // radio groups ========================================================================================

          Expanded(
            child: Container(
              transform: Matrix4.translationValues(0, -20, 0),
              margin: const EdgeInsets.only(left: 30,right: 30),
              child: RadioGroup(
                  
                  scrollPhysics: const BouncingScrollPhysics(),
                  items:controller. decordedResponsePromo,
                  selectedItem: selectedItemNew,
                  
                  onChanged: (value) {
                    setState(() {
                      selectedItemNew = value['code'].toString();
                     
                    });
                  },
                  labelBuilder: (ctx, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      
                      
                      
                            
                        // dotted border =========================
                        Container(
                          transform: Matrix4.translationValues(0, 27, 0),
                          
                          child: DottedBorder(
                            dashPattern: const [5,5],
                            color: Colors.black,
                            borderType: BorderType.RRect,
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(7)),
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 5, bottom: 5),
                              
                                child: Wrap(
                                  direction: Axis.horizontal,
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      controller. decordedResponsePromo[index]["code"].toString(),
                                      style: GoogleFonts.lexendDeca(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300
                                      )
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                     
                 
                        Container(
                           transform: Matrix4.translationValues(0, 30, 0),
                          child: Text(
                          controller. decordedResponsePromo[index]["title"].toString(),
                            style: GoogleFonts.lexendDeca(
                                              fontSize: 14,
                                              color: MyColors.themecolor,
                                              fontWeight: FontWeight.w300
                                            )
                          ),
                        ),

                        Container(
                             transform: Matrix4.translationValues(0, 40, 0),
                        margin: const EdgeInsets.only(top: 10),
                        height: 1,
                        color: const Color(0xffEDF1F4),
                        width: MediaQuery.of(context).size.width-120,
                       ),

                       const SizedBox(height: 20,)
                      

                       

                      ],
                    );
                  },
                  shrinkWrap: true,
                  disabled: false),
            ),
          ),

          InkWell(
            onTap:selectedItemNew.isEmpty? null: 
            
            () async {


             await controller.applyPromocode(context, selectedItemNew);
             Navigator.pop(context);
              
            },
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 20,right: 20,bottom: 30),
               height: 40,
              decoration:  BoxDecoration(
                color: selectedItemNew.isEmpty? Colors.grey: Colors.black,
                borderRadius: const BorderRadius.all(Radius.circular(5))
              ),
          
              child: Text("APPLY COUPON",style: GoogleFonts.lexendExa(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w300),),
            ),
          )
        ],
          ),
        );
      }
    );
  }
}
