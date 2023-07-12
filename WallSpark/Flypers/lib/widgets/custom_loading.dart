import 'package:flutter/material.dart';

Future<void> showCustomDialog(BuildContext context) async {
  Future.delayed(new Duration(seconds: 0), ()
  {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            height: 96,
            width: 96,
            child: Center(child: CircularProgressIndicator()),
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          ),
        );
      },

    );
    Future.delayed(Duration(seconds: 3), ()
    {
      Navigator.pop(context);
    });
  });
}