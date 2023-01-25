import 'dart:convert';
import 'package:bitirme_projesi/data/entity/sepettekiler.dart';
import 'package:bitirme_projesi/data/entity/sepettekiler_cevap.dart';
import 'package:bitirme_projesi/data/entity/yemekler.dart';
import 'package:bitirme_projesi/data/entity/yemekler_cevap.dart';
import 'package:dio/dio.dart';

class YemeklerRepo {
  List<Yemekler> parseYemeklerCevap(String cevap) {
    return YemeklerCevap.fromJson(json.decode(cevap)).yemekler;
  }


  Future<List<Yemekler>> yemekleriYukle() async {
    var url = "http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php";
    var cevap = await Dio().get(url);
    return parseYemeklerCevap(cevap.data.toString());
  }

}
