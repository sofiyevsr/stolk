import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stolk/components/common/lottieLoader.dart';
import 'package:stolk/logic/blocs/authBloc/auth.dart';
import 'package:stolk/utils/common.dart';

class SettingsHeaderSection extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  SettingsHeaderSection({Key? key}) : super(key: key);

  final trailingTextStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18,
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (ctx, state) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: _UserDetails(state: state),
                ),
                const LottieLoader(
                  asset: "assets/lottie/account.json",
                  size: Size(140, 140),
                ),
              ],
            ),
            if (state is AuthorizedState)
              Column(
                children: [
                  Row(
                    key: const ValueKey("name"),
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: AutoSizeText(
                          tr("settings.fields.name"),
                          maxLines: 2,
                        ),
                      ),
                      AutoSizeText(
                        state.user.firstName + " " + state.user.lastName,
                        style: trailingTextStyle,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Divider(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Row(
                    key: const ValueKey("created_at"),
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: AutoSizeText(
                          tr("settings.fields.created_at"),
                          maxLines: 2,
                        ),
                      ),
                      AutoSizeText(
                        convertTime(state.user.createdAt, context),
                        style: trailingTextStyle,
                      ),
                    ],
                  ),
                  if (state.user.email != null)
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Divider(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Row(
                          key: const ValueKey("email"),
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: AutoSizeText(
                                tr("settings.fields.email"),
                                maxLines: 2,
                              ),
                            ),
                            AutoSizeText(
                              state.user.email!,
                              style: trailingTextStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                ],
              ),
          ],
        ),
      );
    });
  }
}

class _UserDetails extends StatelessWidget {
  final AuthState state;
  // ignore: prefer_const_constructors_in_immutables
  _UserDetails({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeText(
          state is AuthorizedState
              ? tr(
                  "settings.welcome",
                  args: [(state as AuthorizedState).user.firstName],
                )
              : tr("settings.guest_welcome"),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          minFontSize: 24,
          maxLines: 2,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: AutoSizeText(
            state is AuthorizedState
                ? tr("settings.description")
                : tr("settings.guest_description"),
            maxLines: 3,
            minFontSize: 16,
          ),
        ),
      ],
    );
  }
}
