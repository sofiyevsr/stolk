import 'package:flutter/material.dart';

class CategoryList extends StatefulWidget {
  CategoryList({Key? key}) : super(key: key);

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  int _current = 0;

  Widget _buildItem(int index) {
    if (index == _current) {
      return Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "test",
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
          "test",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: List.generate(
          25,
          (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _current = index;
                });
              },
              child: _buildItem(index),
            );
          },
        ),
      ),
    );
  }
}
