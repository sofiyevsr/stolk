import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stolk/logic/blocs/authBloc/utils/AuthBloc.dart';
import 'package:stolk/screens/sources/sources.dart';
import 'package:stolk/utils/services/server/authService.dart';

final _service = AuthService();

class CompleteProfileSources extends StatefulWidget {
  CompleteProfileSources({Key? key}) : super(key: key);

  @override
  _CompleteProfileSourcesState createState() => _CompleteProfileSourcesState();
}

class _CompleteProfileSourcesState extends State<CompleteProfileSources> {
  bool _isRequestOn = false;

  void onPressed() async {
    setState(() {
      _isRequestOn = true;
    });
    try {
      final response = await _service.completeProfile();
      AuthBloc.instance.add(
        CompleteProfileEvent(completedAt: response.completedAt),
      );
    } catch (e) {}
    setState(() {
      _isRequestOn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SourcesPage(),
        ),
        ElevatedButton(
          onPressed: _isRequestOn ? null : onPressed,
          child: Text(
            tr("intro.finish"),
          ),
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
