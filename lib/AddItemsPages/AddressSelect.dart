// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:siz/AddItemsPages/Addaddress.dart';
import 'package:siz/AddItemsPages/Summery.dart';
import 'package:siz/Utils/Colors.dart';
import 'package:siz/Utils/ManageAddressController.dart';
import 'package:siz/Utils/Value.dart';

class AddressSelect extends StatefulWidget {
  const AddressSelect({super.key});

  @override
  State<AddressSelect> createState() => _AddressSelectState();
}

class _AddressSelectState extends State<AddressSelect> {
  String currentAddress = "";


   
   var preSelectedAddress = '';


   ManageAddressController controller=Get.put(ManageAddressController());

   
 

 
   @override
  void initState() {
    callAddress();
    super.initState();
  }

  callAddress() async
  {

    await controller.getAddress(context,false);

    setState(() {

          preSelectedAddress=controller.decordedResponse[0]["id"].toString();
      
    });


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
              // top four icons ==============================================================================================

              Container(
                alignment: Alignment.center,
                height: 60,
                decoration: const BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(255, 228, 228, 228),
                      blurRadius: 2,
                      offset: Offset(0, 2))
                ]),
                padding:
                    const EdgeInsets.only(left: 20, right: 20),
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

              // Body ==========================================================================================

              Container(
                  alignment: Alignment.center,
                
                  margin: const EdgeInsets.only(
                      left: 10, right: 10, top: 20, bottom: 10),
                  child: Text(
                    "Please confirm the pick up address",
                    style: GoogleFonts.dmSerifDisplay(
                      fontWeight: FontWeight.w400,
                        color: Colors.black, fontSize: 20),
                  )),

              // add address button ==================================================================================

             

               InkWell(
                          onTap: () {
                             controller.addValue(SizValue.address, currentAddress);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>  ManageAddress(from: 'uploadItems',appartment: "",buildingName: "",  area: "",state: "",pickupUpName: "",mobile: "",edit: false,type: "",addressId: "",)));
                          },
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              
                                                    margin: const EdgeInsets.only(right: 25, top: 20),
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
                                style: GoogleFonts.lexendExa(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                        ),
             
              


              // address list =========================================================================


           
                     Expanded(
                       child: Container(
                            padding: const EdgeInsets.only(right: 10),
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                     
                                   borderRadius: BorderRadius.circular(10),
                               
                                  
                     
                                ),
                                child: ListView.builder(
                                  
                                    itemCount:controller. decordedResponse.length,
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 8),
                                        child: RadioListTile(
                                          contentPadding:
                                                const EdgeInsets
                                                                    .only(
                                                                    left: 0),
                                          activeColor: MyColors.themecolor,
                                          title:Row(
                                                 mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                  children: [
                                                      Container(
                                                         margin: const EdgeInsets.only(top: 15,bottom: 5),
                                                        child: Text(
                                                         controller. decordedResponse[index]
                                                                  ["type_str"]
                                                              .toString().toUpperCase(),
                                                          style:GoogleFonts.lexendExa(
                                                                                                                                        letterSpacing: 1.0,
                                                                                                                                        color: Colors.black,
                                                                                                                                      
                                                                                                                                        fontWeight:
                                                                                                                                            FontWeight.w300,
                                                                                                                                        fontSize: 12)
                                                        ),
                                                      ),
                                                      InkWell(
                                                          onTap: () {


                                                            

                                                bottomsheet(controller.  decordedResponse[index]
                                                                    ["type_str"]
                                                                .toString(), 
                                                                
                                                               controller.   decordedResponse[index]
                                                                    ["id"]
                                                                .toString(), 
                                                              controller.   decordedResponse[index]
                                                                    ["apartment"]
                                                                .toString(),
                                                                
                                                                controller.    decordedResponse[index]
                                                                    ["area_name"]
                                                                .toString(), 
                                                                
                                                                 controller.  decordedResponse[index]
                                                                    ["city"]
                                                                .toString(),
                                                                
                                                                controller.   decordedResponse[index]
                                                                    ["state"]
                                                                .toString(), 
                                                                
                                                                controller.  decordedResponse[index]
                                                                    ["contact_name"]
                                                                .toString(), 
                                                                
                                                               controller.  decordedResponse[index]
                                                                    ["mobile_number"]
                                                                .toString(),
                                                                controller.decordedResponse[index]["type"].toString()
                                                                
                                                                );
   
                                                         
                                                          },
                                                           child: Container(
                                                           margin: const EdgeInsets.only(right: 5,top: 15,bottom: 5),
                                                            child: SvgPicture.asset(
                                                                "assets/images/threedot.svg",width: 30,height: 30,),
                                                          ))
                                                    ]),
                                          subtitle: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                     
                                                  Text(
                                                    "${controller. decordedResponse[index]
                                                            ["contact_name"]}",
                                                    style:   GoogleFonts.lexendDeca(
                                                        color: const Color.fromARGB(255, 88, 88, 88),
                                                        fontWeight: FontWeight.w300,
                                                        fontSize: 12),
                                                  ),
                     
                                                  const SizedBox(height: 5),
                     
                                                  Text(
                                                 controller.   decordedResponse[index]["mobile_number"].toString(),
                                                    style:    GoogleFonts.lexendDeca(
                                                        color: const Color.fromARGB(255, 88, 88, 88),
                                                        fontWeight: FontWeight.w300,
                                                        fontSize: 12),),
                     
                                               
                     
                                                  const SizedBox(height: 5),
                                                  Text(
                                                 controller.  decordedResponse[index]
                                                            ["full_address"]
                                                        .toString(),
                                                    style:  GoogleFonts.lexendDeca(
                                                        color: const Color.fromARGB(255, 88, 88, 88),
                                                        fontWeight: FontWeight.w300,
                                                        fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                          value: controller.decordedResponse[index]
                                                  ["id"]
                                              .toString(),
                                          groupValue:preSelectedAddress,
                                          // ignore: avoid_types_as_parameter_names
                                          onChanged: (value) {
                                            setState(() {
                                             
                                             preSelectedAddress = value.toString();
                                             
                                            });
                                          },
                                        ),
                                      );
                                    }),
                              ),
                     ),


                        InkWell(
                          onTap: () {

                            if(preSelectedAddress.isEmpty)
                            {
                              ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("Please select address",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white)),duration: const Duration(seconds: 1),));
                            }

                            else
                            {

                           controller.addValue(SizValue.address, preSelectedAddress);

                             Navigator.push(context,
                             MaterialPageRoute(builder: (context) => const Summery()));

                          

                            }


                           
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 40, top: 10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(5)),
                            width: MediaQuery.of(context).size.width,
                            height: 40,
                            child: Text(
                              "Next".toUpperCase(),
                              style: GoogleFonts.lexendExa(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),

            ],
          ),
        );
      }
    );
  }

  

       // edit and delete address bottom sheet

  bottomsheet(
      String typestr,
      String addressID,
      String appartment,
      String buildingname,
      String area,
      String state,
      String contactname,
      String mobilenumber,
      String type
      ) {

       
    return showModalBottomSheet(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
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
                                builder: (context) =>  ManageAddress(from: 'uploadItems',appartment:appartment,buildingName: buildingname,  area:area,state: state,pickupUpName: contactname,mobile: mobilenumber,edit: true,type: type,addressId: addressID,)));
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

                             Navigator.pop(context);
                             controller.deleteAddress(context, id,false);
                              
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
