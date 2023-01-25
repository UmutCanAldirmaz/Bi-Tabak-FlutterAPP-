import 'dart:convert';
import 'package:bitirme_projesi/data/entity/yemekler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import '../entity/sepettekiler.dart';
import '../entity/sepettekiler_cevap.dart';
import '../entity/users.dart';
import '../entity/yemekler_cevap.dart';

class SepetRepo {

  final firestore = FirebaseFirestore.instance;

  final auth = FirebaseAuth.instance;


  createUser(Users user,String uid){
      firestore.collection("Users").doc(uid).set({
        "email":user.email,
        "name":user.name,
        "password":user.password
      }).catchError((error, stackTrace) {
        print("create user hatası:${error.toString()}");
      });
  }

  Future<int> getTotal(String kullanici_adi) async{
    int total=0;
    var Sepet = await sepetiYukle(kullanici_adi);
    Sepet.forEach((element) {
      total += int.parse(element.yemek_siparis_adet) * int.parse(element.yemek_fiyat);
    });
    return total;
  }

  Future<List<Yemekler>> parseYemeklerCevap(String cevap) async {
    return YemeklerCevap.fromJson(json.decode(cevap)).yemekler;
  }

  List<Sepettekiler> parseSepettekilerCevap(String cevap,Response response) {
    try{
      if(response.statusCode == 200){
        return SepettekilerCevap.fromJson(json.decode(cevap)).sepet;
      }else{
        return [];
      }

    }catch(e){
      return [];
    }
  }

  Future<List<Sepettekiler>> sepetiYukle(String kullanici_adi) async {
    var url = "http://kasimadalan.pe.hu/yemekler/sepettekiYemekleriGetir.php";
    var veri = {"kullanici_adi": kullanici_adi};
    var cevap = await Dio().post(url, data: FormData.fromMap(veri));
    print("Yüklenen sepet:${cevap.data.toString()}");
    return parseSepettekilerCevap(cevap.data.toString(),cevap);
  }

  Future<void> sepeteEkle(Yemekler yemek, int secilenAdet, String kullanici_adi) async {
    var url = "http://kasimadalan.pe.hu/yemekler/sepeteYemekEkle.php";
    var Sepet = await sepetiYukle(kullanici_adi);
    for (var SepetimdekiYemek in Sepet) {
      if (SepetimdekiYemek.yemek_adi == yemek.ad) {
        secilenAdet =
            secilenAdet + int.parse(SepetimdekiYemek.yemek_siparis_adet);
        sil(int.parse(SepetimdekiYemek.sepet_yemek_id), kullanici_adi);
      }
    }
    var veri = {
      "yemek_adi": yemek.ad,
      "yemek_resim_adi": yemek.resim_ad,
      "yemek_fiyat": int.parse(yemek.fiyat),
      "yemek_siparis_adet": secilenAdet,
      "kullanici_adi": kullanici_adi
    };

    var cevap = await Dio().post(url, data: FormData.fromMap(veri));
    print("Eklenen Sepet:${cevap.data.toString()}");
  }

  Future<void> sepetAzalt(Yemekler yemek, int secilenAdet, String kullanici_adi) async {
    var url = "http://kasimadalan.pe.hu/yemekler/sepeteYemekEkle.php";
    var Sepet = await sepetiYukle(kullanici_adi);
    for (var SepetimdekiYemek in Sepet) {
      if (SepetimdekiYemek.yemek_adi == yemek.ad) {
        secilenAdet = int.parse(SepetimdekiYemek.yemek_siparis_adet) - 1;
        sil(int.parse(SepetimdekiYemek.sepet_yemek_id), kullanici_adi);
      }
    }
    var veri = {
      "yemek_adi": yemek.ad,
      "yemek_resim_adi": yemek.resim_ad,
      "yemek_fiyat": int.parse(yemek.fiyat),
      "yemek_siparis_adet": secilenAdet,
      "kullanici_adi": kullanici_adi
    };

    var cevap = await Dio().post(url, data: FormData.fromMap(veri));
    print("Eklenen Sepet:${cevap.data.toString()}");
  }

  Future<void> sepetArtir(Yemekler yemek, int secilenAdet, String kullanici_adi) async {
    var url = "http://kasimadalan.pe.hu/yemekler/sepeteYemekEkle.php";
    var Sepet = await sepetiYukle(kullanici_adi);
    for (var SepetimdekiYemek in Sepet) {
      if (SepetimdekiYemek.yemek_adi == yemek.ad) {
        secilenAdet = int.parse(SepetimdekiYemek.yemek_siparis_adet)+1;
        sil(int.parse(SepetimdekiYemek.sepet_yemek_id), kullanici_adi);
      }
    }
    var veri = {
      "yemek_adi": yemek.ad,
      "yemek_resim_adi": yemek.resim_ad,
      "yemek_fiyat": int.parse(yemek.fiyat),
      "yemek_siparis_adet": secilenAdet,
      "kullanici_adi": kullanici_adi
    };

    var cevap = await Dio().post(url, data: FormData.fromMap(veri));
    print("Eklenen Sepet:${cevap.data.toString()}");
  }

  Future<void> sil(int sepet_yemek_id, String kullanici_adi) async {
    var url = "http://kasimadalan.pe.hu/yemekler/sepettenYemekSil.php";
    var veri = {
      "sepet_yemek_id": sepet_yemek_id,
      "kullanici_adi": kullanici_adi
    };
    var cevap = await Dio().post(url, data: FormData.fromMap(veri));
  }

  Future<List<Yemekler>> yemekleriYukle() async {
    var url = "http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php";
    var cevap = await Dio().get(url);
    return parseYemeklerCevap(cevap.data.toString());
  }

}
