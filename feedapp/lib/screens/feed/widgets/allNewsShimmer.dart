import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

const NEWS_HEIGHT = 300.0;

class AllNewsShimmer extends StatelessWidget {
  const AllNewsShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade400,
      highlightColor: Colors.white,
      child: ListView(
        children: List.generate(
          3,
          (index) => Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: CircleAvatar(),
                    ),
                    Expanded(
                      child: Container(
                        height: 10,
                        margin: const EdgeInsets.only(right: 80),
                        color: Colors.blue,
                      ),
                    ),
                    Icon(
                      Icons.adaptive.more,
                      size: 32,
                    ),
                  ],
                ),
                Container(
                  height: NEWS_HEIGHT,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                Column(
                  children: List.generate(
                    3,
                    (index) => Container(
                      height: 10,
                      width: 280 / index,
                      margin: const EdgeInsets.all(5),
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
