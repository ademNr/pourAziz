import 'package:g_recaptcha_v3/g_recaptcha_v3.dart';

class GRecaptchaService {
  Future<bool> init() async {
    return GRecaptchaV3.ready('6Lfl7coUAAAAAKUjryaKQDhrrklXE9yrvWNXqKTj',
        showBadge: true);
  }

  Future<String?> getToken() async {
    return GRecaptchaV3.execute('submit');
  }
}
