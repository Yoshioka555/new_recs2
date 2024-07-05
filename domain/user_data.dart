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

class UserData {
  UserData({
    required this.id, required this.email, required this.group, required this.grade,
    required this.name, required this.status, required this.imgData, required this.firebaseUserId, required this.fileName,
  });

  final int id;
  final String email;
  final String group;
  final String grade;
  final String name;
  final String status;
  final String imgData;
  final String firebaseUserId;
  final String fileName;

  //JSONからオブジェクトを作成するファクトリメソッド
  factory UserData.fromJson(dynamic json) {
    return UserData(
      id: json['id'] as int,
      email: json['email'] as String,
      group: json['group'] as String,
      grade: json['grade'] as String,
      name: json['name'] as String,
      status: json['status'] as String,
      imgData: json['bytes_data'] as String,
      firebaseUserId: json['firebase_user_id'] as String,
      fileName: json['file_name'] as String,
    );
  }

}
