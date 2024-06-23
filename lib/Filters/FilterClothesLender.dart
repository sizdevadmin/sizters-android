import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siz/Controllers/FilterController.dart';
import 'package:siz/Pages/Cart.dart';
import 'package:siz/Pages/Wishlist.dart';

class FilterClothesLender extends StatefulWidget {
  const FilterClothesLender({super.key});

  @override
  State<FilterClothesLender> createState() => _FilterClothesLenderState();
}

class _FilterClothesLenderState extends State<FilterClothesLender> {



    late FilterController controller;
      TextEditingController searchController = TextEditingController();
        


  @override
  void initState()
  {

    controller=Get.put(FilterController());

   
     getdata();

        _scrollController.addListener(()async  {
    
     
      scrollListener();
    });

  
    super.initState();
  }


  getdata() async
  {

     if(!controller.tabbedLender)
    {

       await controller.getlenderData(context,"1","",1);
        // call app
       controller.tabbedLender=true;
       controller.forseUpdate();
    }


  }

  final ScrollController _scrollController=ScrollController();
        int pagenoFLC=1;

   Timer? checkTypingTimer;
    String stringValue = "";

   Future<void> scrollListener() async {
   
    if (controller.isLoadingMoreFLC) return;

    _scrollController.addListener(() {

    
      if (_scrollController.offset >=_scrollController.position.maxScrollExtent) {
           controller.isLoadingMoreFLC = true;
           controller.forseUpdate();
          if (!controller.oncesCallFLC) {

          
             controller.getlenderData(context,"1",searchController.text,++pagenoFLC);
             controller. oncesCallFLC = true;
             controller.forseUpdate();
          
          }
      }
    });
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
                  controller: _scrollController,
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: [

                      // top text =============================================\

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
                            'Lender',
                            style: GoogleFonts.dmSerifDisplay(
                              fontWeight: FontWeight.w400,
                                fontSize: 20, color: Colors.black),
                          ),
                          InkWell(
                            onTap: () {
                               
                              setState(() {
                                stringValue="";
                                searchController.text="";
                              });

                               controller.getlenderData(context,"1",stringValue,1);

                              controller. multiSelectedLenders.clear();
                              controller.forseUpdate();
  
                               
                            },
                            child:  Text(
                              "Clear",
                              style:  GoogleFonts.lexendDeca(fontSize: 16,fontWeight: FontWeight.w300 ,color: Colors.black),
                            ),
                          )
                        ],
                      ),
                    ),


                      Container(
                        padding: const EdgeInsets.only(left: 20,right: 20),
                        margin: const EdgeInsets.only(left: 20,right: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: const [BoxShadow(color: Color.fromARGB(255, 209, 209, 209),blurRadius: 1)],
                        
                        ),
                        child: TextFormField(
                          controller: searchController,
                          onChanged: (value) async {
                            startTimer() {
                              checkTypingTimer = Timer(
                                  const Duration(milliseconds: 600), () async {
                                setState(() {
                                  stringValue = value;
                                  // pageno = 1;
                                });
                      
                               await controller.getlenderData(context,"1",stringValue,1);

                                    FocusManager.instance.primaryFocus?.unfocus();

                                     try {
                                  for (int i = 0;
                                      i < controller.lendersList.length;
                                      i++) {
                                    if (controller.multiSelectedLenders.any(
                                        (element) =>
                                            element["username"]
                                                .toString()
                                                .toLowerCase() ==
                                            controller.lendersList[i]["username"]
                                                .toString()
                                                .toLowerCase())) {
                                      setState(() {
                                        controller.lendersList[i]["check"] =
                                            true;
                                        controller.forseUpdate();
                                      });
                                    }
                                  }
                                } catch (e) {
                                  print(e.toString());
                                }
                      
                                   
                      
                                
                              });
                            }
                      
                            checkTypingTimer?.cancel();
                            startTimer();
                          },
                          style:  GoogleFonts.lexendDeca(

                                fontSize: 14,
                                color: Colors.black


                              ),

                          decoration:
                               InputDecoration(border: InputBorder.none,
                               hintText: "Search...",
                              
                              hintStyle: GoogleFonts.lexendDeca(

                                fontSize: 14,
                                color: Colors.grey


                              )
                              ),
                        ),
                      ),
                    

                  

                    // body =========================================

                    // selected brands text heading
                    Visibility(
                      visible: controller. multiSelectedLenders.isEmpty ? false : true,
                      child: Container(
                        margin: const EdgeInsets.only(left: 30, bottom: 10,top: 20),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "SELECTED LENDERS",
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
                          itemCount: controller. multiSelectedLenders.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                               int found = controller.lendersList
                                      .indexWhere((item) =>
                                          item["username"] ==
                                          (controller.multiSelectedLenders[index]
                                                  ["username"]
                                              .toString()));

                                  controller.multiSelectedLenders.removeAt(index);

                                  if (controller.lendersList
                                      .asMap()
                                      .containsKey(found)) {
                                    controller.lendersList[found]["check"] =
                                        false;
                                  }

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
                                          controller. multiSelectedLenders[index]["username"],
                                          overflow: TextOverflow.ellipsis,
                                          style:   GoogleFonts.lexendDeca(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.white,
                                          ),
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

                    Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 15, right: 15),
                          child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.all(0),
                              shrinkWrap: true,
                              itemCount:  controller.lendersList.length,
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
                                      controller. lendersList[index]["username"],
                                      style:  GoogleFonts.lexendDeca(
                                        fontSize: 12.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w300
                                      ),
                                    ),
                                    value: controller. lendersList[index]["check"],
                                    onChanged: (value) {
                                     setState(() {
                                          controller.lendersList[index]
                                              ["check"] = value;

                                          if (controller.multiSelectedLenders.any(
                                              (element) =>
                                                  element["username"]
                                                      .toString()
                                                      .toLowerCase() ==
                                                  controller.lendersList[index]
                                                          ["username"]
                                                      .toString()
                                                      .toLowerCase())) {
                                            setState(() {
                                              int foundindex = controller
                                                  .multiSelectedLenders
                                                  .indexWhere((element) =>
                                                      element["username"]
                                                          .toString()
                                                          .toLowerCase() ==
                                                      controller
                                                          .lendersList[index]
                                                              ["username"]
                                                          .toString()
                                                          .toLowerCase());

                                              controller.multiSelectedLenders
                                                  .removeAt(foundindex);
                                              controller.forseUpdate();
                                            });
                                          } else {
                                            setState(() {
                                              controller.multiSelectedLenders.add(
                                                  controller.lendersList[index]);
                                              controller.forseUpdate();
                                            });
                                          }
                                        });
                                    },
                                  ),
                                );
                              }),
                        ),

                              Visibility(
                                    visible: controller.showLazyIndicator,
                                  
                                      
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
