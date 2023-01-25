import 'package:bitirme_projesi/data/entity/yemekler.dart';
import 'package:bitirme_projesi/data/repo/sepet_repo.dart';
import 'package:bitirme_projesi/data/repo/yemekler_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/entity/sepettekiler.dart';

class DetayCubit extends Cubit<List<Sepettekiler>>{


  DetayCubit():super(<Sepettekiler>[]);

  var srepo=SepetRepo();

  Future<void> sepeteEkle(Yemekler yemekler, int yemek_siparis_adet, String kullanici_adi) async {
    await srepo.sepeteEkle(yemekler,yemek_siparis_adet, kullanici_adi);

  }

  Future<void> sepetiYukle(String kullanici_adi) async {
     var liste = await srepo.sepetiYukle(kullanici_adi);

     emit(liste);

  }
}