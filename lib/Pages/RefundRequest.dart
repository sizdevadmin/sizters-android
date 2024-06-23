// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:convert';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siz/Controllers/RentDetailsController.dart';
import 'package:siz/Utils/Colors.dart';
import 'dart:io';

import 'package:siz/Utils/Value.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';


class RefundRequest extends StatefulWidget {

  String orderId="";
  String imageString="";
  String productId="";
  RefundRequest({super.key,required this.orderId,required this.imageString, required this.productId});

  @override
  State<RefundRequest> createState() => _RefundRequestState();
}

class _RefundRequestState extends State<RefundRequest> {

  
  List<String> dropDownList = [
    "Item Doesn't Fit",
    'Item not as per description',
    'Damaged Item',
    'Other (Please Specify)',
    
  ];




    Map<String, dynamic> returnResponse = {};
  

  punchReturnRequest() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      final response =
          await http.post(Uri.parse(SizValue.orderReturn), body: {
         'user_key': sharedPreferences.getString(SizValue.userKey),
         'id': widget.productId,
         'reason': retrunReason,
         'info': moreInfo,
     
      });

      returnResponse = jsonDecode(response.body);

      if (returnResponse["success"] == true) {
          showMydialog();
      } else if (returnResponse["success"] == false) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(returnResponse["error"].toString(),style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
      }
    } on ClientException {
      mysnackbar(
          "Server not responding please try again after sometime", context);
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

  String retrunReason="";
  String moreInfo="";
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
          decoration: const BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                color: Color.fromARGB(255, 197, 197, 197),
                blurRadius: 2,
                offset: Offset(0, 3))
          ]),
          padding:
              const EdgeInsets.only( left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SvgPicture.asset("assets/images/backarrow.svg",width: 20,height: 20,)),
              Container(
                  margin: const EdgeInsets.only(),
                  child:  Text(
                    "Return Request".toUpperCase(),
                    style:SizValue.toolbarStyle,
                  )),
             const SizedBox(
              height: 20,width: 20,
             )
            ],
          ),
        ),
      
          // body ================================================================
      
      
      
      // top text 

      Expanded(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [

             Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(left: 15,top: 15,bottom: 10),
          child:  Text("Order Number : #${widget.orderId}",style:  GoogleFonts.lexendDeca(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 22))),
      
      
      // main image
           
      
           Container(
            margin: const EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
            child: CachedNetworkImage(imageUrl: widget.imageString,width: MediaQuery.of(context).size.width,height: 300,fit:BoxFit.cover,)),
            
      
            // return text and dropdown
      
          
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left: 20,top: 10),
            child:  Text("Reason for Return",style: GoogleFonts.lexendDeca(
              fontSize: 16,fontWeight: FontWeight.w400
            ),),
          ),
      
      
          // dropdown 
      
      
            Container(
              margin: const EdgeInsets.only(left: 20,right: 20),
              child: CustomDropdown<String>(
                                
                                hideSelectedFieldWhenExpanded: false,
                                hintText: 'Select your reason',
                                items: dropDownList,
                                expandedBorder: Border.all(color: Colors.black),
                               
                                expandedBorderRadius: const BorderRadius.all(Radius.circular(0)),
                                closedBorderRadius: const BorderRadius.all(Radius.circular(0)),
                                closedBorder: Border.all(color: Colors.black),
                                // expandedBorder: Border.all(color: Colors.black),
                                headerBuilder: (context, selectedItem) {
                                  return Text(selectedItem,style: GoogleFonts.lexendDeca(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 14));
                                },
            
                                hintBuilder: (context, hint) {
                                  return Text(hint,style: GoogleFonts.lexendDeca(
                          color: Colors.grey,
                          fontWeight: FontWeight.w300,
                          fontSize: 14));
                                },


                                listItemBuilder: (context, item) {

                                     return Text(item,style: GoogleFonts.lexendDeca(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 14));
                                  
                                },
                                onChanged: (value) {

                              setState(() {

                                  retrunReason=value;
                                
                              });

                                
                                
                                },
                              ),
            ),
      
      
      
       Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left: 20,bottom: 10),
            child:  Text("More Info ( Optional )",style: GoogleFonts.lexendDeca(
              fontSize: 16,fontWeight: FontWeight.w400
            ),),
          ),
      
      
      
      
                   
      Container(
      padding: const EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
      width: MediaQuery.of(context).size.width,
      height: 150,
      margin: const EdgeInsets.only(left: 20,right: 20,bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black)
      ),
      
      child: TextFormField(
        
        maxLines: 8,
        onTapOutside: (event) {
      FocusManager.instance.primaryFocus?.unfocus();
        },


        style: GoogleFonts.lexendDeca(
                                                      
                                                        color:
                                                            Colors.black,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        fontSize: 13),

        onChanged: (value) {
          setState(() {
            moreInfo=value;
          });
        },
        decoration:  InputDecoration(
      
      border: InputBorder.none,
      hintStyle: GoogleFonts.lexendDeca(
                                                      
                                                        color:
                                                            Colors.grey,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        fontSize: 12),
      hintText: "Leave your feedback about this item and lender"
        ),
      ),
      ),
      
      InkWell(
      onTap: () {


        if(retrunReason.isEmpty)
        {
          ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("Please select return reason",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
        }

        else
        {
          
           punchReturnRequest();


        }
       
      },
      child:   Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: const EdgeInsets.only(left: 20,right: 20,top: 15,bottom: 40),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: Colors.black,
      borderRadius: BorderRadius.circular(5)
      
      ),
      child:  Text("REQUEST FOR REFUND",style: GoogleFonts.lexendExa(fontSize: 14,color: Colors.white,fontWeight: FontWeight.w300),),
        ),
      ),
      
      
          ],
        ),
      )
      
        
      
      
        ],
      ) 
      
    );
  }

  showMydialog()
  {
    return 
                 showGeneralDialog(
                context: context,
                barrierLabel: "Barrier",
                barrierDismissible: false,
                barrierColor: Colors.black.withOpacity(0.5),
                transitionDuration: const Duration(milliseconds: 300),
                pageBuilder: (_, __, ___) {
                  return WillPopScope(
                    onWillPop: () async{
                      return false;
                    },
                    child: Center(
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: 20,right: 20),
                        height: 140,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(13)),
                        child:  Scaffold(
                          backgroundColor: Colors.transparent,
                            body: Column( 
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                             Text(
                                "Your return request has been successfully submitted.",textAlign: TextAlign.center,style:GoogleFonts.lexendDeca(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 14)),
                  
                                InkWell(
                                  onTap: () {


    RentDetailsController controller=Get.put(RentDetailsController());

    controller.getRentalDetails(context, widget.productId);

                                    Navigator.pop(context);
                                     Navigator.pop(context);
                                    
                                                                   },
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(top: 15),
                                    padding: const EdgeInsets.only(top: 10,bottom: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(5)
                                    ),
                                    child:  Text("OK",
                                    textAlign: TextAlign.center,
                                   style: GoogleFonts.lexendExa(
        
        fontSize: 16,color: Colors.white,fontWeight: FontWeight.w300)),
                                  ),
                                )
                          ],
                        )),
                      ),
                    ),
                  );
                },
              );
  }
}