// ignore_for_file: must_be_immutable, use_build_context_synchronously

 import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siz/Pages/Home.dart';
import 'package:siz/Utils/Colors.dart';
import 'dart:io';
import 'package:siz/Utils/Value.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../Controllers/BottomNavController.dart';

class CreditPage extends StatefulWidget {
  String totalearning="";
  String earning="";
  
   CreditPage({super.key,required this.earning , required this. totalearning});

  @override
  State<CreditPage> createState() => _CreditPageState();
}

class _CreditPageState extends State<CreditPage> {
  


  List<String> grouprationlist = ["BANK TRANSFER", "CREATE COUPON"];
   String selectedshipping = "BANK TRANSFER";

  TextEditingController accountName=TextEditingController();
  TextEditingController bankName=TextEditingController();
  TextEditingController iBan=TextEditingController();
  TextEditingController transferAmount=TextEditingController();
  TextEditingController coupon=TextEditingController();

  // transfer amount   ==================================================================================================



     Map<String, dynamic> transferredResponse = {};


   transferredRequest() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();


    dialodShow(context);
    try {
      final response =
          await http.post(Uri.parse(SizValue.transferredRequest), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey),
        'account_name': accountName.text,
        'bank_name': bankName.text,
        'iban': iBan.text,
        'amount': transferAmount.text
      });

 

      transferredResponse = jsonDecode(response.body);

     

      if (transferredResponse["success"] == true) {   
       


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
                             Text(
                                "Thank you for submitting your request.\nNow sit back and relax . We will process\nyour request in next 24 Hours.",textAlign: TextAlign.center,style: GoogleFonts.lexendDeca(fontSize: 14,fontWeight: FontWeight.w300),),
                  
                                InkWell(
                                  onTap: () {
                                    BottomNavController controller=Get.put(BottomNavController());

                                 
                                    controller.updateIndex(0);
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


      } else if (transferredResponse["success"] == false) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(transferredResponse["error"].toString(),style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
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



  // get account info    ==================================================================================================



  Map<String, dynamic> accountInfoResponse = {};


   getAccountInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();



    try {
      final response =
          await http.post(Uri.parse(SizValue.accountInfo), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey).toString(),     
        
      });

 

      accountInfoResponse = jsonDecode(response.body);



     

      if (accountInfoResponse["success"] == true) {

      

        accountName.text=accountInfoResponse["account_name"].toString();
        bankName.text=accountInfoResponse["bank_name"].toString();
        iBan.text=accountInfoResponse["iban"].toString();


      } else if (accountInfoResponse["success"] == false) {
       
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Something went wrong",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
      }
    } on ClientException {
     
      mysnackbar(
          "Server not responding please try again after sometime", context);
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
  initState()
  {

    getAccountInfo();
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
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
      
        Container(

          alignment: Alignment.center,
        height: 60,
       
        padding: const EdgeInsets.only(left: 20, right: 20,),

         
           decoration: const BoxDecoration(
             color: Colors.white,
             boxShadow: [BoxShadow(
               color: Color.fromARGB(255, 212, 212, 212),blurRadius: 2,
               offset: Offset(0, 3)
             )]
           ),
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
      
     
      

      Container(

        margin: const EdgeInsets.only(top: 20,bottom: 10),

        alignment: Alignment.center,
        child: Text("BANK transfer".toUpperCase(),style: GoogleFonts.lexendExa(

          fontWeight: FontWeight.w300,
          fontSize: 14,
          color: Colors.black
        ),),
      ),
       


       Container(
        margin: const EdgeInsets.only(left: 20,top: 10),
        alignment: Alignment.centerLeft,
         child: Text("total available credits: AED ${widget.totalearning}".toUpperCase(),style: GoogleFonts.lexendExa(
          fontSize: 12,
          fontWeight: FontWeight.w300
         ),),
       ),

       Container(
        margin: const EdgeInsets.only(left: 20,top: 10),
        alignment: Alignment.centerLeft,
         child: Text("withdrawable credits (earning): AED ${widget.earning}".toUpperCase(),style: GoogleFonts.lexendExa(
          fontSize: 12,
          fontWeight: FontWeight.w300
         ),),
       ),
       

       



      
      
      
      
                             // for bank transfer  ================================================================================================
      
           Expanded(
             child: Container(
             margin: const EdgeInsets.only(left: 5,right: 5),
               child: Column(
                 children: [
                        
                        
                   // textformfield first
                      Container(
                    width: MediaQuery.of(context).size.width,
                    margin:
               const EdgeInsets.only(left: 10, right: 10, top: 15),
                    child: Theme(
                          data: Theme.of(context)
                 .copyWith(splashColor: Colors.transparent),
                          child: TextFormField(
                        
                        
               style: GoogleFonts.lexendDeca(
                   fontWeight: FontWeight.w300,
                     color: Colors.black,
                     fontSize: 14 ,
                    ),
                        
               controller: accountName,
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
                 labelText: "ACCOUNT NAME",
                 labelStyle:  GoogleFonts.lexendExa(
                   fontWeight: FontWeight.w300,
                     color: Colors.grey,
                     fontSize: 12 ,
                    ),
               ),
                          ),
                    ),
                           ),
                   // textformfield second
                      Container(
                    width: MediaQuery.of(context).size.width,
                    margin:
               const EdgeInsets.only(left: 10, right: 10, top: 15),
                    child: Theme(
                          data: Theme.of(context)
                 .copyWith(splashColor: Colors.transparent),
                          child: TextFormField(
                        
                        
               style: GoogleFonts.lexendDeca(
                   fontWeight: FontWeight.w300,
                     color: Colors.black,
                     fontSize: 14 ,
                    ),
                        
               controller: bankName,
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
                 labelText: "BANK NAME",
                 labelStyle:  GoogleFonts.lexendExa(
                   fontWeight: FontWeight.w300,
                     color: Colors.grey,
                     fontSize: 12 ,
                    ),
               ),
                          ),
                    ),
                           ),
                   // textformfield third
                      Container(
                    width: MediaQuery.of(context).size.width,
                    margin:
               const EdgeInsets.only(left: 10, right: 10, top: 15),
                    child: Theme(
                          data: Theme.of(context)
                 .copyWith(splashColor: Colors.transparent),
                          child: TextFormField(
                        
                        
               style: GoogleFonts.lexendDeca(
                   fontWeight: FontWeight.w300,
                     color: Colors.black,
                     fontSize: 14 ,
                    ),
                        
               controller: iBan,
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
                 labelText: "IBAN",
                 labelStyle:  GoogleFonts.lexendExa(
                   fontWeight: FontWeight.w300,
                     color: Colors.grey,
                     fontSize: 12 ,
                    ),
               ),
                          ),
                    ),
                           ),
                   // textformfield four
                      Container(
                    width: MediaQuery.of(context).size.width,
                    margin:
               const EdgeInsets.only(left: 10, right: 10, top: 15),
                    child: Theme(
                          data: Theme.of(context)
                 .copyWith(splashColor: Colors.transparent),
                          child: TextFormField(
                        
                        
               style: GoogleFonts.lexendDeca(
                   fontWeight: FontWeight.w300,
                     color: Colors.black,
                     fontSize: 14 ,
                    ),
               keyboardType: TextInputType.number,      
               controller: transferAmount,
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
                 labelText: "TRANSFER AMOUNT",
                 labelStyle:  GoogleFonts.lexendExa(
                   fontWeight: FontWeight.w300,
                     color: Colors.grey,
                     fontSize: 12 ,
                    ),
               ),
                          ),
                    ),
                           ),
                        
                           Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(top: 5,left: 10,right: 10),
                    child: Text("Transfer amount cannot be greater than withdrawable credits from earning: AED ${widget.earning}".toUpperCase(),
                    
                    textAlign: TextAlign.center,
                    style:GoogleFonts.lexendDeca(
                      color: Colors.grey,
                        
                          fontSize: 12,
                          fontWeight: FontWeight.w300
                    ),),
                           ),
               
               
                           const Spacer(),
               
                Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(bottom: 3),
                    child: Text("*** TRANSACTION FEES OF AED 1 WILL BE APPLIED ON EVERY TRANSFER REQUEST",
                    
                     textAlign: TextAlign.center,
                    
                    style:GoogleFonts.lexendDeca(
                    color: Colors.grey,
                        
                          fontSize: 12,
                          fontWeight: FontWeight.w300
                    ),),
                           ),
               
                           InkWell(
                onTap: () {
                  if(accountName.text.isEmpty)
                  {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter account name"),duration: Duration(seconds: 1),));
                  }
                 else  if(bankName.text.isEmpty)
                  {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter bank name"),duration: Duration(seconds: 1),));
                  }
                 else  if(iBan.text.isEmpty)
                  {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter IBAN"),duration: Duration(seconds: 1),));
                  }
                 else  if(transferAmount.text.isEmpty)
                  {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter transfer amount"),duration: Duration(seconds: 1),));
                  }
                  
                  
                  else if(int.parse(transferAmount.text)>int.parse(widget.earning))
                  {

                 ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("Transfer request amount cannot be greater than withdrawable siz credit",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white)),duration: const Duration(seconds: 2),));


                  }

                  else if(int.parse(transferAmount.text)==0)
                  {

                 ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("Please select different amount",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white)),duration: const Duration(seconds: 1),));


                  }
               
                  else{

                    transferredRequest();

                   
                    
                  }
                },
                child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            bottom: 40,
                                           ),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        width: MediaQuery.of(context).size.width,
                                        height: 40,
                                        child: Text(
                                          "SUBMIT",
                                          style: GoogleFonts.lexendExa(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ),
                           ),
                           
                        
                   
                        
                   
                        
                 ],
               ),
             )
           )
      
        ],
    ),
);
}
}