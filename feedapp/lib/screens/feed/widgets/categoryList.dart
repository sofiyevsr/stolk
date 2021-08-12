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
    final theme = Theme.of(context);
    if (category.id == widget.current) {
      return Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              tr("categories.${category.name}"),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              height: 4,
              width: 4,
              decoration: BoxDecoration(
                color: theme.iconTheme.color,
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

    final cats = [
      SingleCategory.fromJSON({"id": 0, "name": "all"}),
      ..._categories
    ];

    return SizedBox(
      height: 60,
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
