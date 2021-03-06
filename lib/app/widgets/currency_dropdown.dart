import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterando_02/app/models/currency_model.dart';
import 'package:flutterando_02/app/services/currency_service.dart';

class CurrencyDropdown extends StatelessWidget {
  final List<Currency> currencyList;
  final String selectedValue;
  final ValueChanged<String> onChanged;
  CurrencyDropdown({this.currencyList, this.selectedValue, this.onChanged});

  DropdownMenuItem _getItem(Currency currency) {
    return DropdownMenuItem<String>(
      child: Text(currency.name),
      value: currency.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuItem> itens =
        List.of(currencyList.map((currency) => (_getItem(currency))));
    return DropdownButton(
      value: this.selectedValue,
      onChanged: (value) {
        onChanged(value);
      },
      items: itens,
    );
  }
}

class Converter extends StatefulWidget {
  @override
  _ConverterState createState() => _ConverterState();
}

class _ConverterState extends State<Converter> {
  Future<List<Currency>> _currencyList;
  String _selectedFromCurrency;
  String _selectedToCurrency;
  int _valueToConvert;
  String _convertedValue;

  @override
  void initState() {
    super.initState();
    this._currencyList = CurrencyService.getInstance().getAvailableCurrencies();
    this._selectedFromCurrency = null;
    this._selectedToCurrency = null;
    this._convertedValue = '0';
    this._valueToConvert = 0;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Currency>>(
        future: _currencyList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CurrencyDropdown(
                      currencyList: snapshot.data,
                      onChanged: (value) {
                        setState(() {
                          _selectedFromCurrency = value;
                        });
                      },
                      selectedValue: _selectedFromCurrency,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (value) {
                        _valueToConvert = int.parse(value);
                      },
                      decoration: new InputDecoration(
                          labelText: "Enter the value to convert"),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CurrencyDropdown(
                      currencyList: snapshot.data,
                      onChanged: (value) {
                        setState(() {
                          _selectedToCurrency = value;
                        });
                      },
                      selectedValue: _selectedToCurrency,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Value: \$$_convertedValue.'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        final convertedValue =
                            await CurrencyService.getInstance()
                                .getConvertedValue(_selectedFromCurrency,
                                    _selectedToCurrency, _valueToConvert);
                        setState(() {
                          _convertedValue = convertedValue;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Converter'),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return CircularProgressIndicator.adaptive();
        });
  }
}
