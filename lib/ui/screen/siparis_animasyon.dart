import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:lottie/lottie.dart';

import '../../util/dimensions.dart';
import '../../widgets/app_icon.dart';
import 'anasayfa.dart';

class SiparisAnimasyon extends StatefulWidget {
  const SiparisAnimasyon({Key? key}) : super(key: key);


  @override
  State<SiparisAnimasyon> createState() => _SiparisAnimasyonState();
}

class _SiparisAnimasyonState extends State<SiparisAnimasyon> {

  Future<bool> backPage(BuildContext context) async{
    return false;
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () => backPage(context),
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'images/animation/delivery.json',
                height: 300,
                reverse: true,
                repeat: true,
              ),
              Text(
                "Siparişiniz Alınmıştır.",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 24,
                    fontFamily: "Griffon",
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
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
                          size: Dimensions.iconSize44,
                          backgroundColor: Colors.deepOrange.shade100)),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) =>  AnaSayfa()));
                      },
                      child: AppIcon(
                          icon: Icons.home_outlined,
                          size: Dimensions.iconSize44,
                          backgroundColor: Colors.deepOrange.shade100)),
                ],
              ),


            ],
          ),
        ),
      ),
    );
  }
}
