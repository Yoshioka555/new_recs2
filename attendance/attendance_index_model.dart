import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../domain/attendance_data.dart';

class AttendanceIndexModel extends ChangeNotifier {

  List<AttendanceData> attendances = [];

  String? userId;
  int? id;

  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;  // disposeされたことを示すフラグを設定
    super.dispose();
  }


  void fetchAttendance() async {
    final user = FirebaseAuth.instance.currentUser;
    userId = user!.uid;

    var uri = Uri.parse('http://localhost:8000/attendances');

    // GETリクエストを送信
    var response = await http.get(uri);

    // レスポンスのステータスコードを確認
    if (response.statusCode == 200) {
      // レスポンスボディをUTF-8でデコード
      var responseBody = utf8.decode(response.bodyBytes);

      // JSONデータをデコード
      final List<dynamic> body = jsonDecode(responseBody);

      // 必要なデータを取得
      attendances = body.map((dynamic json) => AttendanceData.fromJson(json)).toList();

      // 取得したデータを使用する
    } else {
      // リクエストが失敗した場合の処理
      print('リクエストが失敗しました: ${response.statusCode}');
    }

    var uriUser = Uri.parse('http://localhost:8000/user_id/$userId');
    var responseUser = await http.get(uriUser);

    // レスポンスのステータスコードを確認
    if (responseUser.statusCode == 200) {
      // レスポンスボディをUTF-8でデコード
      var responseBody = utf8.decode(responseUser.bodyBytes);

      // JSONデータをデコード
      var responseData = jsonDecode(responseBody);

      // 必要なデータを取得
      id = responseData['id'];

      // 取得したデータを使用する
    } else {
      // リクエストが失敗した場合の処理
      print('リクエストが失敗しました: ${responseUser.statusCode}');
    }

    if (!_isDisposed) {
      notifyListeners();
    }
  }

}