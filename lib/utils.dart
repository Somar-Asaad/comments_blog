import 'package:comments_viewer_application/services/alert_services.dart';
import 'package:comments_viewer_application/services/auth_services.dart';
import 'package:comments_viewer_application/services/database_services.dart';
import 'package:comments_viewer_application/services/fetch_comments_services.dart';
import 'package:comments_viewer_application/services/navigator_services.dart';
import 'package:comments_viewer_application/services/remote_config_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';

import 'firebase_options.dart';

Future<void> setupFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> registerServices() async {
  final GetIt getIt = GetIt.instance;
  getIt.registerSingleton<NavigatorServices>(NavigatorServices());
  getIt.registerSingleton<AuthServices>(AuthServices());
  getIt.registerSingleton<AlertServices>(AlertServices());
  getIt.registerSingleton<DatabaseServices>(DatabaseServices());
  getIt.registerSingleton<FetchCommentsService>(FetchCommentsService());
  getIt.registerSingleton<RemoteConfigService>(RemoteConfigService());
}
