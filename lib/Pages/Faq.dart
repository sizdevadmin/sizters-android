// ignore_for_file: use_build_context_synchronously

import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siz/Pages/Cart.dart';
import 'package:siz/Pages/Wishlist.dart';
import 'package:siz/Utils/Colors.dart';
import 'dart:convert';

import 'dart:io';

import 'package:siz/Utils/Value.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class FAQ extends StatefulWidget {
  const FAQ({super.key});

  @override
  State<FAQ> createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
  final _headerStyle =  GoogleFonts.lexendDeca(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 14);
  final _contentStyle = GoogleFonts.lexendDeca(
                          color: const Color.fromARGB(255, 73, 73, 73),
                          fontWeight: FontWeight.w300,
                          fontSize: 12);

  // get data==============================================================================================================================================

  Map<String, dynamic> getDataReposne = {};

  List<dynamic> rentalList = [];
  List<dynamic> fittingsList = [];
  List<dynamic> deliveryList = [];
  List<dynamic> rentalperiodList = [];
  List<dynamic> returnList = [];
  List<dynamic> cleaningList = [];
  List<dynamic> damagesList = [];
  List<dynamic> rentalfeesList = [];
  List<dynamic> cancellationList = [];
  List<dynamic> lenderaccountList = [];
  List<dynamic> insauranceList = [];
  List<dynamic> earningList = [];

  getFaqData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    dialodShow(context);
    try {
      final response = await http.post(Uri.parse(SizValue.getfaqs), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey),
      });

      getDataReposne = jsonDecode(response.body);

      if (getDataReposne["success"] == true) {
        setState(() {
          rentalList = getDataReposne["renter_account"];
          fittingsList = getDataReposne["fittings"];
          deliveryList = getDataReposne["delivery"];
          rentalperiodList = getDataReposne["rental_period"];
          returnList = getDataReposne["return"];
          cleaningList = getDataReposne["cleaning_process"];
          damagesList = getDataReposne["damages"];
          rentalfeesList = getDataReposne["rental_fee"];
          cancellationList = getDataReposne["cancelation"];
          lenderaccountList = getDataReposne["lender_account"];
          insauranceList = getDataReposne["insurance"];
          earningList = getDataReposne["earning_structure"];
        });

        Navigator.pop(context);
      } else if (getDataReposne["success"] == false) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(getDataReposne["error"].toString(),style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
      }
    } on ClientException {
      Navigator.pop(context);
      mysnackbar(
          "Server not responding please try again after sometime", context);
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

  @override
  void initState() {
    getFaqData();
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
      backgroundColor: const Color.fromARGB(255, 249, 249, 249),
      body: Column(
        children: [
          // top four icons ==============================================================================================

          Container(
            alignment: Alignment.center,
            height: 60,
            decoration: const BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Color.fromARGB(255, 208, 208, 208),
                  offset: Offset(0, 3),
                  blurRadius: 3)
            ]),
            padding: const EdgeInsets.only(
             
              left: 20,
              right: 20,
            ),
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
                    child:  Text(
                      "FAQ's",
                           style: SizValue.toolbarStyle
                    )),

                     const SizedBox(width: 30)
                // Wrap(
                //   alignment: WrapAlignment.center,
                //   crossAxisAlignment: WrapCrossAlignment.center,
                //   direction: Axis.horizontal,
                //   children: [
                //     InkWell(
                //         onTap: () {
                //           Navigator.push(
                //               context,
                //               MaterialPageRoute(
                //                   builder: (context) =>  Wishlist()));
                //         },
                //         child: SvgPicture.asset("assets/images/heart.svg",width: 20,height: 20,)),
                //     const SizedBox(width: 20),
                //     InkWell(
                //         onTap: () {
                //           Navigator.push(
                //               context,
                //               MaterialPageRoute(
                //                   builder: (context) => const Cart()));
                //         },
                //         child: SvgPicture.asset("assets/images/bag.svg",width: 20,height: 20,)),
                //   ],
                // )
              ],
            ),
          ),


          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [

                     //   accordation ============================================================================================================

          // renter account

          Visibility(
            visible: rentalList.isEmpty ? false : true,
            child: Container(
              margin: const EdgeInsets.only(top: 20,left: 10),
              child: Text(
                'Renter Account',
                style: GoogleFonts.dmSerifDisplay(
                          color: MyColors.themecolor,
                          fontWeight: FontWeight.w300,
                          fontSize: 18)
              ),
            ),
          ),

          Container(
              padding:  EdgeInsets.only(bottom:rentalList.isEmpty ? 0: 20),
            margin:  EdgeInsets.all(rentalList.isEmpty ? 0:10),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color:Colors.white),
            child: Accordion(
                disableScrolling: true,
                maxOpenSections: 1,
                contentBackgroundColor:
                     Colors.white,
                headerBackgroundColor:
                    Colors.white,
                scaleWhenAnimating: false,
                openAndCloseAnimation: true,
                paddingListBottom: 0,
                paddingListTop: 0,
                headerPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
                sectionClosingHapticFeedback: SectionHapticFeedback.light,
                children: rentalList
                    .map(
                      (e) => AccordionSection(
                        headerPadding: const EdgeInsets.only(
                            left: 15, right: 15, bottom: 5, top: 20),
                        contentBorderRadius: 0,
                        headerBorderRadius: 0,
                        paddingBetweenClosedSections: 0,
                        paddingBetweenOpenSections: 0,
                        rightIcon: const Icon(Icons.keyboard_arrow_down,
                            color: Colors.black, size: 20),
                        isOpen: true,
                        header: Text(e['question'].toString(),
                            style: _headerStyle),
                        content: Text(e["answer"].toString(),
                            style: _contentStyle),
                        contentHorizontalPadding: 15,
                        contentBorderWidth: 0,
                      ),
                    )
                    .toList()),
          ),


              // fittings account

          Visibility(
            visible: fittingsList.isEmpty ? false : true,
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              child: Text(
                'Fittings',
            style: GoogleFonts.dmSerifDisplay(
                          color: MyColors.themecolor,
                          fontWeight: FontWeight.w300,
                          fontSize: 18)
              ),
            ),
          ),

          Container(
              padding:  EdgeInsets.only(bottom:fittingsList.isEmpty ? 0: 20),
            margin:  EdgeInsets.all(fittingsList.isEmpty ? 0:10),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color:  Colors.white),
            child: Accordion(
                disableScrolling: true,
                maxOpenSections: 1,
                contentBackgroundColor:
                    Colors.white,
                headerBackgroundColor:
                  Colors.white,
                scaleWhenAnimating: false,
                openAndCloseAnimation: true,
                paddingListBottom: 0,
                paddingListTop: 0,
                headerPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
                sectionClosingHapticFeedback: SectionHapticFeedback.light,
                children: fittingsList
                    .map(
                      (e) => AccordionSection(
                        headerPadding: const EdgeInsets.only(
                            left: 15, right: 15, bottom: 5, top: 20),
                        contentBorderRadius: 0,
                        headerBorderRadius: 0,
                        paddingBetweenClosedSections: 0,
                        paddingBetweenOpenSections: 0,
                        rightIcon: const Icon(Icons.keyboard_arrow_down,
                            color: Colors.black, size: 20),
                        isOpen: false,
                        header: Text(e['question'].toString(),
                            style: _headerStyle),
                        content: Text(e["answer"].toString(),
                            style: _contentStyle),
                        contentHorizontalPadding: 15,
                        contentBorderWidth: 0,
                      ),
                    )
                    .toList()),
          ),



              // delivery

          Visibility(
            visible: deliveryList.isEmpty ? false : true,
            child: Container(
                margin: const EdgeInsets.only(left: 10),
              child: Text(
                'Delivery',
             style: GoogleFonts.dmSerifDisplay(
                          color: MyColors.themecolor,
                          fontWeight: FontWeight.w300,
                          fontSize: 18)
              ),
            ),
          ),

          Container(
            padding:  EdgeInsets.only(bottom:deliveryList.isEmpty ? 0: 20),
            margin:  EdgeInsets.all(deliveryList.isEmpty ? 0:10),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color:  Colors.white),
            child: Accordion(
                disableScrolling: true,
                maxOpenSections: 1,
                contentBackgroundColor:
                Colors.white,
                headerBackgroundColor:
                  Colors.white,
                scaleWhenAnimating: false,
                openAndCloseAnimation: true,
                paddingListBottom: 0,
                paddingListTop: 0,
                headerPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
                sectionClosingHapticFeedback: SectionHapticFeedback.light,
                children: deliveryList
                    .map(
                      (e) => AccordionSection(
                        headerPadding: const EdgeInsets.only(
                            left: 15, right: 15, bottom: 5, top: 20),
                        contentBorderRadius: 0,
                        headerBorderRadius: 0,
                        paddingBetweenClosedSections: 0,
                        paddingBetweenOpenSections: 0,
                        rightIcon: const Icon(Icons.keyboard_arrow_down,
                            color: Colors.black, size: 20),
                        isOpen: false,
                        header: Text(e['question'].toString(),
                            style: _headerStyle),
                        content: Text(e["answer"].toString(),
                            style: _contentStyle),
                        contentHorizontalPadding: 15,
                        contentBorderWidth: 0,
                      ),
                    )
                    .toList()),
          ),



                // rental period 

          Visibility(
            visible: rentalperiodList.isEmpty ? false : true,
            child: Container(
                margin: const EdgeInsets.only(left: 10),
              child: Text(
                'Rental period',
                 style: GoogleFonts.dmSerifDisplay(
                          color: MyColors.themecolor,
                          fontWeight: FontWeight.w300,
                          fontSize: 18)
              ),
            ),
          ),

          Container(
            padding:  EdgeInsets.only(bottom:rentalperiodList.isEmpty ? 0: 20),
            margin:  EdgeInsets.all(rentalperiodList.isEmpty ? 0:10),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color:  Colors.white,),
            child: Accordion(
                disableScrolling: true,
                maxOpenSections: 1,
                contentBackgroundColor:
                     Colors.white,
                headerBackgroundColor:
                     Colors.white,
                scaleWhenAnimating: false,
                openAndCloseAnimation: true,
                paddingListBottom: 0,
                paddingListTop: 0,
                headerPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
                sectionClosingHapticFeedback: SectionHapticFeedback.light,
                children: rentalperiodList
                    .map(
                      (e) => AccordionSection(
                        headerPadding: const EdgeInsets.only(
                            left: 15, right: 15, bottom: 5, top: 20),
                        contentBorderRadius: 0,
                        headerBorderRadius: 0,
                        paddingBetweenClosedSections: 0,
                        paddingBetweenOpenSections: 0,
                        rightIcon: const Icon(Icons.keyboard_arrow_down,
                            color: Colors.black, size: 20),
                        isOpen: false,
                        header: Text(e['question'].toString(),
                            style: _headerStyle),
                        content: Text(e["answer"].toString(),
                            style: _contentStyle),
                        contentHorizontalPadding: 15,
                        contentBorderWidth: 0,
                      ),
                    )
                    .toList()),
          ),


                // return 

          Visibility(
            visible: returnList.isEmpty ? false : true,
            child: Container(
                margin: const EdgeInsets.only(left: 10),
              child: Text(
                'Return',
                style: GoogleFonts.dmSerifDisplay(
                          color: MyColors.themecolor,
                          fontWeight: FontWeight.w300,
                          fontSize: 18)
              ),
            ),
          ),

          Container(
            padding:  EdgeInsets.only(bottom:returnList.isEmpty ? 0: 20),
            margin:  EdgeInsets.all(returnList.isEmpty ? 0:10),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color:  Colors.white,),
            child: Accordion(
                disableScrolling: true,
                maxOpenSections: 1,
                contentBackgroundColor:
                 Colors.white,
                headerBackgroundColor:
                    Colors.white,
                scaleWhenAnimating: false,
                openAndCloseAnimation: true,
                paddingListBottom: 0,
                paddingListTop: 0,
                headerPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
                sectionClosingHapticFeedback: SectionHapticFeedback.light,
                children: returnList
                    .map(
                      (e) => AccordionSection(
                        headerPadding: const EdgeInsets.only(
                            left: 15, right: 15, bottom: 5, top: 20),
                        contentBorderRadius: 0,
                        headerBorderRadius: 0,
                        paddingBetweenClosedSections: 0,
                        paddingBetweenOpenSections: 0,
                        rightIcon: const Icon(Icons.keyboard_arrow_down,
                            color: Colors.black, size: 20),
                        isOpen: false,
                        header: Text(e['question'].toString(),
                            style: _headerStyle),
                        content: Text(e["answer"].toString(),
                            style: _contentStyle),
                        contentHorizontalPadding: 15,
                        contentBorderWidth: 0,
                      ),
                    )
                    .toList()),
          ),



                 // cleaning process 

          Visibility(
            visible: cleaningList.isEmpty ? false : true,
            child: Container(
                margin: const EdgeInsets.only(left: 10),
              child: Text(
                'Our cleaning process',
              style: GoogleFonts.dmSerifDisplay(
                          color: MyColors.themecolor,
                          fontWeight: FontWeight.w300,
                          fontSize: 18)
              ),
            ),
          ),

          Container(
            padding:  EdgeInsets.only(bottom:cleaningList.isEmpty ? 0: 20),
            margin:  EdgeInsets.all(cleaningList.isEmpty ? 0:10),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color:  Colors.white,),
            child: Accordion(
                disableScrolling: true,
                maxOpenSections: 1,
                contentBackgroundColor:
                    Colors.white,
                headerBackgroundColor:
                   Colors.white,
                scaleWhenAnimating: false,
                openAndCloseAnimation: true,
                paddingListBottom: 0,
                paddingListTop: 0,
                headerPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
                sectionClosingHapticFeedback: SectionHapticFeedback.light,
                children: cleaningList
                    .map(
                      (e) => AccordionSection(
                        headerPadding: const EdgeInsets.only(
                            left: 15, right: 15, bottom: 5, top: 20),
                        contentBorderRadius: 0,
                        headerBorderRadius: 0,
                        paddingBetweenClosedSections: 0,
                        paddingBetweenOpenSections: 0,
                        rightIcon: const Icon(Icons.keyboard_arrow_down,
                            color: Colors.black, size: 20),
                        isOpen: false,
                        header: Text(e['question'].toString(),
                            style: _headerStyle),
                        content: Text(e["answer"].toString(),
                            style: _contentStyle),
                        contentHorizontalPadding: 15,
                        contentBorderWidth: 0,
                      ),
                    )
                    .toList()),
          ),


                 // damage  

          Visibility(
            visible: damagesList.isEmpty ? false : true,
            child: Container(
                margin: const EdgeInsets.only(left: 10),
              child: Text(
                'Damages',
                 style: GoogleFonts.dmSerifDisplay(
                          color: MyColors.themecolor,
                          fontWeight: FontWeight.w300,
                          fontSize: 18)
              ),
            ),
          ),

          Container(
            padding:  EdgeInsets.only(bottom:damagesList.isEmpty ? 0: 20),
            margin:  EdgeInsets.all(damagesList.isEmpty ? 0:10),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color:  Colors.white,),
            child: Accordion(
                disableScrolling: true,
                maxOpenSections: 1,
                contentBackgroundColor:
                    Colors.white,
                headerBackgroundColor:
                Colors.white,
                scaleWhenAnimating: false,
                openAndCloseAnimation: true,
                paddingListBottom: 0,
                paddingListTop: 0,
                headerPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
                sectionClosingHapticFeedback: SectionHapticFeedback.light,
                children: damagesList
                    .map(
                      (e) => AccordionSection(
                        headerPadding: const EdgeInsets.only(
                            left: 15, right: 15, bottom: 5, top: 20),
                        contentBorderRadius: 0,
                        headerBorderRadius: 0,
                        paddingBetweenClosedSections: 0,
                        paddingBetweenOpenSections: 0,
                        rightIcon: const Icon(Icons.keyboard_arrow_down,
                            color: Colors.black, size: 20),
                        isOpen: false,
                        header: Text(e['question'].toString(),
                            style: _headerStyle),
                        content: Text(e["answer"].toString(),
                            style: _contentStyle),
                        contentHorizontalPadding: 15,
                        contentBorderWidth: 0,
                      ),
                    )
                    .toList()),
          ),


                  // rental fees  

          Visibility(
            visible: rentalfeesList.isEmpty ? false : true,
            child: Container(
                margin: const EdgeInsets.only(left: 10),
              child: Text(
                'Rental Fee',
                style: GoogleFonts.dmSerifDisplay(
                          color: MyColors.themecolor,
                          fontWeight: FontWeight.w300,
                          fontSize: 18)
              ),
            ),
          ),

          Container(
            padding:  EdgeInsets.only(bottom:rentalfeesList.isEmpty ? 0: 20),
            margin:  EdgeInsets.all(rentalfeesList.isEmpty ? 0:10),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color:  Colors.white,),
            child: Accordion(
                disableScrolling: true,
                maxOpenSections: 1,
                contentBackgroundColor:
                    Colors.white,
                headerBackgroundColor:
                   Colors.white,
                scaleWhenAnimating: false,
                openAndCloseAnimation: true,
                paddingListBottom: 0,
                paddingListTop: 0,
                headerPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
                sectionClosingHapticFeedback: SectionHapticFeedback.light,
                children: rentalfeesList
                    .map(
                      (e) => AccordionSection(
                        headerPadding: const EdgeInsets.only(
                            left: 15, right: 15, bottom: 5, top: 20),
                        contentBorderRadius: 0,
                        headerBorderRadius: 0,
                        paddingBetweenClosedSections: 0,
                        paddingBetweenOpenSections: 0,
                        rightIcon: const Icon(Icons.keyboard_arrow_down,
                            color: Colors.black, size: 20),
                        isOpen: false,
                        header: Text(e['question'].toString(),
                            style: _headerStyle),
                        content: Text(e["answer"].toString(),
                            style: _contentStyle),
                        contentHorizontalPadding: 15,
                        contentBorderWidth: 0,
                      ),
                    )
                    .toList()),
          ),


               // Cancellation fees  

          Visibility(
            visible: cancellationList.isEmpty ? false : true,
            child: Container(
                margin: const EdgeInsets.only(left: 10),
              child: Text(
                'Cancelation',
               style: GoogleFonts.dmSerifDisplay(
                          color: MyColors.themecolor,
                          fontWeight: FontWeight.w300,
                          fontSize: 18)
              ),
            ),
          ),

          Container(
            padding:  EdgeInsets.only(bottom:cancellationList.isEmpty ? 0: 20),
            margin:  EdgeInsets.all(cancellationList.isEmpty ? 0:10),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color:  Colors.white,),
            child: Accordion(
                disableScrolling: true,
                maxOpenSections: 1,
                contentBackgroundColor:
               Colors.white,
                headerBackgroundColor:
                 Colors.white,
                scaleWhenAnimating: false,
                openAndCloseAnimation: true,
                paddingListBottom: 0,
                paddingListTop: 0,
                headerPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
                sectionClosingHapticFeedback: SectionHapticFeedback.light,
                children: cancellationList
                    .map(
                      (e) => AccordionSection(
                        headerPadding: const EdgeInsets.only(
                            left: 15, right: 15, bottom: 5, top: 20),
                        contentBorderRadius: 0,
                        headerBorderRadius: 0,
                        paddingBetweenClosedSections: 0,
                        paddingBetweenOpenSections: 0,
                        rightIcon: const Icon(Icons.keyboard_arrow_down,
                            color: Colors.black, size: 20),
                        isOpen: false,
                        header: Text(e['question'].toString(),
                            style: _headerStyle),
                        content: Text(e["answer"].toString(),
                            style: _contentStyle),
                        contentHorizontalPadding: 15,
                        contentBorderWidth: 0,
                      ),
                    )
                    .toList()),
          ),


                // Lender Account  

          Visibility(
            visible: lenderaccountList.isEmpty ? false : true,
            child: Container(
                margin: const EdgeInsets.only(left: 10),
              child: Text(
                'Lender Account',
                style: GoogleFonts.dmSerifDisplay(
                          color: MyColors.themecolor,
                          fontWeight: FontWeight.w300,
                          fontSize: 18)
              ),
            ),
          ),

          Container(
            padding:  EdgeInsets.only(bottom:lenderaccountList.isEmpty ? 0: 20),
            margin:  EdgeInsets.all(lenderaccountList.isEmpty ? 0:10),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.white,),
            child: Accordion(
                disableScrolling: true,
                maxOpenSections: 1,
                contentBackgroundColor:
                    Colors.white,
                headerBackgroundColor:
                 Colors.white,
                scaleWhenAnimating: false,
                openAndCloseAnimation: true,
                paddingListBottom: 0,
                paddingListTop: 0,
                headerPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
                sectionClosingHapticFeedback: SectionHapticFeedback.light,
                children: lenderaccountList
                    .map(
                      (e) => AccordionSection(
                        headerPadding: const EdgeInsets.only(
                            left: 15, right: 15, bottom: 5, top: 20),
                        contentBorderRadius: 0,
                        headerBorderRadius: 0,
                        paddingBetweenClosedSections: 0,
                        paddingBetweenOpenSections: 0,
                        rightIcon: const Icon(Icons.keyboard_arrow_down,
                            color: Colors.black, size: 20),
                        isOpen: false,
                        header: Text(e['question'].toString(),
                            style: _headerStyle),
                        content: Text(e["answer"].toString(),
                            style: _contentStyle),
                        contentHorizontalPadding: 15,
                        contentBorderWidth: 0,
                      ),
                    )
                    .toList()),
          ),


            // Cancellation fees  

          Visibility(
            visible: cancellationList.isEmpty ? false : true,
            child: Container(
                margin: const EdgeInsets.only(left: 10),
              child: Text(
                'Cancelation',
                  style: GoogleFonts.dmSerifDisplay(
                          color: MyColors.themecolor,
                          fontWeight: FontWeight.w300,
                          fontSize: 18)
              ),
            ),
          ),

          Container(
            padding:  EdgeInsets.only(bottom:cancellationList.isEmpty ? 0: 20),
            margin:  EdgeInsets.all(cancellationList.isEmpty ? 0:10),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color:  Colors.white,),
            child: Accordion(
                disableScrolling: true,
                maxOpenSections: 1,
                contentBackgroundColor:
           Colors.white,
                headerBackgroundColor:
                Colors.white,
                scaleWhenAnimating: false,
                openAndCloseAnimation: true,
                paddingListBottom: 0,
                paddingListTop: 0,
                headerPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
                sectionClosingHapticFeedback: SectionHapticFeedback.light,
                children: cancellationList
                    .map(
                      (e) => AccordionSection(
                        headerPadding: const EdgeInsets.only(
                            left: 15, right: 15, bottom: 5, top: 20),
                        contentBorderRadius: 0,
                        headerBorderRadius: 0,
                        paddingBetweenClosedSections: 0,
                        paddingBetweenOpenSections: 0,
                        rightIcon: const Icon(Icons.keyboard_arrow_down,
                            color: Colors.black, size: 20),
                        isOpen: false,
                        header: Text(e['question'].toString(),
                            style: _headerStyle),
                        content: Text(e["answer"].toString(),
                            style: _contentStyle),
                        contentHorizontalPadding: 15,
                        contentBorderWidth: 0,
                      ),
                    )
                    .toList()),
          ),


                // Insaurance  

          Visibility(
            visible: insauranceList.isEmpty ? false : true,
            child: Container(
                margin: const EdgeInsets.only(left: 10),
              child: Text(
                'Insurance',
                style: GoogleFonts.dmSerifDisplay(
                          color: MyColors.themecolor,
                          fontWeight: FontWeight.w300,
                          fontSize: 18)
              ),
            ),
          ),

          Container(
            padding:  EdgeInsets.only(bottom:insauranceList.isEmpty ? 0: 20),
            margin:  EdgeInsets.all(insauranceList.isEmpty ? 0:10),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.white,),
            child: Accordion(
                disableScrolling: true,
                maxOpenSections: 1,
                contentBackgroundColor:
                Colors.white,
                headerBackgroundColor:
                   Colors.white,
                scaleWhenAnimating: false,
                openAndCloseAnimation: true,
                paddingListBottom: 0,
                paddingListTop: 0,
                headerPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
                sectionClosingHapticFeedback: SectionHapticFeedback.light,
                children: insauranceList
                    .map(
                      (e) => AccordionSection(
                        headerPadding: const EdgeInsets.only(
                            left: 15, right: 15, bottom: 5, top: 20),
                        contentBorderRadius: 0,
                        headerBorderRadius: 0,
                        paddingBetweenClosedSections: 0,
                        paddingBetweenOpenSections: 0,
                        rightIcon: const Icon(Icons.keyboard_arrow_down,
                            color: Colors.black, size: 20),
                        isOpen: false,
                        header: Text(e['question'].toString(),
                            style: _headerStyle),
                        content: Text(e["answer"].toString(),
                            style: _contentStyle),
                        contentHorizontalPadding: 15,
                        contentBorderWidth: 0,
                      ),
                    )
                    .toList()),
          ),


                // Earning Structure  

          Visibility(
            visible: earningList.isEmpty ? false : true,
            child: Container(
                margin: const EdgeInsets.only(left: 10),
              child: Text(
                'Earning Structure',
                style: GoogleFonts.dmSerifDisplay(
                          color: MyColors.themecolor,
                          fontWeight: FontWeight.w300,
                          fontSize: 18)
              ),
            ),
          ),

          Container(
            padding:  EdgeInsets.only(bottom:earningList.isEmpty ? 0: 20),
            margin:  EdgeInsets.all(earningList.isEmpty ? 0:10),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color:  Colors.white,),
            child: Accordion(
                disableScrolling: true,
                maxOpenSections: 1,
                contentBackgroundColor:
                 Colors.white,
                headerBackgroundColor:
                 Colors.white,
                scaleWhenAnimating: false,
                openAndCloseAnimation: true,
                paddingListBottom: 0,
                paddingListTop: 0,
                headerPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
                sectionClosingHapticFeedback: SectionHapticFeedback.light,
                children: earningList
                    .map(
                      (e) => AccordionSection(
                        headerPadding: const EdgeInsets.only(
                            left: 15, right: 15, bottom: 5, top: 20),
                        contentBorderRadius: 0,
                        headerBorderRadius: 0,
                        paddingBetweenClosedSections: 0,
                        paddingBetweenOpenSections: 0,
                        rightIcon: const Icon(Icons.keyboard_arrow_down,
                            color: Colors.black, size: 20),
                        isOpen: false,
                        header: Text(e['question'].toString(),
                            style: _headerStyle),
                        content: Text(e["answer"].toString(),
                            style: _contentStyle),
                        contentHorizontalPadding: 15,
                        contentBorderWidth: 0,
                      ),
                    )
                    .toList()),
          ),
                
              ],
            ),
          )

       
        ],
      ),
    );
  }
}
