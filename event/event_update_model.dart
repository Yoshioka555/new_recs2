import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class UpdateEventModel extends ChangeNotifier {

  Future fetchUser() async {

    notifyListeners();
  }



  Future updateEvent(int id, String title, DateTime start, DateTime end, String unit, String description, bool mailSend) async {

    if (title =='') {
      throw 'タイトルが入力されていません。';
    }
    if (description == '') {
      throw '詳細が入力されていません。';
    }

    var uri = Uri.parse('http://localhost:8000/events/$id');

    // 送信するデータを作成
    Map<String, dynamic> data = {
      'title': title,
      'description': description,
      'unit': unit,
      'mail_send': mailSend,
      'start': start.toIso8601String(),
      'end': end.toIso8601String(),
      // 他のキーと値を追加
    };

    // リクエストヘッダーを設定
    Map<String, String> headers = {
      'Content-Type': 'application/json', // JSON形式のデータを送信する場合
      // 他のヘッダーを必要に応じて追加
    };

    try {
      // HTTP POSTリクエストを送信
      final response = await http.patch(
        uri,
        headers: headers,
        body: json.encode(data), // データをJSON形式にエンコード
      );

      // レスポンスをログに出力（デバッグ用）
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

    } catch (e) {
      // エラーハンドリング
      print('Error: $e');
    }

    notifyListeners();
  }

  Future deleteEvent(int id) async {
    var uri = Uri.parse('http://localhost:8000/events/$id');

    final response = await http.delete(uri);

    if (response.statusCode == 200) {
      // 成功時の処理
      print('Event deleted successfully');
    } else {
      // エラー時の処理
      print('Failed to delete the event');
    }
    notifyListeners();
  }


}

