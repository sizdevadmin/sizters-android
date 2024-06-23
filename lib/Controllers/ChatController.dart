// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';


import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siz/Utils/Colors.dart';
import 'dart:io';
import 'package:siz/Utils/Value.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ChatController extends GetxController{




    



  String review="";
  String reviewMSG="";
  String reviewRejectMSG="";
  String incompleteMsg="";
  String loginStatus="";
  String source="";

  

  getProfleValue() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    review=sharedPreferences.getString(SizValue.underReview).toString();
    loginStatus=sharedPreferences.getString(SizValue.isLogged).toString();
    reviewMSG=sharedPreferences.getString(SizValue.underReviewMsg).toString();
    reviewRejectMSG=sharedPreferences.getString(SizValue.rejectedReviewMSG).toString();
    incompleteMsg=sharedPreferences.getString(SizValue.incompleteMessage).toString();
    source= sharedPreferences.getString(SizValue.source).toString();

    update();
      
   
      
  

    
  
  }











  bool isLoadingMore=false;
  bool onceCalled=false;
   String lenderId="";

  







  Map<String, dynamic> chatResponse = {};
  List<dynamic> decordedChat = [];
  List<dynamic> tempreverse = [];

  bool refreshOnbacksend=false;
  bool refreshOnbackreceive=false;

    bool userBlock =false;
 

  getChatList(BuildContext context,String lenderID,int pageno,String product,String order) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    //  dialodShow(context);
    try {
      final response = await http.post(Uri.parse(SizValue.chatDetails), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey).toString(),
        'to_user': lenderID,
        'page': pageno.toString(),
        'product': product,
        'order': order
      });

      chatResponse = jsonDecode(response.body);

      print("Chat inside ====  "+chatResponse.toString());

    

    
      if (chatResponse["success"] == true) {

        print(chatResponse.toString());

       


     
        if(chatResponse["user_blocked"].toString()=="1")
      {
   
        userBlock=true;
        update();
    
       

      }

      else{

          userBlock=false;
        update();

      }



        if (pageno == 1) {
         
            tempreverse.clear();
            decordedChat.clear();
            tempreverse.addAll(chatResponse["list"]);
            decordedChat = tempreverse.reversed.toList();
            isLoadingMore=false;
            onceCalled=false;
            update();


         
        } else {
            isLoadingMore=false;
            onceCalled=false;
            decordedChat.addAll(chatResponse["list"]);
            update();
       
        }
      } else if (chatResponse["success"] == false) {
        //  Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(chatResponse["error"].toString(),style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
      }
    } on ClientException {
      // Navigator.pop(context);
      mysnackbar(
          "Server not responding please try again after sometimev fg", context);
    } on SocketException {
      // Navigator.pop(context);
      mysnackbar(
          "No Internet connection 😑 please try again after sometime", context);
    } on HttpException {
      // Navigator.pop(context);
      mysnackbar("Something went wrong please try after sometime", context);
    } on FormatException {
      // Navigator.pop(context);
      mysnackbar("Something went wrong please try after sometime", context);
    }
  }



  // get chat outside ===================================================================================================


  


   bool isLoadingMoreChat = false;
  bool oncesCallChat = false;
  bool noMoreDataChat = false;

    bool showLazyIndicator = false;

  // get chat outside  ========================================================================================================

  Map<String, dynamic> chatResponseOutside = {};
  List<dynamic> decordedChatOutside = [];

  getChatListOutside(int page,String search) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if(page>1)
    {

      showLazyIndicator=true;
      
    }

    //  dialodShow(context);
     try {
      final response = await http.post(Uri.parse(SizValue.chatList), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey),
        'search':search,
        "page":page.toString()
       
      });

       chatResponseOutside = jsonDecode(response.body);

      if (chatResponseOutside["success"] == true) {
       
        

          if (page <= 1) {
             decordedChatOutside = chatResponseOutside["list"];
            isLoadingMoreChat = false;
            oncesCallChat = false;
            update();
          } else {
            decordedChatOutside.addAll(chatResponseOutside["list"]);
            isLoadingMoreChat = false;
            oncesCallChat = false;

            update();
          }

          if (chatResponseOutside["list"].toString() == "[]") {

            noMoreDataChat = true;
            isLoadingMoreChat = false;
            oncesCallChat = false;

            update();
          }


          if(page>1)
    {

      showLazyIndicator=false;
      
    }



          
      
  
      } else if (chatResponseOutside["success"] == false) {


          if(page>1)
    {

      showLazyIndicator=false;
      
    }

        //  Navigator.pop(context);
        // ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text(chatResponseOutside["error"].toString())));
      }
    } on ClientException {

          if(page>1)
    {

      showLazyIndicator=false;
      
    }

      // Navigator.pop(context);
      // mysnackbar(
      //     "Server not responding please try again after sometimev fg", context);
    } on SocketException {

          if(page>1)
    {

      showLazyIndicator=false;
      
    }

      // Navigator.pop(context);
      // mysnackbar(
      //     "No Internet connection 😑 please try again after sometime", context);
    } on HttpException {

          if(page>1)
    {

      showLazyIndicator=false;
      
    }

      // Navigator.pop(context);
      // mysnackbar("Something went wrong please try after sometime", context);
    } on FormatException {


          if(page>1)
    {

      showLazyIndicator=false;
      
    }

      // Navigator.pop(context);
      // mysnackbar("Something went wrong please try after sometime", context);
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

  // pusher =========================================================================================================

   



    Map<String,dynamic> data={};
    Map<String,dynamic> datamessage={};
    Map<String,dynamic> objectlist={};


     PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

  void onConnectPressed() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // Remove keyboard

     try {
      await pusher.init(
        apiKey: "cb8ccaccb762f799083a",
        cluster: "ap2",
        onConnectionStateChange: onConnectionStateChange,
        onError: onError,
        onEvent: onEvent,

        // onAuthorizer: onAuthorizer
      );
      await pusher.subscribe(channelName: sharedPreferences.getString(SizValue.channelId).toString());
      await pusher.connect();
    } catch (e) {
      log("ERROR: $e");
    }
  }

  void onConnectionStateChange(dynamic currentState, dynamic previousState) {
    log("Connection: $currentState");
  }

  void onError(String message, int? code, dynamic e) {
    print("ERROR ==================$message");
    log("onError: $message code: $code exception: $e");
  }

  Future<void> onEvent(PusherEvent event) async {
    // //  data=jsonDecode();

    print("event data ========  ${event.data}");
    data = jsonDecode(event.data.toString());
    
    if (data["message"] == null) {
    } else {
      datamessage = jsonDecode(data["message"].toString());


  
      if (datamessage["from_user"].toString() == lenderId) {



       

           
            
         objectlist = {
        
            "id": "",
            "is_read": "",
            "message": datamessage["message"].toString(),
            "msg_type": datamessage["msg_type"],
            "sender_id": "",
            "receiver_id": "",
            "created_at":  datamessage["date"].toString(),
            "attachment": datamessage["attachment"].toString(),
            "real_name": "8013709a-21c1-40da-9426-a1a76e8109551637584092041-Athena-Black-Blingy-mini-party-dress-with-one-sleeve-detail--2.jpg",
            "file_type": 0,
            "type": datamessage["type"],
            "media_url": datamessage["media_path"].toString(),
            "online": true

            

        };


        refreshOnbackreceive=true;
        decordedChat.insert(0, objectlist);
        update();

  
       
      }

       else
      {

       

        getChatListOutside(1,"");
      }
    }
  }

  void log(String text) {
    print("LOG: $text");
  }











  forseUpdate()
  {
    update();
  }



}