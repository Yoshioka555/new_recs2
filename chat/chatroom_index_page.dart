import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:new_labmaid/chat/private_chat_page.dart';
import 'package:provider/provider.dart';
import '../domain/chat_data.dart';
import '../door_status/door_status_appbar.dart';
import '../header_footer_drawer/drawer.dart';
import 'chatroom_index_model.dart';
import 'create_group_chat_room_page.dart';
import 'package:http/http.dart' as http;

import 'delete_group_chat_room_page.dart';
import 'group_chat_page.dart';

class ChatRoomListPage extends StatefulWidget {
  const ChatRoomListPage({Key? key}) : super(key: key);

  @override
  State<ChatRoomListPage> createState() => _ChatRoomListPage();
}

class _ChatRoomListPage extends State<ChatRoomListPage> {
  List<GroupChatRoomData> groupChatRoomList = [];

  Future getGroupChatRoomList() async {
    var uri = Uri.parse('http://localhost:8000/get_group_chat_rooms');

    // GETリクエストを送信
    var response = await http.get(uri);

    // レスポンスのステータスコードを確認
    if (response.statusCode == 200) {
      // レスポンスボディをUTF-8でデコード
      var responseBody = utf8.decode(response.bodyBytes);
      // JSONデータをデコード
      final List<dynamic> body = jsonDecode(responseBody);

      // 必要なデータを取得
      groupChatRoomList = body.map((dynamic json) => GroupChatRoomData.fromJson(json)).toList();

    } else {
      // リクエストが失敗した場合の処理
      print('リクエストが失敗しました: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: ChangeNotifierProvider<ChatRoomListModel>(
        create: (_) => ChatRoomListModel()..fetchChatRoomList(),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      //グループチャット削除ページへ遷移
                      await getGroupChatRoomList();
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) {
                              return GroupChatRoomDeletePage(groupChatRoomList: groupChatRoomList);
                            }
                        ),
                      );
                    }
                ),
              ),
            ],
            backgroundColor: Colors.orange,
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            centerTitle: false,
            elevation: 0.0,
            title: const DoorStatusAppbar(),
            bottom: const TabBar(
              tabs: <Tab>[
                Tab(text: '個人',),
                Tab(text: '参加中',),
                Tab(text: '未参加',),
              ],
            ),
          ),
          drawer: const UserDrawer(),
          body: TabBarView(
            children: [
              Consumer<ChatRoomListModel>(builder: (context, model, child){

                if(model.userData.isNotEmpty){
                  return Scrollbar(
                    child: ListView.builder(
                      itemCount: model.userData.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index){
                        return GestureDetector(
                          onTap: () async {
                            //個人チャットルーム遷移
                            await model.createOrGetPrivateChatRoom(model.userData[index].id);
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) {
                                    return PrivateChatPage(privateChatroomId: model.privateChatroomId!, userData: model.userData[index], myData: model.myData!);
                                  }
                              ),
                            );
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.black12),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey,
                                radius: 50,
                                backgroundImage: model.userData[index].imgData != '' ? Image.memory(
                                  base64Decode(model.userData[index].imgData),
                                  fit: BoxFit.cover,
                                  errorBuilder: (c, o, s) {
                                    return const Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    );
                                  },
                                ).image
                                    : const AssetImage('assets/images/default.png'),
                              ),
                              title: Text(model.userData[index].name),
                              subtitle: Text('${model.userData[index].group}　${model.userData[index].grade}　${model.userData[index].status}'),
                              trailing: const Icon(Icons.input),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                else {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  );
                }

              }),
              Consumer<ChatRoomListModel>(builder: (context, model, child){

                if(model.groupChatData.isNotEmpty){
                  return Scrollbar(
                    child: ListView.builder(
                      itemCount: model.groupChatData.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index){
                        return GestureDetector(
                          onTap: () async {
                            //グループチャットルーム遷移
                            await model.getGroupChatUsers(model.groupChatData[index].id);
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) {
                                    return GroupChatPage(groupChatRoomData: model.groupChatData[index], myData: model.myData!, groupUsers: model.groupChatUsers);
                                  }
                              ),
                            );
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.black12),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey,
                                radius: 50,
                                backgroundImage: model.groupChatData[index].imgData != '' ? Image.memory(
                                  base64Decode(model.groupChatData[index].imgData),
                                  fit: BoxFit.cover,
                                  errorBuilder: (c, o, s) {
                                    return const Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    );
                                  },
                                ).image
                                    : const AssetImage('assets/images/group_default.jpg'),
                              ),
                              title: Text(model.groupChatData[index].name),
                              trailing: const Icon(Icons.input),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                else {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  );
                }

              }),
              Consumer<ChatRoomListModel>(builder: (context, model, child){

                if(model.notGroupChatData.isNotEmpty){
                  return Scrollbar(
                    child: ListView.builder(
                      itemCount: model.notGroupChatData.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index){
                        return GestureDetector(
                          onTap: () async {
                            //グループチャットルーム遷移

                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.black12),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey,
                                radius: 50,
                                backgroundImage: model.notGroupChatData[index].imgData != '' ? Image.memory(
                                  base64Decode(model.notGroupChatData[index].imgData),
                                  fit: BoxFit.cover,
                                  errorBuilder: (c, o, s) {
                                    return const Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    );
                                  },
                                ).image
                                    : const AssetImage('assets/images/group_default.jpg'),
                              ),
                              title: Text(model.notGroupChatData[index].name),

                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                else {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  );
                }

              }),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () async {
              //ルーム追加
              await Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) {
                      return const AddRoomPage();
                    }),
              );
            },
          ),
        ),
      ),
    );
  }
}


