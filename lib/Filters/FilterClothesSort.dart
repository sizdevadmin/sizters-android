// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:siz/Controllers/FilterController.dart';
import 'package:siz/Pages/Cart.dart';
import 'package:siz/Pages/Wishlist.dart';

class FilterClothesSort extends StatefulWidget {
  const FilterClothesSort({super.key});

  @override
  State<FilterClothesSort> createState() => _FilterClothesSortState();
}

class _FilterClothesSortState extends State<FilterClothesSort> {
  

String currentSelectedValue="";

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
                        'Sort by',
                         style: GoogleFonts.dmSerifDisplay(
                            fontSize: 20, color: Colors.black,fontWeight: FontWeight.w400),
                      ),
                      InkWell(
                        onTap: () {},
                        child: InkWell(
                          onTap: () {
                             controller.pagenoC=1;
                             controller.updateSort("1");
                             controller. noMoreDataC=false;
                             controller.getProducts(context,"1" , 0,"",1);
                             Navigator.pop(context);
                          
  
                          },
                          child:  Text(
                            "Reset",
                            style: GoogleFonts.lexendDeca(fontSize: 16, color: Colors.black,fontWeight: FontWeight.w300),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                  Container(
                  margin: const EdgeInsets.only(top: 40, left: 30,bottom: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Sort by",
                    style: GoogleFonts.lexendExa(
                        fontSize: 14, color: Colors.black,fontWeight: FontWeight.w300),
                  ),
                ),

// radio list ==========================
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      left: 15,
                    ),
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: controller.sortList.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Theme(
                                data: ThemeData(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    textTheme:
                                        GoogleFonts.lexendDecaTextTheme(
                                      Theme.of(context).textTheme,
                                    ),
                                    primarySwatch:
                                        const MaterialColor(0xFFAF1010, {
                                      50: Color(0xFFAF1010),
                                      100: Color(0xFFAF1010),
                                      200: Color(0xFFAF1010),
                                      300: Color(0xFFAF1010),
                                      400: Color(0xFFAF1010),
                                      500: Color(0xFFAF1010),
                                      600: Color(0xFFAF1010),
                                      700: Color(0xFFAF1010),
                                      800: Color(0xFFAF1010),
                                      900: Color(0xFFAF1010),
                                    })),
                                child: RadioListTile(
                                    controlAffinity:
                                        ListTileControlAffinity.trailing,
                                    title: Text(
                                      controller.sortList[index]['label']
                                          .toString(),
                                      style:  GoogleFonts.lexendDeca(
                                          fontSize: 12,fontWeight: FontWeight.w300 ,color: Colors.black),
                                    ),
                                    value: controller.sortList[index]
                                        ['id'],
                                    groupValue: controller.sortclothes,
                                    onChanged: (value) {
                                    
                                      controller.updateSort(value.toString());

                                      
                                    }),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 10, right: 20,),
                                width: MediaQuery.of(context).size.width,
                                height: 1,
                                color: const Color.fromARGB(255, 221, 221, 221),
                              )
                            ],
                          );
                        }),
                  ),
                ),

                InkWell(
                onTap: () {
                   
                  controller.pagenoC=1;
                  controller.noMoreDataC=false;
                  
                  controller.getProducts(context,"1" , 0,"",1);
                  Navigator.pop(context);
                 
                },
                child: Container(
                  height: 40,
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(right: 20,left: 20, bottom: 30),
                 
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Colors.black),
                  child:  Text(
                    "SHOW RESULTS",
                    style: GoogleFonts.lexendExa(color: Colors.white, fontSize: 18,fontWeight: FontWeight.w300),
                  ),
                ),
              ),
              ],
            ),
          );
        });
  }
}
