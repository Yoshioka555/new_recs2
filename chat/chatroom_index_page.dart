import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../header_footer_drawer/drawer.dart';
import 'chatroom_index_model.dart';

class ChatRoomListPage extends StatefulWidget {
  const ChatRoomListPage({Key? key}) : super(key: key);

  @override
  State<ChatRoomListPage> createState() => _ChatRoomListPage();
}

class _ChatRoomListPage extends State<ChatRoomListPage> {

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
                    icon: const Icon(Icons.search),
                    onPressed: () async {
                      //サーチ
                    }
                ),
              ),
            ],
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            backgroundColor: Colors.orange,
            centerTitle: true,
            elevation: 0.0,
            title: const Text(
              'チャット',
              style: TextStyle(color: Colors.white),
            ),
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
              Text('aaa'),
              Text('bbb'),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () async {
              //ルーム追加
              /*
              await Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) {
                      return const AddRoomPage();
                    }),
              );

               */
            },
          ),
        ),
      ),
    );
  }
}


