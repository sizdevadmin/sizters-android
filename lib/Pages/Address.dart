import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:siz/Pages/Cart.dart';
import 'package:siz/Pages/Wishlist.dart';
import 'package:siz/Utils/Colors.dart';

class Address extends StatefulWidget {
  const Address({super.key});

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [

          // top four icons ==============================================================================================

          Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: ()
                  {

                    Navigator.pop(context);
                  },
                  child: SvgPicture.asset("assets/images/backarrow.svg")),
                Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: const Text(
                      "Add Address",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    )),
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  direction: Axis.horizontal,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> Wishlist()));
                      },
                      child: SvgPicture.asset("assets/images/heart.svg")),
                    const SizedBox(width: 20),
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const Cart()));
                      },
                      child: SvgPicture.asset("assets/images/bag.svg")),
                  ],
                )
              ],
            ),
          ),

          // address container

          Container(
            
            margin: const EdgeInsets.only(left:10,right: 10,bottom: 20,top: 60),
            padding: const EdgeInsets.only(
                top: 20, bottom: 30, left: 10, right: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)),

            // column
            child: Wrap(
             
              children: [
                // textfromfield one

                Column(children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: SvgPicture.asset("assets/images/edit.svg"),
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(hintText: "Address Line 1"),
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(hintText: "Address Line 2"),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(hintText: "Landmark"),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(hintText: "State"),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(hintText: "Country"),
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(hintText: "Post Code"),
                  )
                ]),

               
              ],
            ),
          ),


             Align(
              alignment: Alignment.bottomRight,
               child: Container(
                    margin: const EdgeInsets.only(right: 15,bottom: 10),
                    padding: const EdgeInsets.only(left: 15,right: 15,top: 10,bottom: 10),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: MyColors.themecolor),
                    child: const Text(
                      "Save",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
             ),
        ],
      ),
    ));
  }
}
