import 'package:flutter/material.dart';
import 'package:labmaidfastapi/attendance/attendance_management_page_web.dart';
import '../gemini/gemini_page.dart';
import '../header_footer_drawer/drawer.dart';
import 'attendance_create_page_web.dart';
import 'attendance_index_page_month.dart';

//変更点
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
        backgroundColor: Colors.blue[100],
        centerTitle: false,
        title: const Text(
          "Create Attendance",
          style: TextStyle(
            color: Color(0xff626262),
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),

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
                  MaterialPageRoute(builder: (context) => const GeminiPage()),
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
          const Expanded(child: AttendanceIndexPageMonth()),
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