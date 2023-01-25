class Yemekler {
  String id;
  String ad;
  String fiyat;
  String resim_ad;


  Yemekler(
      {required this.id,
      required this.ad,
      required this.fiyat,
      required this.resim_ad,
      });

  factory Yemekler.fromJson(Map<String, dynamic> json) {
    return Yemekler(
        id: json["yemek_id"] as String,
        ad: json["yemek_adi"] as String,
        resim_ad: json["yemek_resim_adi"] as String,
        fiyat: json["yemek_fiyat"] as String,
    );
  }
}
