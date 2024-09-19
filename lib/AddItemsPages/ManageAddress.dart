// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siz/Pages/Home.dart';
import 'package:siz/Utils/Colors.dart';
import 'package:siz/Utils/Value.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

class ManageAddress extends StatefulWidget {
  const ManageAddress({super.key});

  @override
  State<ManageAddress> createState() => _ManageAddressState();
}

class _ManageAddressState extends State<ManageAddress> {

  TextEditingController nameController=TextEditingController();
  TextEditingController appartmentController=TextEditingController();
  TextEditingController buildingController=TextEditingController();
  TextEditingController areaController=TextEditingController();
  TextEditingController mobileController=TextEditingController();


  // call manage api =========================================================================================================


    Map<String, dynamic> manageReponse = {};

  addManageRequest() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    dialodShow(context);


    try {
      final response = await http.post(Uri.parse(SizValue.addmanageRequest), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey),
        'apartment': appartmentController.text.toString(),
        'area_name': buildingController.text.toString(),
        'city': areaController.text.toString(),
        'state':selectedEmirates,
        'contact_name': nameController.text.toString(),
        'mobile_number': mobileController.text.toString()
        
      });

      manageReponse = jsonDecode(response.body);

      if (manageReponse["success"] == true) {
       
     
        Navigator.pop(context);


         showGeneralDialog(
                context: context,
                barrierLabel: "Barrier",
                barrierDismissible: false,
                barrierColor: Colors.black.withOpacity(0.5),
                transitionDuration: const Duration(milliseconds: 300),
                pageBuilder: (_, __, ___) {
                  return WillPopScope(
                    onWillPop: () async{
                      return false;
                    },
                    child: Center(
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: 20,right: 20),
                        height: 180,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(13)),
                        child:  Scaffold(
                          backgroundColor: Colors.transparent,
                            body: Column( 
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                                "Thank you for submitting your request.\nNow sit back and relax, our team will\nget in touch with you to schedule your\ncloset visit.",textAlign: TextAlign.center,style: TextStyle(fontSize: 14),),
                  
                                InkWell(
                                  onTap: () {
                                    
                                 
                                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const Home()), (route) => false);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(top: 15),
                                    padding: const EdgeInsets.only(top: 10,bottom: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(5)
                                    ),
                                    child:  Text("HOME",
                                    textAlign: TextAlign.center,
                                   style: GoogleFonts.lexendExa(
        
        fontSize: 16,color: Colors.white,fontWeight: FontWeight.w300)),
                                  ),
                                )
                          ],
                        )),
                      ),
                    ),
                  );
                },
              );
     
      } else if (manageReponse["success"] == false) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text("Something went wrong",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
      }
    } on ClientException {
      Navigator.pop(context);
      mysnackbar(
          "Server not responding please try again after sometimev fg", context);
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




  List<String> emiratesList = [
    'Abu Dhabi',
    'Dubai',
    'Sharjah',
    'Ajman',
    'Umm Al Quwain',
    'Ras Al Khaimah',
    'Fujairah',
  ];


  String selectedEmirates="";

  bool termsCondition=false;




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              toolbarHeight: 0,
            ),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
         
      
      
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
              const EdgeInsets.only( left: 20, right: 20),
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
          
          
        // body ===========================================================================================================
          

          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [


                            Container(
              margin: const EdgeInsets.only(right: 15,top: 20, left: 15),
              alignment: Alignment.center,
              child:  Text(
                'Please share your details so we can reach out to you and arrange a meeting and closet review',
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSerifDisplay(fontSize: 20,fontWeight: FontWeight.w400, color: Colors.black),
              )),
      
         
          
          //textformfield one
      
      
          Container(
           height: 55,
              width: MediaQuery.of(context).size.width,
              margin:
            const EdgeInsets.only(left: 10, right: 10,top: 20),
              child: Theme(
          data: Theme.of(context)
              .copyWith(splashColor: Colors.transparent),
          child: TextFormField(
      
      
            style: GoogleFonts.lexendDeca(
                fontWeight: FontWeight.w300,
                  color: Colors.black,
                  fontSize: 14 ,
              ),
      
            controller: nameController,
            decoration: InputDecoration(
             
              hintStyle: GoogleFonts.lexendExa(
                fontWeight: FontWeight.w300,
                  color: Colors.grey,
                  fontSize: 12 ,
              ),
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
              labelText: "NAME",
              labelStyle:  GoogleFonts.lexendExa(
                fontWeight: FontWeight.w300,
                  color: Colors.grey,
                  fontSize: 12 ,
              ),
            ),
          ),
              ),
            ),
      
               //textformfield Six
          
        Container(
            height: 55,
              width: MediaQuery.of(context).size.width,
              margin:
            const EdgeInsets.only(left: 10, right: 10, top: 15),
              child: Theme(
          data: Theme.of(context)
              .copyWith(splashColor: Colors.transparent),
          child: TextFormField(
      
            keyboardType: TextInputType.number,
      
               controller: mobileController,
      
      
               style:  GoogleFonts.lexendDeca(
                fontWeight: FontWeight.w300,
                  color: Colors.black,
                  fontSize: 14 ,
              ),
            decoration: InputDecoration(
             
              hintStyle:  GoogleFonts.lexendExa(
                fontWeight: FontWeight.w300,
                  color: Colors.grey,
                  fontSize: 12 ,
              ),
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
              labelText: "MOBILE NUMBER",
              labelStyle:   GoogleFonts.lexendExa(
                fontWeight: FontWeight.w300,
                  color: Colors.grey,
                  fontSize: 12 ,
              ),
            ),
          ),
              ),
            ),
          
          //textformfield two
          
        Container(
          height: 55,
              width: MediaQuery.of(context).size.width,
              margin:
            const EdgeInsets.only(left: 10, right: 10, top: 15),
              child: Theme(
          data: Theme.of(context)
              .copyWith(splashColor: Colors.transparent),
          child: TextFormField(
      
            style:  GoogleFonts.lexendDeca(
                fontWeight: FontWeight.w300,
                  color: Colors.black,
                  fontSize: 14 ,
              ),
      
               controller: appartmentController,
            decoration: InputDecoration(
             
              hintStyle:  GoogleFonts.lexendExa(
                fontWeight: FontWeight.w300,
                  color: Colors.grey,
                  fontSize: 12 ,
              ),
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
              labelText: "APARTMENT / VILLA NUMBER",
              labelStyle:   GoogleFonts.lexendExa(
                fontWeight: FontWeight.w300,
                  color: Colors.grey,
                  fontSize: 12 ,
              ),
            ),
          ),
              ),
            ),
          
          //textformfield three
          
        Container(
          height: 55,
              width: MediaQuery.of(context).size.width,
              margin:
            const EdgeInsets.only(left: 10, right: 10, top: 15),
              child: Theme(
          data: Theme.of(context)
              .copyWith(splashColor: Colors.transparent),
          child: TextFormField(
      
            style:  GoogleFonts.lexendDeca(
                fontWeight: FontWeight.w300,
                  color: Colors.black,
                  fontSize: 14,
              ),
      
               controller: buildingController,
            decoration: InputDecoration(
             
              hintStyle:  GoogleFonts.lexendExa(
                fontWeight: FontWeight.w300,
                  color: Colors.grey,
                  fontSize: 12 ,
              ),
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
              labelText: "BUILDING NAME",
              labelStyle:  GoogleFonts.lexendExa(
                fontWeight: FontWeight.w300,
                  color: Colors.grey,
                  fontSize: 12 ,
              ),
            ),
          ),
              ),
            ),
          
          //textformfield four
          
        Container(
          height: 55,
              width: MediaQuery.of(context).size.width,
              margin:
            const EdgeInsets.only(left: 10, right: 10, top: 15),
              child: Theme(
          data: Theme.of(context)
              .copyWith(splashColor: Colors.transparent),
          child: TextFormField(
      
            style:  GoogleFonts.lexendDeca(
                fontWeight: FontWeight.w300,
                  color: Colors.black,
                  fontSize: 14 ,
              ),
      
               controller: areaController,
            decoration: InputDecoration(
             
              hintStyle:  GoogleFonts.lexendExa(
                fontWeight: FontWeight.w300,
                  color: Colors.grey,
                  fontSize: 12 ,
              ),
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
              labelText: "AREA NAME / STREET NAME",
              labelStyle:   GoogleFonts.lexendExa(
                fontWeight: FontWeight.w300,
                  color: Colors.grey,
                  fontSize: 12 ,
              ),
            ),
          ),
              ),
            ),
          
       
      
           Container(
            margin: const EdgeInsets.only(left: 10,right: 10),
             child: CustomDropdown<String>(
                              
                                  hintText: 'SELECT EMIRATE',
                                  items: emiratesList,
                                  excludeSelected: false,
                                  expandedBorderRadius:
                                   
                                      const BorderRadius.all(Radius.circular(5)),
                                  closedBorderRadius:
                                      const BorderRadius.all(Radius.circular(5)),
                                  closedBorder: Border.all(color: const Color.fromARGB(255, 211, 211, 211),),
                                  
                                  // expandedBorder: Border.all(color: Colors.black),
                                  headerBuilder: (context, selectedItem) {
                                    return Container(
                                       margin: const EdgeInsets.symmetric(vertical: 20),
                                      child: Text(
                                        selectedItem,
                                        style:    GoogleFonts.lexendDeca(
                                                      fontWeight: FontWeight.w300,
                                                        color: Colors.black,
                                                        fontSize: 14 ,
                                                    ),
                                      ),
                                    );
                                  },
                               
                                  listItemBuilder: (context, item) {
                                    return Container(
                                     margin: const EdgeInsets.symmetric(vertical: 10),
                                      child: Text(item,
                                          style:   GoogleFonts.lexendDeca(
                                              fontSize: 14,fontWeight: FontWeight.w300, color: Colors.black)),
                                    );
                                  },
                               
                                  hintBuilder: (context, hint) {
                                    return Container(
                                      margin: const EdgeInsets.symmetric(vertical: 20),
                                      child: Text(
                                        hint,
                                        style: GoogleFonts.lexendExa(
                                                    fontWeight: FontWeight.w300,
                                                      color: Colors.grey,
                                                      fontSize: 12 ,
                                                  ),
                                      ),
                                    );
                                  },
                                  onChanged: (value) {
           
           
                                    setState(() {
                                      selectedEmirates=value;
                                    });
                                  },
           
                                
             ),
           ),
      
      
      
          
       
      
            // const Spacer(),
      
      
      Container(
                  margin: const EdgeInsets.only(left:10, right: 20,bottom: 10,top: 10),
                  
                  child: Row(
                    children: [
                
                      Checkbox(value: termsCondition,
      
                    shape:  RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(3)),
      
                      
                       onChanged: (value){
      
      
                
                        setState(() {
                          termsCondition=value!;
                        });
                
                      }),
                
                      Expanded(child:
                       RichText(text: TextSpan(
                        children: [
                
                            TextSpan(
                  text: "Please check the box to confirm that you've read and agree to the ",
                               style: GoogleFonts.lexendDeca(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              fontSize: 12),
                   recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    
                  }),
                            TextSpan(
                  text: "Terms and conditions ",
                               style: GoogleFonts.lexendDeca(
                              color: Colors.blue,
                              fontWeight: FontWeight.w300,
                              fontSize: 12),
                   recognizer: TapGestureRecognizer()
                  ..onTap = () {
                
                  launchUrl(Uri.parse("https://siz.ae/pages/terms-and-conditions"));
                    
                  }),
                            TextSpan(
                  text: "and",
                              style:GoogleFonts.lexendDeca(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              fontSize: 12),
                   recognizer: TapGestureRecognizer()
                  ..onTap = () {
                
              
                    
                  }),
                            TextSpan(
                  text: " Lender terms and conditions.",
                               style: GoogleFonts.lexendDeca(
                              color: Colors.blue,
                              fontWeight: FontWeight.w300,
                              fontSize: 12),
                   recognizer: TapGestureRecognizer()
                  ..onTap = () {
                
                  launchUrl(Uri.parse("https://siz.ae/pages/terms-conditions-lender"));
                    
                  }),
                        ]
                       ))
                      
                      )
                
                    ],
                  ),
      ),
      
      
      
         InkWell(
      onTap: 
      termsCondition?
      
      () {
      
      
        if(nameController.text.isEmpty)
        {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter name")));
        }
      
        else  if(appartmentController.text.isEmpty)
        {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter appartment/villa number")));
        }
        else  if(buildingController.text.isEmpty)
        {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter building name/area name")));
        }
        else  if(areaController.text.isEmpty)
        {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter area name/street name")));
        }
        else  if(selectedEmirates.isEmpty)
        {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select emirate")));
        }
        else  if(mobileController.text.isEmpty)
        {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter mobile number")));
        }
      
        else{
      
      addManageRequest();
      
      
      
      
      
        }
      
        
      
      }:null,
      child:   Container(
      width: MediaQuery.of(context).size.width,
      height: 40,
      margin: const EdgeInsets.only(left: 10,right: 10,top: 15,bottom: 40),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: termsCondition? Colors.black:Colors.grey,
      borderRadius: BorderRadius.circular(5)
      
      ),
      child:  Text("SUBMIT",style: GoogleFonts.lexendExa(
        
        fontSize: 16,color: Colors.white,fontWeight: FontWeight.w300),),
        ),
      )
        
                
              ],
            ),
          )
      
      
  
      
      
      
      
      
      
      
          
        
      
        ],
      ),
    );
  }
}