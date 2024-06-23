// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:siz/Utils/ManageAddressController.dart';

class ManageAddress extends StatefulWidget {
  bool edit = false;
  String addressId = "";
  String from = "";
  String appartment = "";
  String buildingName = "";
  String area = "";
  String state = "";
  String pickupUpName = "";
  String mobile = "";
  String type = "Home";

  ManageAddress({
    super.key,
    required this.addressId,
    required this.from,
    required this.appartment,
    required this.buildingName,
    required this.area,
    required this.state,
    required this.pickupUpName,
    required this.mobile,
    required this.edit,
    required this.type,
  });

  @override
  State<ManageAddress> createState() => _ManageAddressState();
}

class _ManageAddressState extends State<ManageAddress> {
  List<String> grouprationlist = ["Home", "Office", "Others"];

  String type = "";
  Position? currentPosition;

  // text controller =====================================

  TextEditingController appartmentController = TextEditingController();
  TextEditingController buildingController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController pickupContactController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  // get location permission ==========================================================================================================================

  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services',style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text('Location permissions are denied',style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.',style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
      return false;
    }
    return true;
  }

  // get user location ======================================================================================================================

  getCurrentLocation() async {
    final hasPermission = await handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);

        Placemark place = placemarks[0];

        setState(() {
          appartmentController.text = place.subThoroughfare.toString();
          buildingController.text = place.thoroughfare.toString();
          areaController.text = place.subLocality.toString();
          stateController.text = place.locality.toString();
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text("Something went wrong",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
      }
    }).catchError((e) {
      ScaffoldMessenger.of(context)
          .showSnackBar( SnackBar(content: Text("Something went wrong",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white))));
    });
  }

  @override
  void initState() {
    appartmentController.text = widget.appartment;
    buildingController.text = widget.buildingName;
    areaController.text = widget.area;
    stateController.text = widget.state;
    pickupContactController.text = widget.pickupUpName;
    mobileController.text = widget.mobile;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.only(
               left: 20, right: 20,),
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

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
          
                
            Container(
                margin: const EdgeInsets.only(top: 10),
                child: Image.asset("assets/images/Mapview.jpeg")),
          
            InkWell(
              onTap: () {
                getCurrentLocation();
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 20, right: 20, top: 15),
                alignment: Alignment.center,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  "USE CURRENT LOCATION",
                  style: GoogleFonts.lexendExa(
                      
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),
                ),
              ),
            ),
          
            // check box for home office Others =======================================
          
            Visibility(
              visible: widget.from == "uploadItems"?false:true,
              child: Container(
                margin: const EdgeInsets.only(left: 5, top: 5),
                child: Theme(
                  data: ThemeData(
                      splashFactory: NoSplash.splashFactory,
                      primarySwatch: const MaterialColor(0xFFAF1010, {
                        50: Color(0xFFAF1010),
                        100: Color(0xFFAF1010),
                        200: Color(0xFFAF1010),
                        300: Color(0xFFAF1010),
                        400: Color(0xFFAF1010),
                        500: Color(0xFFAF1010),
                        600: Color(0xFFAF1010),
                        700: Color(0xFFAF1010),
                        800: Color(0xFFAF1010),
                        900: Color(0xFFAF1010),
                      }),
                      splashColor: Colors.transparent),
                  child: RadioGroup<String>.builder(
                    direction: Axis.horizontal,
                    groupValue: widget.type.toString(),
                     
                    onChanged: (value) => setState(() {
                      widget.type = value.toString();
                      
                      if (value == "Home") {
                        setState(() {
                          type = "1";
                        });
                      } else if (value == "Office") {
                        setState(() {
                          type = "2";
                        });
                      } else if (value == "Others") {
                        setState(() {
                          type = "3";
                        });
                      }
                    }),
                    textStyle: GoogleFonts.lexend(color: Colors.black,fontWeight: FontWeight.w300 ,fontSize: 16),
                    items: grouprationlist,
                    itemBuilder: (item) => RadioButtonBuilder(
                      
                      item,
                    ),
                  ),
                ),
              ),
            ),
          
            // editext ==================================================================================
          
            Container(
              margin: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Column(
                children: [
                  TextFormField(
          
                    style: GoogleFonts.lexendDeca(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w300),
           
          
                    controller: appartmentController,
                    onChanged: (value) {
                      widget.appartment = value.toString();
                    },
                    decoration:  InputDecoration(
                      hintText: "Apartment/Villa number",
                      hintStyle:
                          GoogleFonts.lexendDeca(color: const Color.fromARGB(255, 206, 206, 206),fontSize: 14,fontWeight: FontWeight.w300),
                    ),
                  ),
                  TextFormField(
                     style: GoogleFonts.lexendDeca(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w300),
           
          
                    controller: buildingController,
                    onChanged: (value) {
                      widget.buildingName = value.toString();
                    },
                    decoration:  InputDecoration(
                      hintText: "Building name",
                      hintStyle:
                          GoogleFonts.lexendDeca(color: const Color.fromARGB(255, 206, 206, 206),fontSize: 14,fontWeight: FontWeight.w300),
                    ),
                  ),
                  TextFormField(
                     style: GoogleFonts.lexendDeca(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w300),
           
          
                    controller: areaController,
                    onChanged: (value) {
                      widget.area = value.toString();
                    },
                    decoration:  InputDecoration(
                      hintText: "Area",
                      hintStyle:
                           GoogleFonts.lexendDeca(color: const Color.fromARGB(255, 206, 206, 206),fontSize: 14,fontWeight: FontWeight.w300),
                    ),
                  ),
                  TextFormField(
                     style: GoogleFonts.lexendDeca(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w300),
           
          
                    controller: stateController,
                    onChanged: (value) {
                      widget.state = value.toString();
                    },
                    decoration:  InputDecoration(
                      hintText: "State",
                      hintStyle:
                          GoogleFonts.lexendDeca(color: const Color.fromARGB(255, 206, 206, 206),fontSize: 14,fontWeight: FontWeight.w300),
                    ),
                  ),
                  TextFormField(
                     style: GoogleFonts.lexendDeca(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w300),
           
          
                    controller: pickupContactController,
                    onChanged: (value) {
                      widget.pickupUpName = value.toString();
                    },
                    decoration:  InputDecoration(
                      hintText: "Contact name",
                      hintStyle:
                          GoogleFonts.lexendDeca(color: const Color.fromARGB(255, 206, 206, 206),fontSize: 14,fontWeight: FontWeight.w300),
                    ),
                  ),
                  TextFormField(
                     style: GoogleFonts.lexendDeca(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w300),
           
          
                    controller: mobileController,
                    onChanged: (value) {
                      widget.mobile = value.toString();
                    },
                    keyboardType: TextInputType.number,
                    decoration:  InputDecoration(
                      hintText: "Mobile number",
                      hintStyle:
                          GoogleFonts.lexendDeca(color: const Color.fromARGB(255, 206, 206, 206),fontSize: 14,fontWeight: FontWeight.w300),
                    ),
                  ),
                ],
              ),
            ),
          
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () async {
                  if (appartmentController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                      content: Text("Apartment cannot be empty",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white)),
                      duration: const Duration(seconds: 1),
                    ));
                  } else if (buildingController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                        content: Text("Building name cannot be empty",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white)),
                        duration: const Duration(seconds: 1)));
                  } else if (areaController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                        content: Text("Area cannot be empty",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white)),
                        duration: const Duration(seconds: 1)));
                  } else if (stateController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                        content: Text("State cannot be empty",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white)),
                        duration: const Duration(seconds: 1)));
                  } else if (pickupContactController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                        content: Text("Pickup name cannot be empty",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white)),
                        duration: const Duration(seconds: 1)));
                  } else if (mobileController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                        content: Text("Mobile no cannot be empty",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white)),
                        duration: const Duration(seconds: 1)));
                  } else if (widget.from == "uploadItems"? appartmentController.text.isEmpty :  type.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                        content: Text("Please select address type",style: GoogleFonts.lexendDeca(fontSize: 13,fontWeight: FontWeight.w300,color: Colors.white)),
                        duration: const Duration(seconds: 1)));
                  } else {
                    ManageAddressController controller =
                        Get.put(ManageAddressController());
          
                    if (widget.from == "ShoppingPaymentSummery") {
                      if (widget.edit) {
                        await controller.editAddress(
                            context,
                            appartmentController.text.toString(),
                            buildingController.text.toString(),
                            areaController.text.toString(),
                            stateController.text.toString(),
                            pickupContactController.text.toString(),
                            mobileController.text.toString(),
                            type,
                            widget.addressId,
                            true);
                        Navigator.pop(context);
                      } else {
                        controller.addAddress(
                            context,
                            appartmentController.text.toString(),
                            buildingController.text.toString(),
                            areaController.text.toString(),
                            stateController.text.toString(),
                            pickupContactController.text.toString(),
                            mobileController.text.toString(),
                            type,
                            true);
                        Navigator.pop(context);
                      }
                    } else if (widget.from == "uploadItems") {
                      if (widget.edit) {
                        await controller.editAddress(
                            context,
                           appartmentController.text.toString(),
                            buildingController.text.toString(),
                            areaController.text.toString(),
                            stateController.text.toString(),
                            pickupContactController.text.toString(),
                            mobileController.text.toString(),
                            "1",
                            widget.addressId,
                            false);
          
                        Navigator.pop(context);
                      } else {
                        await controller.addAddress(
                            context,
                            appartmentController.text.toString(),
                            buildingController.text.toString(),
                            areaController.text.toString(),
                            stateController.text.toString(),
                            pickupContactController.text.toString(),
                            mobileController.text.toString(),
                            "1",
                            false);
                        Navigator.pop(context);
                      }
                    } else {
                      // Navigator.push(
                      // context,
                      // MaterialPageRoute(
                      //     builder: (context) => const AddressSelect()));
          
                      Navigator.pop(context);
                    }
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(
                      right: 20, left: 20, top: 20, bottom: 40),
                  height: 40,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Colors.black),
                  child: Text(
                    "SUBMIT",
                    style: GoogleFonts.lexendExa(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w300),
                  ),
                ),
              ),
            ),
          
              ],
            ),
          )

        ],
      ),
    );
  }
}
