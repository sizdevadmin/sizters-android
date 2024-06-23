// ignore_for_file: non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings, use_build_context_synchronously

import 'dart:convert';


import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:siz/Pages/AllOrderRequest.dart';
import 'package:siz/Pages/ChatInside.dart';

import 'package:siz/Pages/MyListing.dart';
import 'package:siz/Pages/RentDetails.dart';
import 'package:siz/Utils/Colors.dart';


class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  // android channel id

  final _androidChannel = const AndroidNotificationChannel(
      "high_importance_channel", "High Importance Notifications",
      description: "This is the testing channel",
        playSound: true,
      importance: Importance.max);

      // instance of local notification

      

  final _localNotifications = FlutterLocalNotificationsPlugin();

  // hangle message

  void handleMessage(BuildContext context,  RemoteMessage? message) {
    if (message == null) return;

    print(message.data.toString());


    if(message.data["event"].toString()=="chat")
    {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatInside(lenderId: message.data["from_user"].toString(), product: "",order: "",)));
    }

    else if(message.data["event"].toString()=="order_received")
    {

       Navigator.push(context, MaterialPageRoute(builder: (context)=>const AllOrderRequest()));

    }
    else if(message.data["event"].toString()=="order_reviewed")
    {

       Navigator.push(context, MaterialPageRoute(builder: (context)=>RentDetails(productId: message.data["order"].toString())));

    }
    else if(message.data["event"].toString()=="product_reviewed")
    {

       Navigator.push(context, MaterialPageRoute(builder: (context)=>MyListing(fromListing: false, initialIndex: 0)));

    }

   
  }
  // ini local notification

  Future initLocalNotifications(BuildContext context) async
  {



    const iOS=DarwinInitializationSettings();
    const android=AndroidInitializationSettings('@drawable/notiicon');
    const settings=InitializationSettings(android: android,iOS: iOS);


    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (payload) {

          
        final message =RemoteMessage.fromMap(jsonDecode(payload.payload.toString()));
        handleMessage(context,  message);
      },
    );

    final platform=_localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);


  }

  // push notification instances

  Future initPushNotifications(BuildContext context) async {

    // SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);

   
    FirebaseMessaging.instance.getInitialMessage().then((value){


      handleMessage(context, value);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });

   
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((message) {   


      final notification = message.notification;
      if (notification == null) return;

    

     
       _localNotifications.show(
          notification.hashCode,
          notification.title,
          
          notification.body,
          
          NotificationDetails(
              android: AndroidNotificationDetails(
                  _androidChannel.id, _androidChannel.name,
                  channelDescription: _androidChannel.description,
                  icon: '@drawable/notiicon',
                  color: MyColors.themecolor
                  
                  )),
                   payload: jsonEncode(message.toMap())
                  );


        
        if(message.data["event"].toString()=="order_received")
        {
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
                        padding: const EdgeInsets.only(left: 30,right: 20),
                        height: 219,
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
                             Container(
                              alignment: Alignment.center,
                              width: 280,
                               child: Text(
                                 message.data["remark"].toString(),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis
                               ,textAlign: TextAlign.center,style: GoogleFonts.lexendDeca(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                             
                                color: Colors.black
                                
                                ),),
                             ),
                  
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                   Navigator.push(context, MaterialPageRoute(builder: (context)=>const AllOrderRequest()));
                                  },
                                  child: Container(
                                    width: 240,
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(top: 20),
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: MyColors.themecolor,
                                      borderRadius: BorderRadius.circular(5)
                                    ),
                                    child:  Text("REQUESTS",
                                    textAlign: TextAlign.center,
                                   style: GoogleFonts.lexendExa(
        
        fontSize: 16,color: Colors.white,fontWeight: FontWeight.w300)),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    width: 240,
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(top: 20),
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffF6F5F1),
                                      borderRadius: BorderRadius.circular(5)
                                    ),
                                    child:  Text("SKIP",
                                    textAlign: TextAlign.center,
                                   style: GoogleFonts.lexendExa(
        
        fontSize: 16,color: Colors.black,fontWeight: FontWeight.w300)),
                                  ),
                                )
                          ],
                        )),
                      ),
                    ),
                  );
                },
              );



        }
      
  

      
    });
  }

  Future<void> initNotifications(BuildContext context) async {
    await _firebaseMessaging.requestPermission();
    
    initPushNotifications(context);
    initLocalNotifications(context);
  }
}

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print("Title: ${message.notification?.title}");
  print("Body: ${message.notification?.body}");
  print("Payload: ${message.data}");
}
