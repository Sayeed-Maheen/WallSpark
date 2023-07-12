import 'package:WallSpark/screens/splashScreen.dart';
import 'package:WallSpark/widgets/appColors.dart';
import 'package:WallSpark/widgets/customSwatch.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent));

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 800),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'WallSpark: AI Wallpapers',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: "Manrope",
              primarySwatch: createMaterialColor(AppColors.colorPrimary),
            ),
            home: SplashScreen(),
          );
        });
  }
}
