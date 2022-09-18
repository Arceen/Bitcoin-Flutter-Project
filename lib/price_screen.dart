import 'dart:io';

import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/material.dart';
// import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:bitcoin_ticker/exchange_converter.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  ExchangeRate exchangeRate;
  String selectedCurrency = "USD";
  Map<String, int> selectedCurrencyValue;

  @override
  initState() {
    exchangeRate = ExchangeRate();
    selectedCurrencyValue = new Map();
    setExchangeRateAllCurrency();
    super.initState();
  }

  // void setExchangeRate() async {
  //   int tempVal = await exchangeRate.getExchangeRate(selectedCurrency);
  //   setState(() {
  //     selectedCurrencyValue = tempVal;
  //   });
  // }

  void setExchangeRateAllCurrency() async {
    Map<String, int> tempVals = new Map();
    var f = <Future>[];

    for (var i in cryptoList) {
      f.add(exchangeRate.getExchangeRateForSelectedCrypto(i, selectedCurrency));
    }

    dynamic results = await Future.wait(f);
    int currIndex = 0;
    for (var i in cryptoList) {
      tempVals[i] = results[currIndex++];
    }

    setState(() {
      selectedCurrencyValue = tempVals;
    });
  }

  Widget getPlatformSpecificCurrencyPicker() {
    if (Platform.isAndroid) {
      return DropdownButton(
          value: selectedCurrency,
          items: [
            // ignore: sdk_version_ui_as_code
            for (var i in currenciesList)
              DropdownMenuItem(child: Text(i), value: i)
          ],
          onChanged: (value) async {
            // Map<String, int> tempVals = new Map();
            // for (var i in selectedCurrencyValue.keys) {
            //   tempVals[i] =
            //       await exchangeRate.getExchangeRateForSelectedCrypto(i, value);
            // }

            Map<String, int> tempVals = new Map();
            var f = <Future>[];
            for (var i in selectedCurrencyValue.keys) {
              f.add(exchangeRate.getExchangeRateForSelectedCrypto(i, value));
            }
            dynamic results = await Future.wait(f);
            int currIndex = 0;
            for (var i in cryptoList) {
              tempVals[i] = results[currIndex++];
            }
            setState(() {
              selectedCurrency = value;
              selectedCurrencyValue = tempVals;
            });
          });
    } else {
      return CupertinoPicker(
        itemExtent: 25.0,
        onSelectedItemChanged: (index) async {
          Map<String, int> tempVals = new Map();
          for (var i in selectedCurrencyValue.keys) {
            tempVals[i] = await exchangeRate.getExchangeRateForSelectedCrypto(
                i, currenciesList[index]);
          }

          setState(() {
            selectedCurrency = currenciesList[index];
            selectedCurrencyValue = tempVals;
          });
        },
        children: [
          // ignore: sdk_version_ui_as_code
          for (String currency in currenciesList)
            Text(
              currency,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            )
        ],
      );
    }
  }

  List<Widget> generatedCryptoButtons() {
    return [
      // ignore: sdk_version_ui_as_code
      for (var i in cryptoList)
        Padding(
          padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
          child: Card(
            color: Colors.lightBlueAccent,
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
              child: Text(
                '1 $i = ${selectedCurrencyValue[i] == null ? '?' : selectedCurrencyValue[i]} ${selectedCurrency == null ? '?' : selectedCurrency}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: generatedCryptoButtons(),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlue,
              child: getPlatformSpecificCurrencyPicker(),
            ),
          ),
        ],
      ),
    );
  }
}
