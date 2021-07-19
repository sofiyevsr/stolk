import 'package:feedapp/utils/@types/response/allNews.dart';
import 'package:feedapp/utils/services/server/newsService.dart';
import 'package:flutter/material.dart';

final news = NewsService();

class CategoryList extends StatefulWidget {
  final int current;
  final Function(int id) changeCategory;
  CategoryList({Key? key, required this.changeCategory, required this.current})
      : super(key: key);

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  var _isLoading = true;
  List<SingleCategory> _categories = [];

  @override
  void initState() {
    super.initState();
    news.getAllCategories().then((value) {
      setState(() {
        _categories = value.categories;
        _isLoading = false;
      });
    }).catchError((e) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Widget _buildItem(SingleCategory category) {
    if (category.id == widget.current) {
      return Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              category.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              height: 4,
              width: 4,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ],
        ),
      );
    }
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Text(
          category.name,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading == true) {
      return SizedBox(
        height: 80,
      );
    }
    return SizedBox(
      height: 80,
      child: ListView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          SingleCategory.fromJSON({"id": 0, "name": "all"}),
          ..._categories
        ]
            .map(
              (e) => GestureDetector(
                key: Key(
                  e.id.toString(),
                ),
                onTap: () => widget.changeCategory(e.id),
                child: _buildItem(e),
              ),
            )
            .toList(),
      ),
    );
  }
}
