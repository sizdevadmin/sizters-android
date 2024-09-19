// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:info_popup/info_popup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siz/AddItemsPages/AddressSelect.dart';
import 'package:siz/Controllers/BottomNavController.dart';
import 'package:siz/LoginSignUp/AccuntCreate.dart';
import 'package:siz/LoginSignUp/BasicLoginInfo.dart';
import 'package:siz/LoginSignUp/LoginPage.dart';
import 'package:siz/Pages/Home.dart';
import 'package:siz/Utils/Colors.dart';
import 'package:siz/Utils/ListingController.dart';
import 'package:siz/Utils/Value.dart';

import 'dart:convert';

import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class EarnEstimate extends StatefulWidget {
  String rentalIButton = "";
  String yourEarningIButton = "";
  EarnEstimate(
      {super.key,
      required this.rentalIButton,
      required this.yourEarningIButton});

  @override
  State<EarnEstimate> createState() => _EarnEstimateState();
}

class _EarnEstimateState extends State<EarnEstimate> {
  bool dryCleaning = false;

  int originalPrice = 0;
  int percentageEarn = 0;

  int baseedit = 0;

  ListingController controller = Get.put(ListingController());

  String earning3Days = "";
  String earning8Days = "";
  String earning20Days = "";

  TextEditingController rental3daysController = TextEditingController();
  TextEditingController rental8daysController = TextEditingController();
  TextEditingController rental20daysController = TextEditingController();

  bool show3daysWarning = false;
  bool show8daysWarning = false;
  bool show20daysWarning = false;

  Timer? checkTypingTimer;

  Map<String, dynamic> calulateReponse = {};

  calculateEarning(String rentalPrice) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      final response =
          await http.post(Uri.parse(SizValue.calculateEarning), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey).toString(),
        "retail_price": rentalPrice,
        'type': "1",
      });

      calulateReponse = jsonDecode(response.body);

      if (calulateReponse["success"] == true) {
        setState(() {
          rental3daysController.text = calulateReponse["day_3_base"].toString();
          rental8daysController.text = calulateReponse["day_8_base"].toString();
          rental20daysController.text =
              calulateReponse["day_20_base"].toString();

          earning3Days = calulateReponse["earn_3_days"].toString();
          earning8Days = calulateReponse["earn_8_days"].toString();
          earning20Days = calulateReponse["earn_20_days"].toString();

          baseedit = int.parse(calulateReponse["base_edit"].toString());
          percentageEarn = int.parse(calulateReponse["earn_per"].toString());

          if (rental3daysController.text.isNotEmpty &&
              rental8daysController.text.isNotEmpty &&
              rental8daysController.text.isNotEmpty) {
            if (int.parse(rental8daysController.text) <=
                int.parse(rental3daysController.text)) {
              setState(() {
                show8daysWarning = true;
              });
            } else {
              setState(() {
                show8daysWarning = false;
              });
            }

            if (int.parse(rental20daysController.text) <=
                    int.parse(rental8daysController.text) ||
                int.parse(rental20daysController.text) <=
                    int.parse(rental3daysController.text)) {
              setState(() {
                show20daysWarning = true;
              });
            } else {
              setState(() {
                show20daysWarning = false;
              });
            }
          } else {
            setState(() {
              show8daysWarning = false;
              show20daysWarning = false;
            });
          }
        });
      } else if (calulateReponse["success"] == false) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(calulateReponse["error"].toString(),
                style: GoogleFonts.lexendDeca(
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                    color: Colors.white))));
      }
    } on ClientException {
      mysnackbar(
          "Server not responding please try again after sometimev fg", context);
    } on SocketException {
      mysnackbar(
          "No Internet connection 😑 please try again after sometime", context);
    } on HttpException {
      mysnackbar("Something went wrong please try after sometime", context);
    } on FormatException {
      mysnackbar("Something went wrong please try after sometime", context);
    }
  }

  // snackbar ==================================================================================================

  mysnackbar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 1),
        content: Text(message,
            style: GoogleFonts.lexendDeca(
                fontSize: 13,
                fontWeight: FontWeight.w300,
                color: Colors.white))));
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
            alignment: Alignment.center,
            height: 60,
            decoration: const BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Color.fromARGB(255, 228, 228, 228),
                  blurRadius: 2,
                  offset: Offset(0, 2))
            ]),
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(
                      "assets/images/backarrow.svg",
                      width: 20,
                      height: 20,
                    )),
                Image.asset(
                  "assets/images/appiconpng.png",
                  height: 40,
                  width: 40,
                ),
                const SizedBox(width: 30, height: 0)
              ],
            ),
          ),
          // Body ==========================================================================================

          Container(
              margin: const EdgeInsets.only(left: 10, right: 10, top: 30),
              child: Text(
                "Lets find out how much you could earn!",
                style: GoogleFonts.dmSerifDisplay(
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    fontSize: 20),
              )),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // textformfield 1 ======================================================================

                Container(
                  margin: const EdgeInsets.only(
                      left: 10, right: 10, top: 15, bottom: 15),
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(splashColor: Colors.transparent),
                    child: TextFormField(
                      style: GoogleFonts.lexendExa(
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                        fontSize: 12,
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          if (value.isNotEmpty) {
                            originalPrice = int.parse(value);
                          } else {
                            originalPrice = 0;
                          }

                          if (originalPrice < 500) {
                            rental3daysController.text = "";
                            rental8daysController.text = "";
                            rental20daysController.text = "";

                            earning3Days = "";
                            earning8Days = "";
                            earning20Days = "";
                          }
                        });

                        startTimer() {
                          checkTypingTimer =
                              Timer(const Duration(milliseconds: 600), () {
                            // call api

                            calculateEarning(originalPrice.toString());
                          });
                        }

                        checkTypingTimer?.cancel();

                        if (originalPrice < 500) {
                        } else {
                          startTimer();
                        }
                      },
                      decoration: InputDecoration(
                        hintText:
                            "Please provide a retail price of this item...",
                        hintStyle: GoogleFonts.lexendDeca(
                            fontSize: 12, fontWeight: FontWeight.w300),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 211, 211, 211),
                              width: 1),
                          borderRadius: BorderRadius.circular(5.5),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 211, 211, 211),
                              width: 1),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "ORIGINAL RETAIL PRICE OR MARKET VALUE",
                        labelStyle: GoogleFonts.lexendExa(
                          fontWeight: FontWeight.w300,
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),

                // rental fees
                Container(
                  margin: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        direction: Axis.horizontal,
                        children: [
                          Text(
                            "Rental Fees",
                            style: GoogleFonts.dmSerifDisplay(
                                fontWeight: FontWeight.w400,
                                fontSize: 20,
                                color: Colors.black),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            child: InfoPopupWidget(
                              contentTitle: widget.rentalIButton,
                              contentTheme: InfoPopupContentTheme(
                                  infoTextStyle: GoogleFonts.lexendDeca(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300)),
                              child: const Icon(
                                Icons.info_outline,
                                color: Colors.black,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        direction: Axis.horizontal,
                        children: [
                          Text(
                            "Your earnings",
                            style: GoogleFonts.dmSerifDisplay(
                                fontWeight: FontWeight.w400,
                                fontSize: 20,
                                color: Colors.black),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            child: InfoPopupWidget(
                              contentTitle: widget.yourEarningIButton,
                              contentTheme: InfoPopupContentTheme(
                                  infoTextStyle: GoogleFonts.lexendDeca(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300)),
                              child: const Icon(
                                Icons.info_outline,
                                color: Colors.black,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // textformfeild two ===================================================================

                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin:
                            const EdgeInsets.only(left: 10, right: 10, top: 15),
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(splashColor: Colors.transparent),
                          child: TextFormField(
                            readOnly: baseedit == 1 ? false : true,
                            controller: rental3daysController,
                            keyboardType: TextInputType.number,
                            style: GoogleFonts.lexendExa(
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                              fontSize: 12,
                            ),
                            onTapOutside: (event) {
                              FocusScope.of(context).unfocus();
                            },
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                setState(() {
                                  earning3Days = ((percentageEarn / 100 ) *
                                          int.parse(rental3daysController.text))
                                      .toStringAsFixed(2);
                                      
                                });
                              } else {
                                setState(() {
                                  earning3Days = "";
                                });
                              }

                              // compare prices on 3 8 and 20 days rentals ===

                              if (rental3daysController.text.isNotEmpty &&
                                  rental8daysController.text.isNotEmpty &&
                                  rental8daysController.text.isNotEmpty) {
                                if (int.parse(rental8daysController.text) <=
                                    int.parse(rental3daysController.text)) {
                                  setState(() {
                                    show8daysWarning = true;
                                  });
                                } else {
                                  setState(() {
                                    show8daysWarning = false;
                                  });
                                }

                                if (int.parse(rental20daysController.text) <=
                                        int.parse(rental8daysController.text) ||
                                    int.parse(rental20daysController.text) <=
                                        int.parse(rental3daysController.text)) {
                                  setState(() {
                                    show20daysWarning = true;
                                  });
                                } else {
                                  setState(() {
                                    show20daysWarning = false;
                                  });
                                }
                              } else {
                                setState(() {
                                  show8daysWarning = false;
                                  show20daysWarning = false;
                                });
                              }
                            },
                            decoration: InputDecoration(
                                hintText: "Override",
                                hintStyle: GoogleFonts.lexendDeca(
                                    fontSize: 12, fontWeight: FontWeight.w300),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 211, 211, 211),
                                      width: 1),
                                  borderRadius: BorderRadius.circular(5.5),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 211, 211, 211),
                                      width: 1),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                labelText: "3 DAYS",
                                labelStyle: GoogleFonts.lexendExa(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.grey,
                                  fontSize: 12,
                                )),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(left: 15, top: 10),
                        child: Text(
                          earning3Days.isEmpty ? "" : "AED $earning3Days",
                          style: GoogleFonts.lexendDeca(
                              color: MyColors.themecolor,
                              fontSize: 16,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),
                  ],
                ),

                // textformfeild three ===================================================================

                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin:
                            const EdgeInsets.only(left: 10, right: 10, top: 15),
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(splashColor: Colors.transparent),
                          child: TextFormField(
                            readOnly: baseedit == 1 ? false : true,
                            controller: rental8daysController,
                            keyboardType: TextInputType.number,
                            style: GoogleFonts.lexendExa(
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                              fontSize: 12,
                            ),
                            onTapOutside: (event) {
                              FocusScope.of(context).unfocus();
                            },
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                setState(() {
                                  earning8Days = ((percentageEarn / 100) *
                                          int.parse(rental8daysController.text))
                                      .toStringAsFixed(2);
                                     
                                });
                              } else {
                                setState(() {
                                  earning8Days = "";
                                });
                              }

                              if (rental3daysController.text.isNotEmpty &&
                                  rental8daysController.text.isNotEmpty &&
                                  rental8daysController.text.isNotEmpty) {
                                if (int.parse(rental8daysController.text) <=
                                    int.parse(rental3daysController.text)) {
                                  setState(() {
                                    show8daysWarning = true;
                                  });
                                } else {
                                  setState(() {
                                    show8daysWarning = false;
                                  });
                                }

                                if (int.parse(rental20daysController.text) <=
                                        int.parse(rental8daysController.text) ||
                                    int.parse(rental20daysController.text) <=
                                        int.parse(rental3daysController.text)) {
                                  setState(() {
                                    show20daysWarning = true;
                                  });
                                } else {
                                  setState(() {
                                    show20daysWarning = false;
                                  });
                                }
                              } else {
                                setState(() {
                                  show8daysWarning = false;
                                  show20daysWarning = false;
                                });
                              }
                            },
                            decoration: InputDecoration(
                                hintText: "Override",
                                hintStyle: GoogleFonts.lexendDeca(
                                    fontSize: 12, fontWeight: FontWeight.w300),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 211, 211, 211),
                                      width: 1),
                                  borderRadius: BorderRadius.circular(5.5),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 211, 211, 211),
                                      width: 1),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                labelText: "8 DAYS",
                                labelStyle: GoogleFonts.lexendExa(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.grey,
                                  fontSize: 12,
                                )),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(left: 15, top: 10),
                        child: Text(
                          earning8Days.isEmpty ? "" : "AED $earning8Days",
                          style: GoogleFonts.lexendDeca(
                              color: MyColors.themecolor,
                              fontSize: 16,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),
                  ],
                ),

                Visibility(
                  visible: show8daysWarning,
                  child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: const Text(
                      "8 days rental fees cannot be less than or equal to 3 days rental fees",
                      style: TextStyle(color: Colors.red, fontSize: 8),
                    ),
                  ),
                ),

                // textformfeild four ===================================================================

                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin:
                            const EdgeInsets.only(left: 10, right: 10, top: 15),
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(splashColor: Colors.transparent),
                          child: TextFormField(
                            style: GoogleFonts.lexendExa(
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                              fontSize: 12,
                            ),
                            readOnly: baseedit == 1 ? false : true,
                            controller: rental20daysController,
                            onTapOutside: (event) {
                              FocusScope.of(context).unfocus();
                            },
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                setState(() {
                                  earning20Days = ((percentageEarn / 100) *
                                          int.parse(
                                              rental20daysController.text))
                                      .toStringAsFixed(2);
                                      
                                });
                              } else {
                                setState(() {
                                  earning20Days = "";
                                });
                              }

                              if (rental3daysController.text.isNotEmpty &&
                                  rental8daysController.text.isNotEmpty &&
                                  rental8daysController.text.isNotEmpty) {
                                if (int.parse(rental8daysController.text) <=
                                    int.parse(rental3daysController.text)) {
                                  setState(() {
                                    show8daysWarning = true;
                                  });
                                } else {
                                  setState(() {
                                    show8daysWarning = false;
                                  });
                                }

                                if (int.parse(rental20daysController.text) <=
                                        int.parse(rental8daysController.text) ||
                                    int.parse(rental20daysController.text) <=
                                        int.parse(rental3daysController.text)) {
                                  setState(() {
                                    show20daysWarning = true;
                                  });
                                } else {
                                  setState(() {
                                    show20daysWarning = false;
                                  });
                                }
                              } else {
                                setState(() {
                                  show8daysWarning = false;
                                  show20daysWarning = false;
                                });
                              }
                            },
                            decoration: InputDecoration(
                                hintText: "Override",
                                hintStyle: GoogleFonts.lexendDeca(
                                    fontSize: 12, fontWeight: FontWeight.w300),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 211, 211, 211),
                                      width: 1),
                                  borderRadius: BorderRadius.circular(5.5),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 211, 211, 211),
                                      width: 1),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                labelText: "20 DAYS",
                                labelStyle: GoogleFonts.lexendExa(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.grey,
                                  fontSize: 12,
                                )),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(left: 15, top: 10),
                        child: Text(
                          earning20Days.isEmpty ? "" : "AED $earning20Days",
                          style: GoogleFonts.lexendDeca(
                              color: MyColors.themecolor,
                              fontSize: 16,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),
                  ],
                ),

                Visibility(
                  visible: show20daysWarning,
                  child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: const Text(
                      "20 days rental fees cannot be less than or equal to 8 or 3 days rental fees",
                      style: TextStyle(color: Colors.red, fontSize: 8),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: (rental3daysController.text.isEmpty ||
                      rental8daysController.text.isEmpty ||
                      rental20daysController.text.isEmpty)
                  ? null
                  : show20daysWarning
                      ? null
                      : show8daysWarning
                          ? null
                          : () async {
                              if (originalPrice == 0) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("Please enter rental price"),
                                  duration: Duration(seconds: 1),
                                ));
                              } else {
                                SharedPreferences sharedPreferences =
                                    await SharedPreferences.getInstance();

                                if (sharedPreferences
                                        .getString(SizValue.isLogged)
                                        .toString() ==
                                    "null") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              LoginPage(otpNumber: "")));
                                } else if (sharedPreferences
                                        .getString(SizValue.isLogged)
                                        .toString() ==
                                    "1") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => BasicLoginInfo(
                                              fromWhere: sharedPreferences
                                                  .getString(SizValue.source)
                                                  .toString())));
                                } else if (sharedPreferences
                                        .getString(SizValue.isLogged)
                                        .toString() ==
                                    "2") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AccountCreate()));
                                } else if (sharedPreferences
                                        .getString(SizValue.underReview)
                                        .toString() ==
                                    "0") {
                                  showReviewdialog(
                                      sharedPreferences
                                          .getString(SizValue.underReviewMsg)
                                          .toString(),
                                      sharedPreferences
                                          .getString(SizValue.underReview)
                                          .toString());
                                } else if (sharedPreferences
                                        .getString(SizValue.underReview)
                                        .toString() ==
                                    "2") {
                                  showReviewdialog(
                                      sharedPreferences
                                          .getString(SizValue.rejectedReviewMSG)
                                          .toString(),
                                      sharedPreferences
                                          .getString(SizValue.underReview)
                                          .toString());
                                } else if (sharedPreferences
                                        .getString(SizValue.underReview)
                                        .toString() ==
                                    "3") {
                                  showReviewdialog(
                                      sharedPreferences
                                          .getString(SizValue.incompleteMessage)
                                          .toString(),
                                      sharedPreferences
                                          .getString(SizValue.underReview)
                                          .toString());
                                } else {
                                  controller.addValue(
                                      SizValue.price, originalPrice.toString());
                                  controller.addValue(SizValue.rental3days,
                                      rental3daysController.text);
                                  controller.addValue(SizValue.rental8days,
                                      rental8daysController.text);
                                  controller.addValue(SizValue.rental20days,
                                      rental20daysController.text);
                                  controller.addValue(
                                      SizValue.earning3days, earning3Days);
                                  controller.addValue(
                                      SizValue.earning8days, earning8Days);
                                  controller.addValue(
                                      SizValue.earning20days, earning20Days);

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AddressSelect()));
                                }
                              }
                            },
              child: Container(
                margin: const EdgeInsets.only(
                    left: 10, right: 10, bottom: 40, top: 20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: (rental3daysController.text.isEmpty ||
                            rental8daysController.text.isEmpty ||
                            rental20daysController.text.isEmpty)
                        ? Colors.grey
                        : show20daysWarning
                            ? Colors.grey
                            : show8daysWarning
                                ? Colors.grey
                                : Colors.black,
                    borderRadius: BorderRadius.circular(5)),
                width: MediaQuery.of(context).size.width,
                height: 40,
                child: Text(
                  "Next".toUpperCase(),
                  style: GoogleFonts.lexendExa(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w300),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showReviewdialog(String title, String value) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: value == "3" ? true : false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return WillPopScope(
          onWillPop: () async {
            return value == "3" ? true : false;
          },
          child: Center(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 30, right: 20),
              height: 180,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(13)),
              child: Scaffold(
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
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lexendDeca(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: Colors.black),
                        ),
                      ),
                      InkWell(
                        onTap: value == "2"
                            ? () async {
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
                                        builder: (context) => const Home()),
                                    (Route<dynamic> route) => false);
                              }
                            : value == "3"
                                ? () {
                                    Navigator.pop(context);

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AccountCreate()));
                                  }
                                : () {
                                    Navigator.pop(context);
                                  },
                        child: Container(
                          width: 240,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(top: 20),
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                              value == "2"
                                  ? "LOGOUT"
                                  : value == "3"
                                      ? "COMPLETE SIGNUP"
                                      : "OK",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lexendExa(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300)),
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
