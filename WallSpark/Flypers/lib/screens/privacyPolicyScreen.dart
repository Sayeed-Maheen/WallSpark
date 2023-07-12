import 'package:WallSpark/screens/settingScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/appColors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SettingScreen(
                        screenName: '',
                      )));
            },
            child: Icon(Icons.arrow_back,
                color: AppColors.colorBlack, size: 30)),
      ),
      body: Container(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(height: 40.h),
                SizedBox(height: 24.h),
                Text(
                  "Privacy policy",
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.colorBlack,
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  "1. Privacy Policy",
                  style: TextStyle(
                    color: AppColors.colorBlackHighEmp,
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "At Flypers App, we understand the importance of privacy and we are committed to protecting your personal information. This Privacy Policy outlines how we collect, use, and disclose your information when you use our app. By using our app, you agree to the terms of this Privacy Policy.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.colorBlackLowEmp,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 12.h),
                Text(
                  "2. Data that we collect",
                  style: TextStyle(
                    color: AppColors.colorBlackHighEmp,
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "When you use Flypers App, we may collect the following information:"
                      "\n\u2022Personal Information: such as your name, email address, and device information."
                      "\n\u2022Usage Information: such as the wallpapers you download or favorite, and your browsing and search history."
                      "\n\u2022Technical Information: such as your device type, operating system, and IP address.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.colorBlackLowEmp,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 12.h),
                Text(
                  "3. How We Use Your Information",
                  style: TextStyle(
                    color: AppColors.colorBlackHighEmp,
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "We use your information to provide you with a better experience when using our app. This includes:"
                      "\n\u2022Providing and improving our app's services and features.Sending you notifications about new wallpapers, promotions, or other relevant content."
                      "\n\u2022Customizing your app experience based on your usage and preferences."
                      "\n\u2022Conducting analytics to better understand how our app is used and to improve it over time."
                      "\n\u2022Responding to user inquiries and requests."
                      "\nWe do not sell or share your personal information with third parties for their direct marketing purposes without your consent. However, we may share your information with third-party service providers that help us provide our app's services, such as hosting providers and analytics providers. We may also disclose your information as required by law or to protect our rights, property, or safety.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.colorBlackLowEmp,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 12.h),
                Text(
                  "4. Security",
                  style: TextStyle(
                    color: AppColors.colorBlackHighEmp,
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "We take reasonable measures to protect your personal information from unauthorized access, use, or disclosure. However, no method of transmission over the internet or electronic storage is 100% secure, and we cannot guarantee absolute security.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.colorBlackLowEmp,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 12.h),
                Text(
                  "5. Updates to this Privacy Policy",
                  style: TextStyle(
                    color: AppColors.colorBlackHighEmp,
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "We may update this Privacy Policy from time to time. We will notify you of any material changes by posting the updated policy on our app or by other means.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.colorBlackLowEmp,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 12.h),
                Text(
                  "6. Contact Us",
                  style: TextStyle(
                    color: AppColors.colorBlackHighEmp,
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "If you have any questions about this Privacy Policy or our app's practices, please contact us at flypersapp@gmail.com.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.colorBlackLowEmp,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 12.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
