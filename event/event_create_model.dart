import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class CreateEventModel extends ChangeNotifier {

  String? username;
  String? userId;
  int? id;
  String name = '';

  Future fetchUser() async {
    final user = FirebaseAuth.instance.currentUser;
    userId = user!.uid;
    var uri = Uri.parse('http://localhost:8000/user_name_id/$userId');
    var response = await http.get(uri);

    // レスポンスのステータスコードを確認
    if (response.statusCode == 200) {
      // レスポンスボディをUTF-8でデコード
      var responseBody = utf8.decode(response.bodyBytes);

      // JSONデータをデコード
      var responseData = jsonDecode(responseBody);

      // 必要なデータを取得
      id = responseData['id'];
      name = responseData['name'];

      // 取得したデータを使用する
    } else {
      // リクエストが失敗した場合の処理
      print('リクエストが失敗しました: ${response.statusCode}');
    }
    notifyListeners();
  }

  Future addEvent(String title, DateTime start, DateTime end, String unit, String description, bool mailSend) async {

    if (title =='') {
      throw 'タイトルが入力されていません。';
    }
    if (description == '') {
      throw '詳細が入力されていません。';
    }

    final url = Uri.parse('http://localhost:8000/events');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': title,
        'start': start.toIso8601String(),
        'end': end.toIso8601String(),
        'unit': unit,
        'description': description,
        'user_id': id,
        'mail_send': mailSend,
      }),

    );

    if (response.statusCode == 200) {
      // POSTリクエストが成功した場合
      final responseData = jsonDecode(response.body);
      print('Response data: $responseData');
    } else {
      // POSTリクエストが失敗した場合
      print('Request failed with status: ${response.statusCode}');
    }

    notifyListeners();
  }


}

