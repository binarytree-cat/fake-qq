import 'package:FakeQQ/database/database.dart';
import 'package:FakeQQ/pages/changepassword.dart';
import 'package:FakeQQ/pages/message.dart';
import 'package:FakeQQ/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'pages/homePage.dart';
import 'pages/loginPage.dart';
import '../database/database.dart';

void main() {
  runApp(MyApp());
}

late QQUser temp;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return     // 全局配置子树下的SmartRefresher,下面列举几个特别重要的属性
      RefreshConfiguration(
          headerBuilder: () => WaterDropHeader(),        // 配置默认头部指示器,假如你每个页面的头部指示器都一样的话,你需要设置这个
          footerBuilder:  () => ClassicFooter(),        // 配置默认底部指示器
          headerTriggerDistance: 80.0,        // 头部触发刷新的越界距离
          springDescription:SpringDescription(stiffness: 170, damping: 16, mass: 1.9),         // 自定义回弹动画,三个属性值意义请查询flutter api
          maxOverScrollExtent :100, //头部最大可以拖动的范围,如果发生冲出视图范围区域,请设置这个属性
          maxUnderScrollExtent:0, // 底部最大可以拖动的范围
          enableScrollWhenRefreshCompleted: true, //这个属性不兼容PageView和TabBarView,如果你特别需要TabBarView左右滑动,你需要把它设置为true
          enableLoadingWhenFailed : true, //在加载失败的状态下,用户仍然可以通过手势上拉来触发加载更多
          hideFooterWhenNotFull: false, // Viewport不满一屏时,禁用上拉加载更多功能
          enableBallisticLoad: true, // 可以通过惯性滑动触发加载更多
          child: MaterialApp(
            // TODO 路由控制
            routes: {
              HomePage.routeName: (context) =>  const HomePage(),
              MessagePage.routeName:(context) => const MessagePage(),
              RegisterPage.routeName:(context) => const RegisterPage(),
              ChangePasswordPage.routeName:(context) => const ChangePasswordPage(),
            },
            home: LoginPage(),
            theme: ThemeData(primarySwatch: Colors.blue),
          )
      );
  }
}


