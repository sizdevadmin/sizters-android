// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siz/Utils/Colors.dart';

import 'package:siz/Utils/Value.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';


class ExampleGoodImages extends StatefulWidget {
  const ExampleGoodImages({super.key});

  @override
  State<ExampleGoodImages> createState() => _ExampleGoodImagesState();
}

class _ExampleGoodImagesState extends State<ExampleGoodImages> {

  

    Map<String, dynamic> productResponse = {};
      List<dynamic> productImages = [];

    getExampleImages(
   
  ) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

       dialodShow(context);
    try {
      final response =
          await http.post(Uri.parse(SizValue.exampleImages), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey),
        'category_id': sharedPreferences.getString(SizValue.mainCategory).toString().split("+")[1],
      });

      productResponse = jsonDecode(response.body);

      print(productResponse.toString());

      if (productResponse["success"] == true) {
        setState(() {
          productImages = productResponse["list"];


           Navigator.pop(context);
        });
      } else if (productResponse["success"] == false) {
          Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(productResponse["error"].toString(),style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
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
  initState()
  {

    getExampleImages();
    super.initState();
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

          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
          
                     Container(
                
                    margin: const EdgeInsets.only(top: 20, ),
                    alignment: Alignment.center,
                    child:  Text(
                      'Examples of good photos',
                      style: GoogleFonts.dmSerifDisplay(fontSize: 20,fontWeight: FontWeight.w400, color: Colors.black),
                    )),
             Container(
                
                    margin: const EdgeInsets.only(top: 10, ),
                    alignment: Alignment.center,
                    child:  Text(
                      'Top-notch photos feature someone withthe item\ndisplaying it in its most accurate form. Please\ncheckout the below examples',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lexendDeca(fontSize: 14,fontWeight: FontWeight.w300, color: Colors.grey),
                    )),
                
                    Container(
                      margin: const EdgeInsets.only(left: 10,right: 10,top: 20),
                      child: DynamicHeightGridView(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                         crossAxisCount: 2,
                        itemCount: productImages.length,
                         builder: (context, index)
                         {
                                      
                          return CachedNetworkImage(imageUrl: productImages[index]["url"].toString(),
                          width: MediaQuery.of(context).size.width,
                          height: 220,
                          fit: BoxFit.cover,
                          
                          );
                                      
                                      
                                      
                         }),
                    )
          
              ],
            ),
          )
      
      
        ]
      ),
    );
  }
}
