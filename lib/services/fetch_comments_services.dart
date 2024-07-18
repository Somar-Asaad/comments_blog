import 'dart:developer';

import 'package:comments_viewer_application/models/comments_model.dart';
import 'package:dio/dio.dart';
import '../dio_client/dio_client.dart';

class FetchCommentsService {
  FetchCommentsService();

  Future<List<CommentModel>> fetchComments() async {
    try {
      Response response = await DioClient.instance.dio!.get('/comments');

      return commentModelFromJson(response.data as List<dynamic>);
    } catch (e) {
      log('Error fetching comments: $e');
      return [];
    }
  }
}
