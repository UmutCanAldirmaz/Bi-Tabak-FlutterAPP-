import 'package:bitirme_projesi/data/entity/sepettekiler.dart';

class SepettekilerCevap {
  List<Sepettekiler> sepet;

  int success;

  SepettekilerCevap({required this.sepet, required this.success});

  factory SepettekilerCevap.fromJson(Map<String, dynamic> json) {
    var jsonArray = json["sepet_yemekler"] as List;
    var sepet = jsonArray
        .map((jsonArrayNesnesi) => Sepettekiler.fromJson(jsonArrayNesnesi))
        .toList();

    return SepettekilerCevap(sepet: sepet, success: json["success"] as int);
  }
}
