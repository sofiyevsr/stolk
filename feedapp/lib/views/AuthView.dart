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
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 20,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      tr("commons.welcome"),
                      style: const TextStyle(fontSize: 24),
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
                          text: tr("login.title"),
                        ),
                        Tab(
                          text: tr("register.title"),
                        ),
                      ],
                    ),
                  ),
                  AnimatedSize(
                    child: isLogin ? const LoginSection() : RegisterSection(),
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: const Divider(
                            thickness: 2,
                          ),
                        ),
                        Text("OR"),
                        Expanded(
                          child: const Divider(
                            thickness: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const RoundedLoginButtons(),
                ],
              ),
            ),
          ),
          if (canPop == true)
            Positioned(
              top: 8,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_sharp,
                  size: 32,
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
