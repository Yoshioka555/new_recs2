import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../domain/chat_data.dart';
import '../domain/user_data.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatRoomListModel extends ChangeNotifier {
  
  List<UserData> userData = [];
  List<GroupChatUserData> groupChatUsers = [];
  List<GroupChatRoomData> groupChatData = [];
  List<GroupChatRoomData> notGroupChatData = [];
  int? privateChatroomId;
  UserData? myData;

  void fetchChatRoomList() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    // MyUser情報を取得
    var uri = Uri.parse('http://localhost:8000/users/${currentUser!.uid}');

    // GETリクエストを送信
    var response = await http.get(uri);

    // レスポンスのステータスコードを確認
    if (response.statusCode == 200) {
      // レスポンスボディをUTF-8でデコード
      var responseBody = utf8.decode(response.bodyBytes);

      // JSONデータをデコード
      var responseData = jsonDecode(responseBody);

      // 必要なデータを取得
      myData = UserData.fromJson(responseData);

      // 取得したデータを使用する
    } else {
      // リクエストが失敗した場合の処理
      print('リクエストが失敗しました: ${response.statusCode}');
    }

    // 個人チャットのユーザを取得する
    var url = Uri.parse('http://localhost:8000/chat_users/${currentUser.uid}');

    // GETリクエストを送信
    var responseGet = await http.get(url);

    // レスポンスのステータスコードを確認
    if (responseGet.statusCode == 200) {
      // レスポンスボディをUTF-8でデコード
      var responseBody = utf8.decode(responseGet.bodyBytes);

      // JSONデータをデコード
      final List<dynamic> body = jsonDecode(responseBody);

      // 必要なデータを取得
      userData = body.map((dynamic json) => UserData.fromJson(json)).toList();

      // 取得したデータを使用する
    } else {
      // リクエストが失敗した場合の処理
      print('リクエストが失敗しました: ${responseGet.statusCode}');
    }

    // 参加中のグループチャットの一覧を取得
    var uriEntryGroup = Uri.parse('http://localhost:8000/get_entry_group_chat_room/${myData!.id}');
    // GETリクエストを送信
    var responseEntryGroup = await http.get(uriEntryGroup);

    // レスポンスのステータスコードを確認
    if (responseEntryGroup.statusCode == 200) {
      // レスポンスボディをUTF-8でデコード
      var responseBody = utf8.decode(responseEntryGroup.bodyBytes);

      // JSONデータをデコード
      final List<dynamic> body = jsonDecode(responseBody);

      //　必要なデータを取得
      groupChatData = body.map((dynamic json) => GroupChatRoomData.fromJson(json)).toList();

    } else {
      // リクエストが失敗した場合の処理
      print('リクエストが失敗しました: ${responseEntryGroup.statusCode}');
    }

    // 参加していないグループチャット一覧を取得する
    var uriNotEntryGroup = Uri.parse('http://localhost:8000/get_not_entry_group_chat_room/${myData!.id}');
    // GETリクエストを送信
    var responseNotEntryGroup = await http.get(uriNotEntryGroup);

    // レスポンスのステータスコードを確認
    if (responseNotEntryGroup.statusCode == 200) {
      // レスポンスボディをUTF-8でデコード
      var responseBody = utf8.decode(responseNotEntryGroup.bodyBytes);
      // JSONデータをデコード
      final List<dynamic> body = jsonDecode(responseBody);

      // 必要なデータを取得
      notGroupChatData = body.map((dynamic json) => GroupChatRoomData.fromJson(json)).toList();

    } else {
      // リクエストが失敗した場合の処理
      print('リクエストが失敗しました: ${responseNotEntryGroup.statusCode}');
    }

    notifyListeners();
  }
  
  Future createOrGetPrivateChatRoom(int userId) async {
    var uri = Uri.parse('http://localhost:8000/private_chat_room/${myData!.id}/$userId');

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

  Future getGroupChatUsers(int groupChatRoomId) async {
    var uri = Uri.parse('http://localhost:8000/group_chat_room_users/$groupChatRoomId');

    // GETリクエストを送信
    var response = await http.get(uri);

    // レスポンスのステータスコードを確認
    if (response.statusCode == 200) {
      // レスポンスボディをUTF-8でデコード
      var responseBody = utf8.decode(response.bodyBytes);
      // JSONデータをデコード
      final List<dynamic> body = jsonDecode(responseBody);

      // 必要なデータを取得
      groupChatUsers = body.map((dynamic json) => GroupChatUserData.fromJson(json)).toList();

    } else {
      // リクエストが失敗した場合の処理
      print('リクエストが失敗しました: ${response.statusCode}');
    }
    notifyListeners();
  }

}