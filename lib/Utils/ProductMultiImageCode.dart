// ignore_for_file: must_be_immutable, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

enum ThumbnailAlignment { left, right, bottom }
enum ThumbnailShape { circle, custom }
enum ThumbnailBorderType { all, bottom }
enum SliderStyle { overSlider, nextToSlider, }

class ProductMultiImage extends StatefulWidget{

  final List<dynamic> arrayImages;
  final double? aspectRatio;
  final BoxFit? boxFit;
  final ThumbnailAlignment? thumbnailAlignment;
  final double? thumbnailWidth;
  final double? thumbnailHeight;
  final Color? thumbnailBorderColor;
  // String herotag="";
  final ThumbnailBorderType? thumbnailBorderType;
  final double? thumbnailBorderRadius;
  final double? thumbnailBorderWidth;
  final SliderStyle? sliderStyle;
  final Function? onTap;
  final int? selectedImagePosition;

   ProductMultiImage({
    // required this.herotag,
    required this.arrayImages,
    this.aspectRatio = 16/9,
    this.boxFit = BoxFit.fill,
    this.thumbnailAlignment = ThumbnailAlignment.left,
    this.thumbnailWidth = 40,
    this.thumbnailHeight = 40,
    this.thumbnailBorderColor = Colors.blueGrey,
    this.thumbnailBorderType = ThumbnailBorderType.all,
    this.thumbnailBorderRadius = 0,
    this.thumbnailBorderWidth = 1,
    this.sliderStyle,
    this.onTap,
    this.selectedImagePosition = 0,
  });

  @override
  State<ProductMultiImage> createState() => _ProductMultiImageState();

  static CachedNetworkImage funcDisplayImage(String strImageURL, BoxFit varBoxType) {
    return CachedNetworkImage(
      imageUrl: strImageURL,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: varBoxType,
          ),
        ),
      ),
      errorWidget: (context, url, error) => Center(
        child: Icon(Icons.image_outlined,color: Colors.grey.shade400,),
      ),
    );
  }
}

class _ProductMultiImageState extends State<ProductMultiImage> {
  double paddingOfBorder = 3;
  
  PageController pageController = PageController(initialPage: 0,);

  ValueNotifier<int> currentPageViewPage = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {

    currentPageViewPage = ValueNotifier(widget.selectedImagePosition!);

    Future.delayed(const Duration(milliseconds: 3), () {
      pageController.jumpToPage(widget.selectedImagePosition!);
    });

    return  buildContent();
  }

  Widget buildContent(){

    switch (widget.sliderStyle){

      case SliderStyle.overSlider: return buildTheme1();

      case SliderStyle.nextToSlider: return buildTheme2();

      default: return buildTheme1();

    }

  }

  Widget buildTheme1(){
    return AspectRatio( aspectRatio: widget.aspectRatio!,
        child:Stack(
          children: [

            Positioned.fill(
                child: buildImageSlider()
            ),

            widget.thumbnailAlignment == ThumbnailAlignment.bottom ?

            Positioned(
                left: 0,bottom: 5,right: 0,
                child: buildThumbnail(isVertical: false)
            ) :

            widget.thumbnailAlignment == ThumbnailAlignment.left ?

            Positioned(
                top: 5,left: 10,bottom: 5,
                child: buildThumbnail(isVertical: true)
            )
                :
            Positioned(
                top: 5,right: 10,bottom: 5,
                child: buildThumbnail(isVertical: true)
            )


          ],
        ));
  }

  Widget buildTheme2(){
    return

      widget.thumbnailAlignment == ThumbnailAlignment.bottom ?
      Column(
        children: [

          AspectRatio( aspectRatio: widget.aspectRatio!,
            child:buildImageSlider(),
          ),


          Padding(padding: const EdgeInsets.only(top: 5,bottom: 5),
            child: buildThumbnail(isVertical: false),
          )

        ],
      ):
      AspectRatio( aspectRatio: widget.aspectRatio!,
          child:
          Row(
            children: [

              widget.thumbnailAlignment == ThumbnailAlignment.left ?
              Padding(padding: const EdgeInsets.only(left: 10,right: 5),
                child: buildThumbnail(isVertical: true),
              ) : const SizedBox(),

              Expanded(
                child:  buildImageSlider(),
              ),

              widget.thumbnailAlignment == ThumbnailAlignment.right ?
              Padding(padding: const EdgeInsets.only(left: 5,right: 5),
                child: buildThumbnail(isVertical: true),
              ) : const SizedBox(),

            ],
          ));
  }

  Widget buildImageSlider(){
    return PageView.builder(
      controller:pageController,
      onPageChanged: (int currentPage){

        currentPageViewPage.value = currentPage;
        currentPageViewPage.notifyListeners();

      },
      itemCount: widget.arrayImages.length,
      itemBuilder: (context, index) {

        return

          ProductMultiImage.funcDisplayImage(widget.arrayImages[index].toString(),widget.boxFit!);

      },
    );
  }

  Widget buildThumbnail({required bool isVertical}){
    return Container(
      width: isVertical ? widget.thumbnailWidth! + paddingOfBorder + 10 : double.infinity,
      height: isVertical ? double.infinity : widget.thumbnailHeight! + paddingOfBorder + 10,
      child:  ValueListenableBuilder(
          valueListenable: currentPageViewPage,
          builder: (BuildContext context, currIndexValue, child) {

            return ListView.builder(
              padding: const EdgeInsets.only(top: 10),
                    scrollDirection: isVertical ? Axis.vertical : Axis.horizontal,
                    itemCount: widget.arrayImages.length,
                    itemBuilder: (context, index) {
                      return Padding(padding: isVertical ? EdgeInsets.zero : const EdgeInsets.only(left: 5),
                        child: Column(
                          children: [
                            InkWell(
                                onTap: (){
                                 currentPageViewPage.value = index;
                                  currentPageViewPage.notifyListeners();
                                  pageController.jumpToPage(index);

                                },
                                child:

                               Container(
                                        height:widget.thumbnailHeight! + paddingOfBorder,
                                        width: widget.thumbnailWidth! + paddingOfBorder,
                                        decoration: widget.thumbnailBorderType == ThumbnailBorderType.all ?

                                        BoxDecoration(
                                          borderRadius: BorderRadius.circular(widget.thumbnailBorderRadius!),
                                          border: currIndexValue != index ? Border.all(width: widget.thumbnailBorderWidth! ,color: Colors.transparent) :
                                          Border.all(width: widget.thumbnailBorderWidth!,color: widget.thumbnailBorderColor!),
                                        )
                                            :
                                        BoxDecoration(
                                          border:
                                          Border(
                                            bottom: BorderSide(width: widget.thumbnailBorderWidth!,color:currIndexValue != index ? Colors.transparent : widget.thumbnailBorderColor!),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(3),
                                          child:ClipRRect(
                                            borderRadius: BorderRadius.circular(widget.thumbnailBorderRadius!),
                                            child:  ProductMultiImage.funcDisplayImage(widget.arrayImages[index].toString(),widget.boxFit!),
                                          ),
                                        ),
                                      )

                            ),
                            const SizedBox(height: 10,)
                          ],
                        ),
                      );
                    },
              );
          })
    );
  }
}

