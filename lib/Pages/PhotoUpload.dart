// ignore_for_file: must_be_immutable, unused_local_variable, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:google_fonts/google_fonts.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siz/Controllers/ChatController.dart';
import 'package:siz/Utils/Colors.dart';
import 'package:siz/Utils/Value.dart';

class PhotoUpload extends StatefulWidget {
  String imagefile;
  String chatId;
  PhotoUpload({super.key, required this.imagefile, required this.chatId});

  @override
  State<PhotoUpload> createState() => _PhotoUploadState();
}

class _PhotoUploadState extends State<PhotoUpload> {
  encordedResponse(String response) {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    return stringToBase64.encode(response);
  }

  int processindicator = 0;
  String captionValue = "";

  bool showDialog = false;
  Map<String, dynamic> objectlist = {};
  Map<String, dynamic> photoUploadResponse = {};



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: FileImage(File(widget.imagefile)),
              fit: BoxFit.cover,
            )),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      alignment: Alignment.centerLeft,
                      margin:
                          const EdgeInsets.only(left: 10, top: 55, bottom: 20),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      )),
                ),
                Visibility(
                    visible: showDialog,
                    child: const CircularProgressIndicator()),
                Container(
                  margin: const EdgeInsets.only(left: 15, right: 15),
                  child: InkWell(
                    onTap: () async {
                      setState(() {
                        showDialog = true;
                      });

                      SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();

                      final dio = Dio();
                      List<dynamic>? documents = [];

                      documents.add(await MultipartFile.fromFile(
                          widget.imagefile,
                          filename: widget.imagefile.split("/").last,
                          contentType: MediaType('image', 'png')));

                      final formData = FormData.fromMap({
                        'user_key':
                            sharedPreferences.getString(SizValue.userKey),
                        'to_user': widget.chatId,
                       
                        'media': documents
                      });

                      try {
                        final response = await dio.post(
                          SizValue.sendAttachment,
                          data: formData,
                          onSendProgress: (count, total) {
                            setState(() {
                              processindicator = int.parse(
                                  (count / total * 100).toStringAsFixed(0));
                              print(processindicator.toString());
                            });
                          },
                        ).timeout(const Duration(hours: 1));
                       
                        

                          photoUploadResponse=jsonDecode(response.data);

                          if(photoUploadResponse["success"]==true)
                          {

                             

                           ChatController controller =
                              Get.put(ChatController());




                        
                            objectlist = {
                              "id": 69,
                              "is_read": 1,
                              "message": "",
                              "msg_type": 2,
                              "sender_id": 2,
                              "receiver_id": 3,
                              "created_at": "${DateTime.now().hour}:${DateTime.now().minute}",
                              "attachment": photoUploadResponse["attachment"].toString(),
                              "real_name": "cartempty.png",
                              "file_type": 0,
                              "type": 1,
                              "media_url": photoUploadResponse["media_url"].toString(),
                              "online": true
                            };

                            controller.decordedChat.insert(0, objectlist);

                            controller.forseUpdate();
                        

                          showDialog = false;
                          Navigator.pop(context);

                          }

                        
                      } on DioException catch (e) {
                        setState(() {
                          // showUploadingDialog = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(e.toString(),style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white)),
                          duration: const Duration(days: 365),
                        ));
                      }
                    },
                    child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: MyColors.themecolor,
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
