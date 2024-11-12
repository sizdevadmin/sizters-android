// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_button/group_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siz/Controllers/BottomNavController.dart';
import 'package:siz/LoginSignUp/AccuntCreate.dart';
import 'package:siz/LoginSignUp/BasicLoginInfo.dart';
import 'package:siz/LoginSignUp/LoginPage.dart';
import 'package:siz/Pages/Cart.dart';
import 'package:siz/Pages/Home.dart';
import 'package:siz/Pages/Wishlist.dart';
import 'package:siz/Utils/Colors.dart';
import 'dart:convert';

import 'dart:io';

import 'package:siz/Utils/Value.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';


class DateSelector extends StatefulWidget {
  String id="";
  String category="";
  String type="";
  String replace="";
  String price3days="";
  String price8days="";
  String price20days="";
  String tryonPrices="";
  String availableDate="";
  String tryon="";

DateSelector({super.key,required this.id,required this.type,required this.replace,required this.price3days,required this.price8days,required this.price20days,required this.availableDate,required this.category,required this.tryonPrices,required this.tryon});

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {

  late DateTime startdate;
  late DateTime enddate;
  // DateTime enddate = DateTime.now().add(const Duration(days: 4));


  int maxdate = 0;

  GroupButtonController buttonController =
      GroupButtonController(selectedIndex: 0);

  String fixString = " |";
  String selectedday = "3 DAYS";

  bool tapped = false;

   @override
  void initState()
  {



    if(  widget.category=="2")
    {
      

       setState(() {

       maxdate=7; 
       startdate=DateTime.parse(widget.availableDate);
       selectedday="8 DAYS";
       enddate=startdate.add(const Duration(days: 7));
         
       });
   
      
    }

    else{
  


  setState(() {

    maxdate=2;

       startdate=DateTime.parse(widget.availableDate);
       selectedday="3 DAYS";
       enddate=startdate.add(const Duration(days: 2));
    
  });
      
    }
   
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
            margin: const EdgeInsets.only(bottom: 10),
            decoration: const BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Color.fromARGB(255, 216, 216, 216),
                  blurRadius: 1,
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
                Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: Image.asset(
                      "assets/images/appiconpng.png",
                      width: 40,
                      height: 40,
                    )),
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  direction: Axis.horizontal,
                  children: [
                    InkWell(
                      onTap: ()async {


                       
                       


                       SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
                     
                             if(sharedPreferences.getString(SizValue.isLogged).toString()=="null")
                             {

                              Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage(otpNumber: "")));

                             }


                                   else if(sharedPreferences.getString(SizValue.isLogged).toString()=="1")
                             {

                                Navigator.push(context, MaterialPageRoute(builder: (context)=>BasicLoginInfo(fromWhere: sharedPreferences.getString(SizValue.source).toString(),productId: widget.id,)));

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

                                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>  Wishlist()));


                                }





                        
                      },
                      child: SvgPicture.asset("assets/images/heart.svg",width: 20,height: 20,)),
                    const SizedBox(width: 20),
                    InkWell(
                      onTap: ()async {


                       
                       
                       SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
                     
                             if(sharedPreferences.getString(SizValue.isLogged).toString()=="null")
                             {

                              Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage(otpNumber: "")));

                             }


                                   else if(sharedPreferences.getString(SizValue.isLogged).toString()=="1")
                             {

                                Navigator.push(context, MaterialPageRoute(builder: (context)=>BasicLoginInfo(fromWhere: sharedPreferences.getString(SizValue.source).toString(),productId: widget.id,)));

                             }
                             else if(sharedPreferences.getString(SizValue.isLogged).toString()=="2")
                             {

                                Navigator.push(context, MaterialPageRoute(builder: (context)=>AccountCreate(productId: widget.id,)));

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
                                     Navigator.push(context, MaterialPageRoute(builder: (context)=>const Cart()));

                                }




                      },
                      child: SvgPicture.asset("assets/images/bag.svg",width: 20,height: 20,)),
                  ],
                )
              ],
            ),
          ),

          const SizedBox(height: 10),

          Text(
            "Rent duration",
            style: GoogleFonts.dmSerifDisplay(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w400),
          ),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              margin: const EdgeInsets.only(left: 15, right: 15, top: 35),
              child: GroupButton(
          
          
                
                controller: buttonController,
            
                    onSelected: 
                   // if listed by app =================== 
                    widget.tryon=="0"?
            
            
                       widget.category=="2"?
            
            // if its bag
                       
                    (value, index, isSelected) {
               if (index == 0) {
                    setState(() {
                     
            
                     enddate=startdate.add(const Duration(days: 7));
            
            
                      maxdate = 7;
                      selectedday = value.toString();
                    });
                  } else  {
                    setState(() {
                       
                         enddate=startdate.add(const Duration(days: 19));
            
                      maxdate = 19;
                      selectedday = value.toString();
                    });
                  } 
                }
            
                :
            
            
                   
            
                    (value, index, isSelected) {
                  if (index == 0) {
                    setState(() {
                         enddate=startdate.add(const Duration(days: 2));
                      maxdate = 2;
                      selectedday = value.toString();
                    });
                  } else if (index == 1) {
                      
                    setState(() {
                       enddate=startdate.add(const Duration(days: 7));
                      maxdate = 7;
                      selectedday = value.toString();
                    });
                  } else  {
                    setState(() {
                      enddate=startdate.add(const Duration(days: 19));
                      maxdate = 19;
                      selectedday = value.toString();
                    });
                  } 
                }
            
            
            
                    :
            
                     // else listed by backend  =================== 
            
            
            widget.category=="2"?
            
            // if its bag
                       
                    (value, index, isSelected) {
               if (index == 0) {
                    setState(() {
                       enddate=startdate.add(const Duration(days: 7));
                      maxdate = 7;
                      selectedday = value.toString();
                    });
                  } 
                  
                  
                  
                else {
                         setState(() {
                        enddate=startdate.add(const Duration(days: 19));
                      maxdate = 19;
                      selectedday = value.toString();
                    });
                  }
                }:
                    
                    (value, index, isSelected) {
                  if (index == 0) {
                    setState(() {
                        enddate=startdate.add(const Duration(days: 2));
                      maxdate = 2;
                      selectedday = value.toString();
                    });
                  } else if (index == 1) {
                    
                    setState(() {
                       enddate=startdate.add(const Duration(days: 7));
                      maxdate = 7;
                      selectedday = value.toString();
                    });
                  } else if (index == 2) {
                    setState(() {
                       enddate=startdate.add(const Duration(days: 19));
                      maxdate = 19;
                      selectedday = value.toString();
                    });
                  } else {
                    setState(() {
                      enddate=startdate;
                      maxdate = 0;
                      selectedday = value.toString();
                    });
                  }
                },
            
                options: GroupButtonOptions(
                    selectedTextStyle: GoogleFonts.lexendExa(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w300),
                    unselectedTextStyle: GoogleFonts.lexendExa(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w300),
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    unselectedBorderColor: Colors.black,
                    selectedColor: Colors.black,
                    buttonWidth: 81,
                    buttonHeight: 40,
                    elevation: 1),
            
                isRadio: true,
                // ignore: avoid_print
            
                buttons: widget.tryon.toString()=="0"? 
                
                widget.category=="2"?
            
            
                const [
                 
                  "8 DAYS",
                  "20 DAYS",
                 
                ]:
                
                const [
                  "3 DAYS",
                  "8 DAYS",
                  "20 DAYS",
                 
                ]
              
                :
            
            
                  widget.category=="2"?
            
            
                const [
                 
                  "8 DAYS",
                  "20 DAYS",
                   
                 
                ]:
            
                const [
                  "3 DAYS",
                  "8 DAYS",
                  "20 DAYS",
                   "TRY ON",
                 
                 
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          CalendarDatePicker2(
              config: CalendarDatePicker2Config(
                  dayBorderRadius: const BorderRadius.all(Radius.zero),
                  calendarType: CalendarDatePicker2Type.range,
                  
                  selectedRangeHighlightColor: MyColors.themecolor,


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
                      color: Colors.black,
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




                  firstDate: DateTime.parse(widget.availableDate)),
              value: [startdate, enddate],
              
              onValueChanged: (dates) {
                setState(() {
                  startdate = dates[0]!;
                  enddate = dates[0]!.add(Duration(days: maxdate));
                });
              }),

          Expanded(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // Bottom add to cart option ==============================================================================

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    alignment: Alignment.center,
                    height: 80,
                    padding: const EdgeInsets.only(bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    decoration:  BoxDecoration(
                
                     
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                    border: Border.all(color: const Color.fromARGB(255, 222, 222, 222),width: 1)
              
              ),
                    child: Column(
                      children: [
                      const SizedBox(height: 5),

                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 10, bottom: 3),
                                  alignment: Alignment.centerLeft,
                                  child: Text(

                       "${maxdate==2?"RENT AED ${widget.price3days}": maxdate==7?"RENT AED ${widget.price8days}":maxdate==19?"RENT AED ${widget.price20days}":"RENT AED ${widget.tryonPrices}"}${maxdate==0?"$fixString $selectedday":"$fixString $selectedday"}",

                                 
                                    style:  GoogleFonts.lexendExa(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300,
                                    color:MyColors.themecolor )
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 10),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    
                                     "Shipping and Drycleaning included",
                                    style:GoogleFonts.lexendDeca(
                               
                                    fontSize: 11,
                                    fontWeight: FontWeight.w300,
                                    color:Colors.grey )),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: tapped
                                  ? () {



                                    setState(() {
                                      tapped=false;
                                    });
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Cart()));



                                    
                                    }


                                  : () async{





                       SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
                     
                             if(sharedPreferences.getString(SizValue.isLogged).toString()=="null")
                             {

                              Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage(otpNumber: "")));

                             }


                                   else if(sharedPreferences.getString(SizValue.isLogged).toString()=="1")
                             {

                                Navigator.push(context, MaterialPageRoute(builder: (context)=>BasicLoginInfo(fromWhere: sharedPreferences.getString(SizValue.source).toString(),productId: widget.id,)));

                             }
                             else if(sharedPreferences.getString(SizValue.isLogged).toString()=="2")
                             {

                                Navigator.push(context, MaterialPageRoute(builder: (context)=>AccountCreate(productId: widget.id,)));

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

                                    addtoCart(widget.id, "${startdate.year}-${startdate.month}-${startdate.day}", "${enddate.year}-${enddate.month}-${enddate.day}", "${maxdate+1}",widget.replace);


                                }
                                     

                                 

  

                                  
                                    },
                              child: Container(
                                  margin: const EdgeInsets.only(
                                    right: 10,
                                  ),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(5)),
                                   padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  height: 40,
                                  child: Text(
                                    tapped ? "VIEW CART" : "ADD TO CART",
                                    style: GoogleFonts.lexendExa(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300),
                                  )),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );



    
  }


   

    addtoCart(String id,String startDate,String endDate,String days,String replace) async {



     
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

     dialodShow(context);

   
     Map<String, dynamic> cartResponse = {};


    try {
      final response =
          await http.post(Uri.parse(SizValue.addCart), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey),
        'product': id,
        'start_date': startDate,
        'end_date': endDate,
        'days': days,
        'replace': replace 
      });

      cartResponse = jsonDecode(response.body);

      if (cartResponse["success"] == true) {

          Navigator.pop(context);

      
           setState(() {tapped = true;});

         ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("Added into cart successfully",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white)),duration: Duration(milliseconds: 1500),));
          
      } else if (cartResponse["success"] == false) {
         Navigator.pop(context);

         if(cartResponse["status"]==0)
         {
 
            ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(cartResponse["msg"].toString(),style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));

         }
         else if(cartResponse["status"]==1)
         { 

         print("error response ===  "+ cartResponse.toString());

          cartWarning(cartResponse["msg"].toString());

          

         }

         else
         {

            ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(cartResponse["error"].toString(),style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));

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


   // not found dialog

  void cartWarning(String message) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
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
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                height: 230,
                child: Scaffold(
                  backgroundColor: Colors.white,
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Replace cart item?",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 18),
                      ),
                      const SizedBox(height: 10),

                       Text(
                        message,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lexendDeca(

                          fontSize: 16,color: Colors.grey,

                          fontWeight: FontWeight.w300
                        )
                      ),

                      const SizedBox(height: 20),

                      // yes or no row

                      Row(
                        children: [
                          Flexible(
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 40,
                                margin:
                                    const EdgeInsets.only(left: 10, right: 5),
                                width: MediaQuery.of(context).size.width,
                                decoration: const BoxDecoration(
                                    color: Colors.black,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                child:  Text(
                                  "No".toUpperCase(),
                                  style: GoogleFonts.lexendExa(
                                      fontSize: 16,
                                    color:Colors.white,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                addtoCart(widget.id, "${startdate.year}-${startdate.month}-${startdate.day}", "${enddate.year}-${enddate.month}-${enddate.day}", "${maxdate+1}","1");

                                
                              },
                              child: Container(
                                height: 40,
                                alignment: Alignment.center,
                                margin:
                                    const EdgeInsets.only(left: 5, right: 10),
                                width: MediaQuery.of(context).size.width,
                                decoration: const BoxDecoration(
                                    color: Colors.black,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                child:  Text(
                                  "Yes".toUpperCase(),
                                  style: GoogleFonts.lexendExa(
                                    fontSize: 16,
                                    color:Colors.white,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )),
          ),
        );
      },
    );
  }


}
