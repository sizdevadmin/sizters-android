// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:accordion/accordion.dart';
import 'package:accordion/accordion_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:siz/Controllers/FilterController.dart';
import 'package:siz/Pages/Cart.dart';
import 'package:siz/Pages/Wishlist.dart';
import 'package:siz/Utils/Colors.dart';
import 'package:siz/Utils/Value.dart';

class FilterClothesSize extends StatefulWidget {
  const FilterClothesSize({super.key});

  @override
  State<FilterClothesSize> createState() => _FilterClothesSizeState();
}

class _FilterClothesSizeState extends State<FilterClothesSize> {

  late FilterController controller;


  @override
  void initState()
  {

    controller=Get.put(FilterController());

   
    getSizes();

  
    super.initState();
  }


  // getdata() async
  // {

  //    if(!controller.tabbedSize)
  //   {

  //      await getSizes();

  //       // call app
  //      controller.tabbedSize=true;
  //      controller.forseUpdate();
  //   }


  // }

   TextStyle headerStyle =
      GoogleFonts.lexendDeca(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w300);


      
     // list

  Map<String, dynamic> colorResponse = {};
  List<dynamic> decordedcolorResponse = [];


  // list

  
  Map<String, dynamic> sizeResponse = {};
  List<dynamic> smlSizes = [];
  List<dynamic> itSizes = [];
  List<dynamic> euSizes = [];
  List<dynamic> frSizes = [];
  List<dynamic> ukSizes = [];
  List<dynamic> usSizes = [];
  List<dynamic> freeSizes = [];


      // get Sizes =====================================================================================

  getSizes() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    dialodShow();
    try {
      final response = await http.post(Uri.parse(SizValue.getSizes), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey),
        'type':'2'
      });

      sizeResponse = jsonDecode(response.body);

      if (sizeResponse["success"] == true) {
        Navigator.pop(context);

        setState(() {
         

         smlSizes=sizeResponse["list_1"];
         itSizes=sizeResponse["list_2"];
         euSizes=sizeResponse["list_3"];
         frSizes=sizeResponse["list_4"];
         ukSizes=sizeResponse["list_5"];
         usSizes=sizeResponse["list_6"];
         freeSizes=sizeResponse["list_7"];
         
        
         
        });
      } else if (sizeResponse["success"] == false) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(colorResponse["error"],style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
      }
    } on ClientException {
      Navigator.pop(context);
      mysnackbar("Server not responding please try again after sometime");
    } on SocketException {
      Navigator.pop(context);
      mysnackbar("No Internet connection 😑 please try again after sometime");
    } on HttpException {
      Navigator.pop(context);
      mysnackbar("Something went wrong please try after sometime");
    } on FormatException {
      Navigator.pop(context);
      mysnackbar("Something went wrong please try after sometime");
    }
  }


      // snackbar ==================================================================================================

  mysnackbar(String message) {
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



 

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: FilterController(),
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
                      padding:
                          const EdgeInsets.only(right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                width: 50,
                                child:
                                    SvgPicture.asset("assets/images/backarrow.svg",width: 20,height: 20,),
                              )),
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
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                 Wishlist()));
                                  },
                                  child:
                                      SvgPicture.asset("assets/images/heart.svg",width: 20,height: 20,)),
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
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                  

                    // top text =============================================\

                    Container(
                      margin: const EdgeInsets.only(
                          top: 10, left: 10, right: 10, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 45,
                            height: 20,
                          ),
                          Text(
                            'Size',
                            style: GoogleFonts.dmSerifDisplay(
                              fontWeight: FontWeight.w400,
                                fontSize: 20, color: Colors.black),
                          ),
                          InkWell(
                            onTap: () {
                              

                              // controller.getsizeFilter(context);
                              // controller. multipleSelectedSize.clear();

                              controller.selectedSizeName="";
                              controller.selectedSizeID="";
                              
                              controller.forseUpdate();
                              Navigator.pop(context);
  
                               
                            },
                            child:  Text(
                              "Clear",
                              style: GoogleFonts.lexendDeca(fontSize: 16, fontWeight: FontWeight.w300 , color: Colors.black),
                            ),
                          )
                        ],
                      ),
                    ),

                    // body =========================================

                    // selected brands text heading
                    // Visibility(
                    //   visible: controller. multipleSelectedSize.isEmpty ? false : true,
                    //   child: Container(
                    //     margin: const EdgeInsets.only(left: 30, bottom: 10),
                    //     alignment: Alignment.centerLeft,
                    //     child: Text(
                    //       "SELECTED SIZES",
                    //       style: GoogleFonts.lexendExa(
                    //           fontSize: 14,fontWeight: FontWeight.w300 ,color: Colors.black),
                    //     ),
                    //   ),
                    // ),

                    // // selected list

                    // Container(
                    //   margin: const EdgeInsets.only(left: 30, right: 30),
                    //   child: GridView.builder(
                    //       gridDelegate:
                    //           const SliverGridDelegateWithFixedCrossAxisCount(
                    //         crossAxisCount: 2,
                    //         childAspectRatio: 4,
                    //       ),
                    //       padding: const EdgeInsets.all(0),
                    //       shrinkWrap: true,
                    //       physics: const NeverScrollableScrollPhysics(),
                    //       itemCount: controller. multipleSelectedSize.length,
                    //       itemBuilder: (context, index) {
                    //         return InkWell(
                    //           onTap: () {
                    //             int found = controller. checkListItemsSize.indexWhere((item) =>
                    //                 item["title"] ==  (controller.multipleSelectedSize[index]["title"].toString()));


                    //               controller. checkListItemsSize[found]["check"] = false;
                    //               controller. multipleSelectedSize.removeAt(index);
                    //               controller.forseUpdate();
                                   
                    //           },
                    //           child: Container(
                    //             decoration: BoxDecoration(
                    //                 color: Colors.black,
                    //                 borderRadius: BorderRadius.circular(60)),
                    //             alignment: Alignment.center,
                    //             margin: const EdgeInsets.only(
                    //                 left: 5, right: 5, top: 10),
                    //             child: Row(
                    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //               children: [
                    //                 Flexible(
                    //                   child: Container(
                    //                     alignment: Alignment.center,
                    //                     width: MediaQuery.of(context).size.width,
                    //                     margin: const EdgeInsets.only(
                    //                         left: 20, right: 10),
                    //                     child: Text(
                    //                       controller. multipleSelectedSize[index]["title"],
                    //                       overflow: TextOverflow.ellipsis,
                    //                       style:  GoogleFonts.lexendDeca(
                    //                         fontSize: 12.0,
                    //                         fontWeight: FontWeight.w300,
                    //                         color: Colors.white,
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ),
                    //                 Container(
                    //                     margin: const EdgeInsets.only(right: 20),
                    //                     child: SvgPicture.asset(
                    //                       "assets/images/close.svg",
                    //                       height: 10,
                    //                       width: 10,
                    //                       color: Colors.white,
                    //                     ))
                    //               ],
                    //             ),
                    //           ),
                    //         );
                    //       }),
                    // ),

                    // all brands text

                    // Container(
                    //   margin: const EdgeInsets.only(left: 30, top: 30, bottom: 10),
                    //   alignment: Alignment.centerLeft,
                    //   child: Text(
                    //     "SELECT/DESELECT",
                    //     style: GoogleFonts.lexendExa(
                    //       fontWeight: FontWeight.w300,
                    //         fontSize: 14, color: Colors.black),
                    //   ),
                    // ),

                    // // all brands list

                    // Container(
                    //   margin: const EdgeInsets.only(left: 15, right: 15),
                    //   child: ListView.builder(
                    //       physics: const NeverScrollableScrollPhysics(),
                    //       padding: const EdgeInsets.all(0),
                    //       shrinkWrap: true,
                    //       itemCount:  controller.checkListItemsSize.length,
                    //       itemBuilder: (context, index) {
                    //         return Container(
                    //           margin: const EdgeInsets.only(left: 15, right: 15),
                    //           child: CheckboxListTile(
                    //             controlAffinity: ListTileControlAffinity.platform,
                    //             contentPadding: EdgeInsets.zero,
                    //             checkboxShape: RoundedRectangleBorder(
                    //                 borderRadius: BorderRadius.circular(5)),
                    //             dense: true,
                    //             title: Text(
                    //               controller. checkListItemsSize[index]["title"],
                    //               style:  GoogleFonts.lexendDeca(
                    //                 fontSize: 12.0,
                    //                 fontWeight: FontWeight.w300,
                    //                 color: Colors.black,
                    //               ),
                    //             ),
                    //             value: controller.checkListItemsSize[index]["check"],
                    //             onChanged: (value) {
                    //               setState(() {
                    //                 controller. checkListItemsSize[index]["check"] = value;

                    //                 if ( controller. multipleSelectedSize
                    //                     .contains( controller. checkListItemsSize[index])) {
                    //                   setState(() {
                    //                    controller.  multipleSelectedSize.remove( controller.checkListItemsSize[index]);
                    //                    controller.forseUpdate();
                    //                   });
                    //                 } else {
                    //                   setState(() {
                    //                      controller. multipleSelectedSize.add( controller.checkListItemsSize[index]);
                    //                      controller.forseUpdate();
                    //                      print(controller.multipleSelectedSize);
                    //                   });
                    //                 }
                    //               });
                    //             },
                    //           ),
                    //         );
                    //       }),
                    // ),







                          Visibility(
                        visible: freeSizes.isEmpty?false:true,
                         child: Accordion(
                                            
                            paddingListTop: 0,
                          
                          paddingListBottom: 0,
                          
                                             headerBorderColorOpened: Colors.transparent,
                                             // headerBorderWidth: 1,
                                             headerBackgroundColorOpened: Colors.white,
                                             contentBackgroundColor: Colors.white,
                                             headerBackgroundColor: Colors.white,
                                             disableScrolling: true,
                                             rightIcon:
                            SvgPicture.asset("assets/images/arrowdown.svg"),
                                             contentBorderColor: Colors.white,
                                             contentBorderWidth: 3,
                                             contentHorizontalPadding: 20,
                                             scaleWhenAnimating: false,
                         
                                             openAndCloseAnimation: true,
                                             headerPadding: const EdgeInsets.symmetric(
                            vertical: 7, horizontal: 15),
                         
                            children: [
                         
                         
                               AccordionSection(
                            
                            
                            isOpen: true,
                            contentVerticalPadding: 10,
                            header:  Text('FREE SIZES', style: headerStyle),
                            content: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                         
                             children: freeSizes.map((e) =>
                         
                         
                                   InkWell(
                         
                               
                         
                                  onTap: () {
                         
                         
                                    controller.selectedSizeName=e["title"].toString();
                                    controller.selectedSizeID=e["id"].toString();
                                    controller.forseUpdate();
                                     Navigator.pop(context);
                         
                         
                                    
                                  },
                                  child: Container(
                                      margin: const EdgeInsets.only(bottom: 15),
                                      alignment: Alignment.centerLeft,
                                      child:  Text(e["title"].toString(),style:  GoogleFonts.lexendDeca(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w300))),
                                ),
                             
                             
                             
                             ).toList()
                          
                         
                            
                            ),
                          ),
                         
                         
                            ],
                         
                         
                         ),
                       ),








                       Visibility(
                        visible: smlSizes.isEmpty?false:true,
                         child: Accordion(
                                            
                            paddingListTop: 0,
                          
                          paddingListBottom: 0,
                          
                                             headerBorderColorOpened: Colors.transparent,
                                             // headerBorderWidth: 1,
                                             headerBackgroundColorOpened: Colors.white,
                                             contentBackgroundColor: Colors.white,
                                             headerBackgroundColor: Colors.white,
                                             disableScrolling: true,
                                             rightIcon:
                            SvgPicture.asset("assets/images/arrowdown.svg"),
                                             contentBorderColor: Colors.white,
                                             contentBorderWidth: 3,
                                             contentHorizontalPadding: 20,
                                             scaleWhenAnimating: false,
                         
                                             openAndCloseAnimation: true,
                                             headerPadding: const EdgeInsets.symmetric(
                            vertical: 7, horizontal: 15),
                         
                            children: [
                         
                         
                               AccordionSection(
                            
                            
                            isOpen: false,
                            contentVerticalPadding: 10,
                            header:  Text('S-M-L', style: headerStyle),
                            content: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                         
                             children: smlSizes.map((e) =>
                         
                         
                                   InkWell(
                         
                               
                         
                                  onTap: () {
                         
                         
                                    controller.selectedSizeName=e["title"].toString();
                                    controller.selectedSizeID=e["id"].toString();
                                    controller.forseUpdate();
                                     Navigator.pop(context);
                         
                         
                                    
                                  },
                                  child: Container(
                                      margin: const EdgeInsets.only(bottom: 15),
                                      alignment: Alignment.centerLeft,
                                      child:  Text(e["title"].toString(),style:  GoogleFonts.lexendDeca(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w300))),
                                ),
                             
                             
                             
                             ).toList()
                          
                         
                            
                            ),
                          ),
                         
                         
                            ],
                         
                         
                         ),
                       ),

    
                       Visibility(
                        visible: itSizes.isEmpty?false:true,
                         child: Accordion(
                                            
                            paddingListTop: 0,
                          
                          paddingListBottom: 0,
                          
                                             headerBorderColorOpened: Colors.transparent,
                                             // headerBorderWidth: 1,
                                             headerBackgroundColorOpened: Colors.white,
                                             contentBackgroundColor: Colors.white,
                                             headerBackgroundColor: Colors.white,
                                             disableScrolling: true,
                                             rightIcon:
                            SvgPicture.asset("assets/images/arrowdown.svg"),
                                             contentBorderColor: Colors.white,
                                             contentBorderWidth: 3,
                                             contentHorizontalPadding: 20,
                                             scaleWhenAnimating: false,
                         
                                             openAndCloseAnimation: true,
                                             headerPadding: const EdgeInsets.symmetric(
                            vertical: 7, horizontal: 15),
                         
                                             children: [
                          
                          
                          AccordionSection(
                            isOpen: false,
                            contentVerticalPadding: 10,
                            header:  Text('IT', style: headerStyle),
                            content: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                                
                                
                             children: itSizes.map((e) =>
                         
                         
                                   InkWell(
                         
                               
                         
                                  onTap: () {
                         
                                      controller.selectedSizeName=e["title"].toString();
                                    controller.selectedSizeID=e["id"].toString();
                                    controller.forseUpdate();
                                     Navigator.pop(context);
                         
                         
                                    //    controllerList.addValue(SizValue.size, e["title"].toString()+"+"+e["id"].toString());
                         
                                    //    getColors();
                         
                                    // controller.nextPage(
                                    //     duration:
                                    //         const Duration(milliseconds: 500),
                                    //     curve: Curves.linear);
                                  },
                                  child: Container(
                                      margin: const EdgeInsets.only(bottom: 15),
                                      alignment: Alignment.centerLeft,
                                      child:  Text(e["title"].toString(),style:  GoogleFonts.lexendDeca(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w300))),
                                ),
                             
                             
                             
                             ).toList()
                            ),
                          ),
                         
                              
                         
                         
                          
                          
                                             ],
                                           ),
                       ),


                    Visibility(
                      visible: euSizes.isEmpty?false:true,
                      child: Accordion(
                    
                    
                          paddingListTop: 0,
                          
                          paddingListBottom: 0,
                          
                                             headerBorderColorOpened: Colors.transparent,
                                             // headerBorderWidth: 1,
                                             headerBackgroundColorOpened: Colors.white,
                                             contentBackgroundColor: Colors.white,
                                             headerBackgroundColor: Colors.white,
                                             disableScrolling: true,
                                             rightIcon:
                            SvgPicture.asset("assets/images/arrowdown.svg"),
                                             contentBorderColor: Colors.white,
                                             contentBorderWidth: 3,
                                             contentHorizontalPadding: 20,
                                             scaleWhenAnimating: false,
                         
                                             openAndCloseAnimation: true,
                                             headerPadding: const EdgeInsets.symmetric(
                            vertical: 7, horizontal: 15),
                    
                            children: [
                    
                              AccordionSection(
                            isOpen: false,
                            contentVerticalPadding: 10,
                            header:  Text('EU', style: headerStyle),
                            content: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                                
                                
                             children: euSizes.map((e) =>
                    
                    
                                   InkWell(
                    
                               
                    
                                  onTap: () {
                    
                                      controller.selectedSizeName=e["title"].toString();
                                    controller.selectedSizeID=e["id"].toString();
                                    controller.forseUpdate();
                                     Navigator.pop(context);
                    
                    
                                    //    controllerList.addValue(SizValue.size, e["title"].toString()+"+"+e["id"].toString());
                    
                                    //    getColors();
                    
                                    // controller.nextPage(
                                    //     duration:
                                    //         const Duration(milliseconds: 500),
                                    //     curve: Curves.linear);
                                  },
                                  child: Container(
                                      margin: const EdgeInsets.only(bottom: 15),
                                      alignment: Alignment.centerLeft,
                                      child:  Text(e["title"].toString(),style:  GoogleFonts.lexendDeca(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w300))),
                                ),
                             
                             
                             
                             ).toList()
                            ),
                          ),
                    
                            ],
                    
                    
                     
                    
                      ),
                    ),

                    


                  Visibility(
                    visible: frSizes.isEmpty?false:true,
                    child: Accordion(
                      
                      
                  
                          paddingListTop: 0,
                          
                          paddingListBottom: 0,
                          
                                             headerBorderColorOpened: Colors.transparent,
                                             // headerBorderWidth: 1,
                                             headerBackgroundColorOpened: Colors.white,
                                             contentBackgroundColor: Colors.white,
                                             headerBackgroundColor: Colors.white,
                                             disableScrolling: true,
                                             rightIcon:
                            SvgPicture.asset("assets/images/arrowdown.svg"),
                                             contentBorderColor: Colors.white,
                                             contentBorderWidth: 3,
                                             contentHorizontalPadding: 20,
                                             scaleWhenAnimating: false,
                         
                                             openAndCloseAnimation: true,
                                             headerPadding: const EdgeInsets.symmetric(
                            vertical: 7, horizontal: 15),
                      
                      
                      children: [
                        AccordionSection(
                            isOpen: false,
                            contentVerticalPadding: 10,
                            header:  Text('FR', style: headerStyle),
                            content: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                                
                                
                             children: frSizes.map((e) =>
                  
                  
                                   InkWell(
                  
                               
                  
                                  onTap: () {
                  
                                      controller.selectedSizeName=e["title"].toString();
                                    controller.selectedSizeID=e["id"].toString();
                                    controller.forseUpdate();
                                     Navigator.pop(context);
                  
                  
                                    //    controllerList.addValue(SizValue.size, e["title"].toString()+"+"+e["id"].toString());
                  
                                    //    getColors();
                  
                                    // controller.nextPage(
                                    //     duration:
                                    //         const Duration(milliseconds: 500),
                                    //     curve: Curves.linear);
                                  },
                                  child: Container(
                                      margin: const EdgeInsets.only(bottom: 15),
                                      alignment: Alignment.centerLeft,
                                      child:  Text(e["title"].toString(),style:  GoogleFonts.lexendDeca(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w300))),
                                ),
                             
                             
                             
                             ).toList()
                            ),
                          ),
                    ]),
                  ),



                  Visibility(
                      visible: ukSizes.isEmpty?false:true,
                    child: Accordion(
                  
                  
                  
                          paddingListTop: 0,
                          
                          paddingListBottom: 0,
                          
                                             headerBorderColorOpened: Colors.transparent,
                                             // headerBorderWidth: 1,
                                             headerBackgroundColorOpened: Colors.white,
                                             contentBackgroundColor: Colors.white,
                                             headerBackgroundColor: Colors.white,
                                             disableScrolling: true,
                                             rightIcon:
                            SvgPicture.asset("assets/images/arrowdown.svg"),
                                             contentBorderColor: Colors.white,
                                             contentBorderWidth: 3,
                                             contentHorizontalPadding: 20,
                                             scaleWhenAnimating: false,
                         
                                             openAndCloseAnimation: true,
                                             headerPadding: const EdgeInsets.symmetric(
                            vertical: 7, horizontal: 15),
                      
                      
                      children: [
                  
                     
                  
                         AccordionSection(
                            isOpen: false,
                            contentVerticalPadding: 10,
                            header:  Text('UK', style: headerStyle),
                            content: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                                
                                
                             children: ukSizes.map((e) =>
                  
                  
                                   InkWell(
                  
                               
                  
                                  onTap: () {
                  
                                      controller.selectedSizeName=e["title"].toString();
                                      controller.selectedSizeID=e["id"].toString();
                                      controller.forseUpdate();
                                      Navigator.pop(context);
                  
                                    //    controllerList.addValue(SizValue.size, e["title"].toString()+"+"+e["id"].toString());
                  
                                    //    getColors();
                  
                                    // controller.nextPage(
                                    //     duration:
                                    //         const Duration(milliseconds: 500),
                                    //     curve: Curves.linear);
                                  },
                                  child: Container(
                                      margin: const EdgeInsets.only(bottom: 15),
                                      alignment: Alignment.centerLeft,
                                      child:  Text(e["title"].toString(),style:  GoogleFonts.lexendDeca(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w300))),
                                ),
                             
                             
                             
                             ).toList()
                            ),
                          ),
                  
                  
                  
                    ]),
                  ),


                  Visibility(
                    visible: usSizes.isEmpty?false:true,
                    child: Accordion(
                      
                      
                  
                          paddingListTop: 0,
                          
                          paddingListBottom: 0,
                          
                                             headerBorderColorOpened: Colors.transparent,
                                             // headerBorderWidth: 1,
                                             headerBackgroundColorOpened: Colors.white,
                                             contentBackgroundColor: Colors.white,
                                             headerBackgroundColor: Colors.white,
                                             disableScrolling: true,
                                             rightIcon:
                            SvgPicture.asset("assets/images/arrowdown.svg"),
                                             contentBorderColor: Colors.white,
                                             contentBorderWidth: 3,
                                             contentHorizontalPadding: 20,
                                             scaleWhenAnimating: false,
                         
                                             openAndCloseAnimation: true,
                                             headerPadding: const EdgeInsets.symmetric(
                            vertical: 7, horizontal: 15),
                      
                      children: [
                    
                  
                  
                  
                  
                              AccordionSection(
                            isOpen: false,
                            contentVerticalPadding: 10,
                            header:  Text('US', style: headerStyle),
                            content: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                                
                                
                             children: usSizes.map((e) =>
                  
                  
                                   InkWell(
                  
                               
                  
                                  onTap: () {
                  
                                      controller.selectedSizeName=e["title"].toString();
                                    controller.selectedSizeID=e["id"].toString();
                                    controller.forseUpdate();
                                     Navigator.pop(context);
                  
                  
                                    //    controllerList.addValue(SizValue.size, e["title"].toString()+"+"+e["id"].toString());
                  
                                    //    getColors();
                  
                                    // controller.nextPage(
                                    //     duration:
                                    //         const Duration(milliseconds: 500),
                                    //     curve: Curves.linear);
                                  },
                                  child: Container(
                                      margin: const EdgeInsets.only(bottom: 15),
                                      alignment: Alignment.centerLeft,
                                      child:  Text(e["title"].toString(),style:  GoogleFonts.lexendDeca(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w300))),
                                ),
                             
                             
                             
                             ).toList()
                            ),
                          ),
                  
                  
                  
                    ]),
                  )








                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(left: 13, right: 13, bottom: 40),
                  decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: Text(
                    "APPLY FILTER",
                    style: GoogleFonts.lexendExa(color: Colors.white,fontWeight: FontWeight.w300 ,fontSize: 16),
                  ),
                ),
              )
            ],
          ),
        );
      }
    );
  }
}
