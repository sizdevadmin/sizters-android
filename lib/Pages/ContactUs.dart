import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siz/Pages/ChatInside.dart';
import 'package:siz/Utils/Value.dart';

import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

 launchSocialMediaAppIfInstalled(
  String url,
) async {
  try {
    bool launched =
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    if (!launched) {
      launchUrl(Uri.parse(url)); // Launch web view if app is not installed!
    }
  } catch (e) {
    launchUrl(Uri.parse(url)); // Launch web view if app is not installed!
  }
}

class _ContactUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {
    var top = 0.0;

    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
        color: Colors.white,
          child: SafeArea(
            child: NestedScrollView(
              headerSliverBuilder: (BuildContext context, innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                        iconTheme: const IconThemeData(color: Colors.transparent),
                        elevation: 0,
                        backgroundColor: const Color.fromARGB(232, 255, 255, 255),
                        expandedHeight: 98.0,
                        floating: false,
                        pinned: true,
                        flexibleSpace: LayoutBuilder(builder:
                            (BuildContext context, BoxConstraints constraints) {
                          // check current height of toolbar
                          top = constraints.biggest.height;
                  
                          // flexiblespacebar
                  
                          return ClipRRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                              child: FlexibleSpaceBar(
                                expandedTitleScale: 1,
                                collapseMode: CollapseMode.none,
                                centerTitle: true,
                                title: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: 1.0,
                  
                  // if current toolbar height less than 100 than row else column
                  child: top.toInt() < 98
                      ? Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () async {
                                Navigator.pop(context);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(top: 15),
                                child: SvgPicture.asset(
                                    "assets/images/backarrow.svg",width: 20,height: 20,),
                              ),
                            ),
                          
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(right: 30,top: 15),
                                alignment: Alignment.center,
                                child: Text("Contact Us".toUpperCase(),
                                           style: SizValue.toolbarStyle,),
                              ),
                            )
                          ],
                        )
                      : Row(
                          mainAxisAlignment:
                              MainAxisAlignment.start,
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.start,
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        top: 20, left: 20),
                                    child: SvgPicture.asset(
                                        "assets/images/backarrow.svg",width: 20,height: 20,),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 20, top: 13),
                                  child: Text("Contact Us".toUpperCase(),
                                               style:SizValue.toolbarStyle),
                                )
                              ],
                            )
                          ],
                        )),
                              ),
                            ),
                          );
                        })),
                ];
              },
              body: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Container(
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Column(
                    children: [
                      Container(
                        margin:
                            const EdgeInsets.only(top: 5, left: 20, right: 15),
                        child:  Text(
                          "siz.ae is a peer-to-peer designer fashion rental platform empowering women to feel their best without breaking the bank.Join the sizterhood and together, let's make designer fashion accessible, sustainable, and social.",
                          style:
                              GoogleFonts.lexendDeca(
                          color: Colors.grey,
                          fontWeight: FontWeight.w300,
                          fontSize: 13),
                        ),
                      ),
              
                      // social media links container
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.only(
                            top: 20, bottom: 10, left: 10, right: 10),
                        decoration: BoxDecoration(
                            color:Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child:  Text(
                                "Social links",
                                style: GoogleFonts.lexendDeca(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 16)
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Divider(),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    launchSocialMediaAppIfInstalled("https://www.facebook.com/siztersapp");
                                  },
                                  child: SvgPicture.asset(
                                    "assets/images/facebook.svg",
                                    height: 42,
                                    width: 42,
                                  ),
                                ),
                                const SizedBox(
                                  width: 35,
                                ),
                                InkWell(
                                  onTap: () {
                                    launchSocialMediaAppIfInstalled("https://www.instagram.com/sizters.app/");
                                  },
                                  child: SvgPicture.asset(
                                    "assets/images/instagram.svg",
                                    height: 42,
                                    width: 42,
                                  ),
                                ),
                                const SizedBox(
                                  width: 35,
                                ),
                                InkWell(
                                  onTap: () {
                                    launchSocialMediaAppIfInstalled("https://www.tiktok.com/@sizters.app?_t=8kuhrMJOQ0m&_r=1");
                                  },
                                  child: SvgPicture.asset(
                                    "assets/images/tiktok.svg",
                                    height: 42,
                                    width: 42,
                                  ),
                                ),
                                const SizedBox(
                                  width: 35,
                                ),
                              
                              ],
                            )
                          ],
                        ),
                      ),
              
                      // contact with us container
              
                      Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color:Colors.white,),
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 10),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child:  Text(
                                "Connect with us",
                                style: GoogleFonts.lexendDeca(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 16)
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Divider(),
                            const SizedBox(height: 10),
              
                            // email
                            InkWell(
                              onTap: () async {
                  
                  
                                launchUrl(Uri.parse("mailto:<email address>?subject=<subject>&body=<body>"));
                 
                              },
                              child: Row(
                                children: [
                                  SvgPicture.asset("assets/images/emailgrey.svg"),
                                      const SizedBox(width: 10),
                                       Expanded(
                                        child:  Text(
                                          "hey@siz.ae",
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.lexendDeca(
                          color: Colors.grey,
                          fontWeight: FontWeight.w300,
                          fontSize: 13)
                                        ),
                                      ),
                  
                  
                                    const Icon(Icons.arrow_right,color: Color(0xff8B91A1),)
                                ],
                              ),
                            ), 


                             
                            const SizedBox(height: 10),
                            const Divider(),
              
                            // share terms and condition
              
                            const SizedBox(height: 10),
                            InkWell(
                              onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatInside(lenderId:"1",product: "",order: "",)));

                              },
                              child:  Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Wrap(
                                    alignment: WrapAlignment.center,
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    children: [
                                     const Icon(Icons.chat,size: 24,color: Color(0xff8B91A1)),
                                      const SizedBox(width: 10),
                                      Text(
                                        "Chat with us",
                                        style:  GoogleFonts.lexendDeca(
                          color: Colors.grey,
                          fontWeight: FontWeight.w300,
                          fontSize: 13)
                                      ),
                                    ],
                                  ),
                                  const Icon(Icons.arrow_right,color: Color(0xff8B91A1),)
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Divider(),
                           
                          
                          
              
                            // share terms and condition
              
                            const SizedBox(height: 10),
                            InkWell(
                              onTap: () {
                              launchUrl(Uri.parse('tel:${553674923}'));
                              },
                              child:  Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Wrap(
                                    alignment: WrapAlignment.center,
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    children: [
                                     const Icon(Icons.phone,size: 24,color: Color(0xff8B91A1)),
                                      const SizedBox(width: 10),
                                      Text(
                                        "+971 55 367 49 23",
                                        style:  GoogleFonts.lexendDeca(
                          color: Colors.grey,
                          fontWeight: FontWeight.w300,
                          fontSize: 13)
                                      ),
                                    ],
                                  ),
                                  const Icon(Icons.arrow_right,color: Color(0xff8B91A1),)
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Divider(),

                             const SizedBox(height: 10),


                              InkWell(
                              onTap: () async {


                                   var androidUrl = "whatsapp://send?phone=+971553674923&text=";

                                   await launchUrl(Uri.parse(androidUrl));
      
  

                             
                              },
                              child:  Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Wrap(
                                    alignment: WrapAlignment.center,
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    children: [
                                     SvgPicture.asset("assets/images/whatsappgrey.svg",width: 24,height: 24,),
                                      const SizedBox(width: 10),
                                      Text(
                                        "+971 55 367 49 23",
                                        style:  GoogleFonts.lexendDeca(
                          color: Colors.grey,
                          fontWeight: FontWeight.w300,
                          fontSize: 13)
                                      ),
                                    ],
                                  ),
                                  const Icon(Icons.arrow_right,color: Color(0xff8B91A1),)
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Divider(),
              
                            // privacy policy
              
                            const SizedBox(height: 10),
                            InkWell(
                              onTap: () {
                              
                              },
                              child:  Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Icon(Icons.location_city,size: 24,color: Color(0xff8B91A1)),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          "Siz Fashion Rental, Dubai Internet City, Dubai",
                                          style:  GoogleFonts.lexendDeca(
                          color: Colors.grey,
                          fontWeight: FontWeight.w300,
                          fontSize: 13)
                                        ),
                                      ),
                                // SizedBox(height: 10,width: 10,)
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
