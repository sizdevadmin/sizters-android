// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:convert';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:google_fonts/google_fonts.dart';
import 'package:group_button/group_button.dart';

import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:siz/Controllers/ProfileController.dart';

import 'package:siz/Utils/Colors.dart';
import 'package:siz/Utils/Value.dart';
import 'package:dio/dio.dart';

class ManageItem extends StatefulWidget {
  String productID = "";
  
  ManageItem({super.key, required this.productID});

  @override
  State<ManageItem> createState() => _ManageItemState();
}

class _ManageItemState extends State<ManageItem> {
  bool toggleBool = true;

  DateTime startdate = DateTime.now();
  DateTime enddate = DateTime.now();

  int maxdate = 2;

  GroupButtonController buttonController =
      GroupButtonController(selectedIndex: 0);
  String fixString = "Rent for";
  String selectedday = "3 Days";

  TextEditingController descontroller = TextEditingController();

  ScrollController scrollController = ScrollController();

  String earning3Days = "";
  String earning8Days = "";
  String earning20Days = "";

  String rental3Days = "";
  String rental8Days = "";
  String rental20Days = "";

  bool show3daysWarning = false;
  bool show8daysWarning = false;
  bool show20daysWarning = false;

  bool canEdit = false;

  List<int> mediaIndexList = [];
  List<int> mediaremovedList = [];

  bool showDateBlock = false;

  decordedResponse(String response) {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    return stringToBase64.decode(response);
  }

  Map<String, dynamic> getproductResponse = {};
  List<dynamic> imagesList = [];

  // getProductDetails =====================================================================================

  getProductDetails() async {
    
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    dialodShow();
    try {
      final response =
          await http.post(Uri.parse(SizValue.myProductDetails), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey),
        'id': widget.productID
      });

      getproductResponse = jsonDecode(response.body);




      if (getproductResponse["success"] == true) {
        setState(() {
          descontroller.text =
          decordedResponse(getproductResponse["description"].toString());
          imagesList = getproductResponse["images"];

          if (getproductResponse["block_start_date"].toString().isNotEmpty) {
            startdate = DateTime.parse(
                getproductResponse["block_start_date"].toString());
            enddate =
                DateTime.parse(getproductResponse["block_end_date"].toString());
          } else {
            startdate = DateTime.now();
            enddate = DateTime.now();
          }
        });

        // setState(() {

        //    userList=getHomeReponse["list"];

        // });

        Navigator.pop(context);
      } else if (getproductResponse["success"] == false) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(getproductResponse["error"].toString(),style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
      }
    } on http.ClientException {
      Navigator.pop(context);
      mysnackbar(
          "Server not responding please try again after sometime", context);
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


  // upload data====================================================================================

  uploadData() async {

    dialodShow();
   

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    List<dynamic>? documents = [];
    Map<String, dynamic> decordedResponse = {};


    for (int i = 0; i < imagesList.length; i++) {
      if (imagesList[i].toString().contains("https")) {
        documents.add(imagesList[i].toString());
      } else {
        documents.add(await MultipartFile.fromFile(imagesList[i].toString(),
            filename: imagesList[i].toString().split("/").last));
      }
    }

    final formData = FormData.fromMap({
      'user_key': sharedPreferences.getString(SizValue.userKey),
      'id': widget.productID,
      'description': descontroller.text,
      'media': documents,
      "media_index": jsonEncode(mediaIndexList),
      "media_removed": jsonEncode(mediaremovedList)
    });


    

    final dio = Dio();

    try {
      final response = await dio
          .post(
            SizValue.editProduct,
            data: formData,
            onSendProgress: (count, total) {},
          )
          .timeout(const Duration(hours: 1));

      decordedResponse = jsonDecode(response.data);

      if (decordedResponse["success"] == true) {

         Navigator.pop(context);


        setState(() {

           getproductResponse["edit_request"] ="1";
          
        });

                          

       
       

      
      } else {
        
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(decordedResponse["error"].toString(),style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
      }
    } on DioException catch (e) {
    
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString(),style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white)),
        duration: const Duration(days: 365),
      ));
    }
  }

  // update mycloset status ====================================================================

  Map<String, dynamic> updateclosetResponse = {};

  updatemyClosetsStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      final response =
          await http.post(Uri.parse(SizValue.updateClosetStatus), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey),
        'id': widget.productID,
      });

      updateclosetResponse = jsonDecode(response.body);

      if (updateclosetResponse["success"] == true) {
        setState(() {
          getproductResponse["lender_status"] =
              updateclosetResponse["status"].toString();

          profileController controller = Get.put(profileController());

          controller.getclosets(context,1);
        });
      } else if (updateclosetResponse["success"] == false) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(updateclosetResponse["error"].toString(),style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
      }
    } on http.ClientException {
      mysnackbar(
          "Server not responding please try again after sometimev fg", context);
    } on SocketException {
      mysnackbar(
          "No Internet connection 😑 please try again after sometime", context);
    } on HttpException {
      mysnackbar("Something went wrong please try after sometime", context);
    } on FormatException {
      mysnackbar("Something went wrong please try after sometime", context);
    }
  }

// block dates ===============================================================================================================================================

Map<String, dynamic> blockDatesResponse = {};
  

  blockDates(String editstartDate,String editendDate) async {

     dialodShow();

     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      final response =
          await http.post(Uri.parse(SizValue.daysBlocks),
 body: 
 
      {
        'user_key': sharedPreferences.getString(SizValue.userKey).toString(),
        'id': widget.productID,
        'start_date': editstartDate,
        'end_date': editendDate,

      }
      
      );

      blockDatesResponse = jsonDecode(response.body);

     

      if (blockDatesResponse["success"] == true) {

        print( "block dates ersponse ===="+blockDatesResponse.toString());
       
           Navigator.pop(context);
    

        setState(() {

      
           

           if(editstartDate.isEmpty)
           {
               

                 startdate=DateTime.now();
                 enddate=DateTime.now();
                 getproductResponse["block_start_date"]="";
                 getproductResponse["block_end_date"]="";
              
            

           }

           else
           {


            getproductResponse["block_start_date"]=editstartDate;
            getproductResponse["block_end_date"]=editendDate;


           }
          


        
        });
      } else if (blockDatesResponse["success"] == false) {

          Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(blockDatesResponse["error"].toString(),style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
      }
    } on http.ClientException {
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



  // delete Listing ===============================================================================================================================================

Map<String, dynamic> deleteListingResponse = {};
  

  deleteListingAPI() async {

     dialodShow();

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      final response =
          await http.post(Uri.parse(SizValue.deleteProduct), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey),
        'id': widget.productID,
      

      });

      deleteListingResponse = jsonDecode(response.body);

      if (deleteListingResponse["success"] == true) {

        print(deleteListingResponse.toString());
       

     
        setState(() {

          Navigator.pop(context);

          profileController controller = Get.put(profileController());

            controller. getProducts(context,  "2", 1);
            controller.getclosets(context,1);

          

         
         
          

          Navigator.pop(context);
          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("Listing has been successfully deleted.",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));

        
        });
      } else if (deleteListingResponse["success"] == false) {

          Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(deleteListingResponse["error"].toString(),style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
      }
    } on http.ClientException {
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



  @override
  initState() {
    getProductDetails();
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
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          // top four icons ==============================================================================================

          Container(
            height: 60,
            alignment: Alignment.center,
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
                      "Manage Item".toUpperCase(),
                      style: GoogleFonts.lexendDeca(
                              color: const Color.fromARGB(255, 83, 83, 83),
                              fontSize: 16,
                             letterSpacing: 2.0,
                              
                              fontWeight: FontWeight.w500),
                    )),
                const SizedBox(
                  width: 20,
                  height: 20,
                )
              ],
            ),
          ),

          Expanded(
            child: ListView(
              controller: scrollController,
              padding: EdgeInsets.zero,
              children: [
                // horizontal list

                Container(
                  margin: const EdgeInsets.only(top: 10),
                  height: 190,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          mybottomSheet(0, true);
                        },
                        child: Visibility(
                          visible: imagesList.length > 7 ? false : true,
                          child: Container(
                              margin: const EdgeInsets.only(left: 10),
                              alignment: Alignment.center,
                              width: 100,
                              height: 190,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.black, width: 1),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: Text(
                                "+",
                                style: GoogleFonts.lexendDeca(
                                    fontWeight: FontWeight.w400, fontSize: 60),
                              )),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: imagesList.length,
                            itemBuilder: (context, index) {
                              return Stack(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: index == 0 ? 10 : 0, right: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 134, 134, 134))),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: imagesList[index]
                                                .toString()
                                                .contains("https")
                                            ? CachedNetworkImage(
                                                imageUrl: imagesList[index]
                                                    .toString(),
                                                width: 170,
                                                height: 190,
                                                fit: BoxFit.cover,
                                              )
                                            : Image.file(
                                                File(imagesList[index]
                                                    .toString()),
                                                height: 190,
                                                width: 170,
                                                fit: BoxFit.cover,
                                              )),
                                  ),
                                  Positioned(
                                      top: 0,
                                      left: 0,
                                      child: Visibility(
                                        visible: index > 2 ? false : true,
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              left: 20, top: 10),
                                          padding: const EdgeInsets.only(
                                              left: 10,
                                              right: 10,
                                              top: 2,
                                              bottom: 2),
                                          decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100))),
                                          child: Text(
                                            index == 0
                                                ? "Front"
                                                : index == 1
                                                    ? "Back"
                                                    : index == 2
                                                        ? "Tag"
                                                        : "",
                                            style: GoogleFonts.lexendExa(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 8,
                                                color: Colors.black),
                                          ),
                                        ),
                                      )),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Wrap(
                                      alignment: WrapAlignment.center,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      direction: Axis.horizontal,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            mybottomSheet(index, false);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                right: index == 0
                                                    ? 20
                                                    : index == 1
                                                        ? 20
                                                        : index == 2
                                                            ? 20
                                                            : 5,
                                                top: 10),
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.black,
                                                  width: 1),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.repeat_rounded,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: index == 0
                                              ? false
                                              : index == 1
                                                  ? false
                                                  : index == 2
                                                      ? false
                                                      : true,
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                setState(() {
                                                  canEdit = true;
                                                });

                                                mediaremovedList.add(index);

                                                if (mediaIndexList
                                                    .contains(index)) {
                                                  int foundIndex =
                                                      mediaIndexList.indexWhere(
                                                          (element) =>
                                                              element == index);
                                                  mediaIndexList
                                                      .removeAt(foundIndex);
                                                }

                                                imagesList.removeAt(index);
                                              });

                                              // mybottomSheet(index);
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  right: 20, top: 10),
                                              padding: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Colors.black,
                                                    width: 1),
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.delete,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              );
                            }),
                      ),
                    ],
                  ),
                ),

                // below text

                Container(
                  margin: const EdgeInsets.only(
                      left: 10, top: 15, bottom: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          getproductResponse.isEmpty
                              ? ""
                              : "${getproductResponse["brand_name"]} ${getproductResponse["sub_category"]}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.dmSerifDisplay(
                              fontSize: 20, color: Colors.black),
                        ),
                      ),
                      FlutterSwitch(
                        activeColor: const Color(0xFF76EE59),
                        inactiveColor: const Color.fromARGB(255, 219, 219, 219),
                        height: 20,
                        width: 40,
                        value: getproductResponse["lender_status"].toString() ==
                                "1"
                            ? true
                            : false,
                        borderRadius: 20.0,
                        toggleSize: 15,
                        showOnOff: false,
                        onToggle: (val) {
                          setState(() {
                            updatemyClosetsStatus();
                          });
                        },
                      ),
                    ],
                  ),
                ),

                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromARGB(255, 208, 208, 208))),
                  child: TextFormField(
                    controller: descontroller,
                    maxLines: 6,
                    style: GoogleFonts.lexendDeca(
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                        fontSize: 13),
                    onChanged: (value) {
                      setState(() {
                        canEdit = true;
                      });
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Description",
                        hintStyle: GoogleFonts.lexendDeca(
                            fontWeight: FontWeight.w300,
                            color: Colors.grey,
                            fontSize: 12)),
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "AED ${getproductResponse["price_3d"]} - AED ${getproductResponse["price_20d"]}",
                    style: GoogleFonts.lexendExa(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),

                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xffF5F5F5))),
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                            left: 10, top: 10, bottom: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Options",
                          style: GoogleFonts.lexendDeca(
                              fontWeight: FontWeight.w300,
                              fontSize: 12,
                              color: Colors.black),
                        ),
                      ),

                     

                      Visibility(
                        visible:  getproductResponse["category_id"].toString()=="1"?true:false,
                        child: Row(
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.only(left: 10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Size",
                                style: GoogleFonts.lexendDeca(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12,
                                    color: Colors.black),
                              ),
                            ),
                      
                             // size
                      

                         

                          Container(
                                                                height: 25,
                                                                padding: const EdgeInsets.only(left: 5,right: 5),
                                                                alignment: Alignment.center,
                                                                 margin: const EdgeInsets.only(left: 20,),
                                                                constraints: const BoxConstraints(minWidth: 20),
                                                               
                                                                decoration: BoxDecoration(
                                                                   borderRadius: const BorderRadius.all(Radius.circular(50)),
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .grey,
                                                                        width:
                                                                            1)),
                                                                child: Text(
                                                                  getproductResponse.isEmpty
                                ? ""
                                : getproductResponse["size_name"].toString(),
                                                                 style: GoogleFonts.lexendDeca(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12,
                                    color: Colors.black),
                                                                ),
                                                              )


                          ],
                        ),
                      ),

                       const SizedBox(height: 10),

                     

                      Row(
                        children: [
                          Container(
                            margin:
                                const EdgeInsets.only(left: 10),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Color",
                              style: GoogleFonts.lexendDeca(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12,
                                    color: Colors.black),
                            ),
                          ),


                    
                     
                       


                          Container(
                                                                height: 25,
                                                                padding: const EdgeInsets.only(left: 5,right: 5),
                                                                alignment: Alignment.center,
                                                                 margin: const EdgeInsets.only(left: 20,),
                                                                constraints: const BoxConstraints(minWidth: 20),
                                                               
                                                                decoration: BoxDecoration(
                                                                   borderRadius: const BorderRadius.all(Radius.circular(50)),
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .grey,
                                                                        width:
                                                                            1)),
                                                                child: Text(
                                                           getproductResponse.isEmpty ? "" : getproductResponse["color"].toString(),
                          style: GoogleFonts.lexendDeca(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12,
                                    color: Colors.black),
                                                                ),
                                                              )



                        ],
                      ),


                      InkWell(
                        onTap:
                            getproductResponse["edit_request"].toString() == "1"
                                ? null
                                : canEdit
                                    ? () {
                                        uploadData();
                                      }
                                    : null,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          margin: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 20, top: 20),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: getproductResponse["edit_request"]
                                          .toString() ==
                                      "1"
                                  ? Colors.grey
                                  : canEdit
                                      ? Colors.black
                                      : Colors.grey,
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Visibility(
                                  visible: getproductResponse["edit_request"]
                                              .toString() ==
                                          "1"
                                      ? true
                                      : false,
                                  child: const Icon(
                                    Icons.timelapse,
                                    color: Colors.white,
                                  )),
                              Visibility(
                                  visible: getproductResponse["edit_request"]
                                              .toString() ==
                                          "1"
                                      ? true
                                      : false,
                                  child: const SizedBox(
                                    width: 5,
                                  )),
                              Text(
                                getproductResponse["edit_request"].toString() ==
                                        "1"
                                    ? "IN REVIEW"
                                    : "SUBMIT EDIT",
                                style: GoogleFonts.lexendExa(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // block dates

                      const SizedBox(height: 5),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                              left: 10,
                            ),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Block Dates",
                              style: GoogleFonts.lexendDeca(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12,
                                  color: Colors.black),
                            ),
                          ),
                         
                        ],
                      ),

                      InkWell(
                        onTap: () {
                          showGeneralDialog(
                            context: context,
                            barrierLabel: "Barrier",
                            barrierDismissible: true,
                            barrierColor: Colors.black.withOpacity(0.5),
                            transitionDuration:
                                const Duration(milliseconds: 300),
                            pageBuilder: (_, __, ___) {
                              return StatefulBuilder(
                                  builder: (context, StateSetter mystate) {
                                return WillPopScope(
                                  onWillPop: () async {
                                    return false;
                                  },
                                  child: Center(
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      height: 500,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Scaffold(
                                          backgroundColor: Colors.transparent,
                                          body: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              CalendarDatePicker2(
                                                  config: CalendarDatePicker2Config(
                                                      dayBorderRadius:
                                                          const BorderRadius
                                                              .all(Radius.zero),
                                                      calendarType:
                                                          CalendarDatePicker2Type
                                                              .range,
                                                      selectedRangeHighlightColor:
                                                          MyColors.themecolor,
                                                       


                                                       
                      selectedRangeDayTextStyle:GoogleFonts.lexendExa(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),
               
                      selectedYearTextStyle: GoogleFonts.lexendExa(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),

                      yearTextStyle: GoogleFonts.lexendExa(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w300),

                      todayTextStyle: GoogleFonts.lexendExa(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),

                      controlsTextStyle: GoogleFonts.lexendDeca(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w300),

                      weekdayLabelTextStyle: GoogleFonts.lexendExa(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w300),

                      disabledDayTextStyle: GoogleFonts.lexendExa(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w300),

                      dayTextStyle: GoogleFonts.lexendExa(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w300),
                      
                      selectedDayTextStyle: GoogleFonts.lexendExa(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),






                                                      
                                                      firstDate:
                                                          DateTime.now()),
                                                  value: [startdate, enddate],
                                                  onValueChanged: (dates) {
                                                    if (dates.length == 2) {
                                                      mystate(() {
                                                        setState(() {
                                                          startdate = dates[0]!;
                                                          enddate = dates[1]!;

                                                          if (startdate ==
                                                              enddate) {
                                                            showDateBlock =
                                                                false;
                                                          } else {
                                                            showDateBlock =
                                                                true;
                                                          }
                                                        });
                                                      });
                                                    }
                                                  }),

                                                  const SizedBox(height: 10),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    onTap: (){

                                                      mystate(() {
                                                      setState(() {
                                                        showDateBlock =
                                                            false;

                                                        if (getproductResponse[
                                                                "block_start_date"]
                                                            .toString()
                                                            .isNotEmpty) {
                                                          startdate = DateTime.parse(
                                                              getproductResponse[
                                                                      "block_start_date"]
                                                                  .toString());
                                                          enddate = DateTime.parse(
                                                              getproductResponse[
                                                                      "block_end_date"]
                                                                  .toString());
                                                        } else {
                                                          startdate =
                                                              DateTime
                                                                  .now();
                                                          enddate = DateTime
                                                              .now();
                                                        }
                                                      });
                                                    });

                                                    Navigator.pop(context);

                                                    },
                                                    child: Container(
                                                        padding: const EdgeInsets.only(left: 10,right:10),
                                                                                                  
                                                                                                     alignment: Alignment.center,
                                                                                                    height: 40,
                                                                                                    
                                                                                                    decoration: BoxDecoration(
                                                                                                  color:
                                                                 Colors.black,
                                                              
                                                                                                  borderRadius: BorderRadius.circular(5)
                                                                                                    ),
                                                      child: Text(
                                                        "Back".toUpperCase(),
                                                        style: GoogleFonts.lexendExa(
                                                                                    color: Colors.white,
                                                                                    fontSize: 16,
                                                                                    
                                                                                    fontWeight: FontWeight.w300),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 15,
                                                  ),
                                                  InkWell(
                                                    onTap: showDateBlock
                                                      ? () async {

                                                         Navigator.pop(
                                                              context);
                                                          setState(() {
                                                            mystate(() {
                                                              showDateBlock =
                                                                  false;



                                                                  blockDates("${startdate.year}-${startdate.month < 10 ? "0" : ""}${startdate.month}-${startdate.day < 10 ? "0" : ""}${startdate.day}",  "${enddate.year}-${enddate.month < 10 ? "0" : ""}${enddate.month}-${enddate.day < 10 ? "0" : ""}${enddate.day}");
 
                                                                  

                                                            });
                                                          });

                                                         
                                                        }
                                                      : null,
                                                    child: Container(
                                                        padding: const EdgeInsets.only(left: 10,right:10),
                                                                                                    
                                                                                                       alignment: Alignment.center,
                                                                                                      height: 40,
                                                                                                      
                                                                                                      decoration: BoxDecoration(
                                                                                                    color:showDateBlock
                                                                  ? Colors.black
                                                                  : Colors
                                                                      .grey ,
                                                                                                    borderRadius: BorderRadius.circular(5)
                                                                                                      ),
                                                      child: Text(
                                                        "Block Dates".toUpperCase(),
                                                        style:  GoogleFonts.lexendExa(
                                                                                    color: Colors.white,
                                                                                    fontSize: 16,
                                                                                    
                                                                                    fontWeight: FontWeight.w300),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          )),
                                    ),
                                  ),
                                );
                              });
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          margin: const EdgeInsets.only(
                              left: 10, right: 10, top: 5, bottom: 0),
                          alignment: Alignment.centerLeft,
                          height: 30,
                        
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 197, 197, 197),
                                  width: 1)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                getproductResponse.isEmpty
                                    ? ""
                                    : getproductResponse['block_start_date']
                                            .toString()
                                            .isEmpty
                                        ? ""
                                        : "From: ${startdate.day}/${startdate.month}/${startdate.year}, To: ${enddate.day}/${enddate.month}/${enddate.year}",
                                style:GoogleFonts.lexendDeca(
                                        fontWeight: FontWeight.w300,
                                          fontSize: 12, color: Colors.black),
                              ),
                              Visibility(
                                visible:  getproductResponse['block_start_date'].toString().isEmpty?false:true,
                                child: InkWell(
                                  onTap: () {
                                    confirmClearBlockDate(false);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 30,
                                    width: 30,
                                    child: Text(
                                      "Clear",
                                      style: GoogleFonts.lexendDeca(
                                        fontWeight: FontWeight.w300,
                                          fontSize: 12, color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                       Container(

                        margin: const EdgeInsets.only(),
                          
                            alignment: Alignment.center,
                            child: Text(
                              "Select all the dates you want to personally use your item",
                              style: GoogleFonts.lexendDeca(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12,
                                  color: Colors.grey),
                            ),
                          ),

                     
                        InkWell(
                          onTap: () {


                               confirmClearBlockDate(true);
                          
                          },
                          child: Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                   width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.only(top: 50,bottom:30,left: 10,right: 10),
                                  decoration: const BoxDecoration(
                                      color: Colors.black,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: Text("DELETE THIS LISTING",
                                      style: GoogleFonts.lexendExa(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300))),
                        ),

                    ],
                  ),
                ),


             
              ],
            ),
          )

          // body ===============================================
        ],
      ),
    );
  }

  
confirmClearBlockDate(bool deleteListing) {
  return

    

      showModalBottomSheet(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          context: context,
          builder: (context) {
            return Wrap(children: [
              Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 30),
                  child: Column(
                    children: [
                       Container(
                        margin: const EdgeInsets.only(left: 15,right: 15),
                         child:  Text(
                     deleteListing?"Are you sure you really want to delete this listing?":   "Are you sure you really want to clear block dates" ,

                             textAlign: TextAlign.center,
                          style: GoogleFonts.lexendDeca(
                              color:Colors.black,
                              fontSize: 15,
                             
                              fontWeight: FontWeight.w300),
                                             ),
                       ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {

                               Navigator.pop(context);
                              
                            },
                            child: Container(
                                 padding: const EdgeInsets.only(left: 10,right:10),
                                                  
                                                     alignment: Alignment.center,
                                                    height: 40,
                                                    
                                                    decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius: BorderRadius.circular(5)
                                                    ),
                          
                              child: Text(
                                "No".toUpperCase(),
                                style: GoogleFonts.lexendExa(
                                color: Colors.white,
                                fontSize: 16,
                                
                                fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          InkWell(
                            onTap: deleteListing?
                          ()
                          {

                              deleteListingAPI();

                          }

                          :
                          
                          
                            () async {
                            Navigator.pop(context);
                             blockDates("", "");
                          },
                            child: Container(
                                 padding: const EdgeInsets.only(left: 10,right:10),
                                                    
                                                       alignment: Alignment.center,
                                                      height: 40,
                                                      
                                                      decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius: BorderRadius.circular(5)
                                                      ),
                              child: Text(
                                "Yes".toUpperCase(),
                                style:GoogleFonts.lexendExa(
                                color: Colors.white,
                                fontSize: 16,
                                
                                fontWeight: FontWeight.w300),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  )),
            ]);
          });
}






  mybottomSheet(int imageIndex, bool addnew) {
    return showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (context) {
          return Container(
              padding: const EdgeInsets.only(top: 10, bottom: 30),
              child: Wrap(
                direction: Axis.vertical,
                children: [
                  // text heading
                  Container(
                      margin:
                          const EdgeInsets.only(left: 20, top: 10, bottom: 25),
                      child:  Text(
                        "Select image from",
                        style: GoogleFonts.lexendDeca(
                            color: MyColors.themecolor,
                            fontWeight: FontWeight.w300,
                            fontSize: 16),
                      )),

                  // row
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // ontap of camera
                        InkWell(
                          onTap: () async {
                            final ImagePicker picker = ImagePicker();

                            final XFile? image = await picker.pickImage(
                                imageQuality: 60, source: ImageSource.camera);

                            Navigator.pop(context);

                            setState(() {
                              if (image != null) {
                                if (addnew) {
                                  imagesList.add(image.path);
                                  if (!mediaIndexList
                                      .contains(imagesList.length)) {
                                    mediaIndexList.add(imagesList.length);

                                    setState(() {
                                      canEdit = true;
                                    });
                                  }
                                } else {
                                  imagesList[imageIndex] = image.path;

                                  if (!mediaIndexList.contains(imageIndex)) {
                                    mediaIndexList.add(imageIndex);
                                  }

                                  setState(() {
                                    canEdit = true;
                                  });
                                }
                              }
                            });
                          },
                          child: Wrap(
                            direction: Axis.vertical,
                            children: [
                              SvgPicture.asset(
                                "assets/images/camera.svg",
                                width: 50,
                                height: 50,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                               Text(
                                "Camera",
                                style: GoogleFonts.lexendDeca(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontSize: 16),
                              )
                            ],
                          ),
                        ),

                        // ontab on gallery
                        InkWell(
                          onTap: () async {
                            final ImagePicker picker = ImagePicker();

                            final XFile? image = await picker.pickImage(
                                imageQuality: 60, source: ImageSource.gallery);

                            setState(() {
                              Navigator.pop(context);

                              if (image != null) {
                                if (addnew) {
                                  setState(() {
                                    canEdit = true;
                                  });

                                  imagesList.add(image.path);
                                  if (!mediaIndexList
                                      .contains(imagesList.length)) {
                                    mediaIndexList.add(imagesList.length);
                                  }
                                } else {
                                  setState(() {
                                    canEdit = true;
                                  });

                                  imagesList[imageIndex] = image.path;

                                  if (!mediaIndexList.contains(imageIndex)) {
                                    mediaIndexList.add(imageIndex);
                                  }
                                }
                              }
                            });
                          },
                          child: Wrap(
                            direction: Axis.vertical,
                            children: [
                              SvgPicture.asset(
                                "assets/images/gallery.svg",
                                width: 50,
                                height: 50,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                               Text(
                                "Gallery",
                                style: GoogleFonts.lexendDeca(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontSize: 16),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ));
        });
  }
}
