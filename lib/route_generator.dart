import 'package:flutter/material.dart';

import 'src/models/route_argument.dart';
import 'src/pages/cart.dart';
import 'src/pages/category.dart';
import 'src/pages/chat.dart';
import 'src/pages/checkout.dart';
import 'src/pages/debug.dart';
import 'src/pages/delivery_addresses.dart';
import 'src/pages/delivery_pickup.dart';
import 'src/pages/details.dart';
import 'src/pages/favorites.dart';
import 'src/pages/food.dart';
import 'src/pages/forget_password.dart';
import 'src/pages/help.dart';
import 'src/pages/languages.dart';
import 'src/pages/login.dart';
import 'src/pages/menu_list.dart';
import 'src/pages/order_success.dart';
import 'src/pages/pages.dart';
import 'src/pages/payment_methods.dart';
import 'src/pages/paypal_payment.dart';
import 'src/pages/profile.dart';
import 'src/pages/razorpay_payment.dart';
import 'src/pages/reviews.dart';
import 'src/pages/settings.dart';
import 'src/pages/signup.dart';
import 'src/pages/splash_screen.dart';
import 'src/pages/tracking.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    switch (settings.name) {
      case '/Debug':
        return MaterialPageRoute(builder: (_) => DebugWidget(routeArgument: args as RouteArgument), settings: settings);
      case '/Splash':
        return MaterialPageRoute(builder: (_) => SplashScreen(), settings: settings);
      case '/SignUp':
        return MaterialPageRoute(builder: (_) => SignUpWidget(), settings: settings);
      case '/MobileVerification':
        return MaterialPageRoute(builder: (_) => SignUpWidget(), settings: settings);
      case '/MobileVerification2':
        return MaterialPageRoute(builder: (_) => SignUpWidget(), settings: settings);
      case '/Login':
        return MaterialPageRoute(builder: (_) => LoginWidget(), settings: settings);
      case '/Profile':
        return MaterialPageRoute(builder: (_) => ProfileWidget(), settings: settings);
      case '/ForgetPassword':
        return MaterialPageRoute(builder: (_) => ForgetPasswordWidget(), settings: settings);
      case '/Pages':
        return MaterialPageRoute(builder: (_) => PagesWidget(currentTab: args), settings: settings);
      case '/Favorites':
        return MaterialPageRoute(builder: (_) => FavoritesWidget(), settings: settings);
      case '/Chat':
        return MaterialPageRoute(builder: (_) => ChatWidget(routeArgument: args as RouteArgument), settings: settings);
      case '/Details':
        return MaterialPageRoute(builder: (_) => DetailsWidget(currentTab: args), settings: settings);
      case '/Menu':
        return MaterialPageRoute(builder: (_) => MenuWidget(routeArgument: args as RouteArgument), settings: settings);
      case '/Food':
        return MaterialPageRoute(builder: (_) => FoodWidget(routeArgument: args as RouteArgument), settings: settings);
      case '/Category':
        return MaterialPageRoute(builder: (_) => CategoryWidget(routeArgument: args as RouteArgument), settings: settings);
      case '/Cart':
        return MaterialPageRoute(builder: (_) => CartWidget(routeArgument: args as RouteArgument), settings: settings);
      case '/Tracking':
        return MaterialPageRoute(builder: (_) => TrackingWidget(routeArgument: args as RouteArgument), settings: settings);
      case '/Reviews':
        return MaterialPageRoute(builder: (_) => ReviewsWidget(routeArgument: args as RouteArgument), settings: settings);
      case '/PaymentMethod':
        return MaterialPageRoute(builder: (_) => PaymentMethodsWidget(), settings: settings);
      case '/DeliveryAddresses':
        return MaterialPageRoute(builder: (_) => DeliveryAddressesWidget(), settings: settings);
      case '/DeliveryPickup':
        return MaterialPageRoute(builder: (_) => DeliveryPickupWidget(routeArgument: args as RouteArgument), settings: settings);
      case '/Checkout':
        return MaterialPageRoute(builder: (_) => CheckoutWidget(), settings: settings);
      case '/CashOnDelivery':
        return MaterialPageRoute(builder: (_) => OrderSuccessWidget(routeArgument: RouteArgument(param: 'Cash on Delivery')), settings: settings);
      case '/PayOnPickup':
        return MaterialPageRoute(builder: (_) => OrderSuccessWidget(routeArgument: RouteArgument(param: 'Pay on Pickup')), settings: settings);
      case '/PayPal':
        return MaterialPageRoute(builder: (_) => PayPalPaymentWidget(routeArgument: args as RouteArgument), settings: settings);
      case '/RazorPay':
        return MaterialPageRoute(builder: (_) => RazorPayPaymentWidget(routeArgument: args as RouteArgument), settings: settings);
      case '/OrderSuccess':
        return MaterialPageRoute(builder: (_) => OrderSuccessWidget(routeArgument: args as RouteArgument), settings: settings);
      case '/Languages':
        return MaterialPageRoute(builder: (_) => LanguagesWidget(), settings: settings);
      case '/Help':
        return MaterialPageRoute(builder: (_) => HelpWidget(), settings: settings);
      case '/Settings':
        return MaterialPageRoute(builder: (_) => SettingsWidget(), settings: settings);
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return MaterialPageRoute(builder: (_) => PagesWidget(currentTab: 2), settings: settings);
    }
  }
}
