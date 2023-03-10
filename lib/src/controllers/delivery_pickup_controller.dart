import 'package:flutter/material.dart';
import '../models/constants.dart';

import '../../generated/l10n.dart';
import '../models/address.dart' as model;
import '../models/payment_method.dart';
import '../repository/settings_repository.dart' as settingRepo;
import '../repository/user_repository.dart' as userRepo;
import 'cart_controller.dart';

class DeliveryPickupController extends CartController {
  GlobalKey<ScaffoldState> scaffoldKey;
  model.Address deliveryAddress;
  PaymentMethodList list;

  DeliveryPickupController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    super.listenForCarts();
    listenForDeliveryAddress();
  }

  void listenForDeliveryAddress() async {
    this.deliveryAddress = settingRepo.deliveryAddress.value ?? null;
  }

  void addAddress(model.Address address) {
    userRepo.addAddress(address).then((value) {
      setState(() {
        settingRepo.deliveryAddress.value = value;
        this.deliveryAddress = value;
      });
    }).whenComplete(() {
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).new_address_added_successfully),
      ));
    });
  }

  void updateAddress(model.Address address) {
    userRepo.updateAddress(address).then((value) {
      setState(() {
        settingRepo.deliveryAddress.value = value;
        this.deliveryAddress = value;
      });
    }).whenComplete(() {
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).the_address_updated_successfully),
      ));
    });
  }

  PaymentMethod getPickUpMethod() {
    return list.pickupList.elementAt(0);
  }

  PaymentMethod getDeliveryMethod() {
    return list.pickupList.elementAt(1);
  }

  void toggleDelivery() {
    list.pickupList.forEach((element) {
      if (element != getDeliveryMethod()) {
        element.selected = false;
      }
    });
    setState(() {
      getDeliveryMethod().selected = !getDeliveryMethod().selected;
      Constants.pickupOrDelivery = true;
    });
  }

  void togglePickUp() {
    list.pickupList.forEach((element) {
      if (element != getPickUpMethod()) {
        element.selected = false;
      }
    });
    setState(() {
      getPickUpMethod().selected = !getPickUpMethod().selected;
      Constants.pickupOrDelivery = false;
    });
  }

  PaymentMethod getSelectedMethod() {
    PaymentMethod route;
    for (var i = 0; i < list.pickupList.length; i++) {
      if (list.pickupList[i].selected) {
        route = list.pickupList[i];
        break;
      }
    }
    if (route != null)
      return route;
    else
      return PaymentMethod('', '', '', '', '');
  }

  @override
  void goCheckout(BuildContext context) {
    String routeName = getSelectedMethod().route;
    if (routeName == '') {
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).please_choose_delivery_or_pickup),
      ));
      return;
    }
    if (routeName == '/PayOnPickup') {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(routeName, (route) => route.settings.name == '/Pages');
     /*  Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed(
        routeName,
      ); */
    } else if (routeName == '/CashOnDelivery') {
       Navigator.of(context)
          .pushNamedAndRemoveUntil(routeName, (route) => route.settings.name == '/Pages');
     /*  Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed(routeName); */
    } else
      Navigator.of(context).pushNamed(routeName);
  }
}
