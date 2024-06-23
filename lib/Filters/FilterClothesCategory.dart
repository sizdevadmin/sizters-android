import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siz/Controllers/FilterController.dart';
import 'package:siz/Pages/Cart.dart';
import 'package:siz/Pages/Wishlist.dart';

class FilterClothesCategory extends StatefulWidget {
  const FilterClothesCategory({super.key});

  @override
  State<FilterClothesCategory> createState() => _FilterClothesCategoryState();
}

class _FilterClothesCategoryState extends State<FilterClothesCategory> {


  late FilterController controller;

  @override
  void initState()
  {

    controller=Get.put(FilterController());

   
     getdata();

  
    super.initState();
  }


  getdata() async
  {

     if(!controller.tabbedCategory)
    {

       await controller.getcategoryFilter(context,"1");

        // call app
       controller.tabbedCategory=true;
       controller.forseUpdate();
    }


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


              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
               

                    // top text =============================================

                    Container(
                      margin: const EdgeInsets.only(
                          top: 10, left: 10, right: 10, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 45,
                            height: 20,
                          ),
                          Text(
                            'Categories',
                            style: GoogleFonts.dmSerifDisplay(
                              fontWeight: FontWeight.w400,
                                fontSize: 20, color: Colors.black),
                          ),
                          InkWell(
                            onTap: () {
                               
                              controller.getcategoryFilter(context,"1");
                              controller. selectedcategoryList.clear();
                              controller.forseUpdate();
  
                               
                            },
                            child:  Text(
                              "Clear",
                              style: GoogleFonts.lexendDeca(fontSize: 16,fontWeight: FontWeight.w300, color: Colors.black),
                            ),
                          )
                        ],
                      ),
                    ),

                    // body =========================================

                    // selected brands text heading
                    Visibility(
                      visible: controller. multipleSelected.isEmpty ? false : true,
                      child: Container(
                        margin: const EdgeInsets.only(left: 30, bottom: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "SELECTED CATEGORY",
                          style: GoogleFonts.lexendExa(
                            fontWeight: FontWeight.w300,
                              fontSize: 14, color: Colors.black),
                        ),
                      ),
                    ),

                    // selected list

                    Container(
                      margin: const EdgeInsets.only(left: 30, right: 30),
                      child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 4,
                          ),
                          padding: const EdgeInsets.all(0),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller. selectedcategoryList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                int found = controller. categoryList.indexWhere((item) =>
                                    item["name"] ==  (controller.selectedcategoryList[index]["name"].toString()));


                                  controller. categoryList[found]["check"] = false;
                                  controller. selectedcategoryList.removeAt(index);
                                  controller.forseUpdate();
                                   
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(60)),
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(
                                    left: 5, right: 5, top: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: MediaQuery.of(context).size.width,
                                        margin: const EdgeInsets.only(
                                            left: 20, right: 10),
                                        child: Text(
                                          controller. selectedcategoryList[index]["name"],
                                          overflow: TextOverflow.ellipsis,
                                          style:GoogleFonts.lexendDeca(
                                          fontSize: 12,fontWeight: FontWeight.w300 ,color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    Container(
                                        margin: const EdgeInsets.only(right: 20),
                                        child: SvgPicture.asset(
                                          "assets/images/close.svg",
                                          height: 10,
                                          width: 10,
                                          color: Colors.white,
                                        ))
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),

                    // all brands text

                    Container(
                      margin: const EdgeInsets.only(left: 30, top: 30, bottom: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "SELECT/DESELECT",
                        style: GoogleFonts.lexendExa(
                          fontWeight: FontWeight.w300,
                            fontSize: 14, color: Colors.black),
                      ),
                    ),

                    // all brands list

                    Container(
                      margin: const EdgeInsets.only(left: 15, right: 15),
                      child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(0),
                          shrinkWrap: true,
                          itemCount:  controller.categoryList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(left: 15, right: 15),
                              child: CheckboxListTile(
                                controlAffinity: ListTileControlAffinity.platform,
                                contentPadding: EdgeInsets.zero,
                                checkboxShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                dense: true,
                                title: Text(
                                  controller. categoryList[index]["name"],
                                  style: GoogleFonts.lexendDeca(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black,
                                  ),
                                ),
                                value: controller. categoryList[index]["check"],
                                onChanged: (value) {
                                  setState(() {
                                    controller. categoryList[index]["check"] = value;

                                    if ( controller. selectedcategoryList
                                        .contains( controller. categoryList[index])) {
                                      setState(() {
                                       controller.  selectedcategoryList.remove( controller.categoryList[index]);
                                       controller.forseUpdate();
                                      });
                                    } else {
                                      setState(() {
                                         controller. selectedcategoryList.add( controller.categoryList[index]);
                                         controller.forseUpdate();
                                      });
                                    }
                                  });
                                },
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(left: 13, right: 13, bottom: 40),
                  decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: Text(
                    "APPLY FILTER",
                    style: GoogleFonts.lexendExa(color: Colors.white, fontSize: 16,fontWeight: FontWeight.w300),
                  ),
                ),
              )
            ],
          ),
        );
      }
    );
  }
}
