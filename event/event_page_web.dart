import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../attendance/attendance_management_page_web.dart';
import '../door_status/door_status_appbar.dart';
import '../gemini/gemini_chat_page.dart';
import '../header_footer_drawer/drawer.dart';
import 'event_create_page_web.dart';
import 'event_index_page_web.dart';

//新規作成
//Web用のイベント管理ページのUI

//変更点
//自分だけの Dart & Flutter 公式キャラクター Dashatar を作れるサイト
//ユーザアイコンをこれで作ってもらってもいいかもしれない
//Web版のAppBarの空白を埋めるためだけに入れてます
//Web版のEventPageのAppBarにのみ追加しています

//自分だけの Dart & Flutter 公式キャラクター Dash を作れるサイト
final Uri _dashPageUrl = Uri.parse('https://dashatar-dev.web.app/#/');

class EventPageWeb extends StatelessWidget {
  const EventPageWeb({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.purple[100],
        centerTitle: false,
        title: const DoorStatusAppbar(),
        //変更点
        //Iconの色設定を削除
        actions: [
          //変更点
          //自分だけの Dart & Flutter 公式キャラクター Dash を作れるサイトへ遷移
          IconButton(onPressed: () => _DashLaunchUrl(), icon: Icon(Icons.flutter_dash_outlined)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.psychology_alt),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GeminiChatPage()),
                );
              },
            ),
          ),
        ],
      ),
      drawer: const UserDrawer(),
      body: Row(
        children: [
          //Web用のイベント追加UI
          const Expanded(child: CreateEventPageWeb()),
          //Web用のカレンダーUI
          const Expanded(child: EventIndexPageWeb()),
          //出席状況の常時表示UI
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.1,
            child: const AttendanceManagementPageWeb(),
          ),
        ],
      ),
    );
  }
}

//変更点
//自分だけの Dart & Flutter 公式キャラクター Dash を作れるサイト
Future<void> _DashLaunchUrl() async {
  if (!await launchUrl(_dashPageUrl)) {
    throw Exception('Could not launch $_dashPageUrl');
  }
}