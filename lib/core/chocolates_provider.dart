import 'package:chocs_to_go_shop/core/providers_definition.dart';
import 'package:chocs_to_go_shop/core/database_api.dart';
import 'package:chocs_to_go_shop/data_classes/chocolates_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChocolatesProvider extends StateNotifier<List<Chocolates>> {
  ChocolatesProvider() : super([]);

  List<Chocolates> _fullList = [];

  Future init(WidgetRef ref) async {
    await DatabaseAPI(settings: ref.read(mysqlConnectionProvider)).testQueryTable().then(
      (value) {
        List<Chocolates> _temp = [];

        for (var row in value) {
          DateTime? _lastDateReleasedUTC = row[6];
          DateTime? _lastDateReceivedUTC = row[7];

          _temp.add(
            Chocolates(
              productID: row[0],
              productName: row[1],
              netWeight: row[2],
              quantity: row[3],
              price: row[4],
              flavor: row[5],
              lastDateRelease: _lastDateReleasedUTC?.toLocal(),
              lastDateReceive: _lastDateReceivedUTC?.toLocal(),
            ),
          );
        }
        state = _temp;
        _fullList = state;
      },
    );
  }

  Future reset(WidgetRef ref) async {
    _fullList = [];
    await init(ref);
  }

  searchForProductName(String query) {
    state = _fullList.where((element) {
      return element.productName.toLowerCase().contains(query.trim().toLowerCase());
    }).toList();
  }

  searchForProductFlavor(String query, WidgetRef ref) async {
    if (query == 'All') {
      await clearSearch(ref);
      return;
    }

    state = _fullList.where((element) {
      return element.flavor.toLowerCase().contains(query.trim().toLowerCase());
    }).toList();
  }

  clearSearch(WidgetRef ref) {
    state = _fullList.toList();
  }
}
