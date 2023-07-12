import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../screens/artWorkScreenForColor.dart';

class CategoriesColorModel extends StatelessWidget {
  final List<String> items = List.generate(7, (index) => "Item $index");
  final List<Color> colors = [
    const Color(0xffFF0000),
    const Color(0xffFFDD60),
    const Color(0xff000000),
    const Color(0xff2D8EFF),
    const Color(0xffFFC0CB),
    const Color(0xffA020F0),
    const Color(0xff964B00),
  ];


  List<String> colorTitles = [
    "Red",
    "Yellow",
    "Black",
    "Blue",
    "Pink",
    "Purple",
    "Brown",
  ];


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        shrinkWrap: true,
        padding: const EdgeInsets.only(left: 16, right: 16),
        itemBuilder: (context, index) {
          return Row(
            children: [
              InkWell(
                onTap: () {
                  String color = colorTitles.elementAt(index);
                  print(color);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ArtWorkScreenForColor(
                            data: color,
                          )));
                },
                child: Container(
                  height: 60.h,
                  width: 60.w,
                  child: CircleAvatar(
                    backgroundColor: colors[index % colors.length],
                  ),
                ),
              ),
              SizedBox(width: 8.w)
            ],
          );
        },
      ),
    );
  }
}
