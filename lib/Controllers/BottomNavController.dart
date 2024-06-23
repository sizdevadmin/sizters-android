import 'package:get/get.dart';

class BottomNavController extends GetxController{

  int currentIndex=0;

   List loadedPages = [0,];


  updateIndex(int index)
  {  

    currentIndex=index;

    update();
   
  }

  addPages(int index)
  {

    if(!loadedPages.contains(index))

    {

      loadedPages.add(index);
      update();

    }

    

  }

  forseUpdate()
  {
    update();
  }

  

}