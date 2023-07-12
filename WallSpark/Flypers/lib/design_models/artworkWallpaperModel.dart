import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ArtworkWallpaperModel extends StatefulWidget {
  const ArtworkWallpaperModel({Key? key}) : super(key: key);

  @override
  State<ArtworkWallpaperModel> createState() => _ArtworkWallpaperModelState();
}

class _ArtworkWallpaperModelState extends State<ArtworkWallpaperModel> {

  static final _db = FirebaseFirestore.instance;
  List<DocumentSnapshot> products = [];
  bool isLoading = false;
  bool hasMore = true;
  int documentLimit = 8;
  DocumentSnapshot? lastDocument;
  ScrollController _scrollController = ScrollController();

  getProducts(String categoryName) async {
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
          .where('color', isEqualTo: categoryName)
      //.orderBy('name')
          .limit(documentLimit)
          .get();
    } else {
      querySnapshot = await _db
          .collection('data')
          .where('color', isEqualTo: categoryName)
      //.orderBy('name')
          .startAfterDocument(lastDocument!)
          .limit(documentLimit)
          .get();
      print(1);
    }
    if (querySnapshot.docs.length < documentLimit) {
      hasMore = false;
    }
    lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
    products.addAll(querySnapshot.docs);
    print(products.length);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getProducts('Black');
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        getProducts('Black');
      }
    });

    return SizedBox(
      child: GridView.builder(
        physics: const ScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2 / 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 10),
        itemCount: products.length,
        itemBuilder: (BuildContext context, int index) {
          Map<String, dynamic>? data = products?[index].data() as Map<String, dynamic>?;
          return Padding(
              padding: const EdgeInsets.only(left: 12),
              child: /*ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image(
                            image: NetworkImage(data?['imageUrl']),
                            fit: BoxFit.cover,
                            height: 73.h,
                            width: 119.w,
                          ),
                        ),*/
              Container(height: 800,
                  child: Text(data?['imageUrl']))
          );
        },
      ),
    );
  }
}
