// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siz/AddItemsPages/BrandSelect.dart';
import 'package:siz/Utils/Colors.dart';
import 'package:siz/Utils/ListingController.dart';
import 'package:siz/Utils/Value.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class SubCategory extends StatefulWidget {
  String productID="";
   SubCategory({super.key,required this.productID});

  @override
  State<SubCategory> createState() => _SubCategoryState();
}

class _SubCategoryState extends State<SubCategory> {
  

  ListingController controller=Get.put(ListingController());

  Map<String, dynamic> categoryResponse = {};
  List<dynamic> decordedResponse = [];




    
  @override
  void initState() {
   getSubCategory();
    super.initState();
  }
     



    // get category =====================================================================================

  getSubCategory() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  

    dialodShow();
    try {
      final response = await http.post(Uri.parse(SizValue.getSubCategory), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey).toString(),
        'category_id':widget.productID,
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
            padding: const EdgeInsets.only(
               left: 20, right: 20,),
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
              margin: const EdgeInsets.only(top: 30,bottom: 5),
              alignment: Alignment.center,
              child:   Text(
               widget.productID=="2"?  "What type of bag do you have?": 'What type of clothing do you have?',
                style: GoogleFonts.dmSerifDisplay(fontSize: 20,fontWeight: FontWeight.w400, color: Colors.black),
              )),

            

             Expanded(
               child: DynamicHeightGridView(
                         
                         shrinkWrap: true,
                         itemCount: decordedResponse.length,
                         crossAxisCount: 2,
                         crossAxisSpacing: 0,
                         mainAxisSpacing: 0,
                        
                        
                         builder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.only(top: index==0?35:index==1?35:0),
                  child: InkWell(
                    onTap: () async {
                     
                   
                  controller.addValue(SizValue.subCategory,  "${decordedResponse[index]["name"]}+${decordedResponse[index]["id"]}");
                  controller.addValue(SizValue.sizeAsk,  decordedResponse[index]["size_type"].toString());
                   if(decordedResponse[index]["size_type"].toString()=="1")
                   {
                     
                      controller.addValue(SizValue.size, "");
                      
                    
                   }
                             
                   Navigator.push(context, MaterialPageRoute(builder: (context)=>const BrandSelect()));
                             
                             
                    },
                    child: Container(
                      
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(top: 15, bottom: 15),
                     
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.grey, width: 1)),
                      margin: const EdgeInsets.all(5),
                      child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                             
                           decordedResponse[index]["icon"].toString().isEmpty?
                          const SizedBox(
                            width: 40,
                            height: 40,
                          )
                           :
                          CachedNetworkImage(
                            width: 40,
                            height: 40,
                       imageUrl: decordedResponse[index]["icon"].toString(),
                       
                    ),
                          const SizedBox(height: 10),
                           Text(
                           
                            decordedResponse[index]["name"].toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:GoogleFonts.lexendDeca(fontSize: 16, color: Colors.black,fontWeight: FontWeight.w300),
                          )
                        ],
                      ),
                    ),
                  ),
                );
                         },
                       ),
             ),

             const SizedBox(height: 20,)







        ],
      ),
    );
  }
}
