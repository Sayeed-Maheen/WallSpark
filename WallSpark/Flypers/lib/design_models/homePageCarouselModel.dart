import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/appColors.dart';

class HomePageCarouselModel extends StatefulWidget {
  const HomePageCarouselModel({Key? key}) : super(key: key);

  @override
  State<HomePageCarouselModel> createState() => _HomePageCarouselModelState();
}

class _HomePageCarouselModelState extends State<HomePageCarouselModel> {

  int currentIndex = 0;
  final PageController controller = PageController();

  static final _db = FirebaseFirestore.instance;

  List<DocumentSnapshot> banners = [];
  bool isLoadingbanner = false;
  bool hasMorebanner = true;
  int documentLimitbanner = 14;
  DocumentSnapshot? lastDocumentbanner;

  Future<void>getBanners() async {
    QuerySnapshot querySnapshot;
    if (lastDocumentbanner == null) {
      querySnapshot = await _db
          .collection('banner')
          .limit(documentLimitbanner)
          .get();
    } else {
      querySnapshot = await _db
          .collection('banner')
          .startAfterDocument(lastDocumentbanner!)
          .limit(documentLimitbanner)
          .get();
      print(1);
    }

    if (querySnapshot.docs.length < documentLimitbanner) {
      hasMorebanner = false;
    }
    lastDocumentbanner = querySnapshot.docs[querySnapshot.docs.length - 1];
    banners.addAll(querySnapshot.docs);
    print(banners.length);
    setState(() {
      isLoadingbanner = false;
    });
  }



  @override
  void initState() {
    super.initState();
    getBanners();
    Timer.periodic(const Duration(seconds: 2), (timer) {
      if (currentIndex == banners.length - 1) {
        currentIndex = 0;
        controller.animateToPage(
          currentIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        currentIndex++;
        controller.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 152.h,
            width: double.infinity,
            child: PageView.builder(
              controller: controller,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index % banners.length;
                });
              },
              itemCount: banners.length,
              itemBuilder: (context, index) {
                Map<String, dynamic>? data = banners[index].data() as Map<String, dynamic>?;
                return Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: SizedBox(
                    height: 152.h,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image(
                        image: NetworkImage(data?['url']),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < banners.length; i++)
                buildIndicator(currentIndex == i)
            ],
          ),
        ],
      ),
    );
  }

  Widget buildIndicator(bool isSelected) {
    return Container(
      margin: const EdgeInsets.all(2),
      height: isSelected ? 8 : 8,
      width: isSelected ? 24 : 8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: isSelected
            ? AppColors.colorSecondary
            : AppColors.colorIndicatorUnselected,
      ),
    );
  }
}
