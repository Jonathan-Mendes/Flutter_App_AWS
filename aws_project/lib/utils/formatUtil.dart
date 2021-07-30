import 'dart:math';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

class FormatUtil {
  String formatMoney(String money) {
    FlutterMoneyFormatter flutterMoneyFormatter = new FlutterMoneyFormatter(
        amount: double.parse(money),
        settings: MoneyFormatterSettings(
            symbol: 'R\$',
            thousandSeparator: '.',
            decimalSeparator: ',',
            symbolAndNumberSeparator: ' ',
            fractionDigits: 2));

    MoneyFormatterOutput moneyFormatterOutput = flutterMoneyFormatter.output;

    return moneyFormatterOutput.symbolOnLeft;
  }

  String formatCurency(String currency) {
    currency = currency.replaceAll(RegExp(r'[R$. ]'), '');
    currency = currency.replaceAll(RegExp(r'[,]'), '.');
    return currency;
  }
}
