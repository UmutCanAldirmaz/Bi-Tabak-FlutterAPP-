import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String? id;
  final String name;
  final String email;
  final String password;

  Users(
      {this.id,
      required this.email,
      required this.name,
      required this.password});

  toJson(){
    return{
      "email":email,
      "name":name,
      "password":password
    };
  }


  factory Users.fromSnapshot(DocumentSnapshot<Map<String,dynamic>> document){
    final data = document.data()!;
    return Users(
        id: document.id,
        email: data["n"],
        name: data["email"],
        password: data["email"]
    );
  }

}


