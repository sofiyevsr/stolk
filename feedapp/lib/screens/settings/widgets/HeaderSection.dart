import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stolk/components/common/lottieLoader.dart';
import 'package:stolk/logic/blocs/authBloc/auth.dart';

class SettingsHeaderSection extends StatelessWidget {
  const SettingsHeaderSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (ctx, state) {
        if (state is AuthorizedState) {
          final user = state.user;
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoSizeText(
                      '${user.firstName} ${user.lastName}',
                      style: const TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    if (user.confirmedAt != null)
                      Tooltip(
                        message: tr("tooltips.account_verified"),
                        child: const Icon(Icons.verified, color: Colors.blue),
                      ),
                  ],
                ),
              ],
            ),
          );
        }
        return const LottieLoader(
          asset: "assets/lottie/account.json",
          size: Size(200, 200),
        );
      },
    );
  }
}
