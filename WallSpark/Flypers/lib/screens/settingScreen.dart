import 'package:WallSpark/screens/privacyPolicyScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/appColors.dart';
import 'mainHomeScreen.dart';

class SettingScreen extends StatefulWidget {
  final String screenName;

  const SettingScreen({Key? key, required this.screenName}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isSwitched = false;
  bool isSwitched1 = false;
  String nameValue = '';
  final int value = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameValue = widget.screenName;
  }

  @override
  Widget build(BuildContext context) {
    print(nameValue);
    return WillPopScope(
      onWillPop: () async {
        if (nameValue == "fromHome") {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const MainHomeScreen(
                    value: 0,
                  )));
        } else if (nameValue == "fromSettings") {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const MainHomeScreen(
                    value: 0,
                  )));
        } else if (nameValue == "fromCategories") {
          print("fromCategories");
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const MainHomeScreen(value: 1)));
        }
        return false;
      },
      child: Scaffold(
        body: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40.h),
                InkWell(
                    onTap: () {
                      if (nameValue == "fromHome") {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainHomeScreen(
                                  value: 0,
                                )));
                      } else if (nameValue == "fromSettings") {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainHomeScreen(
                                  value: 0,
                                )));
                      } else if (nameValue == "fromCategories") {
                        print("fromCategories");
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const MainHomeScreen(value: 1)));
                      }
                      // Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => MainHomeScreen(
                      //               value: 0,
                      //             )));
                    },
                    child: const Icon(Icons.arrow_back,
                        color: AppColors.colorBlack, size: 30)),
                SizedBox(height: 24.h),
                Text(
                  "Settings",
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.colorBlack,
                  ),
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.notifications),
                        SizedBox(width: 12.w),
                        Text(
                          "Push notification",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.colorTextMainBlack,
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      activeColor: AppColors.colorSecondary,
                      value: isSwitched,
                      onChanged: (value) {
                        setState(() {
                          isSwitched = value;
                        });
                      },
                    )
                  ],
                ),
                SizedBox(height: 24.h),
                const Divider(height: 1),
                SizedBox(height: 24.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.folder_zip),
                    SizedBox(width: 12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Download Location",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.colorTextMainBlack,
                          ),
                        ),
                        Text(
                          "//media/external/images/media/",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.colorBlackLowEmp,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 24.h),
                const Divider(height: 1),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.download_for_offline),
                        SizedBox(width: 12.w),
                        Text(
                          "Ask where to save files",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.colorTextMainBlack,
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      activeColor: AppColors.colorSecondary,
                      value: isSwitched1,
                      onChanged: (value) {
                        setState(() {
                          isSwitched1 = value;
                        });
                      },
                    )
                  ],
                ),
                SizedBox(height: 24.h),
                const Divider(height: 1),
                SizedBox(height: 24.h),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PrivacyPolicyScreen()));
                  },
                  child: Container(
                    height: 25.h,
                    width: double.infinity,
                    child: Row(
                      children: [
                        const Icon(Icons.policy),
                        SizedBox(width: 12.w),
                        Text(
                          "Privacy policy",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.colorTextMainBlack,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
