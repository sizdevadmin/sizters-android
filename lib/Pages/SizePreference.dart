// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siz/Pages/Cart.dart';
import 'package:siz/Pages/Wishlist.dart';
import 'package:siz/Utils/Colors.dart';

import 'dart:io';

import 'package:siz/Utils/Value.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../Controllers/FilterController.dart';


class SizePreference extends StatefulWidget {
  const SizePreference({super.key});

  @override
  State<SizePreference> createState() => _SizePreferenceState();
}

class _SizePreferenceState extends State<SizePreference> {

    FilterController controller = Get.put(FilterController());

   

     // get all size =====================================================================================

     Map<String, dynamic> getSizereponse= {};
     List<dynamic> sizedecordedList=[];



  getallSize() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    dialodShow(context);
    try {
      final response = await http.post(Uri.parse(SizValue.getallSizes), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey),
      });

     getSizereponse = jsonDecode(response.body);


      if (getSizereponse["success"] == true) {

        Navigator.pop(context);

        setState(() {

            sizedecordedList=getSizereponse["list"];
          
        });
      


    
     
      
        
      

     
      } else if (getSizereponse["success"] == false) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(getSizereponse["error"].toString(),style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white)),duration: const Duration(seconds: 1),));
    
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

  

  // update my size ======================================================================================
    
    

     Map<String, dynamic> checkReponse= {};


    updateSize(int updateindex) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    dialodShow(context);

    print("user_key ==== "+ sharedPreferences.getString(SizValue.userKey).toString());

    try {
      final response = await http.post(Uri.parse(SizValue.sizePreference), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey).toString(),
        'size': sizedecordedList[updateindex]["id"].toString()
  
      });

      

     checkReponse = jsonDecode(response.body);

    
     

      if (checkReponse["success"] == true) {

        Navigator.pop(context);


        

        setState(() {

             sizedecordedList[updateindex]["check"]=checkReponse['check'];
             controller. pagenoC = 1;
             controller.noMoreDataC=false;
             controller.getProducts(context, "1", 0, "", 1);
        });
      


    
     
      
        
      

     
      } else if (checkReponse["success"] == false) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(checkReponse["error"].toString(),style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white)),duration: const Duration(seconds: 1),));
    
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
  void initState() {
    getallSize();
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
      backgroundColor: Colors.white,
      body: Column(
    children: [
      // top four icons ==============================================================================================

    
    Container(
      alignment: Alignment.center,
      height: 60,
           width: MediaQuery.of(context).size.width,
          
           padding: const EdgeInsets.only(right: 15,left: 15),
           
           decoration: const BoxDecoration(
             color: Colors.white,
             boxShadow: [BoxShadow(
               color: Color.fromARGB(255, 212, 212, 212),blurRadius: 2,
               offset: Offset(0, 3)
             )]
           ),
    
           child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               InkWell(
                   onTap: () {
                     Navigator.pop(context);
                   },
                   child: SvgPicture.asset("assets/images/backarrow.svg",width: 20,height: 20,)),
               Container(
                   margin: const EdgeInsets.only(left: 30),
                   child:  Text(
                     "Size Preference".toUpperCase(),
                             style: SizValue.toolbarStyle,
                   )),
               Wrap(
                 alignment: WrapAlignment.center,
                 crossAxisAlignment: WrapCrossAlignment.center,
                 direction: Axis.horizontal,
                 children: [
                   InkWell(
                     
                      onTap: () {
                       Navigator.push(context, MaterialPageRoute(builder: (context)=> Wishlist()));
                     },
                     child: SvgPicture.asset("assets/images/heart.svg",width: 20,height: 20,)),
                   const SizedBox(width: 20),
                   InkWell(
                     onTap: () {
                       Navigator.push(context,MaterialPageRoute(builder: (context)=>const Cart()));
                     },
                     child: SvgPicture.asset("assets/images/bag.svg",width: 20,height: 20,)),
                 ],
               )
             ],
           ),
         ),

         Container(
           margin: const EdgeInsets.only(top: 15),
           padding: const EdgeInsets.only(bottom: 15,left: 10),
           
           width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
             color: Colors.white,
             borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
             boxShadow: [BoxShadow(
               color: Color.fromARGB(255, 212, 212, 212),blurRadius: 2,
               offset: Offset(0, 4)
             )]
           ),

            child:  Text("Choose your size",style:  GoogleFonts.lexendDeca(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 20),),
         ),

      

    Expanded(
      
      child: Container(
         
        margin:  const EdgeInsets.only(top: 40,bottom: 20,left: 20,right: 20),
        child: DynamicHeightGridView(
          shrinkWrap: true,
        
          itemCount: sizedecordedList.length,
           crossAxisCount: 4,
             builder: (context,index){
            
              
            return InkWell(
              onTap: () {
                updateSize(index);
              },
              child: Container(
                margin: const EdgeInsets.only(top:       10),
                alignment: Alignment.center,
             
                width: 76,
                 height: 40,
                decoration:  BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  color:  sizedecordedList[index]["check"]==false?Colors.white: MyColors.themecolor,
                  boxShadow:const [BoxShadow(
                    color: Colors.grey,
                    blurRadius: 2,
            
                    offset: Offset(0, 4 )
                  )]
                 
                ),
                
                child:  Text(sizedecordedList[index]["title"],style: GoogleFonts.lexendExa(
                        
                  fontSize: 16,
                  color:sizedecordedList[index]["check"]==false? Colors.black:Colors.white,
                        
                  fontWeight: FontWeight.w300
                ),),
                
              ),
            );
              
              
             }, 
           
           ),
      ),
    )
     
 
    ],
      ),
    );
  }
}
