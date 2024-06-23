// ignore_for_file: must_be_immutable, use_build_context_synchronously, empty_catches, unused_local_variable
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:info_popup/info_popup.dart';
import 'package:selectable_autolink_text/selectable_autolink_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siz/Controllers/ChatController.dart';
import 'package:siz/Pages/FullImageView.dart';
import 'package:siz/Pages/PhotoUpload.dart';
import 'package:siz/Pages/ProductView.dart';
import 'package:siz/Pages/ProfileView.dart';
import 'package:siz/Pages/RentDetails.dart';
import 'package:siz/Utils/Colors.dart';
import 'dart:io';
import 'package:siz/Utils/Value.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatInside extends StatefulWidget {
  String lenderId = "";
  String product = "";
  String order="";
  ChatInside({super.key, required this.lenderId, required this.product,required this.order});

  @override
  State<ChatInside> createState() => _ChatInsideState();
}

class _ChatInsideState extends State<ChatInside> with WidgetsBindingObserver {
  

   final TextEditingController _editingController=TextEditingController();

    late ChatController chatController=Get.put(ChatController());
    ScrollController scrollController=ScrollController();
    int pageno=1;


  // send message ==================================================================================================
 

  Map<String, dynamic> messageSendResponse = {};
  Map<String, dynamic> object = {};


  sendMessage(String message) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

   
    try {
      final response = await http.post(Uri.parse(SizValue.sendMessage), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey),
        'to_user': widget.lenderId,
        'message': message
      });

      messageSendResponse = jsonDecode(response.body);

      if (messageSendResponse["success"] == true) {




        object={


            "id": "",
            "is_read": 1,
            "message": messageSendResponse["message"].toString(),
            "msg_type": 1,
            "sender_id": "",
            "receiver_id": "",
            "created_at": "${DateTime.now().hour}:${DateTime.now().minute}",
            "attachment": null,
            "real_name": null,
            "file_type": 0,
            "type": 1,
            "media_url": ""

        };


     chatController.refreshOnbacksend=true;
     chatController.decordedChat.insert(0, object);
     chatController.forseUpdate();
    
    
      } else if (messageSendResponse["success"] == false) {
      
        ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text("Something went wrong",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
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


  // unblock  =====================================================

   Map<String, dynamic> unblockuserReponse = {};

  unblockUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    dialodShow(context);

    try {
      final response =
          await http.post(Uri.parse(SizValue.unblockUser), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey).toString(),
        'id': widget.lenderId,
      });

      unblockuserReponse = jsonDecode(response.body);

      

      if (unblockuserReponse["success"] == true) {

        
        
     setState(() {
      chatController. userBlock=false;
     });

     Navigator.pop(context);

       
      } else if (unblockuserReponse["success"] == false) {
         Navigator.pop(context);
       
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



  // block users==============================================================================================

  


  Map<String, dynamic> blockuserReponse = {};

  blockUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    dialodShow(context);

    try {
      final response =
          await http.post(Uri.parse(SizValue.blockUser), body: {
          'user_key': sharedPreferences.getString(SizValue.userKey).toString(),
          'id': widget.lenderId,
      });

      blockuserReponse = jsonDecode(response.body);

      

      if (blockuserReponse["success"] == true) {

        
        


      setState(() {


       chatController. userBlock=true;

          
          
        
      });
       
     


        Navigator.pop(context);
      
       

       
      } else if (blockuserReponse["success"] == false) {

          Navigator.pop(context);
      
       
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



  // report and scam  =====================================================

   Map<String, dynamic> reportScamReponse = {};

  reportScam(String message) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    dialodShow(context);

    try {
      final response =
          await http.post(Uri.parse(SizValue.lenderReport), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey).toString(),
        'id': widget.lenderId,
        'comment':message
      });

      reportScamReponse = jsonDecode(response.body);

      

      if (reportScamReponse["success"] == true) {

            Future.delayed(const Duration(milliseconds: 1), () {
            reportTextdialog();

      });

       Navigator.pop(context);

  

       
      } else if (reportScamReponse["success"] == false) {
         Navigator.pop(context);
      
       
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

   readSms() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      final response = await http.post(Uri.parse(SizValue.updateReadStatus), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey),
        'to_user': widget.lenderId,
      });

      var serverResponse = jsonDecode(response.body);

      if (serverResponse["success"] == true) {


       
      } else {
       
      }
    } on Exception {}
  }



  // getProductDetails =====================================================================================

  updatePushStatus(String status) async {
    
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

   
    try {
      final response =
          await http.post(Uri.parse(SizValue.udpatePushNotification), body: {
        'user_key': sharedPreferences.getString(SizValue.userKey),
        'status': status.toString()
      });

     

    
    }
    catch (e){

      
    }
  }



  


  @override
  void initState() {

    
     

    
     chatController.getChatList(context,widget.lenderId,pageno,widget.product,widget.order);
     chatController.lenderId=widget.lenderId;

      scrollController.addListener(() {

        scrollListener();
        
      }) ;

      updateChatIdForNoti(widget.lenderId);

       WidgetsBinding.instance.addObserver(this);
       
       updatePushStatus("0");
  
    super.initState();
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    updatePushStatus("1");
    super.dispose();
  }


   @override
  void didChangeAppLifecycleState(AppLifecycleState state) {

   

    if(state == AppLifecycleState.paused)
    {
      updatePushStatus("1");
    }

    else if(state == AppLifecycleState.resumed)
    {

       updatePushStatus("0");

    }
    
  }




  updateChatIdForNoti(String chatID) async {

  
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(SizValue.notiID, chatID);
  }


    Future<void> scrollListener() async {
    if (chatController.isLoadingMore) return;

    scrollController.addListener(() {
      if (scrollController.offset >=
          scrollController.position.maxScrollExtent) {
        setState(() {

          if(!chatController.onceCalled)
          {

             chatController.isLoadingMore = true;
             chatController.getChatList(context,widget.lenderId,++pageno,widget.product,widget.order);
             chatController.onceCalled=true;

          }
         
        });
      }
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async {
          

               if(chatController.refreshOnbacksend)
                                {
                                chatController.lenderId="-1";
                                chatController.getChatListOutside(1,"");
                                chatController.decordedChat.clear();
                                chatController.forseUpdate();
                                 Navigator.pop(context);
                                  
                                }

                                else if(chatController.refreshOnbackreceive)
                                {
      


                                 chatController.lenderId="-1";
                                await readSms();
                                chatController.getChatListOutside(1,"");
                                chatController.decordedChat.clear();
                                 chatController.forseUpdate();
                                Navigator.pop(context);

                                }

                                else
                                {
                                 chatController.lenderId="-1";
                                chatController.decordedChat.clear();
                                 chatController.forseUpdate();
                                Navigator.pop(context);

                                }
          
           return false;
        
      },
      child: GetBuilder(
        init: ChatController(),
        builder: (chatController) {
          return Scaffold(

            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              toolbarHeight: 0,
            ),
            resizeToAvoidBottomInset: true,
            body: Column(
              children: [
                // top four icon ===========================
                Container(
                  alignment: Alignment.center,
                  height: 60,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: const BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(255, 216, 216, 216),
                        blurRadius: 2,
                        offset: Offset(0, 2))
                  ]),
                  padding: const EdgeInsets.only(right: 20),
                  child: Row(
                    
                    children: [
                      InkWell(
                          onTap: () async{
                            

                         
               if(chatController.refreshOnbacksend)
                            {
                            chatController.lenderId="-1";
                            chatController.getChatListOutside(1,"");
                            chatController.decordedChat.clear();
                            chatController.forseUpdate();
                            Navigator.pop(context);
                              
                            }

                            else if(chatController.refreshOnbackreceive)
                            {
      


                             chatController.lenderId="-1";
                            await readSms();
                            chatController.getChatListOutside(1,"");
                            chatController.decordedChat.clear();
                             chatController.forseUpdate();
                            Navigator.pop(context);

                            }

                            else
                            {
                             chatController.lenderId="-1";
                            chatController.decordedChat.clear();
                             chatController.forseUpdate();
                            Navigator.pop(context);

                            }


                          
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            width: 50,
                            child:
                                SvgPicture.asset("assets/images/backarrow.svg",width: 20,height: 20,),
                          )),


                             chatController.  chatResponse.isEmpty ?
                                                            
                                const SizedBox(height: 50,width: 50,):
                                                  InkWell(
                                                    onTap: () {
                                                      
                                  if( chatController.chatResponse["user"]["lender_type"].toString()=="2")
                                  {

                                    return;

                                  }

                                  else if( chatController.userBlock==true)
                                  {
                                    return;
                                  }

                                  else
                                  {

                                      navigateAndDisplaySelection(context);

                                    

                                  }
                                                    },
                                                    child: Container(
                                                      width: 50,
                                                      height: 50,
                                                      padding: const EdgeInsets.all(2),
                                                      decoration: const BoxDecoration(
                                                                                   
                                                                                    shape: BoxShape.circle),
                                                      child: ClipRRect(
                                                                                  borderRadius: BorderRadius.circular(1000),
                                                                                  child: CachedNetworkImage(
                                                                                    imageUrl:  chatController.  chatResponse["user"]["profile_img"]  .toString(),
                                                                                          
                                                                                    fit: BoxFit.cover,
                                                                                    height: 50,
                                                                                    width: 50,
                                                                                  ),
                                                      ),
                                                    ),
                                                  ),

                                                   const SizedBox(width: 10),


                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                      if( chatController.chatResponse["user"]["lender_type"].toString()=="2")
                                  {

                                    return;

                                  }

                                   else if( chatController.userBlock==true)
                                  {
                                    return;
                                  }

                                  else
                                  {

                                     navigateAndDisplaySelection(context);

                                  }

     
                                  },
                                  child: Text(
                                          chatController.  chatResponse.isEmpty ?"":       chatController.  chatResponse["user"]["username"]  .toString(),
                                                  overflow: TextOverflow.ellipsis,
                                                style:  GoogleFonts.lexendDeca(
                                      color: Colors.black,
                                      fontSize: 16,
                                      
                                      fontWeight: FontWeight.w300),
                                              ),
                                ),
                              ),

                               


                            chatController.chatResponse.isEmpty?
                            
                            const SizedBox(height: 20,width: 20):
                            
                               chatController.chatResponse["user"]["lender_type"].toString()=="2"?

                              InfoPopupWidget(
                              contentTitle: "This chat is managed by Sizters app support team. You cannot block or report it",
                                contentTheme: InfoPopupContentTheme(
                                infoTextStyle: GoogleFonts.lexendDeca(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300
                                )
                              ),
                              child: const Icon(
                                Icons.info_outline,
                                color: Colors.black,
                                size: 25,
                              ),
                            ):

                              
                                 Container(
                                  transform: Matrix4.translationValues(15, 0, 0),
                                   child: PopupMenuButton<int>(
                                    iconSize: 20,
                                                                 
                                    padding: const EdgeInsets.all(0),
                                    icon: const Icon(
                                                                 Icons.more_horiz_rounded
                                                               ),
                                           onSelected: (item) {
                                   
                                             if(item==0)
                                             {
                                   
                                             blockUser();
                                   
                                             }
                                   
                                             else
                                             {
                                               reportLender();
                                             }
                                   
                                   
                                   
                                           },
                                            itemBuilder: (context) => [
                                           PopupMenuItem<int>(value: 0, child: Text('Block',style: GoogleFonts.lexendDeca(fontWeight: FontWeight.w300),)),
                                              PopupMenuItem<int>(value: 1, child: Text('Report',style: GoogleFonts.lexendDeca(fontWeight: FontWeight.w300))),
                                           ],
                                         ),
                                 ),



                    ],
                  ),
                ),

                 Visibility(
                  visible:chatController.chatResponse.isEmpty?false: chatController.chatResponse["user"]["lender_type"].toString()=="2"?false:true,
                   child: Container(
                    margin: const EdgeInsets.only(left: 10,right:10),
                    child: Text(chatController.chatResponse["chat_top_info"].toString(),
                    textAlign: TextAlign.center,
                    
                    style: GoogleFonts.lexendDeca(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey
                    ),),
                                 ),
                 ),
                Visibility(
                   visible:  chatController.chatResponse.isEmpty? false: chatController.chatResponse["user"]["lender_type"].toString()=="2"?false:true,
                  child: InkWell(
                    onTap: () {
                
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ChatInside(lenderId:"1",product: "",order: "",)));
                
                    },
                    child: Container(
                      
                      margin: const EdgeInsets.only(left: 10,right:10,bottom: 10),
                      child: Text("Sizters support",
                      textAlign: TextAlign.center,
                      
                      style: GoogleFonts.lexendDeca(
                        decoration: TextDecoration.underline,
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: MyColors.themecolor
                      ),),
                    ),
                  ),
                ),


                chatController.isLoadingMore?

                const Padding(padding: EdgeInsets.all(5),
                child: CircularProgressIndicator(),
                ):
                Container(),
    
                // list
    
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    reverse: true,
                    controller: scrollController,
                    itemCount:  chatController.  decordedChat.length,
                    shrinkWrap: true,
                    itemBuilder: (context,index){
                
                
                
                
                
                  return   chatController. decordedChat[index]["type"]==2?
                
                
                // from send side =====================================================================================================
    
 
                       chatController. decordedChat[index]["msg_type"]==2?
    
    
                                                      // image ===========================================================================
                                                      
                                                Container(
                                                    margin: const EdgeInsets.only(left: 10, right: 50, bottom: 5, top: 5),
                                                    padding: const EdgeInsets.all(5),
                                                    decoration: const BoxDecoration(color:  Color.fromARGB(31, 175, 16, 16), borderRadius: BorderRadius.only(topLeft: Radius.circular(0), topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
                                                
                                                    // wrap
                                                    child: Wrap(
                                                      alignment:
                                                          WrapAlignment.center,
                                                      crossAxisAlignment:
                                                          WrapCrossAlignment
                                                              .center,
                                                      children: [
                                                        // image view ============================================================================================================================
                                                        ClipRRect(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                                  Radius.circular(
                                                                      10)),
                                                          child: InkWell(
                                                            onTap: () {
                                                             Navigator.push(context, MaterialPageRoute(builder: (context)=>FullImageView(imageUrl: chatController
                                                                    .decordedChat[
                                                                        index][
                                                                        "media_url"]
                                                                    .toString(),)));
                                                            },
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl: chatController
                                                                  .decordedChat[
                                                                      index][
                                                                      "media_url"]
                                                                  .toString(),
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              height: 150,
                                                              fit: BoxFit.cover,
                                                              placeholder:
                                                                  (context,
                                                                          url) =>
                                                                      Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: const SizedBox(
                                                                    width: 50,
                                                                    height: 50,
                                                                    child:
                                                                        CircularProgressIndicator()),
                                                              ),
                                                              errorWidget:
                                                                  (context, url,
                                                                          error) =>
                                                                      const Icon(
                                                                Icons.error,
                                                                color: Colors.red,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                
                                                
                                                
                                                        Container(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          margin: const EdgeInsets
                                                              .only(
                                                              left: 15, top: 5),
                                                          child:  Text(
                                                            // chatController
                                                            //     .decordedChat[
                                                            //         index]["date"]
                                                            //     .toString(),
                                                          chatController
                                                                .decordedChat[
                                                                    index]["created_at"]
                                                                .toString(),
                                                            textAlign:
                                                                TextAlign.right,
                                                            style:
                                                                 GoogleFonts.lexendDeca(
                                                              color: MyColors.themecolor,
                                                              fontSize: 10,
                                                              fontWeight: FontWeight.w300
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    )):
                
                  Wrap(children: [
                                                        Container(
                                                          margin:
                                                              const EdgeInsets.only(
                                                                  left: 10,
                                                                  right: 50,
                                                                  bottom: 5,
                                                                  top: 5),
                                                          padding:
                                                              const EdgeInsets.only(
                                                                  left: 20,
                                                                  right: 20,
                                                                  top: 10,
                                                                  bottom: 10),
                                                          decoration: const BoxDecoration(
                                                              color:
                                                                   Color.fromARGB(31, 175, 16, 16),
                                                              borderRadius:
                                                                  BorderRadius.only(
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              0),
                                                                      topRight: Radius
                                                                          .circular(
                                                                              10),
                                                                      bottomLeft: Radius
                                                                          .circular(
                                                                              10),
                                                                      bottomRight: Radius
                                                                          .circular(
                                                                              10))),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                     .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SelectableAutoLinkText(
                                                                decordedResponse(
                                                                   chatController. decordedChat[
                                                                          index]
                                                                          ["message"]
                                                                      .toString(),
                                                                ),
                
                                                                style:
                                                                    GoogleFonts.lexendDeca(
                                                                      fontWeight: FontWeight.w300,
                                                                  color: Colors.black,
                                                                  fontSize: 14,
                                                                ),
                
                                                                linkStyle:
                                                                    GoogleFonts.lexendDeca(
                                                                       fontWeight: FontWeight.w300,
                                                                        color: Colors

                                                                            .blueAccent),
                                                                highlightedLinkStyle:
                                                                    GoogleFonts.lexendDeca(
                                                                       fontWeight: FontWeight.w300,
                                                                  color: Colors
                                                                      .blueAccent,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .blueAccent
                                                                          .withAlpha(
                                                                              0x33),
                                                                ),
                                                                onTap: (url) =>
                                                                    launchUrl(
                                                                        Uri.parse(
                                                                            url)),
                                                                // onLongPress: (url) => Share.share(url),
                                                              ),
                                                              const SizedBox(
                                                                  height: 5),
                                                               Text(
                                                          chatController
                                                                .decordedChat[
                                                                    index]["created_at"]
                                                                .toString(),
                                                                textAlign:
                                                                    TextAlign.right,
                                                                style:
                                                                     GoogleFonts.lexendDeca(
                                                                  fontWeight:
                                                                      FontWeight.w300,
                                                                  color: MyColors.themecolor,
                                                                  fontSize: 10,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ])




                                                      
                                                                                                      
                              
                                                      :


                                                      chatController. decordedChat[index]["type"]==3?



                                                      InkWell(
                                                        onTap: () {


                                                          if(chatController.userBlock==true)
                                                          {
                                                            return;
                                                          }
                                                          else
                                                          {

                                                              Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductView( index: 0, comesFrom: "", id: chatController
                                                                    .decordedChat[
                                                                        index][
                                                                        "product_id"]
                                                                    .toString(),
                                                                     fromCart: false,
                                                                    
                                                                    )));

                                                          }
                                                       
                                                        },
                                                        child: Container(
                                                      
                                                          padding: const EdgeInsets.all(10),
                                                          
                                                          width: MediaQuery.of(context).size.width,
                                                          margin: const EdgeInsets.only(left: 120,right: 20,top: 20,bottom: 20),
                                                          alignment: Alignment.centerRight,
                                                          decoration: const BoxDecoration(
                                                            color: Color(0xffF6F5F1),
                                                            boxShadow: [BoxShadow(
                                                              color: Colors.grey,
                                                              blurRadius: 5
                                                            )],
                                                       
                                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                                          
                                                          ),
                                                          child: Column(
                                                          
                                                         
                                                            children: [
                                                              CachedNetworkImage(imageUrl: chatController
                                                                    .decordedChat[
                                                                        index][
                                                                        "media_url"]
                                                                    .toString(),
                                                                    width: MediaQuery.of(context).size.width,
                                                                    height: 100,
                                                                    fit: BoxFit.cover,
                                                                    
                                                                    ),
                                                                    const SizedBox(height: 10),
                                                              SelectableAutoLinkText(
                                                                  decordedResponse(
                                                                     chatController. decordedChat[
                                                                            index]
                                                                            ["message"]
                                                                        .toString(),
                                                                  ),
                                                      
                                                                  textAlign: TextAlign.center,
                                                                      
                                                                  style:
                                                                      GoogleFonts.lexendDeca(
                                                                    color: Colors.black,
                                                                     fontWeight: FontWeight.w300,
                                                                    fontSize: 14,
                                                                  ),
                                                                      
                                                                  linkStyle:
                                                                      GoogleFonts.lexendDeca(
                                                                         fontWeight: FontWeight.w300,
                                                                          color: Colors
                                                                              .blueAccent),
                                                                  highlightedLinkStyle:
                                                                      GoogleFonts.lexendDeca(
                                                                         fontWeight: FontWeight.w300,
                                                                    color: Colors
                                                                        .blueAccent,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .blueAccent
                                                                            .withAlpha(
                                                                                0x33),
                                                                  ),
                                                                  onTap: (url) =>
                                                                      launchUrl(
                                                                          Uri.parse(
                                                                              url)),
                                                                  // onLongPress: (url) => Share.share(url),
                                                                ),
                                                            ],
                                                          ),
                                                        ),
                                                      ):




                                                      chatController. decordedChat[index]["type"]==4?



                                                      InkWell(
                                                        onTap: () {



                                                              Navigator.push(context, MaterialPageRoute(builder: (context)=>RentDetails(productId: chatController
                                                                    .decordedChat[
                                                                        index][
                                                                        "order_id"]
                                                                    .toString())));

                                                          
                                                       
                                                        },
                                                        child: Container(
                                                      
                                                          padding: const EdgeInsets.all(10),
                                                          
                                                          width: MediaQuery.of(context).size.width,
                                                          margin: const EdgeInsets.only(left: 120,right: 20,top: 20,bottom: 20),
                                                          alignment: Alignment.centerRight,
                                                          decoration: const BoxDecoration(
                                                            color: Color(0xffF6F5F1),
                                                            boxShadow: [BoxShadow(
                                                              color: Colors.grey,
                                                              blurRadius: 5
                                                            )],
                                                       
                                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                                          
                                                          ),
                                                          child: Column(
                                                          
                                                         
                                                            children: [
                                                              CachedNetworkImage(imageUrl: chatController
                                                                    .decordedChat[
                                                                        index][
                                                                        "media_url"]
                                                                    .toString(),
                                                                    width: MediaQuery.of(context).size.width,
                                                                    height: 100,
                                                                    fit: BoxFit.cover,
                                                                    
                                                                    ),
                                                                    const SizedBox(height: 10),
                                                              SelectableAutoLinkText(
                                                                  decordedResponse(
                                                                     chatController. decordedChat[
                                                                            index]
                                                                            ["message"]
                                                                        .toString(),
                                                                  ),
                                                      
                                                                  textAlign: TextAlign.center,
                                                                      
                                                                  style:
                                                                      GoogleFonts.lexendDeca(
                                                                    color: Colors.black,
                                                                     fontWeight: FontWeight.w300,
                                                                    fontSize: 14,
                                                                  ),
                                                                      
                                                                  linkStyle:
                                                                      GoogleFonts.lexendDeca(
                                                                         fontWeight: FontWeight.w300,
                                                                          color: Colors
                                                                              .blueAccent),
                                                                  highlightedLinkStyle:
                                                                      GoogleFonts.lexendDeca(
                                                                         fontWeight: FontWeight.w300,
                                                                    color: Colors
                                                                        .blueAccent,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .blueAccent
                                                                            .withAlpha(
                                                                                0x33),
                                                                  ),
                                                                  onTap: (url) =>
                                                                      launchUrl(
                                                                          Uri.parse(
                                                                              url)),
                                                                  // onLongPress: (url) => Share.share(url),
                                                                ),
                                                            ],
                                                          ),
                                                        ),
                                      )


                                               




                                                      :





                                                       // from my side ==========================================================================================                                 
    
    
                                                      chatController. decordedChat[index]["msg_type"]==2?
    
    
                                                      // image ===========================================================================
                                                      
                                                Container(
                                                    margin: const EdgeInsets.only(left: 50, right: 10, bottom: 5, top: 5),
                                                    padding: const EdgeInsets.all(5),
                                                    decoration: const BoxDecoration(color: Color.fromARGB(255, 224, 224, 224), borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(0), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
    
                                                    // wrap
                                                    child: Wrap(
                                                      alignment:
                                                          WrapAlignment.center,
                                                      crossAxisAlignment:
                                                          WrapCrossAlignment
                                                              .center,
                                                      children: [
                                                        // image view ============================================================================================================================
                                                        ClipRRect(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                                  Radius.circular(
                                                                      10)),
                                                          child: InkWell(
                                                            onTap: () {
                                                            Navigator.push(context, MaterialPageRoute(builder: (context)=>FullImageView(imageUrl: chatController
                                                                    .decordedChat[
                                                                        index][
                                                                        "media_url"]
                                                                    .toString(),)));
                                                            },
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl: chatController
                                                                  .decordedChat[
                                                                      index][
                                                                      "media_url"]
                                                                  .toString(),
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              height: 150,
                                                              fit: BoxFit.cover,
                                                              placeholder:
                                                                  (context,
                                                                          url) =>
                                                                      Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: const SizedBox(
                                                                    width: 50,
                                                                    height: 50,
                                                                    child:
                                                                        CircularProgressIndicator()),
                                                              ),
                                                              errorWidget:
                                                                  (context, url,
                                                                          error) =>
                                                                      const Icon(
                                                                Icons.error,
                                                                color: Colors.red,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
    
    
    
                                                        Container(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          margin: const EdgeInsets
                                                              .only(
                                                              right: 10, top: 5),
                                                          child:  Text(
                                                            chatController
                                                                .decordedChat[
                                                                    index]["created_at"]
                                                                .toString(),
                                                           
                                                            textAlign:
                                                                TextAlign.right,
                                                            style:
                                                                GoogleFonts.lexendDeca(
                                                                   fontWeight: FontWeight.w300,
                                                              color: const Color(
                                                                  0xff898989),
                                                              fontSize: 10,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ))
                                                     
                                                      // simple message ===========================================================================
                                                     
                                                     :Stack(
                                                      alignment: Alignment.centerRight,
                                                      
                                                      children: [
                                                        Container(
                                                          margin:
                                                              const EdgeInsets.only(
                                                                  left: 50,
                                                                  right: 10,
                                                                  bottom: 5,
                                                                  top: 5),
                                                          padding:
                                                              const EdgeInsets.only(
                                                                  left: 20,
                                                                  right: 20,
                                                                  top: 10,
                                                                  bottom: 10),
                                                          decoration: const BoxDecoration(
                                                              color:
                                                                  Color.fromARGB(255, 224, 224, 224),
                                                              borderRadius:
                                                                  BorderRadius.only(
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              10),
                                                                      topRight: Radius
                                                                          .circular(
                                                                              0),
                                                                      bottomLeft: Radius
                                                                          .circular(
                                                                              10),
                                                                      bottomRight: Radius
                                                                          .circular(
                                                                              10))),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              SelectableAutoLinkText(
                                                                decordedResponse(
                                                                 chatController.   decordedChat[
                                                                          index]
                                                                          ["message"]
                                                                      .toString(),
                                                                ),
                
                                                                style:
                                                                   GoogleFonts.lexendDeca(
                                                                     fontWeight: FontWeight.w300,
                                                                  color: Colors.black,
                                                                  fontSize: 14,
                                                                ),
                
                                                                linkStyle:
                                                                    GoogleFonts.lexendDeca(
                                                                       fontWeight: FontWeight.w300,
                                                                        color: Colors
                                                                            .blueAccent),
                                                                highlightedLinkStyle:
                                                                    GoogleFonts.lexendDeca(
                                                                       fontWeight: FontWeight.w300,
                                                                  color: Colors
                                                                      .blueAccent,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .blueAccent
                                                                          .withAlpha(
                                                                              0x33),
                                                                ),
                                                                onTap: (url) =>
                                                                    launchUrl(
                                                                        Uri.parse(
                                                                            url)),
                                                                // onLongPress: (url) => Share.share(url),
                                                              ),
                                                              const SizedBox(
                                                                  height: 5),
                                                               Text(
                                                           chatController
                                                                .decordedChat[
                                                                    index]["created_at"]
                                                                .toString(),
                                                                textAlign:
                                                                    TextAlign.right,
                                                                style:
                                                                    GoogleFonts.lexendDeca(
                                                                  fontWeight:
                                                                      FontWeight.w300,
                                                                  color: const Color(
                                                                      0xff898989),
                                                                  fontSize: 10,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ]);
                
                
                
                  
                  
                  }),
                ),
    
    
                // bottom sender ============================================================================================
    
    
      chatController.  userBlock?


       Container(

        margin: const EdgeInsets.only(top: 10),
        

    width: MediaQuery.of(context).size.width,


    decoration: const BoxDecoration(
      color: Color.fromARGB(255, 236, 236, 236)
    ),

    child: Column(
      children: [

       Container(
        margin: const EdgeInsets.only(top: 20),
        child: Text("You blocked this account",style: GoogleFonts.lexendDeca(

          fontSize: 16,
          fontWeight: FontWeight.w300
        ),),
       ),
       Container(
        margin: const EdgeInsets.only(top: 10 ,bottom: 20),
        child: Text("You can't message with ${chatController.  chatResponse["user"]["username"]}",style: GoogleFonts.lexendDeca(
          color: Colors.grey,
          fontSize: 14,
          fontWeight: FontWeight.w300
        ),),
       ),


         Row(
                                  children: [

                                    Flexible(
                                      child: InkWell(
                                        onTap: () {
                                         
                                          Navigator.pop(context,"true");
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.only(left: 20,right:5),
                                          decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Colors.black,
                                        ),
                                          width: MediaQuery.of(context).size.width,
                                          height: 40,
                                      
                                          child: Text("GO BACK",style: GoogleFonts.lexendExa(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300
                                          ),),
                                        ),
                                      ),
                                    ),
                                   Flexible(
                                      child: InkWell(
                                        onTap: () {
                                           unblockUser();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: Colors.black,
                                          ),
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.only(left: 5,right:20),
                                          
                                          width: MediaQuery.of(context).size.width,
                                          height: 40,
                                      
                                          child: Text("UNBLOCK",style: GoogleFonts.lexendExa(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300
                                          ),),
                                        ),
                                      ),
                                    ),

                                  ],
                                ),


       const SizedBox(height: 30,)

      ],
    ),



       )
       :

                Container(
                            margin: const EdgeInsets.only(
                                bottom: 30, left: 15, right: 15, top: 10),
                            child: Row(
                              children: [
                                InkWell(
                                    onTap: () async {
    
                                       final ImagePicker
                                                              picker =
                                                              ImagePicker();
    
                                                          final XFile? image =
                                                              await picker.pickImage(
                                                                  imageQuality:
                                                                      60,
                                                                  source:
                                                                      ImageSource
                                                                          .gallery);
    
                                                         
                                                          if (image != null) {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            PhotoUpload(
                                                                              imagefile:
                                                                                  image.path,
                                                                              chatId:
                                                                                  widget.lenderId,
                                                                            )));
                                                          }
                                   
                                    },
                                    child:
                                        const Icon(Icons.image,color: Colors.grey,)),
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    padding:
                                        const EdgeInsets.only(left: 20, right: 10),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color(0xffDBDBDB), width: 1),
                                        borderRadius: BorderRadius.circular(50)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: TextFormField(

                                            style:  GoogleFonts.lexendDeca(
                                                   fontWeight: FontWeight.w300,
                                                   color: Colors.black,

                                                  fontSize: 16
                                                ),

                                                 textInputAction: TextInputAction.send,
                                           
                                            showCursor: true,
                                            onEditingComplete: () {


                                               if (_editingController.text.isEmpty) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar( SnackBar(
                                                  content:
                                                      Text("Please type something",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white),),
                                                  duration:
                                                      const Duration(milliseconds: 300),
                                                ));
                                              } else {
                                                 
                                                   sendMessage(_editingController.text);
                                                  _editingController.text = "";
    
                                              
                                              }


                                            }, 
                                            controller: _editingController,
                                            decoration:  InputDecoration(
                                                border: InputBorder.none,
                                                hintText: "Your Message Here",
                                                hintStyle: GoogleFonts.lexendDeca(
                                                   fontWeight: FontWeight.w300,
                                                   color: Colors.grey,

                                                  fontSize: 16
                                                )
                                                
                                                
                                                ),
                                          ),
                                        ),
                                        InkWell(
                                            onTap: () {
                                            
                                              if (_editingController.text.isEmpty) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar( SnackBar(
                                                  content:
                                                      Text("Please type something",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white),),
                                                  duration:
                                                      const Duration(milliseconds: 300),
                                                ));
                                              } else {
                                                 
                                                   sendMessage(_editingController.text);
                                                  _editingController.text = "";
    
                                              
                                              }
                                            },
                                            child:Container(
                                              width: 25,
                                              height: 25,
                                              color: Colors.white,
                                              child: SvgPicture.asset("assets/images/arrowright.svg")))
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
    
    
    
    
              ],
            ),
          );
        }
      ),
    );
  }

   decordedResponse(String response) {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    return stringToBase64.decode(response);
  }





   

   reportLender() {
  return

      // logut yes or no

      showModalBottomSheet(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10))),
          context: context,
          builder: (context) {
               
          
          return Wrap(children: [
                Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 20),
                    
                    child: Column(
                    
                      children: [

                      Container(
                            alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 10),
                   
                   child: Text("Report",style:GoogleFonts.lexendDeca(
                      fontSize: 18,
                      fontWeight: FontWeight.w300
                   )),
                  ),

                        Container(
                            alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 10,bottom: 10),
                    width: 35,
                    height: 2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: const Color(0xff9D9D9D)),
                  ),

                    Container(
                            alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 0,left: 20,right:20),
                   
                   child: Text("This will only be shared with Sizters App support team. We aim to get back to you within 1 business day.",
                   
                   
                   style:GoogleFonts.lexendDeca(
                      fontSize: 14,
                      color: Colors.grey,

                      fontWeight: FontWeight.w300
                   )),
                  ),

                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    reportScam("User is asking for payment outside the Sizters App");
                      
                    },
                    child: Container(
                       margin: const EdgeInsets.only(left: 20,right:20,top: 30),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text("User is asking for payment outside the Sizters App",style: GoogleFonts.lexendDeca(
                              fontSize: 16,
                              fontWeight: FontWeight.w300
                            ),),
                          ),
                    
                    
                          const Icon(Icons.arrow_forward_ios,size: 15,)
                        ],
                      ),
                    ),
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 1,
                    color: const Color.fromARGB(255, 235, 235, 235),
                    margin: const EdgeInsets.only(left: 30,right: 30,top: 20,bottom:20),
                  ),

                   InkWell(
                    onTap: () {
                      Navigator.pop(context);
                       reportScam("User has damaged or lost an item");
                      
                    },
                    child: Container(
                       margin: const EdgeInsets.only(left: 20,right:20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text("User has damaged or lost an item",style: GoogleFonts.lexendDeca(
                              fontSize: 16,
                              fontWeight: FontWeight.w300
                            ),),
                          ),
                    
                    
                          const Icon(Icons.arrow_forward_ios,size: 15,)
                        ],
                      ),
                    ),
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 1,
                    color: const Color.fromARGB(255, 235, 235, 235),
                    margin: const EdgeInsets.only(left: 30,right: 30,top: 20,bottom:20),
                  ),


                  

                  InkWell(
                    onTap: () {

                      Navigator.pop(context);

                    reportScam("User is inappropriate");
                      
                    },
                    child: Container(
                       margin: const EdgeInsets.only(left: 20,right:20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text("User is inappropriate",style: GoogleFonts.lexendDeca(
                              fontSize: 16,
                              fontWeight: FontWeight.w300
                            ),),
                          ),
                    
                    
                          const Icon(Icons.arrow_forward_ios,size: 15,)
                        ],
                      ),
                    ),
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 1,
                    color: const Color.fromARGB(255, 235, 235, 235),
                    margin: const EdgeInsets.only(left: 30,right: 30,top: 20,bottom:20),
                  ),


                     InkWell(
                      onTap: () {

                        Navigator.pop(context);
                        reportScam("User is unresponsive");
                        
                      },
                       child: Container(
                        margin: const EdgeInsets.only(left: 20,right:20),
                                         child: Row(
                        children: [
                          Expanded(
                            child: Text("User is unresponsive",style: GoogleFonts.lexendDeca(
                              fontSize: 16,
                              fontWeight: FontWeight.w300
                            ),),
                          ),
                                       
                                       
                          const Icon(Icons.arrow_forward_ios,size: 15,)
                        ],
                                         ),
                                       ),
                     ),

              
                

             
                    

                          const SizedBox(height: 30),
                      ],
                    )),
              ]);
            }
          
          
          
          
          );
}

   



    Future<void> navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  ProfileView(lenderId: widget.lenderId)),
    );

  
    if (!context.mounted) return;

    if(result.toString()=="true")
    {

       setState(() {
        chatController.  userBlock=true;
       });

    }


    
    
  }


reportTextdialog()
{
  return showGeneralDialog(
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
                                "Thank you, we received you report",textAlign: TextAlign.center,style: GoogleFonts.lexendDeca(fontSize: 18,fontWeight: FontWeight.w400),),
                            const SizedBox(height: 10,),
                            
                             Text(
                                "While you wait for our decision, we'd like you to know that you can choose to block this account",textAlign: TextAlign.center,style: GoogleFonts.lexendDeca(fontSize: 14,fontWeight: FontWeight.w300),),



                     const SizedBox(height: 15),               

   
                    Row(
                                  children: [

                                    Flexible(
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                         
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.only(left: 20,right:5),
                                          decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Colors.black,
                                        ),
                                          width: MediaQuery.of(context).size.width,
                                          height: 40,
                                      
                                          child: Text("OK",style: GoogleFonts.lexendExa(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300
                                          ),),
                                        ),
                                      ),
                                    ),
                                   Flexible(
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                         blockUser();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: Colors.black,
                                          ),
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.only(left: 5,right:20),
                                          
                                          width: MediaQuery.of(context).size.width,
                                          height: 40,
                                      
                                          child: Text("BLOCK",style: GoogleFonts.lexendExa(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300
                                          ),),
                                        ),
                                      ),
                                    ),

                                  ],
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

