import 'package:easy_localization/easy_localization.dart';
import 'package:feedapp/components/auth/login.dart';
import 'package:feedapp/components/auth/register.dart';
import "package:flutter/material.dart";
import 'package:feedapp/utils/services/app/navigationService.dart';

class AuthView extends StatefulWidget {
  final bool isLogin;
  const AuthView({Key? key, this.isLogin = true}) : super(key: key);

  @override
  _AuthViewState createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  bool _isLogin = true;

  @override
  void initState() {
    super.initState();

    _controller = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.isLogin == true ? 0 : 1,
    )..addListener(() {
        final kIndex = _controller.index == 0;
        if (_isLogin != kIndex) {
          setState(() {
            _isLogin = kIndex;
          });
        }
      });

    setState(() {
      _isLogin = _controller.index == 0;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canPop = NavigationService.key.currentState?.canPop();
    return Scaffold(
      appBar: canPop == true
          ? AppBar(
              leading: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: Icon(
                  Icons.arrow_back_sharp,
                  size: 30,
                  color: theme.primaryColor,
                ),
                onPressed: () {
                  NavigationService.pop();
                },
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
            )
          : null,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
                color: Theme.of(context).accentColor.withOpacity(.9),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                margin: const EdgeInsets.all(30),
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).primaryColor.withOpacity(.4),
                        ),
                      ),
                      child: TabBar(
                        controller: _controller,
                        indicatorSize: TabBarIndicatorSize.tab,
                        unselectedLabelColor: Colors.black,
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
                    AnimatedCrossFade(
                      firstChild: LoginPage(),
                      secondChild: RegisterPage(),
                      secondCurve: Curves.easeIn,
                      firstCurve: Curves.easeIn,
                      crossFadeState: _isLogin
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      duration: const Duration(milliseconds: 450),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
