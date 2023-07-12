import 'package:WallSpark/screens/settingScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterfire_ui/firestore.dart';
import '../design_models/categoriesColorModel.dart';
import '../models/data_model.dart';
import '../widgets/appColors.dart';
import 'artWorkScreen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  showExitPopup() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            content: Text(
              "Do you want to exit?",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppColors.colorTextMainBlack,
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp),
            ),
            contentPadding:
            EdgeInsets.only(left: 24, right: 24, top: 32, bottom: 24),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 30.h,
                    width: 72.w,
                    decoration: BoxDecoration(
                        color: AppColors.colorPrimary,
                        borderRadius: BorderRadius.circular(100)),
                    child: InkWell(
                      onTap: () {
                        SystemNavigator.pop();
                      },
                      child: Center(
                        child: Text(
                          "Yes",
                          style: TextStyle(
                              color: AppColors.colorWhite,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    height: 30.h,
                    width: 72.w,
                    decoration: BoxDecoration(
                        color: AppColors.colorWhite,
                        border: Border.all(
                            width: 1.w, color: AppColors.colorWhiteLowEmp),
                        borderRadius: BorderRadius.circular(100)),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Center(
                        child: Text(
                          "No",
                          style: TextStyle(
                              color: AppColors.colorTextMainBlack,
                              fontWeight: FontWeight.w300,
                              fontSize: 14.sp),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            actionsPadding: EdgeInsets.only(bottom: 32),
          );
        });
  }

  String screenName = "";

  final usersQuery = FirebaseFirestore.instance.collection('category')
      .withConverter<CategoryData>(
    fromFirestore: (snapshot, _) => CategoryData.fromJson(snapshot.data()!),
    toFirestore: (data, _) => data.toJson(),
  );


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showExitPopup();
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.colorWhite,
        appBar: AppBar(
            backgroundColor: AppColors.colorWhite,
            leading: IconButton(
              onPressed: () {
                String text = screenName.toString();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SettingScreen(
                          screenName: 'fromCategories',
                        )));
              },
              icon: Icon(
                Icons.menu,
                color: AppColors.colorBlack,
              ),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
            ),
            elevation: 0),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: FirestoreQueryBuilder<CategoryData>(
                  query: usersQuery,
                  builder: (context, snapshot, _){
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 6.h),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              "Colors",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 24.sp,
                                color: AppColors.colorTextMainBlack,
                              ),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          CategoriesColorModel(),
                          SizedBox(height: 20.h),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              "Categories",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 24.sp,
                                color: AppColors.colorTextMainBlack,
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1.7,
                                  //crossAxisSpacing: 12,
                                  mainAxisSpacing: 10),
                              padding: EdgeInsets.only(right: 12),
                              itemCount: snapshot.docs.length,
                              itemBuilder: (context, index) {
                                if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
                                  snapshot.fetchMore();
                                }
                                final data = snapshot.docs[index].data();
                                return Padding(
                                  padding: EdgeInsets.only(left: 12),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [AppColors.colorGradientStart, AppColors.colorGradientEnd],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                        borderRadius: BorderRadius.circular(12)
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => ArtWorkScreen(
                                                    data: data.name,
                                                  )));
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: NetworkImage(data.imageUrl),
                                                  fit: BoxFit.cover,
                                                )
                                            ),
                                            height: 50,
                                            child: /*Image(
                                            image: NetworkImage(data.imageUrl),
                                           fit: BoxFit.cover,
                                          ),*/
                                            Align(
                                                alignment: Alignment.bottomLeft,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(16.0),
                                                  child: Text(
                                                    data.name,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                )
                                            )
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                          ),
                          SizedBox(height: 100,)
                        ],
                      ),
                    );
                  }

              ),
            ),
          ],
        ),
      ),
    );
  }
}
