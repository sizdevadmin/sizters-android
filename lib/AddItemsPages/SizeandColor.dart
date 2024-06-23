// ignore_for_file: use_build_context_synchronously, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'dart:io';

import 'package:accordion/accordion.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siz/AddItemsPages/ImageSelect.dart';
import 'package:siz/Utils/Colors.dart';
import 'package:siz/Utils/ListingController.dart';
import 'package:siz/Utils/Value.dart';

import 'package:http/http.dart' as http;

class SizeandColor extends StatefulWidget {
  const SizeandColor({super.key});

  @override
  State<SizeandColor> createState() => _SizeandColorState();
}

class _SizeandColorState extends State<SizeandColor> {
    TextStyle headerStyle =
      GoogleFonts.lexendDeca(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w300);

  late PageController controller;

  @override
  void initState() {
    getSizes();
    controller = PageController(initialPage: 0, keepPage: true);
    super.initState();
  }

  int currentPage = 0;



  int selectedIndex = -1;

  ListingController controllerList=Get.put(ListingController());


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
  List<dynamic> freeSize = [];




      // get Sizes =====================================================================================

  getSizes() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    dialodShow();
    try {
      final response = await http.post(Uri.parse(SizValue.getSizes), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey).toString(),
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
         freeSize=sizeResponse["list_7"];
         
        
         
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



    // get colors =====================================================================================

  getColors() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    dialodShow();
    try {
      final response = await http.post(Uri.parse(SizValue.getColors), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey).toString(),
      });

      colorResponse = jsonDecode(response.body);

      if (colorResponse["success"] == true) {
        Navigator.pop(context);

        setState(() {
          decordedcolorResponse = colorResponse["list"];
        
         
        });
      } else if (colorResponse["success"] == false) {
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
            decoration: const BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Color.fromARGB(255, 228, 228, 228),
                  blurRadius: 2,
                  offset: Offset(0, 2))
            ]),
            padding:
                const EdgeInsets.only( left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: () {
                      if (currentPage == 1) {
                        controller.previousPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.linear);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: SvgPicture.asset("assets/images/backarrow.svg",width: 20,height: 20,)),
                Image.asset(
                  "assets/images/appiconpng.png",
                  height: 40,
                  width: 40,
                ),
                const SizedBox(width: 30, height: 0)
              ],
            ),
          ),

          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: controller,
              onPageChanged: (value) {
                setState(() {
                  currentPage = value;
                
                });
              },
              scrollDirection: Axis.vertical,
              children: [
                // accord =============================================================================================

                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                          margin: const EdgeInsets.only(top: 30),
                          alignment: Alignment.center,
                          child: Text(
                            'What is the size of your item?',
                            style: GoogleFonts.dmSerifDisplay(
                            fontWeight: FontWeight.w400,
                                fontSize: 20, color: Colors.black),
                          )),
                      Accordion(
                        headerBorderColorOpened: Colors.transparent,
                        // headerBorderWidth: 1,
                        headerBackgroundColorOpened: Colors.white,
                        contentBackgroundColor: Colors.white,
                        headerBackgroundColor: Colors.white,
                        rightIcon:
                            SvgPicture.asset("assets/images/arrowdown.svg"),
                        contentBorderColor: Colors.white,
                        contentBorderWidth: 3,
                        contentHorizontalPadding: 20,
                        scaleWhenAnimating: false,
                       disableScrolling: true,
                        openAndCloseAnimation: true,
                        headerPadding: const EdgeInsets.symmetric(
                            vertical: 7, horizontal: 15),
                      
                        children: [
                         
                      
                      
                      
                           AccordionSection(
                            isOpen: true,
                            contentVerticalPadding: 10,
                            header:  Text('FREE SIZE', style: headerStyle),
                            content: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                      
                             children: freeSize.map((e) =>
                      
                      
                                   InkWell(
                      
                               
                      
                                  onTap: () {
                      
                                       controllerList.addValue(SizValue.size, e["title"].toString()+"+"+e["id"].toString());
                      
                                       getColors();
                      
                                    controller.nextPage(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.linear);
                                  },
                                  child: Container(
                                      margin: const EdgeInsets.only(bottom: 15),
                                      alignment: Alignment.centerLeft,
                                      child:  Text(e["title"].toString(),style:  GoogleFonts.lexendDeca(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w300))),
                                ),
                             
                             
                             
                             ).toList()
                       
                      
                            
                            ),
                          ),
                      
                      
                      
                      
                          AccordionSection(
                            isOpen: true,
                            contentVerticalPadding: 10,
                            header:  Text('S-M-L', style: headerStyle),
                            content: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                      
                             children: smlSizes.map((e) =>
                      
                      
                                   InkWell(
                      
                               
                      
                                  onTap: () {
                      
                                       controllerList.addValue(SizValue.size, e["title"].toString()+"+"+e["id"].toString());
                      
                                       getColors();
                      
                                    controller.nextPage(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.linear);
                                  },
                                  child: Container(
                                      margin: const EdgeInsets.only(bottom: 15),
                                      alignment: Alignment.centerLeft,
                                      child:  Text(e["title"].toString(),style:  GoogleFonts.lexendDeca(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w300))),
                                ),
                             
                             
                             
                             ).toList()
                       
                      
                            
                            ),
                          ),
                          AccordionSection(
                            isOpen: true,
                            contentVerticalPadding: 10,
                            header:  Text('IT', style: headerStyle),
                            content: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                                
                                
                             children: itSizes.map((e) =>
                      
                      
                                   InkWell(
                      
                               
                      
                                  onTap: () {
                      
                                       controllerList.addValue(SizValue.size, e["title"].toString()+"+"+e["id"].toString());
                      
                                       getColors();
                      
                                    controller.nextPage(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.linear);
                                  },
                                  child: Container(
                                      margin: const EdgeInsets.only(bottom: 15),
                                      alignment: Alignment.centerLeft,
                                      child:  Text(e["title"].toString(),style:  GoogleFonts.lexendDeca(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w300))),
                                ),
                             
                             
                             
                             ).toList()
                            ),
                          ),
                      
                              AccordionSection(
                            isOpen: true,
                            contentVerticalPadding: 10,
                            header:  Text('EU', style: headerStyle),
                            content: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                                
                                
                             children: euSizes.map((e) =>
                      
                      
                                   InkWell(
                      
                               
                      
                                  onTap: () {
                      
                                       controllerList.addValue(SizValue.size, e["title"].toString()+"+"+e["id"].toString());
                      
                                       getColors();
                      
                                    controller.nextPage(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.linear);
                                  },
                                  child: Container(
                                      margin: const EdgeInsets.only(bottom: 15),
                                      alignment: Alignment.centerLeft,
                                      child:  Text(e["title"].toString(),style:  GoogleFonts.lexendDeca(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w300))),
                                ),
                             
                             
                             
                             ).toList()
                            ),
                          ),
                      
                              AccordionSection(
                            isOpen: true,
                            contentVerticalPadding: 10,
                            header:  Text('FR', style: headerStyle),
                            content: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                                
                                
                             children: frSizes.map((e) =>
                      
                      
                                   InkWell(
                      
                               
                      
                                  onTap: () {
                      
                                       controllerList.addValue(SizValue.size, e["title"].toString()+"+"+e["id"].toString());
                      
                                       getColors();
                      
                                    controller.nextPage(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.linear);
                                  },
                                  child: Container(
                                      margin: const EdgeInsets.only(bottom: 15),
                                      alignment: Alignment.centerLeft,
                                      child:  Text(e["title"].toString(),style:  GoogleFonts.lexendDeca(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w300))),
                                ),
                             
                             
                             
                             ).toList()
                            ),
                          ),
                      
                              AccordionSection(
                            isOpen: true,
                            contentVerticalPadding: 10,
                            header:  Text('UK', style: headerStyle),
                            content: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                                
                                
                             children: ukSizes.map((e) =>
                      
                      
                                   InkWell(
                      
                               
                      
                                  onTap: () {
                      
                                       controllerList.addValue(SizValue.size, e["title"].toString()+"+"+e["id"].toString());
                      
                                       getColors();
                      
                                    controller.nextPage(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.linear);
                                  },
                                  child: Container(
                                      margin: const EdgeInsets.only(bottom: 15),
                                      alignment: Alignment.centerLeft,
                                      child:  Text(e["title"].toString(),style:  GoogleFonts.lexendDeca(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w300))),
                                ),
                             
                             
                             
                             ).toList()
                            ),
                          ),
                      
                              AccordionSection(
                            isOpen: true,
                            contentVerticalPadding: 10,
                            header:  Text('US', style: headerStyle),
                            content: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                                
                                
                             children: usSizes.map((e) =>
                      
                      
                                   InkWell(
                      
                               
                      
                                  onTap: () {
                      
                                       controllerList.addValue(SizValue.size, e["title"].toString()+"+"+e["id"].toString());
                      
                                       getColors();
                      
                                    controller.nextPage(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.linear);
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
                    ],
                  ),
                ),

                // select color ============================================================================================

                SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                          margin: const EdgeInsets.only(top: 30, left: 15,bottom: 30),
                          alignment: Alignment.center,
                          child: Text(
                            'Select color of your item.',
                           style: GoogleFonts.dmSerifDisplay(
                          fontWeight: FontWeight.w400,
                              fontSize: 20, color: Colors.black),
                          )),
                      DynamicHeightGridView(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: decordedcolorResponse.length,
                          crossAxisCount: 3,
                          mainAxisSpacing: 10,
                          builder: (context, index) {
                            return Center(
                              child: InkWell(
                                splashFactory: NoSplash.splashFactory,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index;
                                  });
                                },
                                child: Wrap(
                                  direction: Axis.vertical,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  alignment: WrapAlignment.center,
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Color(
                                                       int.parse( "0xff"+decordedcolorResponse[index]['outline'])
                                                        
                                                        ),
                                                    spreadRadius: 2)
                                              ],
                                              color: Color(
                                                
                                                
                                                int.parse( "0xff"+decordedcolorResponse[index]['code'])
                                                
                                                ),
                                              shape: BoxShape.circle),
                                        ),
                                        Visibility(
                                            visible: decordedcolorResponse[index]["name"].toString()=="Other" ? true : false,
                                            // visible: true,
                
                                            child: SvgPicture.asset(
                                              "assets/images/questionmark.svg",
                                              height: 25,
                                              width: 25,
                                            )),
                                        Visibility(
                                            visible: selectedIndex == index
                                                ? true
                                                : false,
                                            child: SvgPicture.asset(
                                              "assets/images/tick.svg",
                                              height: 25,
                                              width: 25,
                                            ))
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      decordedcolorResponse[index]["name"].toString(),
                                      style: GoogleFonts.lexendDeca(
                                          color: Colors.black,fontWeight: FontWeight.w300, fontSize: 12),
                                    ),
                                    const SizedBox(height: 10,)
                                  ],
                                ),
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Visibility(
            visible: currentPage == 1 ? true : false,
            child: InkWell(
              onTap: () async {

             if(selectedIndex==-1)
                {
     

               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select color"),duration: Duration(seconds: 1),));



                }

             else

                {


                controllerList.addValue(SizValue.frontImage, "");
                controllerList.addValue(SizValue.backImage, "");
                controllerList.addValue(SizValue.tagview, "");
                controllerList.addValue(SizValue.additional1, "");
                controllerList.addValue(SizValue.additional2, "");
                controllerList.addValue(SizValue.additional3, "");
                controllerList.addValue(SizValue.additional4, "");
                controllerList.addValue(SizValue.additional5, "");


                  
                  controllerList.addValue(SizValue.color, "${decordedcolorResponse[selectedIndex]["name"]}+${decordedcolorResponse[selectedIndex]["id"]}");

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ImageSelect()));

                }


              },
              child: Container(
                 margin: const EdgeInsets.only(
                                    left: 10, right: 10, bottom: 30, top: 10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(5)),
                                width: MediaQuery.of(context).size.width,
                               height: 40,
                child:  Text(
                  "Next".toUpperCase(),
                   style: GoogleFonts.lexendExa(
                                      color: Colors.white, fontSize: 16,fontWeight: FontWeight.w300),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
