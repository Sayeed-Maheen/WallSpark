import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/appColors.dart';
import '../widgets/custom_loading.dart';
import 'artWorkScreen2.dart';

class SearchResult extends StatefulWidget {
  final String data;
  const SearchResult({Key? key,required this.data}) : super(key: key);
  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  QuerySnapshot? querySnapshot;
  static final _db = FirebaseFirestore.instance;

  List<DocumentSnapshot> searchResult = [];
  bool isLoading = false;
  bool hasMore = true;
  int documentLimit = 10;
  DocumentSnapshot? lastDocument;
  ScrollController _scrollController = ScrollController();

  Future<void> getSearchResult() async {
    await Future(() async {
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
            .limit(documentLimit)
            .where('tag', isGreaterThanOrEqualTo: widget.data).where('tag', isLessThan: 'Zz')
            .get();
      } else {
        querySnapshot = await _db
            .collection('data')
            .startAfterDocument(lastDocument!)
            .limit(documentLimit)
            .get();
        print(1);
      }

      if (querySnapshot.docs.length < documentLimit) {
        hasMore = false;
      }
      lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
      searchResult.addAll(querySnapshot.docs);
      print(searchResult.length);
      setState(() {
        isLoading = false;
      });
    });
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
  void initState() {
    getSearchResult();
    // TODO: implement initState
    super.initState();
    showCustomDialog(context);
  }

  @override
  Widget build(BuildContext context) {

    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        getSearchResult();
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
              'Search result',
              style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.colorTextMainBlack),
            ),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  //crossAxisSpacing: 12,
                  mainAxisSpacing: 12),
              physics: const BouncingScrollPhysics(),
              controller: _scrollController,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: searchResult.length,
              padding: EdgeInsets.only(right: 12),
              itemBuilder: (BuildContext context,int index) {
                Map<String, dynamic>? data = searchResult?[index].data() as Map<String, dynamic>?;
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
        ],
      ),
    );
  }
}
