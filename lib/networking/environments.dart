import '../common/utils/flavors_utils.dart';

class Environments {
  Environments(this.baseUrl);

  final String baseUrl;

  static Environments get current {
    var url = Environments.dev();
    if (FlavorConfig.isStage()) {
      url = Environments.stage();
    } else if (FlavorConfig.isProd()) {
      url = Environments.prod();
    }

    return url;
  }

  // factory Environments.dev() => Environments('https://api-demo.confialink.com/');

  // factory Environments.stage() => Environments('https://api-demo.confialink.com/');

  // factory Environments.prod() => Environments('https://api-demo.confialink.com/');

  factory Environments.dev() => Environments('https://api.neobank.confialink.com/');

  factory Environments.stage() => Environments('https://api.neobank.confialink.com/');

  factory Environments.prod() => Environments('https://api.neobank.confialink.com/');

  @override
  String toString() => baseUrl;
}
