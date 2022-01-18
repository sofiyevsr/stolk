import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stolk/components/auth/login.dart';
import 'package:stolk/components/auth/register.dart';
import 'package:stolk/components/auth/roundedLoginButtons.dart';
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
    return SizedBox.expand(
      child: Stack(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 20,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(
                        Icons.account_circle_sharp,
                        size: 128,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.center,
                        child: AutoSizeText(
                          tr("commons.welcome"),
                          minFontSize: 28,
                          maxLines: 1,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: TabBar(
                          controller: controller,
                          indicatorSize: TabBarIndicatorSize.tab,
                          labelStyle:
                              Theme.of(context).textTheme.headline6?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                          tabs: [
                            Tab(
                              child: AutoSizeText(
                                tr("login.title"),
                                maxLines: 1,
                              ),
                            ),
                            Tab(
                              child: AutoSizeText(
                                tr("register.title"),
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedSize(
                        child:
                            isLogin ? const LoginSection() : RegisterSection(),
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Divider(
                                thickness: 2,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                tr("commons.or"),
                              ),
                            ),
                            const Expanded(
                              child: Divider(
                                thickness: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: const RoundedLoginButtons(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_sharp,
                  size: 32,
                ),
                padding: const EdgeInsets.all(16),
                onPressed: () {
                  NavigationService.pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
