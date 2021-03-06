import 'package:flutter/services.dart';
import 'package:flutterando_02/app/models/currency_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class CurrencyService {
  static CurrencyService _instance = CurrencyService._();

  CurrencyService._();

  static CurrencyService getInstance() {
    return _instance;
  }

  Future<List<Currency>> getAvailableCurrencies() async {
    String data =
        await rootBundle.loadString('assets/json/currency_list.min.json');
    return currencyFromJson(data);
  }

  Future<String> getConvertedValue(String from, String to, int value) async {
    final base = 'https://v6.exchangerate-api.com/v6';
    final apiKey = env['API_KEY'];
    final apiUrl = '$base/$apiKey/pair/$from/$to/$value';
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      double value = json.decode(response.body)['conversion_result'];
      return value.toStringAsPrecision(3);
    } else {
      return 'Error with code ${response.statusCode}';
    }
  }
}
