import 'package:easy_localization/easy_localization.dart';
import 'package:feedapp/logic/blocs/authBloc/auth.dart';
import 'package:feedapp/utils/@types/response/comments.dart';
import 'package:feedapp/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SingleCommentView extends StatelessWidget {
  final SingleComment comment;
  const SingleCommentView({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fullName = "${comment.firstName ?? ""} ${comment.lastName ?? ""}";
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
              if (state is AuthorizedState) {
                return CircleAvatar(
                  child: Text(state.user.firstName[0]),
                );
              }
              return CircleAvatar(
                child: Text(comment.firstName?[0] ?? ""),
              );
            }),
          ),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Column(
                          children: [
                            BlocBuilder<AuthBloc, AuthState>(
                                builder: (ctx, state) {
                              if (state is AuthorizedState) {
                                if (state.user.id == comment.userID) {
                                  return Text(
                                      tr(
                                        "me",
                                      ),
                                      style: textTheme.subtitle1);
                                }
                              }
                              return Text(
                                fullName,
                                style: textTheme.subtitle1,
                              );
                            }),
                            Text(
                              convertDiffTime(comment.createdAt, context),
                              style: textTheme.subtitle2,
                            ),
                          ],
                        )
                      ],
                    ),
                    PopupMenuButton(itemBuilder: (ctx) => []),
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    comment.comment,
                    textAlign: TextAlign.left,
                    style: textTheme.bodyText2?.copyWith(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
