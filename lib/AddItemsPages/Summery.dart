// ignore_for_file: prefer_interpolation_to_compose_strings, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siz/Pages/Home.dart';
import 'package:siz/Pages/MyListing.dart';
import 'package:siz/Utils/Colors.dart';
import 'package:siz/Utils/Value.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';

class Summery extends StatefulWidget {
  const Summery({super.key});

  @override
  State<Summery> createState() => _SummeryState();
}

class _SummeryState extends State<Summery> {
  @override
  void initState() {
    verifyAllValues();
    super.initState();
  }

  String categoryId = "";
  String categoryName = "";

  String subCategoryId = "";
  String subCategoryName = "";

  String brandId = "";
  String brandName = "";

  String sizeId = "";
  String sizeName = "";

  String colorId = "";
  String colorName = "";

  String title = "";

  String description = "";

  String sizeNote = "";

  String occasion = "";

  String addressId = "";
  String addressName = "";

  String retailPrice = "";

  String retailPrice3Days = "";

  String retailPrice8Days = "";

  String retailPrice20Days = "";

  String frontImage = "";
  String backImage = "";
  String tagView = "";
  String additional1 = "";
  String additional2 = "";
  String additional3 = "";
  String additional4 = "";
  String additional5 = "";

  String earning3days = "";
  String earning8days = "";
  String earning20days = "";

  verifyAllValues() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      // get category name and id
      categoryId = sharedPreferences
          .getString(SizValue.mainCategory)
          .toString()
          .split("+")[1];
      categoryName = sharedPreferences
          .getString(SizValue.mainCategory)
          .toString()
          .split("+")[0];
      // sub category name and id
      subCategoryId = sharedPreferences
          .getString(SizValue.subCategory)
          .toString()
          .split("+")[1];
      subCategoryName = sharedPreferences
          .getString(SizValue.subCategory)
          .toString()
          .split("+")[0];
      // sub brand name and id
      brandId =
          sharedPreferences.getString(SizValue.brand).toString().split("+")[1];
      brandName =
          sharedPreferences.getString(SizValue.brand).toString().split("+")[0];
      // sub size name and id

      if (sharedPreferences.getString(SizValue.size).toString().isEmpty) {
        sizeId = sharedPreferences.getString(SizValue.size).toString();
      } else {
        sizeId =
            sharedPreferences.getString(SizValue.size).toString().split("+")[1];
        sizeName =
            sharedPreferences.getString(SizValue.size).toString().split("+")[0];
      }

      // sub color name and id
      colorId =
          sharedPreferences.getString(SizValue.color).toString().split("+")[1];
      colorName =
          sharedPreferences.getString(SizValue.color).toString().split("+")[0];
      // title
      title = sharedPreferences.getString(SizValue.title).toString();
      // description
      description =
          sharedPreferences.getString(SizValue.description).toString();

      // size and fit description
      sizeNote = sharedPreferences
          .getString(SizValue.additionalDescription)
          .toString();
      // occation
      occasion = sharedPreferences.getString(SizValue.occasions).toString();

      // address id and string

      addressId = sharedPreferences.getString(SizValue.address).toString();
      // addressName=sharedPreferences.getString(SizValue.address).toString().split("+")[0];

      // retail price

      retailPrice = sharedPreferences.getString(SizValue.price).toString();

      // retails 3 days

      retailPrice3Days =
          sharedPreferences.getString(SizValue.rental3days).toString();

      // retails 8 days

      retailPrice8Days =
          sharedPreferences.getString(SizValue.rental8days).toString();

      // retails 20 days

      retailPrice20Days =
          sharedPreferences.getString(SizValue.rental20days).toString();

      // earning

      earning3days =
          sharedPreferences.getString(SizValue.earning3days).toString();
      earning8days =
          sharedPreferences.getString(SizValue.earning8days).toString();
      earning20days =
          sharedPreferences.getString(SizValue.earning20days).toString();

      // Images

      frontImage = sharedPreferences.getString(SizValue.frontImage).toString();
      backImage = sharedPreferences.getString(SizValue.backImage).toString();
      tagView = sharedPreferences.getString(SizValue.tagview).toString();

      additional1 =
          sharedPreferences.getString(SizValue.additional1).toString();
      additional2 =
          sharedPreferences.getString(SizValue.additional2).toString();
      additional3 =
          sharedPreferences.getString(SizValue.additional3).toString();
      additional4 =
          sharedPreferences.getString(SizValue.additional4).toString();
      additional5 =
          sharedPreferences.getString(SizValue.additional5).toString();
    });
  }

    int count=0;

  // // upload data

  uploadData() async {


    dialodShow();

   


    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    List<dynamic>? documents = [];
    List<String> list = [];
    List<String> compressImages = [];
    Map<String, dynamic> decordedResponse = {};

    final dio = Dio();

    list.add(frontImage);

    list.add(backImage);

    if (tagView.isNotEmpty) {
      list.add(tagView);
    }

    if (additional1.isNotEmpty) {
      list.add(additional1);
    }

    if (additional2.isNotEmpty) {
      list.add(additional2);
    }
    if (additional3.isNotEmpty) {
      list.add(additional3);
    }

    if (additional4.isNotEmpty) {
      list.add(additional4);
    }

    if (additional5.isNotEmpty) {
      list.add(additional5);
    }



     await Future.forEach(list, (listValue) async {

      
     setState(() {
       ++count;
     });

     
      Uint8List? result = await FlutterImageCompress.compressWithFile(
        listValue.toString(),
        quality: 90,
      );

      final tempDir = await getTemporaryDirectory();
      File compressfile= await File('${tempDir.path}/image$count.png').create();
      compressfile.writeAsBytesSync(result as Uint8List);


      setState(() {
        compressImages.add(compressfile.path);
       
      });

    
      

      
  });

   for (int i = 0; i < compressImages.length; i++) {
      var path = compressImages[i];

      documents.add(
          await MultipartFile.fromFile(path, filename: path.split("/").last));

      setState(() {});
    }

   
   

    final formData = FormData.fromMap({
      'user_key': sharedPreferences.getString(SizValue.userKey),
      'category': categoryId,
      'sub_category': subCategoryId,
      'brand': brandId,
      'custom_brand': brandId == "0" ? brandName : "",
      'size': sizeId,
      'color': colorId,
      'title': title,
      'description': description,
      'size_note': sizeNote,
      'occasion': occasion,
      'address': addressId,
      'retail_price': retailPrice,
      'fees_3_day': retailPrice3Days,
      'fees_8_day': retailPrice8Days,
      'fees_20_day': retailPrice20Days,
      'media': documents,
    });

    

    try {
      final response = await dio.post(
        SizValue.addProduct,
        data: formData,
        onSendProgress: (count, total) {
          print(count.toString() + "  " + total.toString());
        },
      ).timeout(const Duration(hours: 1));

      decordedResponse = jsonDecode(response.data);

      if (decordedResponse["success"] == true) {
        Navigator.pop(context);

        showSuccesDialog();
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Something went wrong",
                style: GoogleFonts.lexendDeca(
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                    color: Colors.white))));
      }
    } on DioException catch (e) {
      Navigator.pop(context);
      

         if (e.error is SocketException) {
        errorDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Something went wrong"),
        ));
      }
       
    }
  }

  dialodShow() {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: const Center(
              child: CircularProgressIndicator(
                color: MyColors.themecolor,
              ),
            ),
          );
        });
  }



          // error dialog  =======================================================================================

  void errorDialog() {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 100),
      pageBuilder: (_, __,___) {
        return Center(
          child: WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                height: 400,
                child: Scaffold(
                  backgroundColor: Colors.white,
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                          alignment: Alignment.center,
                          child: LottieBuilder.asset(
                            "assets/images/erroranimation.json",
                            height: 200,
                          )),
                       Text(
                        "Your network connection appears to be unstable. To ensure smoother upload processes, we recommend switching to a more reliable network or utilizing a Wi-Fi connection for improved stability",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lexendDeca(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontSize: 13),
                      ),
                      const SizedBox(height: 10),
                      const SizedBox(height: 10),

                      InkWell(
                        onTap: () {
                          
                          

                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Home()),
                                (route) => false);
                          
                        },
                        child: Container(
                          height: 40,
                          width: 80,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(5)
                      
                          ),
                      
                          child: Text("OK",style: GoogleFonts.lexendExa(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            color: Colors.white
                          ),),
                        ),
                      ),
                     
                    ],
                  ),
                )),
          ),
        );
      },
    );
  }

  bool lenderTermsCheck=false;

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
                    child: SvgPicture.asset(
                      "assets/images/backarrow.svg",
                      width: 20,
                      height: 20,
                    )),
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
                // Body =================================================================================

                Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 20, bottom: 10),
                    child: Text(
                      "Please review your listing",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.dmSerifDisplay(
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontSize: 20),
                    )),

                frontImage.isEmpty
                    ? Container(
                        margin:
                            const EdgeInsets.only(left: 20, right: 20, top: 15),
                        height: 270,
                        width: MediaQuery.of(context).size.width,
                      )
                    : Container(
                        margin:
                            const EdgeInsets.only(left: 20, right: 20, top: 15),
                        height: 340,
                        width: MediaQuery.of(context).size.width,
                        child: Image.file(
                          File(frontImage),
                          fit: BoxFit.cover,
                        ),
                      ),

                const SizedBox(height: 10),

                // first row

                Container(
                  margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Category",
                        style: GoogleFonts.lexendDeca(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontSize: 16),
                      ),
                      Text(
                        categoryName,
                        style: GoogleFonts.lexendDeca(
                            color: Colors.black,
                            fontWeight: FontWeight.w200,
                            fontSize: 16),
                      )
                    ],
                  ),
                ),

                // sub category

                Container(
                  margin: const EdgeInsets.only(left: 15, right: 15, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Sub Category",
                        style: GoogleFonts.lexendDeca(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontSize: 16),
                      ),
                      Text(
                        subCategoryName,
                        style: GoogleFonts.lexendDeca(
                            color: Colors.black,
                            fontWeight: FontWeight.w200,
                            fontSize: 16),
                      )
                    ],
                  ),
                ),

                // second row

                Container(
                  margin: const EdgeInsets.only(left: 15, right: 15, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Brand",
                        style: GoogleFonts.lexendDeca(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontSize: 16),
                      ),
                      Text(
                        brandName,
                        style: GoogleFonts.lexendDeca(
                            color: Colors.black,
                            fontWeight: FontWeight.w200,
                            fontSize: 16),
                      )
                    ],
                  ),
                ),

                // third row

                Container(
                  margin: const EdgeInsets.only(left: 15, right: 15, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Size",
                        style: GoogleFonts.lexendDeca(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontSize: 16),
                      ),
                      Text(
                        sizeName,
                        style: GoogleFonts.lexendDeca(
                            color: Colors.black,
                            fontWeight: FontWeight.w200,
                            fontSize: 16),
                      )
                    ],
                  ),
                ),

                // fourth row

                Container(
                  margin: const EdgeInsets.only(left: 15, right: 15, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Color",
                        style: GoogleFonts.lexendDeca(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontSize: 16),
                      ),
                      Text(
                        colorName,
                        style: GoogleFonts.lexendDeca(
                            color: Colors.black,
                            fontWeight: FontWeight.w200,
                            fontSize: 16),
                      )
                    ],
                  ),
                ),

                // five row

                Container(
                  margin: const EdgeInsets.only(left: 15, right: 15, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Item Name",
                        style: GoogleFonts.lexendDeca(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontSize: 16),
                      ),
                      Text(
                        colorName + " " + subCategoryName,
                        style: GoogleFonts.lexendDeca(
                            color: Colors.black,
                            fontWeight: FontWeight.w200,
                            fontSize: 16),
                      )
                    ],
                  ),
                ),

                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left: 15, right: 15, top: 20),
                  child: Text(
                    "Description",
                    style: GoogleFonts.lexendDeca(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        fontSize: 16),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(left: 15, right: 15, top: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey, width: 1)),
                  child: Text(
                    description,
                    style: GoogleFonts.lexendDeca(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        fontSize: 16),
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(left: 15, right: 15, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Retail Price",
                        style: GoogleFonts.lexendDeca(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontSize: 16),
                      ),
                      Text(
                        "AED " + retailPrice,
                        style: GoogleFonts.lexendDeca(
                            color: Colors.black,
                            fontWeight: FontWeight.w200,
                            fontSize: 16),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Minimum Rental Fee",
                        style: GoogleFonts.lexendDeca(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontSize: 16),
                      ),
                      Text(
                        "AED " + retailPrice3Days,
                        style: GoogleFonts.lexendDeca(
                            color: Colors.black,
                            fontWeight: FontWeight.w200,
                            fontSize: 16),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Minimum Earnings",
                        style: GoogleFonts.lexendDeca(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontSize: 16),
                      ),
                      Text(
                        "AED " + earning3days,
                        style: GoogleFonts.lexendDeca(
                            color: Colors.black,
                            fontWeight: FontWeight.w200,
                            fontSize: 16),
                      )
                    ],
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(top: 20,right: 10),
                  
                  child: Row(
                    children: [
                
                      Checkbox(value: lenderTermsCheck,

                        shape:  RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(3)),

                      
                       onChanged: (value){


                
                        setState(() {
                          lenderTermsCheck=value!;
                        });
                
                      }),
                
                      Expanded(child:
                       RichText(text: TextSpan(
                        children: [
                
                            TextSpan(
                  text: "Please check the box to confirm that you've read and agree to the ",
                               style: GoogleFonts.lexendDeca(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              fontSize: 12),
                   recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    
                  }),
                            TextSpan(
                  text: "lender's terms and conditions.",
                               style: GoogleFonts.lexendDeca(
                              color: Colors.blue,
                              fontWeight: FontWeight.w300,
                              fontSize: 12),
                   recognizer: TapGestureRecognizer()
                  ..onTap = () {
                
                  launchUrl(Uri.parse("https://siz.ae/pages/terms-conditions-lender"));
                    
                  }),
                        ]
                       ))
                      
                      )
                
                    ],
                  ),
                ),

                 InkWell(
                  onTap: 
                  lenderTermsCheck?
                  
                   () {
                     uploadData();
                  
                  }:null,
                  child: Container(
                    margin: const EdgeInsets.only(
                        left: 10, right: 10, bottom: 40, top: 20),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: lenderTermsCheck? Colors.black:Colors.grey,
                        borderRadius: BorderRadius.circular(5)),
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    child: Text(
                      "Upload".toUpperCase(),
                      style: GoogleFonts.lexendExa(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w300),
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

  showSuccesDialog() {
    return showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Center(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 20, right: 20),
              height: 200,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                          "Thank you for submitting your item.\nIt will now be sent or approval.\n\nYou will be notified about its status.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lexendDeca(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: Colors.black)),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyListing(
                                        fromListing: true,
                                        initialIndex: 1,
                                      )));
                        },
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: 150,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(top: 15),
                            height: 40,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              "MY LISTINGS",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lexendExa(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
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
