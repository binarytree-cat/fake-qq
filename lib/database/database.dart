import 'package:sqflite/sqflite.dart';

const String tableName = 'user';

/// 数据库存储的用户类
class QQUser {
  int? userId;
  String? username;
  String? nickname;
  String? password;
  String? imagePath;

  QQUser.create(
      this.userId, this.username, this.nickname, this.password, this.imagePath);

  QQUser();

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'userId': userId,
      'username': username,
      'nickname': nickname,
      'password': password,
      'imagePath': imagePath
    };
    return map;
  }

  QQUser.fromMap(Map<String, dynamic> map) {
    userId = map['userId'];
    username = map['username'];
    nickname = map['nickname'];
    password = map['password'];
    imagePath = map['imagePath'];
  }
}

class QQUserProvider {
  Database? db;

  Future open(String path) async {
    // 数据库创建语句
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
      create table user(
      userId integer primary key autoincrement,
      username text,
      nickname text,
      password text,
      imagePath text
      )
      ''');
    });
  }

  /// 插入一个用户
  Future<QQUser> insert(QQUser qqUser) async {
    qqUser.userId = await db!.insert(tableName, qqUser.toMap());
    return qqUser;
  }

  /// 根据 id 查询用户全部信息
  Future<QQUser> selectById(int id) async {
    List<Map<String, dynamic>> maps = await db!.query(tableName,
        columns: ['userId', 'username', 'nickname', 'password', 'imagePath'],
        where: 'userId = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return QQUser.fromMap(maps.first);
    }
    return QQUser();
  }

  /// 根据用户的 username 查询这个用户的信息
  Future<QQUser> selectByUsername(String username) async {
    List<Map<String, dynamic>> maps = await db!.query(tableName,
        columns: ['userId', 'username', 'nickname', 'password', 'imagePath'],
        where: 'username = ?',
        whereArgs: [username]);
    if (maps.isNotEmpty) {
      return QQUser.fromMap(maps.first);
    }
    return QQUser();
  }

  /// 查询所有用户
  Future<List<QQUser>> selectAll() async {
    List<Map<String, dynamic>> maps = await db!.query(tableName,
        columns: ['userId', 'username', 'nickname', 'password', 'imagePath']);

    List<QQUser> res = [];
    for (var element in maps) {
      res.add(QQUser.fromMap(element));
    }

    return res;
  }

  /// 根据 id 删除一个用户的信息
  Future<int> delete(int id) async {
    return await db!.delete(tableName, where: 'userId = ?', whereArgs: [id]);
  }

  /// 根据 id 修改一个用户的信息
  Future<int> update(QQUser qqUser) async {
    return await db!.update(tableName, qqUser.toMap(),
        where: 'userId = ?', whereArgs: [qqUser.userId]);
  }

  /// 关闭数据库
  Future close() async => db!.close();
}
