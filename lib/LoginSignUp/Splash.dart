// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'package:siz/Pages/Home.dart';
import 'package:siz/Utils/Colors.dart';


class Splash extends StatefulWidget {
  
   Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  
  bool startAnimation = false;
  
  @override
  void initState() {
    super.initState();


    

    Future.delayed(const Duration(milliseconds: 200), () {

     
     if(mounted)
     {

       setState(() {
        startAnimation = true;
      });

     }

      
     
    });


    Future.delayed(const Duration(milliseconds: 1500), () async {



       reDirect();


      
     });


  }



reDirect() async
{
    
  
  if(mounted)
  {

      Navigator.pushAndRemoveUntil(context,  PageTransition(
                        duration: const Duration(milliseconds: 500),
                          type: PageTransitionType.rightToLeft,
                          child: const Home(),
                          isIos: true), (route) => false);

  }
     
  
       
    
  
       

  
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.themecolor,
      body:Column(
          mainAxisAlignment: MainAxisAlignment.center,
         crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedContainer(
            curve: Curves.easeOutQuint,
            duration: const Duration(milliseconds: 800),
            margin: const EdgeInsets.only(left: 15,right: 15),
            transform: startAnimation
                  ? Matrix4.translationValues(0, 0, 0)
                  : Matrix4.translationValues(0, -500, 0),
            child: Image.asset("assets/images/heyicon.png"))
        ],
      ),
    
    );
  }
}
