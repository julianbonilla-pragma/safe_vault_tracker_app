import 'package:integration_test/integration_test_driver.dart'
    as integration_test_driver;

Future<void> main() async {
  return integration_test_driver.integrationDriver(
    timeout: const Duration(minutes: 5),
    responseDataCallback: (map) {
      integration_test_driver.writeResponseData(
        map,
        destinationDirectory: 'integration_test/e2e/reports',
      );
    }
  );
}