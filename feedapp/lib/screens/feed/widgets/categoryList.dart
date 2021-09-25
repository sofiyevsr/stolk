import 'package:easy_localization/easy_localization.dart';
import 'package:stolk/utils/@types/response/allNews.dart';
import 'package:stolk/utils/services/server/newsService.dart';
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
  bool _isLoading = true;
  List<SingleCategory> _categories = [];

  @override
  void initState() {
    super.initState();
    news.getAllCategories().then((value) {
      if (mounted)
        setState(() {
          _categories = value.categories;
          _isLoading = false;
        });
    }).catchError((e) {
      if (mounted)
        setState(() {
          _isLoading = false;
        });
    });
  }

  Widget _buildItem(SingleCategory category) {
    final isCurrent = category.id == widget.current;
    return Container(
      width: 140,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white,
          width: 5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/static/satellite.jpg",
                fit: BoxFit.fill,
              ),
            ),
            Positioned.fill(
              child: Center(
                child: Text(
                  tr("categories.${category.name}"),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: isCurrent ? FontWeight.bold : null,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading == true) {
      return SizedBox(
        height: 100,
      );
    }

    final cats = [
      SingleCategory.fromJSON({"id": 0, "name": "all"}),
      ..._categories
    ];

    return SizedBox(
      height: 100,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: cats.length,
        itemBuilder: (ctx, index) => GestureDetector(
          key: Key(
            cats[index].id.toString(),
          ),
          onTap: () => widget.changeCategory(cats[index].id),
          child: _buildItem(cats[index]),
        ),
      ),
    );
  }
}
