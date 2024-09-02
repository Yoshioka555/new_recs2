import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'attendance_management_model.dart';

//変更点
//新規作成
//web用のページで右側に表示させる出席状況表示ウィジェット

class AttendanceManagementPageWeb extends StatefulWidget {
  const AttendanceManagementPageWeb({Key? key}) : super(key: key);

  @override
  State<AttendanceManagementPageWeb> createState() =>
      _AttendanceManagementPageWeb();
}

class _AttendanceManagementPageWeb extends State<AttendanceManagementPageWeb> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AttendanceManagementModel>(
      create: (_) => AttendanceManagementModel()..fetchAttendanceManagement(),
      child:
      Consumer<AttendanceManagementModel>(builder: (context, model, child) {
        final List<Widget> netIndex = model.netUsers
            .map(
              (user) => Expanded(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _attendanceColor(user.status),
                border: Border.all(
                  color: Colors.black45,
                ),
              ),
              child: FittedBox(child: Text(user.name)),
            ),
          ),
        )
            .toList();

        final List<Widget> webIndex = model.webUsers
            .map(
              (user) => Expanded(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _attendanceColor(user.status),
                border: Border.all(
                  color: Colors.black45,
                ),
              ),
              child: FittedBox(child: Text(user.name)),
            ),
          ),
        )
            .toList();

        final List<Widget> gridIndex = model.gridUsers
            .map(
              (user) => Expanded(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _attendanceColor(user.status),
                border: Border.all(
                  color: Colors.black45,
                ),
              ),
              child: FittedBox(child: Text(user.name)),
            ),
          ),
        )
            .toList();

        final List<Widget> teacherIndex = model.teacherUsers
            .map(
              (user) => Expanded(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _attendanceColor(user.status),
                border: Border.all(
                  color: Colors.black45,
                ),
              ),
              child: FittedBox(child: Text(user.name)),
            ),
          ),
        )
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 5.0,
                runSpacing: 5.0,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 30,
                    child: ElevatedButton(
                      onPressed: () async {
                        await model.attendanceUpdate('出席');
                        const snackBar = SnackBar(
                          backgroundColor: Colors.green,
                          content: Text(
                            "出席しました",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        );
                        //model.fetchAttendanceList();状態の更新 websocketで更新する
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green[400],
                      ),
                      child: const FittedBox(
                        child: Text(
                          '出席',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 30,
                    child: ElevatedButton(
                      onPressed: () async {
                        await model.attendanceUpdate('一時退席');
                        const snackBar = SnackBar(
                          backgroundColor: Colors.yellow,
                          content: Text(
                            "一時退席しました",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        );
                        //model.fetchAttendanceList();
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.yellow,
                      ),
                      child: const FittedBox(
                        child: Text(
                          '一時退席',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 30,
                    child: ElevatedButton(
                      onPressed: () async {
                        await model.attendanceUpdate('帰宅');
                        const snackBar = SnackBar(
                          backgroundColor: Colors.grey,
                          content: Text(
                            "帰宅しました",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        );
                        //model.fetchAttendanceList();
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.grey,
                      ),
                      child: const FittedBox(
                        child: Text(
                          '帰宅',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 30,
                    child: ElevatedButton(
                      onPressed: () async {
                        await model.attendanceUpdate('欠席');
                        const snackBar = SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                            "欠席しました",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        );
                        //model.fetchAttendanceList();
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                      ),
                      child: const FittedBox(
                        child: Text(
                          '欠席',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 30,
                    child: ElevatedButton(
                      onPressed: () async {
                        await model.attendanceUpdate('未出席');
                        const snackBar = SnackBar(
                          backgroundColor: Colors.blue,
                          content: Text(
                            "未出席になりました",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        );
                        //model.fetchAttendanceList();
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                      ),
                      child: const FittedBox(
                        child: Text(
                          '未出席',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(children: [
              Expanded(
                child: Container(
                  height: 110,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black45,
                    ),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Textの縦表示ができるかわからなかったので、Columnで縦に一文字ずつ並べています
                      Text(
                        'N',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        'e',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        't',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        '班',
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 110,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black45,
                      )),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'G',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        'r',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        'i',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        'd',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        '班',
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 110,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black45,
                      )),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'W',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        'e',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        'b',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        '班',
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 110,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black45,
                      )),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '教',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        '員',
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ],
        );
      }),
    );
  }

  Color _attendanceColor(String text) {
    if (text == '一時退席') {
      return Colors.yellow;
    } else if (text == '出席') {
      return Colors.green;
    } else if (text == '欠席') {
      return Colors.red;
    } else if (text == '帰宅') {
      return Colors.grey;
    } else {
      return Colors.blue;
    }
  }
}