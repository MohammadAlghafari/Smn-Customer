import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_delivery_app/src/elements/DeliveryAddressBottomSheetWidget.dart';
import 'package:food_delivery_app/src/models/constants.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:intl/intl.dart';

import '../../generated/l10n.dart';
import '../controllers/delivery_pickup_controller.dart';
import '../elements/CartBottomDetailsWidget.dart';
import '../elements/DeliveryAddressDialog.dart';
import '../elements/DeliveryAddressesItemWidget.dart';
import '../elements/NotDeliverableAddressesItemWidget.dart';
import '../repository/settings_repository.dart' as settingRepo;
import '../elements/PickUpMethodItemWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../helpers/helper.dart';
import '../models/address.dart';
import '../models/payment_method.dart';
import '../models/route_argument.dart';

class DeliveryPickupWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  DeliveryPickupWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _DeliveryPickupWidgetState createState() => _DeliveryPickupWidgetState();
}

class _DeliveryPickupWidgetState extends StateMVC<DeliveryPickupWidget> {
  DeliveryPickupController _con;

  _DeliveryPickupWidgetState() : super(DeliveryPickupController()) {
    _con = controller;
  }

  bool valueToday = false;
  bool valueSchedule = false;
  DateTime time;

  @override
  Widget build(BuildContext context) {
    if (_con.list == null) {
      _con.list = new PaymentMethodList(context);
//      widget.pickup = widget.list.pickupList.elementAt(0);
//      widget.delivery = widget.list.pickupList.elementAt(1);
    }
    return Scaffold(
      key: _con.scaffoldKey,
      bottomNavigationBar: CartBottomDetailsWidget(con: _con),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).delivery_or_pickup,
          style: Theme.of(context)
              .textTheme
              .headline6
              .merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(
              iconColor: Theme.of(context).hintColor,
              labelColor: Theme.of(context).accentColor),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 100,
                      height: 50,
                      child: new CheckboxListTile(
                        value: valueToday,
                        onChanged: (bool value) {
                          setState(() {
                            valueToday = value;
                            if (valueSchedule == true) {
                              valueSchedule = false;
                            }
                            Constants.time = '';
                            Constants.date = DateTime.now();
                          });
                        },
                        activeColor: Theme.of(context).hintColor,
                      ),
                    ),
                    Text(
                      S.of(context).today,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textSelectionColor),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: 100,
                          height: 50,
                          child: new CheckboxListTile(
                            value: valueSchedule,
                            onChanged: (bool value) {
                              setState(() {});
                              DatePicker.showDateTimePicker(context,
                                  showTitleActions: true,
                                  minTime: DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month,
                                      DateTime.now().day + 1),
                                  maxTime: DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month,
                                      DateTime.now().day + 8),
                                  onChanged: (date) {
                                print('change $date');
                              }, onConfirm: (date) {
                                setState(() {
                                  Constants.date = date;
                                  Constants.time =
                                      DateFormat.Hms().format(date);
                                  time = date;
                                  valueSchedule = true;
                                  if (valueToday == true) {
                                    valueToday = false;
                                  }
                                });
                                print('confirm $date');
                              },
                                  currentTime: DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month,
                                      DateTime.now().day + 1),
                                  locale: settingRepo
                                              .setting
                                              .value
                                              .mobileLanguage
                                              .value
                                              .languageCode ==
                                          "en"
                                      ? LocaleType.en
                                      : LocaleType.ar);
                            },
                            activeColor: Theme.of(context).hintColor,
                          ),
                        ),
                        Text(
                          S.of(context).schedule,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).textSelectionColor),
                        ),
                      ],
                    ),
                    time == null || valueToday == true
                        ? SizedBox()
                        : Text(time.toString())
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 10),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                leading: Icon(
                  Icons.domain,
                  color: Theme.of(context).hintColor,
                ),
                title: Text(
                  S.of(context).pickup,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline4,
                ),
                subtitle: Text(
                  S.of(context).pickup_your_food_from_the_restaurant,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
            ),
            PickUpMethodItem(
                paymentMethod: _con.getPickUpMethod(),
                onPressed: (paymentMethod) {
                  if (valueSchedule == false && valueToday == false) {
                    _con.scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text(
                        S.of(context).please_choose_Today_or_schedule,
                      ),
                    ));
                  } else {
                    _con.togglePickUp();
                  }
                }),
            settingRepo.deliveryAddress.value != null &&
                    _con.carts.isNotEmpty &&
                    _con.carts[0].food.restaurant.availableForDelivery
                ? PickUpMethodItem(
                    paymentMethod: _con.getDeliveryMethod(),
                    onPressed: (paymentMethod) {
                      if (valueSchedule == false && valueToday == false) {
                        _con.scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text(
                            S.of(context).please_choose_Today_or_schedule,
                          ),
                        ));
                      } else if (settingRepo.deliveryAddress.value == null ||
                          settingRepo.deliveryAddress.value.id == null ||
                          settingRepo.deliveryAddress.value.id == 'null' ||
                          settingRepo.deliveryAddress.value.id == '') {
                        _con.scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text(
                            S.of(context).please_add_delivery_adress_first,
                          ),
                        ));
                      } else {
                        _con.toggleDelivery();
                      }
                    })
                : SizedBox(
                    height: 0,
                  ),
            settingRepo.deliveryAddress.value != null &&
                    _con.carts.isNotEmpty &&
                    _con.carts[0].food.restaurant.availableForDelivery
                ? Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20, bottom: 10, left: 20, right: 10),
                        child: ListTile(
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            leading: Icon(
                              Icons.map,
                              color: Theme.of(context).hintColor,
                            ),
                            title: Text(
                              S.of(context).delivery,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            subtitle: Text(
                              S
                                  .of(context)
                                  .click_to_confirm_your_address_and_pay_or_long_press,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.caption,
                            )),
                      ),
                      DeliveryAddressesItemWidget(
                        paymentMethod: _con.getDeliveryMethod(),
                        address: settingRepo.deliveryAddress.value,
                        onPressed: (Address _address) {
                          if (valueSchedule == false && valueToday == false) {
                            _con.scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text(
                                S.of(context).please_choose_Today_or_schedule,
                              ),
                            ));
                          } else if (settingRepo.deliveryAddress.value.id ==
                                  null ||
                              settingRepo.deliveryAddress.value.id == 'null' ||
                              settingRepo.deliveryAddress.value.id == '') {
                            var bottomSheetController =
                                _con.scaffoldKey.currentState.showBottomSheet(
                              (context) => DeliveryAddressBottomSheetWidget(
                                  scaffoldKey: _con.scaffoldKey),
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                              ),
                            );
                            bottomSheetController.closed.then((value) {
                              setState(() {});
                            });
                            /*  DeliveryAddressDialog(
                        context: context,
                        address: _address,
                        onChanged: (Address _address) {
                          _con.addAddress(_address);
                        },
                        ); */
                          } else {
                            _con.toggleDelivery();
                          }
                        },
                        onLongPress: (Address _address) {
                          var bottomSheetController =
                              _con.scaffoldKey.currentState.showBottomSheet(
                            (context) => DeliveryAddressBottomSheetWidget(
                                scaffoldKey: _con.scaffoldKey),
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                            ),
                          );
                          bottomSheetController.closed.then((value) {
                            setState(() {});
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: 55,
                        height: 40,
                        child: FlatButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            var bottomSheetController =
                                _con.scaffoldKey.currentState.showBottomSheet(
                              (context) => DeliveryAddressBottomSheetWidget(
                                  scaffoldKey: _con.scaffoldKey),
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                              ),
                            );
                            bottomSheetController.closed.then((value) {
                              setState(() {});
                            });
                          },
                          child: Icon(Icons.edit_location_outlined,
                              color: Theme.of(context).primaryColor),
                          color: Theme.of(context).accentColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                      ),
                    ],
                  )
                : SizedBox(
                    height: 0,
                  )
          ],
        ),
      ),
    );
  }
}
