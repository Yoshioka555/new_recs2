import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MyModel extends ChangeNotifier {

  String email = '';
  String name = '';
  String group = '';
  String grade = '';
  String status = '';
  String imgURL = '';

  void fetchMyModel() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final uid = currentUser!.uid;

    var uri = Uri.parse('http://localhost:8000/users/$uid');

    // GETリクエストを送信
    var response = await http.get(uri);

    // レスポンスのステータスコードを確認
    if (response.statusCode == 200) {
      // レスポンスボディをUTF-8でデコード
      var responseBody = utf8.decode(response.bodyBytes);

      // JSONデータをデコード
      var responseData = jsonDecode(responseBody);

      // 必要なデータを取得
      email = responseData['email'];
      name = responseData['name'];
      group = responseData['group'];
      grade = responseData['grade'];
      status = responseData['status'];
      imgURL = responseData['bytes_data'];


      // 取得したデータを使用する
    } else {
      // リクエストが失敗した場合の処理
      print('リクエストが失敗しました: ${response.statusCode}');
    }

    notifyListeners();
  }

}