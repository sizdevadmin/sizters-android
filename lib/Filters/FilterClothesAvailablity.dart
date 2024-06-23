import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_button/group_button.dart';
import 'package:siz/Controllers/FilterController.dart';
import 'package:siz/Pages/Cart.dart';
import 'package:siz/Pages/Wishlist.dart';
import 'package:siz/Utils/Colors.dart';

class FilterClothesAvaliblity extends StatefulWidget {
  const FilterClothesAvaliblity({super.key});

  @override
  State<FilterClothesAvaliblity> createState() =>
      _FilterClothesAvaliblityState();
}

class _FilterClothesAvaliblityState extends State<FilterClothesAvaliblity> {
  

  late GroupButtonController buttonController;
      

  

  late FilterController controller;

  @override
  void initState() {
    controller = Get.put(FilterController());
   buttonController= GroupButtonController(selectedIndex:controller.maxdate==2?0:controller.maxdate==7?1:2);
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
          // top four icon ===========================

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
            padding: const EdgeInsets.only(right: 20),
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
                      child: SvgPicture.asset("assets/images/backarrow.svg",width: 20,height: 20,),
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
                                  builder: (context) =>  Wishlist()));
                        },
                        child: SvgPicture.asset("assets/images/heart.svg",width: 20,height: 20,)),
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
                  'Availability',
                  style: GoogleFonts.dmSerifDisplay(
                    fontWeight: FontWeight.w400,
                      fontSize: 20, color: Colors.black),
                ),
                InkWell(
                  onTap: ()async {
                   
                 
                    controller.updateDate("", "");

                     controller.maxdate=2;

                    controller.startdate=DateTime.now().add(const Duration(days: 2));
                    controller.enddate=DateTime.now().add(const Duration(days: 4));

                    Navigator.pop(context);
                  },
                  child:  Text(
                    "Clear",
                    style: GoogleFonts.lexendDeca(fontSize: 16,fontWeight: FontWeight.w300 ,color: Colors.black),
                  ),
                )
              ],
            ),
          ),

          // body ====================================

          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.only(left: 15, right: 15, top: 20),
              child: GroupButton(
                controller: buttonController,
                
                onSelected: (value, index, isSelected) {
                  if (index == 0) {
                    setState(() {
                     controller. maxdate = 2;
                     controller. selectedday = value;

                    controller.startdate=DateTime.now().add(const Duration(days: 2));
                    controller.enddate=DateTime.now().add(const Duration(days: 4));
                    });
                  } else if (index == 1) {
                    setState(() {
                       controller.maxdate = 7;
                        controller.  selectedday = value;

                         controller.startdate=DateTime.now().add(const Duration(days: 2));
                    controller.enddate=DateTime.now().add(const Duration(days: 9));
                    });
                  } else if (index == 2) {
                    setState(() {
                      controller. maxdate = 19;
                          controller. selectedday = value;

                          controller.startdate=DateTime.now().add(const Duration(days: 2));
                    controller.enddate=DateTime.now().add(const Duration(days: 21));
                    });
                  } 
                },

                options:  GroupButtonOptions(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    unselectedBorderColor: Colors.black,
                    selectedColor: Colors.black,
                    buttonWidth: 81,
                    buttonHeight: 46,
                    elevation: 1,

                      selectedTextStyle: GoogleFonts.lexendExa(
                   color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w200

                  ),

                   unselectedTextStyle: GoogleFonts.lexendExa(
                   color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w200

                  ),
                    

                    
                    
                    
                    ),
                    

                isRadio: true,
                // ignore: avoid_print

                buttons: const [
                  "3 Days",
                  "8 Days",
                  "20 Days",
                 
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          color: const Color.fromARGB(255, 210, 210, 210))),
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: CalendarDatePicker2(
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
                      color: Colors.white,
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


                          
                          firstDate: DateTime.now().add(const Duration(days: 2))),
                      value: [controller.startdate,controller. enddate],
                      onValueChanged: (dates) {
                        setState(() {
                          controller.startdate = dates[0]!;
                         controller. enddate = dates[0]!.add(Duration(days: controller.maxdate));
                        });
                      }),
                ),
              ],
            ),
          ),

          InkWell(
            onTap: () {
              controller.updateDate(
                  "${controller.startdate.year}-${controller.startdate.month}-${controller.startdate.day}",
                  "${controller.enddate.year}-${controller.enddate.month}-${controller.enddate.day}");

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
}
