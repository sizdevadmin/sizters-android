// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siz/Controllers/BottomNavController.dart';

import 'package:siz/Controllers/ChatController.dart';
import 'package:siz/Controllers/ProfileController.dart';
import 'package:siz/LoginSignUp/AccuntCreate.dart';
import 'package:siz/LoginSignUp/BasicLoginInfo.dart';
import 'package:siz/LoginSignUp/LoginPage.dart';
import 'package:siz/Pages/ChatInside.dart';
import 'package:siz/Pages/Home.dart';
import 'package:siz/Utils/Colors.dart';
import 'package:siz/Utils/Value.dart';

class ChatNav extends StatefulWidget {
  const ChatNav({super.key});

  @override
  State<ChatNav> createState() => _ChatNavState();
}

class _ChatNavState extends State<ChatNav> {
  late BuildContext loadingDialog;
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

  dialodShow() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              loadingDialog = context;
              return const Center(
                child: CircularProgressIndicator(
                  color: MyColors.themecolor,
                ),
              );
            });
      },
    );
  }

  int pageno = 1;

  Timer? checkTypingTimer;
  TextEditingController searchController = TextEditingController();
  String stringValue = "";
  late ChatController chatController;

  final ScrollController _scrollControllerChat = ScrollController();

  @override
  void initState() {
    chatController = Get.put(ChatController());

    checkValues();

    _scrollControllerChat.addListener(() async {
      scrollChatOutside();
    });
    super.initState();
  }

  checkValues() async {
    await chatController.getProfleValue();

    if (chatController.review == "0") {
    } else if (chatController.review == "3") {
    } else if (chatController.review == "2") {
    } else if (chatController.loginStatus == "null") {
    } else if (chatController.loginStatus == "1") {
    } else if (chatController.loginStatus == "2") {
    } else {
      chatController.onConnectPressed();
      chatController.getChatListOutside(1, "");
    }
  }

  Future<void> scrollChatOutside() async {
    if (chatController.isLoadingMoreChat) return;

    _scrollControllerChat.addListener(() {
      if (_scrollControllerChat.offset >=
          _scrollControllerChat.position.maxScrollExtent - 300) {
        chatController.isLoadingMoreChat = true;
        chatController.forseUpdate();
        if (!chatController.oncesCallChat) {
          if (chatController.noMoreDataChat) {
            return;
          } else {
            chatController.getChatListOutside(++pageno, stringValue);
            chatController.oncesCallChat = true;
            chatController.forseUpdate();
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: ChatController(),
        builder: (chatController) {
          return Scaffold(
              body: chatController.review == "0"
                  ? Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              child: LottieBuilder.asset(
                                "assets/images/underprocess.json",
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
                              )),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              chatController.reviewMSG,
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
                            onTap: () {
                              final BottomNavController controller =
                                  Get.put(BottomNavController());
                              controller.updateIndex(0);

                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Home()),
                                  (route) => false);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(
                                  top: 20, left: 20, right: 20),
                              alignment: Alignment.center,
                              height: 40,
                              decoration: const BoxDecoration(
                                  color: Colors.black,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: Text(
                                "Back to home".toUpperCase(),
                                style: GoogleFonts.lexendExa(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              final BottomNavController controller =
                                  Get.put(BottomNavController());

                              dialodShow();

                              if (await controller.getHomeData(context, "")) {
                                Navigator.pop(loadingDialog);

                                checkValues();

                                profileController proController =
                                    Get.put(profileController());

                                proController.getProfleValue();
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.only(
                                  top: 20, left: 20, right: 20),
                              alignment: Alignment.center,
                              height: 40,
                              decoration: const BoxDecoration(
                                  color: Colors.black,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: Text(
                                "refresh".toUpperCase(),
                                style: GoogleFonts.lexendExa(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                           
                            Text(
                                "Try refreshing",
                                style: GoogleFonts.lexendDeca(
                                  fontStyle: FontStyle.italic,
                                     fontSize: 16,
                                    color: Colors.grey,
                                    
                                    fontWeight: FontWeight.w300),
                              ),


                          Container(
                            margin: const EdgeInsets.only(top: 60, bottom: 10),
                            child: InkWell(
                              onTap: () async {
                                SharedPreferences sharedPreferences =
                                    await SharedPreferences.getInstance();

                                sharedPreferences.setString(
                                    SizValue.underReview, "null");
                                sharedPreferences.setString(
                                    SizValue.isLogged, "null");

                                ChatController chatController =
                                    Get.put(ChatController());
                                chatController.getProfleValue();
                                profileController pController =
                                    Get.put(profileController());
                                pController.getProfleValue();

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            LoginPage(otpNumber: "")));
                              },
                              child: Text(
                                "Use another account ?".toUpperCase(),
                                style: GoogleFonts.lexendDeca(
                                    decoration: TextDecoration.underline,
                                    fontSize: 16,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : chatController.review == "2"
                      ? Container(
                          margin: const EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  child: LottieBuilder.asset(
                                    "assets/images/rejectanimation.json",
                                    fit: BoxFit.cover,
                                    width: 100,
                                    height: 100,
                                  )),
                              Container(
                                alignment: Alignment.center,
                                child: Text(
                                  chatController.reviewRejectMSG,
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
                                onTap: () async {
                                  SharedPreferences sharedPreferences =
                                      await SharedPreferences.getInstance();
                                  sharedPreferences.clear();

                                  final BottomNavController controller =
                                      Get.put(BottomNavController());
                                  controller.updateIndex(0);

                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const Home()),
                                      (Route<dynamic> route) => false);
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      top: 20, left: 20, right: 20),
                                  alignment: Alignment.center,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                      color: Colors.black,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: Text(
                                    "LOGOUT".toUpperCase(),
                                    style: GoogleFonts.lexendExa(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      : chatController.review == "3"
                          ? Container(
                              margin:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      child: LottieBuilder.asset(
                                        "assets/images/incomplete.json",
                                        fit: BoxFit.cover,
                                        width: 100,
                                        height: 100,
                                      )),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      chatController.incompleteMsg,
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
                                    onTap: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AccountCreate()));
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          top: 20, left: 20, right: 20),
                                      alignment: Alignment.center,
                                      height: 40,
                                      decoration: const BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      child: Text(
                                        "COMPLETE SIGNUP".toUpperCase(),
                                        style: GoogleFonts.lexendExa(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    splashFactory: NoSplash.splashFactory,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      SharedPreferences sharedPreferences =
                                          await SharedPreferences.getInstance();

                                      sharedPreferences.setString(
                                          SizValue.underReview, "null");
                                      sharedPreferences.setString(
                                          SizValue.isLogged, "null");

                                      ChatController chatController =
                                          Get.put(ChatController());
                                      chatController.getProfleValue();
                                      profileController pController =
                                          Get.put(profileController());
                                      pController.getProfleValue();

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginPage(otpNumber: "")));
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          top: 60, bottom: 10),
                                      child: Text(
                                        "Use another account ?".toUpperCase(),
                                        style: GoogleFonts.lexendDeca(
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: 16,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : chatController.loginStatus == "1"
                              ? Container(
                                  margin: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 20),
                                          child: LottieBuilder.asset(
                                            "assets/images/incomplete.json",
                                            fit: BoxFit.cover,
                                            width: 100,
                                            height: 100,
                                          )),
                                      Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          chatController.incompleteMsg,
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
                                        onTap: () async {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      BasicLoginInfo(
                                                          fromWhere:
                                                              chatController
                                                                  .source)));
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              top: 20, left: 20, right: 20),
                                          alignment: Alignment.center,
                                          height: 40,
                                          decoration: const BoxDecoration(
                                              color: Colors.black,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                          child: Text(
                                            "COMPLETE SIGNUP".toUpperCase(),
                                            style: GoogleFonts.lexendExa(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        splashFactory: NoSplash.splashFactory,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          SharedPreferences sharedPreferences =
                                              await SharedPreferences
                                                  .getInstance();

                                          sharedPreferences.setString(
                                              SizValue.underReview, "null");
                                          sharedPreferences.setString(
                                              SizValue.isLogged, "null");

                                          ChatController chatController =
                                              Get.put(ChatController());
                                          chatController.getProfleValue();
                                          profileController pController =
                                              Get.put(profileController());
                                          pController.getProfleValue();

                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginPage(
                                                          otpNumber: "")));
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              top: 60, bottom: 10),
                                          child: Text(
                                            "Use another account ?"
                                                .toUpperCase(),
                                            style: GoogleFonts.lexendDeca(
                                                decoration:
                                                    TextDecoration.underline,
                                                fontSize: 16,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : chatController.loginStatus == "2"
                                  ? Container(
                                      margin: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 20),
                                              child: LottieBuilder.asset(
                                                "assets/images/incomplete.json",
                                                fit: BoxFit.cover,
                                                width: 100,
                                                height: 100,
                                              )),
                                          Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              chatController.incompleteMsg,
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
                                            onTap: () async {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AccountCreate()));
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  top: 20, left: 20, right: 20),
                                              alignment: Alignment.center,
                                              height: 40,
                                              decoration: const BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5))),
                                              child: Text(
                                                "COMPLETE SIGNUP".toUpperCase(),
                                                style: GoogleFonts.lexendExa(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            splashFactory:
                                                NoSplash.splashFactory,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              SharedPreferences
                                                  sharedPreferences =
                                                  await SharedPreferences
                                                      .getInstance();

                                              sharedPreferences.setString(
                                                  SizValue.underReview, "null");
                                              sharedPreferences.setString(
                                                  SizValue.isLogged, "null");

                                              ChatController chatController =
                                                  Get.put(ChatController());
                                              chatController.getProfleValue();
                                              profileController pController =
                                                  Get.put(profileController());
                                              pController.getProfleValue();

                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          LoginPage(
                                                              otpNumber: "")));
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  top: 60, bottom: 10),
                                              child: Text(
                                                "Use another account ?"
                                                    .toUpperCase(),
                                                style: GoogleFonts.lexendDeca(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    fontSize: 16,
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : chatController.loginStatus == "null"
                                      ? Container(
                                          margin: const EdgeInsets.only(
                                              left: 20, right: 20),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                  margin: const EdgeInsets.only(
                                                      bottom: 20),
                                                  child: LottieBuilder.asset(
                                                    "assets/images/underprocess.json",
                                                    fit: BoxFit.cover,
                                                    width: 100,
                                                    height: 100,
                                                  )),
                                              Container(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "Please login to continue",
                                                  maxLines: 4,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.lexendDeca(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: Colors.black),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              LoginPage(
                                                                otpNumber: "",
                                                              )));
                                                },
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 20,
                                                      left: 20,
                                                      right: 20),
                                                  alignment: Alignment.center,
                                                  height: 40,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.black,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                  child: Text(
                                                    "Login".toUpperCase(),
                                                    style:
                                                        GoogleFonts.lexendExa(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      : Column(
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              margin: const EdgeInsets.only(
                                                  top: 20, bottom: 20),
                                              child: Text("Chats".toUpperCase(),
                                                  style: SizValue.toolbarStyle),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: 20, right: 20),
                                              margin: const EdgeInsets.only(
                                                  left: 20,
                                                  right: 20,
                                                  bottom: 20),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.white,
                                                boxShadow: const [
                                                  BoxShadow(
                                                      color: Color.fromARGB(
                                                          255, 209, 209, 209),
                                                      blurRadius: 1)
                                                ],
                                              ),
                                              child: TextFormField(
                                                controller: searchController,
                                                onChanged: (value) async {
                                                  startTimer() {
                                                    checkTypingTimer = Timer(
                                                        const Duration(
                                                            milliseconds: 600),
                                                        () async {
                                                      setState(() {
                                                        stringValue = value;
                                                        pageno = 1;
                                                      });

                                                      chatController
                                                          .getChatListOutside(
                                                              1, stringValue);
                                                    });
                                                  }

                                                  checkTypingTimer?.cancel();
                                                  startTimer();
                                                },
                                                style: GoogleFonts.lexendDeca(
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 14,
                                                    color: Colors.black),
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: "Search...",
                                                    hintStyle:
                                                        GoogleFonts.lexendDeca(
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            fontSize: 14,
                                                            color:
                                                                Colors.grey)),
                                              ),
                                            ),
                                            Expanded(
                                              child: (chatController
                                                          .decordedChatOutside
                                                          .isEmpty &&
                                                      pageno <= 1)
                                                  ? Center(
                                                      child: Text(
                                                        "No Chats",
                                                        style: GoogleFonts
                                                            .lexendDeca(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300),
                                                      ),
                                                    )
                                                  : Stack(
                                                      children: [
                                                        ListView.builder(
                                                            controller:
                                                                _scrollControllerChat,
                                                            shrinkWrap: true,
                                                            physics:
                                                                const ClampingScrollPhysics(),
                                                            padding:
                                                                EdgeInsets.zero,
                                                            itemCount:
                                                                chatController
                                                                    .decordedChatOutside
                                                                    .length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10),
                                                                child: Column(
                                                                  children: [
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          chatController.decordedChatOutside[index]["unread"] =
                                                                              0;
                                                                        });

                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder: (context) => ChatInside(
                                                                                      lenderId: chatController.decordedChatOutside[index]["to_user_id"].toString(),
                                                                                      product: "",
                                                                                      order: "",
                                                                                    )));
                                                                      },
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          chatController.chatResponseOutside.isEmpty
                                                                              ? const SizedBox(
                                                                                  width: 55,
                                                                                  height: 55,
                                                                                )
                                                                              : Container(
                                                                                  width: 55,
                                                                                  height: 55,
                                                                                  padding: const EdgeInsets.all(2),
                                                                                  decoration: const BoxDecoration(shape: BoxShape.circle),
                                                                                  child: ClipRRect(
                                                                                    borderRadius: BorderRadius.circular(1000),
                                                                                    child: CachedNetworkImage(
                                                                                      imageUrl: chatController.decordedChatOutside[index]["profile_img"].toString(),
                                                                                      fit: BoxFit.cover,
                                                                                      height: 55,
                                                                                      width: 55,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                          Expanded(
                                                                            child:
                                                                                Container(
                                                                              margin: const EdgeInsets.only(left: 10),
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    "${chatController.decordedChatOutside[index]["username"]}",
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    style: GoogleFonts.lexendDeca(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w300),
                                                                                  ),
                                                                                  const SizedBox(height: 5),
                                                                                  chatController.decordedChatOutside[index]["last_msg_type"] == 1
                                                                                      ? Text(decordedResponse(chatController.decordedChatOutside[index]["last_msg"].toString()), maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.lexendDeca(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w300))
                                                                                      : Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            const Icon(
                                                                                              Icons.image,
                                                                                              size: 15,
                                                                                              color: Colors.grey,
                                                                                            ),
                                                                                            const SizedBox(width: 2),
                                                                                            Text(
                                                                                              decordedResponse(chatController.decordedChatOutside[index]["last_msg"].toString()),
                                                                                              overflow: TextOverflow.ellipsis,
                                                                                              style: GoogleFonts.lexendExa(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w300),
                                                                                            )
                                                                                          ],
                                                                                        )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Column(
                                                                            children: [
                                                                              Text(
                                                                                chatController.decordedChatOutside[index]["updated_at"].toString(),
                                                                                style: GoogleFonts.lexendDeca(fontSize: 12, color: MyColors.themecolor, fontWeight: FontWeight.w300),
                                                                              ),
                                                                              Visibility(
                                                                                visible: chatController.decordedChatOutside[index]["unread"] == 0 ? false : true,
                                                                                child: Container(
                                                                                  padding: const EdgeInsets.all(5),
                                                                                  decoration: const BoxDecoration(shape: BoxShape.circle, color: MyColors.themecolor),
                                                                                  child: Text(
                                                                                    chatController.decordedChatOutside[index]["unread"].toString(),
                                                                                    style: GoogleFonts.lexendDeca(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                      height: 1,
                                                                      color: const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          228,
                                                                          228,
                                                                          228),
                                                                      margin: const EdgeInsets.only(
                                                                          left:
                                                                              20,
                                                                          right:
                                                                              20,
                                                                          top:
                                                                              10,
                                                                          bottom:
                                                                              10),
                                                                    )
                                                                  ],
                                                                ),
                                                              );
                                                            }),
                                                        Visibility(
                                                          visible: chatController
                                                              .showLazyIndicator,
                                                          child: Positioned(
                                                            bottom: 0,
                                                            child: Container(
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            20),
                                                                margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            10),
                                                                child:
                                                                    const CircularProgressIndicator()),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                            )
                                          ],
                                        ));
        });
  }

  decordedResponse(String response) {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    return stringToBase64.decode(response);
  }
}
