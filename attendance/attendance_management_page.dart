import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'attendance_management_model.dart';

class AttendanceManagementPage extends StatefulWidget {
  const AttendanceManagementPage({Key? key}) : super(key: key);

  @override
  State<AttendanceManagementPage> createState() => _AttendanceManagementPage();
}

class _AttendanceManagementPage extends State<AttendanceManagementPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider<AttendanceManagementModel>(
      create: (_) => AttendanceManagementModel()..fetchAttendanceManagement(),
      child: SingleChildScrollView(
        child: Consumer<AttendanceManagementModel>(builder: (context, model, child) {

          final List<Widget> netIndex = model.netUsers.map(
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
          ).toList();

          final List<Widget> webIndex = model.webUsers.map(
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
          ).toList();

          final List<Widget> gridIndex = model.gridUsers.map(
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
          ).toList();

          final List<Widget> teacherIndex = model.teacherUsers.map(
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
          ).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(4.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
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
                            ScaffoldMessenger.of(context).
                            showSnackBar(snackBar);
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
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
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
                            ScaffoldMessenger.of(context).
                            showSnackBar(snackBar);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: Colors.yellow,
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
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
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
                            ScaffoldMessenger.of(context).
                            showSnackBar(snackBar);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: Colors.grey,
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
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
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
                            ScaffoldMessenger.of(context).
                            showSnackBar(snackBar);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: Colors.red,
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
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
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
                            ScaffoldMessenger.of(context).
                            showSnackBar(snackBar);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: Colors.blue,
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
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.98,
                child: Container(
                  margin: const EdgeInsets.all(2.0),
                  child: Row(
                      children: [
                        Container(
                          width: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black45,
                              ),
                          ),
                          child: const Text('Net班'),
                        ),
                        Expanded(
                          child: Row(
                            children: netIndex,
                          ),
                        ),
                      ]
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.98,
                child: Container(
                  margin: const EdgeInsets.all(2.0),
                  child: Row(
                      children: [
                        Container(
                          width: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black45,
                              )
                          ),
                          child: const Text('Grid班'),
                        ),
                        Expanded(
                          child: Row(
                            children: gridIndex,
                          ),
                        ),
                      ]
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.98,
                child: Container(
                  margin: const EdgeInsets.all(2.0),
                  child: Row(
                      children: [
                        Container(
                          width: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black45,
                              )
                          ),
                          child: const Text('Web班'),
                        ),
                        Expanded(
                          child: Row(
                            children: webIndex,
                          ),
                        ),
                      ]
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.98,
                child: Container(
                  margin: const EdgeInsets.all(2.0),
                  child: Row(
                      children: [
                        Container(
                          width: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black45,
                              )
                          ),
                          child: const Text('教員'),
                        ),
                        Expanded(
                          child: Row(
                            children: teacherIndex,
                          ),
                        ),
                      ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }


  Color _attendanceColor(String text){
    if (text == '一時退席'){
      return Colors.yellow;
    }
    else if (text == '出席'){
      return Colors.green;
    }
    else if(text == '欠席'){
      return Colors.red;
    }
    else if(text == '帰宅'){
      return Colors.grey;
    }
    else {
      return Colors.blue;
    }
  }

}

