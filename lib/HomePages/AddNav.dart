// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


import 'package:siz/AddItemsPages/ManageKeep.dart';
import 'package:siz/Controllers/ChatController.dart';

import 'package:siz/Utils/Colors.dart';


class AddNav extends StatefulWidget {

  bool fromhome=false;
   AddNav({super.key,required this.fromhome});

  @override
  State<AddNav> createState() => _AddNavState();
}

class _AddNavState extends State<AddNav> {

  ChatController controller=Get.put(ChatController());



   
    


     firebaseEventCalled()
  {
    
     try {
      FacebookAppEvents facebookAppEvents = FacebookAppEvents();

      facebookAppEvents.logEvent(
        name: "AddClosetAndroid",
      );
    } catch (e) {}
  }

  
  

  @override
  initState()
  {

    firebaseEventCalled();
     controller.getProfleValue();
    super.initState();
  }






  @override
  Widget build(BuildContext context) {
    var boxDecoration = const BoxDecoration();
    return 
    
 
    GetBuilder(
      init: ChatController(),
      builder: (controller) {
        return Scaffold(
           appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              toolbarHeight: 0,
            ),
          
          body: 
              
           Column(
            children: [

                 // top four icons ==============================================================================================
   
              widget.fromhome?
                   
                   const SizedBox(height: 00,width: 30,):
              Container(
                alignment: Alignment.center,
                height: 60,
                decoration: const BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(255, 228, 228, 228),
                      blurRadius: 2,
                      offset: Offset(0, 2))
                ]),
                padding:
                    const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                   InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset("assets/images/backarrow.svg",width: 20,height: 20,)),
                    Image.asset(
                      "assets/images/appiconpng.png",
                      height: 40,
                      width: 40,
                    ),
                    const SizedBox(width: 30, height: 0)
                  ],
                ),
                 ),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: [
                 
                  // heading text 
                  const SizedBox(height: 20),    
                  
                  Container(
                    alignment: Alignment.center,
                    child: Text("How to lend?",style: GoogleFonts.dmSerifDisplay(
                      fontWeight: FontWeight.w400,
                              fontSize: 20,color: Colors.black
                    ),),
                  ),
                
              
                    // steps ==========================================================================================
                  
                
              
                   
                    const SizedBox(height: 10),
                  
                    //step 1
                  
                    Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      decoration: boxDecoration,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                         
                       
                         Expanded(
                           child: Container(
                            
                            height: 130,
                            decoration:  BoxDecoration(
                             color: Colors.white,
                            
                              boxShadow: const [BoxShadow(
                                color: Color.fromARGB(255, 206, 206, 206),
                                blurRadius: 2,
                                offset: Offset(0, 3)
                              )],
                              border: Border.all(color: Colors.black),
                              borderRadius: const BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10),bottomLeft: Radius.circular(60),bottomRight: Radius.circular(10))
                            ),
                  
                            child: Column(
                              
                              children: [
              
                                const SizedBox(height: 7),
              
                                  Container(
                                    alignment: Alignment.centerRight,
                                  margin: const EdgeInsets.only(right: 5),
                                  child:  Text("List",style: GoogleFonts.dmSerifDisplay(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                      color: MyColors.themecolor
                                  ),)),
              
                                  const SizedBox(height: 3),
                            
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.only(right: 30),
                                  child:   Text("List an item in under 2 minutes.\n\nUpload photos in your listing, featuring\nyourself, friends, or past renters wearing the\nitem. High-quality images with people tent to\nattract more interest.",
                                  textAlign: TextAlign.end,
                                  style: GoogleFonts.lexendDeca(
                                                                      color: const Color
                                                                          .fromARGB(
                                                                              255,
                                                                              98,
                                                                              98,
                                                                              98),
                                                                      fontSize: 11,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300),)),
                              
                              
                              ],
                            ),
                           ),
                         ),
                  
                             const SizedBox(width: 15),
                  
                           SizedBox(
                  
                            height: 140,
                            width: 30,
                             child: Column(
                               children: [
                  
                                   
                                 Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        shape: BoxShape.circle),
                                    child: const Text(
                                      "1",
                                      style: TextStyle(color: Colors.black, fontSize: 18),
                                    )),
                  
                                    Expanded(
                                      child: Container(
                                         
                                        width: 1,
                                        color: Colors.black,
                                        
                                      ),
                                    ),
                  
                  
                        
                  
                           
                                    
                               ],
                             ),
                           ),
                        ],
                      ),
                    ),
                  
                  
                  
                //step 2
                  
                   Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      decoration: boxDecoration,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                         
                       
                         Expanded(
                           child: Container(
                           
                            
                           alignment: Alignment.topRight,
                            height: 130,
                            decoration:  BoxDecoration(
                               color: Colors.white,
                            
                              boxShadow: const [BoxShadow(
                                color: Color.fromARGB(255, 206, 206, 206),
                                blurRadius: 2,
                                offset: Offset(0, 3)
                              )],
                              border: Border.all(color: Colors.black),
                              borderRadius: const BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10),bottomLeft: Radius.circular(60),bottomRight: Radius.circular(10))
                            ),
                  
                            child: Column(
                              
                              children: [
              
                                const SizedBox(height: 7),
              
                                  Container(
                                    alignment: Alignment.centerRight,
                                  margin: const EdgeInsets.only(right: 5),
                                  child:  Text("Approve rental",style: GoogleFonts.dmSerifDisplay(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                      color: MyColors.themecolor
                                  ),)),
              
                                  const SizedBox(height: 3),
                            
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.only(right: 30),
                                  child:   Text("You have the choice to approve or decline all\nrental requests that you receive.\n\nCommunicate directly with our team or your\npotential renter via our secure messaging\nsystem.",
                                  textAlign: TextAlign.end,
                                  style:GoogleFonts.lexendDeca(
                                                                      color: const Color
                                                                          .fromARGB(
                                                                              255,
                                                                              98,
                                                                              98,
                                                                              98),
                                                                      fontSize: 11,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300),)),
                              
                              
                              ],
                            ),
                           ),
                         ),
                  
                             const SizedBox(width: 15),
                  
                           SizedBox(
                  
                            height: 140,
                            width: 30,
                             child: Column(
                               children: [
                  
                                   
                                 Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        shape: BoxShape.circle),
                                    child: const Text(
                                      "2",
                                      style: TextStyle(color: Colors.black, fontSize: 18),
                                    )),
                  
                                    Expanded(
                                      
                                      child: Container(
                                         
                                        width: 1,
                                        color: Colors.black,
                                        
                                      ),
                                    ),
                  
                  
                        
                  
                           
                                    
                               ],
                             ),
                           ),
                        ],
                      ),
                    ),
                  
                  
                      //step 3
                  
                   Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      decoration: boxDecoration,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                         
                       
                         Expanded(
                           child: Container(
                             
                          
                           
                            height: 130,
                            decoration:  BoxDecoration(
                               color: Colors.white,
                            
                              boxShadow: const [BoxShadow(
                                color: Color.fromARGB(255, 206, 206, 206),
                                blurRadius: 2,
                                offset: Offset(0, 3)
                              )],
                              border: Border.all(color: Colors.black),
                              borderRadius: const BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10),bottomLeft: Radius.circular(60),bottomRight: Radius.circular(10))
                            ),
                  
                            child: Column(
                              
                              children: [
              
                                const SizedBox(height: 7),
              
                                  Container(
                                    alignment: Alignment.centerRight,
                                  margin: const EdgeInsets.only(right: 5),
                                  child:  Text("Ship",style:  GoogleFonts.dmSerifDisplay(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                      color: MyColors.themecolor
                                  ),)),
              
                                  const SizedBox(height: 3),
                            
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.only(right: 30),
                                  child:   Text("We take care of everything from pick-up to\nreturn once dry cleaned for your hassle-free\nlending.\n\nAll you have to do is approve rental requests!",
                                  textAlign: TextAlign.end,
                                  style: GoogleFonts.lexendDeca(
                                                                      color: const Color
                                                                          .fromARGB(
                                                                              255,
                                                                              98,
                                                                              98,
                                                                              98),
                                                                      fontSize: 11,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300),)),
                              
                              
                              ],
                            ),
                           ),
                         ),
                  
                             const SizedBox(width: 15),
                  
                           SizedBox(
                  
                            height: 140,
                            width: 30,
                             child: Column(
                               children: [
                  
                                   
                                 Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        shape: BoxShape.circle),
                                    child: const Text(
                                      "3",
                                      style: TextStyle(color: Colors.black, fontSize: 18),
                                    )),
                  
                                    Expanded(
                                      
                                      child: Container(
                                         
                                        width: 1,
                                        color: Colors.black,
                                        
                                      ),
                                    ),
                  
                  
                        
                  
                           
                                    
                               ],
                             ),
                           ),
                        ],
                      ),
                    ),
                  
                                //step 3
                  
                   Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      decoration: boxDecoration,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                         
                       
                         Expanded(
                           child: Container(
                             
                          
                            
                            height: 130,
                            decoration:  BoxDecoration(
                               color: Colors.white,
                            
                              boxShadow: const [BoxShadow(
                                color: Color.fromARGB(255, 206, 206, 206),
                                blurRadius: 2,
                                offset: Offset(0, 3)
                              )],
                              border: Border.all(color: Colors.black),
                              borderRadius: const BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10),bottomLeft: Radius.circular(60),bottomRight: Radius.circular(10))
                            ),
                  
                            child: Column(
                              
                              children: [
              
                                const SizedBox(height: 7),
              
                                  Container(
                                    alignment: Alignment.centerRight,
                                  margin: const EdgeInsets.only(right: 5),
                                  child:  Text("Get paid and review",style:  GoogleFonts.dmSerifDisplay(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                      color: MyColors.themecolor
                                  ),)),
              
                                  const SizedBox(height: 3),
                            
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.only(right: 30),
                                  child:   Text("Once your rental is completed,payment to your\nband account will be processed within 10-15\ndays.\n\nLeave honest feedback for your fellow sizters!",
                                  textAlign: TextAlign.end,
                                  style:GoogleFonts.lexendDeca(
                                                                      color: const Color
                                                                          .fromARGB(
                                                                              255,
                                                                              98,
                                                                              98,
                                                                              98),
                                                                      fontSize: 11,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300),)),
                              
                              
                              ],
                            ),
                           ),
                         ),
                  
                             const SizedBox(width: 15),
                  
                           SizedBox(
                  
                            height: 140,
                            width: 30,
                             child: Column(
                               children: [
                  
                                   
                                 Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        shape: BoxShape.circle),
                                    child: const Text(
                                      "4",
                                      style: TextStyle(color: Colors.black, fontSize: 18),
                                    )),
                  
                                  
                  
                  
                        
                  
                           
                                    
                               ],
                             ),
                           ),
                        ],
                      ),
                    ),
                  
                  
                  
                  
                  
                    InkWell(
                      onTap: () {
                       



                              

                                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const ManageKeep()));


                                











                      },
                      child: Container(
                        
                        width:200,
                        height: 40,
                        margin: const EdgeInsets.only(left: 70,right: 70,top: 10,bottom: 30),
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: MyColors.themecolor,
                          borderRadius: BorderRadius.all(Radius.circular(5))
                        ),
                    
                        child:  Text("START LENDING",style: GoogleFonts.lexendExa(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w300),),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      }
    );
  }



}
