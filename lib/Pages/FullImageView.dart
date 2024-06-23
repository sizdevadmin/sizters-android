// ignore_for_file: must_be_immutable




import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:siz/Utils/Colors.dart';




class FullImageView extends StatefulWidget {

  String imageUrl = "";
  FullImageView({super.key, required this.imageUrl});

  @override
  State<FullImageView> createState() => _FullImageViewState();
}

class _FullImageViewState extends State<FullImageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          

          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(left: 10,top: 55),
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black
                
              ),
              child: const Icon(Icons.close,color: Colors.white,)),
          ),


          Expanded(
            child: PinchZoom(
            
              maxScale: 2.5,
              child: CachedNetworkImage(
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.contain,
                      alignment: Alignment.center,
                      imageUrl: widget.imageUrl,
                      placeholder: (context, url) => Container(
                        alignment: Alignment.center,
                        child: const SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.error,
                        color: MyColors.themecolor,
                      ),
                    ),
            ),
          ),
       
        ],
      ),
    );
  }
}
