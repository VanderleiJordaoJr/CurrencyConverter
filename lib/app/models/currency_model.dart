// To parse this JSON data, do
//
//     final currency = currencyFromJson(jsonString);

import 'dart:convert';

List<Currency> currencyFromJson(String str) =>
    List<Currency>.from(json.decode(str).map((x) => Currency.fromJson(x)));

String currencyToJson(List<Currency> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Currency {
  Currency({
    this.id,
    this.name,
  });

  String id;
  String name;

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
