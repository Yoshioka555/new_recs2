import 'package:flutter/material.dart';
import '../attendance/attendance_management_page_web.dart';
import '../gemini/gemini_page.dart';
import '../header_footer_drawer/drawer.dart';
import 'event_create_page_web.dart';
import 'event_index_page_web.dart';

//変更点
//新規作成
//Web用のイベント管理ページのUI

class EventPageWeb extends StatelessWidget {
  const EventPageWeb({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green[100],
        centerTitle: false,
        title: const Text(
          "Create Event",
          style: TextStyle(
            color: Color(0xff626262),
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
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