
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'appColors.dart';

class MyButton extends StatefulWidget {
  final void Function()? onPressed;
  final String text;
  MyButton({
    required this.onPressed,
    required this.text,
  });

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: widget.onPressed,
      height: 53.h,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      padding: EdgeInsets.all(0),
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.colorPrimary,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Container(
          height: 53.h,
          width: 278.w,
          child: Center(
              child: Text(
                widget.text,
                style: TextStyle(
                  color: AppColors.colorWhite,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              )),
        ),
      ),
    );
  }
}