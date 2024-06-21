import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../domain/user_data.dart';


class AttendanceManagementModel extends ChangeNotifier {

  List<UserAttendanceData> webUsers = [];
  List<UserAttendanceData> gridUsers = [];
  List<UserAttendanceData> netUsers = [];
  List<UserAttendanceData> teacherUsers = [];

  String? firebaseUserId;
  int? userId;

  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;  // disposeされたことを示すフラグを設定
    super.dispose();
  }


  void fetchAttendanceManagement() async {
    final user = FirebaseAuth.instance.currentUser;
    firebaseUserId = user!.uid;

    var uri = Uri.parse('http://localhost:8000/users_attendance');

    // GETリクエストを送信
    var response = await http.get(uri);

    // レスポンスのステータスコードを確認
    if (response.statusCode == 200) {
      // レスポンスボディをUTF-8でデコード
      var responseBody = utf8.decode(response.bodyBytes);

      // JSONデータをデコード
      final List<dynamic> body = jsonDecode(responseBody);

      // 必要なデータを取得
      final users = body.map((dynamic json) => UserAttendanceData.fromJson(json)).toList();

      for (var user in users) {
        if (user.group == 'Web班') {
          webUsers.add(user);
        } else if (user.group == 'Grid班') {
          gridUsers.add(user);
        } else if (user.group == 'Network班') {
          netUsers.add(user);
        } else {
          teacherUsers.add(user);
        }
      }

      // 取得したデータを使用する
    } else {
      // リクエストが失敗した場合の処理
      print('リクエストが失敗しました: ${response.statusCode}');
    }

    var uriUser = Uri.parse('http://localhost:8000/user_id/$firebaseUserId');
    var responseUser = await http.get(uriUser);

    // レスポンスのステータスコードを確認
    if (responseUser.statusCode == 200) {
      // レスポンスボディをUTF-8でデコード
      var responseBody = utf8.decode(responseUser.bodyBytes);

      // JSONデータをデコード
      var responseData = jsonDecode(responseBody);

      // 必要なデータを取得
      userId = responseData['id'];

      // 取得したデータを使用する
    } else {
      // リクエストが失敗した場合の処理
      print('リクエストが失敗しました: ${responseUser.statusCode}');
    }

    if (!_isDisposed) {
      notifyListeners();
    }
  }

  Future attendanceUpdate(String updateStatus) async {
    var uri = Uri.parse('http://localhost:8000/update_user_status/$userId');

    // 送信するデータを作成
    Map<String, dynamic> data = {
      'status': updateStatus,
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

}