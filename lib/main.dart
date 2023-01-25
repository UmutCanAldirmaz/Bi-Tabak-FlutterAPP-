import 'package:bitirme_projesi/ui/cubit/anasayfa_cubit.dart';
import 'package:bitirme_projesi/ui/cubit/detay_cubit.dart';
import 'package:bitirme_projesi/ui/cubit/sepet_cubit.dart';
import 'package:bitirme_projesi/ui/screen/signin_ekran.dart';
import 'package:bitirme_projesi/ui/screen/signup_ekran.dart';
import 'package:bitirme_projesi/ui/screen/siparis_animasyon.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:bitirme_projesi/ui/screen/anasayfa.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AnaSayfaCubit()),
        BlocProvider(create: (context) => DetayCubit()),
        BlocProvider(create: (context) => SepetCubit()),
      ],
      child: GetMaterialApp(
        title: '',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SignInEkran(),
      ),
    );
  }
}
