// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siz/Controllers/BottomNavController.dart';
import 'package:siz/HomePages/AddNav.dart';
import 'package:siz/HomePages/BrowserNav.dart';
import 'package:siz/HomePages/ChatNav.dart';
import 'package:siz/HomePages/HomeNav.dart';
import 'package:siz/HomePages/ProfileNav.dart';
import 'package:siz/Utils/Colors.dart';
import 'package:transitioned_indexed_stack/transitioned_indexed_stack.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
