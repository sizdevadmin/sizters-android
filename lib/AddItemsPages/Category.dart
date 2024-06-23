// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:info_popup/info_popup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siz/AddItemsPages/Subcategory.dart';
import 'package:siz/Utils/Colors.dart';
import 'package:siz/Utils/ListingController.dart';
import 'package:siz/Utils/Value.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  ListingController controller = Get.put(ListingController());

  @override
  void initState() {
    getCategory();
    super.initState();
  }

  // list

  Map<String, dynamic> categoryResponse = {};
  List<dynamic> decordedResponse = [];


  // get category =====================================================================================

  getCategory() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  

    dialodShow();
    try {
      final response = await http.post(Uri.parse(SizValue.getCategory), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey).toString(),
      });

      categoryResponse = jsonDecode(response.body);

      if (categoryResponse["success"] == true) {
         Navigator.pop(context);

        setState(() {
          decordedResponse = categoryResponse["list"];
        });
      } else if (categoryResponse["success"] == false) {
         Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(categoryResponse["error"],style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 1), content: Text(message,style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
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
                const EdgeInsets.only( left: 20, right: 20),
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

          Container(
              margin: const EdgeInsets.only(top: 30, left: 15,bottom: 40),
              alignment: Alignment.center,
              child:  Text(
                'What would you like to list?',
                style: GoogleFonts.dmSerifDisplay(fontSize: 20,fontWeight: FontWeight.w400, color: Colors.black),
              )),

          DynamicHeightGridView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: decordedResponse.length,
            crossAxisCount: 2,
            crossAxisSpacing: 0,
           
           
            builder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  controller.addValue(SizValue.mainCategory,"${decordedResponse[index]["name"]}+${decordedResponse[index]["id"]}");

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  SubCategory(productID: decordedResponse[index]["id"].toString(),)));
                },
                child: Container(
                  padding: const EdgeInsets.only(top: 15, bottom: 15, left: 10,right: 10),
                 
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: Colors.grey, width: 1)),
                  margin: const EdgeInsets.all(5),
                  child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                        Container(
                          transform: Matrix4.translationValues(8, -5, 0),
                          alignment: Alignment.centerRight,
                          margin: const EdgeInsets.only(right: 10),
                          
                            child:  InfoPopupWidget(
                              contentTitle: decordedResponse[index]["description"],
                               
                                contentTheme: InfoPopupContentTheme(
                                infoTextStyle: GoogleFonts.lexendDeca(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300
                                )
                              ),
                              child: const Icon(
                                Icons.info_outline,
                                color: Colors.black,
                                size: 25,
                              ),
                            ),
                          ),
                      Container(
                        transform: Matrix4.translationValues(0, -10, 0),
                        child: CachedNetworkImage(
                          width: 40,
                          height: 40,
                              imageUrl: decordedResponse[index]["icon"].toString(),
                              
                           ),
                      ),
                     
                       Text(
                        decordedResponse[index]["name"].toString(),
                        style:  GoogleFonts.lexendDeca(fontSize: 17, color: Colors.black,fontWeight: FontWeight.w300),
                      )
                    ],
                  ),
                ),
              );
            },
          ),

        
        ],
      ),
    );
  }
}
