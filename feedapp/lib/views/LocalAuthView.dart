import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stolk/components/auth/login.dart';
import 'package:stolk/components/auth/register.dart';

class LocalAuthView extends StatelessWidget {
  final TabController controller;
  final bool isLogin;
  const LocalAuthView({
    Key? key,
    required this.controller,
    required this.isLogin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SingleChildScrollView(
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
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  tr("commons:welcome"),
                  style: TextStyle(fontSize: 24),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TabBar(
                  controller: controller,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelStyle: Theme.of(context).textTheme.headline6?.copyWith(
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
                child: isLogin ? LoginSection() : RegisterSection(),
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
              )
            ],
          ),
        ),
      ),
    );
  }
}
