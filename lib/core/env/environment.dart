enum Flavor { development, staging, production }

class Environment {
  final Flavor flavor;
  final String apiBaseUrl;

  const Environment._({required this.flavor, required this.apiBaseUrl});

  static const development = Environment._(
    flavor: Flavor.development,
    apiBaseUrl: 'https://dev.example.com',
  );
  static const staging = Environment._(
    flavor: Flavor.staging,
    apiBaseUrl: 'https://staging.example.com',
  );
  static const production = Environment._(
    flavor: Flavor.production,
    apiBaseUrl: 'https://api.example.com',
  );
}
