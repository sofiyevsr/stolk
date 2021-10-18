import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stolk/components/completeProfile/introduction.dart';
import 'package:stolk/components/completeProfile/sourcesSelection.dart';
import 'package:stolk/logic/blocs/sourcesBloc/sources.dart';

const length = 2;

class CompleteProfile extends StatefulWidget {
  const CompleteProfile({Key? key}) : super(key: key);

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  final _controller = PageController();
  int _current = 0;

  void nextPage() {
    if (_current < length - 1) {
      _controller.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  void prevPage() {
    if (_current >= 0) {
      _controller.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  void onPageChange(int i) {
    setState(() {
      _current = i;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 10),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  length,
                  (index) => Flexible(
                    flex: 1,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 350),
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: _current >= index ? Colors.blue : Colors.grey,
                      ),
                      height: 10,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: BlocProvider<SourcesBloc>(
                  create: (ctx) => SourcesBloc(),
                  child: PageView(
                    onPageChanged: onPageChange,
                    controller: _controller,
                    children: [
                      CompleteProfileIntroduction(nextPage: nextPage),
                      CompleteProfileSources(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
