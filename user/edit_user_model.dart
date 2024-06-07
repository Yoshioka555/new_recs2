import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditMyPageModel extends ChangeNotifier {
  bool isLoading = false;

  String userId = '';
  int? id;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void fetchUser() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    userId = uid;
    var uri = Uri.parse('http://localhost:8000/user_id/$userId');
    var response = await http.get(uri);

    // レスポンスのステータスコードを確認
    if (response.statusCode == 200) {
      // レスポンスボディをUTF-8でデコード
      var responseBody = utf8.decode(response.bodyBytes);

      // JSONデータをデコード
      var responseData = jsonDecode(responseBody);

      // 必要なデータを取得
      id = responseData['id'];

      // 取得したデータを使用する
    } else {
      // リクエストが失敗した場合の処理
      print('リクエストが失敗しました: ${response.statusCode}');
    }

    notifyListeners();
  }

  //ユーザ情報更新
  Future update(String name, String group, String grade) async {

    if(name == ''){
      throw '名前が入力されていません。';
    }
    if(group == ''){
      throw 'グループが選択されていません。';
    }
    if(grade == ''){
      throw '学年が選択されていません。';
    }

    var uri = Uri.parse('http://localhost:8000/users/$id');

    // 送信するデータを作成
    Map<String, dynamic> data = {
      'name': name,
      'group': group,
      'grade': grade,
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

  Future updateImage(Uint8List? userImage) async {

    var uri = Uri.parse('http://localhost:8000/users/image/$id');
    final request = http.MultipartRequest('PATCH', uri);
    Map<String, String> headers = {"Content-type": "multipart/form-data"};
    final file = http.MultipartFile.fromBytes('file', userImage!, filename: 'update.png');
    request.files.add(file);
    request.headers.addAll(headers);
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