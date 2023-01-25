import 'package:bitirme_projesi/data/entity/users.dart';
import 'package:bitirme_projesi/ui/cubit/sepet_cubit.dart';
import 'package:bitirme_projesi/ui/screen/signin_ekran.dart';
import 'package:bitirme_projesi/widgets/button_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../widgets/reusableTextField.dart';

class SignUpEkran extends StatefulWidget {
  @override
  State<SignUpEkran> createState() => _SignUpEkranState();
}

class _SignUpEkranState extends State<SignUpEkran> {
  TextEditingController _userNameTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Kayıt Ol",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.black),
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration:  BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.yellow.withOpacity(0.5),
                Colors.orange.withOpacity(0.5),
                Colors.red,
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  20, MediaQuery.of(context).size.height * 0.1, 20, 0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  reusableTextField("Kullanıcı Adı Giriniz",
                      Icons.person_outline, false, _userNameTextController),
                  SizedBox(
                    height: 20,
                  ),
                  reusableTextField("E-posta Giriniz", Icons.person_outline,
                      false, _emailTextController),
                  SizedBox(
                    height: 20,
                  ),
                  reusableTextField("Parola Giriniz", Icons.lock_outline, true,
                      _passwordTextController),
                  signInSignUpButton(context, false, () {
                    FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailTextController.text, password: _passwordTextController.text).then((value) async {
                      final user = Users(email: _emailTextController.text.trim(),name: _userNameTextController.text.trim(), password: _passwordTextController.text.trim());
                      context.read<SepetCubit>().createUser(user,value.user!.uid);
                      print("Yeni kullanıcı kaydı oluşturuldu");
                      Get.snackbar(
                        "Kayıt Başarılı",
                        "Kaydınız başarıyla gerçekleşmiştir..",
                        backgroundColor: Colors.white,
                        colorText: Colors.black,
                        snackPosition: SnackPosition.TOP,
                        icon: Icon(Icons.verified_user, color: Colors.green),
                        duration: const Duration(seconds: 3),
                        borderRadius: 20,
                        margin: EdgeInsets.all(15),
                        isDismissible: true,
                        dismissDirection: DismissDirection.up,
                      );
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignInEkran()));
                    }).onError((error, stackTrace) {
                      Get.snackbar(
                        "Kayıt Başarısız",
                        "Kaydınız başarıyla gerçekleşmemiştir..",
                        backgroundColor: Colors.white,
                        colorText: Colors.black,
                        snackPosition: SnackPosition.TOP,
                        icon: Icon(Icons.report_outlined, color: Colors.red),
                        duration: const Duration(seconds: 3),
                        borderRadius: 20,
                        margin: EdgeInsets.all(15),
                        isDismissible: true,
                        dismissDirection: DismissDirection.up,
                      );
                      print("Error ${error.toString()}");
                    });
                  })
                ],
              ),
            ),
          ),
        ));
  }
}
