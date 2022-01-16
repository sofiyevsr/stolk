import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stolk/components/common/centerLoadingWidget.dart';
import 'package:stolk/components/common/customCachedImage.dart';
import 'package:stolk/logic/blocs/newsBloc/news.dart';
import 'package:stolk/utils/@types/response/allNews.dart';
import 'package:stolk/utils/constants.dart';
import 'package:stolk/utils/services/server/newsService.dart';
import 'package:flutter/material.dart';

final news = NewsService();
const height = 75.0;

class CategoryList extends StatelessWidget {
  final int current;
  final Function(int id) changeCategory;
  const CategoryList({
    Key? key,
    required this.changeCategory,
    required this.current,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsBloc, NewsState>(builder: (ctx, state) {
      if ((state is NewsStateLoading && state.categories == null) ||
          state is NewsStateInitial) {
        return const SizedBox(
          height: height,
          child: CenterLoadingWidget(),
        );
      }
      if (state is NewsStateError) {
        return const SizedBox(
          height: height,
          child: Center(
            child: Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
          ),
        );
      }
      final cats = [
        SingleCategory.fromJSON(
          {"id": 0, "name": "all", "image_suffix": "all.jpg"},
        ),
      ];
      if (state is NewsStateWithData && state.data.categories != null) {
        cats.addAll(state.data.categories!);
      } else if (state is NewsStateNoData && state.categories != null) {
        cats.addAll(state.categories!);
      } else if (state is NewsStateLoading && state.categories != null) {
        cats.addAll(state.categories!);
      }

      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: cats.length,
        itemBuilder: (ctx, index) => GestureDetector(
            key: Key(
              cats[index].id.toString(),
            ),
            onTap: () => changeCategory(cats[index].id),
            child: _SingleCategory(
              current: current,
              category: cats[index],
            )),
      );
    });
  }
}

class _SingleCategory extends StatelessWidget {
  final int current;
  final SingleCategory category;
  const _SingleCategory({
    Key? key,
    required this.current,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isCurrent = category.id == current;
    return Container(
      width: 120,
      margin: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 15,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color:
              isCurrent == true ? CustomColorScheme.main : Colors.transparent,
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
                opacity: 0.50,
                child: Container(color: Colors.black),
              ),
            ),
            Positioned.fill(
              child: Center(
                child: Text(
                  tr("categories.${category.name}"),
                  style: const TextStyle(
                    fontSize: 22,
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
}
