import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Full-screen WebView that loads the payment redirect URL.
/// Pops itself (with [PaymentResult]) when the user taps back or when the
/// WebView navigates to a URL that looks like a success/cancel callback.
class PaymentWebViewPage extends StatefulWidget {
  final String redirectUrl;
  final String? sessionId;

  const PaymentWebViewPage({
    super.key,
    required this.redirectUrl,
    this.sessionId,
  });

  @override
  State<PaymentWebViewPage> createState() => _PaymentWebViewPageState();
}

class _PaymentWebViewPageState extends State<PaymentWebViewPage> {
  late final WebViewController _controller;
  int _loadingProgress = 0; // 0-100
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() {
            _isLoading = true;
            _loadingProgress = 0;
          }),
          onProgress: (progress) => setState(() => _loadingProgress = progress),
          onPageFinished: (_) => setState(() => _isLoading = false),
          onWebResourceError: (error) {
            // Silently ignore sub-resource errors (ads, trackers, etc.)
            debugPrint('WebView resource error: ${error.description}');
          },
          onNavigationRequest: (request) {
            // Detect success / cancel callback URLs and close the WebView
            final url = request.url.toLowerCase();
            if (_isSuccessUrl(url)) {
              Navigator.of(context).pop(PaymentResult.success);
              return NavigationDecision.prevent;
            }
            if (_isCancelUrl(url)) {
              Navigator.of(context).pop(PaymentResult.cancelled);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.redirectUrl));
  }

  /// Recognise common success URL patterns (adjust to your backend's callbacks)
  bool _isSuccessUrl(String url) {
    return url.contains('/success') ||
        url.contains('/payment-success') ||
        url.contains('/order-confirmed') ||
        url.contains('status=success') ||
        url.contains('result=success');
  }

  /// Recognise common cancel/failure URL patterns
  bool _isCancelUrl(String url) {
    return url.contains('/cancel') ||
        url.contains('/payment-cancel') ||
        url.contains('/payment-failed') ||
        url.contains('status=cancel') ||
        url.contains('result=cancel') ||
        url.contains('result=failed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),

          // ── Top linear progress bar ─────────────────────────────────────────
          if (_isLoading)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: _loadingProgress / 100),
                duration: const Duration(milliseconds: 200),
                builder: (_, value, __) => LinearProgressIndicator(
                  value: value,
                  minHeight: 3,
                  backgroundColor: Colors.transparent,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFFFF6B35),
                  ),
                ),
              ),
            ),

          // ── Full-screen initial loader (before any content loads) ───────────
          if (_isLoading && _loadingProgress == 0)
            Container(
              color: Colors.white,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFFFF6B35),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Opening payment page…',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      leading: IconButton(
        icon: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.close,
            color: Color(0xFF0F172A),
            size: 18,
          ),
        ),
        onPressed: () => _confirmClose(),
      ),
      title: Column(
        children: [
          const Text(
            'Secure Payment',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock, size: 11, color: Color(0xFF16A34A)),
              const SizedBox(width: 3),
              Text(
                Uri.parse(widget.redirectUrl).host,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: const Color(0xFFE2E8F0)),
      ),
    );
  }

  /// Ask the user before closing mid-payment
  Future<void> _confirmClose() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Cancel payment?',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Your payment is still in progress. Are you sure you want to go back?',
          style: TextStyle(fontSize: 14, color: Color(0xFF64748B), height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'Continue',
              style: TextStyle(
                color: Color(0xFFFF6B35),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Go back',
              style: TextStyle(color: Color(0xFF64748B)),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      Navigator.of(context).pop(PaymentResult.cancelled);
    }
  }
}

/// Result returned when the WebView page is popped
enum PaymentResult { success, cancelled }
