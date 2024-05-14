import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart'; // http_parser パッケージをインポート
import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:io';


class RegisterModel extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final groupController = TextEditingController();
  final gradeController = TextEditingController();

  String? email;
  String? password;
  String? name;
  String? group;
  String? grade;
  String? base64Image;
  Uint8List? imageBytes;

  bool isLoading = false;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void setEmail(String email) {
    this.email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    this.password = password;
    notifyListeners();
  }

  void setName(String name) {
    this.name = name;
    notifyListeners();
  }

  void setGroup(String group) {
    this.group = group;
    notifyListeners();
  }

  void setGrade(String grade) {
    this.grade = grade;
    notifyListeners();
  }

  //ByteDataの取得、Uint8Listに変換
  Future<Uint8List> loadImageBytes(String imagePath) async {
    ByteData data = await rootBundle.load(imagePath);
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  Future signUp(Uint8List? userImage) async {
    email = emailController.text;
    password = passwordController.text;
    name = nameController.text;
    group = groupController.text;
    grade = gradeController.text;
    String status = '未出席';

    if(grade == null || grade == ''){
      grade = 'B4';
    }

    if (email != null && password != null ) {
      //firebase authでユーザー作成
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      final user = userCredential.user;

      if (user != null) {
        final uid = user.uid;

        //FastAPIに追加
        //Postリクエストを送信するエンドポイントのURL
        var uri = Uri.parse('http://localhost:8000/users');
        String imagePath = 'assets/images/default.png'; //画像ファイルパス

        final request = http.MultipartRequest('POST', uri);
        if (userImage == null) {
          imageBytes = await loadImageBytes(imagePath);
        } else {
          imageBytes = await userImage;
        }

        Map<String, String> headers = {"Content-type": "multipart/form-data"};

        final file = http.MultipartFile.fromBytes('file', imageBytes!, filename: 'default.png');
        request.files.add(file);
        request.headers.addAll(headers);

        request.fields.addAll({
          'email': email!,
          'grade': grade!,
          'group': group!,
          'name': name!,
          'status': status,
          'firebase_user_id': uid,
        });


        final stream = await request.send();

        return await http.Response.fromStream(stream).then(
                (response) {
                 if (response.statusCode == 200) {
                   return response;
                 }
                 return Future.error(response);
        });

      }
    }
  }
}
