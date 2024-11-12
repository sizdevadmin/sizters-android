// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siz/Controllers/BottomNavController.dart';
import 'package:siz/Controllers/FilterController.dart';
import 'package:siz/LoginSignUp/AccuntCreate.dart';
import 'package:siz/LoginSignUp/BasicLoginInfo.dart';
import 'package:siz/LoginSignUp/LoginPage.dart';
import 'package:siz/Pages/Cart.dart';
import 'package:siz/Pages/Home.dart';
import 'package:siz/Pages/ProductView.dart';
import 'package:siz/Pages/Wishlist.dart';
import 'package:siz/Utils/Colors.dart';
import 'package:siz/Utils/Value.dart';

class SearchList extends StatefulWidget {

  String searchKeyword="";
   SearchList({super.key,required this.searchKeyword});

  @override
  State<SearchList> createState() => _SearchListState();
}



class _SearchListState extends State<SearchList> {

  late FilterController controller;
  final ScrollController _scrollControllerS=ScrollController();
  int pagenoF=1;

   @override
     initState()
   {

   

    controller=Get.put(FilterController());
    controller.getProducts(context, "", 2, widget.searchKeyword,1);

       _scrollControllerS.addListener(()async  {
    
     
           scrollListenerSearch();
    });

    super.initState();
   }


   Future<void> scrollListenerSearch() async {
   
    if (controller.isLoadingMoreS) return;

    _scrollControllerS.addListener(() {

    
      if (_scrollControllerS.offset >=_scrollControllerS.position.maxScrollExtent-200) {
           controller.isLoadingMoreS = true;
           controller.forseUpdate();
          if (!controller.oncesCallS) {

            if(controller.noMoreDataS)
            {
              return;
            }

            else{

               controller.getProducts(context, "", 2, widget.searchKeyword,++pagenoF);
            
             controller. oncesCallS = true;
             controller.forseUpdate();

            }
    
            
          
          }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: FilterController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: ()  async{
             controller.noMoreDataS=false;
                                    controller.forseUpdate();
                                    Navigator.pop(context);
            return false;
          },
          child: Scaffold(
               appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              toolbarHeight: 0,
            ),
        
            body: Column(
              children: [
                  // top four icon =============================================================================
                        Container(
                          alignment: Alignment.center,
                          height: 60,
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration:
                              const BoxDecoration(color: Colors.white, boxShadow: [
                            BoxShadow(
                                color: Color.fromARGB(255, 216, 216, 216),
                                blurRadius: 2,
                                offset: Offset(0, 2))
                          ]),
                          padding:
                              const EdgeInsets.only(right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                  onTap: () {
                                    controller.noMoreDataS=false;
                                    controller.forseUpdate();
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    width: 50,
                                    child: SvgPicture.asset(
                                        "assets/images/backarrow.svg",width: 20,height: 20,),
                                  )),
                              Container(
                                  margin: const EdgeInsets.only(left: 30),
                                  child: Text(
                                              "Search Results".toUpperCase(),
                                              style: SizValue.toolbarStyle
                                            )
                                  ),
                              Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                direction: Axis.horizontal,
                                children: [
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

                            //  else if(sharedPreferences.getString(SizValue.isLogged).toString()=="2")
                            //  {

                            //     Navigator.push(context, MaterialPageRoute(builder: (context)=>AccountCreate()));

                            // }
        
                            //    else if(sharedPreferences.getString(SizValue.underReview).toString()=="0"){
        
                            //         showReviewdialog(sharedPreferences.getString(SizValue.underReviewMsg).toString(),sharedPreferences.getString(SizValue.underReview).toString());
        
            
                            //       }
        
                                  else if(sharedPreferences.getString(SizValue.underReview).toString()=="2"){
        
                                    showReviewdialog(sharedPreferences.getString(SizValue.rejectedReviewMSG).toString(),sharedPreferences.getString(SizValue.underReview).toString());
        
            
        
                                  }
                                  else if(sharedPreferences.getString(SizValue.underReview).toString()=="3"){
        
                                    showReviewdialog(sharedPreferences.getString(SizValue.incompleteMessage).toString(),sharedPreferences.getString(SizValue.underReview).toString());
        
            
        
                                  }
        
                                  else
                                   {
        
        
                                    gotoWishlist();
        
        
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) =>
                                        //              Wishlist()));
        
                                  }
        
        
        
        
        
        
        
                                      },
                                      child: SvgPicture.asset(
                                          "assets/images/heart.svg",width: 20,height: 20,)),
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
        
        
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => const Cart()));
        
                                  }
        
        
        
        
        
        
        
        
        
                                      },
                                      child:
                                          SvgPicture.asset("assets/images/bag.svg",width: 20,height: 20,)),
                                ],
                              )
                            ],
                          ),
                        ),
        
        
        
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(left: 10,right: 10),
                                child:controller. decrodedSearchresponse.isEmpty? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                children: [
                                  LottieBuilder.asset(
                                    "assets/images/notfound.json",
                                    height: 200,
                                  ),
                                  Container(
                                      margin: const EdgeInsets.only(
                                          bottom: 70, top: 10),
                                      child:  Text("No data found",style: GoogleFonts.lexendDeca(
                                  fontWeight: FontWeight.w300,
        
           
                                  fontSize: 14,color:Colors.grey
        
                                ),)),
                                ],
                                    ):Stack(
                                    
                                      children: [
                                        DynamicHeightGridView(
                                                physics: const ClampingScrollPhysics(),
                                                controller: _scrollControllerS,
                                                shrinkWrap: true,
                                                
                                                itemCount:controller. decrodedSearchresponse.length,
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
                                                                   index: index,
                                                                  comesFrom: "3",
                                                                    id: controller.decrodedSearchresponse[index]["id"].toString(),
                                                                     fromCart: false,
                                                                  )));
                                                    },
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        
                                                        Stack(
                                                         
                                                          children: [
                                                            Hero(
                                                              tag: controller.decrodedSearchresponse[index]["image_id"].toString(),
                                                              child: CachedNetworkImage(
                                                                
                                                                imageUrl:
                                                              
                                                              controller. decrodedSearchresponse[index]["img_url"].toString(),
                                                                height: 220,
                                                                width: MediaQuery.of(context).size.width,
                                                                fit: BoxFit.cover,
                                                              ),
                                                            ),
                                                            InkWell(
                                                                onTap: ()async {
        
        
        
        
                                                                     SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
                       
                               if(sharedPreferences.getString(SizValue.isLogged).toString()=="null")
                               {
        
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage(otpNumber: "")));
        
                               }
        
        
                                     else if(sharedPreferences.getString(SizValue.isLogged).toString()=="1")
                             {

                                Navigator.push(context, MaterialPageRoute(builder: (context)=>BasicLoginInfo(fromWhere: sharedPreferences.getString(SizValue.source).toString())));

                             }
                            //  else if(sharedPreferences.getString(SizValue.isLogged).toString()=="2")
                            //  {

                            //     Navigator.push(context, MaterialPageRoute(builder: (context)=>AccountCreate()));

                            // }
        
                            //    else if(sharedPreferences.getString(SizValue.underReview).toString()=="0"){
        
                            //         showReviewdialog(sharedPreferences.getString(SizValue.underReviewMsg).toString(),sharedPreferences.getString(SizValue.underReview).toString());
        
            
                            //       }
        
                                  else if(sharedPreferences.getString(SizValue.underReview).toString()=="2"){
        
                                    showReviewdialog(sharedPreferences.getString(SizValue.rejectedReviewMSG).toString(),sharedPreferences.getString(SizValue.underReview).toString());
        
            
        
                                  }
                                  else if(sharedPreferences.getString(SizValue.underReview).toString()=="3"){
        
                                    showReviewdialog(sharedPreferences.getString(SizValue.incompleteMessage).toString(),sharedPreferences.getString(SizValue.underReview).toString());
        
            
        
                                  }
        
                                  else
                                  {
        
                                     if(  controller. decrodedSearchresponse[index]["wishlist"]==0)
                                                                   {
                                                            
                                                                  controller.addWishlist(context, controller. decrodedSearchresponse[index]["id"].toString(), index,"3","3");
                                                            
                                                                   }
                                                            
                                                                   else
                                                            
                                                                   {
                                                            
                                                                    controller.removeWishlist(context, controller. decrodedSearchresponse[index]["id"].toString(), index,"3","3");
                                                            
                                                            
                                                                   }
        
                                  }
                                                                  
                                                                },
                                                                child: Container(
                                                                  alignment: Alignment.centerRight,
                                                                  child: Container(
                                                                   
                                                                    padding:
                                                                        const EdgeInsets.all(3),
                                                                    margin:
                                                                        const EdgeInsets.all(4),
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                            shape:
                                                                                BoxShape.circle,
                                                                            boxShadow: [
                                                                               BoxShadow(
                                                                              color: Color
                                                                                  .fromARGB(27,
                                                                                      0, 0, 0),
                                                                              blurRadius: 3)
                                                                        ]),
                                                                    child: SvgPicture.asset(
                                                                        controller. decrodedSearchresponse[index]["wishlist"]==0
                                                                        ? "assets/images/likebefore.svg"
                                                                        : "assets/images/likeafter.svg"),
                                                                  ),
                                                                )),
                                                            
                                                            
                                                            
                                                                Visibility(
                                                            
                                                                  visible: controller. decrodedSearchresponse[index]["type"]==1?false:true,
                                                                  
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
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment.center,
                                                              children: [
                                                                Expanded(
                                                                  child: Container(
                                                                    alignment:
                                                                        Alignment.centerLeft,
                                                                    margin:
                                                                        const EdgeInsets.only(),
                                                                    child: Text(
                                                                      controller.decrodedSearchresponse[index]["brand_name"].toString(),
                                                                      maxLines: 1,
                                                                      overflow: TextOverflow.ellipsis,
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
                                                                ),
        
                                                                controller.decrodedSearchresponse[index]["category_id"].toString()=="1"
                                                                ?
                                                               
                                                               
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
                                                                    controller
                                                                        .decrodedSearchresponse[
                                                                            index]
                                                                            [
                                                                            "size_name"]
                                                                        .toString(),
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
                                                                controller.decrodedSearchresponse[index]["title"].toString(),
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
        
                                                                controller.decrodedSearchresponse[index]["category_id"].toString()=="1"?
                                                                "RENT AED ${controller.decrodedSearchresponse[index]["rent_amount"]} | 3 DAYS":
                                                                "RENT AED ${controller.decrodedSearchresponse[index]["rent_amount"]} | 8 DAYS",
                                                                overflow:
                                                                    TextOverflow.ellipsis,
                                                                maxLines: 1,
                                                                textAlign: TextAlign.left,
                                                                style:   GoogleFonts.lexendExa(
                                                                color: MyColors.themecolor,
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.w300
                                                              ),
                                                              ),
                                                            ),
                                                            Container(
                                                              alignment: Alignment.centerLeft,
                                                              margin: const EdgeInsets.only(
                                                                  top: 3,
                                                                  bottom: 20),
                                                              child: Text(
                                                               "Retail AED ${controller.decrodedSearchresponse[index]["retail_price"]}",
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
                                                  );
                                                },
                                              ),
        
                                    Visibility(
                                        visible: controller.showLazyIndicator,
                                        child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                            margin: const EdgeInsets.only(bottom: 10),
                                            child: const CircularProgressIndicator()),
                                        ),
                                      )
                                      ],
                                    ),
        
                                          
                              ),
                            ),
        
                             
              ],
            ),
          ),
        );
      }
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
                                           final BottomNavController controller =
                                    Get.put(BottomNavController());
                          
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


  

  
 Future<void> gotoWishlist() async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Wishlist(from: "search")),
    );

  
    if (!context.mounted) return;

    if(result.toString()=="true")
    {  


       setState(() {
         pagenoF=1;
         controller. decrodedSearchresponse.clear();
       });
       controller.getProducts(context, "", 2, widget.searchKeyword,1);
      

    }

  
    
    
  }



}