import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/appColors.dart';
import '../widgets/custom_loading.dart';
import 'artWorkScreen2.dart';

class RecentlyUpdatedScreen extends StatefulWidget {
  RecentlyUpdatedScreen({Key? key,}) : super(key: key);

  @override
  State<RecentlyUpdatedScreen> createState() => _RecentlyUpdatedScreenState();
}

class _RecentlyUpdatedScreenState extends State<RecentlyUpdatedScreen> {

  static final _db = FirebaseFirestore.instance;
  List<DocumentSnapshot> recentlyUpdated = [];
  bool isLoading2 = false;
  bool hasMore2 = true;
  int documentLimit2 = 14;
  DocumentSnapshot? lastDocument2;
  ScrollController _scrollControllerSecond = ScrollController();

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
            .limit(documentLimit2)
            .get();
      } else {
        querySnapshot = await _db
            .collection('data')
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

    _scrollControllerSecond.addListener(() {
      double maxScroll = _scrollControllerSecond.position.maxScrollExtent;
      double currentScroll = _scrollControllerSecond.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        getRecentlyUpdated();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.colorWhite,
      appBar: AppBar(
          backgroundColor: AppColors.colorWhite,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
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
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(
              'Recently updated',
              style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.colorTextMainBlack),
            ),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  //crossAxisSpacing: 12,
                  mainAxisSpacing: 12),
              controller: _scrollControllerSecond,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: recentlyUpdated.length,
              padding: EdgeInsets.only(right: 12),
              itemBuilder: (BuildContext context,int index) {
                Map<String, dynamic>? data = recentlyUpdated?[index].data() as Map<String, dynamic>?;
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
                  /*Text(data?['imageUrl'])*/
                );
              },
            ),
          ),
          //SizedBox(height: 100.h),
        ],
      ),    );
  }
}

