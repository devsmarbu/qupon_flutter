import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../routing/app_router.dart';

class DeepLinkService {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  Future<void> init() async {
    try {
      // Handle app launch via deep link (cold start)
      final Uri? initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleDeepLink(initialUri);
      }
    } catch (e) {
      debugPrint('DeepLinkService initial link error: $e');
    }

    // Handle deep links received while the app is in background/running (warm start)
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (Uri uri) {
        _handleDeepLink(uri);
      },
      onError: (err) {
        debugPrint('DeepLinkService stream error: $err');
      },
    );
  }

  void _handleDeepLink(Uri uri) {
    debugPrint('Received Deep Link: $uri');
    final String path = uri.path.isEmpty ? '/' : uri.path;
    final Map<String, String> queryParams = uri.queryParameters;

    String route = path;
    if (queryParams.isNotEmpty) {
      final queryString = Uri(queryParameters: queryParams).query;
      route = '$path?$queryString';
    }

    // Custom scheme mapping, e.g. qupon://collection/5 -> /collection/5
    if (uri.scheme == 'qupon') {
      final host = uri.host;
      if (host.isNotEmpty && host != 'qupon.marbu.in') {
        route = '/$host$path';
        if (queryParams.isNotEmpty) {
          final queryString = Uri(queryParameters: queryParams).query;
          route = '$route?$queryString';
        }
      }
    }

    debugPrint('Navigating to deep link route: $route');
    AppRouter.router.go(route);
  }

  void dispose() {
    _linkSubscription?.cancel();
  }
}
