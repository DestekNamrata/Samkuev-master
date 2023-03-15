import 'package:get/get.dart';
import 'package:samku/src/controllers/auth_controller.dart';
import 'package:samku/src/requests/orderAvailabilityCheck.dart';

import '/src/controllers/shop_controller.dart';
import '/src/models/address.dart';
import '/src/models/card.dart';
import '/src/models/product.dart';
import '/src/models/shop.dart';
import '/src/models/user.dart';
import '/src/requests/order_save_request.dart';

class CartController extends GetxController {
  final AuthController authController = Get.put(AuthController());

  final ShopController shopController = Get.put(ShopController());
  var cartProducts = <Product>[].obs;
  var user = Rxn<Users>();

  Shop? shop;
  var deliveryType = 1.obs;
  var proccess = 0.obs;
  var proccessPercentage = 0.obs;
  var cardName = "".obs;
  var cardNumber = "".obs;
  var cardExpiredDate = "".obs;
  var cvc = "".obs;
  var msg = "".obs;
  var productId = "".obs;
  var orderSent = false.obs;
  var orderId = 0.obs;
  var paymentType = 1.obs;
  var paymentStatus = 1.obs; //for payment
  var orderComment = "".obs;
  var cards = <Card>[].obs;
  var activeCardNumber = "".obs;
  var isCardAvailable = false.obs;
  var amount = 0.obs;
  var discount = 0.obs;
  var tax = 0.obs;
  var total = 0.obs;
  var duration = 0.obs;

  var port = "Port 2".obs;
  var type = "AC 3.3 Pin".obs;

  @override
  void onInit() {
    super.onInit();
    user.value = authController.getUser();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void addToCart(Product product) {
    product.count = 1;
    int index = cartProducts.indexWhere((element) => element.id == product.id);
    if (index == -1) cartProducts.add(product);
    cartProducts.refresh();
  }

  void increment(id) {
    int index = cartProducts.indexWhere((element) => element.id == id);
    if (index > -1) {
      cartProducts[index].count = cartProducts[index].count! + 1;
      cartProducts.refresh();
    }
  }

  void decrement(id) {
    int index = cartProducts.indexWhere((element) => element.id == id);
    if (index > -1) {
      if (cartProducts[index].count! > 1)
        cartProducts[index].count = cartProducts[index].count! - 1;
      else
        cartProducts.removeAt(index);
      cartProducts.refresh();
    }
  }

  int getProductCountById(int id) {
    int index = cartProducts.indexWhere((element) => element.id == id);
    if (index > -1) {
      if (cartProducts[index].count! == 0) {
        cartProducts.removeAt(index);
        cartProducts.refresh();
        return 0;
      }
      return cartProducts[index].count!;
    }
    return 0;
  }

  void removeProductFromCart(int id) {
    int index = cartProducts.indexWhere((element) => element.id == id);
    if (index > -1) {
      cartProducts.removeAt(index);
      cartProducts.refresh();
    }
  }

  double calculateAmount() {
    double sum = 0;

    // for (Product product in cartProducts) {
    //   double extrasSum = product.extras != null
    //       ? product.extras!.fold(0, (a, b) => a + b.price!)
    //       : 0;
    //   sum += product.count! * (product.price! + extrasSum);
    // }

    return sum;
  }

  double calculateDiscount() {
    double sum = 0;

    for (Product product in cartProducts) {
      double discountPrice = 0;
      if (product.discountType == 1)
        discountPrice = (product.price! * product.discount!) / 100;
      else if (product.discountType == 2) discountPrice = product.discount!;
      //discountPrice = product.price! - product.discount!;
      sum += (product.count! * discountPrice);
    }

    return double.parse(sum.toStringAsFixed(2));
  }

  void checkoutData() {
    shop = shopController.defaultShop.value;
    Users? user = shopController.authController.getUser();
    Address address = shopController.addressController.getDefaultAddress();

    proccessPercentage.value = 0;
    if (deliveryType.value > 0) proccessPercentage.value += 10;

    if (address.address != null && address.address!.length > 0)
      proccessPercentage.value += 12;

    if (user != null && user.name != null && user.name!.length > 0)
      proccessPercentage.value += 12;

    if (user != null && user.phone != null && user.phone!.length > 0)
      proccessPercentage.value += 12;

    if (proccess.value >= 1) proccessPercentage.value += 4;
  }

  Future<void> orderSave(String startTime, String endTime, String date,
      String productId, double amount,String duration,String taxAmt) async {
    orderSent.value = true;
    shop = shopController.defaultShop.value;
    Address address = shopController.addressController.getDefaultAddress();
    Users? user = shopController.authController.getUser();

    Map<String, dynamic> body = {
      // "total": calculateAmount() -
      //     calculateDiscount() +
      //     (shopController.deliveryType.value == 1 ? shop!.deliveryFee! : 0),
      "total": amount.toString(),
      "amount": amount.toString(),
      "discount": calculateDiscount(),
      "delivery_date":
          "${shopController.deliveryDate.value} ${shopController.deliveryTimeString.value}",
      "delivery_time_id": shopController.deliveryTime.value.toString(),
      "payment_type": paymentType.value.toString(),
      "payment_status": paymentStatus.value.toString(),
      "products": cartProducts.map((element) => element.toJson()).toList(),
      "address": address.toJson(),
      "user": user!.id.toString(),
      "shop": shop!.id.toString(),
      "comment": orderComment.value.toString(),
      "delivery_type": shopController.deliveryType.value.toString(),
      "start_time": startTime,
      "end_time": endTime,
      "date": date,
      "id_product": productId,
      "duration":duration,
      "tax_amt":taxAmt
    };

    Map<String, dynamic> data = await orderSaveRequest(body);
    print("---------cartController------------------$body");
    if (data['success']) {
      orderId.value=data['data'];
      orderSent.value = false;
      cartProducts.value = [];
      proccess.value = 0;
      // Get.back();
    }
  }

  //for order availability api
  Future<String> orderAvailabilityApi(
      startTime, endTime, date, productId,duration) async {
    Map<String, dynamic> body = {
      'product_id': productId,
      'start_time': startTime,
      'end_time': endTime,
      'date': date,
      'duration':duration
    };
    String flag = "";
    Map<String, dynamic> data = await orderAvailabilityCheck(body);
    print("---------cartController------------------$body");
    if (data['success']) {
      if (data['data']['available'] == true) {
        orderSent.value = false;
        flag = "true";
        msg.value=data['data']['msg'];
        // Get.back();
      } else {
        flag = "false";
        msg.value=data['data']['msg'];

      }
    }
    return flag;
  }

  void addToCard() {
    Card card = Card(
      name: cardName.value,
      cardNumber: cardNumber.value,
      expireDate: cardExpiredDate.value,
      cvc: cvc.value,
    );

    int index =
        cards.indexWhere((element) => element.cardNumber == cardNumber.value);
    if (index == -1)
      cards.add(card);
    else
      cards[index] = card;
    cards.refresh();
    Get.back();
  }
}
