import 'package:bitirme_projesi/data/entity/yemekler.dart';
import 'package:bitirme_projesi/ui/cubit/anasayfa_cubit.dart';
import 'package:bitirme_projesi/ui/cubit/sepet_cubit.dart';
import 'package:bitirme_projesi/ui/screen/yemek_detay.dart';
import 'package:bitirme_projesi/ui/screen/yemek_sepet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import '../../util/dimensions.dart';
import '../../widgets/app_icon.dart';

class AnaSayfa extends StatefulWidget {
  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  bool searchInActive = false;

  final auth = FirebaseAuth.instance;

  String userName = "";

  @override
  void initState() {
    super.initState();
    context.read<AnaSayfaCubit>().yemekleriYukle();
    context.read<SepetCubit>().getUser(auth.currentUser!.uid).then((value) {
      setState(() {
        userName = value;
        print("kullanici adi anasayfa:$userName}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print("büyülük:" + MediaQuery.of(context).size.height.toString());
    return Scaffold(
      backgroundColor: Color(0xFFF6E8E8),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => YemekSepet(userName: userName,)));
                      print("ana sayfa kullanici adi:$userName");
                    },
                    child: AppIcon(icon: Icons.shopping_cart_outlined,size: Dimensions.iconSize36,backgroundColor:Colors.white)
                ),
                SizedBox(width: Dimensions.width10),
                GestureDetector(
                    onTap: () {
                      FirebaseAuth.instance.signOut().then((value) {
                        print("Çıkış tamamlandı.");
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                        Get.snackbar(
                          "Çıkış Başarılı",
                          "Hesabınızdan Çıkış yapıldı.",
                          backgroundColor: Colors.white,
                          colorText: Colors.black,
                          snackPosition: SnackPosition.TOP,
                          icon: Icon(Icons.logout, color: Colors.greenAccent),
                          duration: const Duration(seconds: 5),
                          borderRadius: 20,
                          margin: EdgeInsets.all(15),
                          isDismissible: true,
                          dismissDirection: DismissDirection.up,
                        );
                      });
                    },
                    child: AppIcon(
                        icon: Icons.logout_outlined,
                        size: Dimensions.iconSize36,
                        backgroundColor: Colors.white)),
              ],
            ),
          ),
        ],
        backgroundColor: Color(0xffff8200),
        title: Text("Hoşgeldiniz:$userName",
            style: TextStyle(
                fontSize: 16, fontFamily: "Griffon", color: Colors.black)),
      ),
      body: BlocBuilder<AnaSayfaCubit, List<Yemekler>>(
        builder: (context, yemekListesi) {
          if (yemekListesi.isNotEmpty) {
            return GridView.builder(
              itemCount: yemekListesi.length,
              itemBuilder: (context, index) {
                var yemek = yemekListesi[index];
                return GestureDetector(
                  onTap: () {
                    print("Başarılı Sayfa");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                YemeklerDetay(yemek: yemek))).then((value) {
                      context.read<AnaSayfaCubit>().yemekleriYukle();
                    });
                  },
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        Image.network(
                          "http://kasimadalan.pe.hu/yemekler/resimler/${yemek.resim_ad}",
                          height: 150,
                          width: 100,
                        ),
                        Text(
                          "${yemek.ad}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                        Text(
                          "${yemek.fiyat} ₺",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                );
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 2,
                crossAxisCount: 3,
                childAspectRatio: 1 / 1.4,
              ),
            );
          } else {
            return const Center();
          }
        },
      ),
    );
  }
}
