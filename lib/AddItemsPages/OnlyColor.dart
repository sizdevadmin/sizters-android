// ignore_for_file: use_build_context_synchronously, prefer_interpolation_to_compose_strings

import 'dart:convert';
 import 'dart:io';

import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siz/AddItemsPages/ImageSelect.dart';
import 'package:siz/Utils/Colors.dart';
import 'package:siz/Utils/ListingController.dart';
import 'package:siz/Utils/Value.dart';

class OnlyColor extends StatefulWidget {
  const OnlyColor({super.key});

  @override
  State<OnlyColor> createState() => _OnlyColorState();
}

class _OnlyColorState extends State<OnlyColor> {

  

  int selectedIndex = -1;

    ListingController controllerList=Get.put(ListingController());


      // list

  Map<String, dynamic> colorResponse = {};
  List<dynamic> decordedResponse = [];
  

  


  
    
  @override
   void initState() {
   getColors();
    super.initState();
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
          decordedResponse = colorResponse["list"];
        
         
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
                const EdgeInsets.only(left: 20, right: 20),
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

          // color list =================================================================================

          
          Container(
              margin: const EdgeInsets.only(top: 15, left: 15,bottom: 15),
              alignment: Alignment.center,
              child: Text(
                'Select color of your item.',
                style: GoogleFonts.dmSerifDisplay(
            fontWeight: FontWeight.w400,
                fontSize: 20, color: Colors.black),
              )),
          Expanded(
            child: DynamicHeightGridView(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: decordedResponse.length,
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
                                          color: Color(int.parse( "0xff"+decordedResponse[index]['outline'])),
                                          spreadRadius: 2)
                                    ],
                                    color: Color(
                                    //  0xff+decordedResponse[index]["color"] as dynamic
          
                                      int.parse( "0xff"+decordedResponse[index]['code'])
                                      
                                      ),
                                    shape: BoxShape.circle),
                              ),
                              Visibility(
                                  // visible: index == 11 ? true : false,
                                  visible: decordedResponse.length-1==index? true : false,
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
                            decordedResponse[index]["name"].toString(),
                            style:GoogleFonts.lexendDeca(
                              color: Colors.black,fontWeight: FontWeight.w300, fontSize: 12),
                          ),

                          const SizedBox(height: 10,)
                        ],
                      ),
                    ),
                  );
                }),
          ),


          InkWell(
              onTap: ()async {


                if(selectedIndex==-1)
                {

                  ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("Please select color",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white)),duration: const Duration(seconds: 1),));

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


               controllerList.addValue(SizValue.color, "${decordedResponse[selectedIndex]["name"]}+${decordedResponse[selectedIndex]["id"]}");

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
                  "NEXT",
                   style: GoogleFonts.lexendExa(
                                      color: Colors.white, fontSize: 16,fontWeight: FontWeight.w300),
                ),
              ),
            ),



        ],
      ),
    );
  }
}