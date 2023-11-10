import 'package:mysql1/mysql1.dart';

//нет в WEB

class FormDatabaseConnection {
  static late MySqlConnection connection;

  static Future<bool> init() async {
    return await _connectToSQL();
  }

  static _connectToSQL() async {}
}
