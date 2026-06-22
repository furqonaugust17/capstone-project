enum Flavor { development, staging, production }

class Environment {
  final Flavor flavor;
  final String apiBaseUrl;

  const Environment._({required this.flavor, required this.apiBaseUrl});

  static const development = Environment._(
    flavor: Flavor.development,
    apiBaseUrl: 'http://10.0.2.2:3001/api', // Android emulator -> localhost
  );
  static const staging = Environment._(
    flavor: Flavor.staging,
    apiBaseUrl: 'http://<IP_SERVER>:3001/api',
  );
  static const production = Environment._(
    flavor: Flavor.production,
    apiBaseUrl: 'https://api.example.com/api',
  );

  static Environment current = development;
}
