// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:info_popup/info_popup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siz/AddItemsPages/Category.dart';
import 'package:siz/AddItemsPages/ManageAddress.dart';
import 'package:siz/Controllers/BottomNavController.dart';
import 'package:siz/LoginSignUp/AccuntCreate.dart';
import 'package:siz/LoginSignUp/BasicLoginInfo.dart';
import 'package:siz/LoginSignUp/LoginPage.dart';
import 'package:siz/Pages/Home.dart';
import 'package:siz/Utils/Colors.dart';
import 'package:siz/Utils/Value.dart';

class ManageKeep extends StatefulWidget {
  const ManageKeep({super.key});

  @override
  State<ManageKeep> createState() => _ManageKeepState();
}

class _ManageKeepState extends State<ManageKeep> {

  String manageData="";
  String listmyownData="";

  @override
  initState()
  {
    getIButtonValues();
    super.initState();
  }



  getIButtonValues() async
  {
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();

    setState(() {

    manageData= sharedPreferences.getString(SizValue.manageIbutton).toString();
    listmyownData= sharedPreferences.getString(SizValue.LMOIButton).toString();
      
    });
   

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


          // body ============================================================================================================

           // manage my closet

           Container(
              margin: const EdgeInsets.only(top: 30, left: 20,right: 20),
              alignment: Alignment.center,
              child:  Text(
                'Would you like us to manage your rentals for you',
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSerifDisplay(fontSize: 20, color: Colors.black,fontWeight: FontWeight.w400),
              )),

              InkWell(
                onTap: () async {

              
                         SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
                     
                             if(sharedPreferences.getString(SizValue.isLogged).toString()=="null")
                             {

                              Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage(otpNumber: "")));

                             }

                             else if(sharedPreferences.getString(SizValue.isLogged).toString()=="1")
                             {

                                Navigator.push(context, MaterialPageRoute(builder: (context)=>BasicLoginInfo(fromWhere: sharedPreferences.getString(SizValue.source).toString())));

                             }
                             else if(sharedPreferences.getString(SizValue.isLogged).toString()=="2")
                             {

                                Navigator.push(context, MaterialPageRoute(builder: (context)=>AccountCreate()));

                            }

                             else if(sharedPreferences.getString(SizValue.underReview).toString()=="0"){

                                  showReviewdialog(sharedPreferences.getString(SizValue.underReviewMsg).toString(),sharedPreferences.getString(SizValue.underReview).toString());

                                }

                                else if(sharedPreferences.getString(SizValue.underReview).toString()=="2"){

                                  showReviewdialog(sharedPreferences.getString(SizValue.rejectedReviewMSG).toString(),sharedPreferences.getString(SizValue.underReview).toString());

    

                                }
                                else if(sharedPreferences.getString(SizValue.underReview).toString()=="3"){

                                  showReviewdialog(sharedPreferences.getString(SizValue.incompleteMessage).toString(),sharedPreferences.getString(SizValue.underReview).toString());

    

                                }

                                else
                                {

                                 Navigator.push(context, MaterialPageRoute(builder: (context)=>const ManageAddress()));


                                }




                

                },
                child: Container(
                  margin: const EdgeInsets.only(left: 15,right: 15,top: 120),
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: MyColors.themecolor,
                    borderRadius: BorderRadius.all(Radius.circular(6))
                  ),
              
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 40),
                          child: Text("MANAGE MY CLOSET",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lexendExa(
                            
                            fontWeight:FontWeight.w300,
                            color: Colors.white,fontSize: 17),),
                        ),
                      ),
                         Container(
                          margin: const EdgeInsets.only(left: 10,right: 10),
                          
                            child:  InfoPopupWidget(
                              contentTitle: manageData,
                                contentTheme: InfoPopupContentTheme(
                                infoTextStyle: GoogleFonts.lexendDeca(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300
                                )
                              ),
                              child: const Icon(
                                Icons.info_outline,
                                color: Colors.white,
                                size: 25,
                              ),
                            ),
                          ),
                    ],
                  ),
                ),
              ),

              // own list

              InkWell(
                onTap: () {
                  

                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const Category()));


                },
                child: Container(
                  margin: const EdgeInsets.only(left: 15,right: 15,top: 40),
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: MyColors.themecolor,
                    borderRadius: BorderRadius.all(Radius.circular(6))
                  ),
              
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 40),
                          child: Text("LIST MY OWN",
                          textAlign: TextAlign.center,
                          
                          style: GoogleFonts.lexendExa(
                            fontWeight:FontWeight.w300,
                            color: Colors.white,fontSize: 17),),
                        ),
                      ),

                      Container(
                          margin: const EdgeInsets.only(left: 10,right: 10),
                          
                            child:  InfoPopupWidget(
                              contentTitle: listmyownData,
                               
                                contentTheme: InfoPopupContentTheme(
                                infoTextStyle: GoogleFonts.lexendDeca(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300
                                )
                              ),
                              child: const Icon(
                                Icons.info_outline,
                                color: Colors.white,
                                size: 25,
                              ),
                            ),
                          ),
                    ],
                  ),

                  
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
                    child: Scaffold(
                      backgroundColor: Colors.transparent,
                        body: Center(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(13)),
                            child: Column( 
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                                                children: [
                             Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
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
                                              ),
                          ),
                        )),
                  );
                },
              );






  }
}