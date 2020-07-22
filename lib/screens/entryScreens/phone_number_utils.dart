import 'package:flutter_country_picker/country.dart';

class CountryAndNumber {
  Country country;
  String number;

  CountryAndNumber(this.country, this.number);

  @override
  String toString() {
    return 'CountryAndNumber{country: $country, number: $number}';
  }
}

String getValidNumber(String countryCode, String number) {
  return '${number.startsWith('+') ? '' : '+'}$countryCode'
      '${number.startsWith('0') ? number.substring(1, number.length) : number}';
}

CountryAndNumber getCountryAndNumber(String fullNumber) {
  for (int i = 3; i > 0; i--) {
    final Country foundCode = Country.ALL.firstWhere(
      (code) => code.dialingCode == fullNumber.substring(0, i),
      orElse: () => null,
    );

    if (foundCode != null) {
      return CountryAndNumber(
          foundCode, fullNumber.substring(i, fullNumber.length));
    }
  }
  return null;
}
