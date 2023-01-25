import 'package:bitirme_projesi/data/repo/sepet_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/entity/sepettekiler.dart';
import '../../data/entity/users.dart';
import '../../data/entity/yemekler.dart';

class SepetCubit extends Cubit<List<Sepettekiler>> {


  SepetCubit() :super(<Sepettekiler>[]);

  var srepo = SepetRepo();

   Future<String> getUser(String uid) async {
     String email =  FirebaseAuth.instance.currentUser!.email!.trim();
     var collection =  FirebaseFirestore.instance.collection('Users');
     var docSnapshot = await collection.doc(uid).get();
     if (docSnapshot.exists) {
       Map<String, dynamic>? data = docSnapshot.data();
       String name = await data?['name']!!;
       print("cubit k.adi:$name");
       return name;
     }else{
       print("bulunamadı");
       return "";
     }
   }

  Future<void> createUser(Users user,String uid) async{
    await srepo.createUser(user,uid);
  }

   Future<int>getTotal(String kullanici_adi) async{
     return await srepo.getTotal(kullanici_adi);

  }


  Future<void> sepetiYukle(String kullanici_adi) async {
    var liste = await srepo.sepetiYukle(kullanici_adi);

    liste.sort((a,b) {
      int nameComp = a.yemek_adi.toLowerCase().compareTo(b.yemek_adi.toLowerCase());
      if(nameComp == 0){
        return -nameComp;
      }else return nameComp;
    });

    emit(liste);
  }

  Future<void> sil(int sepet_yemek_id, String kullanici_adi) async {
    await srepo.sil(sepet_yemek_id, kullanici_adi);

    await sepetiYukle(kullanici_adi);
  }

  Future<void> sepeteEkle(Yemekler yemek, int secilenAdet, String kullanici_adi) async {
    await srepo.sepeteEkle(yemek, secilenAdet, kullanici_adi);


  }

  Future<void> sepetAzalt(Yemekler yemek, int secilenAdet, String kullanici_adi) async {
    await srepo.sepetAzalt(yemek, secilenAdet, kullanici_adi);

    await sepetiYukle(kullanici_adi);

  }

  Future<void> sepetArtir(Yemekler yemek, int secilenAdet, String kullanici_adi) async {
    await srepo.sepetArtir(yemek, secilenAdet, kullanici_adi);

    await sepetiYukle(kullanici_adi);
  }



}