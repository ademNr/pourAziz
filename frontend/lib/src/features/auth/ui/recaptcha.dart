import 'package:flutter/material.dart';
import 'package:frontend/src/features/auth/screens/login_screen.dart';
import 'package:get/get.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class Recaptcha extends StatefulWidget {
  const Recaptcha({Key? key}) : super(key: key);

  @override
  State<Recaptcha> createState() => _RecaptchaState();
}

class _RecaptchaState extends State<Recaptcha> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WebViewPlus(
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) {
          controller.loadUrl("assets/webpages/index.html");
        },
        javascriptChannels: {
          JavascriptChannel(
              name: 'Captcha',
              onMessageReceived: (JavascriptMessage message) {
                Get.off(() => const LoginScreen());
              })
        },
      ),
    );
  }
}
