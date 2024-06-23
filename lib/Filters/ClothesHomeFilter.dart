import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siz/Controllers/FilterController.dart';
import 'package:siz/Filters/FilterClothesAvailablity.dart';
import 'package:siz/Filters/FilterClothesBrands.dart';
import 'package:siz/Filters/FilterClothesCategory.dart';
import 'package:siz/Filters/FilterClothesClosetType.dart';
import 'package:siz/Filters/FilterClothesCollection.dart';
import 'package:siz/Filters/FilterClothesColor.dart';
import 'package:siz/Filters/FilterClothesLender.dart';
import 'package:siz/Filters/FilterClothesOccasion.dart';
import 'package:siz/Filters/FilterClothesSize.dart';
import 'package:siz/Pages/Cart.dart';
import 'package:siz/Pages/Wishlist.dart';

class ClothesHomeFilter extends StatefulWidget {
  const ClothesHomeFilter({super.key});

  @override
  State<ClothesHomeFilter> createState() => _ClothesHomeFilterState();
}

class _ClothesHomeFilterState extends State<ClothesHomeFilter> {
  @override
  void initState() {
    // FilterController controller=Get.put(FilterController());
    super.initState();
  }

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
                  height: 60,
                  alignment: Alignment.center,
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
                          controller.clearAll();
                            controller.getProducts(context, "1",0,"",1);
                            Navigator.pop(context);
                        },
                        child:  Text(
                          "Clear",
                          style: GoogleFonts.lexendDeca(fontSize: 16, color: Colors.black,fontWeight: FontWeight.w300),
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




                      // row second availablity ====================

                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const FilterClothesAvaliblity()));
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
                                      controller.fromDate.isEmpty
                                          ? ""
                                          : "${controller.fromDate} TO ${controller.toDate}",
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


                      // row one size ====================
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const FilterClothesSize()));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: 25, right: 25, ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                               Text(
                                "Size",
                                style: GoogleFonts.lexendDeca(
                                  fontWeight: FontWeight.w300,
                                    color: Colors.black, fontSize: 12),
                              ),

                                Wrap(
                                direction: Axis.horizontal,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                alignment: WrapAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                       controller.selectedSizeName,
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
                              //  Wrap(
                              //   alignment: WrapAlignment.center,
                              //   crossAxisAlignment: WrapCrossAlignment.center,
                              //   direction: Axis.horizontal,
                              //   children: [

                              //     Visibility(
                              //       visible: controller.multipleSelectedSize.isEmpty?false:true,
                              //       child: Text("(${controller.multipleSelectedSize.length}) ",
                              //       style: GoogleFonts.lexendDeca(
                              //           fontWeight: FontWeight.w400,
                              //             fontSize: 12, color: const Color(0xff898383)),),
                              //     ),
                              //     Container(
                              //       margin: const EdgeInsets.only(right: 7),
                              //       alignment: Alignment.centerRight,
                              //       height: 15,
                              //       width: 200,
                              //       child: ListView.builder(
                              //           itemCount: controller.multipleSelectedSize.length,
                              //           shrinkWrap: true,
                                        
                              //           scrollDirection: Axis.horizontal,
                              //           itemBuilder: (context, index) {
                              //             return Text(
                              //             "${controller.multipleSelectedSize[index]["title"]}, ",
                              //               style: GoogleFonts.lexendDeca(
                              //           fontWeight: FontWeight.w400,
                              //             fontSize: 12, color: const Color(0xff898383)));
                              //           }),
                              //     ),
                              //     SvgPicture.asset(
                              //         "assets/images/arrowrightfilter.svg")
                              //   ],
                              // )
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
                                      const FilterClothesClosetType()));
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
                                    visible: controller.multipleclosetTypeList.isEmpty?false:true,
                                    child: Text("(${controller.multipleclosetTypeList.length}) ",
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
                                        itemCount: controller.multipleclosetTypeList.length,
                                        shrinkWrap: true,
                                        
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return Text(
                                          "${controller.multipleclosetTypeList[index]["title"]}, ",
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
                      


                      
                      

// row third Category ====================

                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const FilterClothesCategory()));
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
                                    visible: controller.selectedcategoryList.isEmpty?false:true,
                                    child: Text("(${controller.selectedcategoryList.length}) ",
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
                                        itemCount: controller.selectedcategoryList.length,
                                        shrinkWrap: true,
                                        
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return Text(
                                          "${controller.selectedcategoryList[index]["name"]}, ",
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
                                      const FilterClothesColor()));
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
                                "Color",
                                style: GoogleFonts.lexendDeca(
                                    color: Colors.black,fontWeight: FontWeight.w300, fontSize: 12),
                              ),
                               Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                direction: Axis.horizontal,
                                children: [

                                  Visibility(
                                    visible: controller.colorListMultiple.isEmpty?false:true,
                                    child: Text("(${controller.colorListMultiple.length}) ",
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
                                        itemCount: controller.colorListMultiple.length,
                                        shrinkWrap: true,
                                        
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return Text(
                                          "${controller.colorListMultiple[index]["name"]}, ",
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
// row five brand ====================

                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const FilterClothesBrands()));
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
                                    visible: controller.multipleSelected.isEmpty?false:true,
                                    child: Text("(${controller.multipleSelected.length}) ",
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
                                        itemCount: controller.multipleSelected.length,
                                        shrinkWrap: true,
                                        
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return Text(
                                          "${controller.multipleSelected[index]["name"]}, ",
                                            style: GoogleFonts.lexendDeca(
                                        fontWeight: FontWeight.w400,
                                          fontSize: 12, color: const Color(0xff898383)));
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
// row six collection ====================

                       InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const FilterClothesCollection()));
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
                                    visible: controller.selectedcollectionList.isEmpty?false:true,
                                    child: Text("(${controller.selectedcollectionList.length}) ",
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
                                        itemCount: controller.selectedcollectionList.length,
                                        shrinkWrap: true,
                                        
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return Text(
                                          "${controller.selectedcollectionList[index]["name"]}, ",
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
                                      const FilterClothesOccasion()));
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
                                      visible: controller.multiSelectedOccasion.isEmpty?false:true,
                                      child: Text("(${controller.multiSelectedOccasion.length}) ",
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
                                          itemCount: controller.multiSelectedOccasion.length,
                                          shrinkWrap: true,
                                          
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            return Text(
                                            "${controller.multiSelectedOccasion[index]["name"]}, ",
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
// row eight lender ====================

                      InkWell(
                        onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const FilterClothesLender()));
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
                                    GoogleFonts.lexendDeca(fontWeight: FontWeight.w300,color: Colors.black, fontSize: 12),
                              ),
                              Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                direction: Axis.horizontal,
                                children: [


                                  Visibility(
                                    visible: controller.multiSelectedLenders.isEmpty?false:true,
                                    child: Text("(${controller.multiSelectedLenders.length}) ",
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
                                        itemCount: controller.multiSelectedLenders.length,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            alignment: Alignment.center,
                                            child:  Text(
                                              "${controller.multiSelectedLenders[index]["username"]}, ",
                                              style: GoogleFonts.lexendDeca(
                                        fontWeight: FontWeight.w400,
                                          fontSize: 12, color: const Color(0xff898383))
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
                      controller. noMoreDataC = false;
                         controller.pagenoC=1;
                     controller.getProducts(context, "1",0,"",1);
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 40),
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
