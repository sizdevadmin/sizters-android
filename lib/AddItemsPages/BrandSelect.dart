// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siz/AddItemsPages/OnlyColor.dart';
import 'package:siz/AddItemsPages/SizeandColor.dart';
import 'package:siz/Utils/Colors.dart';
import 'package:siz/Utils/ListingController.dart';
import 'package:siz/Utils/Value.dart';

class BrandSelect extends StatefulWidget {
  const BrandSelect({super.key});

  @override
  State<BrandSelect> createState() => _BrandSelectState();
}

class _BrandSelectState extends State<BrandSelect> {
  bool tabafterfirst = false;

  List<Map<dynamic, dynamic>> searchlist = [
    {"keyword": "Ralph Lauren"},
    {"keyword": "Louis Vuitton"},
    {"keyword": "Michael kors"},
    {"keyword": "Fendi"},
    {"keyword": "Pinko"},
    {"keyword": "Nadine Merabi"},
    {"keyword": "Louis Vuitton"},
    {"keyword": "Michael kors"},
    {"keyword": "Other"},
  ];

  String newBrand = "";


      

  List<dynamic> found = [];

  ListingController controller = Get.put(ListingController());

  // list

  Map<String, dynamic> brandResponse = {};
  List<dynamic> decordedResponse = [];
  List<dynamic> popularResponse = [];

  @override
  void initState() {
    getBrands();
    super.initState();
  }

  // get category =====================================================================================

  getBrands() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    dialodShow();
    try {
      final response = await http.post(Uri.parse(SizValue.getBrands), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey).toString(),
       
      });

      brandResponse = jsonDecode(response.body);

   

      if (brandResponse["success"] == true) {
        Navigator.pop(context);

        setState(() {
          decordedResponse = brandResponse["list"];
          popularResponse = brandResponse["popular"];
          found = decordedResponse;
        });
      } else if (brandResponse["success"] == false) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(brandResponse["error"],style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
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
        

            // top header ===========================================================================

            Container(
              alignment: Alignment.center,
              height: 60,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(255, 218, 218, 218),
                      blurRadius: 3,
                      offset: Offset(0, 3))
                ],
              ),
              padding: const EdgeInsets.only(
                  left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
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
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
              
          
                Container(
                    margin: const EdgeInsets.only(top: 30),
                    alignment: Alignment.center,
                    child:   Text(
                'What is the brand of your item?',
                style: GoogleFonts.dmSerifDisplay(fontSize: 20,fontWeight: FontWeight.w400, color: Colors.black),
              )),
               
          
          // animated search bar ===========================================================================
          
                AnimatedContainer(
                  alignment: Alignment.topCenter,
                  height: tabafterfirst ? 500 : 48,
                  margin: const EdgeInsets.only(
                      left: 15, right: 15, top: 30),
                  decoration: BoxDecoration(boxShadow: const [
                    BoxShadow(
                        color: Color.fromARGB(255, 218, 218, 218),
                        blurRadius: 3,
                        offset: Offset(0, 3))
                  ], borderRadius: BorderRadius.circular(15), color: Colors.white),
                  duration: const Duration(milliseconds: 300),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 15),
                          SvgPicture.asset("assets/images/search.svg"),
                          const SizedBox(width: 15),
          
                          // textformfield search
          
                          Flexible(
                              child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                filtersearch(value);
                              });
                            },
                            onTapOutside: (event) {
                              //  setState(() {
                              //    FocusManager.instance.primaryFocus
                              //        ?.unfocus();
                              //  });
                            },
                            enableInteractiveSelection: false,
                            onTap: () async {
                              setState(() {
                                // found = searchlist;
                                tabafterfirst = true;
                              });
                            },
          
                            style:  GoogleFonts.lexendDeca(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.black),
          
                            // hint style
                            decoration:  InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search brands...",
                              hintStyle:
                                  GoogleFonts.lexendDeca(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.grey),
                            ),
                          )),
          
                          // close button
          
                          Visibility(
                            visible: tabafterfirst ? true : false,
                            child: InkWell(
                                onTap: () {
                                  setState(() {
                                    tabafterfirst = false;
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  padding:
                                      const EdgeInsets.only(top: 16, bottom: 16),
                                  height: 45,
                                  width: 45,
                                  child: SvgPicture.asset(
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
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                            child: Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: found.length,
                                  itemBuilder: ((context, index) {
                                    return InkWell(
                                      onTap: () async {
                                        SharedPreferences sharedPreferences =
                                            await SharedPreferences.getInstance();
                                        controller.addValue(SizValue.brand,
                                            "${found[index]["name"]}+${found[index]["id"]}");
                                        if (sharedPreferences
                                                .getString(SizValue.sizeAsk) ==
                                            "1") {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const OnlyColor()));
                                        } else {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const SizeandColor()));
                                        }
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            right: 20, left: 20),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  found[index]['name'].toString(),
                                                  style:  GoogleFonts.lexendDeca(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.black),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 10),
                                                  child: SvgPicture.asset(
                                                      "assets/images/arrowright2.svg"),
                                                ),
                                              ],
                                            ),
                                            Container(
                                                margin: const EdgeInsets.only(
                                                    top: 10, bottom: 10),
                                                child: const Divider())
                                          ],
                                        ),
                                      ),
                                    );
                                  })),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                //   // accordion ===============================================================================================
          
                // Accordion(
                //     headerBorderColorOpened: Colors.transparent,
                //     // headerBorderWidth: 1,
                //     headerBackgroundColorOpened: Colors.white,
                //     contentBackgroundColor: Colors.white,
                //     headerBackgroundColor: Colors.white,
                //     rightIcon: SvgPicture.asset("assets/images/arrowdown.svg"),
                //     contentBorderColor: Colors.white,
                //     contentBorderWidth: 3,
                   
                  
                //     contentHorizontalPadding: 20,
                //     scaleWhenAnimating: false,
                //     disableScrolling: true,
                    
                //     openAndCloseAnimation: true,
                //     headerPadding:
                //         const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                //     children: [
                //       AccordionSection(
                //         isOpen: true,
                       
                //         header:  Text('Popular Brands', style:  GoogleFonts.dmSerifDisplay(fontSize: 20,fontWeight: FontWeight.w400, color: Colors.black),),
                //         content: Column(
                //           mainAxisAlignment: MainAxisAlignment.start,
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: popularResponse
                //               .map(
                //                 (e) => InkWell(
                //                   onTap: () async {
                //                     SharedPreferences sharedPreferences =
                //                         await SharedPreferences.getInstance();
                //                     controller.addValue(
                //                         SizValue.brand, "${e["name"]}+${e["id"]}");
                //                     if (sharedPreferences
                //                             .getString(SizValue.sizeAsk) ==
                //                         "1") {
                //                       Navigator.push(
                //                           context,
                //                           MaterialPageRoute(
                //                               builder: (context) =>
                //                                   const OnlyColor()));
                //                     } else {
                //                       Navigator.push(
                //                           context,
                //                           MaterialPageRoute(
                //                               builder: (context) =>
                //                                   const SizeandColor()));
                //                     }
                //                   },
                //                   child: Container(
                //                       margin: const EdgeInsets.only(bottom: 15),
                //                       alignment: Alignment.centerLeft,
                //                       child: Text(e["name"].toString(),
                //                           style: GoogleFonts.lexendDeca(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.black))),
                //                 ),
                //               )
                //               .toList(),
                //         ),
                //       ),
                //     ]),

                Container(
                  margin: const EdgeInsets.only(top: 20,left: 20,bottom: 10),
                  child: Text('Popular Brands', style:  GoogleFonts.dmSerifDisplay(fontSize: 20,fontWeight: FontWeight.w400, color: Colors.black),)),


                    Container(
                      margin: const EdgeInsets.only(left: 25,top: 10),
                      height: 400,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                    
                        itemCount: popularResponse.length,
                        
                        itemBuilder: (context,index){
  
                          return InkWell(
                            onTap: () async {
                               SharedPreferences sharedPreferences =
                                        await SharedPreferences.getInstance();
                                    controller.addValue(
                                        SizValue.brand, "${popularResponse[index]["name"]}+${popularResponse[index]["id"]}");
                                    if (sharedPreferences
                                            .getString(SizValue.sizeAsk) ==
                                        "1") {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const OnlyColor()));
                                    } else {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const SizeandColor()));
                                    }
                            },
                            child: Container(
                                        margin: const EdgeInsets.only(bottom: 15),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                        popularResponse[index]["name"].toString(),
                                            style: GoogleFonts.lexendDeca(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.black))),
                          );
                    
                      }),
                    ),
          
                // textformfield of device not there =================================================================================
            


                Container(
                
                  margin: const EdgeInsets.only(left:30),
                  alignment: Alignment.centerLeft,
                  child: Text('Submit a new brand', style:  GoogleFonts.dmSerifDisplay(fontSize: 20,fontWeight: FontWeight.w400, color: Colors.black),)),
                Container(
                  
                  margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
                  padding:
                      const EdgeInsets.only(left: 15, right: 15),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromARGB(255, 218, 218, 218),
                            blurRadius: 3,
                            offset: Offset(0, 0))
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: TextFormField(

                    style: GoogleFonts.lexendDeca(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.black),
                    onChanged: (value) {
                      setState(() {
                        newBrand = value;
                      });
                    },
                    decoration:  InputDecoration(
                        hintStyle:  GoogleFonts.lexendDeca(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.grey),
                        hintText: "Enter and submit new brand for listing...",
                        border: InputBorder.none),
                  ),
                ),
                Visibility(
                  visible: newBrand.isEmpty ? false : true,
                  child: InkWell(
                    onTap: () async {
                      SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();
                      controller.addValue(SizValue.brand, "$newBrand+0");
                      if (sharedPreferences.getString(SizValue.sizeAsk) ==
                          "1") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const OnlyColor()));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SizeandColor()));
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(
                        top: 15,
                        left: 15,
                        right: 15,
                        bottom: 40
                      ),
                 height: 40,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Text(
                        "NEXT",
                        style: GoogleFonts.lexendExa(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                ),
          
              
              ],
            ),
          ),
        ],
      ),
    );
  }

  void filtersearch(String data) {
    List result = [];

    if (data.isEmpty) {
      setState(() {
        result = decordedResponse;
      });
    } else {
      result = decordedResponse
          .where((element) => element["name"]
              .toString()
              .toLowerCase()
              .contains(data.toString().toLowerCase()))
          .toList();
    }

    setState(() {
      found = result;
    });
  }
}
