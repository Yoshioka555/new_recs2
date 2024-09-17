import 'package:flutter/material.dart';

import '../door_status/door_status_appbar.dart';
import '../gemini/gemini_chat_page.dart';
import '../header_footer_drawer/drawer.dart';
import 'attendance_create_page.dart';
import 'attendance_index_page_day.dart';
import 'attendance_index_page_month.dart';
import 'attendance_index_page_week.dart';
import 'attendance_management_page.dart';

class AttendanceHomePage extends StatefulWidget {
  const AttendanceHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<AttendanceHomePage> createState() => _AttendanceHomePageState();
}

class _AttendanceHomePageState extends State<AttendanceHomePage> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: const Icon(Icons.psychology_alt),
                onPressed: () async {
                  Navigator.push(
                    context,
                    //変更点
                    //GeminiPage()は削除しています
                    //遷移先がGeminiPage()になっているものは、全てGeminiChatPage()に Replace in Files...しています
                    MaterialPageRoute(builder: (context) => const GeminiChatPage()),
                  );
                },
              ),
            ),
          ],
          backgroundColor: Colors.blue[100],
          centerTitle: true,
          elevation: 0.0,
          title: const DoorStatusAppbar(),
          bottom: const TabBar(
            tabs: <Tab>[
              Tab(text: 'Member',),
              Tab(text: 'Month',),
              Tab(text: 'Week',),
              Tab(text: 'Day',),
            ],
          ),
        ),
        drawer: const UserDrawer(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue[200],
          onPressed: () async {
            //画面遷移
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateAttendancePage(),
                fullscreenDialog: true,
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
        body: const TabBarView(
          children: [
            AttendanceManagementPage(),
            AttendanceIndexPageMonth(),
            AttendanceIndexPageWeek(),
            AttendanceIndexPageDay(),
          ],
        ),
      ),
    );
  }
}
