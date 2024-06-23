import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListingController extends GetxController {


  List<String> imagePath=[];

  forseUpdate()
  {
    update();
  }

  addValue(String key,String value) async
  {
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    sharedPreferences.setString(key, value);
  }


  removeValue(String key) async
  {

    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    sharedPreferences.remove(key);

  }

}
