import 'package:flutter/material.dart';
import 'package:comments_viewer_application/models/comments_model.dart';


import '../services/fetch_comments_services.dart';

class CommentsProvider with ChangeNotifier {
  List<CommentModel>? _comments;
  final FetchCommentsService fetchCommentsService;

  CommentsProvider({required this.fetchCommentsService});

  List<CommentModel>? get comments => _comments;

  Future<void> loadComments() async {
    _comments = await fetchCommentsService.fetchComments();
    notifyListeners();
  }
}
