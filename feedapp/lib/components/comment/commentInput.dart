import 'package:easy_localization/easy_localization.dart';
import 'package:stolk/logic/blocs/authBloc/auth.dart';
import 'package:stolk/logic/blocs/commentsBloc/comments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentInput extends StatefulWidget {
  final int newsID;
  final Function() onEnd;
  final Function(dynamic e) onError;
  CommentInput({
    Key? key,
    required this.newsID,
    required this.onEnd,
    required this.onError,
  }) : super(key: key);

  @override
  _CommentInputState createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  final _inputController = TextEditingController();

  Future<void> submitComment() async {
    if (_inputController.text.isNotEmpty) {
      final comments = context.read<CommentsBloc>();
      try {
        final data = await service.comment(
          widget.newsID,
          _inputController.text,
        );
        comments.add(AddCommentEvent(comment: data));
        _inputController.clear();
        widget.onEnd();
      } catch (e) {
        widget.onError(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = context.watch<AuthBloc>();
    final isInputEnabled = auth.state is AuthorizedState &&
        (auth.state as AuthorizedState).user.confirmedAt != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (auth.state is AuthorizedState &&
            (auth.state as AuthorizedState).user.confirmedAt == null)
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey,
                ),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              tr("messages.confirm_to_comment"),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        if (auth is AuthorizedState)
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 1,
                ),
              ],
            ),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: TextField(
              maxLength: 300,
              onSubmitted: (_) => submitComment(),
              controller: _inputController,
              enabled: isInputEnabled,
              decoration: InputDecoration(
                filled: true,
                fillColor: theme.cardColor,
                suffixIcon: Material(
                  color: theme.primaryColor.withOpacity(0.7),
                  child: IconButton(
                    onPressed: isInputEnabled ? submitComment : null,
                    icon: Icon(Icons.send_sharp, color: Colors.white),
                  ),
                ),
                counterStyle: TextStyle(color: Colors.white),
                contentPadding: const EdgeInsets.all(10),
                focusColor: Colors.transparent,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.zero,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: Colors.transparent),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
