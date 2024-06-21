class UserAttendanceData {
  UserAttendanceData({
    required this.id, required this.group, required this.name, required this.status,
  });

  final int id;
  final String group;
  final String name;
  final String status;

  //JSONからオブジェクトを作成するファクトリメソッド
  factory UserAttendanceData.fromJson(dynamic json) {
    return UserAttendanceData(
      id: json['id'] as int,
      name: json['name'] as String,
      group: json['group'] as String,
      status: json['status'] as String,
    );
  }
}
