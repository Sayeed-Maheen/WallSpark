import 'dart:typed_data';
import 'package:WallSpark/screens/artWorkScreen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import '../constants.dart';
import '../widgets/appColors.dart';
import 'artWorkWallpaperScreen.dart';
import 'dart:io' show Platform;


class ArtworkScreen2 extends StatefulWidget {
  final String data;
  final String id;
  const ArtworkScreen2({Key? key,required this.data, required this.id}) : super(key: key);

  @override
  State<ArtworkScreen2> createState() => _ArtworkScreen2State();
}

class _ArtworkScreen2State extends State<ArtworkScreen2> {

  static final _db = FirebaseFirestore.instance;
  final usersQuery = FirebaseFirestore.instance.collection('category');

  final double _imageHeight = 500.h;
  final double _imageWidth = 250.w;


  int _current = 0 ;
  String imageForWallpaper = '';

  String? _selectedData;

  _onSelected(String data) {
    setState(() {
      _selectedData = data;
    });
  }
  Future<void> _setWallpaperForHome(String imageUrl) async {
    var file = await DefaultCacheManager().getSingleFile(imageUrl);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Setting wallpaper...')));
    final result = await WallpaperManager.setWallpaperFromFile(file.path, WallpaperManager.HOME_SCREEN);
    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Wallpaper set successfully.')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to set wallpaper.')));
    }
  }

  Future<void> _setWallpaperForLock(String imageUrl) async {
    var file = await DefaultCacheManager().getSingleFile(imageUrl);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Setting wallpaper...')));
    final result = await WallpaperManager.setWallpaperFromFile(file.path, WallpaperManager.LOCK_SCREEN);
    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Wallpaper set successfully.')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to set wallpaper.')));
    }
  }

  Future<void> _setWallpaperForBoth(String imageUrl) async {
    var file = await DefaultCacheManager().getSingleFile(imageUrl);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Setting wallpaper...')));
    final result = await WallpaperManager.setWallpaperFromFile(file.path, WallpaperManager.BOTH_SCREEN);
    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Wallpaper set successfully.')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to set wallpaper.')));
    }
  }

  Future<void> _save(String image, BuildContext context) async {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Saving image...'),
        ),
      );
    }

    TextStyle _selectedStyle = const TextStyle(
      color: Colors.white,
      // Set any other style properties as per your design requirements
    );

    var status = await Permission.storage.request();
    if (status.isGranted) {
      var response = await Dio().get(
        image,
        options: Options(responseType: ResponseType.bytes),
      );

      final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 60,
        name: "hello",
      );

      print(result);

      if (result['isSuccess']) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Image saved successfully.'),
              duration: Duration(seconds: 1),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to save image.'),
              duration: Duration(seconds: 1),
            ),
          );
        }
      }
    } else if (status.isPermanentlyDenied || status.isDenied) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Permission denied to access storage.'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    }
  }

  InterstitialAd? interstitialAd;
  int _numInterstitialLoadAttempts = 0;

  static final AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createInterstitial();
  }
  void createInterstitial() {
    InterstitialAd.load(
      adUnitId: Platform.isAndroid ? adId : adId,
      request: request,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          print("Ad Loaded");
          interstitialAd = ad;

          _numInterstitialLoadAttempts = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print("Ad Failed to Load");
          interstitialAd = null;

          _numInterstitialLoadAttempts += 1;
          if (_numInterstitialLoadAttempts < 3) {
            createInterstitial();
          }
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (interstitialAd == null) {
      print('Warning: attempt to show interstitialAd before loaded.');
      return;
    }
    interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        createInterstitial();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createInterstitial();
      },
    );

    interstitialAd!.setImmersiveMode(true);
    interstitialAd!.show(
      //     onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      //   print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
      // }
    );
    interstitialAd = null;
  }

  @override
  void dispose() {
    super.dispose();
    interstitialAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: AppColors.colorWhite,
        appBar: AppBar(
            backgroundColor: AppColors.colorWhite,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: AppColors.colorBlack,
              ),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
            ),
            elevation: 0),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _db
                    .collection('data')
                    .orderBy('imageId')
                    .startAt([widget.id])
                    .limit(12)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "${snapshot.data!.docs[_current]['tag']} Wallpaper",
                            style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.colorTextMainBlack),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.visibility_outlined,
                                  size: 18,
                                  color: AppColors.colorBlackMidEmp),
                              SizedBox(width: 4.w),
                              Text(
                                "${snapshot.data!.docs[_current]['viewCount']} views",
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.colorBlackMidEmp),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h),
                        CarouselSlider(
                            options: CarouselOptions(
                              enlargeCenterPage: true,
                              aspectRatio: 11.w / 14.h,
                              viewportFraction: 0.7.w,
                              enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _current = index;
                                  imageForWallpaper = snapshot
                                      .data!.docs[_current]['imageUrl'];
                                });
                              },
                            ),
                            items: snapshot.data!.docs.map((e) {
                              return Builder(builder: (BuildContext context) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ArtworkWallpaperScreen(
                                                    imageData: e['imageId'],
                                                  )));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              AppColors.colorGradientStart,
                                              AppColors.colorGradientEnd
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                          borderRadius:
                                          BorderRadius.circular(20)),
                                      child: ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(20.0),
                                        child: Image.network(
                                          e['imageUrl'],
                                          fit: BoxFit.cover,
                                          height: _imageHeight,
                                          width: _imageWidth,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                                //Text('${e['imageId']}');
                              });
                            }).toList()),
                        SizedBox(height: 16.h),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: SizedBox(
                            height: 35,
                            child: FirestoreListView<Map<String, dynamic>>(
                              scrollDirection: Axis.horizontal,
                              query: usersQuery,
                              itemBuilder: (context, snapshot) {
                                Map<String, dynamic> data = snapshot.data();
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: FilterChip(
                                    showCheckmark: false,
                                    backgroundColor: _selectedData == data
                                        ? AppColors.colorPrimary
                                        : AppColors.colorWhite,
                                    label: InkWell(
                                      onTap: (){
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => ArtWorkScreen(
                                                  data: data['name'],
                                                )));
                                      },
                                      child: Text(
                                        data['name'],
                                        style: const TextStyle(color: AppColors.colorBlackMidEmp),
                                      ),
                                    ),
                                    shape: const StadiumBorder(
                                      side: BorderSide(color: AppColors.colorWhiteLowEmp),
                                    ),
                                    padding: const EdgeInsets.all(5),
                                    onSelected: (_) => _onSelected(data['name']),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Center(
                          child: Container(
                            height: 64.h,
                            width: 268.w,
                            decoration: BoxDecoration(
                                color: AppColors.colorPrimary,
                                borderRadius: BorderRadius.circular(33)),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
                                  onTap: () {
                                    // showModalBottomSheet(
                                    //   shape: const RoundedRectangleBorder(
                                    //     borderRadius: BorderRadius.only(
                                    //       topLeft: Radius.circular(24),
                                    //       topRight: Radius.circular(24),
                                    //     ),
                                    //   ),
                                    //   context: context,
                                    //   builder: (BuildContext context) {
                                    //     return Container(
                                    //       height: 300.h,
                                    //       child: Padding(
                                    //         padding:
                                    //         const EdgeInsets.symmetric(
                                    //             horizontal: 24),
                                    //         child: Column(
                                    //           children: <Widget>[
                                    //             SizedBox(height: 16.h),
                                    //             Image.asset(
                                    //                 "assets/images/box.png",
                                    //                 height: 6.h,
                                    //                 width: 40.w),
                                    //             SizedBox(height: 24.h),
                                    //             Text(
                                    //               "What would like to do?",
                                    //               style: TextStyle(
                                    //                   fontSize: 16.sp,
                                    //                   fontWeight:
                                    //                   FontWeight.w700,
                                    //                   color: AppColors
                                    //                       .colorTextMainBlack),
                                    //             ),
                                    //             SizedBox(height: 24.h),
                                    //             Container(
                                    //               child: Row(
                                    //                 children: [
                                    //                   Image.asset(
                                    //                     "assets/images/phone.png",
                                    //                     height: 20.h,
                                    //                     width: 20.w,
                                    //                   ),
                                    //                   SizedBox(width: 12.w),
                                    //                   InkWell(
                                    //                     onTap: () {
                                    //                       _setWallpaperForHome(
                                    //                           snapshot.data
                                    //                               ?.docs[
                                    //                           _current]
                                    //                           [
                                    //                           'imageUrl']);
                                    //                       Navigator.pop(
                                    //                           context);
                                    //                     },
                                    //                     child: Text(
                                    //                       'Set on home screen',
                                    //                       style: TextStyle(
                                    //                           fontSize: 14.sp,
                                    //                           fontWeight:
                                    //                           FontWeight
                                    //                               .w400,
                                    //                           color: AppColors
                                    //                               .colorTextMainBlack),
                                    //                     ),
                                    //                   ),
                                    //                 ],
                                    //               ),
                                    //             ),
                                    //             SizedBox(height: 12.h),
                                    //             const Divider(height: 1),
                                    //             SizedBox(height: 16.h),
                                    //             Container(
                                    //               child: Row(
                                    //                 children: [
                                    //                   Image.asset(
                                    //                     "assets/images/lockPhone.png",
                                    //                     height: 20.h,
                                    //                     width: 20.w,
                                    //                   ),
                                    //                   SizedBox(width: 12.w),
                                    //                   InkWell(
                                    //                     onTap: () {
                                    //                       _setWallpaperForLock(
                                    //                           snapshot.data
                                    //                               ?.docs[
                                    //                           _current]
                                    //                           [
                                    //                           'imageUrl']);
                                    //                       Navigator.pop(
                                    //                           context);
                                    //                     },
                                    //                     child: Text(
                                    //                       "Set on lock screen",
                                    //                       style: TextStyle(
                                    //                           fontSize: 14.sp,
                                    //                           fontWeight:
                                    //                           FontWeight
                                    //                               .w400,
                                    //                           color: AppColors
                                    //                               .colorTextMainBlack),
                                    //                     ),
                                    //                   ),
                                    //                 ],
                                    //               ),
                                    //             ),
                                    //             SizedBox(height: 12.h),
                                    //             const Divider(height: 1),
                                    //             SizedBox(height: 16.h),
                                    //             Container(
                                    //               child: Row(
                                    //                 children: [
                                    //                   Image.asset(
                                    //                     "assets/images/lockPhone2.png",
                                    //                     height: 20.h,
                                    //                     width: 20.w,
                                    //                   ),
                                    //                   SizedBox(width: 12.w),
                                    //                   InkWell(
                                    //                     onTap: () {
                                    //                       _setWallpaperForBoth(
                                    //                           snapshot.data
                                    //                               ?.docs[
                                    //                           _current]
                                    //                           [
                                    //                           'imageUrl']);
                                    //                       Navigator.pop(
                                    //                           context);
                                    //                     },
                                    //                     child: Text(
                                    //                       'Set on both screen',
                                    //                       style: TextStyle(
                                    //                           fontSize: 14.sp,
                                    //                           fontWeight:
                                    //                           FontWeight
                                    //                               .w400,
                                    //                           color: AppColors
                                    //                               .colorTextMainBlack),
                                    //                     ),
                                    //                   ),
                                    //                 ],
                                    //               ),
                                    //             ),
                                    //             SizedBox(height: 12.h),
                                    //             const Divider(height: 1),
                                    //             SizedBox(height: 16.h),
                                    //             Container(
                                    //               child: Row(
                                    //                 children: [
                                    //                   Image.asset(
                                    //                     "assets/images/save.png",
                                    //                     height: 24.h,
                                    //                     width: 24.w,
                                    //                   ),
                                    //                   SizedBox(width: 12.w),
                                    //                   InkWell(
                                    //                     onTap: () {
                                    //                       _save(snapshot.data
                                    //                           ?.docs[_current]
                                    //                       ['imageUrl'], context);
                                    //                       Navigator.pop(
                                    //                           context);
                                    //                       _showRewardedAd();
                                    //                     },
                                    //                     child: Text(
                                    //                       'Save to device',
                                    //                       style: TextStyle(
                                    //                           fontSize: 14.sp,
                                    //                           fontWeight:
                                    //                           FontWeight
                                    //                               .w400,
                                    //                           color: AppColors
                                    //                               .colorTextMainBlack),
                                    //                     ),
                                    //                   ),
                                    //                 ],
                                    //               ),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //     );
                                    //   },
                                    // );
                                    Fluttertoast.showToast(
                                      msg: 'Coming soon....',
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.grey[700],
                                      textColor: Colors.white,
                                    );
                                  },
                                  child: const Icon(
                                    Icons.format_paint_outlined,
                                    color: AppColors.colorWhite,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    _save(snapshot.data
                                        ?.docs[_current]
                                    ['imageUrl'], context);
                                    _showInterstitialAd();
                                  },
                                  child: Container(
                                      height: 40.h,
                                      width: 40.w,
                                      child: SvgPicture.asset(
                                          "assets/images/download.svg")),
                                ),
                                 InkWell(
                                  onTap: (){
                                    Fluttertoast.showToast(
                                      msg: 'Coming soon....',
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.grey[700],
                                      textColor: Colors.white,
                                    );
                                  },
                                  child: const Icon(
                                    Icons.more_horiz_rounded,
                                    color: AppColors.colorWhite,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        )
    );
  }
}