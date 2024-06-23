// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siz/LoginSignUp/LoginPage.dart';
import 'package:siz/Pages/Cart.dart';
import 'package:siz/Pages/ProductView.dart';

import 'package:siz/Pages/Wishlist.dart';
import 'package:siz/Utils/Colors.dart';
import 'dart:convert';

import 'dart:io';

import 'package:siz/Utils/Value.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class MyProfile extends StatefulWidget {

  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> with TickerProviderStateMixin {

  
  Map<String, dynamic> lenderReponse = {};
  List<dynamic> lenderListDecorded = [];

   




   bool isLoadingMoreC = false;
  bool oncesCallC= false;
  bool noMoreDataC = false;
  bool showLazyIndicatorC = false;

   bool isLoadingMoreR = false;
  bool oncesCallR= false;
  bool noMoreDataR = false;
  bool showLazyIndicatorR = false;

    late TabController tabController;



 
   


   
  getlenderProfile(int pageno) async {


       if (pageno <= 1) {
      dialodShow(context);
    } else {

      setState(() {

         showLazyIndicatorC = true;
        
      });
     
     
    }

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      final response = await http.post(Uri.parse(SizValue.lenderProfile), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey),
        'id': sharedPreferences.getString(SizValue.channelId),
        'page':pageno.toString()
       
      });

   
     lenderReponse = jsonDecode(response.body);

      if (lenderReponse["success"] == true) {
       


        setState(() {

         
        

        
           if(  lenderReponse["follow_status"]=="0")
           {
            setState(() {
              follow=false;
            });
           }

           else
           {

             setState(() {
              follow=true;
            });

           }

         
          
          
        });
        

          if (pageno <= 1) {


          setState(() {

             lenderListDecorded=lenderReponse["list"];
            isLoadingMoreC = false;
            oncesCallC = false;
            
          });
           
           
          } else {

            setState(() {

             lenderListDecorded.addAll(lenderReponse["list"]);
            isLoadingMoreC = false;
            oncesCallC = false;
              
            });
          

            
          }

          if (lenderReponse["list"].toString() == "[]") {

            setState(() {

            noMoreDataC = true;
            isLoadingMoreC = false;
            oncesCallC = false;
              
            });
          

          
          }

          if (pageno <= 1) {
            Navigator.pop(context);
          } else {

            setState(() {

              showLazyIndicatorC = false;
              
            });
            
           
          }
       
      
      

     
      } else if (lenderReponse["success"] == false) {
        if (pageno <= 1) {
            Navigator.pop(context);
          } else {

            setState(() {

              showLazyIndicatorC = false;
              
            });
            
           
          }
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(lenderReponse["error"].toString(),style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
    
      }

      


   
    } on ClientException {
       if (pageno <= 1) {
            Navigator.pop(context);
          } else {

            setState(() {

              showLazyIndicatorC = false;
              
            });
            
           
          }
      mysnackbar(
          "Server not responding please try again after sometimev fg", context);
    } on SocketException {
        if (pageno <= 1) {
            Navigator.pop(context);
          } else {

            setState(() {

              showLazyIndicatorC = false;
              
            });
            
           
          }
      mysnackbar(
          "No Internet connection 😑 please try again after sometime", context);
    } on HttpException {
       if (pageno <= 1) {
            Navigator.pop(context);
          } else {

            setState(() {

              showLazyIndicatorC = false;
              
            });
            
           
          }
      mysnackbar("Something went wrong please try after sometime", context);
    } on FormatException {
        if (pageno <= 1) {
            Navigator.pop(context);
          } else {

            setState(() {

              showLazyIndicatorC = false;
              
            });
            
           
          }
      mysnackbar("Something went wrong please try after sometime", context);
    }
  }

 
   




 


  



  // lenderReview =====================================================================================



   Map<String, dynamic> lenderReviewResponse = {};
   List<dynamic> lenderdecordedListReview=[];
 


   bool tabbedReviews=false;


   getlenderReview(int pageno) async {

      if (pageno <= 1) {
      dialodShow(context);
    } else {

      setState(() {

         showLazyIndicatorR = true;
        
      });
     
     
    }


    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();


   

    try {
      final response = await http.post(Uri.parse(SizValue.lenderReview), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey),
        'id': sharedPreferences.getString(SizValue.channelId).toString(),
        'page':pageno.toString()
       
      });

   
     lenderReviewResponse = jsonDecode(response.body);

      

      if (lenderReviewResponse["success"] == true) {
       

       

        setState(() {

  




              if (pageno <= 1) {


          setState(() {

             lenderdecordedListReview=lenderReviewResponse["list"];
            isLoadingMoreR = false;
            oncesCallR = false;
            
          });
           
           
          } else {

            setState(() {

             lenderdecordedListReview.addAll(lenderReviewResponse["list"]);
            isLoadingMoreR = false;
            oncesCallR = false;
              
            });
          

            
          }

          if (lenderReviewResponse["list"].toString() == "[]") {

            setState(() {

            noMoreDataR = true;
            isLoadingMoreR = false;
            oncesCallR = false;
              
            });
          

          
          }

          if (pageno <= 1) {
            Navigator.pop(context);
          } else {

            setState(() {

              showLazyIndicatorR = false;
              
            });
            
           
          }




          
         
        });


     
      } else if (lenderReviewResponse["success"] == false) {

              if (pageno <= 1) {
            Navigator.pop(context);
          } else {

            setState(() {

              showLazyIndicatorR = false;
              
            });
            
           
          }

     
         ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(lenderReviewResponse["error"].toString(),style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
    
      }

      


   
    } on ClientException {
            if (pageno <= 1) {
            Navigator.pop(context);
          } else {

            setState(() {

              showLazyIndicatorR = false;
              
            });
            
           
          }

      mysnackbar(
          "Server not responding please try again after sometimev fg", context);
    } on SocketException {
         if (pageno <= 1) {
            Navigator.pop(context);
          } else {

            setState(() {

              showLazyIndicatorR = false;
              
            });
            
           
          }

      mysnackbar(
          "No Internet connection 😑 please try again after sometime", context);
    } on HttpException {
           if (pageno <= 1) {
            Navigator.pop(context);
          } else {

            setState(() {

              showLazyIndicatorR = false;
              
            });
            
           
          }

      mysnackbar("Something went wrong please try after sometime", context);
    } on FormatException {
            if (pageno <= 1) {
            Navigator.pop(context);
          } else {

            setState(() {

              showLazyIndicatorR = false;
              
            });
            
           
          }

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






  ScrollController scrollController = ScrollController();

 

  bool follow = false;

  @override
  void initState() {

     tabController = TabController(length: 2, vsync: this, initialIndex: 0);

    
        getlenderProfile(pagenoC);


          _scrollControllerC.addListener(()async  {
    
     
      scrollListenerC();
    });
 

  
     _scrollControllerR.addListener(()async  {
    
     
      scrollListenerR();
    });

    super.initState();
  }



// lender closets 
  final ScrollController _scrollControllerC=ScrollController();
    int pagenoC=1;

    Future<void> scrollListenerC() async {
   
    if (isLoadingMoreC) return;

    _scrollControllerC.addListener(() {

    
      if (_scrollControllerC.offset >=_scrollControllerC.position.maxScrollExtent) {


        setState(() {
           isLoadingMoreC = true;
          
        });
           
          
          if (!oncesCallC) {

              getlenderProfile(++pagenoC);

             setState(() {

               oncesCallC = true;
               
             });
            
             

          
          
          }
      }
    });
  }


// review  
  final ScrollController _scrollControllerR=ScrollController();
    int pagenoR=1;

    Future<void> scrollListenerR() async {
   
    if (isLoadingMoreR) return;

    _scrollControllerR.addListener(() {

    
      if (_scrollControllerR.offset >=_scrollControllerR.position.maxScrollExtent) {


        setState(() {
           isLoadingMoreR = true;
          
        });
           
          
          if (!oncesCallR) {

             getlenderReview(++pagenoR);

              setState(() {

               oncesCallR = true;
               
             });
            
             

          
          
          }
      }
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
      backgroundColor: Colors.white,
      body: Column(
    children: [
      // top four icons ==============================================================================================

      Container(
        height: 60,
        alignment: Alignment.center,
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
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> Wishlist()));
                  },
                  child: SvgPicture.asset("assets/images/heart.svg",width: 20,height: 20,)),
                const SizedBox(width: 20),
                InkWell(
                  onTap: (){

                     Navigator.push(context, MaterialPageRoute(builder: (context)=>const Cart()));
                  },
                  
                  child: SvgPicture.asset("assets/images/bag.svg",width: 20,height: 20,)),
              ],
            )
          ],
        ),
      ),

      // profile info ========================================================================================

      Container(
        height: 110,
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Color.fromARGB(255, 230, 230, 230),
              blurRadius: 1,
              offset: Offset(0, 2))
        ]),
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // one colum
            Container(
              margin: const EdgeInsets.only(left: 10),
              width: 75,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 5),
                lenderReponse.isEmpty? const SizedBox(width: 75,height: 75,): Container(
                              width: 75,
                              height: 75,
                            
                              decoration: const BoxDecoration(
                                 
                                  shape: BoxShape.circle),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(1000),
                                child: CachedNetworkImage(
                                  imageUrl:lenderReponse["profile_img"].toString(),
                                  fit: BoxFit.cover,
                                  height: 75,
                                  width: 75,
                                ),
                              ),
                            ),
            
                              const SizedBox(height: 5),
            
              
            
                
            
            
                ],
              ),
            ),

            // second column
             Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 20, right: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // first row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(

                  
                     lenderReponse.isEmpty?"": "${lenderReponse["username"]}",
                     overflow: TextOverflow.ellipsis,
                      style:  GoogleFonts.dmSerifDisplay(fontSize: 16, color: Colors.black,fontWeight: FontWeight.w300),
                    ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: RatingBarIndicator(
                            rating: lenderReponse.isEmpty? 0: double.parse(lenderReponse["rating"].toString()),
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Color(0xffCAAB05),
                            ),
                            itemCount: 5,
                            itemSize: 20.0,
                            direction: Axis.horizontal,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                  

                
            
            
                    // second row
                     Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                       children: [
                        // first colum
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          direction: Axis.vertical,
                          children: [
                            Text(
                           lenderReponse.isEmpty?"":  lenderReponse["total_item"].toString(),
                              style: GoogleFonts.lexendDeca(
                                fontWeight: FontWeight.w300,
                                  fontSize: 17, color: Colors.black),
                            ),
                             Text(
                              "Items",
                              style:  GoogleFonts.lexendDeca(
                                fontWeight: FontWeight.w300,
                                  fontSize: 12, color: Colors.black),
                            ),
                          ],
                        ),
                        // second colum
                         Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          direction: Axis.vertical,
                          children: [
                            Text(
                               lenderReponse
                                                          .isEmpty
                                                      ? ""
                                                      : MoneyFormatter(
                                                              amount: double.parse(lenderReponse[
                                                                      "closet_value"]
                                                                  .toString()
                                                                 ))
                                                          .output
                                                          .compactNonSymbol,
                              style: GoogleFonts.lexendDeca(
                                fontWeight: FontWeight.w300,
                                  fontSize: 17, color: Colors.black),
                            ),
                             Text(
                              "Closet Value",
                              style:  GoogleFonts.lexendDeca(
                                fontWeight: FontWeight.w300,
                                  fontSize: 12, color: Colors.black),
                            ),
                          ],
                        ),
                        // third colum
                         Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          direction: Axis.vertical,
                          children: [
                            Text(
                               lenderReponse
                                                          .isEmpty
                                                      ? ""
                                                       :MoneyFormatter(
                                                              amount: double.parse(lenderReponse[
                                                                      "follower"]
                                                                  .toString()
                                                                 ))
                                                          .output
                                                          .compactNonSymbol,
                              style:GoogleFonts.lexendDeca(
                                fontWeight: FontWeight.w300,
                                  fontSize: 17, color: Colors.black),
                            ),
                             Text(
                              "Followers",
                              style: GoogleFonts.lexendDeca(
                                fontWeight: FontWeight.w300,
                                  fontSize: 12, color: Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),

                      const SizedBox(height: 5)
            
                    // third row
            
                   
               
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

        //tabbar  ========================================================================================================

      Theme(
        data: ThemeData(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        child: Container(
          decoration: BoxDecoration(
                            //This is for background color
                            color: Colors.white.withOpacity(0.0),
                            //This is for bottom border that is needed
                            
                          ),
          child: TabBar(
            splashFactory: NoSplash.splashFactory,
          

            indicatorColor: Colors.black,
              indicatorWeight: 4,

             onTap: (value) {
               if(value==1)
               {


                setState(() {
                  pagenoR=1;
                });
             
                   getlenderReview(1);
                

        

               }

               else if(value==0)
               {     

                setState(() {
                  pagenoC=1;
                });
                     
                     getlenderProfile(1);

               }
             },

            labelColor: Colors.black,
            unselectedLabelColor: Colors.black,
            labelStyle: GoogleFonts.lexendExa(
              
                fontSize: 16, fontWeight: FontWeight.w300),
            tabs: const [
              Tab(text: "CLOSET"),
              Tab(text: "REVIEWS"),
            ],
            controller: tabController,
          ),
        ),
      ),
       


        Expanded(
        child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: tabController,
            children: [
              // tab one ==============================================================================================
           lenderListDecorded.isEmpty?

             Center(
              child: Container(
                alignment: Alignment.center,
                child: Text("No Products",style: GoogleFonts.lexendDeca(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w300,
                                                      color: Colors.grey),),
              ),
             ):    
    

        Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10,right: 10,bottom:20),
                    child:   DynamicHeightGridView(
                                          controller: _scrollControllerC,
                                          physics: const ClampingScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount:lenderListDecorded.length,
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10,
                                          builder: (context, index) {


                                            return InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProductView(
                                                              index: 0,
                                                            
                                                              id: lenderListDecorded[index]["id"].toString(),
                                                              comesFrom: "",

                                                               fromCart: false,
                                                            )));
                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(top: index==0?10:index==1?10:0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    
                                                    Stack(
                                                     
                                                      children: [
                                                        Hero(
                                                          tag:lenderListDecorded[index]["image_id"].toString(),
                                                          child: CachedNetworkImage(
                                                            
                                                            imageUrl:
                                                          
                                                         lenderListDecorded[index]["img_url"].toString(),
                                                            height: 220,
                                                            width: MediaQuery.of(context).size.width,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),


                                                        
                                                        
                                              
                                              
                                              
                                                            Visibility(
                                              
                                                              visible:lenderListDecorded[index]["type"]==1?false:true,
                                                              
                                                               child: Positioned(
                                                            
                                                                bottom: 0,
                                                                left: 0,
                                                                child: Container(
                                                                  margin: const EdgeInsets.all(5),
                                                                
                                                                  padding: const EdgeInsets.only(left: 3,right: 3),
                                                                 
                                                                  decoration: const BoxDecoration(
                                                                    color: Colors.white,
                                                                    borderRadius: BorderRadius.all(Radius.circular(50))
                                                                  ),
                                                                 
                                                                
                                                                  child: 
                                                                  Text("MANAGED",style: GoogleFonts.lexendExa(
                                                                    fontSize: 10,
                                                                    fontWeight: FontWeight.w400,
                                                                
                                                                    color: MyColors.themecolor
                                                                  ),),
                                                                ),
                                                              ),
                                                            )
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        const SizedBox(height: 5),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment.center,
                                                          children: [
                                                            Container(
                                                              alignment:
                                                                  Alignment.centerLeft,
                                                              margin:
                                                                  const EdgeInsets.only(),
                                                              child: Text(
                                                              lenderListDecorded[index]["brand_name"].toString(),
                                                                textAlign: TextAlign.left,
                                                                style: GoogleFonts
                                                                    .dmSerifDisplay(
                                                                  color: Colors.black,
                                                                  fontWeight:
                                                                      FontWeight.w400,
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                            ),

                                                              lenderListDecorded[index]["category_id"].toString()=="1"?
                                                          


                                                              Container(
                                                                height: 15,
                                                                padding: const EdgeInsets.only(left: 5,right: 5),
                                                                alignment: Alignment.center,
                                                                constraints: const BoxConstraints(minWidth: 20),
                                                               
                                                                decoration: BoxDecoration(
                                                                   borderRadius: const BorderRadius.all(Radius.circular(50)),
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .black,
                                                                        width:
                                                                            1)),
                                                                child: Text(
                                                                 lenderListDecorded[index]["size_name"].toString(),
                                                                  style: GoogleFonts.lexendDeca(
                                                                      fontSize:
                                                                          8,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              )

                                                               :

                                                        Container(
                                                            padding:
                                                                const EdgeInsets.all(5),
                                                                margin: const EdgeInsets.only(top: 5),
                                                                height: 20,
                                                                width: 10,
                                                           
                                                          
                                                          )
                                                          ],
                                                        ),
                                                        Container(
                                                          alignment: Alignment.centerLeft,
                                                          margin: const EdgeInsets.only(
                                                            top: 3,
                                                              bottom: 5),
                                                          child: Text(
                                                          lenderListDecorded[index]["title"].toString(),
                                                            overflow:
                                                                TextOverflow.ellipsis,
                                                            maxLines: 1,
                                                            textAlign: TextAlign.left,
                                                            style: GoogleFonts.lexendDeca(
                                                            fontWeight: FontWeight.w300,
                                                            color: const Color.fromARGB(255, 97, 97, 97),
                                                            fontSize: 12,
                                                          ),
                                                          ),
                                                        ),
                                                        Container(
                                                          alignment: Alignment.centerLeft,
                                                          margin: const EdgeInsets.only(
                                                            top: 3,
                                                              bottom: 5),
                                                          child: Text(

                                                              lenderListDecorded[index]["category_id"].toString()=="1"?
                                                            "RENT AED ${lenderListDecorded[index]["rent_amount"]} | 3 DAYS":
                                                            "RENT AED ${lenderListDecorded[index]["rent_amount"]} | 8 DAYS",
                                                            overflow:
                                                                TextOverflow.ellipsis,
                                                            maxLines: 1,
                                                            textAlign: TextAlign.left,
                                                            style:  GoogleFonts.lexendExa(
                                                            fontWeight: FontWeight.w300,
                                                            color: MyColors.themecolor,
                                                            fontSize: 12,
                                                          ),
                                                          ),
                                                        ),
                                                        Container(
                                                          alignment: Alignment.centerLeft,
                                                          margin: const EdgeInsets.only(
                                                              top: 3,
                                                              bottom: 20),
                                                          child: Text(
                                                           "Retail AED ${lenderListDecorded[index]["retail_price"]}",
                                                            overflow:
                                                                TextOverflow.ellipsis,
                                                            maxLines: 1,
                                                            textAlign: TextAlign.left,
                                                            style: GoogleFonts.lexendDeca(
                                                            decoration: TextDecoration
                                                                .lineThrough,
                                                            color: Colors.grey,
                                                            fontWeight: FontWeight.w300,
                                                            fontSize: 12,
                                                          ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                  ),


                                   Visibility(
                                     visible: showLazyIndicatorC, 
                                  
                                  
                                  
                                      
                                      child: Positioned(
                                       bottom: 0,
                                      
                                        child: Container(
                                          width: MediaQuery.of(context).size.width,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.only(right: 20),
                                          margin: const EdgeInsets.only(bottom: 10),
                                          child: const CircularProgressIndicator()),
                                      ),
                                    )
                ],
              ),

              // tab two ==========================================================================================

             lenderdecordedListReview.isEmpty?

             Center(
              child: Container(
                alignment: Alignment.center,
                child: Text("No Review",style: GoogleFonts.lexendDeca(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w300,
                                                      color: Colors.grey),),
              ),
             )

             :


              Stack(
                children: [
                  ListView.builder(
                      controller: _scrollControllerR,
                      physics: const ClampingScrollPhysics(),
                       itemCount: lenderdecordedListReview.length,
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemBuilder: ((context, index) {

                       List<dynamic> myImages=lenderdecordedListReview[index]["images"];
                       
                        
                        
                        
                          // for lender review UI =============================

                        return  lenderdecordedListReview[index]["type"].toString()=="2"?  Container(

                          padding: const EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 10),

                          margin: const EdgeInsets.only(top: 10,bottom: 10),

                          width: MediaQuery.of(context).size.width,
                         
                          decoration: const BoxDecoration(
                            color: Color(0xffF6F5F1)
                          ),

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                            

 const SizedBox(height: 10,),


                                    Wrap(
                                direction: Axis.horizontal,
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                 children: [
                                  
                                
                                  Container(
                                    width: 55,
                                    height: 55,
                                    padding: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(
                                       
                                        shape: BoxShape.circle),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(1000),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                           lenderdecordedListReview[index]["profile_img"].toString(),
                                        fit: BoxFit.cover,
                                        height: 55,
                                        width: 55,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                       Text(
                                        "${lenderdecordedListReview[index]["username"]} ",
                                        style:  GoogleFonts.dmSerifDisplay(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 15),
                                      ),
                                      RatingBarIndicator(
                                        rating: double.parse(lenderdecordedListReview[index]["rating"].toString()),
                                        itemBuilder: (context, index) =>
                                            const Icon(
                                          Icons.star,
                                          color: Color(0xffCAAB05),
                                        ),
                                        itemCount: 5,
                                        itemSize: 15.0,
                                        direction: Axis.horizontal,
                                      ),
                                    ],
                                  )
                                ],
                              ),

                              Container(
                                margin: const EdgeInsets.only(top: 10,left: 20),
                                child: Text('LENDER REVIEW',style: GoogleFonts.lexendExa(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12,
                                  color: Colors.black
                                ),),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10,bottom: 10,left: 20),
                                child: Text(lenderdecordedListReview[index]["comment"].toString(),style: GoogleFonts.lexendDeca(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12,
                                  color: Colors.black
                                ),),
                              )




                            ],
                          ),
                        )
                        
                        
                        :
                        
                        
                        Container(
                          margin: const EdgeInsets.only(
                              top: 10, bottom: 10, right: 10),
                          child: Wrap(
                            alignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            direction: Axis.vertical,
                            children: [
                              Wrap(
                                direction: Axis.horizontal,
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                 children: [
                                  const SizedBox(width: 10),
                                
                                  Container(
                                    width: 55,
                                    height: 55,
                                    padding: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(
                                       
                                        shape: BoxShape.circle),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(1000),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                           lenderdecordedListReview[index]["profile_img"].toString(),
                                        fit: BoxFit.cover,
                                        height: 55,
                                        width: 55,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                       Text(
                                        "${lenderdecordedListReview[index]["username"]} ",
                                        style:  GoogleFonts.dmSerifDisplay(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 15),
                                      ),
                                      RatingBarIndicator(
                                        rating: double.parse(lenderdecordedListReview[index]["rating"].toString()),
                                        itemBuilder: (context, index) =>
                                            const Icon(
                                          Icons.star,
                                          color: Color(0xffCAAB05),
                                        ),
                                        itemCount: 5,
                                        itemSize: 15.0,
                                        direction: Axis.horizontal,
                                      ),
                                    ],
                                  )
                                ],
                              ),

                              const SizedBox(height: 10),

                              // horizontal list


                             

                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height:myImages.isEmpty?0: 100,
                                child: ListView.builder(
                                    physics: const BouncingScrollPhysics(
                                        parent: ScrollPhysics()),
                                    itemCount: myImages.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index2) {
                                      return InkWell(
                                        onTap: () {
                                          
                              // view image dialog  ============================================
                                showGeneralDialog(
                                              context: context,
                                              barrierLabel: "Barrier",
                                              barrierDismissible: true,
                                              barrierColor:
                                                  Colors.black.withOpacity(0.5),
                                              transitionDuration:
                                                  const Duration(milliseconds: 100),
                                              pageBuilder: (_, __, ___) {
                                                return Center(
                                                    child: Container(
                                                        alignment: Alignment.center,
                                                        height: 400,
                                                        child: CachedNetworkImage(

                                                          imageUrl: myImages[index2].toString(),
                                                            height: 400,
                                                           fit: BoxFit.contain,
                                                            width: MediaQuery.of(context).size.width,
                                                            )));
                                              },
                                            );
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              left: index2 == 0 ? 30 : 5),
                                          child:CachedNetworkImage(
                                            imageUrl:myImages[index2].toString(),
                                            width: 88,
                                            height: 100,
                                            fit: BoxFit.cover,
                                            ),
                                        ),
                                      );
                                    }),
                              ),

                               SizedBox(height: myImages.isEmpty?0:10),

                              Container(
                                padding:
                                    const EdgeInsets.only(right: 5, left: 30),
                                width: MediaQuery.of(context).size.width,
                                child:  Text(

                                  lenderdecordedListReview[index]["comment"].toString(),
                                  style: GoogleFonts.lexendDeca(
                                    fontWeight: FontWeight.w300,
                                      color: const Color.fromARGB(255, 37, 37, 37), fontSize: 12),
                                ),
                              )
                            ],
                          ),
                        );
                      })),



                                   Visibility(
                                     visible: showLazyIndicatorR, 
                                  
                                  
                                  
                                      
                                      child: Positioned(
                                       bottom: 0,
                                      
                                        child: Container(
                                          width: MediaQuery.of(context).size.width,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.only(right: 20),
                                          margin: const EdgeInsets.only(bottom: 10),
                                          child: const CircularProgressIndicator()),
                                      ),
                                    )


                      
                ],
              )
            ]),
      )

       
    ],
      ),
    );
  }

    

    
  void showReviewdialog(String title,String value)
  {
      
   showGeneralDialog(
              
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

                                            SharedPreferences sharedPreferences =
                                    await SharedPreferences.getInstance();
                                sharedPreferences.clear();

                                     Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>    LoginPage(otpNumber: "")),
                                    (Route<dynamic> route) => false);

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
