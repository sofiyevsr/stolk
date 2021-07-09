import 'package:flutter/material.dart';

class CategoryList extends StatefulWidget {
  CategoryList({Key? key}) : super(key: key);

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(
          25,
          (index) => Center(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Text("test"),
            ),
          ),
        ),
      ),
    );
  }
}
