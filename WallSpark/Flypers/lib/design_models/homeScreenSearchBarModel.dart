import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../screens/searchResult.dart';
import '../widgets/appColors.dart';


class HomeScreenSearchBarModel extends StatefulWidget {
  const HomeScreenSearchBarModel({Key? key}) : super(key: key);

  @override
  State<HomeScreenSearchBarModel> createState() =>
      _HomeScreenSearchBarModelState();
}

class _HomeScreenSearchBarModelState extends State<HomeScreenSearchBarModel> {
  bool _expanded = false;
  final myController = TextEditingController();
  String _text = '';

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  void _onPress() {
    setState(() {
      String text = myController.text.toLowerCase();
      _text = text[0].toUpperCase() + text.substring(1);
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SearchResult(
              data: _text,
            )));
  }



  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: _expanded ? MediaQuery.of(context).size.width - 20.w : 48.w,
      height: 70.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(33),
        color: AppColors.colorPrimary,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            type: MaterialType.transparency,
            child: IconButton(
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
              icon: Icon(
                _expanded ? Icons.close : Icons.search,
              ),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
            ),
          ),
          Expanded(
              child: Container(
                child: _expanded
                    ?  TextField(
                  controller: myController,
                  style: TextStyle(color: Colors.white),
                  cursorColor: AppColors.colorWhite,
                  decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: TextStyle(color: AppColors.colorWhiteLowEmp),
                      contentPadding: EdgeInsets.fromLTRB(5, 8, 20, 10),
                      border: InputBorder.none),
                )
                    : null,
              )),
          if (_expanded) IconButton(
            onPressed: _onPress,
            icon: Icon(Icons.search),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
          ),
        ],
      ),
    );
  }
}
