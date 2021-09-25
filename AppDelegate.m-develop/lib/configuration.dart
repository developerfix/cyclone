class Configuration {
  static const ENV = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'Prod',
  );

  static const API_URL = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://62.171.176.52:80/',
  );

  static const SENTRY_DSN = String.fromEnvironment(
    'SENTRY_DSN',
    defaultValue:
        'https://840d267b4da042dcbc14c4b43b095676@o498046.ingest.sentry.io/5575035',
  );

  static const APP_TITLE = String.fromEnvironment(
    'APP_TITLE',
    defaultValue: 'Siuu',
  );
}
