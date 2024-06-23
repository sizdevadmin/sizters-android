// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

import 'dart:io';

import 'package:siz/Utils/Colors.dart';
import 'package:siz/Utils/Value.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class FilterController extends GetxController {
// for clothes filter ===========================

  List<String> sizeList = [];
  List<String> brandsList = [];
  List<Map<dynamic, dynamic>> colorListMultiple = [];
  List<Map<dynamic, dynamic>> colorListMultipleBags = [];

  String fromDate = "";
  String toDate = "";
  String color = "";
  int colorIndex = -1;
  String sortclothes = "1";
  String sortclothesBags = "1";
  String smlString = "";
  String itString = "";
  String euString = "";
  String categoryString = "";
  String collectionString = "";

  DateTime startdate = DateTime.now().add(const Duration(days: 2));
  DateTime enddate = DateTime.now().add(const Duration(days: 4));
  int maxdate = 2;
  String selectedday = "3 Days";

  bool isLoadingMoreC = false;
  bool oncesCallC = false;
  bool noMoreDataC = false;
  bool isLoadingMoreB = false;
  bool oncesCallB = false;
  bool noMoreDataB = false;
  bool isLoadingMoreS = false;
  bool oncesCallS = false;
  bool noMoreDataS = false;

  // tabbed on ============================
  bool tabbedSize = false;
  bool tabbedColor = false;
  bool tabbedBrands = false;
  bool tabbedOccasions = false;
  bool tabbedCategory = false;
  bool tabbedLender = false;
  bool tabbedCollection = false;

  // tabbed on bag
  bool tabbedBagBrands = false;
  bool tabbedBagLenders = false;
  bool tabbedBagsCollection = false;
  bool tabbedBagsCategory = false;
  bool tabbedOccasionsBags = false;
  bool tabbedColorBags = false;

  // lenderfilter true false

  bool isLoadingMoreFLC = false;
  bool oncesCallFLC = false;
  bool noMoreDataFLC = false;
  bool isLoadingMoreFLB = false;
  bool oncesCallFLB = false;
  bool noMoreDataFLB = false;

  int pagenoC = 1;
  int pagenoB = 1;

  // brandsfilter true false

  bool isLoadingMoreFBC = false;
  bool oncesCallFBC = false;
  bool noMoreDataFBC = false;
  bool isLoadingMoreFBB = false;
  bool oncesCallFBB = false;
  bool noMoreDataFBB = false;

// color list

  List<dynamic> colorList = [];
// color list bags

  List<dynamic> colorListBags = [];

// sort list
  List sortList = [
    {'label': "Most Popular", 'id': "4"},
    {'label': "Top Lenders", 'id': "5"},
    {'label': "Newest First", 'id': "1"},
    {'label': "Price Low To High", 'id': "2"},
    {'label': "Price High To Low", 'id': "3"},
  ];
// sort list
  List sortListBags = [
    {'label': "Most Popular", 'id': "4"},
    {'label': "Top Lenders", 'id': "5"},
    {'label': "Newest First", 'id': "1"},
    {'label': "Price Low To High", 'id': "2"},
    {'label': "Price High To Low", 'id': "3"},
  ];

// small medium large list

  List smlList = [
    {'label': "XS"},
    {'label': "S"},
    {'label': "M"},
    {'label': "L"},
  ];

// IT list

  List itList = [
    {'label': "40"},
    {'label': "42"},
    {'label': "44"},
    {'label': "46"},
  ];

// EU list

  List euList = [
    {'label': "4"},
    {'label': "6"},
    {'label': "8"},
    {'label': "10"},
  ];

// Category list=======================

  List selectedcategoryList = [];

  List categoryList = [];

// Category list bags=======================

  List selectedcategoryListBags = [];

  List categoryListBags = [];

  // brands list ==========================

  List multipleSelected = [];

  List checkListItems = [];

  // collection list =======================================

  List selectedcollectionList = [];

  // collection list
  List collectionList = [];

  List selectedcollectionListBags = [];

  // collection list
  List collectionListBags = [];

// manage and p2p list

  List<dynamic> closetTypeList = [
    {
      'title': "Managed",
      "id": 2,
      "value": false,
    },
    {
      'title': "Peer-to-peer self-fulfilled",
      "id": 1,
      "value": false,
    },
  ];

  List<dynamic> closetTypeListBags = [
    {
      'title': "Managed",
      "id": 2,
      "value": false,
    },
    {
      'title': "Peer-to-peer self-fulfilled",
      "id": 1,
      "value": false,
    },
  ];

  List<dynamic> multipleclosetTypeList = [];
  List<dynamic> multipleclosetTypeListBags = [];

  // lender list ==========================

  List multiSelectedLenders = [];

  List lendersList = [];

  // occasion list ==========================

  List multiSelectedOccasion = [];

  List occasionList = [];

  // occasion list bags ==========================
  List multiSelectedOccasionBags = [];

  List occasionListBags = [];

  // multi size==================

  // brands list ==========================

  // List multipleSelectedSize = [];

  // List checkListItemsSize = [];

  String selectedSizeName = "";
  String selectedSizeID = "";

  String fromDateBags = "";
  String toDateBags = "";

// update controller ======================

  forseUpdate() {
    update();
  }

// for bags filter ===========================

  getBagsData() {}

  int maxdateBags = 7;
  String selecteddayBags = "8 Days";

  getClothesData() {}

  updateDate(String startdate, String endDate) {
    fromDate = startdate;
    toDate = endDate;

    update();
  }

  updateColor(String colorname, int index) {
    color = colorname;
    colorIndex = index;
    update();
  }

  updateSort(String sortname) {
    sortclothes = sortname;

    update();
  }

// small medium large update
  smlUpdate(String smlname) {
    smlString = smlname;

    update();
  }

// IT update
  itUpdate(String itname) {
    itString = itname;

    update();
  }

// EU update
  euUpdate(String euname) {
    euString = euname;

    update();
  }

// EU update
  categoryUpdate(String category) {
    categoryString = category;

    update();
  }

// EU update
  collectionUpate(String collection) {
    collectionString = collection;

    update();
  }
// clear all closets

  clearAll() {
    // category = "";
    color = "";

    noMoreDataC = false;
    pagenoC = 1;

    colorIndex = -1;
    sortclothes = "1";
    smlString = "";
    itString = "";
    euString = "";
    categoryString = "";
    collectionString = "";

    // for (int i = 0; i < checkListItems.length; i++) {
    //   checkListItems[i]["check"] = false;
    // }
    tabbedBrands = false;
    tabbedLender = false;
    tabbedCategory = false;
    tabbedOccasions = false;
    tabbedSize = false;
    tabbedColor = false;
    tabbedCollection = false;

    fromDate = "";
    toDate = "";
    maxdate = 2;

    startdate = DateTime.now().add(const Duration(days: 2));
    enddate = DateTime.now().add(const Duration(days: 4));
    multiSelectedOccasion.clear();
    colorListMultiple.clear();
    multipleSelected.clear();
    multiSelectedLenders.clear();
    selectedcategoryList.clear();
    selectedcollectionList.clear();
    // multipleSelectedSize.clear();
    selectedSizeName = "";
    selectedSizeID = "";
    multipleclosetTypeList.clear();

    for (int i = 0; i < collectionList.length; i++) {
      collectionList[i]["value"] = false;
    }

    for (int i = 0; i < closetTypeList.length; i++) {
      closetTypeList[i]["value"] = false;
    }

    update();
  }

  // for bags filters =====================================================================================================

  List multiBrandBags = [];

  DateTime startdateBags = DateTime.now().add(const Duration(days: 2));
  DateTime enddateBags = DateTime.now().add(const Duration(days: 9));

  List bagBrandsList = [];

  // size list =============================

  // Lender list ==========================

  List multiLenderBags = [];

  List bagLenderList = [];

  updateDateBags(String startdate, String endDate) {
    fromDateBags = startdate;
    toDateBags = endDate;

    update();
  }

  updateSortBags(String sortname) {
    sortclothesBags = sortname;

    update();
  }

  clearAllBags() {
    sortclothesBags = "1";

    noMoreDataB = false;
    pagenoB = 1;
    fromDateBags = "";
    toDateBags = "";
    maxdateBags = 7;
    startdateBags = DateTime.now().add(const Duration(days: 2));
    enddateBags = DateTime.now().add(const Duration(days: 9));

    

    // for (int i = 0; i < bagBrandsList.length; i++) {
    //   bagBrandsList[i]["value"] = false;
    // }

    for (int i = 0; i < closetTypeListBags.length; i++) {
      closetTypeListBags[i]["value"] = false;
    }
    multipleclosetTypeListBags.clear();

    tabbedBagBrands = false;

    multiBrandBags.clear();

     tabbedBagLenders = false;

    multiLenderBags.clear();


      selectedcategoryListBags.clear();
      tabbedBagsCategory=false;

      selectedcollectionListBags.clear();
      tabbedBagsCollection=false;


    tabbedColorBags=false;
    colorListMultipleBags.clear();

    
       multiSelectedOccasionBags.clear();
       tabbedOccasionsBags=false;

    update();
  }

  // get  products list

  Map<String, dynamic> productResponse = {};
  List<dynamic> decordedResponse = [];
  bool showLazyIndicator = false;

  // get  products list

  Map<String, dynamic> productResponsebag = {};
  List<dynamic> decordedResponsebag = [];

  // get  products list

  Map<String, dynamic> productSearchResponse = {};
  List<dynamic> decrodedSearchresponse = [];

  // get products =====================================================================================

  getProducts(BuildContext context, String categoryId, int categorySearch,
      String searchkeyword, int pageno) async {
   
         SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    
    // 0 for clothes filter
    // 1 for bags filter

    if (pageno <= 1) {
      dialodShow(context);
    } else {
      showLazyIndicator = true;
      update();
    }

    try {
      final response = await http.post(Uri.parse(SizValue.getlistedProducts),
          body: categorySearch == 0
              ? {
                  'user_key': sharedPreferences.getString(SizValue.isLogged).toString()=="null" ? "": 
         sharedPreferences.getString(SizValue.isLogged).toString()=="1" ? "": 
         sharedPreferences.getString(SizValue.isLogged).toString()=="2" ? "": 
         sharedPreferences.getString(SizValue.userKey).toString(),
                  'category': categoryId,
                  'sub_category': selectedcategoryList.isEmpty
                      ? ""
                      : jsonEncode(selectedcategoryList),
                  'brand': multipleSelected.isEmpty
                      ? ""
                      : jsonEncode(multipleSelected),
                  'lender': multiSelectedLenders.isEmpty
                      ? ""
                      : jsonEncode(multiSelectedLenders),
                  'size': selectedSizeID,
                  'color': colorListMultiple.isEmpty
                      ? ""
                      : jsonEncode(colorListMultiple),
                  'occasion': multiSelectedOccasion.isEmpty
                      ? ""
                      : jsonEncode(multiSelectedOccasion),
                  'closet_type': multipleclosetTypeList.isEmpty
                      ? ""
                      : jsonEncode(multipleclosetTypeList),

                    'collection':selectedcollectionList.isEmpty
                   ?""
                   :jsonEncode(selectedcollectionList),
                  'available_from': fromDate,
                  'available_to': toDate,
                  "sort": sortclothes,
                  'page': pageno.toString()
                }

                
              : categorySearch == 1
                  ? {
                          'user_key': sharedPreferences.getString(SizValue.isLogged).toString()=="null" ? "": 
         sharedPreferences.getString(SizValue.isLogged).toString()=="1" ? "": 
         sharedPreferences.getString(SizValue.isLogged).toString()=="2" ? "": 
         sharedPreferences.getString(SizValue.userKey).toString(),
                      'category': categoryId,
                       'sub_category': selectedcategoryListBags.isEmpty
                      ? ""
                      : jsonEncode(selectedcategoryListBags),
                      'brand': multiBrandBags.isEmpty
                          ? ""
                          : jsonEncode(multiBrandBags),
                      'lender': multiLenderBags.isEmpty
                          ? ""
                          : jsonEncode(multiLenderBags),
                     
                  'color': colorListMultipleBags.isEmpty
                      ? ""
                      : jsonEncode(colorListMultipleBags),
                  'occasion': multiSelectedOccasionBags.isEmpty
                      ? ""
                      : jsonEncode(multiSelectedOccasionBags),
                  'closet_type': multipleclosetTypeListBags.isEmpty
                      ? ""
                      : jsonEncode(multipleclosetTypeListBags),
                   'collection':selectedcollectionListBags.isEmpty
                   ?""
                   :jsonEncode(selectedcollectionListBags),
                  'available_from': fromDateBags,
                  'available_to': toDateBags,   
                      'sort': sortclothesBags,
                      'page': pageno.toString()
                    }
                  : {
                           'user_key': sharedPreferences.getString(SizValue.isLogged).toString()=="null" ? "": 
         sharedPreferences.getString(SizValue.isLogged).toString()=="1" ? "": 
         sharedPreferences.getString(SizValue.isLogged).toString()=="2" ? "": 
         sharedPreferences.getString(SizValue.userKey).toString(),
                      'category': categoryId,
                      'search': searchkeyword,
                      'page': pageno.toString()
                    });

      if (categoryId == "1") {
        productResponse = jsonDecode(response.body);

  

        if (productResponse["success"] == true) {

             
              if (pageno <= 1) {
            Navigator.pop(context);
          } else {
            showLazyIndicator = false;
            update();
          }


          if (pageno <= 1) {
            decordedResponse = productResponse["list"];
            isLoadingMoreC = false;
            oncesCallC = false;
            update();
          } else {
            decordedResponse.addAll(productResponse["list"]);
            isLoadingMoreC = false;
            oncesCallC = false;

            update();
          }

          if (productResponse["list"].toString() == "[]") {
            noMoreDataC = true;
            isLoadingMoreC = false;
            oncesCallC = false;

            update();
          }

         
        } else if (productResponse["success"] == false) {
          if (pageno <= 1) {
            Navigator.pop(context);
          } else {
            showLazyIndicator = false;
            update();
          }
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(productResponse["error"].toString(),
                  style: GoogleFonts.lexendDeca(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      color: Colors.white))));
        }
      } else if (categoryId == "2") {
        productResponsebag = jsonDecode(response.body);

        if (productResponsebag["success"] == true) {

       
         if (pageno <= 1) {
            Navigator.pop(context);
          } else {
            showLazyIndicator = false;
            update();
          }


          if (pageno <= 1) {
            decordedResponsebag = productResponsebag["list"];
            update();
          } else {
            decordedResponsebag.addAll(productResponsebag["list"]);

            update();
          }

          isLoadingMoreB = false;
          oncesCallB = false;
          if (productResponsebag["list"].toString() == "[]") {
            noMoreDataB = true;
            update();
          }

        
        } else if (productResponsebag["success"] == false) {
          if (pageno <= 1) {
            Navigator.pop(context);
          } else {
            showLazyIndicator = false;
            update();
          }
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(productResponsebag["error"].toString(),
                  style: GoogleFonts.lexendDeca(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      color: Colors.white))));
        }
      } else if (categoryId == "") {
        productSearchResponse = jsonDecode(response.body);

        if (productSearchResponse["success"] == true) {


           if (pageno <= 1) {
            Navigator.pop(context);
          } else {
            showLazyIndicator = false;
            update();
          }


          if (pageno <= 1) {
            decrodedSearchresponse = productSearchResponse["list"];

            isLoadingMoreS = false;
            oncesCallS = false;
            update();
          } else {
            decrodedSearchresponse.addAll(productSearchResponse["list"]);
            isLoadingMoreS = false;
            oncesCallS = false;

            update();
          }

          if (productSearchResponse["list"].toString() == "[]") {
            noMoreDataS = true;
            isLoadingMoreS = false;
            oncesCallS = false;
            update();
          }

        
        } else if (productSearchResponse["success"] == false) {
          if (pageno <= 1) {
            Navigator.pop(context);
          } else {
            showLazyIndicator = false;
            update();
          }
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(productSearchResponse["error"].toString(),
                  style: GoogleFonts.lexendDeca(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      color: Colors.white))));
        }
      }
    } on ClientException {
      if (pageno <= 1) {
        Navigator.pop(context);
      } else {
        showLazyIndicator = false;
        update();
      }
      mysnackbar(
          "Server not responding please try again after sometimev fg", context);
    } on SocketException {
      if (pageno <= 1) {
        Navigator.pop(context);
      } else {
        showLazyIndicator = false;
        update();
      }
      mysnackbar(
          "No Internet connection 😑 please try again after sometime", context);
    } on HttpException {
      if (pageno <= 1) {
        Navigator.pop(context);
      } else {
        showLazyIndicator = false;
        update();
      }
      mysnackbar("Something went wrong please try after sometime", context);
    } on FormatException {
      if (pageno <= 1) {
        Navigator.pop(context);
      } else {
        showLazyIndicator = false;
        update();
      }
      mysnackbar("Something went wrong please try after sometime", context);
    }
  }

  // add wishlist ==============================================================================================

  Map<String, dynamic> wishlistaddReponse = {};

   addWishlist(
      BuildContext context, String productId, int index, String type,String comesFrom) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    dialodShow(context);
    try {
      final response = await http.post(Uri.parse(SizValue.addWishlist), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey),
        'product': productId,
      });

      wishlistaddReponse = jsonDecode(response.body);

        if (wishlistaddReponse["success"] == true) {

          // type one means browse page clothes tab
        if (type == "1") {
          decordedResponse[index]["wishlist"] = 1;
        } 
        
         // type two means browse page bag tab
        else if(type=="2") {
          decordedResponsebag[index]["wishlist"] = 1;
        }
         // type three means search page
        else if (type == "3") {
          decrodedSearchresponse[index]["wishlist"] = 1;
        }

         // type four means product details screen
        else if (type == "4") {
          productDetailsResponse["wishlist"] = 1;

              productDetailsResponse["wishlist_count"]= (int.parse(productDetailsResponse["wishlist_count"])+1).toString();

         

          if(comesFrom=="1")
          {

             decordedResponse[index]["wishlist"] = 1;

          }

          else if(comesFrom=="2")
          {

            decordedResponsebag[index]["wishlist"] = 1;

          }

          else if(comesFrom=="3")
          {

            decrodedSearchresponse[index]["wishlist"] = 1;

          }

          else if(comesFrom=="4")
          {

         lenderListDecorded[index]["wishlist"]=1;

          }
        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Item added in your wishlist",
              style: GoogleFonts.lexendDeca(
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                  color: Colors.white)),
          duration: const Duration(seconds: 1),
        ));
        update();
        Navigator.pop(context);
      } else if (wishlistaddReponse["success"] == false) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(wishlistaddReponse["error"].toString(),
                style: GoogleFonts.lexendDeca(
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                    color: Colors.white))));
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

  // remove wishlist ==============================================================================================

  Map<String, dynamic> wishlistremoveReponse = {};

  removeWishlist(
      BuildContext context, String productId, int index, String type,String comesFrom) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    dialodShow(context);
    try {
      final response =
          await http.post(Uri.parse(SizValue.removeWishlist), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey),
        'product': productId,
      });

      wishlistremoveReponse = jsonDecode(response.body);

      if (wishlistremoveReponse["success"] == true) {

        // type one means browse page clothes tab
        if (type == "1") {
          decordedResponse[index]["wishlist"] = 0;
        } else if (type == "3") {
          // type three means search page
          decrodedSearchresponse[index]["wishlist"] = 0;
        } else if(type == "2") {
            // type two means browse page bag tab
          decordedResponsebag[index]["wishlist"] = 0;
        } 
        // type four means product details screen


        else if (type == "4") {
          productDetailsResponse["wishlist"] = 0;
          productDetailsResponse["wishlist_count"]= (int.parse(productDetailsResponse["wishlist_count"])-1).toString();

          if(comesFrom=="1")
          {

             decordedResponse[index]["wishlist"] = 0;

          }

          else if(comesFrom=="2")
          {

            decordedResponsebag[index]["wishlist"] = 0;

          }

          else if(comesFrom=="3")
          {

            decrodedSearchresponse[index]["wishlist"] = 0;

          }

          else if(comesFrom=="4")
          {

         lenderListDecorded[index]["wishlist"]=0;

          }
        }


    

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Item removed from your wishlist",
              style: GoogleFonts.lexendDeca(
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                  color: Colors.white)),
          duration: const Duration(seconds: 1),
        ));
        update();
        Navigator.pop(context);
      } else if (wishlistremoveReponse["success"] == false) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(wishlistremoveReponse["error"].toString(),
                style: GoogleFonts.lexendDeca(
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                    color: Colors.white))));
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

  // call filter apis ==================================================================================================
  //==================================================================================================

  // get size data ===============================================================================

  Map<String, dynamic> sizeResponse = {};

  getsizeFilter(BuildContext context) async {
   

    dialodShow(context);
    try {
      final response = await http.post(Uri.parse(SizValue.getAllSize), body: {
        'user_key':"",
        'type': "2",
      });

      sizeResponse = jsonDecode(response.body);

      if (sizeResponse["success"] == true) {
        // checkListItemsSize = sizeResponse["list"];

        Navigator.pop(context);
        update();
      } else if (sizeResponse["success"] == false) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(sizeResponse["error"].toString(),
                style: GoogleFonts.lexendDeca(
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                    color: Colors.white))));
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

   // get color data ===============================================================================

  Map<String, dynamic> colorResponse = {};
  Map<String, dynamic> colorResponseBags = {};

  getcolorData(BuildContext context, String category) async {
    

    dialodShow(context);
    try {
      final response = await http.post(Uri.parse(SizValue.getColors), body: {
        'user_key': "",
        'type': "2",
        'category': category
      });

      if (category == "1") {
        colorResponse = jsonDecode(response.body);

        if (colorResponse["success"] == true) {
          colorList = colorResponse["list"];

          Navigator.pop(context);
          update();
        } else if (colorResponse["success"] == false) {
          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(colorResponse["error"].toString(),
                  style: GoogleFonts.lexendDeca(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      color: Colors.white))));
        }
      } else {
        print("i am here second");

        colorResponseBags = jsonDecode(response.body);

        if (colorResponseBags["success"] == true) {
          colorListBags = colorResponseBags["list"];

          Navigator.pop(context);
          update();
        } else if (colorResponseBags["success"] == false) {
          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(colorResponseBags["error"].toString(),
                  style: GoogleFonts.lexendDeca(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      color: Colors.white))));
        }
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

  // get brands data ===============================================================================

  Map<String, dynamic> brandsResponse = {};
  Map<String, dynamic> brandsResponseBags = {};

  getbrandsData(BuildContext context, String catrgoryID, String searchData,
      int pageno) async {
    

    if (pageno <= 1) {
      dialodShow(context);
    } else {
      showLazyIndicator = true;
      update();
    }
    try {
      final response = await http.post(Uri.parse(SizValue.getBrands), body: {
        'user_key': "",
        'type': '2',
        'search': searchData,
        'category': catrgoryID,
        'page': pageno.toString()
      });

      if (catrgoryID == "1") {
        brandsResponse = jsonDecode(response.body);

        if (brandsResponse["success"] == true) {
          if (pageno <= 1) {
            checkListItems = brandsResponse["list"];
            isLoadingMoreFBC = false;
            oncesCallFBC = false;
            update();
          } else {
            checkListItems.addAll(brandsResponse["list"]);
            isLoadingMoreFBC = false;
            oncesCallFBC = false;

            update();
          }

          if (brandsResponse["list"].toString() == "[]") {
            noMoreDataFBC = true;
            isLoadingMoreFBC = false;
            oncesCallFBC = false;

            update();
          }

          if (pageno <= 1) {
            Navigator.pop(context);
          } else {
            showLazyIndicator = false;
            update();
          }
        } else if (brandsResponse["success"] == false) {
          if (pageno <= 1) {
            Navigator.pop(context);
          } else {
            showLazyIndicator = false;
            update();
          }
        }
      } else {
        brandsResponseBags = jsonDecode(response.body);

        if (brandsResponseBags["success"] == true) {
          if (pageno <= 1) {
            bagBrandsList = brandsResponseBags["list"];
            isLoadingMoreFBB = false;
            oncesCallFBB = false;
            update();
          } else {
            bagBrandsList.addAll(brandsResponseBags["list"]);
            isLoadingMoreFBB = false;
            oncesCallFBB = false;

            update();
          }

          if (brandsResponseBags["list"].toString() == "[]") {
            noMoreDataFBB = true;
            isLoadingMoreFBB = false;
            oncesCallFBB = false;

            update();
          }

          if (pageno <= 1) {
            Navigator.pop(context);
          } else {
            showLazyIndicator = false;
            update();
          }
        } else if (brandsResponseBags["success"] == false) {
          if (pageno <= 1) {
            Navigator.pop(context);
          } else {
            showLazyIndicator = false;
            update();
          }
        }
      }
    } on ClientException {
      if (pageno <= 1) {
        Navigator.pop(context);
      } else {
        showLazyIndicator = false;
        update();
      }
      mysnackbar(
          "Server not responding please try again after sometimev fg", context);
    } on SocketException {
      if (pageno <= 1) {
        Navigator.pop(context);
      } else {
        showLazyIndicator = false;
        update();
      }
      mysnackbar(
          "No Internet connection 😑 please try again after sometime", context);
    } on HttpException {
      if (pageno <= 1) {
        Navigator.pop(context);
      } else {
        showLazyIndicator = false;
        update();
      }
      mysnackbar("Something went wrong please try after sometime", context);
    } on FormatException {
      if (pageno <= 1) {
        Navigator.pop(context);
      } else {
        showLazyIndicator = false;
        update();
      }
      mysnackbar("Something went wrong please try after sometime", context);
    }
  }

  // get occassion data ===============================================================================

  Map<String, dynamic> occasionResponse = {};
  Map<String, dynamic> occasionResponseBags = {};

  getoccasionData(BuildContext context, String category) async {
   

    dialodShow(context);
    try {
      final response =
          await http.post(Uri.parse(SizValue.getGetOccasions), body: {
        'user_key': "",
        'type': "2",
        'category': category
      });

      if (category == "1") {
        occasionResponse = jsonDecode(response.body);

        if (occasionResponse["success"] == true) {
          occasionList = occasionResponse["list"];

          Navigator.pop(context);
          update();
        } else if (occasionResponse["success"] == false) {
          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(occasionResponse["error"].toString(),
                  style: GoogleFonts.lexendDeca(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      color: Colors.white))));
        }
      } else {
        occasionResponseBags = jsonDecode(response.body);

        if (occasionResponseBags["success"] == true) {
          occasionListBags = occasionResponseBags["list"];

          Navigator.pop(context);
          update();
        } else if (occasionResponseBags["success"] == false) {
          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(occasionResponseBags["error"].toString(),
                  style: GoogleFonts.lexendDeca(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      color: Colors.white))));
        }
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

  // get collection data ===============================================================================
  Map<String, dynamic> collectionResponse = {};
  Map<String, dynamic> collectionResponseBags = {};

  getcollectionData(BuildContext context, String category) async {
    

    dialodShow(context);
    try {
      final response =
          await http.post(Uri.parse(SizValue.getCollection), body: {
        'user_key': "",
        'type': "2",
        'category': category,
      });

      if (category == "1") {
        collectionResponse = jsonDecode(response.body);

        if (collectionResponse["success"] == true) {
          collectionList = collectionResponse["list"];

          Navigator.pop(context);
          update();
        } else if (collectionResponse["success"] == false) {
          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(collectionResponse["error"].toString(),
                  style: GoogleFonts.lexendDeca(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      color: Colors.white))));
        }
      } else {
        collectionResponseBags = jsonDecode(response.body);

        if (collectionResponseBags["success"] == true) {
          collectionListBags = collectionResponseBags["list"];

          Navigator.pop(context);
          update();
        } else if (collectionResponseBags["success"] == false) {
          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(collectionResponseBags["error"].toString(),
                  style: GoogleFonts.lexendDeca(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      color: Colors.white))));
        }
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

  // get category ===============================================================================

  Map<String, dynamic> categoryResponse = {};
  Map<String, dynamic> categoryResponseBags = {};

  getcategoryFilter(BuildContext context, String categoryID) async {
  

    dialodShow(context);
    try {
      final response =
          await http.post(Uri.parse(SizValue.getSubCategory), body: {
        'user_key': "",
        'category_id': categoryID,
        'type': "2",
      });

      if (categoryID == "1") {
        categoryResponse = jsonDecode(response.body);

        if (categoryResponse["success"] == true) {
          categoryList = categoryResponse["list"];

          Navigator.pop(context);
          update();
        } else if (categoryResponse["success"] == false) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(categoryResponse["error"].toString(),
                  style: GoogleFonts.lexendDeca(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      color: Colors.white))));
        }
      } else {
        categoryResponseBags = jsonDecode(response.body);
        if (categoryResponseBags["success"] == true) {
          categoryListBags = categoryResponseBags["list"];

          Navigator.pop(context);
          update();
        } else if (categoryResponseBags["success"] == false) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(categoryResponseBags["error"].toString(),
                  style: GoogleFonts.lexendDeca(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      color: Colors.white))));
        }
      }
    } on ClientException {
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

  // get getlenders data ===============================================================================

  Map<String, dynamic> lenderResponse = {};
  Map<String, dynamic> lenderResponseBags = {};

  getlenderData(BuildContext context, String categoryID, String searchData,
      int pageno) async {
   
    if (pageno <= 1) {
      dialodShow(context);
    } else {
      showLazyIndicator = true;
      update();
    }
    try {
      final response = await http.post(Uri.parse(SizValue.getLenders), body: {
        'user_key': "",
        'category': categoryID,
        'search': searchData,
        'page': pageno.toString()
      });

      if (categoryID == "1") {
        lenderResponse = jsonDecode(response.body);

        if (lenderResponse["success"] == true) {
          if (pageno <= 1) {
            lendersList = lenderResponse["user_list"];
            isLoadingMoreFLC = false;
            oncesCallFLC = false;
            update();

            print(lendersList.toString());
          } else {
            lendersList.addAll(lenderResponse["user_list"]);
            isLoadingMoreFLC = false;
            oncesCallFLC = false;

            update();
          }

          if (lenderResponse["user_list"].toString() == "[]") {
            noMoreDataFLC = true;
            isLoadingMoreFLC = false;
            oncesCallFLC = false;

            update();
          }

          if (pageno <= 1) {
            Navigator.pop(context);
          } else {
            showLazyIndicator = false;
            update();
          }
        } else if (lenderResponse["success"] == false) {
          if (pageno <= 1) {
            Navigator.pop(context);
          } else {
            showLazyIndicator = false;
            update();
          }
        }
      } else {
        lenderResponseBags = jsonDecode(response.body);

        if (lenderResponseBags["success"] == true) {
          bagLenderList = lenderResponseBags["user_list"];

          Navigator.pop(context);
          update();

          if (pageno <= 1) {
            bagLenderList = lenderResponseBags["user_list"];
            isLoadingMoreFLB = false;
            oncesCallFLB = false;
            update();
          } else {
            bagLenderList.addAll(lenderResponseBags["user_list"]);
            isLoadingMoreFLB = false;
            oncesCallFLB = false;
            update();
          }

          if (lenderResponseBags["user_list"].toString() == "[]") {
            noMoreDataFLB = true;
            isLoadingMoreFLB = false;
            oncesCallFLB = false;

            update();
          }

          if (pageno <= 1) {
            Navigator.pop(context);
          } else {
            showLazyIndicator = false;
            update();
          }
        } else if (lenderResponseBags["success"] == false) {
          if (pageno <= 1) {
            Navigator.pop(context);
          } else {
            showLazyIndicator = false;
            update();
          }
        }
      }
    } on ClientException {
      if (pageno <= 1) {
        Navigator.pop(context);
      } else {
        showLazyIndicator = false;
        update();
      }
      mysnackbar(
          "Server not responding please try again after sometimev fg", context);
    } on SocketException {
      if (pageno <= 1) {
        Navigator.pop(context);
      } else {
        showLazyIndicator = false;
        update();
      }
      mysnackbar(
          "No Internet connection 😑 please try again after sometime", context);
    } on HttpException {
      if (pageno <= 1) {
        Navigator.pop(context);
      } else {
        showLazyIndicator = false;
        update();
      }
      mysnackbar("Something went wrong please try after sometime", context);
    } on FormatException {
      if (pageno <= 1) {
        Navigator.pop(context);
      } else {
        showLazyIndicator = false;
        update();
      }
      mysnackbar("Something went wrong please try after sometime", context);
    }
  }

  // get product details ================================================================================================


  Map<String, dynamic> productDetailsResponse = {};
  List<dynamic> productImages = [];
  List<dynamic> similarProducts = [];
  List<dynamic> moreRentalProduct = [];

 

  String saveamount = "";

  getProductsDetails( BuildContext context, String lenderId, ) async {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //  dialodShow(context);
     try {
      final response =
          await http.post(Uri.parse(SizValue.getProductDetails), body: {
        'user_key':sharedPreferences.getString(SizValue.userKey).toString(),
        'id': lenderId,
      });

      productDetailsResponse = jsonDecode(response.body);

 

      if (productDetailsResponse["success"] == true) {

        print("response dialog=====  $productDetailsResponse");

        if(productDetailsResponse["user_blocked"].toString()=="1")
      {
   
      Future.delayed(const Duration(milliseconds: 1), () {
 
       dialogBlocked(context,productDetailsResponse["lender_id"].toString());
       
      });

    
       

      }



       
          productImages = productDetailsResponse["images"];

          moreRentalProduct = productDetailsResponse["lender_product"];
          similarProducts = productDetailsResponse["similar_product"];
          saveamount = (int.parse(productDetailsResponse["rent_amount"]) -
                  int.parse(productDetailsResponse["retail_price"]))
              .toString();
          saveamount = saveamount.replaceAll("-", "");

          update();

          //  Navigator.pop(context);
      
      } else if (productDetailsResponse["success"] == false) {
        //  Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(productDetailsResponse["error"].toString(),style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
      }
    } on ClientException {
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

 

   dialogBlocked(BuildContext context,lenderId)
{
  return showGeneralDialog(
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
                        height: 180,
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
                                "You blocked this account. You can't see their closets and reviews",textAlign: TextAlign.center,style: GoogleFonts.lexendDeca(fontSize: 14,fontWeight: FontWeight.w300),),


                               const SizedBox(height: 20),
                               
                                Row(
                                  children: [

                                    Flexible(
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.only(left: 20,right:5),
                                          decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Colors.black,
                                        ),
                                          width: MediaQuery.of(context).size.width,
                                          height: 40,
                                      
                                          child: Text("GO BACK",style: GoogleFonts.lexendExa(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300
                                          ),),
                                        ),
                                      ),
                                    ),
                                   Flexible(
                                      child: InkWell(
                                        onTap: () {
                               
                                          unblockUserProfile(context,lenderId);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: Colors.black,
                                          ),
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.only(left: 5,right:20),
                                          
                                          width: MediaQuery.of(context).size.width,
                                          height: 40,
                                      
                                          child: Text("UNBLOCK",style: GoogleFonts.lexendExa(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300
                                          ),),
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                  
                              
                          ],
                        )),
                      ),
                    ),
                  );
                },
              );
}



   // get lenderprofile =====================================================================================

  Map<String, dynamic> lenderReponse = {};
   List<dynamic> lenderListDecorded = [];
  bool isLoadingMoreCP = false;
  bool oncesCallCP = false;
  bool noMoreDataCP = false;
  bool showLazyIndicatorCP = false;
  bool follow = false;

  getlenderProfile(BuildContext context, String lenderId , int pageno) async {

  

    if (pageno <= 1) {
       dialodShow(context);
    } else {
     
        showLazyIndicatorCP = true;
        update();
    }

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      final response =
          await http.post(Uri.parse(SizValue.lenderProfile), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey).toString(),
        'id': lenderId,
        'page': pageno.toString()
      });

      lenderReponse = jsonDecode(response.body);

      print("lender Response === "+lenderReponse.toString());



      if (lenderReponse["success"] == true) {


       
          if (lenderReponse["follow_status"] == "0") {
   
              follow = false;
              update();
          
          } else {
          
              follow = true;
              update();
           
          }
    

        

        if(lenderReponse["user_blocked"].toString()=="1")
      {
   
   Future.delayed(const Duration(milliseconds: 1), () {
 
  dialogBlockedProfile(context, lenderId);
  });


      }


        if (pageno <= 1) {
        
            lenderListDecorded = lenderReponse["list"];

          
            isLoadingMoreCP = false;
            oncesCallCP = false;
            update();
          
        } else {
        
            lenderListDecorded.addAll(lenderReponse["list"]);
            isLoadingMoreCP = false;
            oncesCallCP = false;
            update();
         
        }

        if (lenderReponse["list"].toString() == "[]") {
         
            noMoreDataCP = true;
            isLoadingMoreCP = false;
            oncesCallCP = false;

            update();
         
        }

        if (pageno <= 1) {
           Navigator.pop(context);
        } else {
          
            showLazyIndicatorCP = false;
            update();
         
        }
      } else if (lenderReponse["success"] == false) {
        if (pageno <= 1) {
          Navigator.pop(context);
        } else {
         
            showLazyIndicatorCP = false;
            update();
        
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(lenderReponse["error"].toString(),
                style: GoogleFonts.lexendDeca(
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                    color: Colors.white))));
      }
    } on ClientException {
      if (pageno <= 1) {
         Navigator.pop(context);
      } else {
       
          showLazyIndicatorCP = false;
          update();
       
      }
      mysnackbar(
          "Server not responding please try again after sometimev fg", context);
    } on SocketException {
      if (pageno <= 1) {
        Navigator.pop(context);
      } else {
        
          showLazyIndicatorCP = false;
          update();
       
      }
      mysnackbar(
          "No Internet connection 😑 please try again after sometime", context);
    } on HttpException {
      if (pageno <= 1) {
         Navigator.pop(context);
      } else {
       
          showLazyIndicatorCP = false;
          update();
       
      }
      mysnackbar("Something went wrong please try after sometime", context);
    } on FormatException {
      if (pageno <= 1) {
        Navigator.pop(context);
      } else {
      
          showLazyIndicatorCP = false;
          update();
      
      }
      mysnackbar("Something went wrong please try after sometime", context);
    }

    
  }

  // blocked dialog profile ============================================================================================================



  dialogBlockedProfile(BuildContext context,String lenderID)
{
  return showGeneralDialog(
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
                        height: 180,
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
                                "You blocked this account. You can't see their closets and reviews",textAlign: TextAlign.center,style: GoogleFonts.lexendDeca(fontSize: 14,fontWeight: FontWeight.w300),),


                               const SizedBox(height: 20),
                               
                                Row(
                                  children: [

                                    Flexible(
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context,"true");
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.only(left: 20,right:5),
                                          decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Colors.black,
                                        ),
                                          width: MediaQuery.of(context).size.width,
                                          height: 40,
                                      
                                          child: Text("GO BACK",style: GoogleFonts.lexendExa(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300
                                          ),),
                                        ),
                                      ),
                                    ),
                                   Flexible(
                                      child: InkWell(
                                        onTap: () {
                                          unblockUserProfile(context,lenderID);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: Colors.black,
                                          ),
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.only(left: 5,right:20),
                                          
                                          width: MediaQuery.of(context).size.width,
                                          height: 40,
                                      
                                          child: Text("UNBLOCK",style: GoogleFonts.lexendExa(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300
                                          ),),
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                  
                              
                          ],
                        )),
                      ),
                    ),
                  );
                },
              );
}


// unblock  =====================================================

   Map<String, dynamic> unblockuserprofileReponse = {};

  unblockUserProfile(BuildContext context, String lenderID) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    dialodShow(context);

    try {
      final response =
          await http.post(Uri.parse(SizValue.unblockUser), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey).toString(),
        'id': lenderID
      });

      unblockuserprofileReponse = jsonDecode(response.body);

      

      if (unblockuserprofileReponse["success"] == true) {


        print("userBlocked=== "+unblockuserprofileReponse.toString());

        
    

       Navigator.pop(context);
       Navigator.pop(context);
      
      
       
      } else if (unblockuserprofileReponse["success"] == false) {
         Navigator.pop(context);
       
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 1),
        content: Text(message,
            style: GoogleFonts.lexendDeca(
                fontSize: 13,
                fontWeight: FontWeight.w300,
                color: Colors.white))));
  }

  // simple dialog =============================================================================================

  dialodShow(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        showDialog(
            barrierDismissible: true,
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
}
