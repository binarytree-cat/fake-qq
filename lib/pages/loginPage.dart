import 'package:FakeQQ/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/database.dart';
import 'homePage.dart';
import '../entity/user.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  SharedPreferences? sharedPreferences;
  bool checkboxSelected = false;
  bool rememberPassword = false;
  bool passwordHide = true;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initSqlAndSharePreferences();
  } // This widget is the root of your application.

  void initSqlAndSharePreferences() async {
    // 连接数据库
    QQUserProvider qqUserProvider = QQUserProvider();
    await qqUserProvider.open(join(await getDatabasesPath(), 'user.db'));

    qqUserProvider.insert(QQUser.create(null, '5120205830', '测试账号', '123456',
        'assets/images/default_profile_photo.png'));

    sharedPreferences = await SharedPreferences.getInstance();
  }

  void existUsername(String val) async {
    bool? temp = await sharedPreferences?.containsKey(val);
    if (temp == true) {
      String? pwd = await sharedPreferences?.getString(val);
      if (pwd != null && rememberPassword == true) {
        passwordController.text = pwd;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // 设置软键盘不弹出，解决 bottom overflowed 问题
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Flutter QQ'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image(
              image: AssetImage('image/qq.png'),
              width: 200,
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Column(
                children: [
                  TextField(
                    onChanged: (val) {
                      setState(() {
                        existUsername(val);
                      });
                    },
                    key: Key('input username'),
                    controller: usernameController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      contentPadding: const EdgeInsets.all(5.0),
                      labelText: '请输入你的QQ号',
                    ),
                    textAlign: TextAlign.center,
                    autofocus: true,
                    // 限制长度
                    maxLength: 10,
                    inputFormatters: [
                      // 只允许输入0-9的数字
                      FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                    ],
                  ),
                  TextField(
                    key: Key("input password"),
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(5.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      labelText: '请输入你的密码',
                      suffixIcon: IconButton(
                        icon: Icon(passwordHide
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            passwordHide = !passwordHide;
                          });
                        },
                      ),
                    ),
                    maxLength: 10,
                    autofocus: true,
                    obscureText: passwordHide,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Row(
                  children: [
                    Checkbox(
                        value: checkboxSelected,
                        onChanged: (value) {
                          setState(() {
                            checkboxSelected = value!;
                          });
                        }),
                    const Text("已经阅读和同意服务协议！"),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                        value: rememberPassword,
                        onChanged: (value) {
                          setState(() {
                            rememberPassword = value!;
                          });
                        }),
                    const Text("记住密码"),
                  ],
                )
              ],
            ),
            MaterialButton(
              key: Key("button"),
              // 设置 ICON 为右箭头
              onPressed: () async {
                // 登录事件
                String username = usernameController.text.toString();
                String password = passwordController.text.toString();

                /// 连接数据库
                QQUserProvider qqUserProvider = QQUserProvider();
                await qqUserProvider
                    .open(join(await getDatabasesPath(), 'user.db'));

                QQUser loginUser =
                    await qqUserProvider.selectByUsername(username);

                if (loginUser.password == password) {
                  // 登录成功
                  usernameController.clear();
                  passwordController.clear();

                  print("用户登录成功:${loginUser.toMap()}");

                  if (rememberPassword) {
                    // 记住密码
                    await sharedPreferences?.setString(username, password);
                    var temp = await sharedPreferences?.getKeys();
                  }

                  Navigator.pushNamed(context, HomePage.routeName,
                      arguments: loginUser);

                } else {
                  // 登录失败
                  usernameController.clear();
                  passwordController.clear();
                }
              },
              color: Colors.blue.shade200,
              // 设置 ICON 为圆形
              shape: CircleBorder(),
              height: 100,
              // 设置 ICON 为右箭头
              child: Icon(Icons.arrow_forward),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('更多选项'),
                  GestureDetector(
                      child: const Text('新用户注册'),
                      onTap: () {
                        // 新用户注册
                        setState(() {
                          Navigator.pushNamed(context, RegisterPage.routeName);
                        });
                      }),
                  const Text('手机号登录'),
                ],
              ),
            ),
          ],
        ));
  }
}
