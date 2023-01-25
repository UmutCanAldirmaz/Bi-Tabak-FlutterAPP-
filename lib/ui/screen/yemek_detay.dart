import 'package:bitirme_projesi/data/entity/yemekler.dart';
import 'package:bitirme_projesi/ui/cubit/detay_cubit.dart';
import 'package:bitirme_projesi/ui/cubit/sepet_cubit.dart';
import 'package:bitirme_projesi/ui/screen/yemek_sepet.dart';
import 'package:bitirme_projesi/util/dimensions.dart';
import 'package:bitirme_projesi/widgets/app_column.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/big_text.dart';
import 'package:get/get.dart';

class YemeklerDetay extends StatefulWidget {
  Yemekler yemek;

  YemeklerDetay({required this.yemek});

  @override
  State<YemeklerDetay> createState() => _YemeklerDetayState();
}

class _YemeklerDetayState extends State<YemeklerDetay> {
  int secilenAdet = 1;
  String kullanici_adi="";

  final auth= FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  @override
  Widget build(BuildContext context) {
    context.read<SepetCubit>().getUser(auth.currentUser!.uid).then((value) => {
        kullanici_adi = value,
    });

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: Dimensions.height30*2,
            left: 0,
            right: 0,
            child: Container(
              width: double.maxFinite,
              height: 320,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                    image: NetworkImage("http://kasimadalan.pe.hu/yemekler/resimler/${widget.yemek.resim_ad}")),

              ),
            )), //Resim
          Positioned(
            top: Dimensions.height30,
            left: Dimensions.width20,
              right: Dimensions.width20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap:(){
                        Navigator.of(context).pop();
                      },
                      child: AppIcon(icon: Icons.arrow_back_ios,size: Dimensions.iconSize36,backgroundColor:Colors.deepOrange.shade100)
                  ),
                  GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => YemekSepet(userName: kullanici_adi,)));
                        print(kullanici_adi);
                      },
                      child: AppIcon(icon: Icons.shopping_cart_outlined,size: Dimensions.iconSize36,backgroundColor:Colors.deepOrange.shade100,)
                  ),

                ],
              ),
          ), // Bar Icons
          Positioned(
              left: 0,
              right: 0,
              top: Dimensions.detayfoodSize,
              child: Container(
              padding: EdgeInsets.only(left: Dimensions.width20,right: Dimensions.width20,top: 300),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                ),
                child:AppColumn(text: widget.yemek.ad)

          )), // ResimDetay
        ],
      ),
      bottomNavigationBar: Container(
        height: Dimensions.bottomHeightBar,
        padding: EdgeInsets.only(top: Dimensions.height30,bottom: Dimensions.height30,left: Dimensions.width20,right: Dimensions.width20),
        decoration: BoxDecoration(
          color: Colors.deepOrangeAccent,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimensions.radius20*3),
            topRight: Radius.circular(Dimensions.radius20*3),
          )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.only(top: Dimensions.height20,bottom: Dimensions.height20,left: Dimensions.height20,right: Dimensions.height20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius20),
                color: Colors.white
              ),
              child: Row(
                children: [
                  GestureDetector(
                      onTap: (){
                        setState(() {
                          if(secilenAdet == 1){
                            Get.snackbar(
                                "Minimum Ürün Sayısı","Daha fazla ürün azaltamazsınız.",
                                backgroundColor: Colors.deepOrange,
                                colorText: Colors.white
                            );
                            return;
                          }else{
                            secilenAdet-=1;
                          }
                        });
                      },
                      child:Icon(Icons.remove,color: Colors.red,)
                  ),
                  SizedBox(width: Dimensions.width10/2,),
                  BigText(text: secilenAdet.toString()),
                  SizedBox(width: Dimensions.width10/2,),
                  GestureDetector(
                      onTap: (){
                        setState(() {
                          if(secilenAdet >= 20){
                            Get.snackbar(
                                "Maksimum Ürün Sayısı","Daha Fazla ürün ekleyemezsiniz.",
                              backgroundColor: Colors.deepOrange,
                              colorText: Colors.white

                            );
                            secilenAdet = 20;
                          }else{

                            secilenAdet+=1;
                          }
                        });
                      },
                      child: Icon(Icons.add,color: Colors.red,)
                  )

                ],
              ),
            ),
            GestureDetector(
              onTap: (){
                print("userName:$kullanici_adi");
                context.read<DetayCubit>().sepeteEkle(widget.yemek,secilenAdet,kullanici_adi);
              },
              child: Container(
                padding: EdgeInsets.only(top: Dimensions.height20,bottom: Dimensions.height20,left: Dimensions.height20,right: Dimensions.height20),
                child: BigText(text: " ${int.parse(widget.yemek.fiyat) * secilenAdet} ₺  Sepete Ekle",color: Colors.red,),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radius20),
                    color:Colors.white
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
