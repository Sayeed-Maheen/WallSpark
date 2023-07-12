import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_segmented_control/material_segmented_control.dart';

import '../screens/artWorkScreen2.dart';
import '../widgets/appColors.dart';
import 'artworkWallpaperModel.dart';

class TabbarModel extends StatefulWidget {
  @override
  _TabbarModelState createState() => _TabbarModelState();
}

class _TabbarModelState extends State<TabbarModel> {
  final Map<int, Widget> _children = {
    0: SizedBox(
      child: Center(child: Text('Recently added')),
      height: 30.h,
      width: 350.w,
    ),
    1: SizedBox(
      child: Center(child: Text('Trending')),
      height: 30.h,
      width: 350.w,
    ),
  };
  int _currentSelection = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentSelection);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          child: MaterialSegmentedControl(
            children: _children,
            borderRadius: 30,
            selectionIndex: _currentSelection,
            borderColor: AppColors.colorWhite,
            unselectedColor: AppColors.colorTabUnselected,
            selectedColor: AppColors.colorPrimary,
            horizontalPadding: EdgeInsets.symmetric(vertical: 5),
            onSegmentChosen: (index) {
              setState(() {
                _currentSelection = index;
                _pageController.animateToPage(index,
                    duration: Duration(milliseconds: 500), curve: Curves.ease);
              });
            },
          ),
        ),
        SizedBox(height: 16.h),
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentSelection = index;
              });
            },
            children: [
              Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ArtworkScreen2(
                                      data : "Marie Laurencin",
                                      id: '',
                                    )));
                          },
                          child: ArtworkWallpaperModel()),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              ),
              Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ArtworkScreen2(
                                      data : "Marie Laurencin",
                                      id: '',
                                    )));
                          },
                          child: ArtworkWallpaperModel()),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
