import 'dart:convert';
import 'dart:io';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';
import '../models/cart.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as userRepo;
import '../repository/settings_repository.dart' as settingsRepo;

Future<Stream<Cart>> getCart() async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Stream.value(null);
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}carts?${_apiToken}with=food;food.restaurant;extras&search=user_id:${_user.id}&searchFields=user_id:=';

  final client = new http.Client();
  final cartResponse = await client.get(url);
  List carts = json.decode(cartResponse.body)['data'];
  final cart = Cart.fromJSON(
      carts != null && carts.isNotEmpty && carts[0] != null ? carts[0] : {});
  final restaurantId = cart.food.restaurant.id;
  Uri uriFee = Helper.getUri('api/restaurant/delivery_fee/$restaurantId');
  Map<String, dynamic> _queryParams = {};
  if (settingsRepo.deliveryAddress.value != null &&
      !settingsRepo.deliveryAddress.value.isUnknown()) {
    _queryParams['myLon'] =
        settingsRepo.deliveryAddress.value.longitude.toString();
    _queryParams['myLat'] =
        settingsRepo.deliveryAddress.value.latitude.toString();
    _queryParams['areaLon'] =
        settingsRepo.deliveryAddress.value.longitude.toString();
    _queryParams['areaLat'] =
        settingsRepo.deliveryAddress.value.latitude.toString();
  }
  _queryParams['with'] = 'users';
  uriFee = uriFee.replace(queryParameters: _queryParams);
  final feeResponsee = await client.get(uriFee);
  final deliveryFee = double.parse(
      json.decode(feeResponsee.body)['data'] != null
          ? json.decode(feeResponsee.body)['data']['delivery_fee']
          : '0.0');
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    var cart = Cart.fromJSON(data);
    cart.food.restaurant.deliveryFee = deliveryFee;
    return cart;
  });
}

Future<Stream<int>> getCartCount() async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Stream.value(0);
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}carts/count?${_apiToken}search=user_id:${_user.id}&searchFields=user_id:=';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map(
        (data) => Helper.getIntData(data),
      );
}

Future<Cart> addCart(Cart cart, bool reset) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Cart();
  }
  Map<String, dynamic> decodedJSON = {};
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String _resetParam = 'reset=${reset ? 1 : 0}';
  cart.userId = _user.id;
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}carts?$_apiToken&$_resetParam';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(cart.toMap()),
  );
  try {
    decodedJSON = json.decode(response.body)['data'] as Map<String, dynamic>;
  } on FormatException catch (e) {
    print(CustomTrace(StackTrace.current, message: e.toString()));
  }
  return Cart.fromJSON(decodedJSON);
}

Future<Cart> updateCart(Cart cart) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Cart();
  }
  final String _apiToken = 'api_token=${_user.apiToken}';
  cart.userId = _user.id;
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}carts/${cart.id}?$_apiToken';
  final client = new http.Client();
  final response = await client.put(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(cart.toMap()),
  );
  return Cart.fromJSON(json.decode(response.body)['data']);
}

Future<bool> removeCart(Cart cart) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return false;
  }
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}carts/${cart.id}?$_apiToken';
  final client = new http.Client();
  final response = await client.delete(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
  );
  return Helper.getBoolData(json.decode(response.body));
}
