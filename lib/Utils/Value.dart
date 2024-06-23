// ignore_for_file: file_names, constant_identifier_names

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SizValue{

      static final GlobalKey<NavigatorState> navState = GlobalKey<NavigatorState>();



  static const baseUrl="http://app.siz.ae:4202";
  static const loginOTP="$baseUrl/auth/otp_login";
  static const loginVerify="$baseUrl/auth/verify_otp_login";
  static const googleLogin="$baseUrl/auth/check_google_login";
  static const uploadIdProof="$baseUrl/auth/upload_id_proof";
  static const accountInfo="$baseUrl/account/last_bank_detail";
  static const otpcheck="$baseUrl/auth/phone_otp_check";
  static const otpverification="$baseUrl/auth/verify_phone_otp_login";
  static const addrenterReview="$baseUrl/order/add_renter_review";

  static const completeSignup="$baseUrl/auth/complete_signup";
  static const skipUser="$baseUrl/auth/skip_complete_signup";
  static const editAccount="$baseUrl/account/edit";
  static const getCategory="$baseUrl/data/categories";
  static const getCollection="$baseUrl/data/collections";

  static const getSubCategory="$baseUrl/data/sub_categories";
  static const getBrands="$baseUrl/data/brands";
  static const getColors="$baseUrl/data/colors";

  static const getSizes="$baseUrl/data/sizes";
  static const getGetOccasions="$baseUrl/data/occasions";
  static const getAddress="$baseUrl/address/list";
  static const getpickUpAddress="$baseUrl/cart/address";

  static const addAddress="$baseUrl/address/add";
  static const addProduct="$baseUrl/product/add";
  static const editProduct="$baseUrl/product/edit";
  static const editAddress="$baseUrl/address/edit";

   static const deleteAddress="$baseUrl/address/remove";
   static const getmyproducts="$baseUrl/product/my_listed";
   static const getlistedProducts="$baseUrl/home/browse_product";
   static const newslettersignup="$baseUrl/home/newsletter_signup";
  
   static const getHome="$baseUrl/home/main";
   static const getnotications="$baseUrl/home/notifications";
   static const getProductDetails="$baseUrl/product/detail";
   static const productLike="$baseUrl/product/like";
   static const deleteProduct="$baseUrl/product/delete_product";
   static const exampleImages="$baseUrl/product/example_images";

   static const addCart="$baseUrl/cart/add";
   static const getCart="$baseUrl/cart/list";
   static const removeCart="$baseUrl/cart/remove";
   static const blockUser="$baseUrl/lender/block_user";
   static const unblockUser="$baseUrl/lender/unblock_user";
   static const lenderReport="$baseUrl/lender/report_user";

   static const getcartAddress="$baseUrl/cart/address";
   static const addWishlist="$baseUrl/wishlist/add";
   static const getWishlist="$baseUrl/wishlist/list";
   static const removeWishlist="$baseUrl/wishlist/remove";

   static const promoCodeList="$baseUrl/promocode/list";
   static const promoAppy="$baseUrl/promocode/check";
   static const orderCreate="$baseUrl/order/create";

   static const myaccontDetails="$baseUrl/account/detail";
   static const transferredRequest="$baseUrl/account/amount_transfer_request";
   static const createCoupon="$baseUrl/account/create_coupon";

   static const myrentals="$baseUrl/account/rentals";
   static const myrequest="$baseUrl/account/requests";
   static const myProductDetails="$baseUrl/account/my_product_detail";
   static const udpatePushNotification="$baseUrl/account/update_push_status";
  
   static const updateClosetStatus="$baseUrl/product/update_status";
   static const daysBlocks="$baseUrl/product/product_day_block";
   static const requestAction="$baseUrl/account/request_action";
   static const calenderRequest="$baseUrl/account/request_calendar";

   static const rentalDetails="$baseUrl/account/order_detail";
   static const orderReturn="$baseUrl/account/order_return";
   static const lenderProfile="$baseUrl/lender/profile";

   static const followLender="$baseUrl/lender/follow_lender";
   static const unfollowLender="$baseUrl/lender/unfollow_lender";
   static const addReview="$baseUrl/order/add_review";
   static const addLenderReview="$baseUrl/order/add_lender_review";
   static const lenderReview="$baseUrl/lender/reviews";
   static const calculateEarning="$baseUrl/home/calculate_earning";


   static const chatList="$baseUrl/chat/list";
   static const chatDetails="$baseUrl/chat/detail";
   static const sendMessage="$baseUrl/chat/send_message";
   static const sendAttachment="$baseUrl/chat/send_attachment";
   static const updateReadStatus="$baseUrl/chat/update_read_status";
   static const getAllSize="$baseUrl/data/all_sizes";
   static const getLenders="$baseUrl/data/lenders";
   static const addmanageRequest="$baseUrl/account/add_manage_request";
   static const getfaqs="$baseUrl/account/get_faqs";
   static const getallSizes="$baseUrl/data/all_sizes";
   static const sizePreference="$baseUrl/account/size_preference";
   static const updateAllCloset="$baseUrl/account/update_closet_status";
   static const searchSuggestion="$baseUrl/home/search_suggestion";
   static const accountDelete="$baseUrl/account/account_delete";
   static const stripeIntent="$baseUrl/stripe/payment_intents";
   static const logoutAccount="$baseUrl/account/logout";
   static const homeLenders="$baseUrl/home/lenders";



//sharepreference keys

static const String isLogged="isLogged";
static const String firstname="firstname";
static const String lastname="lastname";
static const String email="email";
static const String mobile="mobile";
static const String userKey="userKey";
static const String profile="profile";
static const String referral="referral";
static const String instagramhandle="instagramhandle";
static const String bio="bio";
static const String channelId="channelId";
static const String notiID="notiId";
static const String emirateIDInfo="emirateIDInfo";
static const String basicdialogInfo="basicdialogInfo";
static const String emirateIDSkip="emirateIDSkip";
static const String welcomeDialog="welcomeDialog";
static const String referralAmount="referralAmount";


// value of sourse
static const String phoneSource="phoneSource";
static const String authSource="authSource";
static const String username="username";
static const String source="source";


// list product keys============


static const String mainCategory="mainCategoryS";
static const String subCategory="subCategoryS";
static const String brand="brandS";
static const String size="sizeS";
static const String color="colorS";
// images ==========================
static const String frontImage="frontImageS";
static const String backImage="backImageS";
static const String tagview="tagviewS";
static const String additional1="additional1S";
static const String additional2="additional2S";
static const String additional3="additional3S";
static const String additional4="additional4S";
static const String additional5="additional5S";
// ==========================
static const String title="titleS";
static const String description="descriptionS";
static const String additionalDescription="additionalDescriptionS";
static const String occasions="occasionsS";
static const String address="addressS";
static const String price="priceS";
static const String rental3days="rental3daysS";
static const String rental8days="rental8daysS";
static const String rental20days="rental20daysS";

static const String earning3days="earning3daysS";
static const String earning8days="earning8daysS";
static const String earning20days="earning20daysS";


static const String manageIbutton="manageIbutton";
static const String LMOIButton="LMOIButton";
static const String underReview="underReview";
static const String rejectedReviewMSG="rejectedReviewMSG";
static const String incompleteMessage="incompleteMessage";
static const String underReviewMsg="underReviewMsg";




static const String sizeAsk="sizeAskS";


 static final   toolbarStyle=  GoogleFonts.lexendExa(
                              color: Colors.black,
                              fontSize: 16,
                             letterSpacing: 2.0,
                              
                               fontWeight: FontWeight.w400);


  // routes ==========


  static String First="/first";




}