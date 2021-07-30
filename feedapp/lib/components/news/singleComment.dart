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

    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(),
                  Column(
                    children: [
                      BlocBuilder<AuthBloc, AuthState>(builder: (ctx, state) {
                        if (state is AuthorizedState) {
                          if (state.user.id == comment.userID) {
                            return Text(
                              tr(
                                "comment.me",
                              ),
                              style: Theme.of(context).textTheme.headline6,
                            );
                          }
                        }
                        return Text(
                          fullName,
                          style: Theme.of(context).textTheme.headline6,
                        );
                      }),
                      Text(
                        convertDiffTime(comment.createdAt, context),
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ],
                  )
                ],
              ),
              PopupMenuButton(itemBuilder: (ctx) => []),
            ],
          ),
          Text(
            comment.comment,
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}
