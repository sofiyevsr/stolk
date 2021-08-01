import 'package:feedapp/logic/blocs/authBloc/auth.dart';
import 'package:feedapp/logic/blocs/commentsBloc/comments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentInput extends StatefulWidget {
  final int newsID;
  final Function() onEnd;
  CommentInput({
    Key? key,
    required this.newsID,
    required this.onEnd,
  }) : super(key: key);

  @override
  _CommentInputState createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  final _inputController = TextEditingController();

  Future<void> submitComment() async {
    if (_inputController.text.isNotEmpty) {
      final comments = context.read<CommentsBloc>();
      comments.add(AddCommentEvent(
        body: _inputController.text,
        newsID: widget.newsID,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = context.watch<AuthBloc>();
    return BlocListener<CommentsBloc, CommentsState>(
      listener: (ctx, state) {
        _inputController.clear();
        widget.onEnd();
      },
      listenWhen: (old, current) {
        if (old is CommentsStateSuccess &&
            current is CommentsStateSuccess &&
            current.isLoadingNext == false &&
            old.isLoadingNext == false) return true;
        return false;
      },
      child: Container(
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
          onSubmitted:
              auth.state is AuthorizedState ? (s) => submitComment() : null,
          controller: _inputController,
          enabled: auth.state is AuthorizedState,
          decoration: InputDecoration(
            filled: true,
            fillColor: theme.cardColor,
            suffixIcon: Material(
              color: theme.primaryColor.withOpacity(0.7),
              child: IconButton(
                onPressed: auth.state is AuthorizedState ? submitComment : null,
                icon: Icon(Icons.send_sharp),
              ),
            ),
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
    );
  }
}
