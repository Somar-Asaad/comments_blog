import 'package:comments_viewer_application/services/navigator_services.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class AlertServices {
  late NavigatorServices _navigatorServices;
  final GetIt _getIt = GetIt.instance;

  AlertServices() {
    _navigatorServices = _getIt.get<NavigatorServices>();
  }

  void showToastBar({required String title, IconData icon = Icons.info}) {
    DelightToastBar(
      builder: (context) {
        return ToastCard(
          leading: Icon(
            icon,
            size: 28,
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
      },
      position: DelightSnackbarPosition.top,
      autoDismiss: true,
    ).show(_navigatorServices.navigatorState.currentContext!);
  }
}
