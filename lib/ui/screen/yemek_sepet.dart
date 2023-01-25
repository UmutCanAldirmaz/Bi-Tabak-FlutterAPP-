import 'package:bitirme_projesi/data/entity/sepettekiler.dart';
import 'package:bitirme_projesi/data/entity/yemekler.dart';
import 'package:bitirme_projesi/ui/cubit/sepet_cubit.dart';
import 'package:bitirme_projesi/ui/screen/anasayfa.dart';
import 'package:bitirme_projesi/ui/screen/siparis_animasyon.dart';
import 'package:bitirme_projesi/util/dimensions.dart';
import 'package:bitirme_projesi/widgets/big_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../widgets/app_icon.dart';

class YemekSepet extends StatefulWidget {

  String userName;

  YemekSepet({required this.userName});

  int toplam=0;
  int sepet_toplam=0;
  @override
  State<YemekSepet> createState() => _YemekSepetState();
}

class _YemekSepetState extends State<YemekSepet> {

  String ad="";
  List<String> cart_id=[];

  @override
  void initState() {
    super.initState();
    ad = widget.userName;
    context.read<SepetCubit>().sepetiYukle(ad);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Positioned(
          top: Dimensions.height30 * 2,
          left: Dimensions.width20,
          right: Dimensions.width20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: AppIcon(
                      icon: Icons.arrow_back_ios,
                      size: Dimensions.iconSize44,
                      backgroundColor: Colors.deepOrange.shade100)),
              SizedBox(width: Dimensions.width20 * 6),
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
        ),
        Positioned(
            top: Dimensions.height30 * 4,
            left: Dimensions.width20,
            right: Dimensions.width20,
            bottom: 0,
            child: Container(
                margin: EdgeInsets.only(top: Dimensions.height15),
                color: Colors.white,
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: BlocBuilder<SepetCubit, List<Sepettekiler>>(
                    builder: (context, sepetListesi) {
                      if (sepetListesi.isNotEmpty) {
                        context.read<SepetCubit>().getTotal(ad).then((value) {
                          if(mounted) {
                            setState(() {
                            widget.sepet_toplam = value;
                          });
                          }
                        });
                        return ListView.builder(
                          itemCount: sepetListesi.length,
                          itemBuilder: (context, index) {
                            var sepet = sepetListesi[index];
                            cart_id.add(sepet.sepet_yemek_id);
                            widget.toplam = int.parse(sepet.yemek_siparis_adet) * int.parse(sepet.yemek_fiyat);
                            return Container(
                              height: Dimensions.height20 * 5,
                              width: double.maxFinite,
                              child: Row(
                                children: [
                                  Container(
                                    width: Dimensions.height20 * 5,
                                    height: Dimensions.height20 * 5,
                                    margin: EdgeInsets.only(
                                        bottom: Dimensions.height10),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              "http://kasimadalan.pe.hu/yemekler/resimler/${sepet.yemek_resim_adi}")),
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.radius20),
                                    ),
                                  ),
                                  SizedBox(
                                    width: Dimensions.width10,
                                  ),
                                  Expanded(
                                      child: Container(
                                    height: Dimensions.height20 * 5,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        BigText(text: "${sepet.yemek_adi} "),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            BigText(
                                              text: "${widget.toplam} ₺",
                                              color: Colors.red,
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(
                                                  top: Dimensions.height10,
                                                  bottom: Dimensions.height20,
                                                  left: Dimensions.height20,
                                                  right: Dimensions.height20),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Dimensions.radius20),
                                                  color: Colors.white),
                                              child: Row(
                                                children: [
                                                  GestureDetector(
                                                      onTap: () {
                                                        if(mounted) {
                                                          setState(() {
                                                          if(int.parse(sepet.yemek_siparis_adet) == 1) {
                                                            context.read<SepetCubit>().sil(int.parse(sepet.sepet_yemek_id), sepet.kullanici_adi);
                                                          }else{
                                                            context.read<SepetCubit>().sepetAzalt(Yemekler(
                                                                id: sepet.sepet_yemek_id,
                                                                ad: sepet.yemek_adi,
                                                                fiyat: sepet.yemek_fiyat,
                                                                resim_ad: sepet.yemek_resim_adi), int.parse(sepet.yemek_siparis_adet), sepet.kullanici_adi);
                                                            context.read<SepetCubit>().sepetiYukle(sepet.kullanici_adi);
                                                          }
                                                        });
                                                        }
                                                      },
                                                      child: Icon(
                                                        Icons.remove,
                                                        color: Colors.red,
                                                      )), // Sepet Azaltma
                                                  SizedBox(
                                                    width:
                                                        Dimensions.width10 / 2,
                                                  ),
                                                  BigText(
                                                      text: sepet.yemek_siparis_adet
                                                          .toString()),
                                                  SizedBox(
                                                    width:
                                                        Dimensions.width10 / 2,
                                                  ),
                                                  GestureDetector(
                                                      onTap: () {
                                                        if(mounted) {
                                                          setState(() {
                                                          if(int.parse(sepet.yemek_siparis_adet)>=20){
                                                              Get.snackbar("Maksimum ürün Sayısı","Daha fazla ürün ekleyemezsiniz.");
                                                            }else{
                                                              context.read<SepetCubit>().sepetArtir(Yemekler(
                                                                      id: sepet.sepet_yemek_id,
                                                                      ad: sepet.yemek_adi,
                                                                      fiyat: sepet.yemek_fiyat,
                                                                      resim_ad: sepet.yemek_resim_adi), int.parse(sepet.yemek_siparis_adet), sepet.kullanici_adi);
                                                          }
                                                        });
                                                        }
                                                      },
                                                      child: Icon(
                                                        Icons.add,
                                                        color: Colors.red,
                                                      )) // Sepet Arttırma
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ))
                                ],
                              ),
                            );
                          },
                        );
                      } else {
                        print("Liste Boş");
                        return  Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ))),
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
                  SizedBox(width: Dimensions.width10/2,),
                  BigText(text: "Toplam:${widget.sepet_toplam}",color: Colors.red,),
                  SizedBox(width: Dimensions.width10/2,),
                ],
              ),
            ),
            GestureDetector(
              onTap: (){
                if(mounted) {
                  setState(() {
                  cart_id.forEach((element) { 
                    context.read<SepetCubit>().sil(int.parse(element), ad);
                  });
                });
                }
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  SiparisAnimasyon()));
              },
              child: Container(
                padding: EdgeInsets.only(top: Dimensions.height20,bottom: Dimensions.height20,left: Dimensions.height20,right: Dimensions.height20),
                child: BigText(text: "Sipariş Ver",color: Colors.red,),
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
