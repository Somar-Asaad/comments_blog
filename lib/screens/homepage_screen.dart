import 'dart:developer';

import 'package:comments_viewer_application/services/alert_services.dart';
import 'package:comments_viewer_application/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../models/comments_model.dart';
import '../providers/comment_provider.dart';
import '../services/navigator_services.dart';

import '../services/remote_config_services.dart';
import '../widgets/shimmer_card_widget.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({Key? key}) : super(key: key);

  @override
  _HomepageScreenState createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  final GetIt _getIt = GetIt.instance;
  late RemoteConfigService _remoteConfigService;
  late NavigatorServices _navigatorServices;
  late CommentsProvider _commentsProvider;
  late AuthServices _authServices;
  late AlertServices _alertServices;

  @override
  void initState() {
    super.initState();
    _remoteConfigService = _getIt.get<RemoteConfigService>();
    _navigatorServices = _getIt.get<NavigatorServices>();
    _authServices = _getIt.get<AuthServices>();
    _alertServices = _getIt.get<AlertServices>();
    _commentsProvider = Provider.of<CommentsProvider>(context, listen: false);

    // Listen to config updates
    _remoteConfigService.onConfigUpdated().listen((_) {
      setState(() {
        fetchRemote();
        // Handle UI updates based on config changes here
      });
    });
  }

  fetchRemote() async {
    await _remoteConfigService.fetchAndActivateConfig();
  }

  @override
  Widget build(BuildContext context) {
    bool isEmailMasked = _remoteConfigService.isEmailMasked();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Theme
            .of(context)
            .primaryColor,
      ),
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: FutureBuilder(
              future: _commentsProvider.loadComments(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Expanded(
                    child: Column(
                      children:
                      List.generate(6, (index) => const ShimmerCard()),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading comments'));
                } else {
                  final comments = _commentsProvider.comments;

                  if (comments == null || comments.isEmpty) {
                    return const Center(child: Text('No comments found'));
                  }

                  return ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      return _buildCommentBox(
                          comments[index], context, isEmailMasked);
                    },
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(context) {
    return AppBar(
      backgroundColor: Theme
          .of(context)
          .primaryColor,
      title: Text(
        'Comments',
        style: Theme
            .of(context)
            .textTheme
            .headlineSmall,
      ),
      actions: [
        IconButton(
          onPressed: () async {
            bool result = await _authServices.signOut();
            if (result) {
              _navigatorServices.pushReplacementNamed('/login');
              _alertServices.showToastBar(
                title: 'Successfully Signed Out!',
                icon: Icons.check,
              );
            }
          },
          icon: const Icon(
            Icons.logout,
            color: Color(0xFFF5F9FD),
          ),
        ),
      ],
    );
  }

  Widget _buildCommentBox(CommentModel comment, context, bool isEmailMasked) {
    String email = isEmailMasked ? _maskEmail(comment.email!) : comment.email!;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Theme
            .of(context)
            .colorScheme
            .primaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 23,
            backgroundColor: Theme
                .of(context)
                .colorScheme
                .secondary,
            child: Text(
              comment.name!.substring(0, 1),
              style: Theme
                  .of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCommentAuthorDetails(
                    'Name : ', '${comment.name}', context),
                _buildCommentAuthorDetails('Email : ', email, context),
                const SizedBox(
                  height: 5,
                ),
                _buildCommentBodyText('${comment.body}', context),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCommentAuthorDetails(String title, String value, context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: value,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
            ),
          )
        ],
        text: title,
        style: Theme
            .of(context)
            .textTheme
            .bodySmall!
            .copyWith(color: Colors.grey, fontStyle: FontStyle.italic),
      ),
    );
  }

  Widget _buildCommentBodyText(String text, context) {
    return Text(
      text,
      maxLines: 4,
      overflow: TextOverflow.ellipsis,
      style: Theme
          .of(context)
          .textTheme
          .bodySmall,
    );
  }

  String _maskEmail(String email) {
    log('entered');
    int atIndex = email.indexOf('@');
    if (atIndex > 2) {
      return email.replaceRange(2, atIndex, '***');
    }
    return email;
  }
}
