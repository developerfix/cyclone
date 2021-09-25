import 'dart:async';

import 'package:Siuu/models/user.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/auth_api.dart';
import 'package:Siuu/services/httpie.dart';
import 'package:Siuu/services/toast.dart';
import 'package:Siuu/services/universal_links/universal_links.dart';
import 'package:Siuu/services/user.dart';
import 'package:flutter/material.dart';

import '../../localization.dart';

class EmailVerificationLinkHandler extends UniversalLinkHandler {
  static const String verifyEmailLink = '/api/auth/email/verify';
  StreamSubscription _onLoggedInUserChangeSubscription;

  @override
  Future handle({BuildContext context, String link}) async{
    if (link.indexOf(verifyEmailLink) != -1) {
      final token = _getEmailVerificationTokenFromLink(link);
      OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
      UserService userService = openbookProvider.userService;
      ToastService toastService = openbookProvider.toastService;
      AuthApiService authApiService = openbookProvider.authApiService;
      LocalizationService localizationService = openbookProvider.localizationService;

      _onLoggedInUserChangeSubscription =
          userService.loggedInUserChange.listen((User newUser) async {
        _onLoggedInUserChangeSubscription.cancel();

        try {
          HttpieResponse response =
              await authApiService.verifyEmailWithToken(token);
          if (response.isOk()) {
            toastService.success(
                message: localizationService.user__email_verification_successful, context: context);
          } else if (response.isBadRequest()) {
            toastService.error(
                message:
                localizationService.user__email_verification_error,
                context: context);
          }
        } on HttpieConnectionRefusedError {
          toastService.error(message: localizationService.error__no_internet_connection, context: null);
        } catch (e) {
          toastService.error(message: localizationService.error__unknown_error, context: null);
          rethrow;
        }
      });
    }
  }

  String _getEmailVerificationTokenFromLink(String link) {
    final linkParts = _getDeepLinkParts(link);
    return linkParts[linkParts.length - 1];
  }

  List<String> _getDeepLinkParts(String link) {
    final uri = Uri.parse(link);
    return uri.path.split('/');
  }
}
