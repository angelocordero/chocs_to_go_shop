import 'package:chocs_to_go_shop/core/utilites.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mysql1/mysql1.dart';

class TestDatabaseAPI {
  TestDatabaseAPI({required this.settings});
  
  final String tableName = 'chocs_to_go_inventory';

  final ConnectionSettings settings;

  Future<Iterable> testQueryTable() async {
    EasyLoading.show();
    try {
      MySqlConnection conn = await MySqlConnection.connect(settings);

      await Future.delayed(const Duration(seconds: 1));

      Iterable results = await conn.query(
        '''SELECT 
        `${TableFieldsEnum.product_id.name}`,
        `${TableFieldsEnum.product_name.name}`,
        `${TableFieldsEnum.net_weight.name}`, 
        `${TableFieldsEnum.quantity.name}`,
        `${TableFieldsEnum.price.name}`, 
        `${TableFieldsEnum.flavor.name}`, 
        `${TableFieldsEnum.last_date_release.name}`,
        `${TableFieldsEnum.last_date_receive.name}`
        FROM `$tableName` WHERE 1''',
        [],
      );
      await conn.close();

      EasyLoading.dismiss();

      return results;
    } catch (e) {
      EasyLoading.showError(e.toString());

      return const Iterable.empty();
    }
  }

  Future<bool> checkForDatabaseConnection() async {
    EasyLoading.show(status: 'Loading');

    try {
      MySqlConnection conn = await MySqlConnection.connect(settings);
      await Future.delayed(const Duration(seconds: 1));

      await conn.close();
      EasyLoading.dismiss();
      return true;
    } catch (e) {
      return false;
    }
  }
}
