import 'package:comments_viewer_application/providers/comment_provider.dart';
import 'package:comments_viewer_application/services/auth_services.dart';
import 'package:comments_viewer_application/services/fetch_comments_services.dart';
import 'package:comments_viewer_application/services/navigator_services.dart';
import 'package:comments_viewer_application/theme/app_theme.dart';
import 'package:comments_viewer_application/utils.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:provider/provider.dart';

void main() async {
  await setup();
  runApp(MyApp());
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupFirebase();
  await registerServices();
}

class MyApp extends StatelessWidget {
  final GetIt _getIt = GetIt.instance;
  late NavigatorServices _navigatorServices;
  late AuthServices _authServices;
  late FetchCommentsService _fetchCommentsService;
  MyApp({super.key}) {
    _navigatorServices = _getIt.get<NavigatorServices>();
    _authServices = _getIt.get<AuthServices>();
    _fetchCommentsService = _getIt.get<FetchCommentsService>();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CommentsProvider(
            fetchCommentsService: _fetchCommentsService,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Comments blog application',
        debugShowCheckedModeBanner: false,
        navigatorKey: _navigatorServices.navigatorState,
        routes: _navigatorServices.routes,
        initialRoute: _authServices.user == null ? '/login' : '/home',
        theme: AppTheme.light(),
        themeMode: ThemeMode.light,
        darkTheme: AppTheme.dark(),
      ),
    );
  }
}
