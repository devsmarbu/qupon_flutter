import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../localization/data/services/localization_service.dart';
import '../../../localization/data/repositories/localization_repository.dart';
import '../../../account/presentation/account/bloc/account_bloc.dart';
import '../../../account/presentation/account/bloc/account_state.dart';
import '../../../account/presentation/welcome/view/welcome_page.dart';
import 'main_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  VideoPlayerController? _videoController;
  Timer? _safetyTimer;
  bool _videoFinished = false;
  bool _labelsFetchedOrFailed = false;
  bool _navigated = false;
  bool _videoInitialized = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
    _fetchLabels();

    // Safety timeout: navigate after 8 seconds no matter what
    _safetyTimer = Timer(const Duration(seconds: 8), () {
      if (mounted && !_navigated) {
        debugPrint('[SplashPage] Safety timeout reached, forcing navigation');
        _videoFinished = true;
        _labelsFetchedOrFailed = true;
        _forceNavigate();
      }
    });
  }

  Future<void> _initVideo() async {
    try {
      final controller = VideoPlayerController.asset(
        'assets/video/qupon_splash.mp4',
      );
      _videoController = controller;

      await controller.initialize();
      debugPrint('[SplashPage] Video initialized: ${controller.value.size}');

      if (!mounted) return;

      setState(() {
        _videoInitialized = true;
      });

      controller.addListener(_onVideoUpdate);
      await controller.play();
      debugPrint('[SplashPage] Video playing');
    } catch (e) {
      debugPrint('[SplashPage] Video init error: $e');
      if (mounted) {
        setState(() {
          _videoFinished = true;
        });
        _checkStateAndNavigate();
      }
    }
  }

  void _onVideoUpdate() {
    if (!mounted || _videoFinished) return;

    final controller = _videoController;
    if (controller == null) return;

    final value = controller.value;
    final position = value.position;
    final duration = value.duration;

    // Check if video finished playing
    if (duration > Duration.zero &&
        position.inMilliseconds > 0 &&
        position.inMilliseconds >= (duration.inMilliseconds - 100)) {
      debugPrint('[SplashPage] Video finished: pos=$position dur=$duration');
      setState(() {
        _videoFinished = true;
      });
      _checkStateAndNavigate();
    }

    // Also check if video has an error
    if (value.hasError) {
      debugPrint('[SplashPage] Video error: ${value.errorDescription}');
      setState(() {
        _videoFinished = true;
      });
      _checkStateAndNavigate();
    }
  }

  Future<void> _fetchLabels() async {
    debugPrint('[SplashPage] _fetchLabels called');
    try {
      final repo = context.read<LocalizationRepository>();
      debugPrint('[SplashPage] Calling repo.getLabels(1) and repo.getLabels(2)...');
      final results = await Future.wait([
        repo.getLabels(1).timeout(const Duration(seconds: 5)),
        repo.getLabels(2).timeout(const Duration(seconds: 5)),
      ]);

      final enMap = results[0];
      final arMap = results[1];

      debugPrint('[SplashPage] Labels fetched: EN=${enMap.length} keys, AR=${arMap.length} keys');
      LocalizationService().updateLabels(en: enMap, ar: arMap);
      debugPrint('[SplashPage] Labels updated in LocalizationService');
    } catch (e) {
      debugPrint('[SplashPage] Error fetching localization labels: $e');
    } finally {
      if (mounted) {
        setState(() {
          _labelsFetchedOrFailed = true;
        });
        _checkStateAndNavigate();
      }
    }
  }

  void _checkStateAndNavigate() {
    if (_navigated) return;

    final state = context.read<AccountBloc>().state;
    if (!_videoFinished || !_labelsFetchedOrFailed || state is AccountInitial) return;

    _navigated = true;
    _navigate(state);
  }

  void _forceNavigate() {
    if (_navigated) return;
    _navigated = true;

    final state = context.read<AccountBloc>().state;
    _navigate(state);
  }

  void _navigate(AccountState state) {
    final Widget nextScreen;
    if (state is AccountAuthenticated) {
      nextScreen = const MainPage();
    } else {
      nextScreen = const WelcomePage();
    }

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  void dispose() {
    _safetyTimer?.cancel();
    _videoController?.removeListener(_onVideoUpdate);
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountBloc, AccountState>(
      listener: (context, state) {
        if (state is! AccountInitial) {
          _checkStateAndNavigate();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: _videoInitialized && _videoController != null
            ? SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _videoController!.value.size.width,
                    height: _videoController!.value.size.height,
                    child: VideoPlayer(_videoController!),
                  ),
                ),
              )
            : Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.splashStart,
                      AppColors.splashMid,
                      AppColors.splashEnd,
                    ],
                    stops: [0.0, 0.5, 1.0],
                  ),
                ),
              ),
      ),
    );
  }
}
