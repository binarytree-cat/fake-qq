import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../database/database.dart';

class ChangePasswordPage extends StatefulWidget {

  static const String routeName = '/ChangePasswordPageState';

  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _firstInput = TextEditingController();
  final TextEditingController _secondInput = TextEditingController();
  late QQUser nowUser;

  @override
  Widget build(BuildContext context) {
    nowUser = ModalRoute.of(context)!.settings.arguments as QQUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text("修改密码"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 150,
              height: 150,
              child: Image.asset(nowUser.imagePath!),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _firstInput,
                decoration: const InputDecoration(
                    hintText: '请输入密码', border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _secondInput,
                decoration: const InputDecoration(
                    hintText: '再次输入密码', border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialButton(
                color: Colors.blue[300],
                onPressed: () {
                  String first = _firstInput.text.toString();
                  String second = _secondInput.text.toString();

                  // 长度8到16 必须包含一个大（小）字母 必须包含一个数字
                  RegExp exp = RegExp(r"^.*(?=.{8,16})(?=.*[A-Za-z])(?=.*\d).*$");

                  if(first == second && exp.hasMatch(first)){
                    // 修改密码成功
                   _changePassWord(first);
                   Navigator.pop(context);
                  }
                  _firstInput.clear();
                  _secondInput.clear();
                },
                child: const Text('修改密码'),
              ),
            )
          ],
        ),
      ),
    );
  }
  void _changePassWord(String newPassword) async{
    // 连接数据库
    QQUserProvider qqUserProvider = QQUserProvider();
    await qqUserProvider
        .open(join(await getDatabasesPath(), 'user.db'));

    nowUser.password = newPassword;

    await qqUserProvider.update(nowUser);

    print("更新密码${nowUser.toMap()}");
  }
}
