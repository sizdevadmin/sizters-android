// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:siz/Utils/Colors.dart';

class AppProductImageView extends StatefulWidget {
  List<dynamic> imageslist=[];

  AppProductImageView({super.key ,required this.imageslist});
  @override
  State<AppProductImageView> createState() => _AppProductImageViewState();
}

class _AppProductImageViewState extends State<AppProductImageView> {
  


  int pageviewPosition=0;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [

             PageView.builder(
              onPageChanged: (value) {

                setState(() {
                  pageviewPosition=value;
                });
                
              },
              scrollDirection: Axis.horizontal,
              
              physics: const BouncingScrollPhysics(),
              itemCount: widget.imageslist.length,
              
              
              itemBuilder: (context,index){
    
                return PinchZoom(
                  child: Container(
                    margin: const EdgeInsets.only(left: 5,right: 5),
                    child: CachedNetworkImage(imageUrl: widget.imageslist[index].toString(),
                    
                    fit: BoxFit.contain,
                    
                    
                    ),
                  ),
                );
             
             
             }),
    
    
               Positioned(
            left: 0,
            top: 0,
             child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
               child: Container(
                margin: const EdgeInsets.all(10),
                width: 60,height: 60,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(135, 0, 0, 0),
                        
                  shape: BoxShape.circle,
                        
                ),
                        
                child: const Icon(Icons.close,color: Colors.white,size: 30,),
               ),
             ),
           ),


           Positioned(
            bottom: 0,
            left: 0,
            right: 0,
             child: Container(
              margin: const EdgeInsets.only(bottom: 20),
               child: PageViewDotIndicator(
                unselectedSize: const Size(5, 5),
               currentItem: pageviewPosition,
               count: widget.imageslist.length,
               unselectedColor: Colors.white,
               selectedColor: MyColors.themecolor,
                        ),
             ),
           )
    
    
            
          ],
        ),
      ),
    );
  }
}