import 'package:flutter/material.dart';
import '/core/app_export.dart';

class TermsConditionScreen extends StatefulWidget {
  const TermsConditionScreen({super.key});

  @override
  TermsConditionScreenState createState() => TermsConditionScreenState();
}

class TermsConditionScreenState extends State<TermsConditionScreen> {
  bool preloader = true;
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {},
            onPageStarted: (String url) {
              setState(() {
                preloader = true;
              });
            },
            onPageFinished: (String url) {
              setState(() {
                preloader = false;
              });
            },
            onHttpError: (HttpResponseError error) {},
            onWebResourceError: (WebResourceError error) {},
            onNavigationRequest: (NavigationRequest request) {
              if (request.url.startsWith('https://www.youtube.com/')) {
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse('https://blogs.tourlytours.com/'));
      setState(() {
        preloader = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Preloader(
      preloader: preloader,
      child: Scaffold(
        key: scaffoldKey,
        body: Stack(
          children: [
            WebViewWidget(
              controller: controller,
            ),
          ],
        ),
      ),
    );
  }
}
