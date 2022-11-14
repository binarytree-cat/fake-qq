import 'dart:convert';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class small_world extends StatefulWidget {
  const small_world({Key? key}) : super(key: key);

  @override
  State<small_world> createState() => _small_worldState();
}

class _small_worldState extends State<small_world> {
  List<HistoryToday> _historyTodayData = [];

  @override
  void initState() {
    // 初始化时候，请求数据
    getHistoryToday().then((List<HistoryToday> datas) {
      setState(() {
        _historyTodayData.addAll(datas);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Card(
              margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
                side: BorderSide(
                  color: Colors.blue,
                  width: 3,
                ),
              ),
              child: Container(
                margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(
                  children: [
                    Text(
                      _historyTodayData[index].title.toString(),
                      style: TextStyle(fontSize: 20),
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      _historyTodayData[index].lsdate.toString(),
                      style: TextStyle(fontSize: 15),
                      softWrap: true,
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ));
        },
        itemCount: _historyTodayData.length,
      ),
    );
  }

  /// 通过 HTTP 公开接口获取 数据。
  Future<List<HistoryToday>> getHistoryToday() async {
    //获取 月份日期 时间
    String month = DateTime.now().month < 10 ? "0${DateTime.now().month.toString()}":DateTime.now().month.toString();
    String day = DateTime.now().day < 10 ? "0${DateTime.now().day.toString()}":DateTime.now().day.toString();

    String apiKey = '744cc18a73be0b692f8fbc512f98e121';
    String newsUrl =
        'http://api.tianapi.com/lishi/index?key=$apiKey&date=$month$day';

    // 获取响应体
    final response = await http.get(Uri.parse(newsUrl));

    // 对响应体转码后，使用 convert 将其转为 Map 对象。
    Utf8Decoder decode = const Utf8Decoder();
    Map<String, dynamic> result =
        jsonDecode(decode.convert(response.bodyBytes));

    // 将 json 格式的数据转为我们设置的对象并且返回
    List<HistoryToday> datas;

    datas = result['newslist']
        .map<HistoryToday>((item) => HistoryToday.fromJson(item))
        .toList();

    return datas;
  }
}

class HistoryToday {
  /// 标题
  String? title;

  /// 日期
  String? lsdate;

  HistoryToday({this.title, this.lsdate});

  factory HistoryToday.fromJson(Map<String, dynamic> json) {
    return HistoryToday(
      title: json['title'],
      lsdate: json['lsdate'],
    );
  }
}
