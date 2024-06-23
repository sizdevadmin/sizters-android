import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siz/Controllers/FilterController.dart';
import 'package:siz/Filters/FIlterBagsCategory.dart';
import 'package:siz/Filters/FilterBagsAvailablity.dart';
import 'package:siz/Filters/FilterBagsBrands.dart';
import 'package:siz/Filters/FilterBagsClosetType.dart';
import 'package:siz/Filters/FilterBagsCollection.dart';
import 'package:siz/Filters/FilterBagsColor.dart';
import 'package:siz/Filters/FilterBagsLender.dart';
import 'package:siz/Filters/FilterBagsOccasion.dart';


import 'package:siz/Pages/Cart.dart';
import 'package:siz/Pages/Wishlist.dart';

class BagsHomeFilter extends StatefulWidget {
  const BagsHomeFilter({super.key});

  @override
  State<BagsHomeFilter> createState() => _BagsHomeFilterState();
}

class _BagsHomeFilterState extends State<BagsHomeFilter> {
 

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: FilterController(),
        builder: (controller) {
          return Scaffold(
             appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              toolbarHeight: 0,
            ),
            body: Column(
              children: [
                // top four icon ===========================
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration:
                      const BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(255, 216, 216, 216),
                        blurRadius: 2,
                        offset: Offset(0, 2))
                  ]),
                  height: 60,
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.only(right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            width: 50,
                            child:
                                SvgPicture.asset("assets/images/backarrow.svg",width: 20,height: 20,),
                          )),
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                             Wishlist()));
                              },
                              child:
                                  SvgPicture.asset("assets/images/heart.svg",width: 20,height: 20,)),
                          const SizedBox(width: 20),
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Cart()));
                              },
                              child: SvgPicture.asset("assets/images/bag.svg",width: 20,height: 20,)),
                        ],
                      )
                    ],
                  ),
                ),

// top text and clear text ============================
                Container(
                   margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 45,
                        height: 20,
                      ),
                      Text(
                        'Filter by',
                        style: GoogleFonts.dmSerifDisplay(
                          fontWeight: FontWeight.w400,
                            fontSize: 20, color: Colors.black),
                      ),
                      InkWell(
                        onTap: () {
                          controller.clearAllBags();
                           controller.getProducts(context, "2", 1,"",1);
                           Navigator.pop(context);
                        },
                        child:  Text(
                          "Clear",
                          style:  GoogleFonts.lexendDeca(fontSize: 16,fontWeight: FontWeight.w300 ,color: Colors.black),
                        ),
                      )
                    ],
                  ),
                ),


            

                // filter row =========================================================
                 Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [







// availablity ====================



                  InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const FilterBagsAvailablity()));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                            left: 25,
                            right: 25,
                            top: 50
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                               Text(
                                "Availabilty",
                                style: GoogleFonts.lexendDeca(
                                    color: Colors.black, fontWeight: FontWeight.w300, fontSize: 12),
                              ),
                              Wrap(
                                direction: Axis.horizontal,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                alignment: WrapAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      controller.fromDateBags.isEmpty
                                          ? ""
                                          : "${controller.fromDateBags} TO ${controller.toDateBags}",
                                      style: GoogleFonts.lexendDeca(
                                        fontWeight: FontWeight.w400,
                                          fontSize: 12, color: const Color(0xff898383)),
                                    ),
                                  ),
                                  const SizedBox(width: 7),
                                  SvgPicture.asset(
                                      "assets/images/arrowrightfilter.svg")
                                ],
                              )
                            ],
                          ),
                        ),
                      ),



             
                        // divider
                      Container(
                        margin: const EdgeInsets.only(
                            left: 25, right: 25, top: 15, bottom: 15),
                        width: MediaQuery.of(context).size.width,
                        height: 1,
                        color: const Color.fromARGB(255, 211, 211, 211),
                      ),


// closet type ====================

                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const FilterBagsClosetType()));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                            left: 25,
                            right: 25,
                          
                            
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                               Text(
                                "Closet Type",
                                style: GoogleFonts.lexendDeca(
                                    color: Colors.black,fontWeight: FontWeight.w300 ,fontSize: 12),
                              ),
                                Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                direction: Axis.horizontal,
                                children: [

                                  Visibility(
                                    visible: controller.multipleclosetTypeListBags.isEmpty?false:true,
                                    child: Text("(${controller.multipleclosetTypeListBags.length}) ",
                                    style:  GoogleFonts.lexendDeca(
                                        fontWeight: FontWeight.w400,
                                          fontSize: 12, color: const Color(0xff898383)),),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(right: 7),
                                    alignment: Alignment.centerRight,
                                    height: 15,
                                    width: 200,
                                    child: ListView.builder(
                                        itemCount: controller.multipleclosetTypeListBags.length,
                                        shrinkWrap: true,
                                        
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return Text(
                                          "${controller.multipleclosetTypeListBags[index]["title"]}, ",
                                            style: GoogleFonts.lexendDeca(
                                        fontWeight: FontWeight.w400,
                                          fontSize: 12, color: const Color(0xff898383)),
                                          );
                                        }),
                                  ),
                                  SvgPicture.asset(
                                      "assets/images/arrowrightfilter.svg")
                                ],
                              )
                            ],
                          ),
                        ),
                      ),


                        // divider
                       Container(
                        margin: const EdgeInsets.only(
                            left: 25, right: 25, top: 15, bottom: 15),
                        width: MediaQuery.of(context).size.width,
                        height: 1,
                        color: const Color.fromARGB(255, 211, 211, 211),
                      ),


                                    InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const FilterBagsCategory()));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                            left: 25,
                            right: 25,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                               Text(
                                "Category",
                                style: GoogleFonts.lexendDeca(
                                    color: Colors.black,fontWeight: FontWeight.w300 ,fontSize: 12),
                              ),
                                Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                direction: Axis.horizontal,
                                children: [

                                  Visibility(
                                    visible: controller.selectedcategoryListBags.isEmpty?false:true,
                                    child: Text("(${controller.selectedcategoryListBags.length}) ",
                                    style:  GoogleFonts.lexendDeca(
                                        fontWeight: FontWeight.w400,
                                          fontSize: 12, color: const Color(0xff898383)),),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(right: 7),
                                    alignment: Alignment.centerRight,
                                    height: 15,
                                    width: 200,
                                    child: ListView.builder(
                                        itemCount: controller.selectedcategoryListBags.length,
                                        shrinkWrap: true,
                                        
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return Text(
                                          "${controller.selectedcategoryListBags[index]["name"]}, ",
                                            style: GoogleFonts.lexendDeca(
                                        fontWeight: FontWeight.w400,
                                          fontSize: 12, color: const Color(0xff898383)),
                                          );
                                        }),
                                  ),
                                  SvgPicture.asset(
                                      "assets/images/arrowrightfilter.svg")
                                ],
                              )
                            ],
                          ),
                        ),
                      ),

                      // divider
                      Container(
                        margin: const EdgeInsets.only(
                            left: 25, right: 25, top: 15, bottom: 15),
                        width: MediaQuery.of(context).size.width,
                        height: 1,
                        color: const Color.fromARGB(255, 211, 211, 211),
                      ),


                      // row four color ====================

                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const FilterBagsColor()));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                            left: 25,
                            right: 25,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                               Text(
                                "Colors",
                                style: GoogleFonts.lexendDeca(
                                    color: Colors.black,fontWeight: FontWeight.w300, fontSize: 12),
                              ),
                               Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                direction: Axis.horizontal,
                                children: [

                                  

                                  Visibility(
                                    visible: controller.colorListMultipleBags.isEmpty?false:true,
                                    child: Text("(${controller.colorListMultipleBags.length}) ",
                                    style: GoogleFonts.lexendDeca(
                                        fontWeight: FontWeight.w400,
                                          fontSize: 12, color: const Color(0xff898383)),),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(right: 7),
                                    alignment: Alignment.centerRight,
                                    height: 15,
                                    width: 200,
                                    child: ListView.builder(
                                        itemCount: controller.colorListMultipleBags.length,
                                        shrinkWrap: true,
                                        
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return Text(
                                          "${controller.colorListMultipleBags[index]["name"]}, ",
                                            style: GoogleFonts.lexendDeca(
                                        fontWeight: FontWeight.w400,
                                          fontSize: 12, color: const Color(0xff898383))
                                          );
                                        }),
                                  ),
                                  SvgPicture.asset(
                                      "assets/images/arrowrightfilter.svg")
                                ],
                              )
                            ],
                          ),
                        ),
                      ),

                      // divider
                      Container(
                        margin: const EdgeInsets.only(
                            left: 25, right: 25, top: 15, bottom: 15),
                        width: MediaQuery.of(context).size.width,
                        height: 1,
                        color: const Color.fromARGB(255, 211, 211, 211),
                      ),



                                          InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const FilteBagsCollection()));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                            left: 25,
                            right: 25,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                               Text(
                                "Collection",
                                style: GoogleFonts.lexendDeca(
                                    color: Colors.black,fontWeight: FontWeight.w300 ,fontSize: 12),
                              ),
                                  Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                direction: Axis.horizontal,
                                children: [

                                  Visibility(
                                    visible: controller.selectedcollectionListBags.isEmpty?false:true,
                                    child: Text("(${controller.selectedcollectionListBags.length}) ",
                                    style: GoogleFonts.lexendDeca(
                                        fontWeight: FontWeight.w400,
                                          fontSize: 12, color: const Color(0xff898383)),),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(right: 7),
                                    alignment: Alignment.centerRight,
                                    height: 15,
                                    width: 200,
                                    child: ListView.builder(
                                        itemCount: controller.selectedcollectionListBags.length,
                                        shrinkWrap: true,
                                        
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return Text(
                                          "${controller.selectedcollectionListBags[index]["name"]}, ",
                                            style: GoogleFonts.lexendDeca(
                                        fontWeight: FontWeight.w400,
                                          fontSize: 12, color: const Color(0xff898383))
                                          );
                                        }),
                                  ),
                                  SvgPicture.asset(
                                      "assets/images/arrowrightfilter.svg")
                                ],
                              )
                            ],
                          ),
                        ),
                      ),

                      // divider
                      Container(
                        margin: const EdgeInsets.only(
                            left: 25, right: 25, top: 15, bottom: 15),
                        width: MediaQuery.of(context).size.width,
                        height: 1,
                        color: const Color.fromARGB(255, 211, 211, 211),
                      ),



                      // row seven Occasion ====================

                      InkWell(
                        onTap: () {
                           Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const FilterBagsOccasion()));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                            left: 25,
                            right: 25,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                               Text(
                                "Occasion",
                                style:
                                    GoogleFonts.lexendDeca(color: Colors.black,fontWeight: FontWeight.w300 ,fontSize: 12),
                              ),
                             Wrap(
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  direction: Axis.horizontal,
                                  children: [
                      
                                    Visibility(
                                      visible: controller.multiSelectedOccasionBags.isEmpty?false:true,
                                      child: Text("(${controller.multiSelectedOccasionBags.length}) ",
                                      style: GoogleFonts.lexendDeca(
                                        fontWeight: FontWeight.w400,
                                          fontSize: 12, color: const Color(0xff898383)),),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(right: 7),
                                      alignment: Alignment.centerRight,
                                      height: 15,
                                      width: 200,
                                      child: ListView.builder(
                                          itemCount: controller.multiSelectedOccasionBags.length,
                                          shrinkWrap: true,
                                          
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            return Text(
                                            "${controller.multiSelectedOccasionBags[index]["name"]}, ",
                                              style:GoogleFonts.lexendDeca(
                                        fontWeight: FontWeight.w400,
                                          fontSize: 12, color: const Color(0xff898383)),
                                            );
                                          }),
                                    ),
                                    SvgPicture.asset(
                                        "assets/images/arrowrightfilter.svg")
                                  ],
                                )
                            ],
                          ),
                        ),
                      ),

                      // divider
                      Container(
                        margin: const EdgeInsets.only(
                            left: 25, right: 25, top: 15, bottom: 15),
                        width: MediaQuery.of(context).size.width,
                        height: 1,
                        color: const Color.fromARGB(255, 211, 211, 211),
                      ),

                     
// row one brand ====================

                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const FilterBagsBrands()));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                            left: 25,
                            right: 25,
                           
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                               Text(
                                "Brand",
                                style:
                                     GoogleFonts.lexendDeca(color: Colors.black,fontWeight: FontWeight.w300 ,fontSize: 12),
                              ),
                              Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                direction: Axis.horizontal,
                                children: [

                                  Visibility(
                                    visible: controller.multiBrandBags.isEmpty?false:true,
                                    child: Text("(${controller.multiBrandBags.length}) ",
                                    style: GoogleFonts.lexendDeca(
                                        fontWeight: FontWeight.w400,
                                          fontSize: 12, color: const Color(0xff898383)),),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(right: 7),
                                    alignment: Alignment.centerRight,
                                    height: 15,
                                    width: 200,
                                    child: ListView.builder(
                                        itemCount: controller.multiBrandBags.length,
                                        shrinkWrap: true,
                                        
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return Text(
                                          "${controller.multiBrandBags[index]["name"]}, ",
                                            style: GoogleFonts.lexendDeca(
                                        fontWeight: FontWeight.w400,
                                          fontSize: 12, color: const Color(0xff898383)),
                                          );
                                        }),
                                  ),
                                  SvgPicture.asset(
                                      "assets/images/arrowrightfilter.svg")
                                ],
                              )
                            ],
                          ),
                        ),
                      ),

                      // divider
                      Container(
                        margin: const EdgeInsets.only(
                            left: 25, right: 25, top: 15, bottom: 15),
                        width: MediaQuery.of(context).size.width,
                        height: 1,
                        color: const Color.fromARGB(255, 211, 211, 211),
                      ),


// row two lender ====================

                      InkWell(
                        onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const FilterBagLenders()));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                            left: 25,
                            right: 25,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                               Text(
                                "Lender",
                                style:
                                     GoogleFonts.lexendDeca(color: Colors.black, fontWeight: FontWeight.w300,fontSize: 12),
                              ),
                              Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                direction: Axis.horizontal,
                                children: [


                                  Visibility(
                                    visible: controller.multiLenderBags.isEmpty?false:true,
                                    child: Text("(${controller.multiLenderBags.length}) ",
                                    style:GoogleFonts.lexendDeca(
                                        fontWeight: FontWeight.w400,
                                          fontSize: 12, color: const Color(0xff898383)),
                                                  
                                                  
                                                  ),
                                  ),

  

                                  Container(
                                    margin: const EdgeInsets.only(right: 7),
                                    alignment: Alignment.centerRight,
                                    height: 15,
                                    width: 200,
                                    child: ListView.builder(
                                        itemCount: controller.multiLenderBags.length,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            alignment: Alignment.center,
                                            child:  Text(
                                              "${controller.multiLenderBags[index]["username"]}, ",
                                              style: GoogleFonts.lexendDeca(
                                        fontWeight: FontWeight.w400,
                                          fontSize: 12, color: const Color(0xff898383)),
                                            ),
                                          );
                                        }),
                                  ),
                                  SvgPicture.asset(
                                      "assets/images/arrowrightfilter.svg")
                                ],
                              )
                            ],
                          ),
                        ),
                      ),

                      // divider
                      Container(
                        margin: const EdgeInsets.only(
                            left: 25, right: 25, top: 15, bottom: 15),
                        width: MediaQuery.of(context).size.width,
                        height: 1,
                        color: const Color.fromARGB(255, 211, 211, 211),
                      ),
                    ],
                  ),
                ),

                InkWell(
                  onTap: () {
                   controller. noMoreDataB = false;
                   controller.pagenoB=1;
                   controller.getProducts(context, "2", 1,"",1);
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin:
                        const EdgeInsets.only(left: 13, right: 13, bottom: 40),
                    decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    child: Text(
                      "SHOW RESULTS",
                      style: GoogleFonts.lexendExa(
                        fontWeight: FontWeight.w300,
                          color: Colors.white, fontSize: 16),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
