import 'package:FakeQQ/pages/small_world.dart';
import 'package:FakeQQ/pages/status.dart';
import 'package:flutter/material.dart';
import '../database/database.dart';
import '../entity/user.dart';
import 'changepassword.dart';
import 'message.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/HomePageState';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late QQUser currentUser;

  final List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(
      backgroundColor: Colors.blue,
      icon: Icon(Icons.message),
      label: '消息',
    ),
    BottomNavigationBarItem(
      backgroundColor: Colors.blue,
      icon: Icon(Icons.adjust),
      label: '历史今天',
    ),
    BottomNavigationBarItem(
      backgroundColor: Colors.blue,
      icon: Icon(Icons.account_circle),
      label: '联系人',
    ),
    BottomNavigationBarItem(
      backgroundColor: Colors.blue,
      icon: Icon(Icons.refresh),
      label: '动态',
    )
  ];

  int currentIndex = 0;

  final pages = [message(), small_world(), contacts(), status()];

  @override
  Widget build(BuildContext context) {
    currentUser = ModalRoute.of(context)!.settings.arguments as QQUser;

    return Scaffold(
      appBar: AppBar(
        leading: getLeadingBuilder(currentUser),
        title: Row(children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text("${currentUser.nickname}"),
                padding: const EdgeInsets.only(bottom: 1),
              ),
              Row(
                children: [
                  // TODO 设置主页的状态
                  Icon(Icons.computer, size: 15),
                  Text(
                    "正在工作中",
                    style: TextStyle(fontSize: 14),
                  )
                ],
              )
            ],
          ))
        ]),
        titleSpacing: 10,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, ChangePasswordPage.routeName,
                    arguments: currentUser);
              },
              icon: const Icon(Icons.change_circle)),
          PopupMenuButton(
              icon: const Icon(Icons.account_circle),
              itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                      child: const Text('退出登录'),
                      onTap: () {
                        setState(() {
                          Navigator.pop(context);
                        });
                      },
                    )
                  ]),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('创建群聊'),
                value: 1,
                onTap: () {
                  // TODO 创建群聊 被点击
                },
              ),
              PopupMenuItem(
                child: Text('加好友/群'),
                value: 2,
                onTap: () {
                  // TODO 加好友/群 被点击
                },
              ),
            ],
            child: Container(
              margin: EdgeInsets.all(5),
              child: Icon(Icons.add),
            ),
          )
        ],
      ),
      drawer: getDraw(),
      bottomNavigationBar: BottomNavigationBar(
        // cha
        items: bottomItems,
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          changePage(index);
        },
      ),
      body: pages[currentIndex],
    );
  }

  /// 侧边栏的用户详情
  Widget getDraw() {
    return Drawer(
      width: 411,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Row(
                          children: [Icon(Icons.calendar_today), Text("今日打卡")],
                        ),
                      ),
                      Icon(Icons.close)
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                    backgroundImage: AssetImage(
                                        currentUser.imagePath.toString()))
                              ],
                            ),
                          ))
                    ],
                  )
                ],
              )),
          ListTile(
            leading: Icon(Icons.message),
            title: Text('直播'),
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('会员'),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('钱包'),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('个性装扮'),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('情侣空间'),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('王卡'),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('收藏'),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('收藏'),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('相册'),
          ),
        ],
      ),
    );
  }

  /// appbar 的开头部分
  Builder getLeadingBuilder(QQUser user) {
    return Builder(builder: (BuildContext context) {
      return GestureDetector(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: CircleAvatar(
            backgroundImage: AssetImage(user.imagePath.toString()),
          ),
        ),
        onTap: () {
          setState(() {
            // 点击打开侧边栏
            Scaffold.of(context).openDrawer();
          });
        },
      );
    });
  }

  /// 切换页面函数
  void changePage(int index) {
    if (index != currentIndex) {
      setState(() {
        currentIndex = index;
      });
    }
  }
}

class message extends StatefulWidget {
  @override
  State<message> createState() => _messageState();
}

class _messageState extends State<message> {
  late BuildContext _buildContext;

  ListView getListViews() {
    // TODO 处理聊天界面的用户
    List chatUsers = [];

    for (int i = 1; i < 15; i++) {
      chatUsers.add(ChatUser(
          '测试聊天角色$i', 'assets/images/QQ图片20221018135935.png', '这是测试聊天记录'));
    }

    List<ListTile> listTiles = [];
    for (var value in chatUsers) {
      listTiles.add(getListTileByChatUser(value));
    }

    return ListView(
      children: listTiles,
    );
  }

  /// 返回一个装载了 ChatUser 的 ListTile, 聊天目录的每一个项目
  ListTile getListTileByChatUser(ChatUser chatUser) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(chatUser.imagePath),
        radius: 35,
      ),
      subtitle: Text(chatUser.lastMessage),
      title: Text(chatUser.name),
      trailing: Icon(Icons.keyboard_arrow_right),
      isThreeLine: false,
      dense: false,
      contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      enabled: true,
      onTap: () {
        // TODO 聊天用户被点击
        Navigator.pushNamed(_buildContext, MessagePage.routeName,
            arguments: chatUser);
      },
      onLongPress: () {
        //TODO 聊天用户被长按
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _buildContext = context;
    return Scaffold(
      body: getListViews(),
    );
  }
}

class contacts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('contacts');
  }
}
