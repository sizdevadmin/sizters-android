import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siz/Pages/Cart.dart';
import 'package:siz/Pages/Wishlist.dart';
import 'package:siz/Utils/Colors.dart';
import 'package:siz/Utils/ManageAddressController.dart';
import 'package:siz/Utils/Value.dart';

import '../AddItemsPages/Addaddress.dart';

class ManageBasicAddress extends StatefulWidget {
  const ManageBasicAddress({super.key});

  @override
  State<ManageBasicAddress> createState() => _ManageBasicAddressState();
}

class _ManageBasicAddressState extends State<ManageBasicAddress> {


    ManageAddressController controller = Get.put(ManageAddressController());
      String currentAddress = "";
        var preSelectedAddress = '';


    @override
      initState()
    {

      controller.getAddress(context, true);
      super.initState();
    
      
    }


  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ManageAddressController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              toolbarHeight: 0,
            ),
          body: Column(
                                                children: [


                                                      Container(
                                                        height: 60,
                                                        alignment: Alignment.center,
               width: MediaQuery.of(context).size.width,
              
               padding: const EdgeInsets.only(right: 15,left: 15),
               
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
                   Container(
                       margin: const EdgeInsets.only(left: 30),
                       child:  Text(
                         "Address".toUpperCase(),
                                 style: SizValue.toolbarStyle,
                       )),


                        const SizedBox(width: 30)
                  //  Wrap(
                  //    alignment: WrapAlignment.center,
                  //    crossAxisAlignment: WrapCrossAlignment.center,
                  //    direction: Axis.horizontal,
                  //    children: [
                  //      InkWell(
                         
                  //         onTap: () {
                  //          Navigator.push(context, MaterialPageRoute(builder: (context)=> Wishlist()));
                  //        },
                  //        child: SvgPicture.asset("assets/images/heart.svg",width: 20,height: 20,)),
                  //      const SizedBox(width: 20),
                  //      InkWell(
                  //        onTap: () {
                  //          Navigator.push(context,MaterialPageRoute(builder: (context)=>const Cart()));
                  //        },
                  //        child: SvgPicture.asset("assets/images/bag.svg",width: 20,height: 20,)),
                  //    ],
                  //  )
                 ],
               ),
             ),


             const SizedBox(height: 30),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                          alignment: Alignment.centerLeft,
                                                        
                                                          margin:
                                                              const EdgeInsets.only(
                                                                  left: 20,
                                                                  right: 10,
                                                                  top: 10
                                                                 ),
                                                          child: Text(
                                                            "Manage Address ",
                                                            textAlign: TextAlign.start,
                                                            style: GoogleFonts.lexendDeca(
                                                              fontWeight: FontWeight.w300,
                                                                color: Colors.black,
                                                                fontSize: 20),
                                                          )),
                        
                                                           InkWell(
                                                    onTap: () {
                                                      controller.addValue(
                                                          SizValue.address,
                                                          currentAddress);
                                    
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ManageAddress(
                                                                    from:
                                                                        'ShoppingPaymentSummery',
                                                                    appartment:
                                                                        "",
                                                                    buildingName:
                                                                        "",
                                                                    area: "",
                                                                    state: "",
                                                                    pickupUpName:
                                                                        "",
                                                                    mobile: "",
                                                                    edit: false,
                                                                    type: "",
                                                                    addressId: "",
                                                                  )));
                                                    },
                                                    child: Container(
                                                     
                                                      margin: const EdgeInsets.only(right: 25, top: 10),
                                                      alignment: Alignment.center,
                                                      decoration: BoxDecoration(
                                                          color: const Color(0xff1E1E1E),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                               
                                                       width: 120,
                                                      height: 40,
                                                      child: Text(
                                                        "+ ADD NEW",
                                                        style:
                                                            GoogleFonts.lexendExa(
                                                                color:
                                                                    Colors.white,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300),
                                                      ),
                                                    ),
                                                  )
                                                    ],
                                                  ),
                                    
                                                  // add address button ==================================================================================
                                    
                                                 
                                    
                                                  // address list =========================================================================
                                    
                                                  Expanded(
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 10),
                                                      margin:
                                                          const EdgeInsets.all(
                                                              10),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                10),
                                                        // color:
                                                        //     const Color.fromARGB(
                                                        //         22, 175, 16, 16),
                                                      ),
                                                      child: ListView.builder(
                                                          shrinkWrap: true,
                                                          itemCount: controller
                                                              .decordedResponse
                                                              .length,
                                                          padding:
                                                              EdgeInsets.zero,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      bottom: 8),
                                                              child:
                                                                  RadioListTile(
                                                                contentPadding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left: 0),
                                                                activeColor:
                                                                    MyColors
                                                                        .themecolor,
                                                                title: Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .spaceBetween,
                                                                        children: [
                                                                            Container(
                                                                              margin: const EdgeInsets.only(top: 15,bottom: 5),
                                                                              child: Text(
                                                                                controller.decordedResponse[index]["type_str"].toString().toUpperCase(),
                                                                                style: GoogleFonts.lexendExa(
                                                                                                                                            letterSpacing: 1.0,
                                                                                                                                            color: Colors.black,
                                                                                                                                          
                                                                                                                                            fontWeight:
                                                                                                                                                FontWeight.w300,
                                                                                                                                            fontSize: 12)
                                                                              ),
                                                                            ),
                                                                            InkWell(
                                                                                onTap: () {
                                                                                  bottomsheet(controller.decordedResponse[index]["type_str"].toString(), controller.decordedResponse[index]["id"].toString(), controller.decordedResponse[index]["apartment"].toString(), controller.decordedResponse[index]["area_name"].toString(), controller.decordedResponse[index]["city"].toString(), controller.decordedResponse[index]["state"].toString(), controller.decordedResponse[index]["contact_name"].toString(), controller.decordedResponse[index]["mobile_number"].toString(), controller.decordedResponse[index]["type"].toString());
                                                                                },
                                                                                child: Container(
                                                                                  margin: const EdgeInsets.only(right: 5,top: 15,bottom: 5),
                                                                                  child: SvgPicture.asset(
                                                                                    "assets/images/threedot.svg",
                                                                                    width: 30,
                                                                                    height: 25,
                                                                                  ),
                                                                                ))
                                                                          ]),
                                                                subtitle: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      "${controller.decordedResponse[index]["contact_name"]}",
                                                                      style: GoogleFonts.lexendDeca(
                                                              color: const Color.fromARGB(255, 88, 88, 88),
                                                              fontWeight: FontWeight.w300,
                                                              fontSize: 12)
                                                                    ),
                                                                    const SizedBox(
                                                                        height:
                                                                            5),
                                                                    Text(
                                                                      controller
                                                                          .decordedResponse[
                                                                              index]
                                                                              ["mobile_number"]
                                                                          .toString(),
                                                                      style:  GoogleFonts.lexendDeca(
                                                              color: const Color.fromARGB(255, 88, 88, 88),
                                                              fontWeight: FontWeight.w300,
                                                              fontSize: 12)
                                                                    ),
                                                                    const SizedBox(
                                                                        height:
                                                                            5),
                                                                    Text(
                                                                      controller
                                                                          .decordedResponse[
                                                                              index]
                                                                              ["full_address"]
                                                                          .toString(),
                                                                      style: GoogleFonts.lexendDeca(
                                                              color: const Color.fromARGB(255, 88, 88, 88),
                                                              fontWeight: FontWeight.w300,
                                                              fontSize: 12)
                                                                    ),
                                                                  ],
                                                                ),
                                                                value: controller
                                                                    .decordedResponse[
                                                                        index]
                                                                        ["id"]
                                                                    .toString(),
                                                                groupValue:
                                                                    preSelectedAddress,
                                                                // ignore: avoid_types_as_parameter_names
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                        
                                                                  
                                                                    preSelectedAddress = value.toString();
                                                                 
                                                                   
                                                                  });
                                                                },
                                                              ),
                                                            );
                                                          }),
                                                    ),
                                                  ),
                                    
                                                 
                                                  
                                                ],
                                              ),
        );
      }
    );
  }



    bottomsheet(
      String typestr,
      String addressID,
      String appartment,
      String buildingname,
      String area,
      String state,
      String contactname,
      String mobilenumber,
      String type) {
    return showModalBottomSheet(
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
                    margin: const EdgeInsets.only(top: 0,bottom: 10),
                    width: 35,
                    height: 2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: const Color(0xff9D9D9D)),
                  ),
                        const SizedBox(height: 10),
                        Row(

                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                        
                          children: [
                            InkWell(
                              onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ManageAddress(
                                    from: 'ShoppingPaymentSummery',
                                    appartment: appartment,
                                    buildingName: buildingname,
                                    area: area,
                                    state: state,
                                    pickupUpName: contactname,
                                    mobile: mobilenumber,
                                    edit: true,
                                    type: type,
                                    addressId: addressID,
                                  )));
                    },
                              child: Container(
                                padding: const EdgeInsets.only(left: 10,right:10),
                             
                                alignment: Alignment.center,
                                height: 40,
                                
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(5)
                                ),
                                child: Text(
                                  "Edit Address".toUpperCase(),
                                  style: GoogleFonts.lexendExa(
                                color: Colors.white,
                                fontSize: 16,
                                
                                fontWeight: FontWeight.w300),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            InkWell(
                              onTap: () {
                      Navigator.pop(context);
                      deleteAddressbottomsheet(addressID);
                    },
                              child: Container(
                                padding: const EdgeInsets.only(left: 10,right:10),
                              
                                 alignment: Alignment.center,
                                height: 40,
                                
                                decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(5)
                                ),
                                child: Text(
                                  "Delete Address".toUpperCase(),
                                  style:  GoogleFonts.lexendExa(
                                color: Colors.white,
                                fontSize: 16,
                                
                                fontWeight: FontWeight.w300),
                                ),
                              ),
                            )
                          ],
                        ),

                          const SizedBox(height: 10),
                      ],
                    )),
              ]);





        });


  }


    // confirm delete address

  deleteAddressbottomsheet(String id) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        context: context,
        builder: (context) {
          return Container(
              margin: const EdgeInsets.only(top: 10, bottom: 30),
              child: Wrap(
                children: [
                  Column(
                    children: [

                          Container(
                    margin: const EdgeInsets.only(top: 0,bottom: 10),
                    width: 35,
                    height: 2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: const Color(0xff9D9D9D)),
                  ),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 10),
                        child:  Text(
                            "Sure do you want to delete this address?",
                            style: GoogleFonts.lexendDeca(
                                color: MyColors.themecolor,
                                fontSize: 15,
                                
                                fontWeight: FontWeight.w400)),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                               Navigator.pop(context);
                              
                            },
                            child: Container(
                                padding: const EdgeInsets.only(left: 10,right:10),
                                                      
                             alignment: Alignment.center,
                            height: 40,
                            
                            decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      borderRadius: BorderRadius.circular(5)
                            ),
                              child: Text(
                                "No".toUpperCase(),
                                style:  GoogleFonts.lexendExa(
                                color: Colors.white,
                                fontSize: 16,
                                
                                fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          InkWell(
                            onTap: () {

                             

                            controller.deleteAddress(context, id, true);
                             
                             Navigator.pop(context);
                              
                            },
                            child: Container(
                              padding: const EdgeInsets.only(left: 10,right:10),
                            
                               alignment: Alignment.center,
                              height: 40,
                              
                              decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(5)
                              ),
                              child: Text(
                                "Yes".toUpperCase(),
                                style:  GoogleFonts.lexendExa(
                                color: Colors.white,
                                fontSize: 16,
                                
                                fontWeight: FontWeight.w300),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ));
        });
  }

}