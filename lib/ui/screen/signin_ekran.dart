import 'package:bitirme_projesi/ui/screen/anasayfa.dart';
import 'package:bitirme_projesi/ui/screen/signup_ekran.dart';
import 'package:bitirme_projesi/widgets/button_widget.dart';
import 'package:bitirme_projesi/widgets/reusableTextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../widgets/logo_widget.dart';
import '../cubit/sepet_cubit.dart';

class SignInEkran extends StatefulWidget {


  @override
  State<SignInEkran> createState() => _SignInEkranState();
}

class _SignInEkranState extends State<SignInEkran> {

  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height,
        decoration:  BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.yellow.withOpacity(0.5),
                  Colors.orange.withOpacity(0.5),
                  Colors.red,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, MediaQuery
                .of(context)
                .size
                .height * 0.1, 20, 0),
            child: Column(
              children: [
                logoWidget('images/newlogo.png'),
                SizedBox(height: 30,),
                reusableTextField("E-postanızı Giriniz", Icons.person_outline, false, _emailTextController),
                SizedBox(height: 20,),
                reusableTextField("Parola Giriniz", Icons.lock, true, _passwordTextController),
                SizedBox(height: 20,),
                signInSignUpButton(context, true, () {
                  FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailTextController.text, password:_passwordTextController.text ).then((crud_id) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AnaSayfa()));
                  }).onError((error, stackTrace) {
                    Get.snackbar(
                      "Giriş Başarısız",
                      "${error}",
                      backgroundColor: Colors.white,
                      colorText: Colors.black,
                      snackPosition: SnackPosition.BOTTOM,
                      icon: Icon(Icons.report, color: Colors.red),
                      duration: const Duration(seconds: 5),
                      borderRadius: 20,
                      margin: EdgeInsets.all(15),
                      isDismissible: true,
                      dismissDirection: DismissDirection.down,
                    );
                    print("error code:${error.hashCode}");
                    print("error:${error}");


                  });
                }),
                signUpOption(context)
              ],
            ),
          ),
        ),
      ));
  }
}

Row signUpOption(BuildContext context,) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text(
        "Kayıtlı hesabınız yok mu ?", style: TextStyle(color: Colors.white70),),
      GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpEkran()));

        },
        child: const Text(
            "Kayıt Ol",
          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
        ),
      ),
    ],
  );
}

