import 'package:internet_connection_checker/internet_connection_checker.dart';

Future<bool> checkInternet() async {
  final bool connection = await InternetConnectionChecker().hasConnection;
  return connection;
}
