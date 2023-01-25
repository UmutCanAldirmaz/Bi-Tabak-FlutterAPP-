import 'package:bitirme_projesi/data/entity/yemekler.dart';
import 'package:bitirme_projesi/data/repo/yemekler_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnaSayfaCubit extends Cubit<List<Yemekler>>{


  AnaSayfaCubit():super(<Yemekler>[]);

  var yrepo=YemeklerRepo();

  Future<void> yemekleriYukle() async{
      var liste= await yrepo.yemekleriYukle();
      
      emit(liste);

  }


}