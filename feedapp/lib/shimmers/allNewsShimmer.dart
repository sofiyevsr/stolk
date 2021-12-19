import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stolk/utils/ui/constants.dart';

const NEWS_HEIGHT = 200.0;

class AllNewsShimmer extends StatelessWidget {
  const AllNewsShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final crossCount =
        (media.size.width / SINGLE_NEWS_SIZE).clamp(1, 3).toInt();
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade400,
      highlightColor: Colors.white,
      child: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossCount,
          crossAxisSpacing: 20,
        ),
        children: List.generate(
          crossCount * 2,
          (index) => Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: CircleAvatar(),
                    ),
                    Expanded(
                      child: Container(
                        height: 10,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(
                    3,
                    (index) => Container(
                      height: 10,
                      margin: EdgeInsets.only(
                        left: (25 * (index + 1)).toDouble(),
                        right: (25 * (index + 1)).toDouble(),
                        top: 10,
                      ),
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
