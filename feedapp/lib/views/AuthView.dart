import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stolk/components/auth/login.dart';
import 'package:stolk/components/auth/register.dart';
import 'package:stolk/utils/services/app/navigationService.dart';

class AuthView extends StatelessWidget {
  final TabController controller;
  final bool isLogin;
  const AuthView({
    Key? key,
    required this.controller,
    required this.isLogin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canPop = NavigationService.key.currentState?.canPop();
    return LayoutBuilder(builder: (context, constraints) {
      final height = constraints.maxHeight;
      return Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                minHeight: height,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TweenAnimationBuilder<double>(
                      tween: Tween(begin: -1, end: 0),
                      curve: Curves.easeInOut,
                      duration: const Duration(milliseconds: 200),
                      builder: (context, tween, _) {
                        return FractionalTranslation(
                          translation: Offset(0, tween),
                          child: AnimatedContainer(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.symmetric(vertical: 20),
                            duration: const Duration(
                              milliseconds: 250,
                            ),
                            height: height / 3,
                            child: Image.asset(
                              "assets/static/login.png",
                            ),
                          ),
                        );
                      }),
                  TweenAnimationBuilder<double>(
                      tween: Tween(begin: 1, end: 0),
                      curve: Curves.easeInOut,
                      duration: const Duration(milliseconds: 200),
                      builder: (context, animation, _) {
                        return FractionalTranslation(
                          translation: Offset(0, animation),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    tr("commons.welcome"),
                                    style: TextStyle(fontSize: 24),
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: TabBar(
                                    controller: controller,
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    labelStyle: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                    tabs: [
                                      Tab(
                                        text: tr("login.title"),
                                      ),
                                      Tab(
                                        text: tr("register.title"),
                                      ),
                                    ],
                                  ),
                                ),
                                AnimatedSize(
                                  child: isLogin
                                      ? LoginSection()
                                      : RegisterSection(),
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.easeInOut,
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                ],
              ),
            ),
          ),
          if (canPop == true)
            Positioned(
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_sharp,
                  size: 30,
                  color: theme.iconTheme.color,
                ),
                onPressed: () {
                  NavigationService.pop();
                },
              ),
            ),
        ],
      );
    });
  }
}
