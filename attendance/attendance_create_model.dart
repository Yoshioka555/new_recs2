import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CreateAttendanceModel extends ChangeNotifier {

  String? userId;
  String? email;
  int? id;
  String name = '';

  Future fetchUser() async {
    final user = FirebaseAuth.instance.currentUser;
    userId = user!.uid;
    email = user.email;
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

  Future addAttendance(String title, DateTime start, DateTime end, String description, bool mailSend, bool undecided) async {

    if (title =='') {
      throw 'タイトルが入力されていません。';
    }
    if (description == '') {
      throw '詳細が入力されていません。';
    }

    final url = Uri.parse('http://localhost:8000/attendances');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': title,
        'start': start.toIso8601String(),
        'end': end.toIso8601String(),
        'description': description,
        'user_id': id,
        'mail_send': mailSend,
        'undecided': undecided,
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

  Future sendEmail(String title, DateTime start, DateTime end, String description, bool undecided) async {
    Uri url = Uri.parse('http://localhost:8000/mail');
    final response = await http.post(url, body: {'name': name, 'subject': subject(title), 'from_email': email, 'text': textMessages(title,start,end,description, undecided)});

    if (response.statusCode == 200) {
      // POSTリクエストが成功した場合
      print('Response data: 200');
    } else {
      // POSTリクエストが失敗した場合
      print('Request failed with status: ${response.statusCode}');
    }
  }

  String textMessages(String title, DateTime start, DateTime end, String description, bool undecided) {
    DateTime currentDate = DateTime.now();
    if(title == '遅刻') {
      if (undecided == true) {
        return 'メール送信日：${DateFormat.yMMMd('ja')
            .format(currentDate)
            .toString()}(${DateFormat.E('ja').format(currentDate)})\n'
            '$title\n'
            '作成者：$name\n'
            'メールアドレス：${email!}\n\n'
            '$description\n'
            '到着予定時刻：未定\n';
      } else {
        return 'メール送信日：${DateFormat.yMMMd('ja')
            .format(currentDate)
            .toString()}(${DateFormat.E('ja').format(currentDate)})\n'
            '$title\n'
            '作成者：$name\n'
            'メールアドレス：${email!}\n\n'
            '$description\n'
            '到着予定時刻：${DateFormat.yMMMd('ja')
            .format(start)
            .toString()}(${DateFormat.E('ja').format(start)})ー${DateFormat.Hm(
            'ja').format(start)}\n';
      }
    } else if(title == '早退') {
        return 'メール送信日：${DateFormat.yMMMd('ja').format(currentDate).toString()}(${DateFormat.E('ja').format(currentDate)})\n'
          '$title\n'
          '作成者：$name\n'
          'メールアドレス：${email!}\n\n'
          '$description\n'
          '早退予定時刻：${DateFormat.yMMMd('ja').format(start).toString()}(${DateFormat.E('ja').format(start)})ー${DateFormat.Hm('ja').format(start)}\n';
    } else {
      return 'メール送信日：${DateFormat.yMMMd('ja').format(currentDate).toString()}(${DateFormat.E('ja').format(currentDate)})\n'
          '$title\n'
          '作成者：$name\n'
          'メールアドレス：${email!}\n\n'
          '$description\n'
          '開始時刻：${DateFormat.yMMMd('ja').format(start).toString()}(${DateFormat.E('ja').format(start)})ー${DateFormat.Hm('ja').format(start)}\n'
          '終了時刻：${DateFormat.yMMMd('ja').format(end).toString()}(${DateFormat.E('ja').format(end)})ー${DateFormat.Hm('ja').format(end)}\n';
    }
  }

  String subject(String title) {
    return '$name：$title';
  }

}
