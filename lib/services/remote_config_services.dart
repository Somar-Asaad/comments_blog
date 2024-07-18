import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  RemoteConfigService() {
    _init();
  }

  Future<void> _init() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 1),
      minimumFetchInterval: const Duration(seconds: 1),
    ));
    await _remoteConfig.setDefaults({
      "isEmailMasked": false,
    });

    await fetchAndActivateConfig();
  }

  Future<void> fetchAndActivateConfig() async {
    await _remoteConfig.fetchAndActivate();
  }

  bool isEmailMasked() {
    return _remoteConfig.getBool('isEmailMasked');
  }

  Stream<void> onConfigUpdated() {
    return _remoteConfig.onConfigUpdated; // Use onSettingsChanged instead of onConfigChanged
  }
}
