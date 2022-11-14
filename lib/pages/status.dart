import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../entity/newDetail.dart';
import '../entity/news.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// 展示动态页面的内容
class status extends StatefulWidget {
  const status({Key? key}) : super(key: key);

  @override
  State<status> createState() => _statusState();
}

class _statusState extends State<status> {
  /// 新闻内容
  List<News> _datas = [];

  /// 是否取消和网页的连接
  bool _cancelConnection = false;

  /// pull_to_refresh 控制器
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final ScrollController _scrollController = ScrollController();

  bool showToTopBtn = false;

  /// 每次请求每页新闻的数量
  int number = 5;

  /// 每次请求的当前页数
  int page = 0;

  SharedPreferences? sharedPreferences;

  String? path;

  @override
  void initState() {
    initSharePreferences();

    // 初始化时候，请求数据
    page += 1;
    getNewsData()
        .then(((List<News> datas) {
          if (!_cancelConnection) {
            setState(() {
              _datas = datas;
            });
          }
        }))
        .catchError((e) {
          // 异常错误
          print('error : $e');
        })
        .whenComplete(() {
          // 请求完成
          print('News Request Complete!');
        })
        .timeout(Duration(seconds: 5))
        .catchError((timeOut) {
          // 设置 5 秒后超时，重新请求。
          print("time out! time : ${timeOut}");
          _cancelConnection = true;
        });

    _scrollController.addListener(() {
      // print(_scrollController.offset); //打印滚动位置
      // print("打印滚动位置"); //打印滚动位置
      if (_scrollController.offset < 100 && showToTopBtn) {
        setState(() {
          showToTopBtn = false;
        });
      } else if (_scrollController.offset >= 100 && showToTopBtn == false) {
        setState(() {
          showToTopBtn = true;
        });
      }
    });
  }

  /// 每次刷新就更新页面
  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  /// 每次请求就增加数据
  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if (mounted) {
      setState(() {
        page += 1;
        getNewsData().then((List<News> datas) {
          setState(() {
            _datas.addAll(datas);
          });
        });
      });
    }
    _refreshController.loadComplete();
  }

  void initSharePreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences?.setString("localImagePath", "image/temp_pic.jpg");
  }

  void getLocalImage() async {
    path = await sharedPreferences?.getString("localImagePath");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView.builder(
          controller: _scrollController,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              // 卡片
              color: Colors.grey[250],
              elevation: 5.0,
              child: Builder(
                builder: (context) => InkWell(
                  // 卡片被点击后的跳转事件
                  onTap: () {
                    print("tile:" + _datas[index].title.toString());
                    print("tile:" + _datas[index].picUrl.toString());
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NewsDetail(
                            url: getWebUrl(_datas[index].url.toString()),
                            title: _datas[index].title.toString())));
                  },

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 图片
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                        // child: index < 5 && path != null ? Image.asset(path!) :  getImageFromUrl(_datas[index].picUrl.toString()),
                        child: index < 5
                            ? CachedNetworkImage(
                                imageUrl: _datas[index].picUrl.toString(),
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              )
                            : getImageFromUrl(_datas[index].picUrl.toString()),
                      ),
                      // 标题
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          _datas[index].title.toString(),
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      // 概述
                      Padding(
                        padding: _datas[index].description.toString().isEmpty
                            ? EdgeInsets.all(10.0)
                            : EdgeInsets.only(
                                left: 10.0, right: 10.0, bottom: 10.0),
                        child: Text(
                          _datas[index].description as String,
                          style: TextStyle(fontSize: 12.0),
                        ),
                      ),
                      // 时间
                      Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Text(
                          '时间：${_datas[index].ctime}',
                          style: TextStyle(fontSize: 12.0),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
          itemCount: _datas.length,
        ),
      ),
      floatingActionButton: !showToTopBtn
          ? null
          : FloatingActionButton(
              child: Icon(Icons.arrow_upward),
              onPressed: () {
                //返回到顶部时执行动画
                _scrollController.animateTo(.0,
                    duration: Duration(milliseconds: 200), curve: Curves.ease);
              }),
    );
  }

  /// 处理无效图片
  Image? getImageFromUrl(String url) {
    // TODO 处理无效图片
    if (url == "" || !url.contains('http') || !url.contains('https')) {
      return null;
    } else {
      return Image.network(url);
    }
  }

  /// 通过 HTTP 公开接口获取 新闻数据。
  Future<List<News>> getNewsData() async {
    String apiKey = '744cc18a73be0b692f8fbc512f98e121';
    String newsUrl =
        'http://api.tianapi.com/generalnews/index?key=${apiKey}&num=${number.toString()}&page=${page.toString()}';
    // 获取响应体
    final response = await http.get(Uri.parse(newsUrl));

    // 对响应体转码后，使用 convert 将其转为 Map 对象。
    Utf8Decoder decode = new Utf8Decoder();
    Map<String, dynamic> result =
        jsonDecode(decode.convert(response.bodyBytes));

    // 将 json 格式的数据转为我们设置的 News 对象并且返回
    List<News> datas;
    datas =
        result['newslist'].map<News>((item) => News.fromJson(item)).toList();

    getLocalImage();

    return datas;
  }

  /// 卸载
  @override
  dispose() {
    super.dispose();
    _scrollController.dispose();
    _refreshController.dispose();
  }

  String getWebUrl(String string) {
    if (!string.startsWith("http")) {
      string = "https:" + string;
    }
    return string;
  }
}
