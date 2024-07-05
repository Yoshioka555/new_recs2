import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../domain/user_data.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatRoomListModel extends ChangeNotifier {
  
  List<UserData> userData = [];
  int? myId;
  int? privateChatroomId;
  UserData? myData;

  void fetchChatRoomList() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    var url = Uri.parse('http://localhost:8000/user_id/${currentUser!.uid}');
    var myIdResponse = await http.get(url);
    // レスポンスのステータスコードを確認
    if (myIdResponse.statusCode == 200) {
      // レスポンスボディをUTF-8でデコード
      var responseBody = utf8.decode(myIdResponse.bodyBytes);

      // JSONデータをデコード
      var responseData = jsonDecode(responseBody);

      // 必要なデータを取得
      myId = responseData['id'];

      // 取得したデータを使用する
    } else {
      // リクエストが失敗した場合の処理
      print('リクエストが失敗しました: ${myIdResponse.statusCode}');
    }


    var uri = Uri.parse('http://localhost:8000/chat_users/${currentUser.uid}');

    // GETリクエストを送信
    var response = await http.get(uri);

    // レスポンスのステータスコードを確認
    if (response.statusCode == 200) {
      // レスポンスボディをUTF-8でデコード
      var responseBody = utf8.decode(response.bodyBytes);

      // JSONデータをデコード
      final List<dynamic> body = jsonDecode(responseBody);

      // 必要なデータを取得
      userData = body.map((dynamic json) => UserData.fromJson(json)).toList();

      // 取得したデータを使用する
    } else {
      // リクエストが失敗した場合の処理
      print('リクエストが失敗しました: ${response.statusCode}');
    }

    notifyListeners();
  }
  
  Future createOrGetPrivateChatRoom(int userId) async {
    var uri = Uri.parse('http://localhost:8000/private_chat_room/$myId/$userId');

    // GETリクエストを送信
    var response = await http.get(uri);

    // レスポンスのステータスコードを確認
    if (response.statusCode == 200) {
    // レスポンスボディをUTF-8でデコード
    var responseBody = utf8.decode(response.bodyBytes);

    // JSONデータをデコード
    var responseData = jsonDecode(responseBody);

    // 必要なデータを取得
    privateChatroomId = responseData['id'];

    // 取得したデータを使用する
    } else {
    // リクエストが失敗した場合の処理
    print('リクエストが失敗しました: ${response.statusCode}');
    }
    notifyListeners();
  }

}