import 'package:get/get.dart';
import '/src/controllers/language_controller.dart';
import '/src/controllers/shop_controller.dart';
import '/src/models/currency.dart';
import '/src/models/shop.dart';
import '/src/requests/currency_request.dart';
import '/src/utils/utils.dart';

class CurrencyController extends GetxController {
  var currencyList = <Currency>[].obs;
  var activeCurrencyId = 0.obs;
  final ShopController shopController = Get.put(ShopController());
  final LanguageController languageController = Get.put(LanguageController());

  Shop? shop;

  @override
  void onInit() {
    super.onInit();
  }

  Future<List<Currency>> getCurrencies() async {
    if (currencyList.length > 0) return currencyList;
    shop = shopController.defaultShop.value;
    List<Currency> currencies = [];

    if (await Utils.checkInternetConnectivity() &&
        shop != null &&
        shop!.id != null) {
      Map<String, dynamic> data = await currencyRequest(
          shop!.id!, languageController.activeLanguageId.value);
      if (data['success']) {
        for (int i = 0; i < data['data'].length; i++) {
          Map<String, dynamic> item = data['data'][i];
          int id = int.parse(item['currency']['id'].toString());

          if (activeCurrencyId.value == 0) activeCurrencyId.value = id;

          currencies.add(Currency(
              id: id,
              symbol: item['currency']['symbol'],
              isDefault: int.parse(item['default'].toString()) == 1,
              name: item['currency']['language']['name']));
        }
        currencyList.value = currencies;
        currencyList.refresh();
      }
    }

    return currencies;
  }

  void setActiveCurrency(int id) {
    activeCurrencyId.value = id;
  }

  double calculatePrice(double price) {
    double newPrice = 0;

    return newPrice;
  }
}
