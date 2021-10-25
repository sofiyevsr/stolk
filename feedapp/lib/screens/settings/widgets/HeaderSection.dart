import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).primaryColor, width: 3),
                    borderRadius: BorderRadius.circular(60.0),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.transparent, width: 3),
                      borderRadius: BorderRadius.circular(55.0),
                    ),
                    child: CircleAvatar(
                      child: Text(
                        user.firstName[0],
                        style: TextStyle(fontSize: 50),
                      ),
                      radius: 50.0,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${user.firstName} ${user.lastName}',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    if (user.confirmedAt != null)
                      Tooltip(
                        message: tr("tooltips.account_verified"),
                        child: Icon(Icons.verified, color: Colors.blue),
                      ),
                  ],
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
