import 'package:http/http.dart' as http;
import 'dart:convert';

final apiKey = '11D54BBC-79B2-4E51-BDDD-28BECEC80799';

class ExchangeRate {
  Future<int> getExchangeRate(String selectedCurrency) async {
    // 'https://rest.coinapi.io/v1/exchangerate/BTC/USD?apiKey=$apiKey'
    var url = Uri.parse(
        'https://rest.coinapi.io/v1/exchangerate/BTC/$selectedCurrency?apiKey=$apiKey');
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      double currencyData = jsonDecode(response.body)["rate"];
      print(currencyData);
      return currencyData.toInt();
    } else {
      print(response.statusCode);
      return null;
    }
  }

  Future<int> getExchangeRateForSelectedCrypto(
      String crypto, String selectedCurrency) async {
    // 'https://rest.coinapi.io/v1/exchangerate/BTC/USD?apiKey=$apiKey'
    var url = Uri.parse(
        'https://rest.coinapi.io/v1/exchangerate/$crypto/$selectedCurrency?apiKey=$apiKey');
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      double currencyData = jsonDecode(response.body)["rate"];
      print(currencyData);
      return currencyData.toInt();
    } else {
      print(response.statusCode);
      return response.statusCode;
    }
  }
}
