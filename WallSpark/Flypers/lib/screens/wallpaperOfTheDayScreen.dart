import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterfire_ui/firestore.dart';
import '../models/data_model.dart';
import '../widgets/appColors.dart';
import '../widgets/custom_loading.dart';
import 'artWorkScreen2.dart';

class WallpaperOfTheDayScreen extends StatefulWidget {
  const WallpaperOfTheDayScreen({Key? key}) : super(key: key);

  @override
  State<WallpaperOfTheDayScreen> createState() => _WallpaperOfTheDayScreenState();
}

class _WallpaperOfTheDayScreenState extends State<WallpaperOfTheDayScreen> {


  final usersQuery = FirebaseFirestore.instance.collection('data')
      .withConverter<Data>(
    fromFirestore: (snapshot, _) => Data.fromJson(snapshot.data()!),
    toFirestore: (data, _) => data.toJson(),
  );



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
  void initState() {
    // TODO: implement initState
    super.initState();
    showCustomDialog(context);
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
            //title: Text('Wallpaper Of The Day',style: TextStyle(color: Colors.black),),
            elevation: 0),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                'Wallpaper of the day',
                style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.colorTextMainBlack),
              ),
            ),
            SizedBox(height: 16.h),
            FirestoreQueryBuilder<Data>(
                query: usersQuery,
                builder: (context, snapshot, _){
                  return Expanded(
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.8,
                            //crossAxisSpacing: 12,
                            mainAxisSpacing: 12),
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
                                    incrementViews(data.viewCount+1, data.imageId);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ArtworkScreen2(
                                              data : data.artistName,
                                              id: data.imageId,
                                            )));
                                  },
                                  child: Image(
                                    image: NetworkImage(data.thumbUrl),
                                    fit: BoxFit.cover,
                                    height: 73.h,
                                    width: 119.w,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                    ),
                  );
                }

            ),
            SizedBox(height: 16.h),
          ],
        )
    );
  }
}

