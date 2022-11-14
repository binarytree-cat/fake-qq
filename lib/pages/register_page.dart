import 'package:FakeQQ/pages/select_image_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../database/database.dart';

class RegisterPage extends StatefulWidget {
  static const routeName = '/RegisterPage';

  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _registerNickname = TextEditingController();
  final TextEditingController _registerUsername = TextEditingController();
  final TextEditingController _registerPassword = TextEditingController();

  String nowImagePath = 'assets/images/default_profile_photo.png';

  // 跳转
  Future<void> _imageSelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) =>  SelectImagePage()),
    );

    setState(() {
      nowImagePath = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('注册账号'),
      ),
      // resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: 150,
                  height: 150,
                  child: Image.asset(nowImagePath)),
              MaterialButton(
                  color: Colors.blue[300],
                  child: const Text("更换头像"),
                  onPressed: (){
                    setState(() {
                      _imageSelection(context);
                    });
                  }),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _registerNickname,
                  decoration: const InputDecoration(
                      hintText: '请输入昵称', border: OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _registerUsername,
                  decoration: const InputDecoration(
                      hintText: '请输入账号', border: OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _registerPassword,
                  decoration: const InputDecoration(
                      hintText: '请输入密码', border: OutlineInputBorder()),
                ),
              ),
              MaterialButton(
                color: Colors.blue[300],
                onPressed: () async {
                  String name = _registerUsername.text.toString();
                  String pw = _registerPassword.text.toString();
                  String nickname = _registerNickname.text.toString();
                  String imagePath = nowImagePath;

                  /// 删除数据库，测试使用
                  // await deleteDatabase(join(await getDatabasesPath(), 'user.db'));

                  // 连接数据库
                  QQUserProvider qqUserProvider = QQUserProvider();
                  await qqUserProvider
                      .open(join(await getDatabasesPath(), 'user.db'));

                  QQUser temp = await qqUserProvider.selectByUsername(name);

                  if (temp.username == null) {
                    // 不重名检测成功
                    qqUserProvider.insert(
                        QQUser.create(null, name, nickname, pw, imagePath));
                    List<QQUser> temp = await qqUserProvider.selectAll();

                    Navigator.pop(context);
                  } else {
                    print("注册失败");
                    // 失败清除所有输入框内容
                    _registerNickname.clear();
                    _registerPassword.clear();
                    _registerUsername.clear();
                  }
                },
                child: const Text('注册'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
