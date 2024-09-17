import 'package:flutter/material.dart';
import 'package:new_labmaid/gemini/gemini_chat_page.dart';
import '../door_status/door_status_appbar.dart';
import '../header_footer_drawer/drawer.dart';
import 'attendance_create_page_web.dart';
import 'attendance_home_page_web.dart';
import 'attendance_management_page_web.dart';

//新規作成
//WEB用の出席管理ページ

class AttendancePageWeb extends StatelessWidget {
  const AttendancePageWeb({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        //変更点
        //backgroundColor色の統一
        backgroundColor: Colors.blue[100],
        centerTitle: false,
        title: const DoorStatusAppbar(),
        //Gemini AI Page への遷移
        //仮でここに置いています
        actions: [
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
        //３つのウィジェットを並べている
        children: [
          //Web用の予定追加ページ
          const Expanded(child: CreateAttendancePageWeb()),
          //カレンダーは月表示のみ
          const Expanded(child: AttendanceHomePageWeb()),
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