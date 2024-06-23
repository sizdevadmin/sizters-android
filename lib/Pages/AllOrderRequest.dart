// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siz/Pages/Cart.dart';
import 'package:siz/Pages/ProductView.dart';
import 'package:siz/Pages/Wishlist.dart';
import 'package:siz/Utils/Colors.dart';
import 'dart:io';
import 'package:siz/Utils/Value.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class AllOrderRequest extends StatefulWidget {
  const AllOrderRequest({super.key});

  @override
  State<AllOrderRequest> createState() => _AllOrderRequestState();
}

class _AllOrderRequestState extends State<AllOrderRequest> {
  bool isLoadingMoreMR = false;
  bool oncesCallMR = false;
  bool noMoreDataMR = false;
  bool showLazyIndicatorMR = false;

  // myrequests =================================================================================================

  Map<String, dynamic> myrequesttReponse = {};
  List<dynamic> decordedrequestResponse = [];

  myrequests(int pageno) async {
    if (pageno > 1) {
      setState(() {
        showLazyIndicatorMR = true;
      });
    }

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      final response = await http.post(Uri.parse(SizValue.myrequest), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey),
        'page': pageno.toString()
      });

      myrequesttReponse = jsonDecode(response.body);

      if (myrequesttReponse["success"] == true) {
        if (pageno <= 1) {
          setState(() {
            decordedrequestResponse = myrequesttReponse["list"];

            isLoadingMoreMR = false;
            oncesCallMR = false;
          });
        } else {
          setState(() {
            decordedrequestResponse.addAll(myrequesttReponse["list"]);
            isLoadingMoreMR = false;
            oncesCallMR = false;
          });
        }

        if (myrequesttReponse["list"].toString() == "[]") {
          setState(() {
            noMoreDataMR = true;
            isLoadingMoreMR = false;
            oncesCallMR = false;
          });
        }

        if (pageno > 1) {
          setState(() {
            showLazyIndicatorMR = false;
          });
        }
      } else if (myrequesttReponse["success"] == false) {
        if (pageno > 1) {
          setState(() {
            showLazyIndicatorMR = false;
          });
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(myrequesttReponse["error"].toString(),
                style: GoogleFonts.lexendDeca(
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                    color: Colors.white))));
      }
    } on ClientException {
      if (pageno > 1) {
        setState(() {
          showLazyIndicatorMR = false;
        });
      }
      mysnackbar(
          "Server not responding please try again after sometimev fg", context);
    } on SocketException {
      if (pageno > 1) {
        setState(() {
          showLazyIndicatorMR = false;
        });
      }
      mysnackbar(
          "No Internet connection 😑 please try again after sometime", context);
    } on HttpException {
      if (pageno > 1) {
        setState(() {
          showLazyIndicatorMR = false;
        });
      }
      mysnackbar("Something went wrong please try after sometime", context);
    } on FormatException {
      if (pageno > 1) {
        setState(() {
          showLazyIndicatorMR = false;
        });
      }
      mysnackbar("Something went wrong please try after sometime", context);
    }
  }

  final ScrollController _scrollControllerMR = ScrollController();
  int pagenoMR = 1;

  Future<void> scrollListenerMR() async {
    if (isLoadingMoreMR) return;

    _scrollControllerMR.addListener(() {
      if (_scrollControllerMR.offset >=
          _scrollControllerMR.position.maxScrollExtent - 200) {
        setState(() {
          isLoadingMoreMR = true;
        });

        if (!oncesCallMR) {
          if (noMoreDataMR) {
            return;
          } else {
            myrequests(++pagenoMR);

            setState(() {
              oncesCallMR = true;
            });
          }
        }
      }
    });
  }

  // request approve and rejected ====================================================================

  Map<String, dynamic> requestApproveRejectedResponse = {};

  requestApproveRejected(String id, String action, int index) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      final response =
          await http.post(Uri.parse(SizValue.requestAction), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey),
        'id': id,
        'status': action,
      });

      requestApproveRejectedResponse = jsonDecode(response.body);

      if (requestApproveRejectedResponse["success"] == true) {
        setState(() {
          decordedrequestResponse[index]["status"] =
              requestApproveRejectedResponse["status"];
        });
      } else if (requestApproveRejectedResponse["success"] == false) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(requestApproveRejectedResponse["error"].toString(),
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

  double renterRating = 0.0;
  TextEditingController renterReviewController = TextEditingController();

  @override
  void initState() {
    _scrollControllerMR.addListener(() async {
      scrollListenerMR();
    });
    myrequests(1);
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
          // top four icons ==============================================================================================

          Container(
            alignment: Alignment.center,
            height: 60,
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            decoration: const BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Color.fromARGB(255, 212, 212, 212),
                  blurRadius: 2,
                  offset: Offset(0, 3))
            ]),
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
                Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: Text("All Orders".toUpperCase(),
                        style: SizValue.toolbarStyle)),
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
                                  builder: (context) => Wishlist()));
                        },
                        child: SvgPicture.asset(
                          "assets/images/heart.svg",
                          width: 20,
                          height: 20,
                        )),
                    const SizedBox(width: 20),
                    InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Cart()));
                        },
                        child: SvgPicture.asset(
                          "assets/images/bag.svg",
                          width: 20,
                          height: 20,
                        )),
                  ],
                )
              ],
            ),
          ),

          decordedrequestResponse.isEmpty
              ? Expanded(
                  child: Center(
                    child: Text(
                      "No Requests",
                      style: GoogleFonts.lexendDeca(
                          fontWeight: FontWeight.w300,
                          color: Colors.grey,
                          fontSize: 13),
                    ),
                  ),
                )
              : Expanded(
                  child: Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: ListView.builder(
                            padding: EdgeInsets.zero,
                            controller: _scrollControllerMR,
                            physics: const ClampingScrollPhysics(),
                            itemCount: decordedrequestResponse.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.only(
                                    left: 10, right: 10, bottom: 5),
                                padding: const EdgeInsets.only(
                                    bottom: 10, left: 10, right: 10, top: 15),
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color: Color(0xffF6F5F1)),
                                child: Column(
                                  children: [
                          
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // itemscount text and product image
                                        const SizedBox(width: 10),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProductView(
                                                            index: 0,
                                                            id: decordedrequestResponse[
                                                                        index][
                                                                    "product_id"]
                                                                .toString(),
                                                            comesFrom: "",
                                                            fromCart: false)));
                                          },
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(top: 00),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    decordedrequestResponse[
                                                            index]["img_url"]
                                                        .toString(),
                                                width: 80,
                                                fit: BoxFit.cover,
                                                height: 180,
                                              ),
                                            ),
                                          ),
                                        ),

                                        const SizedBox(width: 20),

                                        // heading

                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              constraints: const BoxConstraints(
                                                  maxWidth: 100),
                                              margin: const EdgeInsets.only(
                                                  bottom: 10),
                                              child: Text(
                                                "Order No ",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.lexendDeca(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              constraints: const BoxConstraints(
                                                  maxWidth: 100),
                                              margin: const EdgeInsets.only(
                                                  bottom: 10),
                                              child: Text(
                                                "Item Name",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.lexendDeca(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              constraints: const BoxConstraints(
                                                  maxWidth: 100),
                                              margin: const EdgeInsets.only(
                                                  bottom: 10),
                                              child: Text(
                                                "Renter",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.lexendDeca(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              constraints: const BoxConstraints(
                                                  maxWidth: 100),
                                              margin: const EdgeInsets.only(
                                                  bottom: 10),
                                              child: Text(
                                                "Renter Rating",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.lexendDeca(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              constraints: const BoxConstraints(
                                                  maxWidth: 100),
                                              margin: const EdgeInsets.only(
                                                  bottom: 10),
                                              child: Text(
                                                "Rental Fees",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.lexendDeca(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              margin: const EdgeInsets.only(
                                                  bottom: 10),
                                              constraints: const BoxConstraints(
                                                  maxWidth: 100),
                                              child: Text(
                                                "Rental Duration",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.lexendDeca(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 10),
                                              alignment: Alignment.centerLeft,
                                              constraints: const BoxConstraints(
                                                  maxWidth: 100),
                                              child: Text(
                                                "Rental Start",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.lexendDeca(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              constraints: const BoxConstraints(
                                                  maxWidth: 100),
                                              child: Text(
                                                "Rental End",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.lexendDeca(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(width: 5),

                                        // values
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                constraints:
                                                    const BoxConstraints(
                                                        maxWidth: 100),
                                                margin: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: Text(
                                                    decordedrequestResponse[
                                                            index]["order_no"]
                                                        .toString(),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        GoogleFonts.lexendDeca(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            fontSize: 12)),
                                              ),
                                              // value one

                                              Container(
                                                alignment: Alignment.centerLeft,
                                                constraints:
                                                    const BoxConstraints(
                                                        maxWidth: 100),
                                                margin: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: Text(
                                                    decordedrequestResponse[
                                                            index]["title"]
                                                        .toString(),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        GoogleFonts.lexendDeca(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            fontSize: 12)),
                                              ),

                                              // value two

                                              Container(
                                                alignment: Alignment.centerLeft,
                                                constraints:
                                                    const BoxConstraints(
                                                        maxWidth: 100),
                                                margin: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: Text(
                                                    decordedrequestResponse[
                                                            index]["first_name"]
                                                        .toString(),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        GoogleFonts.lexendDeca(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            fontSize: 12)),
                                              ),

                                              Container(
                                                constraints:
                                                    const BoxConstraints(
                                                        maxWidth: 100),
                                                margin: const EdgeInsets.only(
                                                    bottom: 10),
                                                alignment: Alignment.centerLeft,
                                                child: RatingBarIndicator(
                                                  itemPadding: EdgeInsets.zero,
                                                  rating: myrequesttReponse
                                                          .isEmpty
                                                      ? 0
                                                      : double.parse(
                                                          decordedrequestResponse[
                                                                      index]
                                                                  ["rating"]
                                                              .toString()),
                                                  itemBuilder:
                                                      (context, index) =>
                                                          const Icon(
                                                    Icons.star_rate_rounded,
                                                    color: Color(0xffCAAB05),
                                                  ),
                                                  itemCount: 5,
                                                  itemSize: 15.0,
                                                  direction: Axis.horizontal,
                                                ),
                                              ),

                                              // value three

                                              Container(
                                                alignment: Alignment.centerLeft,
                                                constraints:
                                                    const BoxConstraints(
                                                        maxWidth: 100),
                                                margin: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: Text(
                                                    "AED ${decordedrequestResponse[index]["amount"]}",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        GoogleFonts.lexendDeca(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            fontSize: 12)),
                                              ),

                                              // value four

                                              Container(
                                                alignment: Alignment.centerLeft,
                                                margin: const EdgeInsets.only(
                                                    bottom: 10),
                                                constraints:
                                                    const BoxConstraints(
                                                        maxWidth: 100),
                                                child: Text(
                                                    "${decordedrequestResponse[index]["days"]} Days",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        GoogleFonts.lexendDeca(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            fontSize: 12)),
                                              ),

                                              Container(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                    "${decordedrequestResponse[index]["start_date"]}",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        GoogleFonts.lexendDeca(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            fontSize: 12)),
                                              ),

                                              const SizedBox(height: 10),

                                              Container(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                    "${decordedrequestResponse[index]["end_date"]}",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        GoogleFonts.lexendDeca(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            fontSize: 12)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 10, right: 10, bottom: 10),
                                      alignment: Alignment.centerRight,
                                      child: decordedrequestResponse[index]
                                                  ["status"] ==
                                              0
                                          ? Wrap(
                                              alignment: WrapAlignment.center,
                                              direction: Axis.horizontal,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    requestApproveRejected(
                                                        decordedrequestResponse[
                                                                index]["id"]
                                                            .toString(),
                                                        "2",
                                                        index);
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    width: 60,
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                        color:
                                                            MyColors.themecolor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    child: Text(
                                                      "REJECT".toUpperCase(),
                                                      style:
                                                          GoogleFonts.lexendExa(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                              fontSize: 9),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 3),
                                                InkWell(
                                                  onTap: () {
                                                    requestApproveRejected(
                                                        decordedrequestResponse[
                                                                index]["id"]
                                                            .toString(),
                                                        "1",
                                                        index);
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    width: 60,
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xff10AF3D),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    child: Text(
                                                      "APPROVE".toUpperCase(),
                                                      style:
                                                          GoogleFonts.lexendExa(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                              fontSize: 9),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          :

                                          //  if status == 1 means approved

                                          decordedrequestResponse[index]
                                                      ["status"] ==
                                                  1
                                              ? Container(
                                                  alignment: Alignment.center,
                                                  width: 120,
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: Text(
                                                    "APPROVED".toUpperCase(),
                                                    style:
                                                        GoogleFonts.lexendExa(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            fontSize: 9),
                                                  ),
                                                )
                                              :

                                              //  if status == 2 means rejected

                                              decordedrequestResponse[index]
                                                          ["status"] ==
                                                      2
                                                  ? Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: 120,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      decoration: BoxDecoration(
                                                          color: Colors.black,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      child: Text(
                                                        "REJECTED"
                                                            .toUpperCase(),
                                                        style: GoogleFonts
                                                            .lexendExa(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                fontSize: 9),
                                                      ),
                                                    )
                                                  :

                                                  //  if status == 4 means delivered

                                                  decordedrequestResponse[index]
                                                              ["status"] ==
                                                          3
                                                      ? Container(
                                                          alignment:
                                                              Alignment.center,
                                                          width: 120,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.black,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                          child: Text(
                                                            "In Progress"
                                                                .toUpperCase(),
                                                            style: GoogleFonts
                                                                .lexendExa(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                    fontSize:
                                                                        9),
                                                          ),
                                                        )
                                                      : decordedrequestResponse[
                                                                      index]
                                                                  ["status"] ==
                                                              4
                                                          ? Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              width: 120,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .black,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5)),
                                                              child: Text(
                                                                "In Progress"
                                                                    .toUpperCase(),
                                                                style: GoogleFonts.lexendExa(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                    fontSize:
                                                                        9),
                                                              ),
                                                            )
                                                          : decordedrequestResponse[
                                                                          index]
                                                                      [
                                                                      "status"] ==
                                                                  5
                                                              ? Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  width: 120,
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          5),
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .black,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5)),
                                                                  child: Text(
                                                                    "In Progress"
                                                                        .toUpperCase(),
                                                                    style: GoogleFonts.lexendExa(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w300,
                                                                        fontSize:
                                                                            9),
                                                                  ),
                                                                )
                                                              : decordedrequestResponse[
                                                                              index]
                                                                          [
                                                                          "status"] ==
                                                                      6
                                                                  ? Row(

                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [

                                                     
                                                               Visibility(
                                      visible: decordedrequestResponse[index]
                                                  ["status"] ==
                                              6
                                          ? true
                                          : false,
                                      child: InkWell(
                                        onTap: () {
                                          renterReviewDialog(
                                              decordedrequestResponse[index]
                                                      ["id"]
                                                  .toString(),
                                              decordedrequestResponse[index]
                                                      ["username"]
                                                  .toString(),
                                              decordedrequestResponse[index]
                                                      ["profile_img"]
                                                  .toString());
                                        },
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                        
                                        margin: const EdgeInsets.only(right: 10),
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: 120,
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Text(
                                              "REVIEW RENTER".toUpperCase(),
                                              style: GoogleFonts.lexendExa(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 9),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),


                                                                      Container(
                                                                          alignment:
                                                                              Alignment
                                                                                  .center,
                                                                          width:
                                                                              120,
                                                                          padding:
                                                                              const EdgeInsets
                                                                                  .all(
                                                                                  5),
                                                                          decoration: BoxDecoration(
                                                                              color: Colors
                                                                                  .black,
                                                                              borderRadius:
                                                                                  BorderRadius.circular(5)),
                                                                          child:
                                                                              Text(
                                                                            "Completed"
                                                                                .toUpperCase(),
                                                                            style: GoogleFonts.lexendExa(
                                                                                color:
                                                                                    Colors.white,
                                                                                fontWeight: FontWeight.w300,
                                                                                fontSize: 9),
                                                                          ),
                                                                        ),
                                                                    ],
                                                                  )
                                                                  :

                                                                  // else empty container

                                                                  Container(),
                                    )
                                  ],
                                ),
                              );
                            }),
                      ),
                      Visibility(
                        visible: showLazyIndicatorMR,
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
                )
        ],
      ),
    );
  }

  renterReviewDialog(String id, String renterUsername, String renterProfile) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return Center(
                child: Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    height: 400,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Scaffold(
                      resizeToAvoidBottomInset: false,
                      backgroundColor: Colors.transparent,
                      body: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(bottom: 10),
                            child: SizedBox(
                              width: 55,
                              height: 55,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: CachedNetworkImage(
                                    imageUrl: renterProfile,
                                    width: 55,
                                    height: 55,
                                    fit: BoxFit.cover,
                                  )),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            alignment: Alignment.center,
                            child: Text(
                              renterUsername,
                              style: GoogleFonts.lexendDeca(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 20),
                                child: Text("Rating",
                                    style: GoogleFonts.lexendDeca(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w300)),
                              ),
                              RatingBar.builder(
                                itemSize: 30,
                                initialRating: 0,
                                glow: false,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemPadding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Color(0xffCAAB05),
                                ),
                                onRatingUpdate: (rating) {
                                  setState(() {
                                    renterRating = rating;
                                  });
                                },
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            margin: const EdgeInsets.only(top: 20),
                            width: MediaQuery.of(context).size.width,
                            height: 100,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey)),
                            child: TextFormField(
                              maxLines: 10,
                              controller: renterReviewController,
                              style: GoogleFonts.lexendDeca(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText:
                                      "Leave your feedback about this Renter",
                                  hintStyle: GoogleFonts.lexendDeca(
                                      fontSize: 16,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w300)),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              sendRenterReview(id, renterRating,
                                  renterReviewController.text);
                            },
                            child: Container(
                                margin: const EdgeInsets.only(top: 20),
                                width: MediaQuery.of(context).size.width,
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text("SUBMIT REVIEW",
                                    style: GoogleFonts.lexendExa(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300))),
                          )
                        ],
                      ),
                    )),
              );
            },
          );
        });
  }

// renter review =====================================================================================

  Map<String, dynamic> renterReviewResponse = {};

  sendRenterReview(String id, double rating, String comment) async {
    showMyDialog();

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      final response =
          await http.post(Uri.parse(SizValue.addrenterReview), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey).toString(),
        'id': id,
        'rating': rating.toString(),
        'comment': comment,
      });

      renterReviewResponse = jsonDecode(response.body);

      if (renterReviewResponse["success"] == true) {
        Navigator.pop(context);

        renterReviewController.text = "";

        Flushbar(
          flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.black,
          messageText: Text("Review Submit Successfully",
              style: GoogleFonts.lexendDeca(
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                  color: Colors.white)),
          duration: const Duration(seconds: 3),
        ).show(context);
      } else if (renterReviewResponse["success"] == false) {
        renterReviewController.text = "";

        Navigator.pop(context);

        Flushbar(
          flushbarStyle: FlushbarStyle.GROUNDED,
          backgroundColor: Colors.black,
          messageText: Text(renterReviewResponse["error"].toString(),
              style: GoogleFonts.lexendDeca(
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                  color: Colors.white)),
          duration: const Duration(seconds: 3),
        ).show(context);
      }
    } on ClientException {
      Navigator.pop(context);

      Flushbar(
        flushbarStyle: FlushbarStyle.GROUNDED,
        backgroundColor: Colors.black,
        messageText: Text(
            "Server not responding please try again after sometime",
            style: GoogleFonts.lexendDeca(
                fontSize: 13,
                fontWeight: FontWeight.w300,
                color: Colors.white)),
        duration: const Duration(seconds: 3),
      ).show(context);
    } on SocketException {
      Navigator.pop(context);

      Flushbar(
        flushbarStyle: FlushbarStyle.GROUNDED,
        backgroundColor: Colors.black,
        messageText: Text(
            "No Internet connection 😑 please try again after sometime",
            style: GoogleFonts.lexendDeca(
                fontSize: 13,
                fontWeight: FontWeight.w300,
                color: Colors.white)),
        duration: const Duration(seconds: 3),
      ).show(context);
    } on HttpException {
      Navigator.pop(context);

      Flushbar(
        flushbarStyle: FlushbarStyle.GROUNDED,
        backgroundColor: Colors.black,
        messageText: Text("Something went wrong please try after sometime",
            style: GoogleFonts.lexendDeca(
                fontSize: 13,
                fontWeight: FontWeight.w300,
                color: Colors.white)),
        duration: const Duration(seconds: 3),
      ).show(context);
    } on FormatException {
      Navigator.pop(context);

      Flushbar(
        flushbarStyle: FlushbarStyle.GROUNDED,
        backgroundColor: Colors.black,
        messageText: Text("Something went wrong please try after sometime",
            style: GoogleFonts.lexendDeca(
                fontSize: 13,
                fontWeight: FontWeight.w300,
                color: Colors.white)),
        duration: const Duration(seconds: 3),
      ).show(context);
    }
  }

  showMyDialog() {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(
              color: MyColors.themecolor,
            ),
          );
        });
  }
}
