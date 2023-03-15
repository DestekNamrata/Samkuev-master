import 'package:get/get.dart';
import 'package:samku/src/components/count_down_time.dart';
import 'package:samku/src/pages/chargedetails.dart';
import 'package:samku/src/pages/home.dart';
import 'package:samku/src/pages/myPreBooking.dart';
import 'package:samku/src/pages/pamentmethod.dart';
import 'package:samku/src/pages/paymentdone.dart';
import 'package:samku/src/pages/store_location_updated.dart';
import 'package:samku/src/pages/support.dart';
import 'package:samku/src/pages/timer.dart';
import 'package:samku/src/pages/verifyphoneforforgetpwd.dart';

import '/src/pages/about.dart';
import '/src/pages/banner_details.dart';
import '/src/pages/brands.dart';
import '/src/pages/brands_products.dart';
import '/src/pages/cart.dart';
import '/src/pages/category_products.dart';
import '/src/pages/chat.dart';
import '/src/pages/checkout.dart';
import '/src/pages/currency.dart';
import '/src/pages/forgot_password.dart';
import '/src/pages/language_init.dart';
import '/src/pages/languages.dart';
import '/src/pages/liked.dart';
import '/src/pages/loading.dart';
import '/src/pages/location.dart';
import '/src/pages/lost_connection.dart';
import '/src/pages/navigation.dart';
import '/src/pages/notifications.dart';
import '/src/pages/order_history.dart';
import '/src/pages/privacy.dart';
import '/src/pages/product_detail.dart';
import '/src/pages/profile.dart';
import '/src/pages/profile_settings.dart';
import '/src/pages/qa.dart';
import '/src/pages/settings.dart';
import '/src/pages/sign_in.dart';
import '/src/pages/sign_up.dart';
import '/src/pages/social_media.dart';
import '/src/pages/splash.dart';
import '/src/pages/store.dart';
import '/src/pages/store_info.dart';
import '/src/pages/store_location.dart';
import '/src/pages/sub_category_products.dart';
import '/src/pages/terms.dart';
import '/src/pages/verify_phone.dart';

class AppRoutes {
  AppRoutes._();
  static final routes = [
    GetPage(name: '/', page: () => Loading()),
    GetPage(name: '/home', page: () => Home()),
    GetPage(
        name: '/signin',
        page: () => SignInPage(),
        transition: Transition.fade,
        transitionDuration: const Duration(milliseconds: 500)),
    GetPage(
        name: '/signup',
        page: () => SignUpPage(),
        // page: () => SignUpUpdated(),
        transition: Transition.fade,
        transitionDuration: const Duration(milliseconds: 500)),
    GetPage(
      name: '/store',
      page: () => StorePage(),
    ),
    GetPage(
        name: '/location',
        page: () => LocationPage(),
        transition: Transition.rightToLeftWithFade,
        transitionDuration: const Duration(milliseconds: 500)),
    GetPage(
        name: '/shopsLocation',
        // page: () => StoreLocation(),
        page: () => StoreLocationUpdated(),
        transition: Transition.rightToLeftWithFade,
        transitionDuration: const Duration(milliseconds: 500)),
    GetPage(
        name: '/shopInfo',
        page: () => StoreInfo(),
        transition: Transition.downToUp,
        transitionDuration: const Duration(milliseconds: 500)),
    // GetPage(
    //     name: '/locationList',
    //     page: () => LocationList(),
    //     transition: Transition.rightToLeftWithFade,
    //     transitionDuration: Duration(milliseconds: 500)),
    GetPage(
        name: '/profile',
        page: () => ProfilePage(),
        transition: Transition.rightToLeftWithFade,
        transitionDuration: const Duration(milliseconds: 500)),
    GetPage(
        name: '/about',
        page: () => About(),
        transition: Transition.rightToLeftWithFade,
        transitionDuration: const Duration(milliseconds: 500)),
    GetPage(
        name: '/privacy',
        page: () => Privacy(),
        transition: Transition.rightToLeftWithFade,
        transitionDuration: const Duration(milliseconds: 500)),
    GetPage(
        name: '/terms',
        page: () => Terms(),
        transition: Transition.rightToLeftWithFade,
        transitionDuration: const Duration(milliseconds: 500)),
    //support
    GetPage(
        name: '/support',
        page: () => SupportScreen(),
        transition: Transition.rightToLeftWithFade,
        transitionDuration: const Duration(milliseconds: 500)),
    GetPage(
        name: '/qa',
        page: () => Qa(),
        transition: Transition.rightToLeftWithFade,
        transitionDuration: const Duration(milliseconds: 500)),
    GetPage(
        name: '/forgotPassword',
        page: () => ForgotPasswordPage(),
        transition: Transition.downToUp,
        transitionDuration: const Duration(milliseconds: 500)),
    GetPage(
        name: '/verifyPhone',
        page: () => VerifyPhonePage(),
        transition: Transition.downToUp,
        transitionDuration: const Duration(milliseconds: 500)),
    GetPage(
        name: '/verifyPhoneforForgetPWD',
        page: () => VerifyPhoneforgetpwdPage(),
        transition: Transition.downToUp,
        transitionDuration: const Duration(milliseconds: 500)),
    GetPage(
        name: '/brands',
        page: () => Brands(),
        transition: Transition.rightToLeftWithFade,
        transitionDuration: const Duration(milliseconds: 500)),
    GetPage(
        name: '/categoryProducts',
        page: () => CategoryProducts(),
        transition: Transition.rightToLeftWithFade,
        transitionDuration: const Duration(milliseconds: 500)),
    GetPage(
        name: '/subCategoryProducts',
        page: () => SubCategoryProducts(),
        transition: Transition.rightToLeftWithFade,
        transitionDuration: const Duration(milliseconds: 500)),
    GetPage(
        name: '/cart',
        page: () => Cart(),
        transition: Transition.rightToLeftWithFade,
        transitionDuration: const Duration(milliseconds: 500)),
    GetPage(
        name: '/settings',
        page: () => Settings(),
        transition: Transition.rightToLeftWithFade,
        transitionDuration: const Duration(milliseconds: 500)),
    GetPage(
        name: '/socialMedia',
        page: () => SocialMedia(),
        transition: Transition.rightToLeftWithFade,
        transitionDuration: const Duration(milliseconds: 500)),
    GetPage(
        name: '/profileSettings',
        page: () => ProfileSettings(),
        transition: Transition.rightToLeftWithFade,
        transitionDuration: const Duration(milliseconds: 500)),
    GetPage(
        name: '/liked',
        page: () => Liked(),
        transition: Transition.rightToLeftWithFade,
        transitionDuration: const Duration(milliseconds: 500)),
    GetPage(
        name: '/currency',
        page: () => Currency(),
        transition: Transition.rightToLeftWithFade,
        transitionDuration: const Duration(milliseconds: 500)),
    GetPage(
        name: '/language',
        page: () => Languages(),
        transition: Transition.rightToLeftWithFade,
        transitionDuration: const Duration(milliseconds: 500)),
    GetPage(
        name: '/orderHistory',
        page: () => OrderHistory(),
        transition: Transition.rightToLeftWithFade,
        transitionDuration: const Duration(milliseconds: 500)),
    //my pre booking
    GetPage(
        name: '/mypreBooking',
        page: () => MyPreBooking(),
        transition: Transition.rightToLeftWithFade,
        transitionDuration: const Duration(milliseconds: 500)),
    GetPage(
        name: '/notifications',
        page: () => Notifications(),
        transition: Transition.upToDown,
        transitionDuration: const Duration(milliseconds: 500)),
    GetPage(
        name: '/productDetail',
        page: () => ProductDetail(),
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 500)),
    GetPage(
        name: '/chat',
        page: () => Chat(),
        transition: Transition.downToUp,
        transitionDuration: const Duration(milliseconds: 500)),
    GetPage(
        name: '/orderHistory',
        page: () => OrderHistory(),
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 500)),
    GetPage(
        name: '/checkout',
        page: () => Checkout(),
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 500)),
    GetPage(
        name: '/profileSettings',
        page: () => ProfileSettings(),
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 500)),
    GetPage(
        name: '/navigation',
        page: () => const Navigation(),
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 500)),
    GetPage(
        name: '/brandProducts',
        page: () => BrandsProducts(),
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 500)),
    GetPage(
        name: '/bannerDetails',
        page: () => BannerDetails(),
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 500)),
    GetPage(name: '/languageInit', page: () => LanguageInit()),
    GetPage(name: '/noConnection', page: () => LostConnection()),
    GetPage(name: '/splash', page: () => SplashPage()),
    GetPage(
        name: '/ChargeingDetails',
        page: () => ChargeingDetails(),
        transition: Transition.downToUp,
        transitionDuration: const Duration(milliseconds: 500)),
    GetPage(
        name: '/PaymentMethod',
        page: () => PaymentMethod(),
        transition: Transition.downToUp,
        transitionDuration: const Duration(milliseconds: 500)),
    GetPage(
        name: '/PaymentDone',
        page: () => PaymentDone(),
        transition: Transition.downToUp,
        transitionDuration: const Duration(milliseconds: 500)),
    GetPage(
        name: '/TimerScreen',
        page: () => TimerScreen(),
        transition: Transition.downToUp,
        transitionDuration: const Duration(milliseconds: 500)),
    GetPage(
        name: '/CountDownTimer',
        page: () => CountDownTimer(),
        transition: Transition.downToUp,
        transitionDuration: const Duration(milliseconds: 500)),
  ];
}
