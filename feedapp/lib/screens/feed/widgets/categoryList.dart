import 'package:easy_localization/easy_localization.dart';
import 'package:stolk/components/common/customCachedImage.dart';
import 'package:stolk/utils/@types/response/allNews.dart';
import 'package:stolk/utils/constants.dart';
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
      height: 80,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isCurrent == true ? Colors.blue.shade500 : Colors.transparent,
          width: 5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomCachedImage(
                url: categoryImagesPrefix + category.imageSuffix,
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Opacity(
                opacity: 0.45,
                child: Container(color: Colors.black),
              ),
            ),
            Positioned.fill(
              child: Center(
                child: Text(
                  tr("categories.${category.name}"),
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
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
      SingleCategory.fromJSON(
        {"id": 0, "name": "all", "image_suffix": "all.jpg"},
      ),
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
