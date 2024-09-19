// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:siz/Controllers/BottomNavController.dart';
import 'package:siz/HomePages/AddNav.dart';
import 'package:siz/HomePages/BrowserNav.dart';
import 'package:siz/HomePages/ChatNav.dart';
import 'package:siz/HomePages/HomeNav.dart';
import 'package:siz/HomePages/ProfileNav.dart';
import 'package:siz/Utils/Colors.dart';
import 'package:http/http.dart' as http;
import 'package:transitioned_indexed_stack/transitioned_indexed_stack.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late BuildContext updateDialogContext;

  checkUpdate() async {
    final uri = Uri.https(
        "play.google.com", "/store/apps/details", {"id": 'com.siz.siz'});
    try {
      final response = await http.get(uri);
      if (response.statusCode != 200) {
        debugPrint("not found this app");
      } else {
        String? newVersion = RegExp(r',\[\[\["([0-9,\.]*)"]],')
            .firstMatch(response.body)!
            .group(1);

        checkVersion(newVersion.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    checkUpdate();
    super.initState();
  }

  checkVersion(String uploadedVersion) async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;
    debugPrint("current sdk verions====  $currentVersion");
    debugPrint("app store verion====  $uploadedVersion");
    if (uploadedVersion != currentVersion.toString()) {
      updateDialog();
    } else {
      debugPrint("No Update Found");
    }
  }

  updateDialog() {
    return showGeneralDialog(
        context: context,
        barrierLabel: "",
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: const Duration(milliseconds: 300),
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: Curves.fastOutSlowIn,
              reverseCurve: Curves.easeOutCirc,
            ),
            child: child,
          );
        },
        pageBuilder: (_, __, ___) {
          updateDialogContext = context;
          return Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.transparent,
            body: Center(
              child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      alignment: Alignment.center,
                      child: Text(
                        "Time to update!",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dmSerifDisplay(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          bottom: 20, left: 20, right: 20),
                      alignment: Alignment.center,
                      child: Text(
                        "We are constantly adding new features and fixing some bugs to make your experience as smooth as possible . Get the latest updates",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lexendDeca(
                            fontSize: 16,
                            color: const Color.fromARGB(255, 96, 96, 96),
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(updateDialogContext);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 5),
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              height: 40,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                color: Colors.grey,
                              ),
                              child: Text("Later".toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lexendExa(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300)),
                            ),
                          ),
                        ),
                        Flexible(
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(updateDialogContext);
                              launchUrl(Uri.parse(
                                  "https://play.google.com/store/apps/details?id=com.siz.siz"));
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 5),
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              height: 40,
                              decoration: const BoxDecoration(
                                  color: Colors.black,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: Text("Update now".toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lexendExa(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: BottomNavController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 0,
          ),
          body: FadeIndexedStack(
            beginOpacity: 0.0,
            endOpacity: 1.0,
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 250),
            index: controller.currentIndex,
            children: [
              const HomeNav(),
              controller.loadedPages.contains(1)
                  ? const BrowserNav()
                  : Container(),
              controller.loadedPages.contains(2)
                  ? AddNav(
                      fromhome: true,
                    )
                  : Container(),
              controller.loadedPages.contains(3)
                  ? const ChatNav()
                  : Container(),
              controller.loadedPages.contains(4)
                  ? const ProfileNav()
                  : Container()
            ],
          ),
          bottomNavigationBar: Theme(
            data: ThemeData(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent),
            child: BottomNavigationBar(
                selectedFontSize: 10,
                unselectedFontSize: 10,
                type: BottomNavigationBarType.fixed,
                currentIndex: controller.currentIndex,
                backgroundColor: Colors.white,
                selectedLabelStyle:
                    GoogleFonts.lexendDeca(fontWeight: FontWeight.w400),
                unselectedLabelStyle:
                    GoogleFonts.lexendDeca(fontWeight: FontWeight.w400),
                selectedItemColor: MyColors.themecolor,
                elevation: 0.0,
                unselectedItemColor: Colors.black,
                showUnselectedLabels: true,
                onTap: (value) {
                  controller.updateIndex(value);

                  if (!controller.loadedPages.contains(value)) {
                    setState(() {
                      controller.loadedPages.add(value);
                    });
                  }
                },
                // onTap: (index) => setState(() {
                //      controller. currentIndex = index;
                //     }),
                items: [
                  // cart icon
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      "assets/images/homebefore.svg",
                      height: 25,
                      width: 25,
                    ),
                    label: 'Home',
                    activeIcon: SvgPicture.asset(
                      "assets/images/homeafter.svg",
                      height: 25,
                      width: 25,
                    ),
                  ),

                  // home icon

                  BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        "assets/images/beforebrowse.svg",
                        height: 25,
                        width: 25,
                      ),
                      label: 'Browse',
                      activeIcon: SvgPicture.asset(
                        "assets/images/afterbrowse.svg",
                        height: 25,
                        width: 25,
                      )),

                  BottomNavigationBarItem(
                      icon: SvgPicture.asset("assets/images/plus.svg"),
                      label: '',
                      activeIcon: SvgPicture.asset("assets/images/plus.svg")),

                  // profile icon

                  BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        "assets/images/beforchat.svg",
                        height: 25,
                        width: 25,
                      ),
                      label: 'Chat',
                      activeIcon: SvgPicture.asset(
                        "assets/images/afterchat.svg",
                        height: 25,
                        width: 25,
                      )),
                  BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        "assets/images/beforprofile.svg",
                        height: 25,
                        width: 25,
                      ),
                      label: 'Dashboard',
                      activeIcon: SvgPicture.asset(
                        "assets/images/afterprofile.svg",
                        height: 25,
                        width: 25,
                      )),
                ]),
          ),
        );
      },
    );
  }
}
