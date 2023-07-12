import 'package:WallSpark/screens/recentlyUpdatedScreen.dart';
import 'package:WallSpark/screens/settingScreen.dart';
import 'package:WallSpark/screens/wallpaperOfTheDayScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../design_models/homePageCarouselModel.dart';
import '../design_models/homeScreenSearchBarModel.dart';
import '../widgets/appColors.dart';
import '../widgets/custom_loading.dart';
import 'artWorkScreen2.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
            const EdgeInsets.only(left: 24, right: 24, top: 32, bottom: 24),
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
            actionsPadding: const EdgeInsets.only(bottom: 32),
          );
        });
  }

  String screenName = "";

  static final _db = FirebaseFirestore.instance;

  List<DocumentSnapshot> recentlyUpdated = [];
  List<DocumentSnapshot> wallpaperOfTheDay = [];
  bool isLoading = false;
  bool isLoading2 = false;
  bool hasMore = true;
  bool hasMore2 = true;
  int documentLimit = 14;
  int documentLimit2 = 14;
  DocumentSnapshot? lastDocument;
  DocumentSnapshot? lastDocument2;
  ScrollController _scrollControllerFirst = ScrollController();
  ScrollController _scrollControllerSecond = ScrollController();

  bool showPop = true;


  Future<void>getWallpaperOfTheDay() async {
    if (!hasMore) {
      print('No More Products');
      return;
    }
    if (isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    QuerySnapshot querySnapshot;
    if (lastDocument == null) {
      querySnapshot = await _db
          .collection('data')
          .orderBy('viewCount',descending: true)
          .limit(documentLimit)
          .get();
    } else {
      querySnapshot = await _db
          .collection('data')
          .orderBy('viewCount',descending: true)
          .startAfterDocument(lastDocument!)
          .limit(documentLimit)
          .get();
      print(1);
    }

    if (querySnapshot.docs.length < documentLimit) {
      hasMore = false;
    }
    lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
    wallpaperOfTheDay.addAll(querySnapshot.docs);
    print(wallpaperOfTheDay.length);
    setState(() {
      isLoading = false;
    });
  }


  Future<void> getRecentlyUpdated() async {
    await Future(() async {
      if (!hasMore2) {
        print('No More Products');
        return;
      }
      if (isLoading2) {
        return;
      }
      setState(() {
        isLoading2 = true;
      });
      QuerySnapshot querySnapshot;
      if (lastDocument2 == null) {
        querySnapshot = await _db
            .collection('data')
            .orderBy('timestamp',descending: true)
            .limit(documentLimit2)
            .get();
      } else {
        querySnapshot = await _db
            .collection('data')
            .orderBy('timestamp',descending: true)
            .startAfterDocument(lastDocument2!)
            .limit(documentLimit2)
            .get();
        print(1);
      }

      if (querySnapshot.docs.length < documentLimit2) {
        hasMore2 = false;
      }
      lastDocument2 = querySnapshot.docs[querySnapshot.docs.length - 1];
      recentlyUpdated.addAll(querySnapshot.docs);
      print(recentlyUpdated.length);
      setState(() {
        isLoading2 = false;
      });
    });
  }
  

  @override
  void initState() {
    getRecentlyUpdated();
    getWallpaperOfTheDay();
    // TODO: implement initState
    super.initState();
    showCustomDialog(context);
  }

  void incrementViews(int views, String id) async{
    var collection = FirebaseFirestore.instance.collection('data');
    collection
        .doc(id)
        .update({'viewCount' : views}) // <-- Updated data
        .then((_) => print('Success'))
        .whenComplete(() => null)
        .catchError((error) => print('Failed: $error'));
  }


  @override
  Widget build(BuildContext context) {

    _scrollControllerFirst.addListener(() {
      double maxScroll = _scrollControllerFirst.position.maxScrollExtent;
      double currentScroll = _scrollControllerFirst.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        getWallpaperOfTheDay();
      }
    });

    _scrollControllerSecond.addListener(() {
      double maxScroll = _scrollControllerSecond.position.maxScrollExtent;
      double currentScroll = _scrollControllerSecond.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        getRecentlyUpdated();
      }
    });


    return WillPopScope(
      onWillPop: () async {
        showExitPopup();
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.colorWhite,
        appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                //String text = screenName.toString();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingScreen(
                          screenName: 'fromHome',
                        )));
              },
              icon: const Icon(
                Icons.menu,
                color: AppColors.colorWhite,
              ),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
            ),
            title: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 20.sp,
                  color: AppColors.colorWhite,
                ),
                children: [
                  const TextSpan(
                    text: "Wall",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const TextSpan(
                    text: "Spark",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              const Padding(
                padding: EdgeInsets.all(10),
                child: HomeScreenSearchBarModel(),
              ),
            ],
            elevation: 0),
        body: SingleChildScrollView(
          physics: const ScrollPhysics(),
          controller: _scrollControllerSecond,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(children: [
                Container(
                  height: 70.h,
                  color: AppColors.colorPrimary,
                ),
                const Positioned(child: HomePageCarouselModel()
                ),
              ]),
              SizedBox(height: 24.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Wallpaper of the day",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        color: AppColors.colorTextMainBlack,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const WallpaperOfTheDayScreen()));
                      },
                      child: Row(
                        children: [
                          Text(
                            "See all",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                              color: AppColors.colorSecondary,
                            ),

                          ),
                          SizedBox(width: 8.h),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.colorSecondary,
                            size: 16,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              SizedBox(
                height: 73.h,
                child: ListView.builder(
                  controller: _scrollControllerFirst,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: wallpaperOfTheDay.length,
                  padding: const EdgeInsets.only(right: 12),
                  itemBuilder: (BuildContext context,int index) {
                    Map<String, dynamic>? data = wallpaperOfTheDay[index].data() as Map<String, dynamic>?;
                    return Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Container(
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
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
                              incrementViews(data?['viewCount']+1, data?['imageId']);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ArtworkScreen2(
                                        data : data?['artistName'],
                                        id: data?['imageId'],
                                      )));
                            },
                            child: Image(
                              image: NetworkImage(data?['thumbUrl']),
                              fit: BoxFit.cover,
                              height: 73.h,
                              width: 119.w,
                            ),
                          ),
                        ),
                      ),
                      //Container(width:30,child: Text('${data?['viewCount']}'))
                    );
                  },
                ),
              ),
              SizedBox(height: 24.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Recently Updated",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        color: AppColors.colorTextMainBlack,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    RecentlyUpdatedScreen()));
                      },
                      child: Row(
                        children: [
                          Text(
                            "See all",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                              color: AppColors.colorSecondary,
                            ),
                          ),
                          SizedBox(width: 8.h),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.colorSecondary,
                            size: 16,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              SizedBox(
                //height: 73.h,
                // width: 50,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      //crossAxisSpacing: 12,
                      mainAxisSpacing: 12),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: recentlyUpdated.length,
                  padding: const EdgeInsets.only(right: 12),
                  itemBuilder: (BuildContext context,int index) {
                    Map<String, dynamic>? data = recentlyUpdated[index].data() as Map<String, dynamic>?;
                    return Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Container(
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
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
                              incrementViews(data?['viewCount']+1, data?['imageId']);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ArtworkScreen2(
                                        data : data?['artistName'],
                                        id: data?['imageId'],
                                      )));
                            },
                            child: Image(
                              image: NetworkImage(data?['thumbUrl']),
                              fit: BoxFit.cover,
                              height: 73.h,
                              width: 119.w,
                            ),
                            //child: Text('${data?['viewCount']}')
                          ),
                        ),
                      ),
                      /*Text(data?['imageUrl'])*/
                    );
                  },
                ),
              ),
              SizedBox(height: 100.h),
            ],
          ),
        ),
      ),
    );
  }
}