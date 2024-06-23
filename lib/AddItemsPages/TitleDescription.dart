// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siz/AddItemsPages/EarnEstimate.dart';
import 'package:siz/Controllers/BottomNavController.dart';
import 'package:siz/LoginSignUp/AccuntCreate.dart';
import 'package:siz/Utils/Colors.dart';
import 'package:siz/Utils/ListingController.dart';
import 'package:siz/Utils/Value.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../Pages/Home.dart';

class TitleDescription extends StatefulWidget {
  const TitleDescription({super.key});

  @override
  State<TitleDescription> createState() => _TitleDescriptionState();
}

class _TitleDescriptionState extends State<TitleDescription> {

  // checkbox bool

   bool corporatebool=false;
   bool dateNightbool=false;
   bool brunchbool=false;
   bool modestbool=false;
   bool bumpbool=false;
   bool weedingbool=false;
   bool summerbool=false;
   bool winterbool=false;
   bool companyeventbool=false;


   String title="";
   String description="";
   String additionaldescription="";




   List<dynamic> occasionsList=[];

  //  value of checkboxes string

   String corporateString="";
   String dateNightString="";
   String brunchString="";
   String modestString="";
   String bumpString="";
   String weeingString="";
   String summerString="";
   String winterString="";
   String companyeventString="";



   ListingController controller=Get.put(ListingController());


   

   @override
  void initState() {
    getOccasions();
    super.initState();
  }

  // list

  Map<String, dynamic> occasionResponse = {};
  List<dynamic> decordedResponse = [];


  // get category =====================================================================================

  getOccasions() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  

    dialodShow();
    try {
      final response = await http.post(Uri.parse(SizValue.getGetOccasions), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey).toString(),
      });

      occasionResponse = jsonDecode(response.body);

     

      if (occasionResponse["success"] == true) {
         Navigator.pop(context);

        setState(() {
          decordedResponse = occasionResponse["list"];
        });
      } else if (occasionResponse["success"] == false) {
         Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(occasionResponse["error"],style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
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
            
               
            // first textformfield and heading ==========================================================
            
                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      alignment: Alignment.center,
                      child:  Text(
                        'Now lets give your item a title',
                        style: GoogleFonts.dmSerifDisplay(fontSize: 20,fontWeight: FontWeight.w400, color: Colors.black),
                      )),
                  Container(
                      margin: const EdgeInsets.only(top: 20, left: 15),
                      alignment: Alignment.centerLeft,
                      child:  Text(
                        'Keep it short and simple.',
                        style: GoogleFonts.lexendDeca(
                          fontWeight: FontWeight.w300,
                            fontSize: 12, color: Colors.grey),
                      )),
            
            
            
                      Container(
                        alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 10,right: 10,top: 5),
                      margin: const EdgeInsets.only(left: 10,right: 10,top: 5),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: const Color(0xffD4D4D4),width: 1)
                      ),
                      height: 56,
                      child: TextFormField(
          
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
          
                       onChanged: (value) {
                         setState(() {
                           title=value;
                         });
                       },

                        maxLines: 6,
                        maxLength: 40,

                       style:GoogleFonts.lexendDeca(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w300
                      ) ,
           
                    
                        decoration:  InputDecoration(
                      counterText: "",
                      border: InputBorder.none,
                      hintStyle: GoogleFonts.lexendDeca(

                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w300
                      )
                        ),
                        
                      ),
                      ),
            
            
                      // second  textformfield and heading ==========================================================
            
            
                      Container(
                      margin: const EdgeInsets.only(top: 30, left: 15),
                      alignment: Alignment.center,
                      child:  Text(
                      'Please describe your item',
                                     style: GoogleFonts.dmSerifDisplay(fontSize: 20,fontWeight: FontWeight.w400, color: Colors.black),
                      )),
                  Container(
                      margin: const EdgeInsets.only(top: 20, left: 15),
                      alignment: Alignment.centerLeft,
                      child:  Text(
                      'Please provide the product description available online, if possible.',
                 style: GoogleFonts.lexendDeca(
                          fontWeight: FontWeight.w300,
                            fontSize: 12, color: Colors.grey),
                      )),
            
                       
            
                         Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(left: 10,right: 10,top: 5),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: const Color(0xffD4D4D4),width: 1)
                      ),
                      height: 130,
                      child: TextFormField(
          
                         onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
          
                         onChanged: (value) {
                         setState(() {
                           description=value;
                         });
                       },
          
                        maxLines: 6,
                        maxLength: 300,
                        
                        
                       style:GoogleFonts.lexendDeca(

                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w300
                      ) ,
           
                    
                        decoration:  InputDecoration(
                      border: InputBorder.none,
                      hintStyle: GoogleFonts.lexendDeca(

                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w300
                      )
                        ),
                        
                      ),
                      ),
            
                            // third textformfield and heading ==========================================================
            
            
                      Container(
                      margin: const EdgeInsets.only(top: 30, left: 15,bottom: 10),
                      alignment: Alignment.center,
                      child:  Text(
                      'Please help your renter about\nfitting of this item',
                      textAlign: TextAlign.center,
                        style: GoogleFonts.dmSerifDisplay(fontSize: 20,fontWeight: FontWeight.w400, color: Colors.black),
                      )),


                        Container(
                      margin: const EdgeInsets.only(top: 20, left: 15),
                      alignment: Alignment.centerLeft,
                      child:  Text(
                      'True to size,Comes a bit small, Altered in following ways,Custom made provide your size.',
                 style: GoogleFonts.lexendDeca(
                          fontWeight: FontWeight.w300,
                            fontSize: 12, color: Colors.grey),
                      )),
            
   
            
                         Container(
                            margin: const EdgeInsets.only(left: 10,right: 10,top: 5),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: const Color(0xffD4D4D4),width: 1)
                      ),
                      height: 130,
                      child: TextFormField(
          
                    
                          onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                      
                      
                        maxLines: 6,
          
                         onChanged: (value) {
                         setState(() {
                           additionaldescription=value;
                         });
                       },

                        style:GoogleFonts.lexendDeca(

                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w300
                      ) ,
           
                    
                      
                     
                        decoration:  InputDecoration(
                      border: InputBorder.none,
                      
                       hintStyle:  GoogleFonts.lexendDeca(

                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w300
                      ),
                      hintText: ""
                        ),
                        
                        
                      ),
                      ),
          
          
                      //  where item suitable checkbox==============================================
            
          
            
                      Container(
                      margin: const EdgeInsets.only(top: 30,bottom: 10),
                     
                      child:  Text(
                      'Please select occasions where this\nitem is suitable for',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.dmSerifDisplay(fontSize: 20,fontWeight: FontWeight.w400, color: Colors.black),
                      )),
          
          
          
                       Container(
                          margin: const EdgeInsets.only(left: 15, right: 15,top: 10),
                          child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.all(0),
                              shrinkWrap: true,
                              itemCount:  decordedResponse.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.only(left: 15, right: 15),
                                  child: CheckboxListTile(
                                    
                                    controlAffinity: ListTileControlAffinity.leading,
                                    contentPadding: EdgeInsets.zero,
                                    checkboxShape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    dense: true,
                                    title: Text(
                                      decordedResponse[index]["name"],
                                      style:  GoogleFonts.lexendDeca(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black,
                                      ),
                                    ),
                                    value: decordedResponse[index]["state"],
                                    onChanged: (value) {
                                      setState(() {
                                        decordedResponse[index]["state"] = value;
                       
                                        if ( occasionsList.contains(decordedResponse[index]["id"])) {
                                          setState(() {
          
                                            occasionsList.remove(decordedResponse[index]["id"]);
                                        
                                         
                                        
                                          });
                                        } else {
                                          setState(() {
          
                                            occasionsList.add(decordedResponse[index]["id"]);
                                            print(occasionsList.toString());
                                           
                                           
                                            
                                          });
                                        }
                                      });
                                    },
                                  ),
                                );
                              }),
                        ),
          
          
          
          
            
                      
                      Align(
                        alignment: Alignment.bottomRight,
                        child: InkWell(
                          onTap: () async {
          
                           if(title.isEmpty)
                           {
                            ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("Please enter title",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white)),duration: const Duration(seconds: 1),));
                           }
          
                           else  if(title.isEmpty)
                           {
                            ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("Please provide description",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white)),duration: const Duration(seconds: 1),));
                           }
          
                           
                           else  if(additionaldescription.isEmpty)
                           {
                            ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("Please provide us fitting info",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white)),duration: const Duration(seconds: 1),));
                           }
          
                           else if(occasionsList.isEmpty)
                           {
               ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("Please select occasions",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white)),duration: const Duration(seconds: 1),));
          
                            
                           }
                           else{

                


                                  
                            controller.addValue(SizValue.title, title);
                            controller.addValue(SizValue.description, description);
                            controller.addValue(SizValue.additionalDescription, additionaldescription);
                            controller.addValue(SizValue.occasions,occasionsList.toString());

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                     builder: (context) =>  EarnEstimate(rentalIButton: occasionResponse["rental_fee_info"].toString(),yourEarningIButton: occasionResponse["earning_info"].toString(),)));
                
          
                           }
          
          
          
            
                          },
                          child:Container(
                            height: 40,
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.only(right:15,left: 15,top: 100 ,bottom: 30),
                            
                            decoration: const BoxDecoration(
                                            
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              color: Colors.black
                            ),
                            child: 
                             Text("NEXT",style: GoogleFonts.lexendExa(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w300),),
                          ),
                        ),
                      )
            
            
                  
            
              ],
            ),
          ),
        ],
      ),

      
    );
  }


  


    void showReviewdialog(String title,String value)
  {


                    showGeneralDialog(
              
                context: context,
                barrierLabel: "Barrier",
                barrierDismissible: value=="3"? true: false,
                barrierColor: Colors.black.withOpacity(0.5),
                transitionDuration: const Duration(milliseconds: 300),
                pageBuilder: (_, __, ___) {
                  return WillPopScope(
                    onWillPop: () async{
                      return  value=="3"? true: false;
                    },
                    child: Center(
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: 30,right: 20),
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
                             Container(
                              alignment: Alignment.center,
                              width: 280,
                               child: Text(
                                 title,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis
                               ,textAlign: TextAlign.center,style: GoogleFonts.lexendDeca(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                             
                                color: Colors.black
                                
                                ),),
                             ),
                  
                                InkWell(
                                  onTap: 
                                  
                                    value=="2"?

                                      () async
                                      {

                                    

                                     Navigator.pop(context);
                                       final BottomNavController controller = Get.put(BottomNavController());
                                   controller.updateIndex(0);

                                            SharedPreferences sharedPreferences =
                                    await SharedPreferences.getInstance();
                                sharedPreferences.clear();

                                     Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                         builder: (context) =>   const Home()),
                                    (Route<dynamic> route) => false);

                                      }
                                      
                                      
                                      :

                                        value=="3"?

                                        ()
                                        {

                                          Navigator.pop(context);

                                            Navigator.push(context, MaterialPageRoute(builder: (context)=> AccountCreate()));

                                        }
                                        
                                        :
                                  
                                  
                                  () {
                                    Navigator.pop(context);
                                
                                  },
                                  child: Container(
                                    width: 240,
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(top: 20),
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(5)
                                    ),
                                    child:  Text(
                                      value=="2"?

                                      "LOGOUT":

                                      value=="3"?
                                      "COMPLETE SIGNUP":
                                      
                                      "OK",
                                    textAlign: TextAlign.center,
                                   style: GoogleFonts.lexendExa(
        
        fontSize: 16,color: Colors.white,fontWeight: FontWeight.w300)),
                                  ),
                                ),
                              
                          ],
                        )),
                      ),
                    ),
                  );
                },
              );






  }





}